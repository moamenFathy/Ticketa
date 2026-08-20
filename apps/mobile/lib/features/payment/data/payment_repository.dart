import 'package:ticketa/core/constants/api_constants.dart';
import 'package:ticketa/core/network/api_service.dart';
import 'package:ticketa/features/payment/data/models/payment_models.dart';

class PaymentRepository {
  final ApiService _apiService;

  PaymentRepository(this._apiService);

  Future<PaymentConfigDto> getConfig() async {
    final response = await _apiService.get(ApiConstants.paymentsConfigEndpoint);
    return PaymentConfigDto.fromJson(response.data);
  }

  Future<PaymentIntentResultDto> createIntent(CreatePaymentIntentDto dto) async {
    final response = await _apiService.post(
      '${ApiConstants.paymentsEndpoint}/create-intent',
      data: dto.toJson(),
    );
    return PaymentIntentResultDto.fromJson(response.data);
  }

  Future<ConfirmPaymentResultDto> confirmPayment(String paymentIntentId) async {
    final response = await _apiService.post(
      '${ApiConstants.paymentsEndpoint}/confirm-payment',
      data: {'paymentIntentId': paymentIntentId},
    );
    return ConfirmPaymentResultDto.fromJson(response.data);
  }
}