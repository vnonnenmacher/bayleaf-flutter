import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/config.dart';

class PatientListItem {
  final String pid;
  final String firstName;
  final String lastName;
  final String? email;
  final String? birthDate;

  PatientListItem({
    required this.pid,
    required this.firstName,
    required this.lastName,
    this.email,
    this.birthDate,
  });

  factory PatientListItem.fromJson(Map<String, dynamic> j) {
    return PatientListItem(
      pid: j['pid'] as String,
      firstName: j['first_name'] as String? ?? '',
      lastName: j['last_name'] as String? ?? '',
      email: j['email'] as String?,
      birthDate: j['birth_date'] as String?,
    );
  }
}

/// File-private helper: build an authenticated Dio using the saved access token.
Future<Dio> _buildAuthedDio() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken'); // same key used in login/registration
  final headers = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
  };
  return Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl, headers: headers));
}

class PatientService {
  // Unauthenticated client, used for public endpoints like register.
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ),
  );

  Future<Map<String, dynamic>> registerPatient({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String birthDate, // ISO: YYYY-MM-DD
  }) async {
    try {
      final response = await _dio.post(
        '/api/patients/register/',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'birth_date': birthDate,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMessage = (data is Map && data['detail'] is String)
          ? data['detail'] as String
          : 'Registration failed. Please try again.';
      // ignore: avoid_print
      print("Registration error payload: ${e.response?.data}");
      throw Exception(errorMessage);
    }
  }

  /// Professionals: list assigned patients (paged).
  static Future<List<PatientListItem>> listPatientsForProfessional({int page = 1}) async {
    final dio = await _buildAuthedDio();
    final res = await dio.get(
      '/api/professionals/me/patients/',
      queryParameters: {'page': page},
    );
    final data = res.data as Map<String, dynamic>;
    final results = (data['results'] as List).cast<Map>();
    return results
        .map((j) => PatientListItem.fromJson(j.cast<String, dynamic>()))
        .toList();
  }

  /// Relatives: list linked patients (non-paged, backend returns `patient_links`).
  static Future<List<PatientListItem>> listPatientsForRelative() async {
    final dio = await _buildAuthedDio();
    final res = await dio.get('/api/patients/relatives/me/');
    final data = res.data as Map<String, dynamic>;
    final links = (data['patient_links'] as List).cast<Map>();
    return links
        .map((l) => (l['patient'] as Map).cast<String, dynamic>())
        .map(PatientListItem.fromJson)
        .toList();
  }
}
