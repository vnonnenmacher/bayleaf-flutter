import '../../models/slot_model.dart';

class BookingFlowState {
  int? selectedServiceId;
  int? selectedDoctorId;
  DateTime? selectedDate;
  String? selectedStartTime;
  String? selectedEndTime;
  int? selectedShiftId;
  String? symptoms;
  SlotModel? selectedSlot;

  List<SlotModel> availableSlots;

  BookingFlowState({
    this.selectedServiceId,
    this.selectedDoctorId,
    this.selectedDate,
    this.selectedStartTime,
    this.selectedEndTime,
    this.selectedShiftId,
    this.symptoms,
    this.availableSlots = const [],
  });

void setSelectedSlot(SlotModel slot) {
  selectedSlot = slot;
  selectedServiceId = slot.serviceId;
  selectedDoctorId = slot.doctorId;
  selectedDate = slot.date;
  selectedStartTime = slot.startTime;
  selectedEndTime = slot.endTime;
  selectedShiftId = slot.shiftId;
}
}
