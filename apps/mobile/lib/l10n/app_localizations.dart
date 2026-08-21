import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Ticketa'**
  String get appName;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ticketa'**
  String get welcomeMessage;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello {userName}'**
  String hello(String userName);

  /// No description provided for @nowShowing.
  ///
  /// In en, this message translates to:
  /// **'Now Showing'**
  String get nowShowing;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @comingSoonLabel.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get comingSoonLabel;

  /// No description provided for @storyLine.
  ///
  /// In en, this message translates to:
  /// **'Storyline'**
  String get storyLine;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @selectSeats.
  ///
  /// In en, this message translates to:
  /// **'Select Seats'**
  String get selectSeats;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @occupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get occupied;

  /// No description provided for @screen.
  ///
  /// In en, this message translates to:
  /// **'Screen'**
  String get screen;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @bookingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmation'**
  String get bookingConfirm;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking Successful! 🎉'**
  String get bookingSuccess;

  /// No description provided for @movie.
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get movie;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @seats.
  ///
  /// In en, this message translates to:
  /// **'Seats'**
  String get seats;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @searchMovies.
  ///
  /// In en, this message translates to:
  /// **'Search movies...'**
  String get searchMovies;

  /// No description provided for @watchTrailer.
  ///
  /// In en, this message translates to:
  /// **'Watch Trailer'**
  String get watchTrailer;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @toggleDarkLight.
  ///
  /// In en, this message translates to:
  /// **'Toggle between dark and light themes'**
  String get toggleDarkLight;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @manageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Manage your alerts and reminders'**
  String get manageNotifications;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Security settings and privacy policy'**
  String get privacyPolicy;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'STANDARD'**
  String get standard;

  /// No description provided for @imax.
  ///
  /// In en, this message translates to:
  /// **'IMAX'**
  String get imax;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @bookTickets.
  ///
  /// In en, this message translates to:
  /// **'Book Tickets'**
  String get bookTickets;

  /// No description provided for @buyFor.
  ///
  /// In en, this message translates to:
  /// **'Buy For E£{price}'**
  String buyFor(String price);

  /// No description provided for @cast.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get cast;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @myTickets.
  ///
  /// In en, this message translates to:
  /// **'My Tickets'**
  String get myTickets;

  /// No description provided for @loyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Points'**
  String get loyaltyPoints;

  /// No description provided for @totalTickets.
  ///
  /// In en, this message translates to:
  /// **'Total Tickets'**
  String get totalTickets;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @eWallet.
  ///
  /// In en, this message translates to:
  /// **'E-Wallet'**
  String get eWallet;

  /// No description provided for @ticketId.
  ///
  /// In en, this message translates to:
  /// **'Ticket ID'**
  String get ticketId;

  /// No description provided for @downloadTicket.
  ///
  /// In en, this message translates to:
  /// **'Download Ticket'**
  String get downloadTicket;

  /// No description provided for @confirmExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmExitTitle;

  /// No description provided for @confirmExitMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? All selected seats will be cleared.'**
  String get confirmExitMessage;

  /// No description provided for @confirmExitYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get confirmExitYes;

  /// No description provided for @confirmExitNo.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get confirmExitNo;

  /// No description provided for @yourTicket.
  ///
  /// In en, this message translates to:
  /// **'Your Ticket'**
  String get yourTicket;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingConfirmed;

  /// No description provided for @enjoyYourMovie.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your movie!'**
  String get enjoyYourMovie;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @totalPayment.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get totalPayment;

  /// No description provided for @trailerNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Trailer not available'**
  String get trailerNotAvailable;

  /// No description provided for @gold.
  ///
  /// In en, this message translates to:
  /// **'GOLD'**
  String get gold;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinCinemaExperience.
  ///
  /// In en, this message translates to:
  /// **'Join the cinema experience'**
  String get joinCinemaExperience;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameHint;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameHint;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get emailHint;

  /// No description provided for @minPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get minPasswordHint;

  /// No description provided for @minPassword.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get minPassword;

  /// No description provided for @selectDOB.
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get selectDOB;

  /// No description provided for @dobRequired.
  ///
  /// In en, this message translates to:
  /// **'Date of birth is required'**
  String get dobRequired;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @confirmationCode.
  ///
  /// In en, this message translates to:
  /// **'Confirmation Code'**
  String get confirmationCode;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// No description provided for @enterConfirmationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the confirmation code sent to your email'**
  String get enterConfirmationCode;

  /// No description provided for @codeHint.
  ///
  /// In en, this message translates to:
  /// **'_ _ _ _ _ _'**
  String get codeHint;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @resendConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Resend confirmation code'**
  String get resendConfirmation;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you\na link to reset your password'**
  String get forgotPasswordDesc;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @signInToAccess.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your tickets,\nbookings and preferences'**
  String get signInToAccess;

  /// No description provided for @ticketCountSummary.
  ///
  /// In en, this message translates to:
  /// **'{upcoming} upcoming • {past} past'**
  String ticketCountSummary(String upcoming, String past);

  /// No description provided for @checkYourTickets.
  ///
  /// In en, this message translates to:
  /// **'Check your tickets'**
  String get checkYourTickets;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @seatCount.
  ///
  /// In en, this message translates to:
  /// **'{count} seats'**
  String seatCount(String count);

  /// No description provided for @showTime.
  ///
  /// In en, this message translates to:
  /// **'Show Time'**
  String get showTime;

  /// No description provided for @noShowtimes.
  ///
  /// In en, this message translates to:
  /// **'No showtimes available yet.'**
  String get noShowtimes;

  /// No description provided for @noMoviesShowing.
  ///
  /// In en, this message translates to:
  /// **'No movies showing right now'**
  String get noMoviesShowing;

  /// No description provided for @genreFallback.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get genreFallback;

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String durationHours(String hours, String minutes);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String durationMinutes(String minutes);

  /// No description provided for @currencySuffix.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currencySuffix;

  /// No description provided for @locationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Cairo, Egypt'**
  String get locationPlaceholder;

  /// No description provided for @signInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in required'**
  String get signInRequired;

  /// No description provided for @signInToBook.
  ///
  /// In en, this message translates to:
  /// **'You need to sign in to book tickets.'**
  String get signInToBook;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @seatConflicting.
  ///
  /// In en, this message translates to:
  /// **'{count} seat(s) already booked.'**
  String seatConflicting(String count);

  /// No description provided for @unknownMovie.
  ///
  /// In en, this message translates to:
  /// **'Unknown Movie'**
  String get unknownMovie;

  /// No description provided for @vip.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get vip;

  /// No description provided for @paymentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled'**
  String get paymentCancelled;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed: {error}'**
  String paymentFailed(String error);

  /// No description provided for @paymentFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'Payment failed, please try again.'**
  String get paymentFailedRetry;

  /// No description provided for @secure.
  ///
  /// In en, this message translates to:
  /// **'secure'**
  String get secure;

  /// No description provided for @stripePaymentDesc.
  ///
  /// In en, this message translates to:
  /// **'You will confirm your card securely inside the Stripe payment sheet.'**
  String get stripePaymentDesc;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Ref: {ref}'**
  String reference(String ref);

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccessful;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registrationSuccessful;

  /// No description provided for @emailConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Email confirmed'**
  String get emailConfirmed;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @confirmationResent.
  ///
  /// In en, this message translates to:
  /// **'Confirmation resent'**
  String get confirmationResent;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent to your email'**
  String get resetLinkSent;

  /// No description provided for @paymentConfirmFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment could not be confirmed'**
  String get paymentConfirmFailed;

  /// No description provided for @failedLoadTickets.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tickets.'**
  String get failedLoadTickets;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
