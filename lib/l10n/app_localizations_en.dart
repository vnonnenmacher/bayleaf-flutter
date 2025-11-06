// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome to CuidaDora';

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
  String get menuBayleaf => 'Dora';

  @override
  String get menuMedications => 'Medications';

  @override
  String get menuAppointments => 'Appointments';

  @override
  String get menuExams => 'Exams';

  @override
  String get menuDoctors => 'Doctors';

  @override
  String get menuTreatment => 'Treatment';

  @override
  String get menuOrientations => 'Orientations';

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

  @override
  String get vaccinesTabTitle => 'Vaccines';

  @override
  String get vaccinesUpcoming => 'Upcoming Vaccines';

  @override
  String get vaccinesTaken => 'Vaccines Taken';

  @override
  String get tooltipAddMedication => 'Add Medication';

  @override
  String get tooltipAddVaccine => 'Add Vaccine';

  @override
  String get medicationsLoadError =>
      'Couldn’t load medications. Pull to refresh or try again later.';

  @override
  String get medicationsNoneTitle => 'No medications yet';

  @override
  String get medicationsNoneDesc =>
      'When your doctor prescribes a medication, it will appear here.';

  @override
  String get medicationFallback => 'Medication';

  @override
  String everyXHours(String hours) {
    return 'Every ${hours}h';
  }

  @override
  String get asPrescribed => 'As prescribed';

  @override
  String totalUnits(String amount) {
    return 'Total: $amount';
  }

  @override
  String get brandCuidaDora => 'CuidaDora';

  @override
  String get doraHelloTitle => 'Hi, I’m Dora';

  @override
  String get doraHelloSubtitle => 'I’ll guide you through your first steps.';

  @override
  String get iAmNewHere => 'I’m new here';

  @override
  String get iAlreadyHaveAnAccount => 'I already have an account';

  @override
  String get roleDefTitle => 'Choose your role';

  @override
  String get roleDefSubtitle => 'This helps us personalize your experience.';

  @override
  String get roleDefPatientTitle => 'I am following a medical treatment';

  @override
  String get roleDefPatientSubtitle => 'I need assistance to organize my care.';

  @override
  String get roleDefFamilyTitle => 'I am a family member or legal guardian';

  @override
  String get roleDefFamilySubtitle =>
      'I help one or more patients with their care.';

  @override
  String get roleDefCaregiverTitle => 'I am a caregiver';

  @override
  String get roleDefCaregiverSubtitle => 'I take care of one or more patients.';

  @override
  String get back => 'Back';

  @override
  String get acceptTermsOfUse => 'Accept Terms of Use of Cuida Dora';

  @override
  String get viewTerms => 'View Terms of use.';

  @override
  String get selectPatientTitle => 'Select your patient';

  @override
  String get selectRelativeTitle => 'Select your relative';

  @override
  String get addPatient => 'Add patient';

  @override
  String get noPatientsTitleProfessional => 'No patients linked';

  @override
  String get noPatientsHintProfessional =>
      'Tap the + button to add a patient under your care.';

  @override
  String get noPatientsTitleRelative => 'No relatives linked';

  @override
  String get noPatientsHintRelative =>
      'Tap the + button to add a relative under your care.';

  @override
  String get addPatientComingSoonTitle => 'Add patient';

  @override
  String get addPatientComingSoonBodyProfessional =>
      'This feature will be available soon. For now, you can continue using the app and select a patient later.';

  @override
  String get addPatientComingSoonBodyRelative =>
      'This feature will be available soon. For now, you can continue and link a family member later.';

  @override
  String get ok => 'OK';

  @override
  String get doraChatTitle => 'Chat with Dora';

  @override
  String get typeYourMessage => 'Type your message...';

  @override
  String get profile_title => 'Profile';

  @override
  String get profile_edit_title => 'Edit Profile';

  @override
  String get profile_edit_mode => 'You\'re now editing your profile';

  @override
  String get profile_update_success => 'Profile updated successfully!';

  @override
  String get profile_update_fail => 'Failed to update profile.';

  @override
  String get profile_tabs_personal => 'Personal Info';

  @override
  String get profile_tabs_address => 'Address';

  @override
  String get profile_tabs_financial => 'Financials';

  @override
  String get profile_first_name => 'First Name';

  @override
  String get profile_last_name => 'Last Name';

  @override
  String get profile_date_of_birth => 'Date of Birth';

  @override
  String get profile_email => 'Email';

  @override
  String get profile_street => 'Street';

  @override
  String get profile_city => 'City';

  @override
  String get profile_zip => 'ZIP Code';

  @override
  String get profile_state => 'State';

  @override
  String get profile_forgot_password => 'Forgot Password';

  @override
  String get profile_logout => 'Logout';

  @override
  String get profile_logout_confirm => 'Are you sure you want to logout?';

  @override
  String get profile_financial_placeholder =>
      'Financial info not implemented yet.';

  @override
  String get profile_unknown_tab => 'Unknown tab selected.';
}
