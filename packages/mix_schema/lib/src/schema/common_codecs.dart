import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
import 'primitive_wire.dart';

CodecSchema<num, double> numberAsDoubleCodec() {
  return Ack.number().codec<double>(
    decode: (value) => value.toDouble(),
    encode: (value) => value,
  );
}

CodecSchema<num, double> nonNegativeDoubleCodec() {
  return Ack.number()
      .min(0)
      .codec<double>(
        decode: (value) => value.toDouble(),
        encode: (value) => value,
      );
}

CodecSchema<String, Color> colorCodec() {
  return Ack.codec<String, String, Color>(
    input: _colorWireCodec(),
    decode: _decodeColor,
    encode: encodeColorWire,
  );
}

CodecSchema<Object, Alignment> alignmentCodec() {
  return Ack.codec<Object, Object, Alignment>(
    input: Ack.anyOf([
      Ack.enumString(namedAlignments.keys.toList(growable: false)),
      Ack.object({'x': numberAsDoubleCodec(), 'y': numberAsDoubleCodec()}),
    ]),
    decode: _decodeAlignment,
    encode: encodeAlignmentWire,
  );
}

CodecSchema<JsonMap, Offset> offsetCodec() {
  return Ack.object({
    'x': numberAsDoubleCodec(),
    'y': numberAsDoubleCodec(),
  }).codec<Offset>(
    decode: (data) => Offset(data['x']! as double, data['y']! as double),
    encode: (value) => {'x': value.dx, 'y': value.dy},
  );
}

CodecSchema<List<num>, Matrix4> matrix4Codec() {
  return Ack.list(numberAsDoubleCodec())
      .refine(
        (value) => value.length == 16,
        message: 'Matrix4 payloads must contain exactly 16 numbers.',
      )
      .codec<Matrix4>(
        decode: (value) => Matrix4.fromList(value),
        encode: (value) => value.storage.toList(growable: false),
      );
}

CodecSchema<Object, Radius> radiusCodec() {
  return Ack.codec<Object, Object, Radius>(
    input: Ack.anyOf([
      nonNegativeDoubleCodec(),
      Ack.object({
        'x': nonNegativeDoubleCodec(),
        'y': nonNegativeDoubleCodec(),
      }),
    ]),
    decode: _decodeRadius,
    encode: _encodeRadius,
  );
}

CodecSchema<JsonMap, BorderSideMix> borderSideCodec() {
  return Ack.object({
    'color': colorCodec().optional(),
    'width': numberAsDoubleCodec().optional(),
    'style': enumCodec({
      'none': BorderStyle.none,
      'solid': BorderStyle.solid,
    }, debugName: 'BorderStyle').optional(),
    'strokeAlign': numberAsDoubleCodec().optional(),
  }).codec<BorderSideMix>(
    decode: (data) => BorderSideMix(
      color: data['color'] as Color?,
      width: data['width'] as double?,
      style: data['style'] as BorderStyle?,
      strokeAlign: data['strokeAlign'] as double?,
    ),
    encode: (value) => {
      'color': singleValueProp(value.$color, 'borderSide.color'),
      'width': singleValueProp(value.$width, 'borderSide.width'),
      'style': singleValueProp(value.$style, 'borderSide.style'),
      'strokeAlign': singleValueProp(
        value.$strokeAlign,
        'borderSide.strokeAlign',
      ),
    },
  );
}

CodecSchema<JsonMap, BorderMix> borderCodec() {
  return Ack.object({
    'top': borderSideCodec().optional(),
    'right': borderSideCodec().optional(),
    'bottom': borderSideCodec().optional(),
    'left': borderSideCodec().optional(),
  }).codec<BorderMix>(
    decode: (data) => BorderMix(
      top: data['top'] as BorderSideMix?,
      right: data['right'] as BorderSideMix?,
      bottom: data['bottom'] as BorderSideMix?,
      left: data['left'] as BorderSideMix?,
    ),
    encode: (value) => {
      'top': singleMixProp<BorderSideMix, BorderSide>(value.$top, 'border.top'),
      'right': singleMixProp<BorderSideMix, BorderSide>(
        value.$right,
        'border.right',
      ),
      'bottom': singleMixProp<BorderSideMix, BorderSide>(
        value.$bottom,
        'border.bottom',
      ),
      'left': singleMixProp<BorderSideMix, BorderSide>(
        value.$left,
        'border.left',
      ),
    },
  );
}

