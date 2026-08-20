import 'package:ticketa/core/constants/app_constants.dart';

class CastMember {
  final String name;
  final String character;
  final String? profilePath;
  final int order;

  const CastMember({
    required this.name,
    required this.character,
    this.profilePath,
    required this.order,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    String? profilePath = json['profilePath'] ?? json['profile_path'];
    if (profilePath != null && profilePath.isNotEmpty && !profilePath.startsWith('http')) {
      profilePath = '${AppConstants.tmdbImageBase}${AppConstants.tmdbCastSize}$profilePath';
    }
    return CastMember(
      name: json['name'] ?? json['Name'] ?? '',
      character: json['character'] ?? json['Character'] ?? '',
      profilePath: profilePath,
      order: json['order'] ?? json['Order'] ?? 0,
    );
  }
}

class ShowtimeInfo {
  final int id;
  final DateTime startTime;
  final double price;
  final String hallName;
  final int totalSeats;

  const ShowtimeInfo({
    required this.id,
    required this.startTime,
    required this.price,
    this.hallName = '',
    this.totalSeats = 0,
  });

  String get hallType {
    if (totalSeats >= 220) return 'IMAX';
    if (totalSeats >= 80) return 'Standard';
    return 'Gold';
  }

  factory ShowtimeInfo.fromJson(Map<String, dynamic> json) => ShowtimeInfo(
        id: json['id'] ?? 0,
        startTime: DateTime.tryParse(json['startTime']?.toString() ?? '') ?? DateTime.now(),
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        hallName: json['hallName'] ?? '',
        totalSeats: json['totalSeats'] ?? json['visibleSeatCount'] ?? 0,
      );
}

class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String genre;
  final double rating;
  final int duration; // minutes
  final List<DateTime> showTimes;
  final List<ShowtimeInfo> showtimeInfos;
  final String hallType;
  final String overview;
  final String? trailerKey;
  final List<CastMember> cast;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.genre,
    required this.rating,
    required this.duration,
    required this.showTimes,
    this.showtimeInfos = const [],
    this.hallType = 'Standard',
    this.backdropUrl = '',
    this.overview = '',
    this.trailerKey,
    this.cast = const [],
  });

  bool get hasTrailer => trailerKey != null && trailerKey!.isNotEmpty;

  /// Returns individual genres, handles both '|' (dummy) and ', ' (API) separators
  List<String> get genres {
    if (genre.isEmpty) return [];
    if (genre.contains('|')) return genre.split('|').map((e) => e.trim()).toList();
    if (genre.contains(',')) return genre.split(',').map((e) => e.trim()).toList();
    return [genre];
  }

  String get firstGenre => genres.isNotEmpty ? genres.first : '';

  factory Movie.fromJson(Map<String, dynamic> json) {
    String posterPath = json['posterPath'] ?? '';
    if (posterPath.isNotEmpty && !posterPath.startsWith('http')) {
      posterPath = '${AppConstants.tmdbImageBase}${AppConstants.tmdbPosterSize}$posterPath';
    }

    String backdropPath = json['backdropPath'] ?? '';
    if (backdropPath.isNotEmpty && !backdropPath.startsWith('http')) {
      backdropPath = '${AppConstants.tmdbImageBase}${AppConstants.tmdbBackdropSize}$backdropPath';
    }

    final rawShowtimes = (json['showtimes'] as List<dynamic>?);

    List<ShowtimeInfo> showtimeInfos = [];
    List<DateTime> showTimes = [];

    if (rawShowtimes != null) {
      if (rawShowtimes.every((e) => e is String)) {
        showTimes = rawShowtimes
            .map((e) => DateTime.tryParse(e.toString()) ?? DateTime.now())
            .toList();
        showtimeInfos = showTimes
            .map((d) => ShowtimeInfo(id: 0, startTime: d, price: 0, totalSeats: 192))
            .toList();
      } else {
        showtimeInfos = rawShowtimes
            .map((e) => ShowtimeInfo.fromJson(e as Map<String, dynamic>))
            .toList();
        showTimes = showtimeInfos.map((s) => s.startTime).toList();
      }
    }

    return Movie(
      id: json['id']?.toString() ?? json['movieId']?.toString() ?? '',
      title: json['title'] ?? '',
      posterUrl: posterPath,
      backdropUrl: backdropPath,
      genre: (json['genres'] as List<dynamic>?)?.join(', ') ?? '',
      rating: (json['voteAverage'] as num?)?.toDouble() ?? (json['rate'] as num?)?.toDouble() ?? 0.0,
      duration: json['runtime'] ?? 0,
      overview: json['overview'] ?? '',
      trailerKey: json['trailerKey'] as String?,
      cast: (json['cast'] as List<dynamic>?)
              ?.map((e) => CastMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      showTimes: showTimes,
      showtimeInfos: showtimeInfos,
      hallType: showtimeInfos.isNotEmpty ? showtimeInfos.first.hallType : 'Standard',
    );
  }
}