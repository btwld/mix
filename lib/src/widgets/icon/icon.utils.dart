import 'package:flutter/material.dart';

import 'icon.attributes.dart';

/// ## Widget
/// - [IconMix](IconMix-class.html)
///
/// Utility functions and short utils are listed in [Static Methods](#static-methods)
///
/// {@category Utilities}
class IconUtility {
  const IconUtility._();

  /// Short Utils: icon
  static IconAttributes icon({double? size, Color? color}) {
    return IconAttributes(
      size: size,
      color: color,
    );
  }

  /// Short Utils: iconSize
  static IconAttributes iconSize(double size) {
    return IconAttributes(
      size: size,
    );
  }

  /// Short Utils: iconColor
  static IconAttributes iconColor(Color color) {
    return IconAttributes(
      color: color,
    );
  }
}
