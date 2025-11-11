import 'package:bayleaf_flutter/core/config.dart';
import 'package:bayleaf_flutter/features/auth/welcome_dora_screen.dart';
import 'package:bayleaf_flutter/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_page.dart';
import '../../theme/app_colors.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';
import 'package:bayleaf_flutter/models/user_type.dart';
import 'package:bayleaf_flutter/features/patients/patient_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  static const _kAuthToken = 'authToken';
  static const _kRefreshToken = 'refreshToken';
  static const _kSavedEmail = 'savedEmail';
  static const _kSavedPassword = 'savedPassword';
  static const _kUserType = 'user_type';
  static const _kUserId = 'user_id';
  static const _kPatientPid = 'patient_pid';

  @override
  void initState() {
    super.initState();
    _loadSavedCreds();
  }

  Future<void> _loadSavedCreds() async {
    final prefs = await SharedPreferences.getInstance();
    _emailController.text = prefs.getString(_kSavedEmail) ?? '';
    _passwordController.text = prefs.getString(_kSavedPassword) ?? '';
  }

  Future<void> _handleLogin() async {
    final healthy = await checkBackendHealth();
    if (!healthy) {
      setState(() {
        _error = AppLocalizations.of(context)!.systemUnavailable;
      });
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final loginRes = await Dio().post(
        '${AppConfig.apiBaseUrl}/api/users/login/',
        data: {'email': email, 'password': password},
      );

      final accessToken = loginRes.data['access'] as String?;
      final refreshToken = loginRes.data['refresh'] as String?;
      if (accessToken == null || refreshToken == null) {
        throw Exception('Invalid token payload.');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kAuthToken, accessToken);
      await prefs.setString(_kRefreshToken, refreshToken);
      await prefs.setString(_kSavedEmail, email);
      await prefs.setString(_kSavedPassword, password);

      String userTypeStr = 'patient';
      int? userId;
      String? patientPid;

      try {
        final authed = Dio(BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          headers: {'Authorization': 'Bearer $accessToken'},
        ));
        final typeRes = await authed.get('/api/users/me/type/');
        final data = typeRes.data as Map<String, dynamic>;
        userTypeStr = (data['user_type'] as String?) ?? 'patient';
        final ids = (data['ids'] as Map?) ?? {};
        userId = ids['user_id'] as int?;
        patientPid = ids['patient_pid'] as String?;
      } catch (_) {}

      await prefs.setString(_kUserType, userTypeStr);
      if (userId != null) await prefs.setInt(_kUserId, userId!);
      if (patientPid != null) await prefs.setString(_kPatientPid, patientPid!);

      if (!mounted) return;
      final ut = userTypeFromString(userTypeStr);

      if (ut == UserType.professional || ut == UserType.relative) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => PatientSelectionScreen(userType: ut)),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      }
    } on DioException catch (e) {
      final backendMsg = e.response?.data is Map
          ? (e.response?.data['detail'] as String?)
          : null;
      setState(() {
        _error = backendMsg ?? AppLocalizations.of(context)!.loginFailed;
      });
    } catch (_) {
      setState(() {
        _error = AppLocalizations.of(context)!.loginFailed;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.primary.withOpacity(0.8)),
      labelText: label,
      labelStyle: TextStyle(
        color: AppColors.textSecondary.withOpacity(0.8),
        fontSize: 15,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            BorderSide(color: AppColors.primary.withOpacity(0.25), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryLight, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Image.asset(
                      'assets/images/cuidadora_icon.png',
                      height: 90,
                      width: 90,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      loc.welcome,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 28),

                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration:
                          _inputDecoration(loc.email, Icons.email_outlined),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? loc.enterEmail : null,
                    ),
                    const SizedBox(height: 14),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _inputDecoration(loc.password, Icons.lock_outline),
                      validator: (v) => (v == null || v.length < 6)
                          ? loc.minPasswordLength
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                loc.login,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const WelcomeDoraScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        loc.back,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
