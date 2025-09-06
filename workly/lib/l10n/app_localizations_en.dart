// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Workly';

  @override
  String get welcomeToWorkly => 'Welcome to Workly';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get pleaseEnterEmailAndPassword => 'Please enter email and password';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGitHub => 'Continue with GitHub';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get registerNewAccount => 'Register New Account';

  @override
  String get fullName => 'Full Name';

  @override
  String get register => 'Register';

  @override
  String get passwordMinCharacters => 'Password (min 6 characters)';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get passwordMustBe6Characters =>
      'Password must be at least 6 characters';

  @override
  String get registrationSuccessful =>
      'Registration successful! A verification email has been sent to your email address. Please check your inbox and spam folder.';

  @override
  String get verifyYourEmail => 'Verify Your Email';

  @override
  String get verificationEmailSent => 'A verification link has been sent to:';

  @override
  String get checkEmailAndSpam =>
      'Please check your email and click the verification link before logging in.\n\nDon\'t forget to check your spam folder!';

  @override
  String get resendEmail => 'Resend Email';

  @override
  String get ok => 'OK';

  @override
  String get verificationEmailSentAgain => 'Verification email sent again!';

  @override
  String get failedToResendEmail => 'Failed to resend email.';

  @override
  String get or => 'OR';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get unexpectedError => 'Unexpected error';

  @override
  String get googleSignInCanceled => 'Google Sign-In canceled';

  @override
  String get googleSignInFailed => 'Google Sign-In failed';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get appleSignInNotAvailable =>
      'Apple Sign-In is not available on this device';

  @override
  String get appleSignInCanceled => 'Apple Sign-In was canceled';

  @override
  String get appleSignInFailed => 'Apple Sign-In failed';

  @override
  String get githubSignInFailed => 'GitHub Sign-In failed';

  @override
  String get accountExistsWithDifferentCredential =>
      'An account already exists with the same email address';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get operationNotAllowed => 'Sign-In is not enabled';

  @override
  String get userDisabled => 'This user has been disabled';

  @override
  String get userNotFound => 'No user found';

  @override
  String get wrongPassword => 'Wrong password';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get accountCreated => 'Account created! Please verify your email.';

  @override
  String get profile => 'Profile';

  @override
  String get name => 'Name';

  @override
  String get birthDate => 'Birth Date';

  @override
  String get companyCode => 'Company Code';

  @override
  String get address => 'Address';

  @override
  String get iban => 'IBAN';

  @override
  String get uploadId => 'Upload ID Image';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get profileSaved => 'Profile saved successfully!';

  @override
  String get tapToUploadId => 'Tap to upload ID';

  @override
  String get errorEnterName => 'Please enter your name';

  @override
  String get errorEnterCode => 'Please enter your company code';

  @override
  String get idNumber => 'ID';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get rejectedTitle => 'Your request has been rejected';

  @override
  String get rejectedMessage =>
      'Unfortunately, your request was rejected by the admin. Please review your information or contact support.';

  @override
  String get pendingTitle => 'Your request is under review';

  @override
  String get pendingMessage =>
      'We have received your information successfully. Please wait until the admin reviews and approves your request.';

  @override
  String get logout => 'Logout';

  @override
  String get errorSelectBirth => 'Please select your birth date';

  @override
  String get home => 'Workly 🌞';

  @override
  String get loading => 'Loading...';

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkOut => 'Check-out';

  @override
  String get totalHours => 'Total hours';

  @override
  String get hours => 'hours';

  @override
  String get withinCompany => 'Within Company ✅';

  @override
  String get outsideCompany => 'Outside Company ❌';

  @override
  String get noData => 'No data available';

  @override
  String get todayAttendance => 'Today\'s Attendance';

  @override
  String get employee => 'Employee';

  @override
  String get warningNearCompany =>
      'Warning: You must be near the company to check in.';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get attendanceHistory => 'Attendance History';

  @override
  String get monthlySchedule => 'Monthly Schedule';

  @override
  String get myRequests => 'My Requests';

  @override
  String get notifications => 'Notifications';

  @override
  String get help => 'Help & Support';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get customization => 'CUSTOMIZATION';

  @override
  String get changeAppLanguage => 'Change app language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get enableDisableDarkMode => 'Enable/Disable dark mode';

  @override
  String get notificationsAndSecurity => 'NOTIFICATIONS & SECURITY';

  @override
  String get manageNotifications => 'Manage notifications';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String version(Object version) {
    return 'Version $version';
  }

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get frequentlyAskedQuestions => 'Frequently Asked Questions';

  @override
  String get howToUseApp => 'How to use the app?';

  @override
  String get howToUseAppAnswer =>
      'You can navigate through the app using the bottom navigation bar or the side drawer.';

  @override
  String get isMyDataSecure => 'Is my data secure?';

  @override
  String get isMyDataSecureAnswer =>
      'Yes, we take privacy seriously and store your data securely.';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get emailUs => 'Email us';

  @override
  String get emailAddress => 'support@example.com';

  @override
  String get callUs => 'Call us';

  @override
  String get phoneNumbersupport => '+123 456 789';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get personalInfo => 'Personal Info';

  @override
  String get profilePicture => 'Profile Picture';

  @override
  String get monthlyScheduleTitle => 'Your Monthly Schedule';

  @override
  String get noEvents => 'No events available this month';

  @override
  String get eventDetails => 'Event Details';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get next => 'Next';

  @override
  String get previous => 'previous';

  @override
  String get error => 'Error';

  @override
  String get addEvent => 'Add Event';

  @override
  String get eventText => 'Event text';

  @override
  String get eventReminder => 'Event Reminder';

  @override
  String get eventTime => 'Event time';

  @override
  String get save => 'Save';

  @override
  String get loginToViewRecords => 'Please login to view records';

  @override
  String get noDataForMonth => 'No records for this month';

  @override
  String get filterByMonth => 'Filter by month:';

  @override
  String get minutes => 'min';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get unknownLocation => 'Unknown location';

  @override
  String get locationError => 'Error fetching location';

  @override
  String get duration => 'Duration';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get pleaseLoginToViewRecords => 'Please log in to view records';

  @override
  String get noRecordsInThisMonth => 'No records in this month';

  @override
  String get all => 'All';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get totalWorkHours => 'Total Work Hours';

  @override
  String get notCheckedOutYet => 'Not checked out yet';

  @override
  String get noLocation => 'No location recorded';

  @override
  String get locating => 'Locating...';

  @override
  String get workDayDetails => 'Work Day Details';

  @override
  String get completed => 'Completed';

  @override
  String get active => 'Active';

  @override
  String get tapForDetails => 'Tap to view details';

  @override
  String get allFieldsRequired => 'All fields must be filled';

  @override
  String get fillAllRequiredFields => 'Please fill in all required fields';

  @override
  String get failedToLoadUser => 'Failed to load user';

  @override
  String get failedToSaveProfile => 'Failed to save profile';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get locationServicesDisabled => 'Location services are disabled';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationPermissionDeniedForever =>
      'Location permission denied forever';

  @override
  String get errorGettingLocation => 'Error getting location';

  @override
  String get setCompanyLocationFirst =>
      'Please set your company location before saving';

  @override
  String get useGps => 'Use GPS for company location';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get hrPortal => 'HR Portal';

  @override
  String get hrLogin => 'HR Login';

  @override
  String get enterEmail => 'Please enter your email';

  @override
  String get enterPassword => 'Please enter your password';

  @override
  String get createNewAccount => 'Create New Account';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinHrTeam => 'Join the HR team';

  @override
  String get enterFullName => 'Please enter your full name';

  @override
  String get enterValidEmail => 'Please enter a valid email';

  @override
  String get passwordRequirements => 'Password must meet requirements';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordNotMatch => 'Passwords do not match';

  @override
  String get mustAcceptTerms => 'You must accept the terms and conditions';

  @override
  String get termsAndPrivacy =>
      'I agree to the Terms & Conditions and Privacy Policy';

  @override
  String get registrationSuccess => 'Account created successfully';

  @override
  String get success => 'Success';
}
