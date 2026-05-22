import 'dart:math' as math;

import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/branch_codec.dart';
import '../../core/numeric_codecs.dart';
import '../../core/prop_encode.dart';
import '../../core/schema_wire_types.dart';
import '../shared/shared_schemas.dart';

const List<String> _cssLinearGradientDirections = [
  'to_right',
  'to_left',
  'to_top',
  'to_bottom',
  'to_top_right',
  'to_top_left',
  'to_bottom_right',
  'to_bottom_left',
];

final class CssLinearKeywordGradientTransform extends GradientTransform {
  final String directionKey;

  const CssLinearKeywordGradientTransform(this.directionKey);

  static (double, double) _directionVector(
    String directionKey,
    double width,
    double height,
  ) {
    return switch (directionKey) {
      'to_right' => (1, 0),
      'to_left' => (-1, 0),
      'to_bottom' => (0, 1),
      'to_top' => (0, -1),
      'to_bottom_right' => (height, width),
      'to_top_right' => (height, -width),
      'to_bottom_left' => (-height, width),
      'to_top_left' => (-height, -width),
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
      other is CssLinearKeywordGradientTransform &&
          other.directionKey == directionKey;

  @override
  int get hashCode => directionKey.hashCode;
}

List<Color> _gradientColors(JsonMap map) => (map['colors']! as List).cast();

List<double>? _gradientStops(JsonMap map) =>
    (map['stops'] as List?)?.cast<double>();

bool _hasMatchingGradientStops(JsonMap map) {
  final stops = _gradientStops(map);

  return stops == null || stops.length == _gradientColors(map).length;
}

final gradientTransformCodec = Ack.discriminated<GradientTransform>(
  discriminatorKey: 'type',
  schemas: {
    for (final type in SchemaGradientTransform.values)
      type.wireValue: _buildGradientTransformBranch(type),
  },
);

final gradientCodec = Ack.discriminated<GradientMix>(
  discriminatorKey: 'type',
  schemas: {
    for (final type in SchemaGradient.values)
      type.wireValue: _buildGradientBranch(
        type: type,
        gradientTransformCodec: gradientTransformCodec,
      ),
  },
);

AckSchema<JsonMap, GradientTransform> _buildGradientTransformBranch(
  SchemaGradientTransform type,
) {
  switch (type) {
    case .rotation:
      return discriminatedBranchCodec<GradientTransform, GradientRotation>(
        type: type.wireValue,
        input: Ack.object({'radians': doubleFromNum()}),
        decode: (data) => GradientRotation(data['radians']! as double),
        encode: (value) => {'radians': value.radians},
      );
    case .cssLinearKeyword:
      return discriminatedBranchCodec<
        GradientTransform,
        CssLinearKeywordGradientTransform
      >(
        type: type.wireValue,
        input: Ack.object({
          'direction': Ack.enumString(_cssLinearGradientDirections),
        }),
        decode: (data) =>
            CssLinearKeywordGradientTransform(data['direction']! as String),
        encode: (value) => {'direction': value.directionKey},
      );
  }
}

AckSchema<JsonMap, GradientMix> _buildGradientBranch({
  required SchemaGradient type,
  required AckSchema<JsonMap, GradientTransform> gradientTransformCodec,
}) {
  switch (type) {
    case .linear:
      return discriminatedBranchCodec<GradientMix, LinearGradientMix>(
        type: type.wireValue,
        input:
            Ack.object({
              'colors': colorListSchema,
              'stops': doubleListSchema.optional(),
              'begin': alignmentCodec.optional(),
              'end': alignmentCodec.optional(),
              'tileMode': tileModeSchema.optional(),
              'transform': gradientTransformCodec.optional(),
            }).refine(
              _hasMatchingGradientStops,
              message: 'Gradient stops length must match colors length.',
            ),
        decode: (data) => LinearGradientMix(
          begin: data['begin'] as AlignmentGeometry?,
          end: data['end'] as AlignmentGeometry?,
          tileMode: data['tileMode'] as TileMode?,
          transform: data['transform'] as GradientTransform?,
          colors: _gradientColors(data),
          stops: _gradientStops(data),
        ),
        encode: (mix) => optionalJsonMap([
          ('colors', requiredPropValue(mix.$colors, 'colors')),
          ('stops', propValue(mix.$stops)),
          ('begin', propValue(mix.$begin)),
          ('end', propValue(mix.$end)),
          ('tileMode', propValue(mix.$tileMode)),
          ('transform', propValue(mix.$transform)),
        ]),
      );
    case .radial:
      return discriminatedBranchCodec<GradientMix, RadialGradientMix>(
        type: type.wireValue,
        input:
            Ack.object({
              'colors': colorListSchema,
              'stops': doubleListSchema.optional(),
              'center': alignmentCodec.optional(),
              'radius': doubleFromNum().optional(),
              'tileMode': tileModeSchema.optional(),
              'focal': alignmentCodec.optional(),
              'focalRadius': doubleFromNum().optional(),
              'transform': gradientTransformCodec.optional(),
            }).refine(
              _hasMatchingGradientStops,
              message: 'Gradient stops length must match colors length.',
            ),
        decode: (data) => RadialGradientMix(
          center: data['center'] as AlignmentGeometry?,
          radius: data['radius'] as double?,
          tileMode: data['tileMode'] as TileMode?,
          focal: data['focal'] as AlignmentGeometry?,
          focalRadius: data['focalRadius'] as double?,
          transform: data['transform'] as GradientTransform?,
          colors: _gradientColors(data),
          stops: _gradientStops(data),
        ),
        encode: (mix) => optionalJsonMap([
          ('colors', requiredPropValue(mix.$colors, 'colors')),
          ('stops', propValue(mix.$stops)),
          ('center', propValue(mix.$center)),
          ('radius', propValue(mix.$radius)),
          ('tileMode', propValue(mix.$tileMode)),
          ('focal', propValue(mix.$focal)),
          ('focalRadius', propValue(mix.$focalRadius)),
          ('transform', propValue(mix.$transform)),
        ]),
      );
    case .sweep:
      return discriminatedBranchCodec<GradientMix, SweepGradientMix>(
        type: type.wireValue,
        input:
            Ack.object({
              'colors': colorListSchema,
              'stops': doubleListSchema.optional(),
              'center': alignmentCodec.optional(),
              'startAngle': doubleFromNum().optional(),
              'endAngle': doubleFromNum().optional(),
              'tileMode': tileModeSchema.optional(),
              'transform': gradientTransformCodec.optional(),
            }).refine(
              _hasMatchingGradientStops,
              message: 'Gradient stops length must match colors length.',
            ),
        decode: (data) => SweepGradientMix(
          center: data['center'] as AlignmentGeometry?,
          startAngle: data['startAngle'] as double?,
          endAngle: data['endAngle'] as double?,
          tileMode: data['tileMode'] as TileMode?,
          transform: data['transform'] as GradientTransform?,
          colors: _gradientColors(data),
          stops: _gradientStops(data),
        ),
        encode: (mix) => optionalJsonMap([
          ('colors', requiredPropValue(mix.$colors, 'colors')),
          ('stops', propValue(mix.$stops)),
          ('center', propValue(mix.$center)),
          ('startAngle', propValue(mix.$startAngle)),
          ('endAngle', propValue(mix.$endAngle)),
          ('tileMode', propValue(mix.$tileMode)),
          ('transform', propValue(mix.$transform)),
        ]),
      );
  }
}
