import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:ticketa/core/constants/api_constants.dart';
import 'package:ticketa/core/network/api_service.dart';
import 'package:ticketa/features/home/data/movie_repository.dart';
import 'package:ticketa/features/home/presentation/cubit/home_cubit.dart';
import 'package:ticketa/features/home/presentation/cubit/movie_detail_cubit.dart';
import 'package:ticketa/features/now_showing/presentation/cubit/now_showing_cubit.dart';
final getIt = GetIt.instance;

Future<void> initInjection() async {
  // External
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPrefs);
  
  getIt.registerLazySingleton(() => Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': ApiConstants.contentType,
            'Accept': ApiConstants.accept,
          },
        ),
      )..interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      )));

  getIt.registerLazySingleton(() => ApiService(getIt<Dio>()));

  // Repositories
  getIt.registerLazySingleton(() => MovieRepository(getIt<ApiService>()));

  // Cubits
  getIt.registerFactory(() => HomeCubit(getIt<MovieRepository>()));
  getIt.registerFactory(() => MovieDetailCubit(getIt<MovieRepository>()));
  getIt.registerFactory(() => NowShowingCubit(getIt<MovieRepository>()));
}
