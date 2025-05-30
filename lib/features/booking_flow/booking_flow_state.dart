import '../../models/slot_model.dart';

class BookingFlowState {
  int? selectedServiceId;
  int? selectedProfessionalId;
  DateTime? selectedDate;
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;
  int? selectedShiftId;
  String? symptoms;
  SlotModel? selectedSlot;

  List<SlotModel> availableSlots;

  BookingFlowState({
    this.selectedServiceId,
    this.selectedProfessionalId,
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
    selectedProfessionalId = slot.professionalId;
    selectedDate = DateTime(slot.startTime.year, slot.startTime.month, slot.startTime.day);
    selectedStartTime = slot.startTime;
    selectedEndTime = slot.endTime;
    selectedShiftId = slot.shiftId;
  }
}
