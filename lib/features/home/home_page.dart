import 'package:bayleaf_flutter/features/appointments/appointments_screen.dart';
import 'package:bayleaf_flutter/features/doctors/doctos_screen.dart';
import 'package:bayleaf_flutter/features/exams/exams_screen.dart';
import 'package:flutter/material.dart';
import '../medications/medications_screen.dart';
import '../profile/patient_profile_screen.dart';
import '../../theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  bool showTimeline = false;

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: AppColors.appBarBackground,
      elevation: 1.5,
      titleSpacing: 16,
      title: Row(
        children: [
          Image.asset('assets/images/bayleaf_logo.png', height: 28), // Simple logo asset
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          color: AppColors.appBarIcon,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientProfileScreen()));
          },
          child: const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.greyLight,
            child: Icon(Icons.person, color: AppColors.textSecondary, size: 20),
          ),
        ),
        const SizedBox(width: 12),
      ],
    ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildFeedTimelinePage(),
          const MedicationsScreen(),
          const AppointmentsScreen(),
          const ExamsScreen(),
          const DoctorsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.greyMedium,
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_liquid),
            label: 'Medications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Exams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Doctors',
          ),
        ],
      ),
    );
  }

  Widget _buildFeedTimelinePage() {
    return Column(
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
