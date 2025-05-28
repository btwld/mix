import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../core/factory/style_mix.dart';
import '../../theme/tokens/breakpoints_token.dart';
import '../widget_state_variant.dart';
import 'on_breakpoint_util.dart';
import 'on_brightness_util.dart';
import 'on_directionality_util.dart';
import 'on_not_util.dart';
import 'on_orientation_util.dart';
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

  // Breakpoint variants
  final small = const OnBreakpointTokenVariant(BreakpointToken.small);
  final xsmall = const OnBreakpointTokenVariant(BreakpointToken.xsmall);
  final medium = const OnBreakpointTokenVariant(BreakpointToken.medium);
  final large = const OnBreakpointTokenVariant(BreakpointToken.large);
  final breakpoint = OnBreakPointVariant.new;
  final breakpointToken = OnBreakpointTokenVariant.new;

  // Brightness variants
  final light = const OnBrightnessVariant(Brightness.light);
  final dark = const OnBrightnessVariant(Brightness.dark);

  // Directionality variants
  final ltr = const OnDirectionalityVariant(TextDirection.ltr);
  final rtl = const OnDirectionalityVariant(TextDirection.rtl);

  // Orientation variants
  final landscape = const OnOrientationVariant(Orientation.landscape);
  final portrait = const OnOrientationVariant(Orientation.portrait);

  // Widget state variants
  final press = const OnPressVariant();
  final hover = const OnHoverVariant();
  final focus = const OnFocusedVariant();
  final enabled = const OnNotVariant(OnDisabledVariant());
  final disabled = const OnDisabledVariant();
  @Deprecated(
    'The longPress variant has been removed. Please implement your own context variant for it',
  )
  final longPress = const OnLongPressVariant();
  final selected = const OnSelectedVariant();
  final unselected = const OnNotVariant(OnSelectedVariant());
  final dragged = const OnDraggedVariant();
  final error = const OnErrorVariant();

  /// Creates an [OnNotVariant] with the specified [variant].
  ///
  /// This reverses the result of the specified [variant].
  ///
  /// For example, if the specified [variant] evaluates to `true`,
  /// the [OnNotVariant] with that variant will evaluate to `false`, and vice versa.
  final not = OnNotVariant.new;

  static final self = OnContextVariantUtility._();
  OnContextVariantUtility._();

  Attribute builder(Style Function(BuildContext context) builder) =>
      StyleVariantBuilder(builder).build();
}
