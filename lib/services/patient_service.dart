import 'package:dio/dio.dart';
import '../core/config.dart';

class PatientService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Map<String, dynamic>> registerPatient({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String birthDate,
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

      return response.data; // Return the patient data
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['detail'] ?? 'Registration failed. Please try again.';
      print("Full error response: ${e.response?.data}");
      throw Exception(errorMessage);
    }
  }
}
