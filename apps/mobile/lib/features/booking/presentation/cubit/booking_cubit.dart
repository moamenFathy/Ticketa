import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/features/booking/data/booking_repository.dart';
import 'package:ticketa/features/booking/data/models/booking_create_dto.dart';
import 'package:ticketa/features/booking/data/models/booking_details_dto.dart';
import 'package:ticketa/features/booking/data/models/seat_dto.dart';
import 'package:ticketa/features/booking/presentation/cubit/booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _repository;
  SeatMapLoaded? _lastLoaded;

  BookingCubit(this._repository) : super(BookingInitial());

  SeatMapLoaded? get lastLoaded => _lastLoaded;

  Future<void> loadSeatMap(int showtimeId) async {
    emit(BookingLoading());
    try {
      final seatMap = await _repository.getSeatMap(showtimeId);
      final loaded = SeatMapLoaded(seatMap: seatMap);
      _lastLoaded = loaded;
      emit(loaded);
    } catch (e) {
      _lastLoaded = null;
      emit(BookingError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  static const int maxSeats = 10;

  bool toggleSeat(String seatId) {
    final current = state;
    if (current is! SeatMapLoaded) return false;
    final seats = List<String>.from(current.selectedSeats);
    if (seats.contains(seatId)) {
      seats.remove(seatId);
    } else {
      if (seats.length >= maxSeats) return false;
      seats.add(seatId);
    }
    final updated = SeatMapLoaded(seatMap: current.seatMap, selectedSeats: seats);
    _lastLoaded = updated;
    emit(updated);
    return true;
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
