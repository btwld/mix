import 'package:flutter/material.dart';

import '../core/factory/mix_data.dart';
import '../core/factory/mix_provider.dart';
import '../theme/mix/mix_theme.dart';

extension BuildContextExt on BuildContext {
  MixData? get mix => Mix.maybeOf(this);

  /// MEDIA QUERY EXTENSION METHODS

  /// Directionality of context.
  TextDirection get directionality => Directionality.of(this);

  /// Orientation of the device.

  Orientation get orientation => MediaQuery.of(this).orientation;

  /// Screen size.

  Size get screenSize => MediaQuery.of(this).size;

  // Theme Context Extensions.
  Brightness get brightness => Theme.of(this).brightness;

  /// Theme context helpers.
  ThemeData get theme => Theme.of(this);

  /// Theme color scheme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Theme text theme.
  TextTheme get textTheme => theme.textTheme;

  /// Mix Theme Data.
  MixThemeData get mixTheme => MixTheme.of(this);

  /// Check if brightness is Brightness.dark.
  bool get isDarkMode => brightness == Brightness.dark;

  /// Is device in landscape mode.
  bool get isLandscape => orientation == Orientation.landscape;

  /// Is device in portrait mode.
  bool get isPortrait => orientation == Orientation.portrait;
}
