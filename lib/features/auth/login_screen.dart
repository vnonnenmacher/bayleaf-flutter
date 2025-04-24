import 'package:flutter/material.dart';
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
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      print("Login success! Token: ${data['token']}");
      // TODO: Navigate to dashboard
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: true,
    body: Stack(
      children: [
        // Background color
        Container(
          color: const Color(0xFFE3F2FD),
          width: double.infinity,
          height: double.infinity,
        ),

        // 🔹 Centered form block
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 120), // spacer for logo + title

                // 🔐 Form fields
                if (_error != null)
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 8),
                TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: null, // 👈 disables autofill suggestion bar
                decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                ),
                enableSuggestions: false,
                autocorrect: false,
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Login"),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 🔝 Logo + title positioned just above the centered form
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 260),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/bayleaf_logo.png',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to Bayleaf',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


}