import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';

import 'color_schema.dart';

final AckSchema<Offset> offsetSchema =
    Ack.object({'dx': Ack.double(), 'dy': Ack.double()}).transform<Offset>((
      data,
    ) {
      final map = data!;

      return Offset(map['dx'] as double, map['dy'] as double);
    });

final AckSchema<Radius> radiusSchema =
    Ack.object({
      'x': Ack.double(),
      'y': Ack.double().optional(),
    }).transform<Radius>((data) {
      final map = data!;
      final x = map['x'] as double;

      return Radius.elliptical(x, (map['y'] as double?) ?? x);
    });

final AckSchema<AlignmentGeometry> alignmentSchema =
    Ack.object({
      'x': Ack.double(),
      'y': Ack.double(),
    }).transform<AlignmentGeometry>((data) {
      final map = data!;

      return Alignment(map['x'] as double, map['y'] as double);
    });

final AckSchema<Rect> rectSchema =
    Ack.object({
      'left': Ack.double(),
      'top': Ack.double(),
      'right': Ack.double(),
      'bottom': Ack.double(),
    }).transform<Rect>((data) {
      final map = data!;

      return Rect.fromLTRB(
        map['left'] as double,
        map['top'] as double,
        map['right'] as double,
        map['bottom'] as double,
      );
    });

final AckSchema<List<Color>> colorListSchema = Ack.list(colorSchema).refine(
  (colors) => colors.length >= 2,
  message: 'Gradient requires at least two colors.',
);

final AckSchema<List<double>> doubleListSchema = Ack.list(Ack.double());
final AckSchema<List<String>> stringListSchema = Ack.list(Ack.string());

final AckSchema<Matrix4> matrix4Schema = Ack.list(Ack.double())
    .refine(
      (values) => values.length == 16,
      message: 'Matrix4 requires 16 values.',
    )
    .transform<Matrix4>((values) => Matrix4.fromList(values!));
