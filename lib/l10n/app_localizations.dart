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
  /// **'Welcome to Bayleaf'**
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
  /// **'Bayleaf'**
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
