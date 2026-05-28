import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/features/booking/data/booking_repository.dart';
import 'package:ticketa/features/booking/data/models/booking_create_dto.dart';
import 'package:ticketa/features/booking/data/models/booking_details_dto.dart';
import 'package:ticketa/features/booking/data/models/seat_dto.dart';
import 'package:ticketa/features/booking/presentation/cubit/booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _repository;

  BookingCubit(this._repository) : super(BookingInitial());

  Future<void> loadSeatMap(int showtimeId) async {
    emit(BookingLoading());
    try {
      final seatMap = await _repository.getSeatMap(showtimeId);
      emit(SeatMapLoaded(seatMap: seatMap));
    } catch (e) {
      emit(BookingError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void toggleSeat(String seatId) {
    final current = state;
    if (current is! SeatMapLoaded) return;
    final seats = List<String>.from(current.selectedSeats);
    if (seats.contains(seatId)) {
      seats.remove(seatId);
    } else {
      seats.add(seatId);
    }
    emit(SeatMapLoaded(seatMap: current.seatMap, selectedSeats: seats));
  }

  Future<void> createBooking(int showtimeId, List<SeatDto> seats) async {
    emit(BookingLoading());
    try {
      final dto = BookingCreateDto(showtimeId: showtimeId, seats: seats);
      final result = await _repository.createBooking(dto);
      if (result.succeeded) {
        BookingDetailsDto? details;
        if (result.bookingReference != null) {
          try {
            details = await _repository.getBookingByReference(result.bookingReference!);
          } catch (_) {}
        }
        emit(BookingCreated(
          bookingReference: result.bookingReference ?? '',
          totalAmount: result.totalAmount ?? 0.0,
          details: details,
        ));
      } else {
        final conflictIds = result.conflictingSeats.map((s) => s.id).toList();
        emit(BookingSeatConflict(conflictIds));
      }
    } catch (e) {
      emit(BookingError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void reset() => emit(BookingInitial());
}
