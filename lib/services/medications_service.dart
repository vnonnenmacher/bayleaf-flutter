import 'package:dio/dio.dart';

typedef TokenProvider = Future<String?> Function();

class MedicationsService {
  final String apiBaseUrl;
  final TokenProvider tokenProvider;
  final Dio _dio;

  MedicationsService({
    required this.apiBaseUrl,
    required this.tokenProvider,
  }) : _dio = Dio(BaseOptions(baseUrl: apiBaseUrl));

  Future<PagedMyMedications> getMyMedications({int page = 1}) async {
    final token = await tokenProvider();
    if (token == null || token.isEmpty) {
      throw MedicationsServiceError('Auth token not found. Please sign in again.');
    }

    try {
      final resp = await _dio.get(
        '/api/medications/my-medications',
        queryParameters: {'page': page},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return PagedMyMedications.fromJson(resp.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final detail = e.response?.data?['detail'] ?? e.message;
      throw MedicationsServiceError('HTTP $status – $detail');
    }
  }
}

class MedicationsServiceError implements Exception {
  final String message;
  MedicationsServiceError(this.message);
  @override
  String toString() => 'MedicationsServiceError: $message';
}

/// ===== Models (same as before) =====

class PagedMyMedications {
  final int count;
  final String? next;
  final String? previous;
  final List<MyMedication> results;

  PagedMyMedications({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PagedMyMedications.fromJson(Map<String, dynamic> json) {
    final list = (json['results'] as List<dynamic>? ?? [])
        .map((e) => MyMedication.fromJson(e as Map<String, dynamic>))
        .toList();
    return PagedMyMedications(
      count: json['count'] as int? ?? list.length,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: list,
    );
  }
}

class MyMedication {
  final int id;
  final MedicationDef medication;
  final String dosageAmount;
  final DosageUnit dosageUnit;
  final int? frequencyHours;
  final String? instructions;
  final int? totalUnitAmount;

  MyMedication({
    required this.id,
    required this.medication,
    required this.dosageAmount,
    required this.dosageUnit,
    required this.frequencyHours,
    required this.instructions,
    required this.totalUnitAmount,
  });

  factory MyMedication.fromJson(Map<String, dynamic> json) {
    return MyMedication(
      id: json['id'] as int,
      medication: MedicationDef.fromJson(json['medication'] as Map<String, dynamic>),
      dosageAmount: json['dosage_amount'] as String? ?? '',
      dosageUnit: DosageUnit.fromJson(json['dosage_unit'] as Map<String, dynamic>),
      frequencyHours: json['frequency_hours'] as int?,
      instructions: json['instructions'] as String?,
      totalUnitAmount: json['total_unit_amount'] as int?,
    );
  }
}

class MedicationDef {
  final int id;
  final String name;
  final String description;

  MedicationDef({
    required this.id,
    required this.name,
    required this.description,
  });

  factory MedicationDef.fromJson(Map<String, dynamic> json) {
    return MedicationDef(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class DosageUnit {
  final int id;
  final String code;
  final String name;

  DosageUnit({
    required this.id,
    required this.code,
    required this.name,
  });

  factory DosageUnit.fromJson(Map<String, dynamic> json) {
    return DosageUnit(
      id: json['id'] as int,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}
