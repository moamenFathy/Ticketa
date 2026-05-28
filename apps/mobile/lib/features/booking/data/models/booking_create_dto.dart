import 'seat_dto.dart';

class BookingCreateDto {
  final int showtimeId;
  final List<SeatDto> seats;

  const BookingCreateDto({required this.showtimeId, required this.seats});

  Map<String, dynamic> toJson() => {
        'showtimeId': showtimeId,
        'seats': seats.map((s) => s.toJson()).toList(),
      };
}
