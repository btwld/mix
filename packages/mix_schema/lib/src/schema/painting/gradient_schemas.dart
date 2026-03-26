import 'dart:math' as math;

import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/schema_wire_types.dart';
import '../discriminated_branch_registry.dart';
import '../shared/enum_schemas.dart';
import '../shared/primitive_schemas.dart';

const List<String> _tailwindGradientDirections = [
  'to-r',
  'to-l',
  'to-t',
  'to-b',
  'to-tr',
  'to-tl',
  'to-br',
  'to-bl',
];

final class TailwindCssAngleRectGradientTransform extends GradientTransform {
  final String directionKey;

  const TailwindCssAngleRectGradientTransform(this.directionKey);

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
      _ => (0, 0),
    };
  }

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final width = bounds.width;
    final height = bounds.height;
    if (width <= 0 || height <= 0) {
      return Matrix4.identity();
    }

    final (rawX, rawY) = _directionVector(directionKey, width, height);
    final magnitude = math.sqrt((rawX * rawX) + (rawY * rawY));
    if (magnitude == 0) {
      return Matrix4.identity();
    }

    final unitX = rawX / magnitude;
    final unitY = rawY / magnitude;
    final gradientLength = (width * unitX.abs()) + (height * unitY.abs());
    final scale = gradientLength / width;
    final angle = math.atan2(unitY, unitX);

    return Matrix4.identity()
      ..translateByDouble(bounds.center.dx, bounds.center.dy, 0, 1)
      ..rotateZ(angle)
      ..scaleByDouble(scale, scale, 1, 1)
      ..translateByDouble(-bounds.center.dx, -bounds.center.dy, 0, 1);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TailwindCssAngleRectGradientTransform &&
          other.directionKey == directionKey;

  @override
  int get hashCode => directionKey.hashCode;
}

List<Color> _gradientColors(Map<String, Object?> map) =>
    castList(map['colors']);

List<double>? _gradientStops(Map<String, Object?> map) =>
    castListOrNull(map['stops']);

bool _hasMatchingGradientStops(Map<String, Object?> map) {
  final stops = _gradientStops(map);

  return stops == null || stops.length == _gradientColors(map).length;
}

AckSchema<GradientTransform> buildGradientTransformSchema() {
  final registry = DiscriminatedBranchRegistry<GradientTransform>(
    discriminatorKey: 'type',
  );

  for (final type in SchemaGradientTransform.values) {
    registry.register(type.wireValue, _buildGradientTransformBranch(type));
  }

  return registry.freeze();
}

AckSchema<GradientMix> buildGradientSchema({
  required AckSchema<GradientTransform> gradientTransformSchema,
}) {
  final registry = DiscriminatedBranchRegistry<GradientMix>(
    discriminatorKey: 'type',
  );

  for (final type in SchemaGradient.values) {
    registry.register(
      type.wireValue,
      _buildGradientBranch(
        type: type,
        gradientTransformSchema: gradientTransformSchema,
      ),
    );
  }

  return registry.freeze();
}

AckSchema<GradientTransform> _buildGradientTransformBranch(
  SchemaGradientTransform type,
) {
  switch (type) {
    case .rotation:
      return Ack.object({'radians': Ack.double()}).transform<GradientTransform>(
        (data) {
          final map = data;

          return GradientRotation(map['radians'] as double);
        },
      );
    case .tailwindAngleRect:
      return Ack.object({
        'direction': Ack.enumString(_tailwindGradientDirections),
      }).transform<GradientTransform>((data) {
        final map = data;

        return TailwindCssAngleRectGradientTransform(
          map['direction'] as String,
        );
      });
  }
}

AckSchema<GradientMix> _buildGradientBranch({
  required SchemaGradient type,
  required AckSchema<GradientTransform> gradientTransformSchema,
}) {
  switch (type) {
    case .linear:
      return Ack.object({
            'colors': colorListSchema,
            'stops': doubleListSchema.optional(),
            'begin': alignmentSchema.optional(),
            'end': alignmentSchema.optional(),
            'tileMode': tileModeSchema.optional(),
            'transform': gradientTransformSchema.optional(),
          })
          .refine(
            _hasMatchingGradientStops,
            message: 'Gradient stops length must match colors length.',
          )
          .transform<GradientMix>((data) {
            final map = data;

            return LinearGradientMix(
              begin: map['begin'] as AlignmentGeometry?,
              end: map['end'] as AlignmentGeometry?,
              tileMode: map['tileMode'] as TileMode?,
              transform: map['transform'] as GradientTransform?,
              colors: _gradientColors(map),
              stops: _gradientStops(map),
            );
          });
    case .radial:
      return Ack.object({
            'colors': colorListSchema,
            'stops': doubleListSchema.optional(),
            'center': alignmentSchema.optional(),
            'radius': Ack.double().optional(),
            'tileMode': tileModeSchema.optional(),
            'focal': alignmentSchema.optional(),
            'focalRadius': Ack.double().optional(),
            'transform': gradientTransformSchema.optional(),
          })
          .refine(
            _hasMatchingGradientStops,
            message: 'Gradient stops length must match colors length.',
          )
          .transform<GradientMix>((data) {
            final map = data;

            return RadialGradientMix(
              center: map['center'] as AlignmentGeometry?,
              radius: map['radius'] as double?,
              tileMode: map['tileMode'] as TileMode?,
              focal: map['focal'] as AlignmentGeometry?,
              focalRadius: map['focalRadius'] as double?,
              transform: map['transform'] as GradientTransform?,
              colors: _gradientColors(map),
              stops: _gradientStops(map),
            );
          });
    case .sweep:
      return Ack.object({
            'colors': colorListSchema,
            'stops': doubleListSchema.optional(),
            'center': alignmentSchema.optional(),
            'startAngle': Ack.double().optional(),
            'endAngle': Ack.double().optional(),
            'tileMode': tileModeSchema.optional(),
            'transform': gradientTransformSchema.optional(),
          })
          .refine(
            _hasMatchingGradientStops,
            message: 'Gradient stops length must match colors length.',
          )
          .transform<GradientMix>((data) {
            final map = data;

            return SweepGradientMix(
              center: map['center'] as AlignmentGeometry?,
              startAngle: map['startAngle'] as double?,
              endAngle: map['endAngle'] as double?,
              tileMode: map['tileMode'] as TileMode?,
              transform: map['transform'] as GradientTransform?,
              colors: _gradientColors(map),
              stops: _gradientStops(map),
            );
          });
  }
}
