import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../services/patient_service.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState
    extends State<PatientRegistrationScreen> {
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

  bool _isLoading = false;
  String? _error;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final parts = _birthDateController.text.split('/');
      if (parts.length != 3) {
        setState(() => _error = AppLocalizations.of(context)!.invalidBirthDateFormat);
        return;
      }
      final formattedDate =
          '${parts[2]}-${parts[1]}-${parts[0]}'; // YYYY-MM-DD

      final patientData = await _patientService.registerPatient(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        birthDate: formattedDate,
      );

      print("Patient registered and logged in: $patientData");

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        color: const Color(0xFFD0E8F2),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔵 Logo
                  Image.asset(
                    'assets/images/bayleaf_logo.png',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 16),

                  // 🔵 Title
                  Text(
                    loc.registrationTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
                  ),

                  const SizedBox(height: 32),

                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),

                  // 🔰 First Name
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: loc.firstName,
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? loc.enterFirstName : null,
                  ),

                  // 🔰 Last Name
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: loc.lastName,
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? loc.enterLastName : null,
                  ),

                  // ✉️ Email
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: loc.email,
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? loc.enterEmail : null,
                  ),

                  // 🔒 Password
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: loc.password,
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                      ),
                    ),
                    validator: (value) => value!.length < 6
                        ? loc.minPasswordLength
                        : null,
                  ),

                  // 🎂 Birth Date
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _birthDateController,
                    inputFormatters: [_birthDateFormatter],
                    decoration: InputDecoration(
                      labelText: loc.birthDate,
                      prefixIcon: const Icon(Icons.cake),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? loc.enterBirthDate : null,
                  ),

                  // 🔘 Button
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 6,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _isLoading ? null : _handleRegister,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
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

                  // 🔙 Back to login
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      loc.backToLogin,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
