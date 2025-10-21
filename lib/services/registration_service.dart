// lib/services/registration_service.dart
import 'dart:convert';
import 'package:bayleaf_flutter/core/config.dart';
import 'package:bayleaf_flutter/models/user_role.dart';
import 'package:http/http.dart' as http;

class RegistrationService {
  final http.Client _client;
  RegistrationService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> register({
    required UserRole role,
    required Map<String, dynamic> payload,
  }) async {
    final uri = Uri.parse("${AppConfig.apiBaseUrl}${role.apiPath}");
    final resp = await _client.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(payload),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return jsonDecode(resp.body.isNotEmpty ? resp.body : "{}") as Map<String, dynamic>;
    }

    // Bubble up backend error with best-effort parsing
    try {
      final body = jsonDecode(resp.body);
      throw RegistrationException(
        statusCode: resp.statusCode,
        detail: body is Map && body["detail"] is String ? body["detail"] : resp.body,
      );
    } catch (_) {
      throw RegistrationException(statusCode: resp.statusCode, detail: resp.body);
    }
  }
}

class RegistrationException implements Exception {
  final int statusCode;
  final String detail;
  RegistrationException({required this.statusCode, required this.detail});

  @override
  String toString() => "RegistrationException($statusCode): $detail";
}
