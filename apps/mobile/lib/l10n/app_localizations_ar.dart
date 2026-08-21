// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'تيكيتا';

  @override
  String get welcomeMessage => 'مرحباً بك في تيكيتا';

  @override
  String get home => 'الرئيسية';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String hello(String userName) {
    return 'مرحباً $userName';
  }

  @override
  String get nowShowing => 'يعرض الآن';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get comingSoonLabel => 'قريباً';

  @override
  String get storyLine => 'القصة';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get selectSeats => 'اختر المقاعد';

  @override
  String get available => 'متاح';

  @override
  String get selected => 'محدد';

  @override
  String get occupied => 'محجوز';

  @override
  String get screen => 'شاشة العرض';

  @override
  String get total => 'الإجمالي';

  @override
  String get continueText => 'استمرار';

  @override
  String get bookingConfirm => 'تأكيد الحجز';

  @override
  String get bookingSuccess => 'تم الحجز بنجاح! 🎉';

  @override
  String get movie => 'الفيلم';

  @override
  String get date => 'التاريخ';

  @override
  String get seats => 'المقاعد';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get offers => 'العروض';

  @override
  String get account => 'الحساب';

  @override
  String get now => 'الآن';

  @override
  String get searchMovies => 'ابحث عن أفلام...';

  @override
  String get watchTrailer => 'شاهد الإعلان';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get toggleDarkLight => 'التبديل بين الوضع الداكن والفاتح';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get manageNotifications => 'إدارة التنبيهات والتذكيرات';

  @override
  String get privacySecurity => 'الخصوصية والأمان';

  @override
  String get privacyPolicy => 'إعدادات الأمان وسياسة الخصوصية';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get standard => 'عادي';

  @override
  String get imax => 'ايماكس';

  @override
  String get price => 'السعر';

  @override
  String get bookTickets => 'حجز التذاكر';

  @override
  String buyFor(String price) {
    return 'اشتري بـ E£$price';
  }

  @override
  String get cast => 'طاقم العمل';

  @override
  String get reviews => 'المراجعات';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get myTickets => 'تذاكري';

  @override
  String get loyaltyPoints => 'نقاط الولاء';

  @override
  String get totalTickets => 'إجمالي التذاكر';

  @override
  String get points => 'نقطة';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get payNow => 'ادفع الآن';

  @override
  String get creditCard => 'بطاقة ائتمان';

  @override
  String get eWallet => 'محفظة إلكترونية';

  @override
  String get ticketId => 'رقم التذكرة';

  @override
  String get downloadTicket => 'تحميل التذكرة';

  @override
  String get confirmExitTitle => 'تأكيد';

  @override
  String get confirmExitMessage =>
      'هل أنت متأكد؟ سيتم إزالة جميع المقاعد المحددة.';

  @override
  String get confirmExitYes => 'تأكيد';

  @override
  String get confirmExitNo => 'إلغاء';

  @override
  String get yourTicket => 'تذكرتك';

  @override
  String get bookingConfirmed => 'تم الحجز!';

  @override
  String get enjoyYourMovie => 'استمتع بمشاهدة الفيلم!';

  @override
  String get time => 'الوقت';

  @override
  String get totalPayment => 'إجمالي الدفع';

  @override
  String get trailerNotAvailable => 'التريلر مش متاح';

  @override
  String get gold => 'ذهبي';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enterEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get password => 'كلمة السر';

  @override
  String get enterPassword => 'أدخل كلمة السر';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInToContinue => 'سجل دخولك للمتابعة';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get passwordRequired => 'كلمة السر مطلوبة';

  @override
  String get forgotPassword => 'نسيت كلمة السر؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get or => 'أو';

  @override
  String get continueAsGuest => 'المتابعة كضيف';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get joinCinemaExperience => 'انضم لتجربة السينما';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get firstNameHint => 'الاسم الأول';

  @override
  String get lastName => 'الاسم الأخير';

  @override
  String get lastNameHint => 'الاسم الأخير';

  @override
  String get required => 'مطلوب';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get minPasswordHint => '6 أحرف على الأقل';

  @override
  String get minPassword => '6 أحرف على الأقل';

  @override
  String get selectDOB => 'اختر تاريخ ميلادك';

  @override
  String get dobRequired => 'تاريخ الميلاد مطلوب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get confirmationCode => 'رمز التأكيد';

  @override
  String get verifyEmail => 'تأكيد البريد الإلكتروني';

  @override
  String get enterConfirmationCode =>
      'أدخل رمز التأكيد المرسل إلى بريدك الإلكتروني';

  @override
  String get codeHint => '_ _ _ _ _ _';

  @override
  String get confirm => 'تأكيد';

  @override
  String get resendConfirmation => 'إعادة إرسال رمز التأكيد';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة السر؟';

  @override
  String get forgotPasswordDesc =>
      'أدخل بريدك الإلكتروني وسنرسل لك\nرابطاً لإعادة تعيين كلمة السر';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get backToSignIn => 'العودة لتسجيل الدخول';

  @override
  String get signInToAccess =>
      'سجل دخولك للوصول إلى تذاكرك\nوحجوزاتك وتفضيلاتك';

  @override
  String ticketCountSummary(String upcoming, String past) {
    return '$upcoming قادمة • $past سابقة';
  }

  @override
  String get checkYourTickets => 'تحقق من تذاكرك';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String seatCount(String count) {
    return '$count مقاعد';
  }

  @override
  String get showTime => 'موعد العرض';

  @override
  String get noShowtimes => 'لا توجد عروض متاحة بعد.';

  @override
  String get noMoviesShowing => 'لا توجد أفلام تُعرض الآن';

  @override
  String get genreFallback => 'أكشن';

  @override
  String durationHours(String hours, String minutes) {
    return '$hoursس $minutesد';
  }

  @override
  String durationMinutes(String minutes) {
    return '$minutesد';
  }

  @override
  String get currencySuffix => 'ج.م';

  @override
  String get locationPlaceholder => 'القاهرة، مصر';

  @override
  String get signInRequired => 'تسجيل الدخول مطلوب';

  @override
  String get signInToBook => 'يجب عليك تسجيل الدخول لحجز التذاكر.';

  @override
  String get cancel => 'إلغاء';

  @override
  String seatConflicting(String count) {
    return '$count مقعد محجوز بالفعل.';
  }

  @override
  String get unknownMovie => 'فيلم غير معروف';

  @override
  String get vip => 'VIP';

  @override
  String get paymentCancelled => 'تم إلغاء الدفع';

  @override
  String paymentFailed(String error) {
    return 'فشل الدفع: $error';
  }

  @override
  String get paymentFailedRetry => 'فشل الدفع، حاول مرة أخرى.';

  @override
  String get secure => 'آمن';

  @override
  String get stripePaymentDesc =>
      'ستؤكد بطاقتك بشكل آمن داخل صفحة الدفع من Stripe.';

  @override
  String reference(String ref) {
    return 'المرجع: $ref';
  }

  @override
  String get sessionExpired => 'انتهت الجلسة. الرجاء تسجيل الدخول مرة أخرى.';

  @override
  String get loginSuccessful => 'تم تسجيل الدخول بنجاح';

  @override
  String get registrationSuccessful => 'تم إنشاء الحساب بنجاح';

  @override
  String get emailConfirmed => 'تم تأكيد البريد الإلكتروني';

  @override
  String get guest => 'ضيف';

  @override
  String get confirmationResent => 'تم إعادة إرسال رمز التأكيد';

  @override
  String get resetLinkSent =>
      'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني';

  @override
  String get paymentConfirmFailed => 'تعذر تأكيد الدفع';

  @override
  String get failedLoadTickets => 'فشل تحميل التذاكر.';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';
}
