import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';

class CardInputForm extends StatelessWidget {
  const CardInputForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
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

  Widget _buildTextField(ThemeData theme, String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
            prefixIcon: Icon(icon, size: 18, color: AppColors.warmOrange.withValues(alpha: 0.5)),
            filled: true,
            fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
