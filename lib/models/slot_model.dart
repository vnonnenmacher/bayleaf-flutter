// lib/models/slot_model.dart

class SlotModel {
  final int serviceId;
  final int shiftId;
  final String startTime;
  final String endTime;
  final DateTime date;
  final int doctorId; // Only doctorId

  SlotModel({
    required this.serviceId,
    required this.shiftId,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.doctorId,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      serviceId: json['service_id'],
      shiftId: json['shift_id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      date: DateTime.parse(json['date']),
      doctorId: json['doctor_id'],
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
