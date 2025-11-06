import 'package:bayleaf_flutter/core/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profile/patient_profile_screen.dart';
import '../../theme/app_colors.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';
import 'package:bayleaf_flutter/features/patients/patient_selection_screen.dart';
import 'package:bayleaf_flutter/models/user_type.dart';

String localizedMenuLabel(BuildContext context, String key) {
  final loc = AppLocalizations.of(context)!;
  switch (key) {
    case 'menuBayleaf':
      return loc.menuBayleaf;
    case 'menuMedications':
      return loc.menuMedications;
    case 'menuAppointments':
      return loc.menuAppointments;
    case 'menuExams':
      return loc.menuExams;
    case 'menuDoctors':
      return loc.menuDoctors;
    case 'menuTreatment':
      return loc.menuTreatment;
    case 'menuOrientations':
      return loc.menuOrientations;
    default:
      return key;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  String? _activePatientNickname;
  String? _activePatientGender;
  UserType? _userType;
  bool _isCareContext = false;

  List<MenuScreenConfig> get availableScreens =>
      AppConfig.menuScreens.where((s) => s.enabled).toList();

  @override
  void initState() {
    super.initState();
    _loadContext();
  }

  Future<void> _loadContext() async {
    final prefs = await SharedPreferences.getInstance();
    final typeString = prefs.getString('user_type');
    final patientPid = prefs.getString('active_patient_pid');

    final userType =
        typeString != null ? userTypeFromString(typeString) : UserType.patient;
    final isCaregiver =
        userType == UserType.relative || userType == UserType.professional;

    // Mock: Normally you'd fetch patient details here via API
    String? nickname;
    String? gender;
    if (isCaregiver && patientPid != null) {
      // Example data for now
      nickname = "Mãe"; // could be fetched from PatientListItem
      gender = "F";
    }

    setState(() {
      _userType = userType;
      _isCareContext = isCaregiver && patientPid != null;
      _activePatientNickname = nickname;
      _activePatientGender = gender;
    });
  }

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
  }

  void _goBackToPatientList() {
    if (_userType == null) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PatientSelectionScreen(userType: _userType!),
      ),
    );
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
            if (_isCareContext)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.primary, size: 20),
                onPressed: _goBackToPatientList,
              ),
            if (_isCareContext)
              _buildCareContextHeader()
            else
              Image.asset('assets/images/cuidadora_icon.png', height: 28),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PatientProfileScreen()),
              );
            },
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.greyLight,
              child: Icon(Icons.person,
                  color: AppColors.textSecondary, size: 20),
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
                label: localizedMenuLabel(context, s.labelKey),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCareContextHeader() {
    final avatarColor = _activePatientGender == 'M'
        ? Colors.lightBlue.shade100
        : Colors.pink.shade100;
    final nickname = _activePatientNickname ?? "Paciente";

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: avatarColor,
            width: 36,
            height: 36,
            child: const Icon(Icons.person,
                color: AppColors.primary, size: 22),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          nickname,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
