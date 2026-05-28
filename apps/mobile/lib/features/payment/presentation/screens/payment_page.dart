import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import 'package:ticketa/features/payment/presentation/screens/booking_success_page.dart';
import 'package:ticketa/features/payment/presentation/widgets/order_summary.dart';
import 'package:ticketa/features/payment/presentation/widgets/card_input_form.dart';
import 'package:ticketa/features/payment/presentation/widgets/payment_method_selector.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final String movieTitle;
  final List<String> selectedSeats;
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
    required this.selectedSeats,
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
  int _selectedMethod = 0;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.paymentMethod, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
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
              selectedSeats: widget.selectedSeats,
              totalAmount: widget.totalAmount,
            ),
            const SizedBox(height: 32),

            Text(
              l10n.paymentMethod,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),

            PaymentMethodSelector(
              index: 0,
              title: l10n.creditCard,
              icon: Icons.credit_card_rounded,
              isSelected: _selectedMethod == 0,
              onTap: () => setState(() => _selectedMethod = 0),
            ),

            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: const CardInputForm(),
              crossFadeState: _selectedMethod == 0 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),

            const SizedBox(height: 12),
            PaymentMethodSelector(
              index: 1,
              title: "Apple Pay",
              icon: Icons.apple_rounded,
              isSelected: _selectedMethod == 1,
              onTap: () => setState(() => _selectedMethod = 1),
            ),

            const SizedBox(height: 40),
            _buildPayButton(l10n, theme),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _handlePaymentSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingSuccessPage(
          movieTitle: widget.movieTitle,
          date: widget.date,
          time: widget.time,
          seats: widget.selectedSeats,
          totalAmount: widget.totalAmount,
          bookingReference: widget.bookingReference,
        ),
      ),
    );
  }

  Widget _buildPayButton(AppLocalizations l10n, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : () {
          setState(() => _isProcessing = true);
          Future.delayed(const Duration(milliseconds: 800), () {
            if (!mounted) return;
            setState(() => _isProcessing = false);
            _handlePaymentSuccess();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warmOrange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          shadowColor: AppColors.warmOrange.withValues(alpha: 0.5),
        ),
        child: _isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                l10n.payNow,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }
}
