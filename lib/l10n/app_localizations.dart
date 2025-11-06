import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to CuidaDora'**
  String get welcome;

  /// No description provided for @systemUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Our system is currently unavailable. Please try again later.'**
  String get systemUnavailable;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginFailed;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @minPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get minPasswordLength;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @registerPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register here'**
  String get registerPrompt;

  /// No description provided for @registrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your patient account'**
  String get registrationTitle;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get enterFirstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter last name'**
  String get enterLastName;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date (DD/MM/YYYY)'**
  String get birthDate;

  /// No description provided for @enterBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Enter birth date'**
  String get enterBirthDate;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @invalidBirthDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid birth date format'**
  String get invalidBirthDateFormat;

  /// No description provided for @menuBayleaf.
  ///
  /// In en, this message translates to:
  /// **'Dora'**
  String get menuBayleaf;

  /// No description provided for @menuMedications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get menuMedications;

  /// No description provided for @menuAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get menuAppointments;

  /// No description provided for @menuExams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get menuExams;

  /// No description provided for @menuDoctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get menuDoctors;

  /// No description provided for @menuTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get menuTreatment;

  /// No description provided for @menuOrientations.
  ///
  /// In en, this message translates to:
  /// **'Orientations'**
  String get menuOrientations;

  /// No description provided for @appointmentsUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get appointmentsUpcoming;

  /// No description provided for @appointmentsPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get appointmentsPast;

  /// No description provided for @appointmentsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get appointmentsLoading;

  /// No description provided for @appointmentsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get appointmentsToday;

  /// No description provided for @appointmentsTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get appointmentsTomorrow;

  /// No description provided for @appointmentsInXDays.
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String appointmentsInXDays(Object days);

  /// No description provided for @appointmentsNoneUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming appointments yet'**
  String get appointmentsNoneUpcoming;

  /// No description provided for @appointmentsNoneUpcomingDesc.
  ///
  /// In en, this message translates to:
  /// **'Book your next visit and stay on top of your health.'**
  String get appointmentsNoneUpcomingDesc;

  /// No description provided for @appointmentsNonePast.
  ///
  /// In en, this message translates to:
  /// **'You haven’t had any appointments yet'**
  String get appointmentsNonePast;

  /// No description provided for @appointmentsNonePastDesc.
  ///
  /// In en, this message translates to:
  /// **'Once you complete a visit, it’ll appear here.'**
  String get appointmentsNonePastDesc;

  /// No description provided for @appointmentsBookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get appointmentsBookAppointment;

  /// No description provided for @appointmentsReschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get appointmentsReschedule;

  /// No description provided for @appointmentsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get appointmentsCancel;

  /// No description provided for @appointmentsBookAgain.
  ///
  /// In en, this message translates to:
  /// **'Book Again'**
  String get appointmentsBookAgain;

  /// No description provided for @appointmentsUnknownDoctor.
  ///
  /// In en, this message translates to:
  /// **'Unknown Doctor'**
  String get appointmentsUnknownDoctor;

  /// No description provided for @appointmentsGeneralPractitioner.
  ///
  /// In en, this message translates to:
  /// **'General Practitioner'**
  String get appointmentsGeneralPractitioner;

  /// No description provided for @appointmentsClinicName.
  ///
  /// In en, this message translates to:
  /// **'Clinic Name'**
  String get appointmentsClinicName;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get statusRequested;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @vaccinesTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccines'**
  String get vaccinesTabTitle;

  /// No description provided for @vaccinesUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Vaccines'**
  String get vaccinesUpcoming;

  /// No description provided for @vaccinesTaken.
  ///
  /// In en, this message translates to:
  /// **'Vaccines Taken'**
  String get vaccinesTaken;

  /// No description provided for @tooltipAddMedication.
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get tooltipAddMedication;

  /// No description provided for @tooltipAddVaccine.
  ///
  /// In en, this message translates to:
  /// **'Add Vaccine'**
  String get tooltipAddVaccine;

  /// No description provided for @medicationsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load medications. Pull to refresh or try again later.'**
  String get medicationsLoadError;

  /// No description provided for @medicationsNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No medications yet'**
  String get medicationsNoneTitle;

  /// No description provided for @medicationsNoneDesc.
  ///
  /// In en, this message translates to:
  /// **'When your doctor prescribes a medication, it will appear here.'**
  String get medicationsNoneDesc;

  /// No description provided for @medicationFallback.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medicationFallback;

  /// No description provided for @everyXHours.
  ///
  /// In en, this message translates to:
  /// **'Every {hours}h'**
  String everyXHours(String hours);

  /// No description provided for @asPrescribed.
  ///
  /// In en, this message translates to:
  /// **'As prescribed'**
  String get asPrescribed;

  /// No description provided for @totalUnits.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String totalUnits(String amount);

  /// No description provided for @brandCuidaDora.
  ///
  /// In en, this message translates to:
  /// **'CuidaDora'**
  String get brandCuidaDora;

  /// No description provided for @doraHelloTitle.
  ///
  /// In en, this message translates to:
  /// **'Hi, I’m Dora'**
  String get doraHelloTitle;

  /// No description provided for @doraHelloSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I’ll guide you through your first steps.'**
  String get doraHelloSubtitle;

  /// No description provided for @iAmNewHere.
  ///
  /// In en, this message translates to:
  /// **'I’m new here'**
  String get iAmNewHere;

  /// No description provided for @iAlreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get iAlreadyHaveAnAccount;

  /// No description provided for @roleDefTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your role'**
  String get roleDefTitle;

  /// No description provided for @roleDefSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us personalize your experience.'**
  String get roleDefSubtitle;

  /// No description provided for @roleDefPatientTitle.
  ///
  /// In en, this message translates to:
  /// **'I am following a medical treatment'**
  String get roleDefPatientTitle;

  /// No description provided for @roleDefPatientSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I need assistance to organize my care.'**
  String get roleDefPatientSubtitle;

  /// No description provided for @roleDefFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'I am a family member or legal guardian'**
  String get roleDefFamilyTitle;

  /// No description provided for @roleDefFamilySubtitle.
  ///
  /// In en, this message translates to:
  /// **'I help one or more patients with their care.'**
  String get roleDefFamilySubtitle;

  /// No description provided for @roleDefCaregiverTitle.
  ///
  /// In en, this message translates to:
  /// **'I am a caregiver'**
  String get roleDefCaregiverTitle;

  /// No description provided for @roleDefCaregiverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I take care of one or more patients.'**
  String get roleDefCaregiverSubtitle;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @acceptTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Accept Terms of Use of Cuida Dora'**
  String get acceptTermsOfUse;

  /// No description provided for @viewTerms.
  ///
  /// In en, this message translates to:
  /// **'View Terms of use.'**
  String get viewTerms;

  /// No description provided for @selectPatientTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your patient'**
  String get selectPatientTitle;

  /// No description provided for @selectRelativeTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your relative'**
  String get selectRelativeTitle;

  /// No description provided for @addPatient.
  ///
  /// In en, this message translates to:
  /// **'Add patient'**
  String get addPatient;

  /// No description provided for @noPatientsTitleProfessional.
  ///
  /// In en, this message translates to:
  /// **'No patients linked'**
  String get noPatientsTitleProfessional;

  /// No description provided for @noPatientsHintProfessional.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add a patient under your care.'**
  String get noPatientsHintProfessional;

  /// No description provided for @noPatientsTitleRelative.
  ///
  /// In en, this message translates to:
  /// **'No relatives linked'**
  String get noPatientsTitleRelative;

  /// No description provided for @noPatientsHintRelative.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add a relative under your care.'**
  String get noPatientsHintRelative;

  /// No description provided for @addPatientComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Add patient'**
  String get addPatientComingSoonTitle;

  /// No description provided for @addPatientComingSoonBodyProfessional.
  ///
  /// In en, this message translates to:
  /// **'This feature will be available soon. For now, you can continue using the app and select a patient later.'**
  String get addPatientComingSoonBodyProfessional;

  /// No description provided for @addPatientComingSoonBodyRelative.
  ///
  /// In en, this message translates to:
  /// **'This feature will be available soon. For now, you can continue and link a family member later.'**
  String get addPatientComingSoonBodyRelative;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @doraChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with Dora'**
  String get doraChatTitle;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @profile_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profile_edit_title;

  /// No description provided for @profile_edit_mode.
  ///
  /// In en, this message translates to:
  /// **'You\'re now editing your profile'**
  String get profile_edit_mode;

  /// No description provided for @profile_update_success.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profile_update_success;

  /// No description provided for @profile_update_fail.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile.'**
  String get profile_update_fail;

  /// No description provided for @profile_tabs_personal.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get profile_tabs_personal;

  /// No description provided for @profile_tabs_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profile_tabs_address;

  /// No description provided for @profile_tabs_financial.
  ///
  /// In en, this message translates to:
  /// **'Financials'**
  String get profile_tabs_financial;

  /// No description provided for @profile_first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get profile_first_name;

  /// No description provided for @profile_last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get profile_last_name;

  /// No description provided for @profile_date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get profile_date_of_birth;

  /// No description provided for @profile_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profile_email;

  /// No description provided for @profile_street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get profile_street;

  /// No description provided for @profile_city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get profile_city;

  /// No description provided for @profile_zip.
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get profile_zip;

  /// No description provided for @profile_state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get profile_state;

  /// No description provided for @profile_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get profile_forgot_password;

  /// No description provided for @profile_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_logout;

  /// No description provided for @profile_logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get profile_logout_confirm;

  /// No description provided for @profile_financial_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Financial info not implemented yet.'**
  String get profile_financial_placeholder;

  /// No description provided for @profile_unknown_tab.
  ///
  /// In en, this message translates to:
  /// **'Unknown tab selected.'**
  String get profile_unknown_tab;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
