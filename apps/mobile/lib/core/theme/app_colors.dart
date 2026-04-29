import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية من اللوجو
  static const Color warmOrange = Color(0xFFF2612B);
  static const Color lighterOrange = Color(0xFFFF7F50);
  static const Color deepCharcoal = Color(0xFF1A252A); // للـ Dark Mode
  static const Color softCharcoal = Color(0xFF2C3E50); // للـ Light Mode text
  static const Color lightCream = Color(0xFFF9F9F9);
  static const Color terracotta = Color(0xFFC15637);

  // Light Mode Colors
  static const Color primaryLight = warmOrange;
  static const Color secondaryLight = softCharcoal;
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = lightCream;

  // Dark Mode Colors
  static const Color primaryDark = lighterOrange;
  static const Color secondaryDark = terracotta;
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = deepCharcoal;

  // Status Colors
  static const Color error = Color(0xFFD32F2F);
}