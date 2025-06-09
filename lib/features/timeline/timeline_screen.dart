import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ai_assistant_modal.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  bool showTimeline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          showAiModal(
            context: context,
            onAction: (action) {
              print('Selected: $action');
            },
            onVoiceTap: () {
              print('Voice input tapped!');
            },
            onTextSend: (text) {},
            suggestionsOverride: [
              {
                "label": "Add Medication",
                "icon": Icons.medication_outlined,
                "action": "add_medication",
              },
              {
                "label": "Schedule",
                "icon": Icons.calendar_today_outlined,
                "action": "schedule_appointment",
              },
              {
                "label": "Log Symptom",
                "icon": Icons.edit_note_outlined,
                "action": "log_symptom",
              },
              {
                "label": "Get Advice",
                "icon": Icons.lightbulb_outline,
                "action": "get_advice",
              },
              {
                "label": "Message Doctor",
                "icon": Icons.message_outlined,
                "action": "message_doctor",
              },
              {
                "label": "Check Reminders",
                "icon": Icons.notifications_outlined,
                "action": "check_reminders",
              },
              {
                "label": "Update Profile",
                "icon": Icons.person_outline,
                "action": "update_profile",
              },
            ],
          );
        },
        tooltip: 'Activate AI Assistant',
        child: const Icon(Icons.smart_toy, color: AppColors.addButtonText),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: !showTimeline ? AppColors.primary : AppColors.greyLight,
                  foregroundColor: !showTimeline ? AppColors.textInverse : AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    showTimeline = false;
                  });
                },
                child: const Text('Feed'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: showTimeline ? AppColors.primary : AppColors.greyLight,
                  foregroundColor: showTimeline ? AppColors.textInverse : AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    showTimeline = true;
                  });
                },
                child: const Text('Timeline'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showTimeline ? _buildTimeline() : _buildFeed(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeed() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _feedAiMoodCard(),
        _feedCard(
          title: 'How to manage your medications effectively',
          description: 'Check out these 5 expert tips to ensure you never miss a dose.',
        ),
        _feedCard(
          title: 'Upcoming Health Webinar',
          description: 'Join our physiotherapy webinar on May 10th to learn at-home exercises.',
        ),
        _feedCard(
          title: 'New Feature: Track Symptoms',
          description: 'Now you can log daily symptoms directly in Bayleaf. Try it today!',
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Today • May 7', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _timelineCard(icon: Icons.medication_outlined, title: 'Take Aspirin 100mg', subtitle: '8:00 AM', actionLabel: 'Mark as Taken'),
        _timelineCard(icon: Icons.video_call, title: 'Video Appointment with Dr. Smith', subtitle: '10:30 AM', actionLabel: 'Join'),
        const SizedBox(height: 24),
        const Text('Tomorrow • May 8', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _timelineCard(icon: Icons.medication_liquid, title: 'Take Vitamin D', subtitle: '9:00 AM', actionLabel: 'Mark as Taken'),
      ],
    );
  }

  Widget _feedAiMoodCard() {
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
              children: const [
                Icon(Icons.smart_toy, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'How are you feeling today?',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('😃', style: TextStyle(fontSize: 28)),
                Text('🙂', style: TextStyle(fontSize: 28)),
                Text('😐', style: TextStyle(fontSize: 28)),
                Text('🙁', style: TextStyle(fontSize: 28)),
                Text('😢', style: TextStyle(fontSize: 28)),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Tell me more',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timelineCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionLabel,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 32, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: TextButton(
          onPressed: () {},
          child: Text(actionLabel),
        ),
      ),
    );
  }

  Widget _feedCard({required String title, required String description}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
