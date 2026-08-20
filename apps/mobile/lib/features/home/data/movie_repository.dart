import 'package:ticketa/core/network/api_service.dart';
import 'package:ticketa/core/constants/api_constants.dart';
import 'package:ticketa/features/home/data/models/movie.dart';

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

  Future<List<Movie>> getTopBooked({int count = 6}) async {
    final response = await _apiService.get(
      ApiConstants.topBookedEndpoint,
      queryParameters: {'count': count},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((e) => Movie.fromJson(e)).toList();
    }
    throw Exception('Failed to load top booked movies');
  }

  Future<List<Movie>> getAllMovies({int page = 1, int pageSize = 20}) async {
    final response = await _apiService.get(
      ApiConstants.moviesEndpoint,
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> items = data['items'] ?? [];
      return items.map((e) => Movie.fromJson(e)).toList();
    }
    throw Exception('Failed to load movies');
  }

  Future<Movie> getMovieDetails(String id) async {
    final response = await _apiService.get('${ApiConstants.moviesEndpoint}/$id');
    if (response.statusCode == 200) {
      return Movie.fromJson(response.data);
    }
    throw Exception('Failed to load movie details');
  }
}
