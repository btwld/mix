import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/numeric_codecs.dart';
import '../../core/prop_encode.dart';

final boxConstraintsCodec = Ack.codec<JsonMap, JsonMap, BoxConstraintsMix>(
  input:
      Ack.object({
            'minWidth': doubleFromNum().optional(),
            'maxWidth': doubleFromNum().optional(),
            'minHeight': doubleFromNum().optional(),
            'maxHeight': doubleFromNum().optional(),
          })
          .refine((data) {
            final minWidth = data['minWidth'] as double?;
            final maxWidth = data['maxWidth'] as double?;

            return minWidth == null || maxWidth == null || minWidth <= maxWidth;
          }, message: 'minWidth must be less than or equal to maxWidth.')
          .refine((data) {
            final minHeight = data['minHeight'] as double?;
            final maxHeight = data['maxHeight'] as double?;

            return minHeight == null ||
                maxHeight == null ||
                minHeight <= maxHeight;
          }, message: 'minHeight must be less than or equal to maxHeight.'),
  output: Ack.instance<BoxConstraintsMix>(),
  decode: (data) => BoxConstraintsMix(
    minWidth: data['minWidth'] as double?,
    maxWidth: data['maxWidth'] as double?,
    minHeight: data['minHeight'] as double?,
    maxHeight: data['maxHeight'] as double?,
  ),
  encode: (value) => optionalJsonMap([
    ('minWidth', directPropValue(value.$minWidth)),
    ('maxWidth', directPropValue(value.$maxWidth)),
    ('minHeight', directPropValue(value.$minHeight)),
    ('maxHeight', directPropValue(value.$maxHeight)),
  ]),
);
