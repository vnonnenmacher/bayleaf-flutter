import 'package:flutter/material.dart';
import 'package:bayleaf_flutter/theme/app_colors.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';

class PatientCreationByUserScreen extends StatefulWidget {
  const PatientCreationByUserScreen({super.key});

  @override
  State<PatientCreationByUserScreen> createState() =>
      _PatientCreationByUserScreenState();
}

class _PatientCreationByUserScreenState extends State<PatientCreationByUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedSex;

  final List<String> _sexOptions = ['Masculino', 'Feminino', 'Outro'];

  bool _isLoading = false;

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate save action
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paciente adicionado com sucesso!')),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryLight, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Column(
                    children: [
                      const Icon(Icons.person_add_alt_1_rounded,
                          size: 60, color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text(
                        "Adicionar Paciente",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Cadastre um familiar ou paciente sob seus cuidados.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Nickname
                  TextFormField(
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      labelText: "Apelido (ex: Mãe, Pai, Tio...)",
                      prefixIcon:
                          const Icon(Icons.person_outline, color: AppColors.primary),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe um apelido" : null,
                  ),

                  const SizedBox(height: 16),

                  // Age
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Idade",
                      prefixIcon:
                          const Icon(Icons.calendar_today, color: AppColors.primary),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Informe a idade";
                      final n = int.tryParse(v);
                      if (n == null || n <= 0) return "Idade inválida";
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Sex Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedSex,
                    items: _sexOptions
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedSex = v),
                    decoration: InputDecoration(
                      labelText: "Sexo",
                      prefixIcon:
                          const Icon(Icons.wc_rounded, color: AppColors.primary),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Selecione o sexo" : null,
                  ),

                  const SizedBox(height: 16),

                  // Notes / Description
                  TextFormField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: "Conte um pouco sobre as dificuldades do paciente",
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Icon(Icons.chat_bubble_outline_rounded,
                            color: AppColors.primary),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Descreva brevemente" : null,
                  ),

                  const SizedBox(height: 28),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_rounded, color: Colors.white),
                      label: Text(
                        _isLoading ? "Salvando..." : "Salvar Paciente",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
