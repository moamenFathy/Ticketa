import 'package:ticketa/core/network/api_service.dart';
import 'package:ticketa/core/constants/api_constants.dart';
import 'package:ticketa/features/home/models/movie.dart';

class MovieRepository {
  final ApiService _apiService;

  MovieRepository(this._apiService);

  Future<List<Movie>> getNowShowing() async {
    final response = await _apiService.get(ApiConstants.nowShowingEndpoint);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((e) => Movie.fromJson(e)).toList();
    }
    throw Exception('Failed to load now showing movies');
  }

  Future<List<Movie>> getComingSoon() async {
    final response = await _apiService.get(ApiConstants.upcomingEndpoint);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((e) => Movie.fromJson(e)).toList();
    }
    throw Exception('Failed to load coming soon movies');
  }

  Future<Movie> getMovieDetails(String id) async {
    final response = await _apiService.get('${ApiConstants.moviesEndpoint}/$id');
    if (response.statusCode == 200) {
      return Movie.fromJson(response.data);
    }
    throw Exception('Failed to load movie details');
  }
}
