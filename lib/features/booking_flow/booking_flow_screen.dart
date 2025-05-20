import 'package:bayleaf_flutter/core/config.dart';
import 'package:bayleaf_flutter/models/slot_model.dart';
import 'package:bayleaf_flutter/models/service_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bayleaf_flutter/features/booking_flow/booking_flow_state.dart';
import 'package:bayleaf_flutter/features/booking_flow/steps/appointment_search_step.dart';
import 'package:bayleaf_flutter/features/booking_flow/steps/booking_confirmation_step.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bayleaf_flutter/theme/app_colors.dart';

class BookingFlowScreen extends StatefulWidget {
  final int? preselectedServiceId;
  final int? preselectedDoctorId;

  const BookingFlowScreen({
    super.key,
    this.preselectedServiceId,
    this.preselectedDoctorId,
  });

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  int currentStep = 0;
  final BookingFlowState flowState = BookingFlowState();
  List<ServiceModel> availableServices = [];
  DateTime filterDate = DateTime.now();
  List<ProfessionalModel> availableDoctors = [];

  @override
  void initState() {
    super.initState();

    if (widget.preselectedServiceId != null) {
      flowState.selectedServiceId = widget.preselectedServiceId;
    }
    if (widget.preselectedDoctorId != null) {
      flowState.selectedDoctorId = widget.preselectedDoctorId;
    }

    _fetchAvailableServices();
  }

  void _nextStep() {
    setState(() {
      currentStep++;
    });
  }

  void _previousStep() {
    setState(() {
      currentStep = currentStep > 0 ? currentStep - 1 : 0;
    });
  }

  Future<void> _fetchSlots() async {
    if (flowState.selectedServiceId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    final dateStr = filterDate.toIso8601String().split('T').first;

    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $authToken';

      final response = await dio.get(
        '${AppConfig.apiBaseUrl}api/appointments/available-slots/',
        queryParameters: {
          'start_date': dateStr,
          'end_date': dateStr,
          'services': flowState.selectedServiceId!,
        },
      );

      final List results = response.data['results'];
      final slots = results.map((json) => SlotModel.fromJson(json)).toList();

      // ------> Add this code:
      final List doctorResults = response.data['doctors'] ?? [];
      final doctors = doctorResults.map((json) => ProfessionalModel.fromJson(json)).toList();

      setState(() {
        flowState.availableSlots = slots;
        availableDoctors = doctors; // <------ store in the state!
      });
    } catch (e) {
      print('Failed to fetch slots: $e');
    }
  }

  Future<void> _fetchAvailableServices() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $authToken';

      final response = await dio.get('${AppConfig.apiBaseUrl}api/core/services/');
      final List results = response.data['results'];
      final services = results.map((json) => ServiceModel.fromJson(json)).toList();

      setState(() {
        availableServices = services;
      });
    } catch (e) {
      print('Failed to fetch services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget stepWidget;

    switch (currentStep) {
      case 0:
        stepWidget = AppointmentSearchStep(
          flowState: flowState,
          selectedServiceId: flowState.selectedServiceId,
          availableServices: availableServices,
          availableDoctors: availableDoctors,
          filterDate: filterDate,
          onDateChanged: (date) {
            setState(() {
              filterDate = date;
            });
            _fetchSlots();
          },
          onServiceSelected: (id) {
            setState(() {
              flowState.selectedServiceId = id;
            });
            _fetchSlots();
          },
          onSlotSelected: (slot) {
            setState(() {
              flowState.selectedDate = slot.date;
              flowState.selectedStartTime = slot.startTime;
              flowState.selectedEndTime = slot.endTime;
              flowState.selectedShiftId = slot.shiftId;
              flowState.selectedDoctorId = slot.doctorId;
            });
          },
          onNext: _nextStep,
        );
        break;
      case 1:
        stepWidget = BookingConfirmationStep(
          flowState: flowState,
          onPrevious: _previousStep,
          onFinish: () {
            Navigator.of(context).pop();
          },
          availableDoctors: availableDoctors, // <-- THIS LINE IS THE FIX
        );
        break;
      default:
        stepWidget = const Center(child: Text('Invalid step'));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        iconTheme: const IconThemeData(color: AppColors.appBarIcon),
        titleTextStyle: const TextStyle(
          color: AppColors.appBarTitle,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        title: const Text('Book Appointment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (currentStep > 0) {
              _previousStep();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.appBarTitle),
            ),
          )
        ],
      ),
      body: stepWidget,
    );
  }
}
