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
  String buyFor(String price) {
    return 'Buy For E£$price';
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

  @override
  String get confirmExitTitle => 'Confirm';

  @override
  String get confirmExitMessage =>
      'Are you sure? All selected seats will be cleared.';

  @override
  String get confirmExitYes => 'Yes';

  @override
  String get confirmExitNo => 'Cancel';

  @override
  String get yourTicket => 'Your Ticket';

  @override
  String get bookingConfirmed => 'Booking Confirmed!';

  @override
  String get enjoyYourMovie => 'Enjoy your movie!';

  @override
  String get time => 'Time';

  @override
  String get totalPayment => 'Total Payment';

  @override
  String get trailerNotAvailable => 'Trailer not available';

  @override
  String get gold => 'GOLD';

  @override
  String get email => 'Email';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get or => 'OR';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get register => 'Register';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinCinemaExperience => 'Join the cinema experience';

  @override
  String get firstName => 'First Name';

  @override
  String get firstNameHint => 'First name';

  @override
  String get lastName => 'Last Name';

  @override
  String get lastNameHint => 'Last name';

  @override
  String get required => 'Required';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get minPasswordHint => 'Minimum 6 characters';

  @override
  String get minPassword => 'At least 6 characters';

  @override
  String get selectDOB => 'Select your date of birth';

  @override
  String get dobRequired => 'Date of birth is required';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get confirmationCode => 'Confirmation Code';

  @override
  String get verifyEmail => 'Verify Email';

  @override
  String get enterConfirmationCode =>
      'Enter the confirmation code sent to your email';

  @override
  String get codeHint => '_ _ _ _ _ _';

  @override
  String get confirm => 'Confirm';

  @override
  String get resendConfirmation => 'Resend confirmation code';

  @override
  String get forgotPasswordTitle => 'Forgot Password?';

  @override
  String get forgotPasswordDesc =>
      'Enter your email address and we\'ll send you\na link to reset your password';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get signInToAccess =>
      'Sign in to access your tickets,\nbookings and preferences';

  @override
  String ticketCountSummary(String upcoming, String past) {
    return '$upcoming upcoming • $past past';
  }

  @override
  String get checkYourTickets => 'Check your tickets';

  @override
  String get retry => 'Retry';

  @override
  String seatCount(String count) {
    return '$count seats';
  }

  @override
  String get showTime => 'Show Time';

  @override
  String get noShowtimes => 'No showtimes available yet.';

  @override
  String get noMoviesShowing => 'No movies showing right now';

  @override
  String get genreFallback => 'Action';

  @override
  String durationHours(String hours, String minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String durationMinutes(String minutes) {
    return '${minutes}m';
  }

  @override
  String get currencySuffix => 'EGP';

  @override
  String get locationPlaceholder => 'Cairo, Egypt';

  @override
  String get signInRequired => 'Sign in required';

  @override
  String get signInToBook => 'You need to sign in to book tickets.';

  @override
  String get cancel => 'Cancel';

  @override
  String seatConflicting(String count) {
    return '$count seat(s) already booked.';
  }

  @override
  String get unknownMovie => 'Unknown Movie';

  @override
  String get vip => 'VIP';

  @override
  String get paymentCancelled => 'Payment cancelled';

  @override
  String paymentFailed(String error) {
    return 'Payment failed: $error';
  }

  @override
  String get paymentFailedRetry => 'Payment failed, please try again.';

  @override
  String get secure => 'secure';

  @override
  String get stripePaymentDesc =>
      'You will confirm your card securely inside the Stripe payment sheet.';

  @override
  String reference(String ref) {
    return 'Ref: $ref';
  }

  @override
  String get sessionExpired => 'Session expired. Please sign in again.';

  @override
  String get loginSuccessful => 'Login successful';

  @override
  String get registrationSuccessful => 'Registration successful';

  @override
  String get emailConfirmed => 'Email confirmed';

  @override
  String get guest => 'Guest';

  @override
  String get confirmationResent => 'Confirmation resent';

  @override
  String get resetLinkSent => 'Reset link sent to your email';

  @override
  String get paymentConfirmFailed => 'Payment could not be confirmed';

  @override
  String get failedLoadTickets => 'Failed to load tickets.';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get fieldRequired => 'This field is required';
}
