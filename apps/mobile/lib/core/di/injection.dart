import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ticketa/core/constants/api_constants.dart';
import 'package:ticketa/core/constants/app_constants.dart';
import 'package:ticketa/core/network/api_service.dart';
import 'package:ticketa/core/services/message_service.dart';
import 'package:ticketa/core/services/navigation_service.dart';
import 'package:ticketa/features/home/data/movie_repository.dart';
import 'package:ticketa/features/home/presentation/cubit/home_cubit.dart';
import 'package:ticketa/features/home/presentation/cubit/movie_detail_cubit.dart';
import 'package:ticketa/features/now_showing/presentation/cubit/now_showing_cubit.dart';
import 'package:ticketa/features/auth/data/auth_repository.dart';
import 'package:ticketa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ticketa/features/booking/data/booking_repository.dart';
import 'package:ticketa/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:ticketa/features/payment/data/payment_repository.dart';
import 'package:ticketa/features/payment/presentation/cubit/payment_cubit.dart';

final getIt = GetIt.instance;

bool _refreshing = false;

Future<void> initInjection() async {
  // External
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPrefs);

  final supportDir = await getApplicationSupportDirectory();
  final cookieJar = PersistCookieJar(
    storage: FileStorage('${supportDir.path}/cookies'),
    ignoreExpires: true,
  );
  getIt.registerLazySingleton<CookieJar>(() => cookieJar);
  getIt.registerLazySingleton(() => NavigationService());

  getIt.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': ApiConstants.accept,
        },
      ),
    );

    // Store & send cookies (refreshToken HttpOnly cookie)
    dio.interceptors.add(CookieManager(cookieJar));

    // Attach access token + refresh on 401
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = sharedPrefs.getString(AppConstants.tokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) =>
            _handleUnauthorized(dio, sharedPrefs, cookieJar, error, handler),
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  });

  getIt.registerLazySingleton(() => ApiService(getIt<Dio>()));

  // Repositories
  getIt.registerLazySingleton(() => MovieRepository(getIt<ApiService>()));
  getIt.registerLazySingleton(() => AuthRepository(getIt<ApiService>()));
  getIt.registerLazySingleton(() => BookingRepository(getIt<ApiService>()));
  getIt.registerLazySingleton(() => PaymentRepository(getIt<ApiService>()));

  // Cubits
  getIt.registerFactory(() => HomeCubit(getIt<MovieRepository>()));
  getIt.registerFactory(() => MovieDetailCubit(getIt<MovieRepository>()));
  getIt.registerFactory(() => NowShowingCubit(getIt<MovieRepository>()));
  getIt.registerFactory(() => AuthCubit(getIt<AuthRepository>()));
  getIt.registerFactory(() => BookingCubit(getIt<BookingRepository>()));
  getIt.registerFactory(() => PaymentCubit(getIt<PaymentRepository>()));
}

Future<void> _handleUnauthorized(
  Dio dio,
  SharedPreferences prefs,
  CookieJar cookieJar,
  DioException error,
  ErrorInterceptorHandler handler,
) async {
  final request = error.requestOptions;
  if (error.response?.statusCode != 401) {
    handler.next(error);
    return;
  }

  final path = request.path;
  if (path.contains('/Auth/refresh') ||
      path.contains('/Auth/login') ||
      path.contains('/Auth/register') ||
      path.contains('/Auth/confirm-email') ||
      path.contains('/Auth/google')) {
    handler.next(error);
    return;
  }

  final isLoggedIn = prefs.getBool(AppConstants.isLoggedInKey) ?? false;
  final hasToken = (prefs.getString(AppConstants.tokenKey) ?? '').isNotEmpty;

  if (_refreshing || !isLoggedIn || !hasToken) {
    handler.next(error);
    return;
  }
  _refreshing = true;
  try {
    final refreshResponse = await dio.post<Map<String, dynamic>>(
      ApiConstants.refreshEndpoint,
      options: Options(extra: {'skipAuthRefresh': true}),
    );
    final data = refreshResponse.data;
    final newToken = data?['accessToken']?.toString();
    if (newToken == null || newToken.isEmpty) {
      throw Exception('Refresh failed: no access token returned');
    }
    await prefs.setString(AppConstants.tokenKey, newToken);

    request.headers['Authorization'] = 'Bearer $newToken';
    final retried = await dio.fetch(request);
    handler.resolve(retried);
  } catch (e) {
    await cookieJar.deleteAll();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userEmailKey);
    await prefs.remove(AppConstants.isLoggedInKey);
    await prefs.setBool(AppConstants.isGuestKey, false);
    final navContext = getIt<NavigationService>().navigatorKey.currentContext;
    if (navContext != null && navContext.mounted) {
      MessageService.showWarning(
        context: navContext,
        message: 'Session expired. Please sign in again.',
      );
    }
    getIt<NavigationService>().pushNamedAndRemoveUntil('/login');
    handler.next(error);
  } finally {
    _refreshing = false;
  }
}
