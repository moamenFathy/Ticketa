import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:ticketa/core/constants/api_constants.dart';
import 'package:ticketa/core/constants/app_constants.dart';
import 'package:ticketa/core/network/api_service.dart';
import 'package:ticketa/features/home/data/movie_repository.dart';
import 'package:ticketa/features/home/presentation/cubit/home_cubit.dart';
import 'package:ticketa/features/home/presentation/cubit/movie_detail_cubit.dart';
import 'package:ticketa/features/now_showing/presentation/cubit/now_showing_cubit.dart';
import 'package:ticketa/features/auth/data/auth_repository.dart';
import 'package:ticketa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ticketa/features/booking/data/booking_repository.dart';
import 'package:ticketa/features/booking/presentation/cubit/booking_cubit.dart';
final getIt = GetIt.instance;

Future<void> initInjection() async {
  // External
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPrefs);

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

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = sharedPrefs.getString(AppConstants.tokenKey);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    return dio;
  });

  getIt.registerLazySingleton(() => ApiService(getIt<Dio>()));

  // Repositories
  getIt.registerLazySingleton(() => MovieRepository(getIt<ApiService>()));
  getIt.registerLazySingleton(() => AuthRepository(getIt<ApiService>()));
  getIt.registerLazySingleton(() => BookingRepository(getIt<ApiService>()));

  // Cubits
  getIt.registerFactory(() => HomeCubit(getIt<MovieRepository>()));
  getIt.registerFactory(() => MovieDetailCubit(getIt<MovieRepository>()));
  getIt.registerFactory(() => NowShowingCubit(getIt<MovieRepository>()));
  getIt.registerFactory(() => AuthCubit(getIt<AuthRepository>()));
  getIt.registerFactory(() => BookingCubit(getIt<BookingRepository>()));
}
