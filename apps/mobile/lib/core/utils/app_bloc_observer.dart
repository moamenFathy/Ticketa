import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/core/utils/app_logger.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    AppLogger.d(
      '${bloc.runtimeType} -> ${change.nextState.runtimeType}',
      tag: 'BLoC',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    AppLogger.e(
      '${bloc.runtimeType} Error: $error',
      tag: 'BLoC',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
