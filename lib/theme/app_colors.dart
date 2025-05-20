import 'package:flutter/material.dart';

class AppColors {
  // ✅ Branding
  static const Color primary = Color(0xFF4F9D69);      // 🍃 Eucalyptus green
  static const Color primaryLight = Color(0xFFD6ECE2); // 🌿 Soft mint for backgrounds and AppBar
  static const Color accent = Color(0xFF89C2D9);       // 💧 Calm blue for links or secondary actions

  // ✅ Greys
  static const Color greyLight = Color(0xFFF2F4F6);
  static const Color greyMedium = Color(0xFF9E9E9E);
  static const Color greyDark = Color(0xFF3E3E3E);

  // ✅ Text Colors
  static const Color textPrimary = Color(0xFF2B2B2B);     // Near-black, good for dark-on-light
  static const Color textSecondary = Color(0xFF5F5F5F);   // Muted secondary text
  static const Color textInverse = Colors.white;

  // ✅ Status
  static const Color success = Color(0xFF6FBF73);   // Gentle green
  static const Color warning = Color(0xFFFFB74D);   // Muted amber
  static const Color error = Color(0xFFE57373);     // Soft red

  // ✅ Backgrounds
  static const Color background = Color(0xFFF8FBF9); // 🧘 Light mint
  static const Color card = Color(0xFFF0F4F1);       // Subtle eucalyptus tint

  // ✅ AppBar
  static const Color appBarBackground = primaryLight;  // Matches header background
  static const Color appBarTitle = primary;            // Title text color
  static const Color appBarIcon = Color(0xFF4F9D69);   // Consistent with branding

  // ✅ Misc
  static const Color divider = Color(0xFFE0E0E0);

  // New
  static const Color softRed = Color(0xFFFFCDD2);
  static const Color redText = Color(0xFFD32F2F);

}
