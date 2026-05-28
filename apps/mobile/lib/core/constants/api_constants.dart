class ApiConstants {
  static const String baseUrl = "https://ticketa.runasp.net/api/";
  static const String moviesEndpoint = "Movies";
  static const String nowShowingEndpoint = "Movies/NowShowing";
  static const String upcomingEndpoint = "Movies/ComingSoon";
  
  // Auth
  static const String authEndpoint = "Auth";
  static const String loginEndpoint = "Auth/login";
  static const String registerEndpoint = "Auth/register";
  static const String confirmEmailEndpoint = "Auth/confirm-email";
  static const String resendConfirmationEndpoint = "Auth/resend-confirmation";
  static const String logoutEndpoint = "Auth/logout";
  static const String refreshEndpoint = "Auth/refresh";
  static const String forgotPasswordEndpoint = "Auth/forgot-password";

  // Booking
  static const String showtimeSeatsEndpoint = "Showtimes";
  static const String bookingsEndpoint = "Bookings";
  
  // Headers
  static const String contentType = "application/json";
  static const String accept = "application/json";
}
  