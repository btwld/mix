import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../core/json_casts.dart';
import '../core/json_map.dart';
import '../core/schema_wire_types.dart';
import 'builtins/styler_metadata.dart';
import 'styler_catalog.dart';

typedef StylerBuilder<S extends Spec<S>, T extends Style<S>> =
    T Function(
      Map<String, Object?> data, {
      AnimationConfig? animation,
      WidgetModifierConfig? modifier,
      List<VariantStyle<S>>? variants,
    });

typedef StylerFieldEncoder<S extends Spec<S>, T extends Style<S>> =
    JsonMap Function(T value);

final class StylerContract<S extends Spec<S>, T extends Style<S>> {
  final SchemaStyler type;
  final T emptyStyle;
  final CodecSchema<JsonMap, T> codec;

  const StylerContract({
    required this.type,
    required this.emptyStyle,
    required this.codec,
  });
}

StylerContract<S, T>
buildStylerCodecContract<S extends Spec<S>, T extends Style<S>>({
  required StylerCatalog catalog,
  required SchemaStyler type,
  required T emptyStyle,
  required Map<String, AckSchema> fields,
  required StylerBuilder<S, T> build,
  required StylerFieldEncoder<S, T> encodeFields,
}) {
  final metadata = catalog.metadata;
  final inputFields = Map<String, AckSchema>.unmodifiable(fields);
  final variantStyleCodec = _buildStylerCodec<S, T>(
    inputFields: {...inputFields, ...metadata.variantStyleMetadataFields()},
    build: (data) {
      final map = data;

      return build(map, modifier: metadata.modifierConfig(map));
    },
    encode: (value) => {
      ...encodeFields(value),
      ...encodeStylerMetadata(value, includeTopLevelMetadata: false),
    },
  );

  final codec = _buildStylerCodec<S, T>(
    type: type,
    inputFields: {
      ...inputFields,
      ...metadata.topLevelMetadataFields<S, T>(
        variantStyleCodec: variantStyleCodec,
        emptyStyle: emptyStyle,
      ),
    },
    build: (data) {
      final map = data;
      final List<VariantStyle<S>>? variants = castListOrNull(map['variants']);

      return build(
        map,
        animation: map['animation'] as AnimationConfig?,
        modifier: metadata.modifierConfig(map),
        variants: variants,
      );
    },
    encode: (value) => {
      ...encodeFields(value),
      ...encodeStylerMetadata(value, includeTopLevelMetadata: true),
    },
  );

  return StylerContract(type: type, emptyStyle: emptyStyle, codec: codec);
}

CodecSchema<JsonMap, T>
_buildStylerCodec<S extends Spec<S>, T extends Style<S>>({
  SchemaStyler? type,
  required Map<String, AckSchema> inputFields,
  required T Function(JsonMap data) build,
  required JsonMap Function(T value) encode,
}) {
  return Ack.codec<JsonMap, T>(
    input: Ack.object({
      if (type != null) 'type': Ack.literal(type.wireValue),
      ...inputFields,
    }),
    output: Ack.instance<T>(),
    decoder: build,
    encoder: type == null
        ? encode
        : (value) => {'type': type.wireValue, ...encode(value)},
  );
}
