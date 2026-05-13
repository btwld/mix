import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';

import '../../core/json_casts.dart';
import 'color_schema.dart';

final CodecSchema<Map<String, Object?>, Offset> offsetCodec =
    Ack.codec<Map<String, Object?>, Offset>(
      input: Ack.object({'dx': Ack.number(), 'dy': Ack.number()}),
      output: Ack.instance<Offset>(),
      decoder: (data) => Offset(castDouble(data['dx']), castDouble(data['dy'])),
      encoder: (offset) => {'dx': offset.dx, 'dy': offset.dy},
    );

final CodecSchema<Map<String, Object?>, Radius> radiusCodec =
    Ack.codec<Map<String, Object?>, Radius>(
      input: Ack.object({'x': Ack.number(), 'y': Ack.number().optional()}),
      output: Ack.instance<Radius>(),
      decoder: (data) {
        final x = castDouble(data['x']);

        return Radius.elliptical(x, castDoubleOrNull(data['y']) ?? x);
      },
      encoder: (radius) => {
        'x': radius.x,
        if (radius.y != radius.x) 'y': radius.y,
      },
    );

final CodecSchema<Map<String, Object?>, AlignmentGeometry> alignmentCodec =
    Ack.codec<Map<String, Object?>, AlignmentGeometry>(
      input: Ack.object({'x': Ack.number(), 'y': Ack.number()}),
      output: Ack.instance<AlignmentGeometry>(),
      decoder: (data) =>
          Alignment(castDouble(data['x']), castDouble(data['y'])),
      encoder: (alignment) {
        if (alignment is! Alignment) {
          throw UnsupportedError(
            'Only absolute Alignment values can be encoded.',
          );
        }

        return {'x': alignment.x, 'y': alignment.y};
      },
    );

final CodecSchema<Map<String, Object?>, Rect> rectCodec =
    Ack.codec<Map<String, Object?>, Rect>(
      input: Ack.object({
        'left': Ack.number(),
        'top': Ack.number(),
        'right': Ack.number(),
        'bottom': Ack.number(),
      }),
      output: Ack.instance<Rect>(),
      decoder: (data) => Rect.fromLTRB(
        castDouble(data['left']),
        castDouble(data['top']),
        castDouble(data['right']),
        castDouble(data['bottom']),
      ),
      encoder: (rect) => {
        'left': rect.left,
        'top': rect.top,
        'right': rect.right,
        'bottom': rect.bottom,
      },
    );

final AckSchema<List<Color>> colorListSchema = Ack.list(colorCodec).refine(
  (colors) => colors.length >= 2,
  message: 'Gradient requires at least two colors.',
);

final AckSchema<List<num>> numListSchema = Ack.list(Ack.number());
final AckSchema<List<String>> stringListSchema = Ack.list(Ack.string());

final CodecSchema<List<Object?>, Matrix4> matrix4Codec =
    Ack.codec<List<Object?>, Matrix4>(
      input: Ack.list(Ack.number()).refine(
        (values) => values.length == 16,
        message: 'Matrix4 requires 16 values.',
      ),
      output: Ack.instance<Matrix4>(),
      decoder: (values) =>
          Matrix4.fromList([for (final v in values) castDouble(v)]),
      encoder: (matrix) => matrix.storage.toList(),
    );
