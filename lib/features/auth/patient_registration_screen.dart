import 'dart:convert';
import 'package:bayleaf_flutter/core/config.dart';
import 'package:bayleaf_flutter/features/home/home_page.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';
import 'package:bayleaf_flutter/theme/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/patient_service.dart';
import '../../services/auth_service.dart';
import 'package:bayleaf_flutter/models/user_type.dart';
import 'package:bayleaf_flutter/features/patients/patient_selection_screen.dart';

class PatientRegistrationScreen extends StatefulWidget {
  final String? selectedRole;
  const PatientRegistrationScreen({super.key, this.selectedRole});

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();

  final _birthDateFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final _patientService = PatientService();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _acceptedTerms = false;
  String? _error;

  static const _kAuthToken = 'authToken';
  static const _kRefreshToken = 'refreshToken';
  static const _kSavedEmail = 'savedEmail';
  static const _kSavedPassword = 'savedPassword';
  static const _kUserType = 'user_type';
  static const _kUserId = 'user_id';
  static const _kPatientPid = 'patient_pid';

  String get _roleRaw => (widget.selectedRole ?? 'patient').toLowerCase();
  String get _normalizedRole {
    switch (_roleRaw) {
      case 'family':
        return 'relative';
      case 'caregiver':
        return 'professional';
      default:
        return 'patient';
    }
  }

  Future<void> _registerForRole({
    required String roleNormalized,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? birthDateIso,
  }) async {
    if (roleNormalized == 'patient') {
      await _patientService.registerPatient(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        birthDate: birthDateIso!,
      );
      return;
    }

    final path = roleNormalized == 'professional'
        ? '/api/professionals/register/'
        : '/api/patients/relatives/register/';
    final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');

    final payload = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
    };

    final resp = await http.post(
      uri,
      headers: const {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(payload),
    );

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      try {
        final body = jsonDecode(resp.body);
        final detail = (body is Map && body["detail"] is String)
            ? body["detail"] as String
            : resp.body;
        throw Exception(detail);
      } catch (_) {
        throw Exception(resp.body);
      }
    }
  }

  Future<void> _loginPersistTokens({
    required String email,
    required String password,
  }) async {
    final tokens = await _authService.login(email, password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAuthToken, tokens['access'] as String);
    await prefs.setString(_kRefreshToken, tokens['refresh'] as String);
    await prefs.setString(_kSavedEmail, email);
    await prefs.setString(_kSavedPassword, password);
  }

  Future<void> _fetchPersistUserTypeAndRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final access = prefs.getString(_kAuthToken);

    String userTypeStr = 'patient';
    int? userId;
    String? patientPid;

    if (access != null && access.isNotEmpty) {
      final authedDio = Dio(BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        headers: {'Authorization': 'Bearer $access'},
      ));
      try {
        final r = await authedDio.get('/api/users/me/type/');
        final data = r.data as Map<String, dynamic>;
        userTypeStr = (data['user_type'] as String?) ?? 'patient';
        final ids = (data['ids'] as Map?) ?? {};
        userId = ids['user_id'] as int?;
        patientPid = ids['patient_pid'] as String?;
      } catch (_) {}
    }

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
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      setState(() =>
          _error = AppLocalizations.of(context)!.acceptTermsOfUse);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final role = _normalizedRole;
      String? birthDateIso;
      if (role == 'patient') {
        final parts = _birthDateController.text.split('/');
        if (parts.length != 3) {
          setState(() => _error =
              AppLocalizations.of(context)!.invalidBirthDateFormat);
          return;
        }
        birthDateIso = '${parts[2]}-${parts[1]}-${parts[0]}';
      }

      final first = _firstNameController.text.trim();
      final last = _lastNameController.text.trim();
      final email = _emailController.text.trim();
      final pass = _passwordController.text;

      await _registerForRole(
        roleNormalized: role,
        firstName: first,
        lastName: last,
        email: email,
        password: pass,
        birthDateIso: birthDateIso,
      );

      await _loginPersistTokens(email: email, password: pass);
      await _fetchPersistUserTypeAndRoute();
    } catch (e) {
      setState(() => _error = e.toString());
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
    final isPatient = _normalizedRole == 'patient';

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
                      height: 80,
                      width: 80,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      loc.registrationTitle,
                      textAlign: TextAlign.center,
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

                    TextFormField(
                      controller: _firstNameController,
                      decoration: _inputDecoration(loc.firstName, Icons.person),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? loc.enterFirstName : null,
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _lastNameController,
                      decoration: _inputDecoration(
                          loc.lastName, Icons.person_outline),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? loc.enterLastName : null,
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          _inputDecoration(loc.email, Icons.email_outlined),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? loc.enterEmail : null,
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _inputDecoration(loc.password, Icons.lock),
                      validator: (v) => (v == null || v.length < 6)
                          ? loc.minPasswordLength
                          : null,
                    ),
                    const SizedBox(height: 14),

                    if (isPatient)
                      TextFormField(
                        controller: _birthDateController,
                        inputFormatters: [_birthDateFormatter],
                        decoration:
                            _inputDecoration(loc.birthDate, Icons.cake_outlined),
                        validator: (v) => (v == null || v.isEmpty)
                            ? loc.enterBirthDate
                            : null,
                      ),

                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox.adaptive(
                          value: _acceptedTerms,
                          onChanged: (v) =>
                              setState(() => _acceptedTerms = v ?? false),
                          activeColor: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Wrap(
                            children: [
                              Text(
                                loc.acceptTermsOfUse,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  loc.viewTerms,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _acceptedTerms
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _isLoading ? null : _handleRegister,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                loc.register,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 18),
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
