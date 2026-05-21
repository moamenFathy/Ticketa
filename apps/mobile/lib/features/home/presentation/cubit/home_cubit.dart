import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/features/home/data/movie_repository.dart';
import 'package:ticketa/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MovieRepository _repository;

  HomeCubit(this._repository) : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());
    try {
      final responses = await Future.wait([
        _repository.getNowShowing(),
        _repository.getComingSoon(),
      ]);
      
      var nowShowing = responses[0];
      var comingSoon = responses[1];
      
      emit(HomeLoaded(
        nowShowing: nowShowing,
        comingSoon: comingSoon,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
