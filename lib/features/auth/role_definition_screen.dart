import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bayleaf_flutter/theme/app_colors.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';
import 'patient_registration_screen.dart';

enum UserRoleChoice { patient, family, caregiver }

class RoleDefinitionScreen extends StatelessWidget {
  const RoleDefinitionScreen({super.key});

  void _goToRegistration(BuildContext context, UserRoleChoice role) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PatientRegistrationScreen(
          // pass the role as a string – patient | family | caregiver
          selectedRole: role.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: BackButton(color: AppColors.textPrimary),
        centerTitle: true,
        title: Text(
          t.roleDefTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryLight, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  t.roleDefSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 18),

                _RoleOptionCard(
                  icon: Icons.favorite_border,
                  title: t.roleDefPatientTitle,
                  subtitle: t.roleDefPatientSubtitle,
                  onTap: () => _goToRegistration(context, UserRoleChoice.patient),
                ),
                const SizedBox(height: 12),

                _RoleOptionCard(
                  icon: Icons.group_outlined,
                  title: t.roleDefFamilyTitle,
                  subtitle: t.roleDefFamilySubtitle,
                  onTap: () => _goToRegistration(context, UserRoleChoice.family),
                ),
                const SizedBox(height: 12),

                _RoleOptionCard(
                  icon: Icons.medical_services_outlined,
                  title: t.roleDefCaregiverTitle,
                  subtitle: t.roleDefCaregiverSubtitle,
                  onTap: () => _goToRegistration(context, UserRoleChoice.caregiver),
                ),

                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back),
                  label: Text(t.back),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.white.withOpacity(.92),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primary.withOpacity(0.12),
                child: Icon(icon, color: AppColors.primary, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
