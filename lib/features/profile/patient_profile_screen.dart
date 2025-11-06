import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bayleaf_flutter/features/auth/login_screen.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../core/config.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen>
    with TickerProviderStateMixin {
  bool isEditing = false;
  int selectedTab = 0;

  String firstName = 'John';
  String lastName = 'Doe';
  DateTime birthDate = DateTime(1992, 7, 21);
  String email = 'patients@example.com';

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _streetController =
      TextEditingController(text: '1234 Main St');
  final TextEditingController _cityController =
      TextEditingController(text: 'Porto Alegre');
  final TextEditingController _zipController =
      TextEditingController(text: '90100-000');
  final TextEditingController _stateController =
      TextEditingController(text: 'RS');

  @override
  void initState() {
    super.initState();
    _firstNameController.text = firstName;
    _lastNameController.text = lastName;
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
      if (isEditing) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.profile_edit_mode),
          ),
        );
      }
    });
  }

  Future<void> _saveProfile() async {
    setState(() {
      firstName = _firstNameController.text;
      lastName = _lastNameController.text;
      isEditing = false;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token == null) return;

    final data = {
      "pid": "75ad468a-a1b1-4764-bca9-b972fb740771",
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "birth_date": DateFormat('yyyy-MM-dd').format(birthDate),
      "address1": {
        "id": 13,
        "street": _streetController.text,
        "city": _cityController.text,
        "state": _stateController.text,
        "zip_code": _zipController.text,
        "country": "USA"
      }
    };

    try {
      await Dio().patch(
        '${AppConfig.apiBaseUrl}/api/patients/profile/',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.profile_update_success),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.profile_update_fail),
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => birthDate = picked);
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final List<String> tabs = [
      loc.profile_tabs_personal,
      loc.profile_tabs_address,
      loc.profile_tabs_financial,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          isEditing ? loc.profile_edit_title : loc.profile_title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit,
                color: Colors.black87),
            onPressed: isEditing ? _saveProfile : _toggleEdit,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                if (!isEditing)
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child:
                          Icon(Icons.edit, size: 18, color: Colors.black87),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              '$firstName $lastName',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(tabs.length, (index) {
                  final selected = selectedTab == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selected ? AppColors.primary : Colors.grey[300],
                        foregroundColor:
                            selected ? Colors.white : Colors.black87,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => setState(() => selectedTab = index),
                      child: Text(
                        tabs[index],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                ..._buildTabContent(loc),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock_reset),
                  title: Text(loc.profile_forgot_password),
                  onTap: () {
                    // TODO: Implement forgot password flow
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    loc.profile_logout,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTabContent(AppLocalizations loc) {
    switch (selectedTab) {
      case 0:
        return [
          _editableCard(
              icon: Icons.person,
              label: loc.profile_first_name,
              controller: _firstNameController,
              isEditable: isEditing),
          _editableCard(
              icon: Icons.person,
              label: loc.profile_last_name,
              controller: _lastNameController,
              isEditable: isEditing),
          _birthDateCard(loc.profile_date_of_birth),
          _readonlyCard(
              icon: Icons.email,
              label: loc.profile_email,
              value: email,
              lock: true),
        ];
      case 1:
        return [
          _editableCard(
              icon: Icons.location_on,
              label: loc.profile_street,
              controller: _streetController,
              isEditable: isEditing),
          _editableCard(
              icon: Icons.location_city,
              label: loc.profile_city,
              controller: _cityController,
              isEditable: isEditing),
          _editableCard(
              icon: Icons.pin_drop,
              label: loc.profile_zip,
              controller: _zipController,
              isEditable: isEditing),
          _editableCard(
              icon: Icons.map,
              label: loc.profile_state,
              controller: _stateController,
              isEditable: isEditing),
        ];
      case 2:
        return [
          ListTile(title: Text(loc.profile_financial_placeholder))
        ];
      default:
        return [Text(loc.profile_unknown_tab)];
    }
  }

  Widget _editableCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditable,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 14)),
        subtitle: isEditable
            ? TextField(
                controller: controller,
                decoration:
                    const InputDecoration(border: InputBorder.none),
              )
            : Text(controller.text,
                style: const TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 16)),
      ),
    );
  }

  Widget _birthDateCard(String label) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.cake, color: AppColors.primary),
        title: Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 14)),
        subtitle: isEditing
            ? GestureDetector(
                onTap: _pickDate,
                child: Text(
                  DateFormat.yMMMMd().format(birthDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            : Text(
                DateFormat.yMMMMd().format(birthDate),
                style: const TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 16),
              ),
      ),
    );
  }

  Widget _readonlyCard({
    required IconData icon,
    required String label,
    required String value,
    bool lock = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 14)),
        subtitle: Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w400, fontSize: 16)),
        trailing:
            lock ? const Icon(Icons.lock_outline, size: 18) : null,
      ),
    );
  }
}
