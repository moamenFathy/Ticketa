import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/features/payment/data/models/payment_models.dart';
import 'package:ticketa/features/payment/data/payment_repository.dart';

abstract class PaymentState {}

class PaymentIdle extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentIntentReady extends PaymentState {
  final PaymentIntentResultDto intent;

  PaymentIntentReady(this.intent);
}

class PaymentSuccess extends PaymentState {
  final ConfirmPaymentResultDto result;

  PaymentSuccess(this.result);
}

class PaymentFailure extends PaymentState {
  final String message;

  PaymentFailure(this.message);
}

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _repository;

  PaymentCubit(this._repository) : super(PaymentIdle());

  Future<void> createIntent(CreatePaymentIntentDto dto) async {
    emit(PaymentLoading());
    try {
      final intent = await _repository.createIntent(dto);
      emit(PaymentIntentReady(intent));
    } catch (e) {
      emit(PaymentFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> confirmPayment(String paymentIntentId) async {
    emit(PaymentLoading());
    try {
      final result = await _repository.confirmPayment(paymentIntentId);
      if (result.succeeded) {
        emit(PaymentSuccess(result));
      } else {
        emit(PaymentFailure(result.message.isEmpty
            ? 'Payment could not be confirmed'
            : result.message));
      }
    } catch (e) {
      emit(PaymentFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void reset() => emit(PaymentIdle());
}