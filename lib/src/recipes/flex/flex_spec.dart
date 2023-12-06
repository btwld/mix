import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/attribute.dart';
import '../../factory/mix_provider_data.dart';
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
    required this.crossAxisAlignment,
    required this.mainAxisAlignment,
    required this.mainAxisSize,
    required this.verticalDirection,
    required this.direction,
    required this.textDirection,
    required this.textBaseline,
    required this.clipBehavior,
    required this.gap,
  });

  const FlexSpec.empty()
      : crossAxisAlignment = null,
        mainAxisAlignment = null,
        mainAxisSize = null,
        verticalDirection = null,
        direction = null,
        textDirection = null,
        textBaseline = null,
        clipBehavior = null,
        gap = null;

  static FlexSpec resolve(MixData mix) {
    final recipe = mix.attributeOf<FlexSpecAttribute>()?.resolve(mix);

    return recipe ?? const FlexSpecAttribute().resolve(mix);
  }

  @override
  FlexSpec lerp(FlexSpec other, double t) {
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
      ];
}
