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

  @override
  String get offers => 'Offers';

  @override
  String get account => 'Account';

  @override
  String get now => 'Now';

  @override
  String get searchMovies => 'Search movies...';

  @override
  String get watchTrailer => 'Watch Trailer';

  @override
  String get appSettings => 'App Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get toggleDarkLight => 'Toggle between dark and light themes';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageNotifications => 'Manage your alerts and reminders';

  @override
  String get privacySecurity => 'Privacy & Security';

  @override
  String get privacyPolicy => 'Security settings and privacy policy';

  @override
  String get signOut => 'Sign Out';

  @override
  String get standard => 'STANDARD';

  @override
  String get imax => 'IMAX';

  @override
  String get price => 'Price';

  @override
  String get bookTickets => 'Book Tickets';

  @override
  String buyFor(Object price) {
    return 'Buy For $price';
  }

  @override
  String get cast => 'Cast';

  @override
  String get reviews => 'Reviews';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get myTickets => 'My Tickets';

  @override
  String get loyaltyPoints => 'Loyalty Points';

  @override
  String get totalTickets => 'Total Tickets';

  @override
  String get points => 'Points';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get payNow => 'Pay Now';

  @override
  String get creditCard => 'Credit Card';

  @override
  String get eWallet => 'E-Wallet';

  @override
  String get ticketId => 'Ticket ID';

  @override
  String get downloadTicket => 'Download Ticket';
}
