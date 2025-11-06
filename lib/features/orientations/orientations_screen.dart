import 'package:flutter/material.dart';
import 'package:bayleaf_flutter/theme/app_colors.dart';

class OrientationsScreen extends StatefulWidget {
  const OrientationsScreen({super.key});

  @override
  State<OrientationsScreen> createState() => _OrientationsScreenState();
}

class _OrientationsScreenState extends State<OrientationsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = 'Todas';
  bool _isFabOpen = false;

  final List<String> _filters = [
    'Todas',
    'Medicações',
    'Exames',
    'Médicos',
  ];

  final List<_OrientationItem> _orientations = [
    _OrientationItem(
      category: 'Medicações',
      title: 'Iniciar uso de Amoxicilina 500mg',
      description: 'Tomar 1 cápsula a cada 8 horas por 7 dias.',
      date: '02/11/2025',
      color: AppColors.primary,
      icon: Icons.medication_rounded,
    ),
    _OrientationItem(
      category: 'Exames',
      title: 'Exame de sangue solicitado',
      description: 'Realizar exame de hemograma completo e glicemia em jejum.',
      date: '03/11/2025',
      color: Colors.orangeAccent,
      icon: Icons.biotech_rounded,
    ),
    _OrientationItem(
      category: 'Médicos',
      title: 'Recomendação do Dr. Márcio',
      description:
          'Manter rotina de alongamentos e exercícios leves de fisioterapia.',
      date: '04/11/2025',
      color: AppColors.secondary,
      icon: Icons.health_and_safety_rounded,
    ),
    _OrientationItem(
      category: 'Medicações',
      title: 'Anotação pessoal',
      description: 'Evitar tomar o remédio em jejum, pois causa leve enjoo.',
      date: '04/11/2025',
      color: AppColors.primary,
      icon: Icons.edit_note_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedFilter == 'Todas'
        ? _orientations
        : _orientations
            .where((item) => item.category == _selectedFilter)
            .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ==== MAIN CONTENT ====
          Container(
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
            child: SafeArea(
              child: Column(
                children: [
                  // ==== FILTER BAR ====
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final f = _filters[index];
                          final isSelected = f == _selectedFilter;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedFilter = f),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.15)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.greyLight,
                                  width: 1.2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  f,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const Divider(height: 1, color: AppColors.greyLight),

                  // ==== ORIENTATIONS LIST ====
                  Expanded(
                    child: ListView.builder(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: item.color.withOpacity(0.25),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: item.color.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(item.icon, color: item.color, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description,
                                      style: const TextStyle(
                                        fontSize: 14.5,
                                        height: 1.4,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.date,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textHint,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ==== OVERLAY & FLOATING MENU ====
          _buildFabMenu(context),
        ],
      ),
    );

  }

  Widget _buildFabMenu(BuildContext context) {
    return Stack(
      children: [
        // Fullscreen overlay when open
        if (_isFabOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _isFabOpen = false),
              child: Container(
                color: Colors.black.withOpacity(0.35),
              ),
            ),
          ),

        // FAB and expanded buttons
        Positioned(
          right: 20,
          bottom: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedOpacity(
                opacity: _isFabOpen ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_isFabOpen) ...[
                      _buildMiniButton(
                        label: 'Adicionar medicação',
                        icon: Icons.medication_rounded,
                        color: AppColors.primary,
                        onTap: () => _openFlow(context, 'medicacao'),
                      ),
                      const SizedBox(height: 12),
                      _buildMiniButton(
                        label: 'Adicionar consulta',
                        icon: Icons.calendar_today_rounded,
                        color: Colors.teal,
                        onTap: () => _openFlow(context, 'consulta'),
                      ),
                      const SizedBox(height: 12),
                      _buildMiniButton(
                        label: 'Adicionar exame',
                        icon: Icons.biotech_rounded,
                        color: Colors.orangeAccent,
                        onTap: () => _openFlow(context, 'exame'),
                      ),
                      const SizedBox(height: 12),
                      _buildMiniButton(
                        label: 'Orientação médica',
                        icon: Icons.health_and_safety_rounded,
                        color: AppColors.secondary,
                        onTap: () => _openFlow(context, 'medico'),
                      ),
                      const SizedBox(height: 12),
                    ]
                  ],
                ),
              ),
              FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: () => setState(() => _isFabOpen = !_isFabOpen),
                child: Icon(
                  _isFabOpen ? Icons.close : Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _openFlow(BuildContext context, String type) {
    setState(() => _isFabOpen = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abrindo fluxo para: $type')),
    );
    // TODO: Navigate to the new flow here
  }
}

class _OrientationItem {
  final String category;
  final String title;
  final String description;
  final String date;
  final IconData icon;
  final Color color;

  _OrientationItem({
    required this.category,
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
    required this.color,
  });
}
