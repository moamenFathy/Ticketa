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

  const PaymentPage({
    super.key,
    required this.totalAmount,
    required this.movieTitle,
    required this.selectedSeats,
    required this.date,
    required this.time,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _selectedMethod = 0; // 0: Card, 1: Apple Pay
  final bool _isProcessing = false;

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
            
            // Card Input Form (Animated)
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

  void _simulateApplePay(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: theme.colorScheme.onSurface.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 32),
            Icon(Icons.apple_rounded, size: 48, color: theme.colorScheme.onSurface),
            const SizedBox(height: 16),
            Text("Apple Pay", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total", style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.bold)),
                  Text("${widget.totalAmount.toStringAsFixed(0)} EGP", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: theme.colorScheme.onSurface)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.all(32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handlePaymentSuccess();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black, 
                    foregroundColor: isDark ? Colors.black : Colors.white, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.face_unlock_rounded),
                      const SizedBox(width: 12),
                      const Text("Pay with Face ID", style: TextStyle(fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ),
            ),
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
          if (_selectedMethod == 1) {
            _simulateApplePay(context, theme);
          } else {
            _handlePaymentSuccess();
          }
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
