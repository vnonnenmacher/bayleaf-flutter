import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          // TODO: Implement exam scheduling
        },
        tooltip: 'Schedule Exam',
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Today • May 11',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _examCard(
            name: 'Blood Test',
            date: 'Tuesday, May 14, 2025',
            time: '9:00 AM',
            status: 'Scheduled',
          ),
          _examCard(
            name: 'MRI of Spine',
            date: 'Wednesday, May 15, 2025',
            time: '1:30 PM',
            status: 'In Process',
          ),
          const SizedBox(height: 24),
          const Text(
            'Earlier Exams',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _examCard(
            name: 'X-Ray Chest',
            date: 'April 10, 2025',
            time: '10:00 AM',
            status: 'Completed',
          ),
        ],
      ),
    );
  }

  Widget _examCard({
    required String name,
    required String date,
    required String time,
    required String status,
  }) {
    IconData statusIcon;
    Color statusColor;

    switch (status) {
      case 'Completed':
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        break;
      case 'In Process':
        statusIcon = Icons.autorenew;
        statusColor = Colors.orange;
        break;
      default:
        statusIcon = Icons.hourglass_top;
        statusColor = Colors.blueGrey;
    }

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(statusIcon, size: 18, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                  ],
                )
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
          ],
        ),
      ),
    );
  }
}
