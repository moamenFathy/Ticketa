import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildAnimatedAvatar(theme, isDark),
        const SizedBox(height: 20),
        Text(
          "MOHAMED AHMED",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "mohamed@ticketa.com",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 25),
        _buildEditProfileButton(theme),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildAnimatedAvatar(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.warmOrange, Colors.orangeAccent],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmOrange.withOpacity(0.3),
            blurRadius: 25,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 55,
          backgroundColor: theme.colorScheme.onSurface.withOpacity(0.05),
          child: Icon(
            Icons.person_rounded,
            size: 60,
            color: theme.colorScheme.onSurface.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildEditProfileButton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_rounded, color: theme.colorScheme.onSurface, size: 14),
                const SizedBox(width: 8),
                Text(
                  "EDIT PROFILE",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