CodecSchema<Object, EdgeInsetsMix> edgeInsetsCodec() {
  return Ack.codec<Object, Object, EdgeInsetsMix>(
    input: Ack.anyOf([
      numberAsDoubleCodec(),
      Ack.object({
        'left': numberAsDoubleCodec().optional(),
        'top': numberAsDoubleCodec().optional(),
        'right': numberAsDoubleCodec().optional(),
        'bottom': numberAsDoubleCodec().optional(),
      }),
    ]),
    decode: _decodeEdgeInsetsMix,
    encode: _encodeEdgeInsetsMix,
  );
}

CodecSchema<JsonMap, BoxShadowMix> boxShadowCodec() {
  return Ack.object({
    'color': colorCodec().optional(),
    'offset': offsetCodec().optional(),
    'blurRadius': numberAsDoubleCodec().optional(),
    'spreadRadius': numberAsDoubleCodec().optional(),
  }).codec<BoxShadowMix>(
    decode: (data) => BoxShadowMix(
      color: data['color'] as Color?,
      offset: data['offset'] as Offset?,
      blurRadius: data['blurRadius'] as double?,
      spreadRadius: data['spreadRadius'] as double?,
    ),
    encode: (value) => {
      'color': singleValueProp(value.$color, 'boxShadow.color'),
      'offset': singleValueProp(value.$offset, 'boxShadow.offset'),
      'blurRadius': singleValueProp(value.$blurRadius, 'boxShadow.blurRadius'),
      'spreadRadius': singleValueProp(
        value.$spreadRadius,
        'boxShadow.spreadRadius',
      ),
    },
  );
}

CodecSchema<JsonMap, ShadowMix> shadowCodec() {
  return Ack.object({
    'color': colorCodec().optional(),
    'offset': offsetCodec().optional(),
    'blurRadius': numberAsDoubleCodec().optional(),
  }).codec<ShadowMix>(
    decode: (data) => ShadowMix(
      color: data['color'] as Color?,
      offset: data['offset'] as Offset?,
      blurRadius: data['blurRadius'] as double?,
    ),
    encode: (value) => {
      'color': singleValueProp(value.$color, 'shadow.color'),
      'offset': singleValueProp(value.$offset, 'shadow.offset'),
      'blurRadius': singleValueProp(value.$blurRadius, 'shadow.blurRadius'),
    },
  );
}

CodecSchema<JsonMap, TextHeightBehaviorMix> textHeightBehaviorCodec() {
  return Ack.object({
    'applyHeightToFirstAscent': Ack.boolean().optional(),
    'applyHeightToLastDescent': Ack.boolean().optional(),
    'leadingDistribution': enumNameCodec(
      TextLeadingDistribution.values,
    ).optional(),
  }).codec<TextHeightBehaviorMix>(
    decode: (data) => TextHeightBehaviorMix(
      applyHeightToFirstAscent: data['applyHeightToFirstAscent'] as bool?,
      applyHeightToLastDescent: data['applyHeightToLastDescent'] as bool?,
      leadingDistribution:
          data['leadingDistribution'] as TextLeadingDistribution?,
    ),
    encode: (value) => {
      'applyHeightToFirstAscent': singleValueProp(
        value.$applyHeightToFirstAscent,
        'textHeightBehavior.applyHeightToFirstAscent',
      ),
      'applyHeightToLastDescent': singleValueProp(
        value.$applyHeightToLastDescent,
        'textHeightBehavior.applyHeightToLastDescent',
      ),
      'leadingDistribution': singleValueProp(
        value.$leadingDistribution,
        'textHeightBehavior.leadingDistribution',
      ),
    },
  );
}

CodecSchema<String, Directive<String>> textDirectiveCodec() {
  return enumCodec({
    'uppercase': const UppercaseStringDirective(),
    'lowercase': const LowercaseStringDirective(),
    'capitalize': const CapitalizeStringDirective(),
    'title_case': const TitleCaseStringDirective(),
    'sentence_case': const SentenceCaseStringDirective(),
  }, debugName: 'TextDirective');
}

