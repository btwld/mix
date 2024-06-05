import 'dart:ui';

import 'package:flutter/material.dart';

import '../../attributes/animated/animated_data.dart';
import '../../core/attribute.dart';
import '../../factory/mix_provider.dart';
import '../../factory/mix_provider_data.dart';
import '../../helpers/lerp_helpers.dart';
import 'flex_attribute.dart';

class FlexSpec extends Spec<FlexSpec> {
  final Axis? direction;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final VerticalDirection? verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final Clip? clipBehavior;
  final double? gap;

  const FlexSpec({
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.verticalDirection,
    this.direction,
    this.textDirection,
    this.textBaseline,
    this.clipBehavior,
    this.gap,
    super.animated,
  });

  const FlexSpec.exhaustive({
    required this.crossAxisAlignment,
    required this.mainAxisAlignment,
    required this.mainAxisSize,
    required this.verticalDirection,
    required this.direction,
    required this.textDirection,
    required this.textBaseline,
    required this.clipBehavior,
    required this.gap,
    required super.animated,
  });

  static FlexSpec of(BuildContext context) {
    final mix = Mix.of(context);

    return FlexSpec.from(mix);
  }

  static FlexSpec from(MixData mix) {
    return mix.attributeOf<FlexSpecAttribute>()?.resolve(mix) ??
        const FlexSpec();
  }

  @override
  FlexSpec lerp(FlexSpec? other, double t) {
    if (other == null) return this;

    return FlexSpec(
      crossAxisAlignment:
          lerpSnap(crossAxisAlignment, other.crossAxisAlignment, t),
      mainAxisAlignment:
          lerpSnap(mainAxisAlignment, other.mainAxisAlignment, t),
      mainAxisSize: lerpSnap(mainAxisSize, other.mainAxisSize, t),
      verticalDirection:
          lerpSnap(verticalDirection, other.verticalDirection, t),
      direction: lerpSnap(direction, other.direction, t),
      textDirection: lerpSnap(textDirection, other.textDirection, t),
      textBaseline: lerpSnap(textBaseline, other.textBaseline, t),
      clipBehavior: lerpSnap(clipBehavior, other.clipBehavior, t),
      gap: lerpDouble(gap, other.gap, t),
      animated: other.animated ?? animated,
    );
  }

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
    AnimatedData? animated,
  }) {
    return FlexSpec(
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      verticalDirection: verticalDirection ?? this.verticalDirection,
      direction: direction ?? this.direction,
      textDirection: textDirection ?? this.textDirection,
      textBaseline: textBaseline ?? this.textBaseline,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      gap: gap ?? this.gap,
      animated: animated ?? this.animated,
    );
  }

  @override
  List<Object?> get props => [
        crossAxisAlignment,
        mainAxisAlignment,
        mainAxisSize,
        verticalDirection,
        direction,
        textDirection,
        textBaseline,
        clipBehavior,
        gap,
        animated,
      ];
}
