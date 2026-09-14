import 'package:ticketa/features/booking/data/models/seat_dto.dart';

class PaymentConfigDto {
  final String publishableKey;

  const PaymentConfigDto({required this.publishableKey});

  factory PaymentConfigDto.fromJson(Map<String, dynamic> json) =>
      PaymentConfigDto(publishableKey: json['publishableKey'] ?? '');
}

class CreatePaymentIntentDto {
  final int showtimeId;
  final List<SeatDto> seats;

  const CreatePaymentIntentDto({required this.showtimeId, required this.seats});

  Map<String, dynamic> toJson() => {
        'showtimeId': showtimeId,
        'seats': seats.map((s) => s.toJson()).toList(),
      };
}

class PaymentIntentResultDto {
  final String clientSecret;
  final String paymentIntentId;
  final double totalAmount;

  const PaymentIntentResultDto({
    required this.clientSecret,
    required this.paymentIntentId,
    required this.totalAmount,
  });

  factory PaymentIntentResultDto.fromJson(Map<String, dynamic> json) =>
      PaymentIntentResultDto(
        clientSecret: json['clientSecret'] ?? '',
        paymentIntentId: json['paymentIntentId'] ?? '',
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      );
}

class ConfirmPaymentResultDto {
  final bool succeeded;
  final String? bookingReference;
  final double? totalAmount;
  final String message;

  const ConfirmPaymentResultDto({
    required this.succeeded,
    this.bookingReference,
    this.totalAmount,
    this.message = '',
  });

  factory ConfirmPaymentResultDto.fromJson(Map<String, dynamic> json) =>
      ConfirmPaymentResultDto(
        succeeded: json['succeeded'] ?? false,
        bookingReference: json['bookingReference'] as String?,
        totalAmount: (json['totalAmount'] as num?)?.toDouble(),
        message: json['message'] ?? '',
      );
}