import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';

class PaymentMethodSelector extends StatelessWidget {
  final int index;
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodSelector({
    super.key,
    required this.index,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.warmOrange.withValues(alpha: 0.1) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.warmOrange : theme.colorScheme.onSurface.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.warmOrange : theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
}
