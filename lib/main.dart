import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_page.dart';

void main() {
  runApp(const BayleafApp());
}

class BayleafApp extends StatelessWidget {
  const BayleafApp({super.key});

  Future<bool> _checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bayleaf',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkLoggedIn(),
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
