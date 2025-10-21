// lib/services/user_service.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bayleaf_flutter/services/app_config.dart'; // adjust if your Dio lives elsewhere
import 'package:bayleaf_flutter/models/user_type.dart';

class UserService {
  static const _kUserTypeKey = 'user_type';
  static const _kUserIdKey = 'user_id';
  static const _kPatientPidKey = 'patient_pid';

  static Future<UserIdentity> fetchAndPersistUserType() async {
    final dio = AppConfig.dio; // Your configured dio with auth header
    final res = await dio.get('/api/users/me/type/');
    final data = res.data as Map<String, dynamic>;
    final identity = UserIdentity.fromJson(data);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserTypeKey, identity.userType.name);
    if (identity.userId != null) {
      await prefs.setInt(_kUserIdKey, identity.userId!);
    }
    if (identity.patientPid != null) {
      await prefs.setString(_kPatientPidKey, identity.patientPid!);
    }
    return identity;
  }

  static Future<UserType> getStoredUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kUserTypeKey);
    return userTypeFromString(s);
  }

  static Future<void> clearUserType() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserTypeKey);
    await prefs.remove(_kUserIdKey);
    await prefs.remove(_kPatientPidKey);
  }
}
