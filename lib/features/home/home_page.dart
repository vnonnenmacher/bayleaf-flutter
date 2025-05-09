import 'package:flutter/material.dart';
import '../medications/medications_screen.dart';
import '../profile/patient_profile_screen.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  bool showTimeline = false; // Feed default

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0E8F2),
        elevation: 0,
        title: const Text(
          'Bayleaf',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            color: Colors.black87,
            onPressed: () {
              // TODO: Notifications
            },
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientProfileScreen(),
                ),
              );
            },
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
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
          const Placeholder(),
          const Placeholder(),
          const Placeholder(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
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
                backgroundColor: !showTimeline ? const Color(0xFF2E7D32) : Colors.grey[300],
                foregroundColor: !showTimeline ? Colors.white : Colors.black87,
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
                backgroundColor: showTimeline ? const Color(0xFF2E7D32) : Colors.grey[300],
                foregroundColor: showTimeline ? Colors.white : Colors.black87,
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
        _feedCard(title: 'How to manage your medications effectively', description: 'Check out these 5 expert tips to ensure you never miss a dose.'),
        _feedCard(title: 'Upcoming Health Webinar', description: 'Join our physiotherapy webinar on May 10th to learn at-home exercises.'),
        _feedCard(title: 'New Feature: Track Symptoms', description: 'Now you can log daily symptoms directly in Bayleaf. Try it today!'),
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
                Icon(Icons.smart_toy, color: Color(0xFF2E7D32)),
                SizedBox(width: 8),
                Text('How are you feeling today?',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2E7D32)),
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
        leading: Icon(icon, size: 32, color: Color(0xFF2E7D32)),
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
            Text(description, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
