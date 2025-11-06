import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bayleaf_flutter/models/user_type.dart';
import 'package:bayleaf_flutter/services/patient_service.dart';
import 'package:bayleaf_flutter/features/home/home_page.dart';
import 'package:bayleaf_flutter/features/profile/patient_profile_screen.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';
import 'package:bayleaf_flutter/theme/app_colors.dart';

class PatientSelectionScreen extends StatefulWidget {
  final UserType userType;
  const PatientSelectionScreen({super.key, required this.userType});

  @override
  State<PatientSelectionScreen> createState() => _PatientSelectionScreenState();
}

class _PatientSelectionScreenState extends State<PatientSelectionScreen> {
  late Future<List<PatientListItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<PatientListItem>> _load() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      PatientListItem(
        pid: '001',
        firstName: 'Maria',
        lastName: 'Souza',
        email: 'maria@example.com',
        nickname: 'Mãe',
        gender: 'F',
        observations: const [
          Observation(Icons.check_circle_outline, Colors.green, "Todas as tarefas realizadas"),
          Observation(Icons.event_note_outlined, Colors.orange, "Consulta com cardiologista amanhã"),
          Observation(Icons.medication_liquid_outlined, Colors.redAccent, "Estoque de remédios baixo"),
        ],
      ),
      PatientListItem(
        pid: '002',
        firstName: 'João',
        lastName: 'Pereira',
        email: 'joao@example.com',
        nickname: 'Pai',
        gender: 'M',
        observations: const [
          Observation(Icons.check_circle_outline, Colors.green, "Tomou todas as medicações do dia"),
          Observation(Icons.local_hospital_outlined, Colors.orange, "Avaliação de fisioterapia agendada"),
          Observation(Icons.warning_amber_rounded, Colors.redAccent, "Pressão arterial elevada"),
        ],
      ),
      PatientListItem(
        pid: '003',
        firstName: 'Ana',
        lastName: 'Lima',
        email: 'ana@example.com',
        nickname: 'Avó',
        gender: 'F',
        observations: const [
          Observation(Icons.check_circle_outline, Colors.green, "Atividades cognitivas concluídas"),
          Observation(Icons.healing_outlined, Colors.orange, "Consulta de rotina semana que vem"),
        ],
      ),
    ];
  }

  Future<void> _refresh() async => setState(() => _future = _load());

  Future<void> _selectPatient(PatientListItem p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_patient_pid', p.pid);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  void _goToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PatientProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final title = widget.userType == UserType.professional
        ? t.selectPatientTitle
        : t.selectRelativeTitle;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _goToProfile,
              child: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                radius: 18,
                child: const Icon(Icons.person_outline,
                    color: AppColors.primary, size: 22),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: t.addPatient,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<PatientListItem>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final patients = snap.data ?? [];
          if (patients.isEmpty) {
            return const Center(child: Text("Nenhum paciente encontrado"));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: patients.length,
              itemBuilder: (context, i) =>
                  _buildPatientCard(context, patients[i]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, PatientListItem p) {
    final needsAttention = p.observations
        .any((o) => o.color == Colors.redAccent || o.icon == Icons.warning_amber_rounded);
    final avatarColor =
        p.gender == 'M' ? Colors.lightBlue.shade100 : Colors.pink.shade100;

    return GestureDetector(
      onTap: () => _selectPatient(p),
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: avatarColor,
                      width: 56,
                      height: 56,
                      child: const Icon(Icons.person,
                          color: AppColors.primary, size: 34),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.nickname ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p.firstName ?? '',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: p.observations
                              .map((o) => _PatientInfoRow(
                                  icon: o.icon, color: o.color, text: o.text))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (needsAttention)
            Positioned(
              top: 10,
              right: 12,
              child: Icon(Icons.warning_amber_rounded,
                  color: Colors.orange.shade700, size: 26),
            ),
        ],
      ),
    );
  }
}

class _PatientInfoRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _PatientInfoRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PatientListItem {
  final String pid;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? nickname;
  final String? gender;
  final List<Observation> observations;

  PatientListItem({
    required this.pid,
    this.firstName,
    this.lastName,
    this.email,
    this.nickname,
    this.gender,
    this.observations = const [],
  });
}

class Observation {
  final IconData icon;
  final Color color;
  final String text;

  const Observation(this.icon, this.color, this.text);
}
