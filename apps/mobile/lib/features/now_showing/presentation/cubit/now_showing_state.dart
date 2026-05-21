import 'package:ticketa/features/home/models/movie.dart';

abstract class NowShowingState {}

class NowShowingInitial extends NowShowingState {}

class NowShowingLoading extends NowShowingState {}

class NowShowingLoaded extends NowShowingState {
  final List<Movie> movies;

  NowShowingLoaded(this.movies);
}

class NowShowingError extends NowShowingState {
  final String message;

  NowShowingError(this.message);
}
