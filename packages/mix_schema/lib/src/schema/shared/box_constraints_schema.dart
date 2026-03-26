import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

final AckSchema<BoxConstraintsMix> boxConstraintsSchema =
    Ack.object({
          'minWidth': Ack.double().optional(),
          'maxWidth': Ack.double().optional(),
          'minHeight': Ack.double().optional(),
          'maxHeight': Ack.double().optional(),
        })
        .refine((data) {
          final map = data;
          final minWidth = map['minWidth'] as double?;
          final maxWidth = map['maxWidth'] as double?;

          return minWidth == null || maxWidth == null || minWidth <= maxWidth;
        }, message: 'minWidth must be less than or equal to maxWidth.')
        .refine((data) {
          final map = data;
          final minHeight = map['minHeight'] as double?;
          final maxHeight = map['maxHeight'] as double?;

          return minHeight == null ||
              maxHeight == null ||
              minHeight <= maxHeight;
        }, message: 'minHeight must be less than or equal to maxHeight.')
        .transform<BoxConstraintsMix>((data) {
          final map = data;

          return BoxConstraintsMix(
            minWidth: map['minWidth'] as double?,
            maxWidth: map['maxWidth'] as double?,
            minHeight: map['minHeight'] as double?,
            maxHeight: map['maxHeight'] as double?,
          );
        });
