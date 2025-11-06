import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bayleaf_flutter/theme/app_colors.dart';

class MyTreatmentScreen extends StatelessWidget {
  const MyTreatmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final dayAfter = now.add(const Duration(days: 2));

    final dateFormat = DateFormat("dd 'de' MMMM 'de' yyyy", 'pt_BR');
    final shortDate = DateFormat("dd 'de' MMMM", 'pt_BR');

    final List<_TreatmentDay> treatmentDays = [
      _TreatmentDay(
        title: "Hoje, ${dateFormat.format(now)}",
        events: [
          _TreatmentEvent(
            time: "Em 30 minutos",
            description: "Tomar medicação",
            icon: Icons.medication_liquid_outlined,
            color: AppColors.primary,
          ),
        ],
      ),
      _TreatmentDay(
        title: "Amanhã, dia ${shortDate.format(tomorrow)}",
        events: [
          _TreatmentEvent(
            time: "08:00 e 13:00",
            description: "Tomar suas medicações",
            icon: Icons.alarm_rounded,
            color: AppColors.secondary,
          ),
          _TreatmentEvent(
            time: "09:00",
            description: "Consulta com o Dr. Márcio (Fisioterapeuta)",
            icon: Icons.medical_services_outlined,
            color: Colors.orangeAccent,
          ),
        ],
      ),
      _TreatmentDay(
        title: "${shortDate.format(dayAfter)}",
        events: [
          _TreatmentEvent(
            time: "08:00 e 13:00",
            description: "Tomar suas medicações",
            icon: Icons.medication_outlined,
            color: AppColors.primary,
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.08),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: treatmentDays.length,
          itemBuilder: (context, index) {
            final day = treatmentDays[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8, bottom: 12),
                  child: Text(
                    day.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                ...day.events.map(
                  (event) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: event.color.withOpacity(0.25),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: event.color.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child:
                              Icon(event.icon, color: event.color, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.description,
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                event.time,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TreatmentDay {
  final String title;
  final List<_TreatmentEvent> events;
  _TreatmentDay({required this.title, required this.events});
}

class _TreatmentEvent {
  final String time;
  final String description;
  final IconData icon;
  final Color color;
  _TreatmentEvent({
    required this.time,
    required this.description,
    required this.icon,
    required this.color,
  });
}
