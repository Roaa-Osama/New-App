// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'User App';

  @override
  String get loginTitle => 'Login Now';

  @override
  String get loginSubtitle => 'Please fill the details and login';

  @override
  String get signupTitle => 'Sign Up Now';

  @override
  String get signupSubtitle => 'Please fill the details and create an account';

  @override
  String get email => 'Email';

  @override
  String get fullName => 'Full name';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get agreeTerms => 'I agree to the Terms of Service and Privacy Policy';

  @override
  String get agreeTermsShort => 'I agree to the Terms and Conditions';

  @override
  String get login => 'Login';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get passwordMin => 'Password must be at least 8 characters';

  @override
  String get passwordUpper => 'Add at least one uppercase letter';

  @override
  String get passwordLower => 'Add at least one lowercase letter';

  @override
  String get passwordNumber => 'Add at least one number';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get loading => 'Loading...';

  @override
  String get successLogin => 'Welcome back 👋';

  @override
  String get successSignup => 'Your account is ready 🎉';

  @override
  String get errWrongPassword => 'Incorrect password. Try again.';

  @override
  String get errUserNotFound => 'No account found for this email.';

  @override
  String get errEmailInUse => 'This email is already in use.';

  @override
  String get errWeakPassword => 'Password is too weak.';

  @override
  String get errTooManyRequests => 'Too many attempts. Please try later.';

  @override
  String get errGeneric => 'Something went wrong. Please try again.';

  @override
  String helloUser(String name) {
    return 'Hello, $name';
  }

  @override
  String get gallery => 'Gallery';

  @override
  String get changeView => 'Change view';

  @override
  String get logoutTooltip => 'Logout';

  @override
  String get confirmLogoutTitle => 'Confirm logout';

  @override
  String get confirmLogoutBody => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get logout => 'Logout';

  @override
  String get userFallback => 'User';

  @override
  String get verifyEmailFirst => 'Please verify your email first. Check your inbox.';

  @override
  String get emailNotFoundCreateAccount => 'Email not found. Would you like to create an account?';

  @override
  String get forgotPasswordTitle => 'Forgot Password?';

  @override
  String get forgotPasswordDialogBody => 'Enter your email to receive a password reset link.';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get resetLinkSent => 'Password reset link sent to your email';

  @override
  String get checkEmailCorrect => 'Check if the email is correct';

  @override
  String get send => 'Send';

  @override
  String get authErrWrongPassword => 'Incorrect email or password, try again';

  @override
  String get authErrUserNotFound => 'Email not found, please create an account';

  @override
  String get authErrInvalidEmail => 'Invalid email format';

  @override
  String get authErrTooManyRequests => 'Too many attempts, try again later';

  @override
  String get authErrGeneric => 'Something went wrong, please try again';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get signupVerifyEmailSuccess => 'Account created! Please check your email to verify your account before logging in.';

  @override
  String get emailAlreadyRegisteredLogin => 'This email is already registered. Please log in.';

  @override
  String get loginAction => 'Login';

  @override
  String get nameLettersOnly => 'Name must contain letters only';

  @override
  String get nameMinLetters => 'Name must be at least 3 letters';
}
