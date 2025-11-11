import 'package:bayleaf_flutter/features/patients/patient_creation_by_user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bayleaf_flutter/models/user_type.dart';
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
        nickname: 'Mãe',
        gender: 'F',
        observations: const [
          Observation(Icons.check_circle_outline, AppColors.successDark, "Todas as tarefas realizadas"),
          Observation(Icons.event_note_outlined, AppColors.warningDark, "Consulta com cardiologista amanhã"),
          Observation(Icons.medication_liquid_outlined, AppColors.errorDark, "Estoque de remédios baixo"),
        ],
      ),
      PatientListItem(
        pid: '002',
        firstName: 'João',
        nickname: 'Pai',
        gender: 'M',
        observations: const [
          Observation(Icons.check_circle_outline, AppColors.successDark, "Tomou todas as medicações do dia"),
          Observation(Icons.local_hospital_outlined, AppColors.warningDark, "Avaliação de fisioterapia agendada"),
          Observation(Icons.warning_amber_rounded, AppColors.errorDark, "Pressão arterial elevada"),
        ],
      ),
      PatientListItem(
        pid: '003',
        firstName: 'Ana',
        nickname: 'Avó',
        gender: 'F',
        observations: const [
          Observation(Icons.check_circle_outline, AppColors.successDark, "Atividades cognitivas concluídas"),
          Observation(Icons.healing_outlined, AppColors.warningDark, "Consulta de rotina semana que vem"),
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
      backgroundColor: AppColors.background, // soft mint base
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(84),
        child: Stack(
          children: [
            // 🎨 Gradient background (mint → background)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFCFE6DA),
                    Color(0xFFEFF6F2),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),

            // 🧭 AppBar content
            AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.only(left: 20, top: 14, bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.appBarTitle,
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Escolha quem deseja acompanhar hoje",
                      style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16, top: 10),
                  child: GestureDetector(
                    onTap: _goToProfile,
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.12),
                      radius: 16,
                      child: const Icon(
                        Icons.person_outline,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const PatientCreationByUserScreen(),
            ),
          );
        },
        tooltip: t.addPatient,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: patients.length,
              itemBuilder: (context, i) => _buildPatientCard(context, patients[i]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, PatientListItem p) {
    // Determine overall severity
    Color statusColor = AppColors.successDark;
    if (p.observations.any((o) => o.color == AppColors.errorDark)) {
      statusColor = AppColors.errorDark;
    } else if (p.observations.any((o) => o.color == AppColors.warningDark)) {
      statusColor = AppColors.warningDark;
    }

    return GestureDetector(
      onTap: () => _selectPatient(p),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.divider, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left accent bar
            Container(
              width: 6,
              height: 160,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  bottomLeft: Radius.circular(22),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.primary,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.firstName ?? '',
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                p.nickname ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary
                                      .withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: AppColors.textSecondary, size: 26),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Divider(height: 1, color: AppColors.divider.withOpacity(0.9)),
                    const SizedBox(height: 10),
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
            ),
          ],
        ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color.withOpacity(0.9)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 15.5,
                fontWeight: FontWeight.w500,
                height: 1.4,
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
  final String? nickname;
  final String? gender;
  final List<Observation> observations;

  PatientListItem({
    required this.pid,
    this.firstName,
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
