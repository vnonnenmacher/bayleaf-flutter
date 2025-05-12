import 'package:flutter/material.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool showUpcoming = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        onPressed: () {
          // TODO: Implement new appointment booking flow
        },
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
                  foregroundColor:
                      showUpcoming ? Colors.white : Colors.black87,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => setState(() => showUpcoming = true),
                child: const Text('Upcoming'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      !showUpcoming ? const Color(0xFF2E7D32) : Colors.grey[300],
                  foregroundColor:
                      !showUpcoming ? Colors.white : Colors.black87,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => setState(() => showUpcoming = false),
                child: const Text('Past'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children:
                  showUpcoming ? _buildUpcomingAppointments() : _buildPastAppointments(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildUpcomingAppointments() {
    return [
      _appointmentCard(
        doctor: 'Dr. Laura Mendes',
        specialty: 'General Consultation',
        date: 'Monday, May 13, 2025',
        time: '10:30 AM',
        location: 'São Lucas Clinic',
        showActions: true,
      ),
      _appointmentCard(
        doctor: 'Dr. Henrique Silva',
        specialty: 'Dermatology',
        date: 'Wednesday, May 15, 2025',
        time: '2:00 PM',
        location: 'Vida Clinic',
        showActions: true,
      ),
    ];
  }

  List<Widget> _buildPastAppointments() {
    return [
      _appointmentCard(
        doctor: 'Dr. Laura Mendes',
        specialty: 'General Consultation',
        date: 'Mar 28, 2025',
        time: '4:00 PM',
        location: 'São Lucas Clinic',
        status: 'Completed',
      ),
      _appointmentCard(
        doctor: 'Dr. Henrique Silva',
        specialty: 'Dermatology',
        date: 'Feb 10, 2025',
        time: '11:00 AM',
        location: 'Vida Clinic',
        status: 'No-show',
      ),
    ];
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
                      Text(doctor,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(specialty, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                if (showActions)
                  const Icon(Icons.more_vert, size: 20, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(date),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 8),
                Text(time),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 8),
                Text(location),
              ],
            ),
            if (showActions) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2E7D32)),
                    ),
                    child: const Text('Reschedule'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                    child:
                        const Text('Cancel', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ] else if (status != null) ...[
              const SizedBox(height: 12),
              Text('Status: $status',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: status == 'Completed'
                        ? Colors.green
                        : (status == 'No-show'
                            ? Colors.orange
                            : Colors.red),
                  )),
            ]
          ],
        ),
      ),
    );
  }
}
