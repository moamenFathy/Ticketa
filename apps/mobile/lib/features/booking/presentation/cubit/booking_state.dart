import 'package:ticketa/features/booking/data/models/booking_details_dto.dart';
import 'package:ticketa/features/booking/data/models/showtime_seat_dto.dart';

sealed class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class SeatMapLoaded extends BookingState {
  final ShowtimeSeatDto seatMap;
  final List<String> selectedSeats;

  SeatMapLoaded({required this.seatMap, this.selectedSeats = const []});
}

class BookingCreated extends BookingState {
  final String bookingReference;
  final double totalAmount;
  final BookingDetailsDto? details;

  BookingCreated({
    required this.bookingReference,
    required this.totalAmount,
    this.details,
  });
}

class BookingSeatConflict extends BookingState {
  final List<String> conflictingSeatIds;

  BookingSeatConflict(this.conflictingSeatIds);
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);
}

class BookingLoadingDetails extends BookingState {}

class BookingDetailsLoaded extends BookingState {
  final BookingDetailsDto details;

  BookingDetailsLoaded(this.details);
}
