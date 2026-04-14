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
final class IntrinsicHeightModifier
    extends WidgetModifier<IntrinsicHeightModifier>
    with Diagnosticable {
  const IntrinsicHeightModifier();

  @override
  IntrinsicHeightModifier copyWith() {
    return const IntrinsicHeightModifier();
  }

  @override
  IntrinsicHeightModifier lerp(IntrinsicHeightModifier? other, double t) {
    if (other == null) return this;

    return const IntrinsicHeightModifier();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }

  @override
  List<Object?> get props => [];

  @override
  Widget build(Widget child) {
    return IntrinsicHeight(child: child);
  }
}

/// Modifier that forces its child to be exactly as wide as its intrinsic width.
///
/// Wraps the child in an [IntrinsicWidth] widget.
@MixableModifier()
final class IntrinsicWidthModifier
    extends WidgetModifier<IntrinsicWidthModifier>
    with Diagnosticable {
  const IntrinsicWidthModifier();

  @override
  IntrinsicWidthModifier copyWith() {
    return const IntrinsicWidthModifier();
  }

  @override
  IntrinsicWidthModifier lerp(IntrinsicWidthModifier? other, double t) {
    if (other == null) return this;

    return const IntrinsicWidthModifier();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }

  @override
  List<Object?> get props => [];

  @override
  Widget build(Widget child) {
    return IntrinsicWidth(child: child);
  }
}

