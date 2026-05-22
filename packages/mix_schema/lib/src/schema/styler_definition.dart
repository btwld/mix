import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../core/json_casts.dart';
import '../core/schema_wire_types.dart';
import 'builtins/styler_metadata.dart';
import 'styler_catalog.dart';

typedef StylerBuilder<S extends Spec<S>, T extends Style<S>> =
    T Function(
      JsonMap data, {
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
  required Map<String, AckSchema<Object, Object>> fields,
  Map<String, AckSchema<Object, Object>>? variantStyleFields,
  required StylerBuilder<S, T> build,
  required StylerFieldEncoder<S, T> encodeFields,
  StylerFieldEncoder<S, T>? encodeVariantStyleFields,
}) {
  final metadata = catalog.metadata;
  final inputFields = Map<String, AckSchema<Object, Object>>.unmodifiable(
    fields,
  );
  final nestedInputFields = Map<String, AckSchema<Object, Object>>.unmodifiable(
    variantStyleFields ?? fields,
  );
  final encodeNestedFields = encodeVariantStyleFields ?? encodeFields;
  final variantStyleCodec = _buildStylerCodec<S, T>(
    inputFields: {
      ...nestedInputFields,
      ...metadata.variantStyleMetadataFields(),
    },
    build: (data) => build(data, modifier: metadata.modifierConfig(data)),
    encode: (value) => {
      ...encodeNestedFields(value),
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
      final List<VariantStyle<S>>? variants = castListOrNull(data['variants']);

      return build(
        data,
        animation: data['animation'] as AnimationConfig?,
        modifier: metadata.modifierConfig(data),
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
  required Map<String, AckSchema<Object, Object>> inputFields,
  required T Function(JsonMap data) build,
  required JsonMap Function(T value) encode,
}) {
  return Ack.codec<JsonMap, JsonMap, T>(
    input: Ack.object(inputFields),
    decode: build,
    encode: type == null
        ? encode
        : (value) => {'type': type.wireValue, ...encode(value)},
    output: Ack.instance<T>(),
  );
}
