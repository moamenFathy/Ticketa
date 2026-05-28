import 'package:ticketa/core/constants/api_constants.dart';
import 'package:ticketa/core/network/api_service.dart';
import 'package:ticketa/features/booking/data/models/booking_create_dto.dart';
import 'package:ticketa/features/booking/data/models/booking_details_dto.dart';
import 'package:ticketa/features/booking/data/models/booking_result_dto.dart';
import 'package:ticketa/features/booking/data/models/showtime_seat_dto.dart';

class BookingRepository {
  final ApiService _apiService;

  BookingRepository(this._apiService);

  Future<ShowtimeSeatDto> getSeatMap(int showtimeId) async {
    final response =
        await _apiService.get('${ApiConstants.showtimeSeatsEndpoint}/$showtimeId/seats');
    return ShowtimeSeatDto.fromJson(response.data);
  }

  Future<BookingResultDto> createBooking(BookingCreateDto dto) async {
    final response = await _apiService.post(
      ApiConstants.bookingsEndpoint,
      data: dto.toJson(),
    );
    return BookingResultDto.fromJson(response.data);
  }

  Future<BookingDetailsDto> getBookingByReference(String reference) async {
    final response = await _apiService.get(
      '${ApiConstants.bookingsEndpoint}/$reference',
    );
    return BookingDetailsDto.fromJson(response.data);
  }
}
