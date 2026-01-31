// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'تطبيق المستخدم';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle => 'يرجى إدخال البيانات لإتمام تسجيل الدخول';

  @override
  String get signupTitle => 'إنشاء حساب';

  @override
  String get signupSubtitle => 'يرجى إدخال البيانات لإنشاء حساب جديد';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get agreeTerms => 'أوافق على شروط الخدمة وسياسة الخصوصية';

  @override
  String get agreeTermsShort => 'أوافق على الشروط والأحكام';

  @override
  String get login => 'دخول';

  @override
  String get signUp => 'تسجيل';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get fieldRequired => 'هذا الحقل إلزامي';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get passwordMin => 'يجب ألا تقل كلمة المرور عن ٨ أحرف';

  @override
  String get passwordUpper => 'أضف حرفًا كبيرًا واحدًا على الأقل';

  @override
  String get passwordLower => 'أضف حرفًا صغيرًا واحدًا على الأقل';

  @override
  String get passwordNumber => 'أضف رقمًا واحدًا على الأقل';

  @override
  String get passwordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get successLogin => 'مرحبًا بعودتك 👋';

  @override
  String get successSignup => 'تم إعداد حسابك بنجاح 🎉';

  @override
  String get errWrongPassword => 'كلمة المرور غير صحيحة. حاول مجددًا.';

  @override
  String get errUserNotFound => 'لا يوجد حساب مرتبط بهذا البريد الإلكتروني.';

  @override
  String get errEmailInUse => 'هذا البريد الإلكتروني مستخدم بالفعل.';

  @override
  String get errWeakPassword => 'كلمة المرور ضعيفة.';

  @override
  String get errTooManyRequests => 'محاولات كثيرة. يرجى المحاولة لاحقًا.';

  @override
  String get errGeneric => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String helloUser(String name) {
    return 'أهلاً، $name';
  }

  @override
  String get gallery => 'معرض الصور';

  @override
  String get changeView => 'تغيير العرض';

  @override
  String get logoutTooltip => 'تسجيل خروج';

  @override
  String get confirmLogoutTitle => 'تأكيد تسجيل الخروج';

  @override
  String get confirmLogoutBody => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get logout => 'خروج';

  @override
  String get userFallback => 'مستخدم';

  @override
  String get verifyEmailFirst => 'يرجى تفعيل بريدك الإلكتروني أولاً. تحقق من صندوق الوارد.';

  @override
  String get emailNotFoundCreateAccount => 'الإيميل غير مسجل، هل تريد إنشاء حساب جديد؟';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordDialogBody => 'أدخل بريدك الإلكتروني وسنرسل لك رابط لإعادة تعيين كلمة المرور.';

  @override
  String get pleaseEnterEmail => 'من فضلك أدخل البريد الإلكتروني';

  @override
  String get resetLinkSent => 'تم إرسال رابط إعادة التعيين لبريدك';

  @override
  String get checkEmailCorrect => 'تأكد من صحة البريد الإلكتروني';

  @override
  String get send => 'إرسال';

  @override
  String get authErrWrongPassword => 'كلمة المرور أو الإيميل غير صحيح، حاول مرة أخرى';

  @override
  String get authErrUserNotFound => 'الإيميل غير مسجل، الرجاء إنشاء حساب جديد';

  @override
  String get authErrInvalidEmail => 'صيغة البريد غير صحيحة';

  @override
  String get authErrTooManyRequests => 'محاولات كثيرة خاطئة، جرب لاحقاً';

  @override
  String get authErrGeneric => 'حدث خطأ ما، يرجى المحاولة مرة أخرى';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get signupVerifyEmailSuccess => 'تم إنشاء الحساب! يرجى التحقق من بريدك الإلكتروني لتفعيل الحساب قبل تسجيل الدخول.';

  @override
  String get emailAlreadyRegisteredLogin => 'هذا البريد الإلكتروني مسجل بالفعل، يرجى تسجيل الدخول.';

  @override
  String get loginAction => 'تسجيل دخول';

  @override
  String get nameLettersOnly => 'الاسم يجب أن يحتوي على أحرف فقط';

  @override
  String get nameMinLetters => 'الاسم يجب أن يكون 3 أحرف على الأقل';
}
