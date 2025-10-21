import 'dart:math' as math;
import 'package:bayleaf_flutter/features/auth/role_definition_screen.dart';
import 'package:flutter/material.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';
import 'package:bayleaf_flutter/theme/app_colors.dart';

import 'login_screen.dart';
import 'patient_registration_screen.dart';

class WelcomeDoraScreen extends StatelessWidget {
  const WelcomeDoraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final h = c.maxHeight;
            final w = c.maxWidth;

            // reserve ~half screen for Dora and center her inside it
            final imageBandH = (h * 0.50).clamp(320.0, 520.0);
            final illoH = math.min(imageBandH * 0.8, 340.0); // max Dora size
            final buttonsMaxWidth = w * 0.70;

            return DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primaryLight, AppColors.background],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // brand row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/cuidadora_icon.png', width: 36, height: 36),
                      const SizedBox(width: 10),
                      Text(
                        l10n.brandCuidaDora,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .3,
                            ),
                      ),
                    ],
                  ),

                  // === IMAGE BAND (Dora centered vertically here) ===
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


                  // === TEXT + BUTTONS (no space between image and title) ===
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // no extra gap above
                        Text(
                          l10n.doraHelloTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.doraHelloSubtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 18),

                        // buttons (same width, right below the text)
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: buttonsMaxWidth),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FilledButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const RoleDefinitionScreen()),
                                  );
                                },
                                icon: const Icon(Icons.person_add_alt_1),
                                label: Text(l10n.iAmNewHere),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.addButtonText,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                },
                                icon: const Icon(Icons.login),
                                label: Text(l10n.iAlreadyHaveAnAccount),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.primary, width: 1.4),
                                  foregroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  backgroundColor: Colors.white.withOpacity(.92),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // breathe + safe area
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
