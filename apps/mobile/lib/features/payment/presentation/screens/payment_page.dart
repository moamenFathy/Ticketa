import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/core/services/message_service.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/booking/data/models/seat_dto.dart';
import 'package:ticketa/features/payment/data/models/payment_models.dart';
import 'package:ticketa/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:ticketa/features/payment/presentation/screens/booking_success_page.dart';
import 'package:ticketa/features/payment/presentation/widgets/order_summary.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final String movieTitle;
  final List<SeatDto> seats;
  final String date;
  final String time;
  final String? bookingReference;
  final int showtimeId;
  final String? moviePoster;
  final String? hallName;

  const PaymentPage({
    super.key,
    required this.totalAmount,
    required this.movieTitle,
    required this.seats,
    required this.date,
    required this.time,
    this.bookingReference,
    this.showtimeId = 0,
    this.moviePoster,
    this.hallName,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static const String _publishableKey =
      'pk_test_51TjmWwRFtQmaK3YIn0wPIZz2f3Zob8aUwvcZzeW2RkKngGTi6pPXiCjCqXqtQpiogz8lvcjQqM89kG6VwpF9kMv7006Yv3TyGG';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setupStripe());
  }

  Future<void> _setupStripe() async {
    Stripe.publishableKey = _publishableKey;
    await Stripe.instance.applySettings();
  }

  List<String> get _seatLabels =>
      widget.seats.map((s) => 'R${s.row}-S${s.seatNumber}').toList();

  Future<void> _onPayPressed(BuildContext ctx) async {
    debugPrint('[payment] pay pressed, '
        'showtimeId=${widget.showtimeId} seats=${widget.seats.length}');
    final cubit = ctx.read<PaymentCubit>();
    var state = cubit.state;

    if (state is! PaymentIntentReady) {
      await cubit.createIntent(CreatePaymentIntentDto(
        showtimeId: widget.showtimeId,
        seats: widget.seats,
      ));
      state = cubit.state;
    }
    debugPrint('[payment] after createIntent -> ${state.runtimeType}');
    if (state is! PaymentIntentReady) return;

    final theme = Theme.of(context);
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: state.intent.clientSecret,
          merchantDisplayName: 'Ticketa',
          style: theme.brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
    } on PlatformException catch (e) {
      if (!mounted) return;
      MessageService.showWarning(
        context: context,
        message: e.code == 'PaymentSheetCancelled'
            ? 'Payment cancelled'
            : 'Payment failed: ${e.message ?? ''}',
      );
      return;
    } catch (_) {
      if (!mounted) return;
      MessageService.showWarning(
        context: context,
        message: 'Payment failed, please try again.',
      );
      return;
    }

    await cubit.confirmPayment(state.intent.paymentIntentId);
  }

  void _handlePaymentSuccess(ConfirmPaymentResultDto result) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingSuccessPage(
          movieTitle: widget.movieTitle,
          date: widget.date,
          time: widget.time,
          seats: _seatLabels,
          totalAmount: result.totalAmount ?? widget.totalAmount,
          bookingReference: result.bookingReference ?? widget.bookingReference,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => getIt<PaymentCubit>(),
      child: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            _handlePaymentSuccess(state.result);
          } else if (state is PaymentFailure) {
            MessageService.showWarning(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          final isProcessing = state is PaymentLoading;

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              title: Text(
                  l10n.paymentMethod,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderSummary(
                    movieTitle: widget.movieTitle,
                    date: widget.date,
                    time: widget.time,
                    selectedSeats: _seatLabels,
                    totalAmount: state is PaymentIntentReady
                        ? state.intent.totalAmount
                        : widget.totalAmount,
                  ),
                  const SizedBox(height: 32),

                  Text(
                    l10n.paymentMethod,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(Icons.credit_card_rounded,
                          color: AppColors.warmOrange, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.creditCard,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Icon(Icons.lock_outline_rounded,
                          size: 16,
                          color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'secure',
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.green, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You will confirm your card securely inside the Stripe payment sheet.',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.45)),
                  ),

                  const SizedBox(height: 40),
                  _buildPayButton(l10n, theme, isProcessing, context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPayButton(
      AppLocalizations l10n, ThemeData theme, bool isProcessing, BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isProcessing ? null : () => _onPayPressed(ctx),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warmOrange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          shadowColor: AppColors.warmOrange.withValues(alpha: 0.5),
        ),
        child: isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                l10n.payNow,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }
}