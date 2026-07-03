import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import 'animation_codec.dart';
import 'common_codecs.dart';
import 'modifier_codec.dart';
import 'schema_field.dart';
import 'variant_codec.dart';

const stylerMetadataFields = {'variants', 'modifiers', 'animation'};

FrozenRegistry emptyFrozenRegistry() => RegistryBuilder().freeze();

final class StylerMetadataFields<
  Owner extends Object,
  SpecType extends Spec<SpecType>
> {
  StylerMetadataFields({
    required AckSchema<JsonMap, Object>? rootStyleSchema,
    required FrozenRegistry Function() registry,
    required List<VariantStyle<SpecType>>? Function(Owner value) readVariants,
    required WidgetModifierConfig? Function(Owner value) readModifier,
    required AnimationConfig? Function(Owner value) readAnimation,
  }) : _readVariants = readVariants,
       variants = rootStyleSchema == null
           ? null
           : directField<Owner, List<VariantStyle<SpecType>>>(
               'variants',
               Ack.list(variantCodec<SpecType>(rootStyleSchema)),
               readVariants,
             ),
       modifiers = directField<Owner, WidgetModifierConfig>(
         'modifiers',
         modifierConfigCodec(rootStyleSchema: rootStyleSchema),
         readModifier,
         inventoryName: 'modifier',
       ),
       animation = directField<Owner, AnimationConfig>(
         'animation',
         animationConfigCodec(registry: registry),
         readAnimation,
       );

  final List<VariantStyle<SpecType>>? Function(Owner value) _readVariants;
  final SchemaField<Owner, List<VariantStyle<SpecType>>>? variants;
  final SchemaField<Owner, WidgetModifierConfig> modifiers;
  final SchemaField<Owner, AnimationConfig> animation;

  List<SchemaFieldBase<Owner>> get fields => [?variants, modifiers, animation];

  List<UnsupportedSchemaField<Owner>> unsupportedFields({
    bool whenVariantsUnavailable = true,
  }) {
    return [
      if (whenVariantsUnavailable && variants == null)
        UnsupportedSchemaField<Owner>('variants', _readVariants),
    ];
  }
}

Object? encodedNestedStylerField<
  Owner extends Object,
  Styler extends Style<SpecType>,
  SpecType extends Spec<SpecType>
>(
  Owner value,
  String wire, {
  required Prop<StyleSpec<SpecType>>? Function(Owner value) read,
  required JsonMap Function(Styler value, {bool includeStylerMetadata})
  encodeFields,
  required String fieldName,
}) {
  final styler = readProp<Styler, StyleSpec<SpecType>>(read(value), fieldName);
  if (styler != null) {
    failIfPresent(styler.$variants, '$fieldName.variants');
    failIfPresent(styler.$modifier, '$fieldName.modifiers');
    failIfPresent(styler.$animation, '$fieldName.animation');
  }

  return styler == null
      ? null
      : encodeFields(styler, includeStylerMetadata: false)[wire];
}
