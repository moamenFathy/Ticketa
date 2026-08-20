class ApiConstants {
  static const String baseUrl = "https://ticketa.runasp.net/api/";
  static const String moviesEndpoint = "Movies";
  static const String nowShowingEndpoint = "Movies/NowShowing";
  static const String upcomingEndpoint = "Movies/coming-soon";
  static const String topBookedEndpoint = "Movies/top-booked";

  // Auth
  static const String authEndpoint = "Auth";
  static const String loginEndpoint = "Auth/login";
  static const String registerEndpoint = "Auth/register";
  static const String confirmEmailEndpoint = "Auth/confirm-email";
  static const String resendConfirmationEndpoint = "Auth/resend-confirmation";
  static const String logoutEndpoint = "Auth/logout";
  static const String refreshEndpoint = "Auth/refresh";
  static const String forgotPasswordEndpoint = "Auth/forget-password";

  // Booking
  static const String showtimeSeatsEndpoint = "Showtimes";
  static const String bookingsEndpoint = "Bookings";
  static const String paymentsEndpoint = "Payments";
  static const String paymentsConfigEndpoint = "Payments/config";

  // Profile
  static const String profileEndpoint = "Profile";
  static const String profilePasswordEndpoint = "Profile/password";
  static const String profileBookingsEndpoint = "Profile/bookings";

  // Headers
  static const String contentType = "application/json";
  static const String accept = "application/json";
}
