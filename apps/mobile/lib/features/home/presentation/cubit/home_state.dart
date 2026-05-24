import 'package:ticketa/features/home/data/models/movie.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Movie> nowShowing;
  final List<Movie> comingSoon;

  HomeLoaded({required this.nowShowing, required this.comingSoon});
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
