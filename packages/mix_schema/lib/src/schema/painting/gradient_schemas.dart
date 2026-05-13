import 'dart:math' as math;

import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/prop_encode.dart';
import '../../core/schema_wire_types.dart';
import '../discriminated_schema_builder.dart';
import '../shared/shared_schemas.dart';

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

List<double>? _gradientStops(Map<String, Object?> map) {
  final stops = map['stops'] as List<Object?>?;

  return stops == null ? null : [for (final s in stops) castDouble(s)];
}

bool _hasMatchingGradientStops(Map<String, Object?> map) {
  final stops = _gradientStops(map);

  return stops == null || stops.length == _gradientColors(map).length;
}

AckSchema<GradientTransform> buildGradientTransformSchema() {
  return buildDiscriminatedSchema<GradientTransform>(
    discriminatorKey: 'type',
    branches: [
      for (final type in SchemaGradientTransform.values)
        discriminatedBranch<GradientTransform, GradientTransform>(
          type: type.wireValue,
          schema: _buildGradientTransformBranch(type),
        ),
    ],
  );
}

AckSchema<GradientMix> buildGradientSchema({
  required AckSchema<GradientTransform> gradientTransformSchema,
}) {
  return buildDiscriminatedSchema<GradientMix>(
    discriminatorKey: 'type',
    branches: [
      for (final type in SchemaGradient.values)
        discriminatedBranch<GradientMix, GradientMix>(
          type: type.wireValue,
          schema: _buildGradientBranch(
            type: type,
            gradientTransformSchema: gradientTransformSchema,
          ),
        ),
    ],
  );
}

AckSchema<GradientTransform> _buildGradientTransformBranch(
  SchemaGradientTransform type,
) {
  switch (type) {
    case .rotation:
      return Ack.codec<Map<String, Object?>, GradientTransform>(
        input: Ack.object({'radians': Ack.number()}),
        output: Ack.instance<GradientTransform>(),
        decoder: (data) => GradientRotation(castDouble(data['radians'])),
        encoder: (value) {
          final rotation = value as GradientRotation;

          return {'radians': rotation.radians};
        },
      );
    case .tailwindAngleRect:
      return Ack.codec<Map<String, Object?>, GradientTransform>(
        input: Ack.object({
          'direction': Ack.enumString(_tailwindGradientDirections),
        }),
        output: Ack.instance<GradientTransform>(),
        decoder: (data) =>
            TailwindCssAngleRectGradientTransform(data['direction'] as String),
        encoder: (value) {
          final transform = value as TailwindCssAngleRectGradientTransform;

          return {'direction': transform.directionKey};
        },
      );
  }
}

AckSchema<GradientMix> _buildGradientBranch({
  required SchemaGradient type,
  required AckSchema<GradientTransform> gradientTransformSchema,
}) {
  switch (type) {
    case .linear:
      return Ack.codec<Map<String, Object?>, GradientMix>(
        input:
            Ack.object({
              'colors': colorListSchema,
              'stops': numListSchema.optional(),
              'begin': alignmentCodec.optional(),
              'end': alignmentCodec.optional(),
              'tileMode': tileModeSchema.optional(),
              'transform': gradientTransformSchema.optional(),
            }).refine(
              _hasMatchingGradientStops,
              message: 'Gradient stops length must match colors length.',
            ),
        output: Ack.instance<GradientMix>(),
        decoder: (data) {
          return LinearGradientMix(
            begin: data['begin'] as AlignmentGeometry?,
            end: data['end'] as AlignmentGeometry?,
            tileMode: data['tileMode'] as TileMode?,
            transform: data['transform'] as GradientTransform?,
            colors: _gradientColors(data),
            stops: _gradientStops(data),
          );
        },
        encoder: (value) {
          final mix = value as LinearGradientMix;

          return optionalJsonMap([
            ('colors', requiredPropValue(mix.$colors, 'colors')),
            ('stops', propValue(mix.$stops)),
            ('begin', propValue(mix.$begin)),
            ('end', propValue(mix.$end)),
            ('tileMode', propValue(mix.$tileMode)),
            ('transform', propValue(mix.$transform)),
          ]);
        },
      );
    case .radial:
      return Ack.codec<Map<String, Object?>, GradientMix>(
        input:
            Ack.object({
              'colors': colorListSchema,
              'stops': numListSchema.optional(),
              'center': alignmentCodec.optional(),
              'radius': Ack.number().optional(),
              'tileMode': tileModeSchema.optional(),
              'focal': alignmentCodec.optional(),
              'focalRadius': Ack.number().optional(),
              'transform': gradientTransformSchema.optional(),
            }).refine(
              _hasMatchingGradientStops,
              message: 'Gradient stops length must match colors length.',
            ),
        output: Ack.instance<GradientMix>(),
        decoder: (data) {
          return RadialGradientMix(
            center: data['center'] as AlignmentGeometry?,
            radius: castDoubleOrNull(data['radius']),
            tileMode: data['tileMode'] as TileMode?,
            focal: data['focal'] as AlignmentGeometry?,
            focalRadius: castDoubleOrNull(data['focalRadius']),
            transform: data['transform'] as GradientTransform?,
            colors: _gradientColors(data),
            stops: _gradientStops(data),
          );
        },
        encoder: (value) {
          final mix = value as RadialGradientMix;

          return optionalJsonMap([
            ('colors', requiredPropValue(mix.$colors, 'colors')),
            ('stops', propValue(mix.$stops)),
            ('center', propValue(mix.$center)),
            ('radius', propValue(mix.$radius)),
            ('tileMode', propValue(mix.$tileMode)),
            ('focal', propValue(mix.$focal)),
            ('focalRadius', propValue(mix.$focalRadius)),
            ('transform', propValue(mix.$transform)),
          ]);
        },
      );
    case .sweep:
      return Ack.codec<Map<String, Object?>, GradientMix>(
        input:
            Ack.object({
              'colors': colorListSchema,
              'stops': numListSchema.optional(),
              'center': alignmentCodec.optional(),
              'startAngle': Ack.number().optional(),
              'endAngle': Ack.number().optional(),
              'tileMode': tileModeSchema.optional(),
              'transform': gradientTransformSchema.optional(),
            }).refine(
              _hasMatchingGradientStops,
              message: 'Gradient stops length must match colors length.',
            ),
        output: Ack.instance<GradientMix>(),
        decoder: (data) {
          return SweepGradientMix(
            center: data['center'] as AlignmentGeometry?,
            startAngle: castDoubleOrNull(data['startAngle']),
            endAngle: castDoubleOrNull(data['endAngle']),
            tileMode: data['tileMode'] as TileMode?,
            transform: data['transform'] as GradientTransform?,
            colors: _gradientColors(data),
            stops: _gradientStops(data),
          );
        },
        encoder: (value) {
          final mix = value as SweepGradientMix;

          return optionalJsonMap([
            ('colors', requiredPropValue(mix.$colors, 'colors')),
            ('stops', propValue(mix.$stops)),
            ('center', propValue(mix.$center)),
            ('startAngle', propValue(mix.$startAngle)),
            ('endAngle', propValue(mix.$endAngle)),
            ('tileMode', propValue(mix.$tileMode)),
            ('transform', propValue(mix.$transform)),
          ]);
        },
      );
  }
}
