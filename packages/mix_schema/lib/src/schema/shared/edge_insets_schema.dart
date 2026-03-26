import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

final AckSchema<EdgeInsetsGeometryMix> edgeInsetsSchema =
    Ack.object({
      'top': Ack.double().optional(),
      'bottom': Ack.double().optional(),
      'left': Ack.double().optional(),
      'right': Ack.double().optional(),
    }).transform<EdgeInsetsGeometryMix>((data) {
      final map = data;

      return EdgeInsetsMix(
        top: map['top'] as double?,
        bottom: map['bottom'] as double?,
        left: map['left'] as double?,
        right: map['right'] as double?,
      );
    });

final AckSchema<EdgeInsetsGeometryMix> edgeInsetsDirectionalSchema =
    Ack.object({
      'top': Ack.double().optional(),
      'bottom': Ack.double().optional(),
      'start': Ack.double().optional(),
      'end': Ack.double().optional(),
    }).transform<EdgeInsetsGeometryMix>((data) {
      final map = data;

      return EdgeInsetsDirectionalMix(
        top: map['top'] as double?,
        bottom: map['bottom'] as double?,
        start: map['start'] as double?,
        end: map['end'] as double?,
      );
    });

final AckSchema<EdgeInsetsGeometryMix> edgeInsetsGeometrySchema =
    Ack.object({
          'top': Ack.double().optional(),
          'bottom': Ack.double().optional(),
          'left': Ack.double().optional(),
          'right': Ack.double().optional(),
          'start': Ack.double().optional(),
          'end': Ack.double().optional(),
        })
        .refine((data) {
          final hasAbsolute = data['left'] != null || data['right'] != null;
          final hasDirectional = data['start'] != null || data['end'] != null;

          return !(hasAbsolute && hasDirectional);
        }, message: 'Use either left/right or start/end, not both.')
        .transform<EdgeInsetsGeometryMix>((data) {
          final map = data;
          final usesDirectional = map['start'] != null || map['end'] != null;

          return usesDirectional
              ? EdgeInsetsDirectionalMix(
                  top: map['top'] as double?,
                  bottom: map['bottom'] as double?,
                  start: map['start'] as double?,
                  end: map['end'] as double?,
                )
              : EdgeInsetsMix(
                  top: map['top'] as double?,
                  bottom: map['bottom'] as double?,
                  left: map['left'] as double?,
                  right: map['right'] as double?,
                );
        });
