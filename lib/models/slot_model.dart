// lib/models/slot_model.dart

class SlotModel {
  final int id;
  final int shiftId;
  final DateTime startTime;
  final DateTime endTime;
  final int professionalId;
  final int serviceId;
  final String? serviceName;

  SlotModel({
    required this.id,
    required this.shiftId,
    required this.startTime,
    required this.endTime,
    required this.professionalId,
    required this.serviceId,
    this.serviceName,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    final service = json['service'] ?? {};
    return SlotModel(
      id: json['id'],
      shiftId: json['shift_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      professionalId: json['professional_id'],
      serviceId: service['id'],
      serviceName: service['name'],
    );
  }
}


class ProfessionalModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatar;

  ProfessionalModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatar,
  });

  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}