CodecSchema<JsonMap, BoxConstraintsMix> boxConstraintsCodec() {
  return Ack.object({
        'minWidth': nonNegativeDoubleCodec().optional(),
        'maxWidth': nonNegativeDoubleCodec().nullable().optional(),
        'minHeight': nonNegativeDoubleCodec().optional(),
        'maxHeight': nonNegativeDoubleCodec().nullable().optional(),
      })
      .constrain(const _BoxConstraintsBoundsConstraint())
      .codec<BoxConstraintsMix>(
        decode: (data) => BoxConstraintsMix(
          minWidth: _readOptionalMinConstraintBound(data, 'minWidth'),
          maxWidth: _readOptionalMaxConstraintBound(data, 'maxWidth'),
          minHeight: _readOptionalMinConstraintBound(data, 'minHeight'),
          maxHeight: _readOptionalMaxConstraintBound(data, 'maxHeight'),
        ),
        encode: _encodeBoxConstraintsMix,
      );
}

CodecSchema<Object, BorderRadiusMix> borderRadiusCodec() {
  return Ack.codec<Object, Object, BorderRadiusMix>(
    input: Ack.anyOf([
      radiusCodec(),
      Ack.object({
        'topLeft': radiusCodec().optional(),
        'topRight': radiusCodec().optional(),
        'bottomLeft': radiusCodec().optional(),
        'bottomRight': radiusCodec().optional(),
      }),
    ]),
    decode: _decodeBorderRadiusMix,
    encode: _encodeBorderRadiusMix,
  );
}

CodecSchema<String, T> enumCodec<T extends Object>(
  Map<String, T> values, {
  String? debugName,
}) {
  return Ack.enumString(values.keys.toList(growable: false)).codec<T>(
    decode: (wire) => values[wire]!,
    encode: (value) {
      for (final entry in values.entries) {
        if (entry.value == value) return entry.key;
      }

      throw UnsupportedEncodeValueError(
        value,
        'No ${debugName ?? 'enum'} wire value is registered for $value.',
      );
    },
  );
}

CodecSchema<String, T> enumNameCodec<T extends Enum>(List<T> values) {
  return enumCodec({for (final value in values) value.name: value});
}

void failIfPresent(Object? value, String fieldName) {
  if (value == null) return;

  throw UnsupportedEncodeValueError(
    value,
    'Field "$fieldName" is not representable by this schema.',
  );
}

Alignment? singleAlignmentProp(
  Prop<AlignmentGeometry>? prop,
  String fieldName,
) {
  return readProp<Alignment, AlignmentGeometry>(prop, fieldName);
}

T? singleValueProp<T extends Object>(Prop<T>? prop, String fieldName) {
  return readProp<T, T>(prop, fieldName);
}

T? singleMixProp<T extends Object, V extends Object>(
  Prop<V>? prop,
  String fieldName,
) {
  return readProp<T, V>(prop, fieldName);
}

T? readProp<T extends Object, V extends Object>(
  Prop<V>? prop,
  String fieldName,
) {
  if (prop == null) return null;
  if (prop.$directives?.isNotEmpty == true) {
    throw UnsupportedEncodeValueError(
      prop,
      'Field "$fieldName" has directives and cannot be represented.',
    );
  }
  if (prop.sources.length != 1) {
    throw UnsupportedEncodeValueError(
      prop,
      'Field "$fieldName" has ${prop.sources.length} sources; expected one.',
    );
  }

  final source = prop.sources.single;
  if (source is MixSource<V> && source.mix is T) {
    return source.mix as T;
  }
  if (source is ValueSource<V> && source.value is T) {
    return source.value as T;
  }

  throw UnsupportedEncodeValueError(
    prop,
    'Field "$fieldName" is ${source.runtimeType}; expected $T.',
  );
}

AckSchema<String, String> _colorWireCodec() {
  return Ack.string()
      .matches(
        r'^(?:#[0-9A-Fa-f]{6}|#[0-9A-Fa-f]{8}|rgb\(\s*-?\d+\s*,\s*-?\d+\s*,\s*-?\d+\s*\)|rgba\(\s*-?\d+\s*,\s*-?\d+\s*,\s*-?\d+\s*,\s*-?(?:\d+(?:\.\d+)?|\.\d+)\s*\))$',
      )
      .constrain(
        _PredicateConstraint<String>(
          constraintKey: 'mix_schema_color_wire_range',
          description: 'Color wire values must use in-range CSS channels.',
          isValidValue: _isColorWireInRange,
          message:
              'RGB channels must be between 0 and 255; alpha must be between 0 and 1.',
        ),
      );
}

