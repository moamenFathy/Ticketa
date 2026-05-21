import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/features/home/data/movie_repository.dart';
import 'package:ticketa/features/home/presentation/cubit/movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final MovieRepository _repository;

  MovieDetailCubit(this._repository) : super(MovieDetailInitial());

  Future<void> fetchMovieDetails(String id) async {
    emit(MovieDetailLoading());
    try {
      final movie = await _repository.getMovieDetails(id);
      emit(MovieDetailLoaded(movie: movie));
    } catch (e) {
      emit(MovieDetailError(e.toString()));
    }
  }
}
