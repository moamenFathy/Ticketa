import 'package:flutter/material.dart';

class AppResponsive {
  // Returns true if the device is a tablet or iPad
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide >= 600;

  static double heroHeight(BuildContext context) =>
      isTablet(context) ? 400 : 300;

  static double cardWidth(BuildContext context) =>
      isTablet(context)
          ? MediaQuery.of(context).size.width * 0.65
          : MediaQuery.of(context).size.width * 0.88;

  static double sidebarWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double fontScale(BuildContext context) =>
      isTablet(context) ? 1.15 : 1.0;

  static EdgeInsets screenPadding(BuildContext context) =>
      isTablet(context)
          ? const EdgeInsets.symmetric(horizontal: 60)
          : const EdgeInsets.symmetric(horizontal: 24);

  // Bottom Nav height
  static double bottomNavHeight(BuildContext context) =>
      isTablet(context) ? 100 : 80;
}
