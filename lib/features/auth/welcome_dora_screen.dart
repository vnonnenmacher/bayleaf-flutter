import 'dart:math' as math;
import 'package:bayleaf_flutter/features/auth/role_definition_screen.dart';
import 'package:flutter/material.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';
import 'package:bayleaf_flutter/theme/app_colors.dart';

import 'login_screen.dart';

class WelcomeDoraScreen extends StatelessWidget {
  const WelcomeDoraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryLight, AppColors.background],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, c) {
              final h = c.maxHeight;
              final w = c.maxWidth;
              final imageBandH = (h * 0.50).clamp(320.0, 520.0);
              final illoH = math.min(imageBandH * 0.8, 340.0);
              final buttonsMaxWidth = w * 0.72;

              return Column(
                children: [
                  const SizedBox(height: 20),

                  // === BRAND HEADER ===
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/cuidadora_icon.png', width: 40, height: 40),
                      const SizedBox(width: 10),
                      Text(
                        l10n.brandCuidaDora,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: .3,
                        ),
                      ),
                    ],
                  ),

                  // === DORA ILLUSTRATION ===
                  SizedBox(
                    height: imageBandH,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'assets/images/dora_full.png',
                        height: illoH,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // === TEXT & BUTTONS ===
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.doraHelloTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.doraHelloSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // === BUTTONS ===
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: buttonsMaxWidth),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Primary action (filled)
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => const RoleDefinitionScreen()),
                                  );
                                },
                                icon: const Icon(Icons.person_add_alt_1),
                                label: Text(
                                  l10n.iAmNewHere,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 6,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Secondary action (outlined with soft background)
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                },
                                icon: const Icon(Icons.login_rounded),
                                label: Text(
                                  l10n.iAlreadyHaveAnAccount,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.primary, width: 1.3),
                                  foregroundColor: AppColors.primary,
                                  backgroundColor: Colors.white.withOpacity(0.9),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  shadowColor: AppColors.primary.withOpacity(0.2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
