// lib/core/models/user_role.dart
enum UserRole { patient, professional, relative }

extension UserRoleX on UserRole {
  String get apiPath {
    switch (this) {
      case UserRole.patient:
        return "/api/patients/register/";
      case UserRole.professional:
        return "/api/professionals/register/";
      case UserRole.relative:
        return "/api/patients/relatives/register/";
    }
  }

  String get i18nKey {
    switch (this) {
      case UserRole.patient:
        return "rolePatient";
      case UserRole.professional:
        return "roleProfessional";
      case UserRole.relative:
        return "roleRelative";
    }
  }
}
