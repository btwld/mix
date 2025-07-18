import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/gap/space_dto.dart';
import '../../core/attribute.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';

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

  /// Retrieves the [FlexSpec] from the nearest [MixContext] in the widget tree.
  static FlexSpec from(BuildContext _) {
    // This is a placeholder implementation
    // In actual usage, this would retrieve from a provider
    return const FlexSpec();
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
      crossAxisAlignment: t < 0.5 ? crossAxisAlignment : other.crossAxisAlignment,
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

/// Attribute for [FlexSpec] properties.
@immutable
final class FlexSpecAttribute extends SpecAttribute<FlexSpec> with Diagnosticable {
  final Axis? direction;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final VerticalDirection? verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final Clip? clipBehavior;
  final SpaceDto? gap;

  /// Creates a [FlexSpecAttribute] with the provided properties.
  const FlexSpecAttribute({
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

  /// Creates a [FlexSpecAttribute] from a [FlexSpec] value.
  factory FlexSpecAttribute.value(FlexSpec spec) {
    return FlexSpecAttribute(
      direction: spec.direction,
      mainAxisAlignment: spec.mainAxisAlignment,
      crossAxisAlignment: spec.crossAxisAlignment,
      mainAxisSize: spec.mainAxisSize,
      verticalDirection: spec.verticalDirection,
      textDirection: spec.textDirection,
      textBaseline: spec.textBaseline,
      clipBehavior: spec.clipBehavior,
      gap: spec.gap != null ? SpaceDto.value(spec.gap!) : null,
    );
  }

  /// Creates a nullable [FlexSpecAttribute] from a nullable [FlexSpec] value.
  static FlexSpecAttribute? maybeValue(FlexSpec? spec) {
    return spec != null ? FlexSpecAttribute.value(spec) : null;
  }

  @override
  FlexSpecAttribute merge(FlexSpecAttribute? other) {
    if (other == null) return this;

    return FlexSpecAttribute(
      direction: other.direction ?? direction,
      mainAxisAlignment: other.mainAxisAlignment ?? mainAxisAlignment,
      crossAxisAlignment: other.crossAxisAlignment ?? crossAxisAlignment,
      mainAxisSize: other.mainAxisSize ?? mainAxisSize,
      verticalDirection: other.verticalDirection ?? verticalDirection,
      textDirection: other.textDirection ?? textDirection,
      textBaseline: other.textBaseline ?? textBaseline,
      clipBehavior: other.clipBehavior ?? clipBehavior,
      gap: other.gap ?? gap,
    );
  }

  @override
  FlexSpec resolve(BuildContext context) {
    return FlexSpec(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      gap: gap?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('direction', direction));
    properties.add(EnumProperty('mainAxisAlignment', mainAxisAlignment));
    properties.add(EnumProperty('crossAxisAlignment', crossAxisAlignment));
    properties.add(EnumProperty('mainAxisSize', mainAxisSize));
    properties.add(EnumProperty('verticalDirection', verticalDirection));
    properties.add(EnumProperty('textDirection', textDirection));
    properties.add(EnumProperty('textBaseline', textBaseline));
    properties.add(EnumProperty('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty('gap', gap));
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

/// Utility class for building [FlexSpecAttribute] instances.
final class FlexSpecUtility<T extends Attribute> extends SpecUtility<T, FlexSpecAttribute> {
  /// Creates a [FlexSpecUtility] with the provided builder.
  FlexSpecUtility(super.builder);

  /// Creates a static instance of [FlexSpecUtility].
  static FlexSpecUtility<FlexSpecAttribute> get self =>
      FlexSpecUtility((v) => v);

  /// Returns a new [FlexSpecAttribute] with the specified properties.
  @override
  T only({
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    SpaceDto? gap,
  }) {
    return builder(FlexSpecAttribute(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      gap: gap,
    ));
  }

  /// Sets the direction of the flex layout.
  T direction(Axis direction) => only(direction: direction);

  /// Sets the main axis alignment.
  T mainAxisAlignment(MainAxisAlignment alignment) =>
      only(mainAxisAlignment: alignment);

  /// Sets the cross axis alignment.
  T crossAxisAlignment(CrossAxisAlignment alignment) =>
      only(crossAxisAlignment: alignment);

  /// Sets the main axis size.
  T mainAxisSize(MainAxisSize size) => only(mainAxisSize: size);

  /// Sets the vertical direction.
  T verticalDirection(VerticalDirection direction) =>
      only(verticalDirection: direction);

  /// Sets the text direction.
  T textDirection(TextDirection direction) =>
      only(textDirection: direction);

  /// Sets the text baseline.
  T textBaseline(TextBaseline baseline) => only(textBaseline: baseline);

  /// Sets the clip behavior.
  T clipBehavior(Clip behavior) => only(clipBehavior: behavior);

  /// Sets the gap between children.
  T gap(double gap) => only(gap: SpaceDto.value(gap));
}