import 'package:bayleaf_flutter/features/auth/welcome_dora_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'package:bayleaf_flutter/core/config.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';
import 'package:bayleaf_flutter/theme/app_colors.dart';

// Screens
import 'package:bayleaf_flutter/features/auth/login_screen.dart';
import 'package:bayleaf_flutter/features/home/home_page.dart';
import 'package:bayleaf_flutter/features/patients/patient_selection_screen.dart';

// USER TYPE ENUM + HELPER
import 'package:bayleaf_flutter/models/user_type.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BayleafApp());
}

class BayleafApp extends StatelessWidget {
  const BayleafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bayleaf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const _StartupGate(),
    );
  }
}

/// Decides where to send the user on startup:
/// - No token -> Login
/// - Token + cached user_type -> route by user_type
/// - Token + no cached user_type -> fetch /api/users/me/type/ then route
class _StartupGate extends StatefulWidget {
  const _StartupGate({super.key});

  @override
  State<_StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<_StartupGate> {
  // Pref keys (aligned with Login/Registration)
  static const _kAuthToken = 'authToken';
  static const _kRefreshToken = 'refreshToken';
  static const _kUserType = 'user_type';
  static const _kUserId = 'user_id';
  static const _kPatientPid = 'patient_pid';

  bool _loading = true;
  String? _fatalError;

  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final access = prefs.getString(_kAuthToken);

      if (access == null || access.isEmpty) {
        _goLogin();
        return;
      }

      // If we already cached the user_type, route immediately.
      var userTypeStr = prefs.getString(_kUserType);
      if (userTypeStr == null || userTypeStr.isEmpty) {
        // Fetch it now
        try {
          final dio = Dio(BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            headers: {'Authorization': 'Bearer $access'},
          ));
          final r = await dio.get('/api/users/me/type/');
          final data = r.data as Map<String, dynamic>;
          userTypeStr = (data['user_type'] as String?) ?? 'patient';

          final ids = (data['ids'] as Map?) ?? {};
          final userId = ids['user_id'] as int?;
          final patientPid = ids['patient_pid'] as String?;

          await prefs.setString(_kUserType, userTypeStr!);
          if (userId != null) await prefs.setInt(_kUserId, userId);
          if (patientPid != null) await prefs.setString(_kPatientPid, patientPid);
        } on DioException catch (e) {
          if (e.response?.statusCode == 401) {
            await _clearAuth();
            _goLogin();
            return;
          }
          // For other errors, fall back to patient home (won't block the app)
          userTypeStr = 'patient';
        } catch (_) {
          userTypeStr = 'patient';
        }
      }

      _routeByUserType(userTypeStr ?? 'patient');
    } catch (e) {
      setState(() {
        _fatalError = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAuthToken);
    await prefs.remove(_kRefreshToken);
    await prefs.remove(_kUserType);
    await prefs.remove(_kUserId);
    await prefs.remove(_kPatientPid);
  }

  void _routeByUserType(String userTypeStr) {
    if (!mounted) return;

    final ut = userTypeFromString(userTypeStr);

    Widget dest;
    if (ut == UserType.professional || ut == UserType.relative) {
      dest = PatientSelectionScreen(userType: ut);
    } else {
      dest = const HomePage();
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => dest),
      (route) => false,
    );
  }

  void _goLogin() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeDoraScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    if (_loading) {
      return Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryLight, AppColors.background],
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_fatalError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  loc?.systemUnavailable ?? 'Something went wrong.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                Text(
                  _fatalError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _fatalError = null;
                      _loading = true;
                    });
                    _decide();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Should never render; navigation happens in _decide()
    return const SizedBox.shrink();
  }
}