bool _isColorWireInRange(String value) {
  if (value.startsWith('#')) return true;
  final prefix = value.startsWith('rgb(')
      ? 'rgb('
      : value.startsWith('rgba(')
      ? 'rgba('
      : null;
  if (prefix == null) return false;

  final parts = value.substring(prefix.length, value.length - 1).split(',');
  final expectedCount = prefix == 'rgb(' ? 3 : 4;
  if (parts.length != expectedCount) return false;

  for (final part in parts.take(3)) {
    final channel = int.tryParse(part.trim());
    if (channel == null || channel < 0 || channel > 255) return false;
  }
  if (expectedCount == 3) return true;

  final alpha = double.tryParse(parts[3].trim());

  return alpha != null && alpha >= 0 && alpha <= 1;
}

Color _decodeColor(String value) {
  if (value.startsWith('#')) return _decodeHexColor(value);
  if (value.startsWith('rgb(')) return _decodeRgbColor(value);
  if (value.startsWith('rgba(')) return _decodeRgbaColor(value);

  throw FormatException('Unsupported color format: $value');
}

Color _decodeHexColor(String value) {
  final hex = value.substring(1);
  final argb = hex.length == 6 ? 'FF$hex' : hex;

  return Color(int.parse(argb, radix: 16));
}

Color _decodeRgbColor(String value) {
  final channels = _parseColorChannels(value, prefix: 'rgb(', count: 3);

  return Color.fromARGB(0xFF, channels[0], channels[1], channels[2]);
}

Color _decodeRgbaColor(String value) {
  final channels = _parseColorChannels(value, prefix: 'rgba(', count: 4);

  return Color.fromARGB(channels[3], channels[0], channels[1], channels[2]);
}

List<int> _parseColorChannels(
  String value, {
  required String prefix,
  required int count,
}) {
  final parts = value.substring(prefix.length, value.length - 1).split(',');
  if (parts.length != count) {
    throw FormatException('Expected $count color channels.');
  }

  final rgb = parts
      .take(3)
      .map((part) {
        final channel = int.parse(part.trim());
        if (channel < 0 || channel > 255) {
          throw FormatException('Color channel out of range: $channel');
        }

        return channel;
      })
      .toList(growable: false);

  if (count == 3) return rgb;

  final alpha = double.parse(parts[3].trim());
  if (alpha < 0 || alpha > 1) {
    throw FormatException('Alpha channel out of range: $alpha');
  }

  return [...rgb, (alpha * 255).round()];
}

Alignment _decodeAlignment(Object value) {
  if (value is String) return namedAlignments[value]!;

  final data = value as JsonMap;

  return Alignment(data['x']! as double, data['y']! as double);
}

Radius _decodeRadius(Object value) {
  if (value is num) return Radius.circular(value.toDouble());

  final data = value as JsonMap;

  return Radius.elliptical(data['x']! as double, data['y']! as double);
}

Object _encodeRadius(Radius value) {
  if (value.x == value.y) return value.x;

  return {'x': value.x, 'y': value.y};
}

EdgeInsetsMix _decodeEdgeInsetsMix(Object value) {
  if (value is num) return EdgeInsetsMix.all(value.toDouble());

  final data = value as JsonMap;

  return EdgeInsetsMix(
    left: data['left'] as double?,
    top: data['top'] as double?,
    right: data['right'] as double?,
    bottom: data['bottom'] as double?,
  );
}

