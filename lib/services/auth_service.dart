import 'package:dio/dio.dart';
import '../core/config.dart'; // for AppConfig.apiBaseUrl

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/users/login/',
        data: {
          'email': email,
          'password': password,
        },
      );

      return response.data; // expected to contain token + user info
    } on DioException catch (e) {
      print("Full error response: ${e.response?.data}");  // 🔥 Add this line
      final errorMessage =
          e.response?.data['detail'] ?? 'Login failed. Please try again.';
      throw Exception(errorMessage);
    }
  }
}

Future<bool> checkBackendHealth() async {
  try {
    final response = await Dio().get('${AppConfig.apiBaseUrl}/api/core/healthcheck');
    return response.statusCode == 200;
  } catch (e) {
    print("Healthcheck failed: $e");
    return false;
  }
}