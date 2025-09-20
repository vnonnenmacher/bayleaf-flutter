import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../booking_flow/booking_flow_screen.dart';
import '../../core/config.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';

String localizedStatus(BuildContext context, String? status) {
  final loc = AppLocalizations.of(context)!;
  switch (status) {
    case 'CONFIRMED':
      return loc.statusConfirmed;
    case 'REQUESTED':
      return loc.statusRequested;
    case 'CANCELLED':
      return loc.statusCancelled;
    default:
      return status ?? '';
  }
}

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool showUpcoming = true;
  bool isLoading = true;
  List<Map<String, dynamic>> appointments = [];
  Map<String, String> doctorNamesByDid = {};

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token == null) return;

    try {
      final response = await Dio().get(
        '${AppConfig.apiBaseUrl}/api/patients/appointments/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data['results'];
      final List appointmentsRaw = data['appointments'];
      final List professionals = data['professionals'];

      final professionalMap = <String, String>{};
      for (var prof in professionals) {
        final did = prof['did'].toString();
        final fullName = '${prof['first_name']} ${prof['last_name']}';
        professionalMap[did] = fullName;
      }

      setState(() {
        doctorNamesByDid = professionalMap;
        appointments = List<Map<String, dynamic>>.from(appointmentsRaw);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching appointments: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final filtered = appointments.where((appt) {
      final scheduled = DateTime.tryParse(appt['scheduled_to'] ?? '') ?? now;
      return showUpcoming ? scheduled.isAfter(now) : scheduled.isBefore(now);
    }).toList();

    filtered.sort((a, b) {
      final aDate = DateTime.tryParse(a['scheduled_to'] ?? '') ?? now;
      final bDate = DateTime.tryParse(b['scheduled_to'] ?? '') ?? now;
      return showUpcoming ? aDate.compareTo(bDate) : bDate.compareTo(aDate);
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BookingFlowScreen()),
          );
        },
        child: const Icon(Icons.add, color: AppColors.addButtonText),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildToggleButtons(loc),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading
                ? Center(child: Text(loc.appointmentsLoading))
                : filtered.isEmpty
                    ? _buildEmptyState(loc)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final appt = filtered[index];
                          return _buildAppointmentCard(appt, loc);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons(AppLocalizations loc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                showUpcoming ? AppColors.primary : AppColors.greyLight,
            foregroundColor:
                showUpcoming ? AppColors.textInverse : AppColors.textPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => setState(() => showUpcoming = true),
          child: Text(loc.appointmentsUpcoming),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                !showUpcoming ? AppColors.primary : AppColors.greyLight,
            foregroundColor:
                !showUpcoming ? AppColors.textInverse : AppColors.textPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => setState(() => showUpcoming = false),
          child: Text(loc.appointmentsPast),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appt, AppLocalizations loc) {
    final now = DateTime.now();
    final dateTime = DateTime.tryParse(appt['scheduled_to'] ?? '') ?? now;
    final doctorDid = appt['professional_did']?.toString();
    final doctorName = doctorNamesByDid[doctorDid] ?? loc.appointmentsUnknownDoctor;

    final difference = dateTime.difference(now);
    final daysRemaining = difference.inDays;
    final statusText = showUpcoming
        ? (daysRemaining == 0
            ? loc.appointmentsToday
            : daysRemaining == 1
                ? loc.appointmentsTomorrow
                : loc.appointmentsInXDays(daysRemaining))
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (statusText != null)
                      Text(
                        statusText,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat.E().add_yMMMd().add_Hm().format(dateTime),
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColorBackground(appt['status']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    localizedStatus(context, appt['status']),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: _statusColorText(appt['status']),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            // Doctor info
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctorName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      loc.appointmentsGeneralPractitioner,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            // Location
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.black54),
                const SizedBox(width: 6),
                Text(
                  loc.appointmentsClinicName,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (showUpcoming)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.schedule, color: AppColors.primary),
                      label: Text(
                        loc.appointmentsReschedule,
                        style: TextStyle(color: AppColors.primary),
                      ),
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.softRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.cancel_outlined, color: AppColors.redText),
                      label: Text(
                        loc.appointmentsCancel,
                        style: const TextStyle(color: AppColors.redText),
                      ),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Hook this up to the booking flow
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(loc.appointmentsBookAgain),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Color? _statusColorBackground(String? status) {
    if (status == 'CONFIRMED') return Colors.green[100];
    if (status == 'REQUESTED') return Colors.yellow[100];
    return Colors.red[100];
  }

  Color? _statusColorText(String? status) {
    if (status == 'CONFIRMED') return Colors.green[800];
    if (status == 'REQUESTED') return Colors.amber[800];
    return Colors.red[800];
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              showUpcoming ? Icons.event_available : Icons.history,
              size: 72,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              showUpcoming
                  ? loc.appointmentsNoneUpcoming
                  : loc.appointmentsNonePast,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              showUpcoming
                  ? loc.appointmentsNoneUpcomingDesc
                  : loc.appointmentsNonePastDesc,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            if (showUpcoming)
              const SizedBox(height: 24),
            if (showUpcoming)
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  loc.appointmentsBookAppointment,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
