import 'package:flutter/material.dart';

class AppResponsive {
  AppResponsive._();

  /// Returns true if the device is a tablet or iPad (shortest side >= 600)
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide >= 600;

  /// Returns device screen width
  static double width(BuildContext context) => MediaQuery.of(context).size.width;

  /// Returns device screen height
  static double height(BuildContext context) => MediaQuery.of(context).size.height;

  /// Max form/modal width for tablet layouts to keep UI centered and elegant
  static const double maxFormWidth = 520.0;
  static const double maxContentWidth = 900.0;

  /// Horizontal padding dynamically scaled by device type
  static EdgeInsets screenPadding(BuildContext context) =>
      isTablet(context)
          ? const EdgeInsets.symmetric(horizontal: 48)
          : const EdgeInsets.symmetric(horizontal: 20);

  /// Horizontal padding with top/bottom
  static EdgeInsets screenPaddingWithVertical(
    BuildContext context, {
    double top = 16,
    double bottom = 24,
  }) =>
      isTablet(context)
          ? EdgeInsets.fromLTRB(48, top * 1.5, 48, bottom * 1.5)
          : EdgeInsets.fromLTRB(20, top, 20, bottom);

  /// Hero carousel banner height
  static double heroHeight(BuildContext context) =>
      isTablet(context) ? 520.0 : 420.0;

  /// Hero carousel viewport fraction
  static double heroViewportFraction(BuildContext context) =>
      isTablet(context) ? 0.50 : 0.72;

  /// Card width for horizontal movie lists
  static double movieCardWidth(BuildContext context) =>
      isTablet(context) ? 170.0 : 130.0;

  /// Card height for horizontal movie lists
  static double movieCardHeight(BuildContext context) =>
      isTablet(context) ? 250.0 : 190.0;

  /// Grid column count for movies (e.g. See All / Search)
  static int movieGridColumns(BuildContext context) =>
      isTablet(context) ? 4 : 2;

  /// Cast grid column count
  static int castGridColumns(BuildContext context) =>
      isTablet(context) ? 5 : 3;

  /// Font scaling factor for tablet
  static double fontScale(BuildContext context) =>
      isTablet(context) ? 1.15 : 1.0;

  /// Bottom navigation bar height
  static double bottomNavHeight(BuildContext context) =>
      isTablet(context) ? 90.0 : 70.0;

  /// Helper widget to constrain content width in tablet mode and center it
  static Widget constrainedBody({
    required BuildContext context,
    required Widget child,
    double maxWidth = maxContentWidth,
    Alignment alignment = Alignment.topCenter,
  }) {
    if (!isTablet(context)) return child;
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
