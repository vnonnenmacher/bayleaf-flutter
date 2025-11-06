import 'package:bayleaf_flutter/features/ai_agent/dora_screen.dart';
import 'package:bayleaf_flutter/features/appointments/appointments_screen.dart';
import 'package:bayleaf_flutter/features/doctors/doctos_screen.dart';
import 'package:bayleaf_flutter/features/exams/exams_screen.dart';
import 'package:bayleaf_flutter/features/medications/medications_screen.dart';
// import 'package:bayleaf_flutter/features/timeline/timeline_screen.dart';
import 'package:bayleaf_flutter/features/ai_agent/dora_screen.dart'; // <- Make sure to use the correct path
import 'package:bayleaf_flutter/features/orientations/orientations_screen.dart';
import 'package:bayleaf_flutter/features/treatment/my_treatment_screen.dart';
import 'package:flutter/material.dart';

class MenuScreenConfig {
  final String labelKey;
  final IconData icon;
  final Widget Function() screenBuilder;
  final String route;
  final bool enabled;

  const MenuScreenConfig({
    required this.labelKey,
    required this.icon,
    required this.screenBuilder,
    required this.route,
    this.enabled = true,
  });
}

class AppConfig {
  static const String apiBaseUrl = 'https://bayleaf.nonnenmacher.tech';
  // static const String apiBaseUrl = 'http://10.0.2.2:8000/';

  // Add your screens here (order = nav order)
  static final List<MenuScreenConfig> menuScreens = [
    MenuScreenConfig(
      labelKey: 'menuBayleaf',
      icon: Icons.support_agent,
      screenBuilder: () => const DoraScreen(),
      route: '/ai-agent',
    ),
    MenuScreenConfig(
      labelKey: 'menuTreatment',
      icon: Icons.medication_liquid,
      screenBuilder: () => const MyTreatmentScreen(),
      route: '/treatment',
    ),
    /* MenuScreenConfig(
      labelKey: 'menuAppointments',
      icon: Icons.calendar_today,
      screenBuilder: () => const AppointmentsScreen(),
      route: '/appointments',
    ),
    MenuScreenConfig(
      labelKey: 'menuExams',
      icon: Icons.description,
      screenBuilder: () => const ExamsScreen(),
      route: '/exams',
    ),*/
    MenuScreenConfig(
      labelKey: 'menuOrientations',
      icon: Icons.medical_services,
      screenBuilder: () => const OrientationsScreen(),
      route: '/orientations',
    ),
  ];
}
