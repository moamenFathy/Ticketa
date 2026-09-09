import 'package:ticketa/core/constants/app_constants.dart';

enum BookingStatus {
  confirmed,
  cancelled,
  completed,
  refunded,
  unknown;

  static BookingStatus fromString(String? value) {
    if (value == null) return BookingStatus.unknown;
    switch (value.toLowerCase()) {
case 'confirmed':
        return BookingStatus.confirmed;
      case 'pending':
        return BookingStatus.completed;
      case 'cancelled':
      case 'canceled':
        return BookingStatus.cancelled;
      case 'refunded':
        return BookingStatus.refunded;
      default:
        return BookingStatus.unknown;
    }
  }
}

class BookingHistoryItemDto {
  final String bookingReference;
  final String movieTitle;
  final String? moviePosterPath;
  final DateTime showtimeStartsAt;
  final int seatCount;
  final double totalAmount;
  final BookingStatus status;

  const BookingHistoryItemDto({
    required this.bookingReference,
    required this.movieTitle,
    this.moviePosterPath,
    required this.showtimeStartsAt,
    required this.seatCount,
    required this.totalAmount,
    required this.status,
  });

  factory BookingHistoryItemDto.fromJson(Map<String, dynamic> json) =>
      BookingHistoryItemDto(
        bookingReference: json['bookingReference'] ?? '',
        movieTitle: json['movieTitle'] ?? '',
        moviePosterPath: json['moviePosterPath'] as String?,
        showtimeStartsAt: DateTime.tryParse(
                json['showtimeStartsAt']?.toString() ?? '') ??
            DateTime.now(),
        seatCount: json['seatCount'] ?? 0,
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
        status: BookingStatus.fromString(json['status']?.toString()),
      );

  bool get isUpcoming => showtimeStartsAt.isAfter(DateTime.now());
  bool get isPast => !isUpcoming;

  String? get fullPosterUrl {
    final path = moviePosterPath;
    if (path == null || path.trim().isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '${AppConstants.tmdbImageBase}${AppConstants.tmdbPosterSize}$cleanPath';
  }
}

class PagedBookingHistoryDto {
  final List<BookingHistoryItemDto> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasMore;

  const PagedBookingHistoryDto({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasMore,
  });

  factory PagedBookingHistoryDto.fromJson(Map<String, dynamic> json) =>
      PagedBookingHistoryDto(
        items: (json['items'] as List<dynamic>?)
                ?.map((e) =>
                    BookingHistoryItemDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        page: json['page'] ?? 1,
        pageSize: json['pageSize'] ?? 0,
        totalCount: json['totalCount'] ?? 0,
        hasMore: json['hasMore'] ?? false,
      );
}