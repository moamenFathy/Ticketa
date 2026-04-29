// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Ticketa';

  @override
  String get welcomeMessage => 'Welcome to Ticketa';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String hello(String userName) {
    return 'Hello $userName';
  }

  @override
  String get nowShowing => 'Now Showing';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get seeAll => 'See All';

  @override
  String get comingSoonLabel => 'Soon';

  @override
  String get storyLine => 'Storyline';

  @override
  String get selectDate => 'Select Date';

  @override
  String get bookNow => 'Book Now';

  @override
  String get selectSeats => 'Select Seats';

  @override
  String get available => 'Available';

  @override
  String get selected => 'Selected';

  @override
  String get occupied => 'Occupied';

  @override
  String get screen => 'Screen';

  @override
  String get total => 'Total';

  @override
  String get continueText => 'Continue';

  @override
  String get bookingConfirm => 'Booking Confirmation';

  @override
  String get bookingSuccess => 'Booking Successful! 🎉';

  @override
  String get movie => 'Movie';

  @override
  String get date => 'Date';

  @override
  String get seats => 'Seats';

  @override
  String get backToHome => 'Back to Home';
}
