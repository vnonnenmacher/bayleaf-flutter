import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  bool showMedications = true;

  @override
  Widget build(BuildContext context) {
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
                child: const Text('Medications'),
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
                child: const Text('Vaccines'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  showMedications ? _buildMedicationsView() : _buildVaccinesView(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        tooltip: showMedications ? 'Add Medication' : 'Add Vaccine',
        child: Icon(showMedications ? Icons.add : Icons.vaccines_outlined, color: AppColors.addButtonText),
        onPressed: () {
          // TODO: Add logic
        },
      ),
    );
  }

  Widget _buildMedicationsView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _medicationCard(name: 'Aspirin 100mg', frequency: 'Every 8 hours'),
        _medicationCard(name: 'Vitamin D', frequency: 'Daily at 9:00 AM'),
      ],
    );
  }

  Widget _medicationCard({required String name, required String frequency}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.medication_liquid, color: AppColors.primary),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(frequency),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccinesView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text('Upcoming Vaccines',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        _vaccineItem(icon: Icons.event, label: 'Flu Shot', date: 'May 12, 2025'),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text('Vaccines Taken',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        _vaccineItem(
            icon: Icons.vaccines_outlined,
            label: 'COVID-19 Booster',
            date: 'Jan 10, 2025'),
        _vaccineItem(
            icon: Icons.vaccines_outlined, label: 'Tetanus', date: 'Sep 3, 2023'),
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
