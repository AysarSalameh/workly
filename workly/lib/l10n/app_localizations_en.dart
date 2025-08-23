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
}
