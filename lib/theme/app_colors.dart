import 'package:flutter/material.dart';

class AppColors {
  // ✅ Branding (unchanged keys)
  static const Color primary = Color(0xFF4F9D69);      // 🍃 Eucalyptus green
  static const Color primaryLight = Color(0xFFD6ECE2); // 🌿 Soft mint for backgrounds and AppBar
  static const Color accent = Color(0xFF89C2D9);       // 💧 Calm blue for links or secondary actions

  // ✅ Secondary Color (MUST remain)
  static const Color secondary = Color(0xFF89C2D9);    // 💧 Calm blue (matches accent)

  // ✅ Greys (unchanged keys)
  static const Color greyLight = Color(0xFFF2F4F6);
  static const Color greyMedium = Color(0xFF9E9E9E);
  static const Color greyDark = Color(0xFF3E3E3E);

  // ✅ Text Colors (unchanged keys)
  static const Color textPrimary = Color(0xFF2B2B2B);
  static const Color textSecondary = Color(0xFF5F5F5F);
  static const Color textInverse = Colors.white;

  // ✅ Status (base tones kept for backwards compatibility)
  static const Color success = Color(0xFF6FBF73);
  static const Color warning = Color(0xFFFFB74D);
  static const Color error   = Color(0xFFE57373);

  // ➕ NEW: Darker status colors for legible text on light surfaces
  static const Color successDark = Color(0xFF388E3C);
  static const Color warningDark = Color(0xFFF57C00);
  static const Color errorDark   = Color(0xFFD32F2F);

  // ✅ Backgrounds (unchanged keys)
  static const Color background = Color(0xFFF8FBF9); // 🧘 Light mint (app-wide)
  static const Color card       = Color(0xFFF0F4F1); // Subtle eucalyptus tint

  // ➕ NEW: Optional helpers (safe to ignore elsewhere)
  static const Color surface       = Colors.white;      // standard white surface
  static const Color cardBorder    = Color(0xFFE0E0E0); // subtle outline for cards

  // ✅ AppBar (unchanged keys)
  static const Color appBarBackground = primaryLight;
  static const Color appBarTitle      = primary;
  static const Color appBarIcon       = Color(0xFF4F9D69);

  // ✅ Misc (unchanged keys)
  static const Color divider      = Color(0xFFE0E0E0);
  static const Color softRed      = Color(0xFFFFCDD2);
  static const Color redText      = Color(0xFFD32F2F);
  static const Color addButtonText = Colors.white;
  static const Color grey         = Colors.grey;
  static const Color textHint     = Color(0xFF9E9E9E);
}
