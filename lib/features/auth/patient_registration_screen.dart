import 'dart:convert';
import 'package:bayleaf_flutter/core/config.dart'; // AppConfig.apiBaseUrl
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

// NEW: enum + selection screen requires a UserType (not String)
import 'package:bayleaf_flutter/models/user_type.dart';
import 'package:bayleaf_flutter/features/patients/patient_selection_screen.dart';

class PatientRegistrationScreen extends StatefulWidget {
  /// Comes from RoleDefinitionScreen as: 'patient' | 'family' | 'caregiver'
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

  // Pref keys (aligned with LoginScreen)
  static const _kAuthToken = 'authToken';
  static const _kRefreshToken = 'refreshToken';
  static const _kSavedEmail = 'savedEmail';
  static const _kSavedPassword = 'savedPassword';
  static const _kUserType = 'user_type';
  static const _kUserId = 'user_id';
  static const _kPatientPid = 'patient_pid';

  String get _roleRaw => (widget.selectedRole ?? 'patient').toLowerCase();

  /// Maps screen roles to backend user types/endpoints
  /// 'patient'   -> patient flow
  /// 'family'    -> relative flow
  /// 'caregiver' -> professional flow
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
    required String roleNormalized, // 'patient' | 'relative' | 'professional'
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? birthDateIso, // only for patient
  }) async {
    if (roleNormalized == 'patient') {
      // Patient registration via your service
      await _patientService.registerPatient(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        birthDate: birthDateIso!,
      );
      return;
    }

    // professional -> /api/professionals/register/
    // relative     -> /api/patients/relatives/register/
    final path = roleNormalized == 'professional'
        ? '/api/professionals/register/'
        : '/api/patients/relatives/register/';

    final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
    final payload = <String, dynamic>{
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
      // Try to extract backend error message
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

    String userTypeStr = 'patient'; // safe default
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
      } catch (_) {
        // keep defaults; we'll still navigate
      }
    }

    // persist identity (keep these lines)
    await prefs.setString(_kUserType, userTypeStr);
    if (userId != null) await prefs.setInt(_kUserId, userId!);
    if (patientPid != null) await prefs.setString(_kPatientPid, patientPid!);

    if (!mounted) return;

    // Convert to enum for PatientSelectionScreen
    final ut = userTypeFromString(userTypeStr);

    // route by user type
    if (ut == UserType.professional || ut == UserType.relative) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => PatientSelectionScreen(userType: ut),
        ),
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
      setState(() => _error = AppLocalizations.of(context)!.acceptTermsOfUse);
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
          setState(() =>
              _error = AppLocalizations.of(context)!.invalidBirthDateFormat);
          return;
        }
        birthDateIso = '${parts[2]}-${parts[1]}-${parts[0]}';
      }

      final first = _firstNameController.text.trim();
      final last = _lastNameController.text.trim();
      final email = _emailController.text.trim();
      final pass = _passwordController.text;

      // 1) Register appropriate role
      await _registerForRole(
        roleNormalized: role,
        firstName: first,
        lastName: last,
        email: email,
        password: pass,
        birthDateIso: birthDateIso,
      );

      // 2) Login and persist tokens
      await _loginPersistTokens(email: email, password: pass);

      // 3) Fetch user type + route
      await _fetchPersistUserTypeAndRoute();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                  children: [
                    // Brand icon
                    Image.asset(
                      'assets/images/cuidadora_icon.png',
                      height: 80,
                      width: 80,
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      loc.registrationTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // First Name
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: loc.firstName,
                        prefixIcon: const Icon(Icons.person),
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
                          (value == null || value.isEmpty)
                              ? loc.enterFirstName
                              : null,
                    ),

                    const SizedBox(height: 12),

                    // Last Name
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: loc.lastName,
                        prefixIcon: const Icon(Icons.person_outline),
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
                          (value == null || value.isEmpty)
                              ? loc.enterLastName
                              : null,
                    ),

                    const SizedBox(height: 12),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
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
                          (value == null || value.isEmpty)
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

                    const SizedBox(height: 12),

                    // Birth Date (only visible/validated for patient)
                    if (isPatient)
                      TextFormField(
                        controller: _birthDateController,
                        inputFormatters: [_birthDateFormatter],
                        decoration: InputDecoration(
                          labelText: loc.birthDate,
                          prefixIcon: const Icon(Icons.cake),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (!isPatient) return null;
                          return (value == null || value.isEmpty)
                              ? loc.enterBirthDate
                              : null;
                        },
                      ),

                    // Terms of Use
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox.adaptive(
                          value: _acceptedTerms,
                          onChanged: (v) =>
                              setState(() => _acceptedTerms = v ?? false),
                          activeColor: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
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
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () {
                                  // TODO: push terms screen or open URL
                                },
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

                    // Register button
                    const SizedBox(height: 16),
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
                        onPressed:
                            _isLoading || !_acceptedTerms ? null : _handleRegister,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
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

                    // Back
                    const SizedBox(height: 16),
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
