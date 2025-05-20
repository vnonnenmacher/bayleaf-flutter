import 'package:bayleaf_flutter/features/booking_flow/booking_flow_state.dart';
import 'package:bayleaf_flutter/models/service_model.dart';
import 'package:bayleaf_flutter/models/slot_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';

// --- FilterBox reusable widget ---
class _FilterBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final bool selected;

  const _FilterBox({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
    this.onClear,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : AppColors.primaryLight),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? Colors.white : AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value ?? label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (selected && onClear != null)
              GestureDetector(
                onTap: onClear,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AppointmentSearchStep extends StatefulWidget {
  final BookingFlowState flowState;
  final void Function(SlotModel) onSlotSelected;
  final int? selectedServiceId;
  final int? selectedDoctorId;
  final List<ServiceModel> availableServices;
  final List<ProfessionalModel> availableDoctors;
  final DateTime filterDate;
  final ValueChanged<DateTime> onDateChanged;
  final void Function(int?)? onServiceSelected;
  final void Function(int?)? onDoctorSelected;
  final VoidCallback onNext;

  const AppointmentSearchStep({
    super.key,
    required this.flowState,
    required this.selectedServiceId,
    this.selectedDoctorId,
    required this.availableServices,
    required this.availableDoctors,
    required this.filterDate,
    required this.onDateChanged,
    this.onServiceSelected,
    this.onDoctorSelected,
    required this.onSlotSelected,
    required this.onNext,
  });

  @override
  State<AppointmentSearchStep> createState() => _AppointmentSearchStepState();
}

class _AppointmentSearchStepState extends State<AppointmentSearchStep> {
  int? selectedDoctor;
  int? selectedService;

  late final Map<int, ProfessionalModel> doctorById;

  @override
  void initState() {
    super.initState();
    selectedDoctor = widget.selectedDoctorId;
    selectedService = widget.selectedServiceId;
    doctorById = {
      for (var doc in widget.availableDoctors) doc.id: doc,
    };
  }

  void _showDoctorSelector() async {
    final doctors = widget.availableDoctors;
    int? result = await showModalBottomSheet<int?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        TextEditingController searchCtrl = TextEditingController();
        return StatefulBuilder(
          builder: (context, setModalState) {
            String search = searchCtrl.text.toLowerCase();
            final filtered = search.isEmpty
                ? doctors
                : doctors.where((d) =>
                    d.firstName.toLowerCase().contains(search) ||
                    d.lastName.toLowerCase().contains(search)
                  ).toList();
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search doctors',
                        filled: true,
                        fillColor: AppColors.greyLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setModalState(() {}),
                    ),
                  ),
                  ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.people)),
                    title: const Text('All Doctors'),
                    onTap: () => Navigator.of(context).pop(null),
                    selected: selectedDoctor == null,
                  ),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No doctors found'),
                    ),
                  ...filtered.map<Widget>((doctor) => ListTile(
                        leading: doctor.avatar != null
                            ? CircleAvatar(backgroundImage: NetworkImage(doctor.avatar!))
                            : const CircleAvatar(child: Icon(Icons.person)),
                        title: Text('${doctor.firstName} ${doctor.lastName}'),
                        subtitle: Text(doctor.email),
                        onTap: () => Navigator.of(context).pop(doctor.id),
                        selected: selectedDoctor == doctor.id,
                      )),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
    if (result != selectedDoctor) {
      setState(() => selectedDoctor = result);
      widget.onDoctorSelected?.call(result);
    }
  }

  void _showServiceSelector() async {
    final services = widget.availableServices;
    int? result = await showModalBottomSheet<int?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        TextEditingController searchCtrl = TextEditingController();
        return StatefulBuilder(
          builder: (context, setModalState) {
            String search = searchCtrl.text.toLowerCase();
            final filtered = search.isEmpty
                ? services
                : services.where((s) => s.name.toLowerCase().contains(search)).toList();
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search services',
                        filled: true,
                        fillColor: AppColors.greyLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setModalState(() {}),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.apps),
                    title: const Text('All Services'),
                    onTap: () => Navigator.of(context).pop(null),
                    selected: selectedService == null,
                  ),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No services found'),
                    ),
                  ...filtered.map<Widget>((service) => ListTile(
                        leading: const Icon(Icons.medical_services),
                        title: Text(service.name),
                        onTap: () => Navigator.of(context).pop(service.id),
                        selected: selectedService == service.id,
                      )),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
    if (result != selectedService) {
      setState(() => selectedService = result);
      widget.onServiceSelected?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final slots = widget.flowState.availableSlots;
    // Always up to date
    final doctorById = {
      for (var doc in widget.availableDoctors) doc.id: doc,
    };

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _FilterBox(
                        icon: Icons.person_search,
                        label: 'Doctor',
                        value: selectedDoctor == null
                            ? null
                            : (() {
                                final doc = doctorById[selectedDoctor];
                                return doc != null
                                    ? '${doc.firstName} ${doc.lastName}'
                                    : 'Loading...';
                              })(),
                        onTap: _showDoctorSelector,
                        onClear: selectedDoctor != null
                            ? () {
                                setState(() => selectedDoctor = null);
                                widget.onDoctorSelected?.call(null);
                              }
                            : null,
                        selected: selectedDoctor != null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FilterBox(
                        icon: Icons.calendar_today,
                        label: 'Date',
                        value: DateFormat('MMM dd, yyyy').format(widget.filterDate),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: widget.filterDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 60)),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors.primary,
                                    onPrimary: Colors.white,
                                    surface: AppColors.card,
                                    onSurface: AppColors.textPrimary,
                                  ),
                                  dialogBackgroundColor: AppColors.background,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            widget.onDateChanged(picked);
                          }
                        },
                        selected: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _FilterBox(
                        icon: Icons.medical_services,
                        label: 'Service',
                        value: selectedService == null
                            ? null
                            : (() {
                                final serviceList = widget.availableServices.where((s) => s.id == selectedService);
                                return serviceList.isNotEmpty ? serviceList.first.name : 'Service';
                              })(),
                        onTap: _showServiceSelector,
                        onClear: selectedService != null
                            ? () {
                                setState(() => selectedService = null);
                                widget.onServiceSelected?.call(null);
                              }
                            : null,
                        selected: selectedService != null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: slots.isEmpty
                ? Center(
                    child: Text('No available slots', style: TextStyle(color: AppColors.textSecondary)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: slots.length,
                    itemBuilder: (context, index) {
                      final slot = slots[index];
                      final doctor = doctorById[slot.doctorId];
                      final formattedDate = DateFormat('MMM dd, yyyy').format(slot.date);
                      final startTime = slot.startTime;
                      final endTime = slot.endTime;

                      return Card(
                        color: AppColors.card,
                        elevation: 3,
                        shadowColor: AppColors.primaryLight,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          onTap: () {
                            widget.onSlotSelected(slot);
                            widget.onNext();
                          },
                          leading: doctor?.avatar != null
                              ? CircleAvatar(backgroundImage: NetworkImage(doctor!.avatar!))
                              : const CircleAvatar(child: Icon(Icons.person)),
                          title: doctor != null
                              ? Text(
                                  '${doctor.firstName} ${doctor.lastName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                )
                              : Text(
                                  'Loading...',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                          subtitle: doctor != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      '$formattedDate • $startTime - $endTime',
                                      style: const TextStyle(color: AppColors.textSecondary),
                                    ),
                                    Text(
                                      doctor.email,
                                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ],
                                )
                              : null,
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

}
