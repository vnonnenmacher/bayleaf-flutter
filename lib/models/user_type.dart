// lib/models/user_type.dart
enum UserType { patient, professional, relative, unknown }

UserType userTypeFromString(String? s) {
  switch (s) {
    case 'patient':
      return UserType.patient;
    case 'professional':
      return UserType.professional;
    case 'relative':
      return UserType.relative;
    default:
      return UserType.unknown;
  }
}

class UserIdentity {
  final UserType userType;
  final int? userId;
  final String? patientPid; // for patients; may exist in some responses

  UserIdentity({
    required this.userType,
    this.userId,
    this.patientPid,
  });

  factory UserIdentity.fromJson(Map<String, dynamic> json) {
    final ids = (json['ids'] as Map?) ?? {};
    return UserIdentity(
      userType: userTypeFromString(json['user_type'] as String?),
      userId: ids['user_id'] as int?,
      patientPid: ids['patient_pid'] as String?,
    );
  }
}
