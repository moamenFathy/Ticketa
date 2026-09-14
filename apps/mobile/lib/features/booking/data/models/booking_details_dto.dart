class BookingDetailsSeatDto {
  final int row;
  final int seatNumber;
  final String category;
  final double price;

  const BookingDetailsSeatDto({
    required this.row,
    required this.seatNumber,
    required this.category,
    required this.price,
  });

  factory BookingDetailsSeatDto.fromJson(Map<String, dynamic> json) =>
      BookingDetailsSeatDto(
        row: json['row'] ?? 0,
        seatNumber: json['seatNumber'] ?? 0,
        category: json['category'] ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
      );

  String get display => 'R${row}-S$seatNumber';
}

class BookingDetailsDto {
  final String userId;
  final String userEmail;
  final String bookingReference;
  final String status;
  final DateTime bookedAt;
  final double totalAmount;
  final String movieTitle;
  final String? moviePosterPath;
  final DateTime startsAt;
  final String hallName;
  final String hallType;
  final List<BookingDetailsSeatDto> seats;

  const BookingDetailsDto({
    required this.userId,
    required this.userEmail,
    required this.bookingReference,
    required this.status,
    required this.bookedAt,
    required this.totalAmount,
    required this.movieTitle,
    this.moviePosterPath,
    required this.startsAt,
    required this.hallName,
    required this.hallType,
    required this.seats,
  });

  factory BookingDetailsDto.fromJson(Map<String, dynamic> json) =>
      BookingDetailsDto(
        userId: json['userId'] ?? '',
        userEmail: json['userEmail'] ?? '',
        bookingReference: json['bookingRefrence'] ?? '',
        status: json['status'] ?? '',
        bookedAt:
            DateTime.tryParse(json['bookedAt']?.toString() ?? '') ?? DateTime.now(),
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
        movieTitle: json['movieTitle'] ?? '',
        moviePosterPath: json['moviePosterPath'] as String?,
        startsAt:
            DateTime.tryParse(json['startsAt']?.toString() ?? '') ??
                DateTime.now(),
        hallName: json['hallName'] ?? '',
        hallType: json['hallType'] ?? '',
        seats: (json['seats'] as List<dynamic>?)
                ?.map((e) =>
                    BookingDetailsSeatDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  String get seatsDisplay => seats.map((s) => s.display).join(', ');

  String get dateFormatted {
    final m = startsAt.month.toString().padLeft(2, '0');
    final d = startsAt.day.toString().padLeft(2, '0');
    return '${startsAt.year}-$m-$d';
  }

  String get timeFormatted {
    final h = startsAt.hour.toString().padLeft(2, '0');
    final m = startsAt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
