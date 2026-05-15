import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../contract/mix_schema_limits.dart';
import '../../core/json_map.dart';
import '../../registry/registry_catalog.dart';
import '../metadata/metadata_field_schemas.dart';
import '../metadata/modifier_definition.dart';
import '../metadata/modifier_schema.dart';
import '../metadata/variant_schema.dart';

final class StylerMetadataContext {
  final RegistryCatalog registries;
  final MixSchemaLimits limits;
  final AckSchema<CurveAnimationConfig> animationCodec;
  final AckSchema<ModifierMix> modifierCodec;

  const StylerMetadataContext({
    required this.registries,
    required this.limits,
    required this.animationCodec,
    required this.modifierCodec,
  });

  Map<String, AckSchema> variantStyleMetadataFields() {
    return buildVariantStyleMetadataFieldSchemas(
      modifierSchema: modifierCodec,
      limits: limits,
    );
  }

  Map<String, AckSchema> topLevelMetadataFields<
    S extends Spec<S>,
    T extends Style<S>
  >({required AckSchema<T> variantStyleCodec, required T emptyStyle}) {
    final AckSchema<VariantStyle<S>> variantCodec = buildVariantSchema(
      styleSchema: variantStyleCodec,
      emptyStyle: emptyStyle,
      registries: registries,
      limits: limits,
    );

    return buildMetadataFieldSchemas(
      animationSchema: animationCodec,
      modifierSchema: modifierCodec,
      variantSchema: variantCodec,
      limits: limits,
    );
  }

  WidgetModifierConfig? modifierConfig(JsonMap data) {
    return buildWidgetModifierConfigFromFields(data);
  }
}

JsonMap encodeStylerMetadata(
  Style value, {
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
