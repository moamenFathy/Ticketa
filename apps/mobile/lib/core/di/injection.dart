import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

Future<void> initInjection() async {
  // External
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPrefs);
  getIt.registerLazySingleton(() => Dio());

  // Features - Home
  // Example: getIt.registerLazySingleton(() => HomeRepository());
}
