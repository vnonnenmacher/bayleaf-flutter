import 'package:flutter/material.dart';

class BookingFlowState {
  int? selectedServiceId;
  int? selectedProfessionalId;
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  int? selectedShiftId;

  BookingFlowState({
    this.selectedServiceId,
    this.selectedProfessionalId,
    this.selectedDate,
    this.selectedStartTime,
    this.selectedEndTime,
    this.selectedShiftId,
  });
}
