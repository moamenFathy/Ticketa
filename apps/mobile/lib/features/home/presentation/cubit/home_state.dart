import 'package:ticketa/features/home/data/models/movie.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Movie> nowShowing;
  final List<Movie> comingSoon;
  final List<Movie> topBooked;

  HomeLoaded({
    required this.nowShowing,
    required this.comingSoon,
    required this.topBooked,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
