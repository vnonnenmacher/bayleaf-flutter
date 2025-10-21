import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bayleaf_flutter/core/config.dart'; // <-- adjust if yours is in core/config.dart
import 'package:bayleaf_flutter/l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../services/medications_service.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  bool showMedications = true;

  late final MedicationsService _service;

  bool _loading = true;
  String? _error;
  List<MyMedication> _items = [];

  @override
  void initState() {
    super.initState();
    _service = MedicationsService(
      apiBaseUrl: AppConfig.apiBaseUrl,
      tokenProvider: () async {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString('authToken');
      },
    );
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final page1 = await _service.getMyMedications(page: 1);
      setState(() {
        _items = page1.results;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _refresh() => _load();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      showMedications ? AppColors.primary : AppColors.greyLight,
                  foregroundColor:
                      showMedications ? AppColors.textInverse : AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  setState(() => showMedications = true);
                },
                child: Text(loc.menuMedications),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      !showMedications ? AppColors.primary : AppColors.greyLight,
                  foregroundColor:
                      !showMedications ? AppColors.textInverse : AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  setState(() => showMedications = false);
                },
                child: Text(loc.vaccinesTabTitle),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showMedications
                  ? _buildMedicationsView(loc)
                  : _buildVaccinesView(loc),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        tooltip: showMedications ? loc.tooltipAddMedication : loc.tooltipAddVaccine,
        child: Icon(
          showMedications ? Icons.add : Icons.vaccines_outlined,
          color: AppColors.addButtonText,
        ),
        onPressed: () {
          // TODO: Add logic
        },
      ),
    );
  }

  Widget _buildMedicationsView(AppLocalizations loc) {
    if (_loading) {
      return Center(child: Text(loc.appointmentsLoading)); // reuse "Loading..."
    }
    if (_error != null) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _errorCard(loc.medicationsLoadError),
          ],
        ),
      );
    }
    if (_items.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 24),
            Center(
              child: Text(
                loc.medicationsNoneTitle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                loc.medicationsNoneDesc,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, idx) {
          final m = _items[idx];

          final displayName = m.medication.name.isEmpty
              ? '${loc.medicationFallback} #${m.id}'
              : m.medication.name;

          final dose = m.dosageAmount.isNotEmpty
              ? '${_trimZeros(m.dosageAmount)} ${m.dosageUnit.code}'
              : m.dosageUnit.code;

          final freq = (m.frequencyHours != null && m.frequencyHours! > 0)
              ? loc.everyXHours(m.frequencyHours!.toString())
              : loc.asPrescribed;

          final subtitleParts = <String>[];
          if (dose.trim().isNotEmpty) subtitleParts.add(dose);
          if (freq.trim().isNotEmpty) subtitleParts.add(freq);
          if ((m.totalUnitAmount ?? 0) > 0) {
            subtitleParts.add(loc.totalUnits(m.totalUnitAmount!.toString()));
          }
          final subtitle = subtitleParts.join(' • ');

          return _medicationCard(
            name: displayName,
            frequency: subtitle,
            instructions: m.instructions,
            onEdit: () {
              // TODO: implement edit flow
            },
            onDelete: () {
              // TODO: implement delete flow then call _load()
            },
          );
        },
      ),
    );
  }

  String _trimZeros(String s) {
    if (!s.contains('.')) return s;
    s = s.replaceFirst(RegExp(r'0+$'), '');
    s = s.replaceFirst(RegExp(r'\.$'), '');
    return s;
  }

  Widget _errorCard(String message) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _medicationCard({
    required String name,
    required String frequency,
    String? instructions,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.medication_liquid, color: AppColors.primary),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(frequency),
            if (instructions != null && instructions.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  instructions,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: onEdit,
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  // Vaccines placeholder with i18n strings for headers
  Widget _buildVaccinesView(AppLocalizations loc) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            loc.vaccinesUpcoming,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        _vaccineItem(icon: Icons.event, label: 'Flu Shot', date: 'May 12, 2025'),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            loc.vaccinesTaken,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        _vaccineItem(
          icon: Icons.vaccines_outlined,
          label: 'COVID-19 Booster',
          date: 'Jan 10, 2025',
        ),
        _vaccineItem(
          icon: Icons.vaccines_outlined,
          label: 'Tetanus',
          date: 'Sep 3, 2023',
        ),
      ],
    );
  }

  Widget _vaccineItem({
    required IconData icon,
    required String label,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label),
        subtitle: Text(date),
      ),
    );
  }
}
