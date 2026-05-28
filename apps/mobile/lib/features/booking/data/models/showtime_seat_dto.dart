import 'seat_dto.dart';

class ShowtimeSeatDto {
  final int showtimeId;
  final int movieId;
  final String movieTitle;
  final String? moviePosterPath;
  final String hallName;
  final String hallType;
  final DateTime startsAt;
  final double basePrice;
  final int rows;
  final int seatsPerRow;
  final Map<int, String> rowCategoryMap;
  final Map<String, double> categoryPrices;
  final List<SeatDto> bookedSeats;

  const ShowtimeSeatDto({
    required this.showtimeId,
    required this.movieId,
    required this.movieTitle,
    this.moviePosterPath,
    required this.hallName,
    required this.hallType,
    required this.startsAt,
    required this.basePrice,
    required this.rows,
    required this.seatsPerRow,
    required this.rowCategoryMap,
    required this.categoryPrices,
    required this.bookedSeats,
  });

  factory ShowtimeSeatDto.fromJson(Map<String, dynamic> json) {
    final rawMap = json['rowCategoryMap'] as Map<String, dynamic>? ?? {};
    final rowMap = rawMap.map((k, v) => MapEntry(int.parse(k), v.toString()));

    final rawPrices = json['categoryPrices'] as Map<String, dynamic>? ?? {};
    final prices = rawPrices.map((k, v) => MapEntry(k, (v as num).toDouble()));

    return ShowtimeSeatDto(
      showtimeId: json['showtimeId'] ?? 0,
      movieId: json['movieId'] ?? 0,
      movieTitle: json['movieTitle'] ?? '',
      moviePosterPath: json['moviePosterPath'] as String?,
      hallName: json['hallName'] ?? '',
      hallType: json['hallType'] ?? '',
      startsAt: DateTime.tryParse(json['startsAt']?.toString() ?? '') ?? DateTime.now(),
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
      rows: json['rows'] ?? 0,
      seatsPerRow: json['seatsPerRow'] ?? 0,
      rowCategoryMap: rowMap,
      categoryPrices: prices,
      bookedSeats: (json['bookedSeats'] as List<dynamic>?)
              ?.map((e) => SeatDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
