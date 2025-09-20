// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome to Bayleaf';

  @override
  String get systemUnavailable =>
      'Our system is currently unavailable. Please try again later.';

  @override
  String get loginFailed => 'Login failed. Please check your credentials.';

  @override
  String get email => 'Email';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get password => 'Password';

  @override
  String get minPasswordLength => 'Minimum 6 characters';

  @override
  String get login => 'Login';

  @override
  String get registerPrompt => 'Don\'t have an account? Register here';

  @override
  String get registrationTitle => 'Create your patient account';

  @override
  String get firstName => 'First Name';

  @override
  String get enterFirstName => 'Enter first name';

  @override
  String get lastName => 'Last Name';

  @override
  String get enterLastName => 'Enter last name';

  @override
  String get birthDate => 'Birth Date (DD/MM/YYYY)';

  @override
  String get enterBirthDate => 'Enter birth date';

  @override
  String get register => 'Register';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get invalidBirthDateFormat => 'Invalid birth date format';

  @override
  String get menuBayleaf => 'Bayleaf';

  @override
  String get menuMedications => 'Medications';

  @override
  String get menuAppointments => 'Appointments';

  @override
  String get menuExams => 'Exams';

  @override
  String get menuDoctors => 'Doctors';

  @override
  String get appointmentsUpcoming => 'Upcoming';

  @override
  String get appointmentsPast => 'Past';

  @override
  String get appointmentsLoading => 'Loading...';

  @override
  String get appointmentsToday => 'Today';

  @override
  String get appointmentsTomorrow => 'Tomorrow';

  @override
  String appointmentsInXDays(Object days) {
    return 'In $days days';
  }

  @override
  String get appointmentsNoneUpcoming => 'No upcoming appointments yet';

  @override
  String get appointmentsNoneUpcomingDesc =>
      'Book your next visit and stay on top of your health.';

  @override
  String get appointmentsNonePast => 'You haven’t had any appointments yet';

  @override
  String get appointmentsNonePastDesc =>
      'Once you complete a visit, it’ll appear here.';

  @override
  String get appointmentsBookAppointment => 'Book Appointment';

  @override
  String get appointmentsReschedule => 'Reschedule';

  @override
  String get appointmentsCancel => 'Cancel';

  @override
  String get appointmentsBookAgain => 'Book Again';

  @override
  String get appointmentsUnknownDoctor => 'Unknown Doctor';

  @override
  String get appointmentsGeneralPractitioner => 'General Practitioner';

  @override
  String get appointmentsClinicName => 'Clinic Name';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusRequested => 'Requested';

  @override
  String get statusCancelled => 'Cancelled';
}
