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
  String buyFor(Object price) {
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
}
