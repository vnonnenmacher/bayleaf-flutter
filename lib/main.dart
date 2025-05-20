import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'features/auth/login_screen.dart';
import 'features/home/home_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const BayleafApp());
}

class BayleafApp extends StatelessWidget {
  const BayleafApp({super.key});

  Future<bool> _attemptAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final email = prefs.getString('savedEmail');
    final password = prefs.getString('savedPassword');

    // If we already have a token, try verifying it (optional)
    if (token != null && token.isNotEmpty) {
      try {
        await Dio().get(
          'http://10.0.2.2:8000/api/patients/retrieve/', // 🔁 replace with a real protected endpoint
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        return true;
      } catch (e) {
        print('Stored token invalid or backend offline: $e');
      }
    }

    // If stored credentials exist, try login again
    if (email != null && password != null) {
      try {
        final response = await AuthService().login(email, password);
        await prefs.setString('authToken', response['access']);
        await prefs.setString('refreshToken', response['refresh']);
        print("Auto-login succeeded for $email");
        return true;
      } catch (e) {
        print("Auto-login failed: $e");
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bayleaf',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _attemptAutoLogin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return snapshot.data! ? const HomePage() : const LoginScreen();
        },
      ),
    );
  }
}
