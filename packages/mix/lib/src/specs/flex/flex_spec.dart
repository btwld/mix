import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/resolved_style_provider.dart';
import '../../core/spec.dart';

/// Defines the styling for a Flex widget.
///
/// This class provides configuration for flex-specific properties such as
/// direction, alignment, and spacing through the Mix framework.
@immutable
final class FlexSpec extends Spec<FlexSpec> with Diagnosticable {
  /// The direction to use as the main axis.
  final Axis? direction;

  /// How the children should be placed along the main axis.
  final MainAxisAlignment? mainAxisAlignment;

  /// How the children should be placed along the cross axis.
  final CrossAxisAlignment? crossAxisAlignment;

  /// How much space should be occupied in the main axis.
  final MainAxisSize? mainAxisSize;

  /// Determines the order to lay children out vertically.
  final VerticalDirection? verticalDirection;

  /// Determines the order to lay children out horizontally.
  final TextDirection? textDirection;

  /// A baseline to use for aligning items.
  final TextBaseline? textBaseline;

  /// The content will be clipped (or not) according to this option.
  final Clip? clipBehavior;

  /// The gap between children.
  final double? gap;

  /// Creates a [FlexSpec] with the provided properties.
  const FlexSpec({
    this.direction,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
    this.verticalDirection,
    this.textDirection,
    this.textBaseline,
    this.clipBehavior,
    this.gap,
  });

  static FlexSpec? maybeOf(BuildContext context) {
    return ResolvedStyleProvider.of<FlexSpec>(context)?.spec;
  }

  /// {@template flex_spec_of}
  /// Retrieves the [FlexSpec] from the nearest [ResolvedStyleProvider] ancestor in the widget tree.
  ///
  /// This method provides the resolved FlexSpec from the style system.
  /// If no ancestor [ResolvedStyleProvider] is found, this method returns an empty [FlexSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final flexSpec = FlexSpec.of(context);
  /// ```
  /// {@endtemplate}
  static FlexSpec of(BuildContext context) {
    return maybeOf(context) ?? const FlexSpec();
  }

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(EnumProperty('direction', direction));
    properties.add(EnumProperty('mainAxisAlignment', mainAxisAlignment));
    properties.add(EnumProperty('crossAxisAlignment', crossAxisAlignment));
    properties.add(EnumProperty('mainAxisSize', mainAxisSize));
    properties.add(EnumProperty('verticalDirection', verticalDirection));
    properties.add(EnumProperty('textDirection', textDirection));
    properties.add(EnumProperty('textBaseline', textBaseline));
    properties.add(EnumProperty('clipBehavior', clipBehavior));
    properties.add(DoubleProperty('gap', gap));
  }

  /// Creates a copy of this [FlexSpec] with the given properties replaced.
  @override
  FlexSpec copyWith({
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    double? gap,
  }) {
    return FlexSpec(
      direction: direction ?? this.direction,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      verticalDirection: verticalDirection ?? this.verticalDirection,
      textDirection: textDirection ?? this.textDirection,
      textBaseline: textBaseline ?? this.textBaseline,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      gap: gap ?? this.gap,
    );
  }

  /// Linearly interpolates between this [FlexSpec] and another [FlexSpec].
  @override
  FlexSpec lerp(FlexSpec? other, double t) {
    if (other == null) return this;

    return FlexSpec(
      direction: t < 0.5 ? direction : other.direction,
      mainAxisAlignment: t < 0.5 ? mainAxisAlignment : other.mainAxisAlignment,
      crossAxisAlignment: t < 0.5
          ? crossAxisAlignment
          : other.crossAxisAlignment,
      mainAxisSize: t < 0.5 ? mainAxisSize : other.mainAxisSize,
      verticalDirection: t < 0.5 ? verticalDirection : other.verticalDirection,
      textDirection: t < 0.5 ? textDirection : other.textDirection,
      textBaseline: t < 0.5 ? textBaseline : other.textBaseline,
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
      gap: lerpDouble(gap, other.gap, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  List<Object?> get props => [
    direction,
    mainAxisAlignment,
    crossAxisAlignment,
    mainAxisSize,
    verticalDirection,
    textDirection,
    textBaseline,
    clipBehavior,
    gap,
  ];
}
