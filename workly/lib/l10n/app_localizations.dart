import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Workly'**
  String get appTitle;

  /// No description provided for @welcomeToWorkly.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Workly'**
  String get welcomeToWorkly;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pleaseEnterEmailAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter email and password'**
  String get pleaseEnterEmailAndPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @continueWithGitHub.
  ///
  /// In en, this message translates to:
  /// **'Continue with GitHub'**
  String get continueWithGitHub;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @registerNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Register New Account'**
  String get registerNewAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @passwordMinCharacters.
  ///
  /// In en, this message translates to:
  /// **'Password (min 6 characters)'**
  String get passwordMinCharacters;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @passwordMustBe6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBe6Characters;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! A verification email has been sent to your email address. Please check your inbox and spam folder.'**
  String get registrationSuccessful;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyYourEmail;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'A verification link has been sent to:'**
  String get verificationEmailSent;

  /// No description provided for @checkEmailAndSpam.
  ///
  /// In en, this message translates to:
  /// **'Please check your email and click the verification link before logging in.\n\nDon\'t forget to check your spam folder!'**
  String get checkEmailAndSpam;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get resendEmail;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @verificationEmailSentAgain.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent again!'**
  String get verificationEmailSentAgain;

  /// No description provided for @failedToResendEmail.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend email.'**
  String get failedToResendEmail;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error'**
  String get unexpectedError;

  /// No description provided for @googleSignInCanceled.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In canceled'**
  String get googleSignInCanceled;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In failed'**
  String get googleSignInFailed;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @appleSignInNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Apple Sign-In is not available on this device'**
  String get appleSignInNotAvailable;

  /// No description provided for @appleSignInCanceled.
  ///
  /// In en, this message translates to:
  /// **'Apple Sign-In was canceled'**
  String get appleSignInCanceled;

  /// No description provided for @appleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Apple Sign-In failed'**
  String get appleSignInFailed;

  /// No description provided for @githubSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'GitHub Sign-In failed'**
  String get githubSignInFailed;

  /// No description provided for @accountExistsWithDifferentCredential.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with the same email address'**
  String get accountExistsWithDifferentCredential;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredentials;

  /// No description provided for @operationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Sign-In is not enabled'**
  String get operationNotAllowed;

  /// No description provided for @userDisabled.
  ///
  /// In en, this message translates to:
  /// **'This user has been disabled'**
  String get userDisabled;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get wrongPassword;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created! Please verify your email.'**
  String get accountCreated;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @companyCode.
  ///
  /// In en, this message translates to:
  /// **'Company Code'**
  String get companyCode;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @iban.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get iban;

  /// No description provided for @uploadId.
  ///
  /// In en, this message translates to:
  /// **'Upload ID Image'**
  String get uploadId;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully!'**
  String get profileSaved;

  /// No description provided for @tapToUploadId.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload ID'**
  String get tapToUploadId;

  /// No description provided for @errorEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get errorEnterName;

  /// No description provided for @errorEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter your company code'**
  String get errorEnterCode;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get idNumber;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @rejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your request has been rejected'**
  String get rejectedTitle;

  /// No description provided for @rejectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, your request was rejected by the admin. Please review your information or contact support.'**
  String get rejectedMessage;

  /// No description provided for @pendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your request is under review'**
  String get pendingTitle;

  /// No description provided for @pendingMessage.
  ///
  /// In en, this message translates to:
  /// **'We have received your information successfully. Please wait until the admin reviews and approves your request.'**
  String get pendingMessage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @errorSelectBirth.
  ///
  /// In en, this message translates to:
  /// **'Please select your birth date'**
  String get errorSelectBirth;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Workly 🌞'**
  String get home;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOut;

  /// No description provided for @totalHours.
  ///
  /// In en, this message translates to:
  /// **'Total hours'**
  String get totalHours;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @withinCompany.
  ///
  /// In en, this message translates to:
  /// **'Within Company ✅'**
  String get withinCompany;

  /// No description provided for @outsideCompany.
  ///
  /// In en, this message translates to:
  /// **'Outside Company ❌'**
  String get outsideCompany;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @todayAttendance.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Attendance'**
  String get todayAttendance;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @warningNearCompany.
  ///
  /// In en, this message translates to:
  /// **'Warning: You must be near the company to check in.'**
  String get warningNearCompany;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @attendanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Attendance History'**
  String get attendanceHistory;

  /// No description provided for @monthlySchedule.
  ///
  /// In en, this message translates to:
  /// **'Monthly Schedule'**
  String get monthlySchedule;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get myRequests;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @customization.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMIZATION'**
  String get customization;

  /// No description provided for @changeAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get changeAppLanguage;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @enableDisableDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Enable/Disable dark mode'**
  String get enableDisableDarkMode;

  /// No description provided for @notificationsAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS & SECURITY'**
  String get notificationsAndSecurity;

  /// No description provided for @manageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Manage notifications'**
  String get manageNotifications;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(Object version);

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @howToUseApp.
  ///
  /// In en, this message translates to:
  /// **'How to use the app?'**
  String get howToUseApp;

  /// No description provided for @howToUseAppAnswer.
  ///
  /// In en, this message translates to:
  /// **'You can navigate through the app using the bottom navigation bar or the side drawer.'**
  String get howToUseAppAnswer;

  /// No description provided for @isMyDataSecure.
  ///
  /// In en, this message translates to:
  /// **'Is my data secure?'**
  String get isMyDataSecure;

  /// No description provided for @isMyDataSecureAnswer.
  ///
  /// In en, this message translates to:
  /// **'Yes, we take privacy seriously and store your data securely.'**
  String get isMyDataSecureAnswer;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @emailUs.
  ///
  /// In en, this message translates to:
  /// **'Email us'**
  String get emailUs;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'support@example.com'**
  String get emailAddress;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call us'**
  String get callUs;

  /// No description provided for @phoneNumbersupport.
  ///
  /// In en, this message translates to:
  /// **'+123 456 789'**
  String get phoneNumbersupport;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personalInfo;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profilePicture;

  /// No description provided for @monthlyScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Monthly Schedule'**
  String get monthlyScheduleTitle;

  /// No description provided for @noEvents.
  ///
  /// In en, this message translates to:
  /// **'No events available this month'**
  String get noEvents;

  /// No description provided for @eventDetails.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetails;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'previous'**
  String get previous;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @addEvent.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get addEvent;

  /// No description provided for @eventText.
  ///
  /// In en, this message translates to:
  /// **'Event text'**
  String get eventText;

  /// No description provided for @eventReminder.
  ///
  /// In en, this message translates to:
  /// **'Event Reminder'**
  String get eventReminder;

  /// No description provided for @eventTime.
  ///
  /// In en, this message translates to:
  /// **'Event time'**
  String get eventTime;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @loginToViewRecords.
  ///
  /// In en, this message translates to:
  /// **'Please login to view records'**
  String get loginToViewRecords;

  /// No description provided for @noDataForMonth.
  ///
  /// In en, this message translates to:
  /// **'No records for this month'**
  String get noDataForMonth;

  /// No description provided for @filterByMonth.
  ///
  /// In en, this message translates to:
  /// **'Filter by month:'**
  String get filterByMonth;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @unknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown location'**
  String get unknownLocation;

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'Error fetching location'**
  String get locationError;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @pleaseLoginToViewRecords.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view records'**
  String get pleaseLoginToViewRecords;

  /// No description provided for @noRecordsInThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No records in this month'**
  String get noRecordsInThisMonth;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @totalWorkHours.
  ///
  /// In en, this message translates to:
  /// **'Total Work Hours'**
  String get totalWorkHours;

  /// No description provided for @notCheckedOutYet.
  ///
  /// In en, this message translates to:
  /// **'Not checked out yet'**
  String get notCheckedOutYet;

  /// No description provided for @noLocation.
  ///
  /// In en, this message translates to:
  /// **'No location recorded'**
  String get noLocation;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Locating...'**
  String get locating;

  /// No description provided for @workDayDetails.
  ///
  /// In en, this message translates to:
  /// **'Work Day Details'**
  String get workDayDetails;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @tapForDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap to view details'**
  String get tapForDetails;

  /// No description provided for @allFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'All fields must be filled'**
  String get allFieldsRequired;

  /// No description provided for @fillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get fillAllRequiredFields;

  /// No description provided for @failedToLoadUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user'**
  String get failedToLoadUser;

  /// No description provided for @failedToSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile'**
  String get failedToSaveProfile;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied forever'**
  String get locationPermissionDeniedForever;

  /// No description provided for @errorGettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Error getting location'**
  String get errorGettingLocation;

  /// No description provided for @setCompanyLocationFirst.
  ///
  /// In en, this message translates to:
  /// **'Please set your company location before saving'**
  String get setCompanyLocationFirst;

  /// No description provided for @useGps.
  ///
  /// In en, this message translates to:
  /// **'Use GPS for company location'**
  String get useGps;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