Object _encodeEdgeInsetsMix(EdgeInsetsMix value) {
  final left = singleValueProp(value.$left, 'left');
  final top = singleValueProp(value.$top, 'top');
  final right = singleValueProp(value.$right, 'right');
  final bottom = singleValueProp(value.$bottom, 'bottom');

  return encodeEdgeInsetsWire(
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

double? _readOptionalMinConstraintBound(JsonMap data, String key) {
  if (!data.containsKey(key)) return null;

  return data[key] as double;
}

double? _readOptionalMaxConstraintBound(JsonMap data, String key) {
  if (!data.containsKey(key)) return null;

  return data[key] == null ? double.infinity : data[key] as double;
}

JsonMap _encodeBoxConstraintsMix(BoxConstraintsMix value) {
  final minWidth = singleValueProp(value.$minWidth, 'minWidth');
  final maxWidth = singleValueProp(value.$maxWidth, 'maxWidth');
  final minHeight = singleValueProp(value.$minHeight, 'minHeight');
  final maxHeight = singleValueProp(value.$maxHeight, 'maxHeight');

  _assertEncodableConstraintBounds(minWidth, maxWidth, 'width');
  _assertEncodableConstraintBounds(minHeight, maxHeight, 'height');

  return {
    if (minWidth != null) 'minWidth': _encodeMinConstraintBound(minWidth),
    if (maxWidth != null) 'maxWidth': _encodeMaxConstraintBound(maxWidth),
    if (minHeight != null) 'minHeight': _encodeMinConstraintBound(minHeight),
    if (maxHeight != null) 'maxHeight': _encodeMaxConstraintBound(maxHeight),
  };
}

double _encodeMinConstraintBound(double value) {
  if (value == double.infinity) {
    throw UnsupportedEncodeValueError(
      value,
      'Minimum constraint bounds cannot be unbounded.',
    );
  }

  return value;
}

double? _encodeMaxConstraintBound(double value) {
  return value == double.infinity ? null : value;
}

void _assertEncodableConstraintBounds(double? min, double? max, String axis) {
  if (min == null || max == null || max == double.infinity) return;
  if (min <= max) return;

  throw UnsupportedEncodeValueError({
    'min': min,
    'max': max,
  }, 'Minimum $axis constraint must be less than or equal to maximum $axis.');
}

BorderRadiusMix _decodeBorderRadiusMix(Object value) {
  if (value is Radius) return BorderRadiusMix.all(value);

  final data = value as JsonMap;

  return BorderRadiusMix(
    topLeft: data['topLeft'] as Radius?,
    topRight: data['topRight'] as Radius?,
    bottomLeft: data['bottomLeft'] as Radius?,
    bottomRight: data['bottomRight'] as Radius?,
  );
}

Object _encodeBorderRadiusMix(BorderRadiusMix value) {
  final topLeft = singleValueProp(value.$topLeft, 'topLeft');
  final topRight = singleValueProp(value.$topRight, 'topRight');
  final bottomLeft = singleValueProp(value.$bottomLeft, 'bottomLeft');
  final bottomRight = singleValueProp(value.$bottomRight, 'bottomRight');

  if (topLeft != null &&
      topLeft == topRight &&
      topRight == bottomLeft &&
      bottomLeft == bottomRight) {
    return topLeft;
  }

  return {
    'topLeft': topLeft,
    'topRight': topRight,
    'bottomLeft': bottomLeft,
    'bottomRight': bottomRight,
  };
}

final class _PredicateConstraint<T extends Object> extends Constraint<T>
    with Validator<T> {
  const _PredicateConstraint({
    required super.constraintKey,
    required super.description,
    required this.isValidValue,
    required this.message,
  });

  final bool Function(T value) isValidValue;
  final String message;

  @override
  bool isValid(T value) => isValidValue(value);

  @override
  String buildMessage(T value) => message;
}

final class _BoxConstraintsBoundsConstraint extends Constraint<JsonMap>
    with Validator<JsonMap> {
  const _BoxConstraintsBoundsConstraint()
    : super(
        constraintKey: 'mix_schema_box_constraints_bounds',
        description:
            'Box constraint minimum bounds must not exceed maximum bounds.',
      );

  @override
  bool isValid(JsonMap value) {
    return _isAxisValid(value, 'minWidth', 'maxWidth') &&
        _isAxisValid(value, 'minHeight', 'maxHeight');
  }

  @override
  String buildMessage(JsonMap value) {
    return 'Minimum box constraint bounds must be less than or equal to '
        'their maximum bounds.';
  }

  static bool _isAxisValid(JsonMap value, String minKey, String maxKey) {
    final min = value[minKey] as double?;
    final max = value[maxKey] as double?;
    if (min == null || max == null) return true;

    return min <= max;
  }
}
