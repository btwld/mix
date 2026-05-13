import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/prop_encode.dart';

final CodecSchema<Map<String, Object?>, BoxConstraintsMix> boxConstraintsCodec =
    Ack.codec<Map<String, Object?>, BoxConstraintsMix>(
      input:
          Ack.object({
                'minWidth': Ack.number().optional(),
                'maxWidth': Ack.number().optional(),
                'minHeight': Ack.number().optional(),
                'maxHeight': Ack.number().optional(),
              })
              .refine((data) {
                final minWidth = castDoubleOrNull(data['minWidth']);
                final maxWidth = castDoubleOrNull(data['maxWidth']);

                return minWidth == null ||
                    maxWidth == null ||
                    minWidth <= maxWidth;
              }, message: 'minWidth must be less than or equal to maxWidth.')
              .refine((data) {
                final minHeight = castDoubleOrNull(data['minHeight']);
                final maxHeight = castDoubleOrNull(data['maxHeight']);

                return minHeight == null ||
                    maxHeight == null ||
                    minHeight <= maxHeight;
              }, message: 'minHeight must be less than or equal to maxHeight.'),
      output: Ack.instance<BoxConstraintsMix>(),
      decoder: (data) => BoxConstraintsMix(
        minWidth: castDoubleOrNull(data['minWidth']),
        maxWidth: castDoubleOrNull(data['maxWidth']),
        minHeight: castDoubleOrNull(data['minHeight']),
        maxHeight: castDoubleOrNull(data['maxHeight']),
      ),
      encoder: (value) => optionalJsonMap([
        ('minWidth', propValue(value.$minWidth)),
        ('maxWidth', propValue(value.$maxWidth)),
        ('minHeight', propValue(value.$minHeight)),
        ('maxHeight', propValue(value.$maxHeight)),
      ]),
    );
