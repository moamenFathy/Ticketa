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
    String? profilePath = json['profilePath'];
    if (profilePath != null && profilePath.isNotEmpty && !profilePath.startsWith('http')) {
      profilePath = 'https://image.tmdb.org/t/p/w185$profilePath';
    }
    return CastMember(
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: profilePath,
      order: json['order'] ?? 0,
    );
  }
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
      posterPath = 'https://image.tmdb.org/t/p/w500$posterPath';
    }

    String backdropPath = json['backdropPath'] ?? '';
    if (backdropPath.isNotEmpty && !backdropPath.startsWith('http')) {
      backdropPath = 'https://image.tmdb.org/t/p/w1280$backdropPath';
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
      // API might return list of ISO DateTime strings OR list of Showtime objects with startTime
      showTimes: (json['showtimes'] as List<dynamic>?)
              ?.map((e) {
                if (e is Map<String, dynamic> && e.containsKey('startTime')) {
                  return DateTime.tryParse(e['startTime'].toString()) ?? DateTime.now();
                }
                return DateTime.tryParse(e.toString()) ?? DateTime.now();
              })
              .toList() ??
          [],
      hallType: json['hallType']?.toString() ?? 'Standard',
    );
  }
}