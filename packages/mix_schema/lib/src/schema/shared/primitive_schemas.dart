import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';

import '../../core/numeric_codecs.dart';
import '../../errors/schema_transform_exceptions.dart';
import 'color_schema.dart';

final offsetCodec = Ack.codec<JsonMap, JsonMap, Offset>(
  input: Ack.object({'dx': doubleFromNum(), 'dy': doubleFromNum()}),
  output: Ack.instance<Offset>(),
  decode: (data) => Offset(data['dx']! as double, data['dy']! as double),
  encode: (offset) => {'dx': offset.dx, 'dy': offset.dy},
);

final radiusCodec = Ack.codec<JsonMap, JsonMap, Radius>(
  input: Ack.object({'x': doubleFromNum(), 'y': doubleFromNum().optional()}),
  output: Ack.instance<Radius>(),
  decode: (data) {
    final x = data['x']! as double;
    final y = data['y'] as double?;

    return Radius.elliptical(x, y ?? x);
  },
  encode: (radius) => {'x': radius.x, if (radius.y != radius.x) 'y': radius.y},
);

final alignmentCodec = Ack.codec<JsonMap, JsonMap, AlignmentGeometry>(
  input: Ack.object({'x': doubleFromNum(), 'y': doubleFromNum()}),
  output: Ack.instance<AlignmentGeometry>(),
  decode: (data) => Alignment(data['x']! as double, data['y']! as double),
  encode: (alignment) {
    if (alignment is! Alignment) {
      throw UnsupportedEncodeValueError(
        'Only absolute Alignment values can be encoded.',
        value: alignment,
      );
    }

    return {'x': alignment.x, 'y': alignment.y};
  },
);

final rectCodec = Ack.codec<JsonMap, JsonMap, Rect>(
  input: Ack.object({
    'left': doubleFromNum(),
    'top': doubleFromNum(),
    'right': doubleFromNum(),
    'bottom': doubleFromNum(),
  }),
  output: Ack.instance<Rect>(),
  decode: (data) => Rect.fromLTRB(
    data['left']! as double,
    data['top']! as double,
    data['right']! as double,
    data['bottom']! as double,
  ),
  encode: (rect) => {
    'left': rect.left,
    'top': rect.top,
    'right': rect.right,
    'bottom': rect.bottom,
  },
);

final colorListSchema = Ack.list(colorCodec).refine(
  (colors) => colors.length >= 2,
  message: 'Gradient requires at least two colors.',
);

final doubleListSchema = Ack.list(doubleFromNum());
final stringListSchema = Ack.list(Ack.string());

final matrix4Codec = Ack.codec<List<Object>, List<double>, Matrix4>(
  input: Ack.list(doubleFromNum()).refine(
    (values) => values.length == 16,
    message: 'Matrix4 requires 16 values.',
  ),
  output: Ack.instance<Matrix4>(),
  decode: Matrix4.fromList,
  encode: (matrix) => matrix.storage.toList(),
);
