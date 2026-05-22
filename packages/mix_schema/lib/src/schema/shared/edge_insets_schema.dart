import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/numeric_codecs.dart';
import '../../core/prop_encode.dart';

JsonMap _encodeEdgeInsetsMix(EdgeInsetsMix value) => optionalJsonMap([
  ('top', propValue(value.$top)),
  ('bottom', propValue(value.$bottom)),
  ('left', propValue(value.$left)),
  ('right', propValue(value.$right)),
]);

JsonMap _encodeEdgeInsetsDirectionalMix(EdgeInsetsDirectionalMix value) =>
    optionalJsonMap([
      ('top', propValue(value.$top)),
      ('bottom', propValue(value.$bottom)),
      ('start', propValue(value.$start)),
      ('end', propValue(value.$end)),
    ]);

final edgeInsetsCodec = Ack.codec<JsonMap, JsonMap, EdgeInsetsGeometryMix>(
  input: Ack.object({
    'top': doubleFromNum().optional(),
    'bottom': doubleFromNum().optional(),
    'left': doubleFromNum().optional(),
    'right': doubleFromNum().optional(),
  }),
  output: Ack.instance<EdgeInsetsGeometryMix>(),
  decode: (data) => EdgeInsetsMix(
    top: data['top'] as double?,
    bottom: data['bottom'] as double?,
    left: data['left'] as double?,
    right: data['right'] as double?,
  ),
  encode: (value) => _encodeEdgeInsetsMix(value as EdgeInsetsMix),
);

final edgeInsetsDirectionalCodec =
    Ack.codec<JsonMap, JsonMap, EdgeInsetsGeometryMix>(
      input: Ack.object({
        'top': doubleFromNum().optional(),
        'bottom': doubleFromNum().optional(),
        'start': doubleFromNum().optional(),
        'end': doubleFromNum().optional(),
      }),
      output: Ack.instance<EdgeInsetsGeometryMix>(),
      decode: (data) => EdgeInsetsDirectionalMix(
        top: data['top'] as double?,
        bottom: data['bottom'] as double?,
        start: data['start'] as double?,
        end: data['end'] as double?,
      ),
      encode: (value) =>
          _encodeEdgeInsetsDirectionalMix(value as EdgeInsetsDirectionalMix),
    );

final edgeInsetsGeometryCodec =
    Ack.codec<JsonMap, JsonMap, EdgeInsetsGeometryMix>(
      input:
          Ack.object({
            'top': doubleFromNum().optional(),
            'bottom': doubleFromNum().optional(),
            'left': doubleFromNum().optional(),
            'right': doubleFromNum().optional(),
            'start': doubleFromNum().optional(),
            'end': doubleFromNum().optional(),
          }).refine((data) {
            final hasAbsolute = data['left'] != null || data['right'] != null;
            final hasDirectional = data['start'] != null || data['end'] != null;

            return !(hasAbsolute && hasDirectional);
          }, message: 'Use either left/right or start/end, not both.'),
      output: Ack.instance<EdgeInsetsGeometryMix>(),
      decode: (data) {
        final usesDirectional = data['start'] != null || data['end'] != null;

        return usesDirectional
            ? EdgeInsetsDirectionalMix(
                top: data['top'] as double?,
                bottom: data['bottom'] as double?,
                start: data['start'] as double?,
                end: data['end'] as double?,
              )
            : EdgeInsetsMix(
                top: data['top'] as double?,
                bottom: data['bottom'] as double?,
                left: data['left'] as double?,
                right: data['right'] as double?,
              );
      },
      encode: (value) => switch (value) {
        EdgeInsetsMix() => _encodeEdgeInsetsMix(value),
        EdgeInsetsDirectionalMix() => _encodeEdgeInsetsDirectionalMix(value),
      },
    );
