import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/widget_modifier.dart';
import '../core/style.dart';

part 'intrinsic_modifier.g.dart';

/// Modifier that forces its child to be exactly as tall as its intrinsic height.
///
/// Wraps the child in an [IntrinsicHeight] widget.
@MixableModifier()
final class IntrinsicHeightModifier with _$IntrinsicHeightModifier {
  const IntrinsicHeightModifier();

  @override
  Widget build(Widget child) {
    return IntrinsicHeight(child: child);
  }
}

/// Modifier that forces its child to be exactly as wide as its intrinsic width.
///
/// Wraps the child in an [IntrinsicWidth] widget.
@MixableModifier()
final class IntrinsicWidthModifier with _$IntrinsicWidthModifier {
  const IntrinsicWidthModifier();

  @override
  Widget build(Widget child) {
    return IntrinsicWidth(child: child);
  }
}
