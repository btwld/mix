import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/json_map.dart';
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

final CodecSchema<Map<String, Object?>, EdgeInsetsGeometryMix> edgeInsetsCodec =
    Ack.codec<Map<String, Object?>, EdgeInsetsGeometryMix>(
      input: Ack.object({
        'top': Ack.number().optional(),
        'bottom': Ack.number().optional(),
        'left': Ack.number().optional(),
        'right': Ack.number().optional(),
      }),
      output: Ack.instance<EdgeInsetsGeometryMix>(),
      decoder: (data) => EdgeInsetsMix(
        top: castDoubleOrNull(data['top']),
        bottom: castDoubleOrNull(data['bottom']),
        left: castDoubleOrNull(data['left']),
        right: castDoubleOrNull(data['right']),
      ),
      encoder: (value) => _encodeEdgeInsetsMix(value as EdgeInsetsMix),
    );

final CodecSchema<Map<String, Object?>, EdgeInsetsGeometryMix>
edgeInsetsDirectionalCodec =
    Ack.codec<Map<String, Object?>, EdgeInsetsGeometryMix>(
      input: Ack.object({
        'top': Ack.number().optional(),
        'bottom': Ack.number().optional(),
        'start': Ack.number().optional(),
        'end': Ack.number().optional(),
      }),
      output: Ack.instance<EdgeInsetsGeometryMix>(),
      decoder: (data) => EdgeInsetsDirectionalMix(
        top: castDoubleOrNull(data['top']),
        bottom: castDoubleOrNull(data['bottom']),
        start: castDoubleOrNull(data['start']),
        end: castDoubleOrNull(data['end']),
      ),
      encoder: (value) =>
          _encodeEdgeInsetsDirectionalMix(value as EdgeInsetsDirectionalMix),
    );

final CodecSchema<Map<String, Object?>, EdgeInsetsGeometryMix>
edgeInsetsGeometryCodec =
    Ack.codec<Map<String, Object?>, EdgeInsetsGeometryMix>(
      input:
          Ack.object({
            'top': Ack.number().optional(),
            'bottom': Ack.number().optional(),
            'left': Ack.number().optional(),
            'right': Ack.number().optional(),
            'start': Ack.number().optional(),
            'end': Ack.number().optional(),
          }).refine((data) {
            final hasAbsolute = data['left'] != null || data['right'] != null;
            final hasDirectional = data['start'] != null || data['end'] != null;

            return !(hasAbsolute && hasDirectional);
          }, message: 'Use either left/right or start/end, not both.'),
      output: Ack.instance<EdgeInsetsGeometryMix>(),
      decoder: (data) {
        final usesDirectional = data['start'] != null || data['end'] != null;

        return usesDirectional
            ? EdgeInsetsDirectionalMix(
                top: castDoubleOrNull(data['top']),
                bottom: castDoubleOrNull(data['bottom']),
                start: castDoubleOrNull(data['start']),
                end: castDoubleOrNull(data['end']),
              )
            : EdgeInsetsMix(
                top: castDoubleOrNull(data['top']),
                bottom: castDoubleOrNull(data['bottom']),
                left: castDoubleOrNull(data['left']),
                right: castDoubleOrNull(data['right']),
              );
      },
      encoder: (value) => switch (value) {
        EdgeInsetsMix() => _encodeEdgeInsetsMix(value),
        EdgeInsetsDirectionalMix() => _encodeEdgeInsetsDirectionalMix(value),
      },
    );
