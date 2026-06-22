/// Gradient accumulation and post-decode Mix patching.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../tw_config.dart';

const gradientDirections = <String, (Alignment, Alignment)>{
  'to-t': (Alignment.bottomCenter, Alignment.topCenter),
  'to-tr': (Alignment.bottomLeft, Alignment.topRight),
  'to-r': (Alignment.centerLeft, Alignment.centerRight),
  'to-br': (Alignment.topLeft, Alignment.bottomRight),
  'to-b': (Alignment.topCenter, Alignment.bottomCenter),
  'to-bl': (Alignment.topRight, Alignment.bottomLeft),
  'to-l': (Alignment.centerRight, Alignment.centerLeft),
  'to-tl': (Alignment.bottomRight, Alignment.topLeft),
};

const _tailwindGradientAngles = <String, double>{
  'to-r': 0,
  'to-br': math.pi / 4,
  'to-b': math.pi / 2,
  'to-bl': 3 * math.pi / 4,
  'to-l': math.pi,
  'to-tl': -3 * math.pi / 4,
  'to-t': -math.pi / 2,
  'to-tr': -math.pi / 4,
};

const _tailwindCornerDirections = {'to-br', 'to-bl', 'to-tr', 'to-tl'};

final class GradientAccum {
  String? directionKey;
  (Alignment, Alignment)? direction;
  Color? fromColor;
  Color? viaColor;
  Color? toColor;

  bool get hasAnyPart =>
      direction != null ||
      directionKey != null ||
      fromColor != null ||
      viaColor != null ||
      toColor != null;

  bool get hasGradient => direction != null && fromColor != null;

  void inheritUnsetFrom(GradientAccum base) {
    directionKey ??= base.directionKey;
    direction ??= base.direction;
    fromColor ??= base.fromColor;
    viaColor ??= base.viaColor;
    toColor ??= base.toColor;
  }

  LinearGradientMix? toGradientMix(TwGradientStrategy strategy) {
    if (!hasGradient) return null;
    final colors = <Color>[fromColor!, ?viaColor, toColor ?? fromColor!];
    final stops = viaColor != null ? const [0.0, 0.5, 1.0] : const [0.0, 1.0];

    if (strategy == TwGradientStrategy.angle && directionKey != null) {
      final angle = _tailwindGradientAngles[directionKey!];
      if (angle != null) {
        return LinearGradientMix(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          transform: angle == 0 ? null : GradientRotation(angle),
          colors: colors,
          stops: stops,
        );
      }
    }

    final useCssAngleRect = strategy == TwGradientStrategy.cssAngleRect;
    if (useCssAngleRect &&
        directionKey != null &&
        _tailwindCornerDirections.contains(directionKey)) {
      return LinearGradientMix(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        transform: TwCssKeywordLinearTransform(directionKey!),
        colors: colors,
        stops: stops,
      );
    }

    final (begin, end) = direction!;
    return LinearGradientMix(
      begin: begin,
      end: end,
      colors: colors,
      stops: stops,
    );
  }
}

@immutable
class TwCssKeywordLinearTransform extends GradientTransform {
  const TwCssKeywordLinearTransform(this.directionKey);

  final String directionKey;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final w = bounds.width;
    final h = bounds.height;
    if (w <= 0 || h <= 0) return Matrix4.identity();

    final (rawX, rawY) = _directionVector(directionKey, w, h);
    final magnitude = math.sqrt((rawX * rawX) + (rawY * rawY));
    if (magnitude == 0) return Matrix4.identity();

    final ux = rawX / magnitude;
    final uy = rawY / magnitude;
    final gradientLength = (w * ux.abs()) + (h * uy.abs());
    final scale = gradientLength / w;
    final angle = math.atan2(uy, ux);

    return Matrix4.identity()
      ..translateByDouble(bounds.center.dx, bounds.center.dy, 0, 1)
      ..rotateZ(angle)
      ..scaleByDouble(scale, scale, 1, 1)
      ..translateByDouble(-bounds.center.dx, -bounds.center.dy, 0, 1);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwCssKeywordLinearTransform &&
          directionKey == other.directionKey;

  @override
  int get hashCode => directionKey.hashCode;

  static (double, double) _directionVector(
    String directionKey,
    double width,
    double height,
  ) {
    return switch (directionKey) {
      'to-r' => (1, 0),
      'to-l' => (-1, 0),
      'to-b' => (0, 1),
      'to-t' => (0, -1),
      'to-br' => (height, width),
      'to-tr' => (height, -width),
      'to-bl' => (-height, width),
      'to-tl' => (-height, -width),
      _ => (0, 1),
    };
  }
}
