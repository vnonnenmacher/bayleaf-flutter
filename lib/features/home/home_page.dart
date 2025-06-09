import 'package:bayleaf_flutter/core/config.dart';
import 'package:flutter/material.dart';
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

  // Helper to get only enabled/visible screens
  List<MenuScreenConfig> get availableScreens =>
      AppConfig.menuScreens.where((s) => s.enabled).toList();

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = availableScreens;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        elevation: 1.5,
        titleSpacing: 16,
        title: Row(
          children: [
            Image.asset('assets/images/bayleaf_logo.png', height: 28),
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
        children: screens.map((s) => s.screenBuilder()).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.greyMedium,
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: screens
            .map(
              (s) => BottomNavigationBarItem(
                icon: Icon(s.icon),
                label: s.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
