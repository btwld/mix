import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/variant.dart';
import '../../core/deprecated.dart';
import 'on_directionality_util.dart';
import 'on_not_util.dart';
import 'on_platform_util.dart';

class OnContextVariantUtility {
  // Platform variants
  final macos = const OnPlatformVariant(TargetPlatform.macOS);
  final android = const OnPlatformVariant(TargetPlatform.android);
  final fuchsia = const OnPlatformVariant(TargetPlatform.fuchsia);
  final ios = const OnPlatformVariant(TargetPlatform.iOS);
  final linux = const OnPlatformVariant(TargetPlatform.linux);
  final windows = const OnPlatformVariant(TargetPlatform.windows);
  final web = const OnWebVariant();

  // Breakpoint variants (deprecated - use MediaQueryVariant.size() instead)
  final small = const OnBreakpointTokenVariant(BreakpointTokens.small);
  final xsmall = const OnBreakpointTokenVariant(BreakpointTokens.xsmall);
  final medium = const OnBreakpointTokenVariant(BreakpointTokens.medium);
  final large = const OnBreakpointTokenVariant(BreakpointTokens.large);
  final breakpoint = OnBreakPointVariant.new;
  final breakpointToken = OnBreakpointTokenVariant.new;

  // Brightness variants - now use MediaQueryVariant
  final light = MediaQueryVariant.platformBrightness(Brightness.light);
  final dark = MediaQueryVariant.platformBrightness(Brightness.dark);

  // Directionality variants
  final ltr = const OnDirectionalityVariant(TextDirection.ltr);
  final rtl = const OnDirectionalityVariant(TextDirection.rtl);

  // Orientation variants - now use MediaQueryVariant
  final landscape = MediaQueryVariant.orientation(Orientation.landscape);
  final portrait = MediaQueryVariant.orientation(Orientation.portrait);

  // Widget state variants
  final press = const WidgetStateVariant(WidgetState.pressed);
  final hover = const WidgetStateVariant(WidgetState.hovered);
  final focus = const WidgetStateVariant(WidgetState.focused);
  final enabled = const OnNotVariant(WidgetStateVariant(WidgetState.disabled));
  final disabled = const WidgetStateVariant(WidgetState.disabled);
  final selected = const WidgetStateVariant(WidgetState.selected);
  final unselected = const OnNotVariant(
    WidgetStateVariant(WidgetState.selected),
  );
  final dragged = const WidgetStateVariant(WidgetState.dragged);
  final error = const WidgetStateVariant(WidgetState.error);

  /// Creates an [OnNotVariant] with the specified [variant].
  ///
  /// This reverses the result of the specified [variant].
  ///
  /// For example, if the specified [variant] evaluates to `true`,
  /// the [OnNotVariant] with that variant will evaluate to `false`, and vice versa.
  final not = OnNotVariant.new;
  static final self = OnContextVariantUtility._();

  OnContextVariantUtility._();
}
