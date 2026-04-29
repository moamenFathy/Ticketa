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
}
