import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../core/json_casts.dart';
import '../core/json_map.dart';
import '../core/schema_wire_types.dart';
import 'metadata/modifier_definition.dart';
import 'mix_schema_catalog.dart';

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
  required MixSchemaCatalog catalog,
  required SchemaStyler type,
  required T emptyStyle,
  required Map<String, AckSchema> fields,
  required StylerBuilder<S, T> build,
  required StylerFieldEncoder<S, T> encodeFields,
}) {
  final inputFields = Map<String, AckSchema>.unmodifiable(fields);
  final variantStyleCodec = _buildStylerCodec<S, T>(
    inputFields: {...inputFields, ...catalog.buildVariantStyleMetadataFields()},
    build: (data) {
      final map = data;

      return build(map, modifier: catalog.buildModifierConfig(map));
    },
    encode: (value) => {
      ...encodeFields(value),
      ..._encodeMetadata<S, T>(value, includeTopLevelMetadata: false),
    },
  );

  final codec = _buildStylerCodec<S, T>(
    inputFields: {
      ...inputFields,
      ...catalog.buildMetadataFields<S, T>(
        styleSchema: variantStyleCodec,
        emptyStyle: emptyStyle,
      ),
    },
    build: (data) {
      final map = data;
      final List<VariantStyle<S>>? variants = castListOrNull(map['variants']);

      return build(
        map,
        animation: map['animation'] as AnimationConfig?,
        modifier: catalog.buildModifierConfig(map),
        variants: variants,
      );
    },
    encode: (value) => {
      ...encodeFields(value),
      ..._encodeMetadata<S, T>(value, includeTopLevelMetadata: true),
    },
  );

  return StylerContract(type: type, emptyStyle: emptyStyle, codec: codec);
}

CodecSchema<JsonMap, T>
_buildStylerCodec<S extends Spec<S>, T extends Style<S>>({
  required Map<String, AckSchema> inputFields,
  required T Function(JsonMap data) build,
  required JsonMap Function(T value) encode,
}) {
  return Ack.codec<JsonMap, T>(
    input: Ack.object(inputFields),
    output: Ack.instance<T>(),
    decoder: build,
    encoder: encode,
  );
}

JsonMap _encodeMetadata<S extends Spec<S>, T extends Style<S>>(
  T value, {
  required bool includeTopLevelMetadata,
}) {
  final payload = <String, Object?>{};
  _encodeModifierMetadata(payload, value.$modifier);

  if (!includeTopLevelMetadata) {
    if (value.$animation != null) {
      throw UnsupportedError('Variant styles cannot encode animation.');
    }
    if (value.$variants != null && value.$variants!.isNotEmpty) {
      throw UnsupportedError('Variant styles cannot encode nested variants.');
    }

    return payload;
  }

  if (value.$animation case final CurveAnimationConfig animation) {
    payload['animation'] = animation;
  } else if (value.$animation != null) {
    throw UnsupportedError('Only curve animation configs can be encoded.');
  }

  if (value.$variants case final variants? when variants.isNotEmpty) {
    payload['variants'] = variants;
  }

  return payload;
}

void _encodeModifierMetadata(JsonMap payload, WidgetModifierConfig? modifier) {
  if (modifier == null) return;

  final modifiers = modifier.$modifiers;
  if (modifiers != null && modifiers.isNotEmpty) {
    payload['modifiers'] = modifiers;
  }

  final modifierOrder = modifier.$orderOfModifiers;
  if (modifierOrder != null && modifierOrder.isNotEmpty) {
    payload['modifierOrder'] = [
      for (final runtimeType in modifierOrder) _modifierWireValue(runtimeType),
    ];
  }
}

String _modifierWireValue(Type runtimeType) {
  final type = schemaModifierForRuntimeType(runtimeType);
  if (type == null) {
    throw UnsupportedError(
      'Modifier order type $runtimeType is not supported.',
    );
  }

  return type.wireValue;
}
