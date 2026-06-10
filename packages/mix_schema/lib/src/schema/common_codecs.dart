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

CodecSchema<Object, Color> colorCodec() {
  return Ack.codec<Object, Object, Color>(
    input: Ack.anyOf([
      Ack.string().matches(r'^#[0-9A-Fa-f]{6}$'),
      Ack.string().matches(r'^#[0-9A-Fa-f]{8}$'),
      Ack.string().matches(
        r'^rgb\(\s*\d{1,3}\s*,\s*\d{1,3}\s*,\s*\d{1,3}\s*\)$',
      ),
      Ack.string().matches(
        r'^rgba\(\s*\d{1,3}\s*,\s*\d{1,3}\s*,\s*\d{1,3}\s*,\s*(?:0|1|0?\.\d+|1\.0+)\s*\)$',
      ),
    ]),
    decode: (value) => _decodeColor(value as String),
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

CodecSchema<JsonMap, BoxConstraintsMix> boxConstraintsCodec() {
  return Ack.object({
    'minWidth': nonNegativeDoubleCodec().nullable().optional(),
    'maxWidth': nonNegativeDoubleCodec().nullable().optional(),
    'minHeight': nonNegativeDoubleCodec().nullable().optional(),
    'maxHeight': nonNegativeDoubleCodec().nullable().optional(),
  }).codec<BoxConstraintsMix>(
    decode: (data) => BoxConstraintsMix(
      minWidth: _readOptionalConstraintBound(data, 'minWidth'),
      maxWidth: _readOptionalConstraintBound(data, 'maxWidth'),
      minHeight: _readOptionalConstraintBound(data, 'minHeight'),
      maxHeight: _readOptionalConstraintBound(data, 'maxHeight'),
    ),
    encode: (value) => {
      'minWidth': _encodeConstraintBound(
        singleValueProp(value.$minWidth, 'minWidth'),
      ),
      'maxWidth': _encodeConstraintBound(
        singleValueProp(value.$maxWidth, 'maxWidth'),
      ),
      'minHeight': _encodeConstraintBound(
        singleValueProp(value.$minHeight, 'minHeight'),
      ),
      'maxHeight': _encodeConstraintBound(
        singleValueProp(value.$maxHeight, 'maxHeight'),
      ),
    },
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

CodecSchema<String, T> strictEnumCodec<T extends Object>(
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

CodecSchema<String, T> enumNameCodec<T extends Enum>(
  List<T> values, {
  String? debugName,
}) {
  return Ack.enumCodec(values);
}

Alignment? singleAlignmentProp(
  Prop<AlignmentGeometry>? prop,
  String fieldName,
) {
  final value = singleValueProp(prop, fieldName);
  if (value == null) return null;
  if (value is Alignment) return value;

  throw UnsupportedEncodeValueError(
    value,
    'Field "$fieldName" uses ${value.runtimeType}; only Alignment is supported.',
  );
}

T? singleValueProp<T extends Object>(Prop<T>? prop, String fieldName) {
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

  return switch (source) {
    ValueSource<T>(:final value) => value,
    TokenSource<T>() => throw UnsupportedEncodeValueError(
      prop,
      'Field "$fieldName" uses a token value.',
    ),
    MixSource<T>() => throw UnsupportedEncodeValueError(
      prop,
      'Field "$fieldName" uses a nested Mix value.',
    ),
  };
}

T? singleMixProp<T extends Object, V extends Object>(
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

double? _readOptionalConstraintBound(JsonMap data, String key) {
  if (!data.containsKey(key)) return null;

  final value = data[key];
  if (value == null) return double.infinity;

  return value as double;
}

double? _encodeConstraintBound(double? value) {
  if (value == null) return null;

  return value == double.infinity ? null : value;
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
