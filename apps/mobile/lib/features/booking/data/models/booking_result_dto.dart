import 'seat_dto.dart';

class BookingResultDto {
  final bool succeeded;
  final String? bookingReference;
  final double? totalAmount;
  final List<SeatDto> conflictingSeats;

  const BookingResultDto({
    required this.succeeded,
    this.bookingReference,
    this.totalAmount,
    this.conflictingSeats = const [],
  });

  factory BookingResultDto.fromJson(Map<String, dynamic> json) => BookingResultDto(
        succeeded: true,
        bookingReference: json['bookingReference']?.toString(),
        totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      );

  factory BookingResultDto.conflict(Map<String, dynamic> json) {
    final seats = (json['conflictingSeats'] as List<dynamic>?)
            ?.map((e) => SeatDto.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return BookingResultDto(
      succeeded: false,
      conflictingSeats: seats,
    );
  }
}
