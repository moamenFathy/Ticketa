import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/widgets/glass_card.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import 'package:ticketa/features/payment/presentation/pages/booking_success_page.dart';

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
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.paymentMethod, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(l10n, theme),
            const SizedBox(height: 32),
            
            Text(
              l10n.paymentMethod,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildPaymentMethod(0, l10n.creditCard, Icons.credit_card_rounded, theme),
            
            // Card Input Form (Animated)
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: _buildCardForm(theme),
              crossFadeState: _selectedMethod == 0 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
            
            const SizedBox(height: 12),
            _buildPaymentMethod(1, "Apple Pay", Icons.apple_rounded, theme),
            
            const SizedBox(height: 40),
            _buildPayButton(l10n, theme),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          _buildTextField(theme, "Card Number", "XXXX XXXX XXXX XXXX", Icons.payment_rounded),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField(theme, "Expiry Date", "MM/YY", Icons.calendar_today_rounded)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField(theme, "CVV", "XXX", Icons.lock_outline_rounded)),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(theme, "Card Holder", "FULL NAME", Icons.person_outline_rounded),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(AppLocalizations l10n, ThemeData theme) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.orderSummary,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.warmOrange,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const Icon(Icons.receipt_long_rounded, color: AppColors.warmOrange, size: 18),
            ],
          ),
          const Divider(height: 30, color: Colors.white12),
          _summaryRow(l10n.movie, widget.movieTitle, theme),
          const SizedBox(height: 12),
          _summaryRow(l10n.date, "${widget.date} | ${widget.time}", theme),
          const SizedBox(height: 12),
          _summaryRow(l10n.seats, widget.selectedSeats.join(", "), theme),
          const Divider(height: 30, color: Colors.white12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.total, style: theme.textTheme.titleMedium),
              Text(
                "${widget.totalAmount.toStringAsFixed(0)} EGP",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.warmOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white38)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(ThemeData theme, String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: Colors.white38)),
        const SizedBox(height: 8),
        TextField(
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white10),
            prefixIcon: Icon(icon, size: 18, color: AppColors.warmOrange.withOpacity(0.5)),
            filled: true,
            fillColor: Colors.black26,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(int index, String title, IconData icon, ThemeData theme) {
    bool isSelected = _selectedMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.warmOrange.withOpacity(0.1) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.warmOrange : theme.dividerColor.withOpacity(0.05),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.warmOrange : Colors.white24),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.white38,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.warmOrange, size: 20),
          ],
        ),
      ),
    );
  }

  void _simulateApplePay(BuildContext context, AppLocalizations l10n, ThemeData theme) {
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
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 32),
            const Icon(Icons.apple_rounded, size: 48, color: Colors.white),
            const SizedBox(height: 16),
            const Text("Apple Pay", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total", style: TextStyle(color: Colors.white38)),
                  Text("${widget.totalAmount.toStringAsFixed(0)} EGP", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.face_unlock_rounded),
                      SizedBox(width: 12),
                      Text("Pay with Face ID", style: TextStyle(fontWeight: FontWeight.bold)),
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
            _simulateApplePay(context, l10n, theme);
          } else {
            _handlePaymentSuccess();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warmOrange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          shadowColor: AppColors.warmOrange.withOpacity(0.5),
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
