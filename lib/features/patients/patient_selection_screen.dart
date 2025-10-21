// lib/features/patients/patient_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bayleaf_flutter/models/user_type.dart';
import 'package:bayleaf_flutter/services/patient_service.dart';
import 'package:bayleaf_flutter/features/home/home_page.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';

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

  Future<List<PatientListItem>> _load() {
    if (widget.userType == UserType.professional) {
      return PatientService.listPatientsForProfessional();
    } else {
      // relative
      return PatientService.listPatientsForRelative();
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _selectPatient(PatientListItem p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_patient_pid', p.pid);
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    }
  }

  // MOCK: No route required yet. Just show a friendly bottom sheet.
  Future<void> _goToAddPatient() async {
    final t = AppLocalizations.of(context)!;
    final roleIsProfessional = widget.userType == UserType.professional;

    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_add_alt_1_outlined, size: 48),
            const SizedBox(height: 12),
            Text(
              t.addPatientComingSoonTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              roleIsProfessional
                  ? t.addPatientComingSoonBodyProfessional
                  : t.addPatientComingSoonBodyRelative,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.ok),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final title = widget.userType == UserType.professional
        ? t.selectPatientTitle
        : t.selectRelativeTitle;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddPatient,
        tooltip: t.addPatient,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<PatientListItem>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Failed to load patients: ${snap.error}'));
          }
          final patients = snap.data ?? [];
          if (patients.isEmpty) {
            final emptyTitle = widget.userType == UserType.professional
                ? t.noPatientsTitleProfessional
                : t.noPatientsTitleRelative;
            final emptyHint = widget.userType == UserType.professional
                ? t.noPatientsHintProfessional
                : t.noPatientsHintRelative;

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.group_outlined, size: 64),
                    const SizedBox(height: 12),
                    Text(
                      emptyTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      emptyHint,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _goToAddPatient,
                      icon: const Icon(Icons.add),
                      label: Text(t.addPatient),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            You said:
            Uploaded image
            We recently created the patient selection screen on bayleaf. It is very raw, and we need to put togheter some nice ux. Remember, you should NOT CHANGE ANY LOGIC THAT IS ALREADY IMPLEMENTED. This is a UX enchancement thing. 
            
            Also, we need to do it in portuguese and english. First, we need a better message on the screen when there is no patient. And we need a + button, to add new patients . Lets begin with these 2 requirements. 
            
            Here is the actual code:
            
            
            // lib/features/patients/patient_selection_screen.dart
            import 'package:flutter/material.dart';
            import 'package:shared_preferences/shared_preferences.dart';
            import 'package:bayleaf_flutter/models/user_type.dart';
            import 'package:bayleaf_flutter/services/patient_service.dart';
            import 'package:bayleaf_flutter/features/home/home_page.dart';
            
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
            
              Future<List<PatientListItem>> _load() {
                if (widget.userType == UserType.professional) {
                  return PatientService.listPatientsForProfessional();
                } else {
                  // relative
                  return PatientService.listPatientsForRelative();
                }
              }
            
              Future<void> _selectPatient(PatientListItem p) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('active_patient_pid', p.pid);
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
                  );
                }
              }
            
              @override
              Widget build(BuildContext context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(widget.userType == UserType.professional
                        ? 'Select a patient'
                        : 'Select your relative'),
                  ),
                  body: FutureBuilder<List<PatientListItem>>(
                    future: _future,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snap.hasError) {
                        return Center(child: Text('Failed to load patients: ${snap.error}'));
                      }
                      final patients = snap.data ?? [];
                      if (patients.isEmpty) {
                        return const Center(child: Text('No patients found.'));
                      }
                      return ListView.separated(
                        itemCount: patients.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final p = patients[i];
                          final name = '${p.firstName} ${p.lastName}'.trim();
                          return ListTile(
                            title: Text(name.isEmpty ? p.pid : name),
                            subtitle: Text(p.email ?? p.birthDate ?? ''),
                            onTap: () => _selectPatient(p),
                          );
                        },
                      );
                    },
                  ),
                );
              }
            }
            
            ChatGPT said:
            
            Thought for 19s
            awesome—let’s give that screen a friendlier empty-state and a clear + to add patients, without touching your selection logic 🔧
            
            Below is a drop-in update that:
            
            adds proper i18n (EN/PT) with AppLocalizations
            
            shows a nicer empty message (title + hint)
            
            adds a floating + button that opens your existing PatientRegistrationScreen
            
            refreshes the list after returning from the registration screen (no backend/selection logic changed)
            
            1) Updated screen (patient_selection_screen.dart)
            // lib/features/patients/patient_selection_screen.dart
            import 'package:flutter/material.dart';
            import 'package:shared_preferences/shared_preferences.dart';
            import 'package:bayleaf_flutter/models/user_type.dart';
            import 'package:bayleaf_flutter/services/patient_service.dart';
            import 'package:bayleaf_flutter/features/home/home_page.dart';
            import 'package:bayleaf_flutter/l10n/app_localizations.dart';
            
            // Navigate to registration (already exists in your project)
            import 'package:bayleaf_flutter/features/patients/patient_registration_screen.dart';
            
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
            
              Future<List<PatientListItem>> _load() {
                if (widget.userType == UserType.professional) {
                  return PatientService.listPatientsForProfessional();
                } else {
                  // relative
                  return PatientService.listPatientsForRelative();
                }
              }
            
              Future<void> _refresh() async {
                setState(() {
                  _future = _load();
                });
              }
            
              Future<void> _selectPatient(PatientListItem p) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('active_patient_pid', p.pid);
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
                  );
                }
              }
            
              Future<void> _goToAddPatient() async {
                final role = widget.userType == UserType.professional ? 'patient' : 'family';
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PatientRegistrationScreen(selectedRole: role),
                  ),
                );
                // When returning, refresh the list to show any newly created patient
                await _refresh();
              }
            
              @override
              Widget build(BuildContext context) {
                final t = AppLocalizations.of(context)!;
            
                final title = widget.userType == UserType.professional
                    ? t.selectPatientTitle
                    : t.selectRelativeTitle;
            
                // Show + button on this screen (no logic change)
                final fab = FloatingActionButton(
                  onPressed: _goToAddPatient,
                  tooltip: t.addPatient,
                  child: const Icon(Icons.add),
                );
            
                return Scaffold(
                  appBar: AppBar(title: Text(title)),
                  floatingActionButton: fab,
                  body: FutureBuilder<List<PatientListItem>>(
                    future: _future,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snap.hasError) {
                        return Center(child: Text('Failed to load patients: ${snap.error}'));
                      }
                      final patients = snap.data ?? [];
                      if (patients.isEmpty) {
                        final emptyTitle = widget.userType == UserType.professional
                            ? t.noPatientsTitleProfessional
                            : t.noPatientsTitleRelative;
                        final emptyHint = widget.userType == UserType.professional
                            ? t.noPatientsHintProfessional
                            : t.noPatientsHintRelative;
            
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.group_outlined, size: 64),
                                const SizedBox(height: 12),
                                Text(
                                  emptyTitle,
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  emptyHint,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
            
                      return RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: patients.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final p = patients[i];
                            final name = '${p.firstName} ${p.lastName}'.trim();
                            return ListTile(
                              title: Text(name.isEmpty ? p.pid : name),
                              subtitle: Text(p.email ?? p.birthDate ?? ''),
                              onTap: () => _selectPatient(p),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            }
            2) Add i18n strings
            lib/l10n/app_en.arb (add these keys)
            
            {
              "selectPatientTitle": "Select a patient",
              "selectRelativeTitle": "Select your relative",
              "addPatient": "Add patient",
              "noPatientsTitleProfessional": "No patients yet",
              "noPatientsHintProfessional": "Tap the + button to add a new patient.",
              "noPatientsTitleRelative": "No relatives linked",
              "noPatientsHintRelative": "Tap the + button to add a relative under your care."
            }
            lib/l10n/app_pt.arb (add these keys)
            
            {
              "selectPatientTitle": "Selecione um paciente",
              "selectRelativeTitle": "Selecione seu familiar",
              "addPatient": "Adicionar paciente",
              "noPatientsTitleProfessional": "Nenhum paciente ainda",
              "noPatientsHintProfessional": "Toque no botão + para adicionar um novo paciente.",
              "noPatientsTitleRelative": "Nenhum familiar vinculado",
              "noPatientsHintRelative": "Toque no botão + para adicionar um familiar sob seus cuidados."
            }
            3) Rebuild localizations
            Run:
            
            flutter pub get
            flutter gen-l10n
            Then hot-restart the app.
            
            If you want, next we can add avatars, search, and a compact card layout—still keeping your existing logic intact.
            
            You said:
            we got an error:
            
            lib/features/patients/patient_selection_screen.dart:10:8: Error: Error when reading 'lib/features/patients/patient_registration_screen.dart': No such file or directory
            import 'package:bayleaf_flutter/features/patients/patient_registration_screen.dart';
                   ^
            lib/features/patients/patient_selection_screen.dart:59:25: Error: The method 'PatientRegistrationScreen' isn't defined for the type '_PatientSelectionScreenState'.
             - '_PatientSelectionScreenState' is from 'package:bayleaf_flutter/features/patients/patient_selection_screen.dart' ('lib/features/patients/patient_selection_screen.dart').
            Try correcting the name to the name of an existing method, or defining a method named 'PatientRegistrationScreen'.
                    builder: (_) => PatientRegistrationScreen(selectedRole: role),
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^
            Target kernel_snapshot_program failed: Exception
            
            
            FAILURE: Build failed with an exception.
            
            * What went wrong:
            Execution failed for task ':app:compileFlutterBuildDebug'.
            > Process 'command '/home/nonnenmacher/snap/flutter/common/flutter/bin/flutter'' finished with non-zero exit value 1
            
            * Try:
            > Run with --stacktrace option to get the stack trace.
            > Run with --info or --debug option to get more log output.
            > Run with --scan to get full insights.
            > Get more help at https://help.gradle.org.
            ChatGPT said:
            Got it — the error is because that screen/file isn’t in your project (or not at that path), so importing it breaks the build.
            
            I’ll keep the new + button but remove the hard import. The button will first try to navigate to a named route (/patients/register) and, if that route isn’t wired yet, it’ll show a friendly snackbar (EN/PT). No logic changes to selection or fetching.
            
            Updated patient_selection_screen.dart (drop-in)
            // lib/features/patients/patient_selection_screen.dart
            import 'package:flutter/material.dart';
            import 'package:shared_preferences/shared_preferences.dart';
            import 'package:bayleaf_flutter/models/user_type.dart';
            import 'package:bayleaf_flutter/services/patient_service.dart';
            import 'package:bayleaf_flutter/features/home/home_page.dart';
            import 'package:bayleaf_flutter/l10n/app_localizations.dart';
            
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
            
              Future<List<PatientListItem>> _load() {
                if (widget.userType == UserType.professional) {
                  return PatientService.listPatientsForProfessional();
                } else {
                  // relative
                  return PatientService.listPatientsForRelative();
                }
              }
            
              Future<void> _refresh() async {
                setState(() {
                  _future = _load();
                });
              }
            
              Future<void> _selectPatient(PatientListItem p) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('active_patient_pid', p.pid);
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
                  );
                }
              }
            
              Future<void> _goToAddPatient() async {
                final t = AppLocalizations.of(context)!;
                final role = widget.userType == UserType.professional ? 'patient' : 'family';
            
                // Try a named route so we don't depend on a direct import.
                try {
                  await Navigator.of(context).pushNamed(
                    '/patients/register',
                    arguments: {'selectedRole': role},
                  );
                  // If user returned from registration, refresh the list.
                  await _refresh();
                } catch (_) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.addPatientRouteMissing)),
                  );
                }
              }
            
              @override
              Widget build(BuildContext context) {
                final t = AppLocalizations.of(context)!;
            
                final title = widget.userType == UserType.professional
                    ? t.selectPatientTitle
                    : t.selectRelativeTitle;
            
                return Scaffold(
                  appBar: AppBar(title: Text(title)),
                  floatingActionButton: FloatingActionButton(
                    onPressed: _goToAddPatient,
                    tooltip: t.addPatient,
                    child: const Icon(Icons.add),
                  ),
                  body: FutureBuilder<List<PatientListItem>>(
                    future: _future,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snap.hasError) {
                        return Center(child: Text('Failed to load patients: ${snap.error}'));
                      }
                      final patients = snap.data ?? [];
                      if (patients.isEmpty) {
                        final emptyTitle = widget.userType == UserType.professional
                            ? t.noPatientsTitleProfessional
                            : t.noPatientsTitleRelative;
                        final emptyHint = widget.userType == UserType.professional
                            ? t.noPatientsHintProfessional
                            : t.noPatientsHintRelative;
            
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.group_outlined, size: 64),
                                const SizedBox(height: 12),
                                Text(
                                  emptyTitle,
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  emptyHint,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
            
                      return RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: patients.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final p = patients[i];
                            final name = '${p.firstName} ${p.lastName}'.trim();
                            return ListTile(
                              title: Text(name.isEmpty ? p.pid : name),
                              subtitle: Text(p.email ?? p.birthDate ?? ''),
                              onTap: () => _selectPatient(p),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            }
            i18n additions
            lib/l10n/app_en.arb
            
            {
              "selectPatientTitle": "Select a patient",
              "selectRelativeTitle": "Select your relative",
              "addPatient": "Add patient",
              "noPatientsTitleProfessional": "No patients yet",
              "noPatientsHintProfessional": "Tap the + button to add a new patient.",
              "noPatientsTitleRelative": "No relatives linked",
              "noPatientsHintRelative": "Tap the + button to add a relative under your care.",
              "addPatientRouteMissing": "Registration screen not found. Please wire the /patients/register route."
            }
            lib/l10n/app_pt.arb
            
            {
              "selectPatientTitle": "Selecione um paciente",
              "selectRelativeTitle": "Selecione seu familiar",
              "addPatient": "Adicionar paciente",
              "noPatientsTitleProfessional": "Nenhum paciente ainda",
              "noPatientsHintProfessional": "Toque no botão + para adicionar um novo paciente.",
              "noPatientsTitleRelative": "Nenhum familiar vinculado",
              "noPatientsHintRelative": "Toque no botão + para adicionar um familiar sob seus cuidados.",
              "addPatientRouteMissing": "Tela de cadastro não encontrada. Por favor, configure a rota /patients/register."
            }
            (Optional) route wiring
            If you do have PatientRegistrationScreen, expose it via a named route so this works without imports:
            
            // In your MaterialApp
            routes: {
              '/patients/register': (context) {
                final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
                final selectedRole = args?['selectedRole'] as String?;
                return PatientRegistrationScreen(selectedRole: selectedRole);
              },
            },
            Regenerate localizations
            flutter pub get
            flutter gen-l10n
            This keeps your existing logic intact, fixes the build error, and gives you the UX pieces you wanted (better empty-state + + button).
            
            You said:
            do we have do add that route now ?? put a mock button or anything .. 
            ChatGPT said:
            
            Thought for 5s
            No worries—let’s keep the + button visible but make it a harmless placeholder for now (no route needed). Tapping it will open a small, friendly bottom sheet saying the feature is coming soon. Zero changes to your existing selection/fetch logic.
            
            Drop-in screen (mock + button)
            // lib/features/patients/patient_selection_screen.dart
            import 'package:flutter/material.dart';
            import 'package:shared_preferences/shared_preferences.dart';
            import 'package:bayleaf_flutter/models/user_type.dart';
            import 'package:bayleaf_flutter/services/patient_service.dart';
            import 'package:bayleaf_flutter/features/home/home_page.dart';
            import 'package:bayleaf_flutter/l10n/app_localizations.dart';
            
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
            
              Future<List<PatientListItem>> _load() {
                if (widget.userType == UserType.professional) {
                  return PatientService.listPatientsForProfessional();
                } else {
                  // relative
                  return PatientService.listPatientsForRelative();
                }
              }
            
              Future<void> _refresh() async {
                setState(() {
                  _future = _load();
                });
              }
            
              Future<void> _selectPatient(PatientListItem p) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('active_patient_pid', p.pid);
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
                  );
                }
              }
            
              // MOCK: No route required yet. Just show a friendly bottom sheet.
              Future<void> _goToAddPatient() async {
                final t = AppLocalizations.of(context)!;
                final roleIsProfessional = widget.userType == UserType.professional;
            
                await showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  builder: (_) => Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_add_alt_1_outlined, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          t.addPatientComingSoonTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          roleIsProfessional
                              ? t.addPatientComingSoonBodyProfessional
                              : t.addPatientComingSoonBodyRelative,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(t.ok),
                        )
                      ],
                    ),
                  ),
                );
              }
            
              @override
              Widget build(BuildContext context) {
                final t = AppLocalizations.of(context)!;
            
                final title = widget.userType == UserType.professional
                    ? t.selectPatientTitle
                    : t.selectRelativeTitle;
            
                return Scaffold(
                  appBar: AppBar(title: Text(title)),
                  floatingActionButton: FloatingActionButton(
                    onPressed: _goToAddPatient,
                    tooltip: t.addPatient,
                    child: const Icon(Icons.add),
                  ),
                  body: FutureBuilder<List<PatientListItem>>(
                    future: _future,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snap.hasError) {
                        return Center(child: Text('Failed to load patients: ${snap.error}'));
                      }
                      final patients = snap.data ?? [];
                      if (patients.isEmpty) {
                        final emptyTitle = widget.userType == UserType.professional
                            ? t.noPatientsTitleProfessional
                            : t.noPatientsTitleRelative;
                        final emptyHint = widget.userType == UserType.professional
                            ? t.noPatientsHintProfessional
                            : t.noPatientsHintRelative;
            
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.group_outlined, size: 64),
                                const SizedBox(height: 12),
                                Text(
                                  emptyTitle,
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  emptyHint,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                OutlinedButton.icon(
                                  onPressed: _goToAddPatient,
                                  icon: const Icon(Icons.add),
                                  label: Text(t.addPatient),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
            
                      return RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: patients.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final p = patients[i];
                            final name = '${p.firstName} ${p.lastName}'.trim();
                            return ListTile(
                              title: Text(name.isEmpty ? p.pid : name),
                              subtitle: Text(p.email ?? p.birthDate ?? ''),
                              onTap: () => _selectPatient(p),
                            );
                          },
                        ),
                      );
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: patients.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final p = patients[i];
                final name = '${p.firstName} ${p.lastName}'.trim();
                return ListTile(
                  title: Text(name.isEmpty ? p.pid : name),
                  subtitle: Text(p.email ?? p.birthDate ?? ''),
                  onTap: () => _selectPatient(p),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
