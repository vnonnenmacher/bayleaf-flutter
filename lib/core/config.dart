import 'package:bayleaf_flutter/features/appointments/appointments_screen.dart';
import 'package:bayleaf_flutter/features/doctors/doctos_screen.dart';
import 'package:bayleaf_flutter/features/exams/exams_screen.dart';
import 'package:bayleaf_flutter/features/medications/medications_screen.dart';
// import 'package:bayleaf_flutter/features/timeline/timeline_screen.dart';
import 'package:bayleaf_flutter/features/ai_agent/ai_agent_screen.dart'; // <- Make sure to use the correct path
import 'package:flutter/material.dart';

class MenuScreenConfig {
  final String label;
  final IconData icon;
  final Widget Function() screenBuilder; // use builder for lazy instantiation
  final String route;
  final bool enabled;

  const MenuScreenConfig({
    required this.label,
    required this.icon,
    required this.screenBuilder,
    required this.route,
    this.enabled = true,
  });
}

class AppConfig {
  static const String apiBaseUrl = 'http://10.0.2.2:8000/';
  // static const String apiBaseUrl = 'http://10.0.2.2:8000/';

  // Add your screens here (order = nav order)
  static final List<MenuScreenConfig> menuScreens = [
    // MenuScreenConfig(
    //   label: 'Timeline',
    //   icon: Icons.timeline,
    //   screenBuilder: () => const TimelineScreen(),
    //   route: '/timeline',
    // ),
    MenuScreenConfig(
      label: 'Bayleaf',
      icon: Icons.eco_sharp,
      screenBuilder: () => const AiAgentScreen(),
      route: '/ai-agent',
    ),
    MenuScreenConfig(
      label: 'Medications',
      icon: Icons.medication_liquid,
      screenBuilder: () => const MedicationsScreen(),
      route: '/medications',
    ),
    MenuScreenConfig(
      label: 'Appointments',
      icon: Icons.calendar_today,
      screenBuilder: () => const AppointmentsScreen(),
      route: '/appointments',
    ),
    MenuScreenConfig(
      label: 'Exams',
      icon: Icons.description,
      screenBuilder: () => const ExamsScreen(),
      route: '/exams',
      enabled: true, // Toggle this to false to hide
    ),
    MenuScreenConfig(
      label: 'Doctors',
      icon: Icons.medical_services,
      screenBuilder: () => const DoctorsScreen(),
      route: '/doctors',
      enabled: true,
    ),
    // You can add more screens or set enabled: false to hide them
  ];
}
