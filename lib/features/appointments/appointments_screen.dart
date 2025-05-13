import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool showUpcoming = true;
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
        'http://10.0.2.2:8000/api/patients/appointments/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data['results'];
      final List appointmentsRaw = data['appointments'];
      final List professionals = data['professionals'];

      // Build a map of professional DID -> Full Name
      final professionalMap = <String, String>{};
      for (var prof in professionals) {
        final did = prof['did'].toString();
        final fullName = '${prof['first_name']} ${prof['last_name']}';
        professionalMap[did] = fullName;
      }

      setState(() {
        doctorNamesByDid = professionalMap;
        appointments = List<Map<String, dynamic>>.from(appointmentsRaw);
      });
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final filtered = appointments.where((appt) {
      final scheduled = DateTime.tryParse(appt['scheduled_to'] ?? '') ?? now;
      return showUpcoming ? scheduled.isAfter(now) : scheduled.isBefore(now);
    }).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      showUpcoming ? const Color(0xFF2E7D32) : Colors.grey[300],
                  foregroundColor: showUpcoming ? Colors.white : Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => setState(() => showUpcoming = true),
                child: const Text('Upcoming'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      !showUpcoming ? const Color(0xFF2E7D32) : Colors.grey[300],
                  foregroundColor: !showUpcoming ? Colors.white : Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => setState(() => showUpcoming = false),
                child: const Text('Past'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final appt = filtered[index];
                final dateTime = DateTime.tryParse(appt['scheduled_to'] ?? '') ?? DateTime.now();
                final dateStr = DateFormat.yMMMMd().format(dateTime);
                final timeStr = DateFormat.Hm().format(dateTime);
                final doctorDid = appt['professional_did']?.toString();
                final doctorName = doctorNamesByDid[doctorDid] ?? 'Unknown Doctor';

                return _appointmentCard(
                  doctor: doctorName,
                  specialty: 'General',
                  date: dateStr,
                  time: timeStr,
                  location: 'Clinic Name',
                  showActions: showUpcoming,
                  status: appt['status'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentCard({
    required String doctor,
    required String specialty,
    required String date,
    required String time,
    required String location,
    bool showActions = false,
    String? status,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(specialty, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                if (showActions) const Icon(Icons.more_vert, size: 20, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.calendar_today, size: 16), const SizedBox(width: 8), Text(date)]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.access_time, size: 16), const SizedBox(width: 8), Text(time)]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.location_on, size: 16), const SizedBox(width: 8), Text(location)]),
            if (showActions) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF2E7D32))),
                    child: const Text('Reschedule'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                    child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ] else if (status != null) ...[
              const SizedBox(height: 12),
              Text('Status: $status',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: status == 'COMPLETED'
                        ? Colors.green
                        : (status == 'NO_SHOW' ? Colors.orange : Colors.red),
                  )),
            ]
          ],
        ),
      ),
    );
  }
}
