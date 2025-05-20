import 'package:bayleaf_flutter/features/booking_flow/booking_flow_state.dart';
import 'package:bayleaf_flutter/models/slot_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';

class BookingConfirmationStep extends StatelessWidget {
  final BookingFlowState flowState;
  final List<ProfessionalModel> availableDoctors;
  final VoidCallback onPrevious;
  final VoidCallback onFinish;

  const BookingConfirmationStep({
    super.key,
    required this.flowState,
    required this.availableDoctors,
    required this.onPrevious,
    required this.onFinish,
  });

  ProfessionalModel? getDoctor() {
    final selectedId = flowState.selectedDoctorId;
    if (selectedId != null) {
      try {
        return availableDoctors.firstWhere((doc) => doc.id == selectedId);
      } catch (_) {}
    }
    if (availableDoctors.isNotEmpty) return availableDoctors.first;
    return null;
  }

  SlotModel? getSlot() {
    if (flowState.selectedShiftId != null) {
      try {
        return flowState.availableSlots
            .firstWhere((slot) => slot.shiftId == flowState.selectedShiftId);
      } catch (_) {}
    }
    if (flowState.availableSlots.isNotEmpty) return flowState.availableSlots.first;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final doctor = getDoctor();
    final slot = getSlot();

    final doctorName = doctor != null
        ? '${doctor.firstName} ${doctor.lastName}'
        : "Doctor";

    final doctorSpecialty = "General"; // No specializations in model
    final appointmentLocation = "Bayleaf Clinic";
    final formattedDate = slot != null
        ? DateFormat('EEE, MMM dd, yyyy').format(slot.date)
        : "-";
    final formattedTime = slot != null
        ? '${slot.startTime.substring(0, 5)} – ${slot.endTime.substring(0, 5)}'
        : "-";

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              // Doctor Card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16, bottom: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(31), // ~12% opacity
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: AppColors.divider, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.primaryLight,
                        backgroundImage: doctor?.avatar != null && doctor!.avatar!.isNotEmpty
                            ? NetworkImage(doctor.avatar!)
                            : null,
                        child: (doctor?.avatar == null || doctor!.avatar!.isEmpty)
                            ? Icon(Icons.person, size: 38, color: AppColors.primary)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      doctorName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      doctorSpecialty,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_pin, color: AppColors.primary, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          appointmentLocation,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withAlpha(56),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: AppColors.primary, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withAlpha(56),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time,
                                  color: AppColors.primary, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                formattedTime,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Payment Summary Card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(31),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: AppColors.divider, width: 1),
                ),
                child: Column(
                  children: [
                    _feeRow('Service Fee', 'R\$150,00'),
                    const SizedBox(height: 8),
                    _feeRow('Booking Fee', 'R\$10,00'),
                    const SizedBox(height: 18),
                    Divider(color: AppColors.divider, thickness: 1.3),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Text(
                          "TOTAL",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 18),
                        ),
                        const Spacer(),
                        const Text(
                          "R\$160,00",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Icon(Icons.credit_card, color: AppColors.greyMedium, size: 22),
                        const SizedBox(width: 8),
                        const Text(
                          "Credit Card",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Credit Card Input Card (placeholder UI)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(31),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: AppColors.divider, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel("Card Number"),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "1234 5678 1234 5678",
                        suffixIcon: Icon(Icons.credit_card, color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.divider, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
                        ),
                        filled: true,
                        fillColor: AppColors.primaryLight.withAlpha(46),
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel("Expiry (MM/YY)"),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: "MM/YY",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: AppColors.divider, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.primaryLight.withAlpha(46),
                                  hintStyle: TextStyle(color: AppColors.textSecondary),
                                ),
                                keyboardType: TextInputType.datetime,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel("CVV"),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: "CVV",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: AppColors.divider, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.primaryLight.withAlpha(46),
                                  hintStyle: TextStyle(color: AppColors.textSecondary),
                                ),
                                obscureText: true,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _fieldLabel("Cardholder Name"),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Full Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.divider, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
                        ),
                        filled: true,
                        fillColor: AppColors.primaryLight.withAlpha(46),
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (v) {},
                          activeColor: AppColors.primary,
                        ),
                        const Text(
                          "Save card for future use",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // Legal Notice / Terms
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text:
                        "By booking this appointment, you agree to our ",
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                    children: [
                      TextSpan(
                        text: "Terms of Service",
                        style: const TextStyle(
                          color: AppColors.accent,
                          decoration: TextDecoration.underline,
                        ),
                        // Add your onTap for navigation if needed
                      ),
                      const TextSpan(text: " and "),
                      TextSpan(
                        text: "Privacy Policy",
                        style: const TextStyle(
                          color: AppColors.accent,
                          decoration: TextDecoration.underline,
                        ),
                        // Add your onTap for navigation if needed
                      ),
                      const TextSpan(text: "."),
                    ],
                  ),
                ),
              ),

              // Book Appointment Button (sticky on bottom)
              SafeArea(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      shadowColor: AppColors.primary.withAlpha(60),
                    ),
                    onPressed: onFinish,
                    child: const Text(
                      "Book Appointment",
                      style: TextStyle(
                        color: AppColors.textInverse,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _feeRow(String label, String value) {
  return Row(
    children: [
      Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
      const Spacer(),
      Text(
        value,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

Widget _fieldLabel(String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
