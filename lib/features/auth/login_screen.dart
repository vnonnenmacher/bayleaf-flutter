import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';

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

  final _authService = AuthService();

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    print("Login button pressed");

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      print("Login success! Data: $data");

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      print("Login error: $e");
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFD0E8F2), // Slightly deeper blue background
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
                  const Text(
                    'Welcome to Bayleaf',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700, // Slightly bolder
                      color: Color(0xFF2E7D32), // Dark green for hierarchy
                    ),
                  ),

                  const SizedBox(height: 32),

                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),

                  // 🔐 Email Field
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                        value!.isEmpty ? 'Enter your email' : null,
                  ),

                  // 🔒 Password Field
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                      ),
                    ),
                    validator: (value) =>
                        value!.length < 6 ? 'Minimum 6 characters' : null,
                  ),

                  const SizedBox(height: 24),

                  // 🔵 Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF2E7D32), // Slightly deeper green
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 6, // Slightly stronger shadow
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  // 🔵 Register Link
                  const SizedBox(height: 24), // Slightly more spacing for better tap area
                  TextButton(
                    onPressed: () {
                      context.go('/register');
                    },
                    child: const Text(
                      "Don't have an account? Register here",
                      style: TextStyle(
                        fontSize: 16,
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
