import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/features/home/data/movie_repository.dart';
import 'package:ticketa/features/now_showing/presentation/cubit/now_showing_state.dart';

class NowShowingCubit extends Cubit<NowShowingState> {
  final MovieRepository _repository;

  NowShowingCubit(this._repository) : super(NowShowingInitial());

  Future<void> fetchNowShowing() async {
    emit(NowShowingLoading());
    try {
      var movies = await _repository.getNowShowing();
      if (movies.isEmpty) {
        movies = await _repository.getAllMovies(pageSize: 20);
      }
      emit(NowShowingLoaded(movies));
    } catch (e) {
      emit(NowShowingError(e.toString()));
    }
  }
}
