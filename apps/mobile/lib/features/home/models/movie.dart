class Movie {
  final String id;
  final String title;
  final String posterUrl; // نستخدم أسماء أصول محلية حالياً
  final String genre;
  final double rating;
  final int duration; // minutes
  final List<DateTime> showTimes;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.genre,
    required this.rating,
    required this.duration,
    required this.showTimes,
  });
}