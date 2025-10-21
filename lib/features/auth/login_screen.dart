// lib/features/auth/login_screen.dart
import 'package:bayleaf_flutter/core/config.dart';
import 'package:bayleaf_flutter/services/auth_service.dart'; // for checkBackendHealth()
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_page.dart';
import '../../theme/app_colors.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';

// NEW imports for routing based on enum and patient selection screen
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

  // SharedPreferences keys (keep consistent across app)
  static const _kAuthToken = 'authToken';
  static const _kRefreshToken = 'refreshToken';
  static const _kSavedEmail = 'savedEmail';
  static const _kSavedPassword = 'savedPassword';
  static const _kUserType = 'user_type';        // stored as String: 'patient'|'professional'|'relative'
  static const _kUserId = 'user_id';            // stored as int
  static const _kPatientPid = 'patient_pid';    // stored as String (uuid)

  @override
  void initState() {
    super.initState();
    _loadSavedCreds();
  }

  Future<void> _loadSavedCreds() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString(_kSavedEmail);
    final savedPassword = prefs.getString(_kSavedPassword);
    if (savedEmail != null) _emailController.text = savedEmail;
    if (savedPassword != null) _passwordController.text = savedPassword;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

      // 1) Login (unauthenticated request)
      final loginRes = await Dio().post(
        '${AppConfig.apiBaseUrl}/api/users/login/',
        data: {'email': email, 'password': password},
      );

      final accessToken = loginRes.data['access'] as String?;
      final refreshToken = loginRes.data['refresh'] as String?;
      if (accessToken == null || refreshToken == null) {
        throw Exception('Invalid token payload.');
      }

      // 2) Persist tokens + saved creds
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kAuthToken, accessToken);
      await prefs.setString(_kRefreshToken, refreshToken);
      await prefs.setString(_kSavedEmail, email);
      await prefs.setString(_kSavedPassword, password);

      // 3) Fetch user type/ids (authorized request)
      String userTypeStr = 'patient'; // safe default
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
      } catch (_) {
        // If this fails, we still proceed with default patient routing below
      }

      // 4) Persist identity — YES, keep these lines exactly (your question)
      await prefs.setString(_kUserType, userTypeStr);
      if (userId != null) await prefs.setInt(_kUserId, userId!);
      if (patientPid != null) await prefs.setString(_kPatientPid, patientPid!);

      // 5) Route by enum (PatientSelectionScreen expects UserType, not String)
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
      // Prefer backend-provided error when available
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
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/cuidadora_icon.png',
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      loc.welcome,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: loc.email,
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? loc.enterEmail
                              : null,
                    ),

                    const SizedBox(height: 12),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: loc.password,
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) =>
                          (value == null || value.length < 6)
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
                            borderRadius: BorderRadius.circular(8),
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

                    const SizedBox(height: 24),

                    // Back
                    TextButton(
                      onPressed: () => Navigator.pop(context),
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
