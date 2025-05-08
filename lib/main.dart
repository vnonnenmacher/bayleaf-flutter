import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_page.dart'; // You already have a HomePage
import 'features/auth/patient_registration_screen.dart';

void main() {
  runApp(const BayleafApp());
}

class BayleafApp extends StatelessWidget {
  const BayleafApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const PatientRegistrationScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Bayleaf',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}