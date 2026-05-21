import 'package:ticketa/features/home/models/movie.dart';

abstract class MovieDetailState {}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final Movie movie;

  MovieDetailLoaded({required this.movie});
}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);
}
