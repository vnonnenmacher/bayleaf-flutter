import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  bool isEditing = false;

  String firstName = 'John';
  String lastName = 'Doe';
  DateTime birthDate = DateTime(1992, 7, 21);
  String email = 'patients@example.com';

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

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
          const SnackBar(content: Text("You're now editing your profile")),
        );
      }
    });
  }

  void _saveProfile() {
    setState(() {
      firstName = _firstNameController.text;
      lastName = _lastNameController.text;
      isEditing = false;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => birthDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0E8F2),
        elevation: 0,
        title: Text(isEditing ? 'Edit Profile' : 'Profile',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            )),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.black87),
              onPressed: _saveProfile,
            )
          else
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black87),
              onPressed: _toggleEdit,
            )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          _editableCard(
            icon: Icons.person,
            label: 'First Name',
            controller: _firstNameController,
            isEditable: isEditing,
          ),
          _editableCard(
            icon: Icons.person,
            label: 'Last Name',
            controller: _lastNameController,
            isEditable: isEditing,
          ),
          _birthDateCard(),
          _readonlyCard(
              icon: Icons.email, label: 'Email', value: email, lock: true),
          const SizedBox(height: 32),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text('Notification Preferences'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _editableCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditable,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2E7D32)),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        subtitle: isEditable
            ? TextField(
                controller: controller,
                decoration: const InputDecoration(border: InputBorder.none),
              )
            : Text(controller.text,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
      ),
    );
  }

  Widget _birthDateCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.cake, color: Color(0xFF2E7D32)),
        title: const Text('Date of Birth',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        subtitle: isEditing
            ? GestureDetector(
                onTap: _pickDate,
                child: Text(
                  DateFormat.yMMMMd().format(birthDate),
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      decoration: TextDecoration.underline),
                ),
              )
            : Text(
                DateFormat.yMMMMd().format(birthDate),
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2E7D32)),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        subtitle: Text(value,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
        trailing: lock ? const Icon(Icons.lock_outline, size: 18) : null,
      ),
    );
  }
}
