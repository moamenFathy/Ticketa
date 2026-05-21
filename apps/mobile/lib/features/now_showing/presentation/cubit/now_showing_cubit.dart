import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/features/home/data/movie_repository.dart';
import 'package:ticketa/features/now_showing/presentation/cubit/now_showing_state.dart';

class NowShowingCubit extends Cubit<NowShowingState> {
  final MovieRepository _repository;

  NowShowingCubit(this._repository) : super(NowShowingInitial());

  Future<void> fetchNowShowing() async {
    emit(NowShowingLoading());
    try {
      final movies = await _repository.getNowShowing();
      emit(NowShowingLoaded(movies));
    } catch (e) {
      emit(NowShowingError(e.toString()));
    }
  }
}
