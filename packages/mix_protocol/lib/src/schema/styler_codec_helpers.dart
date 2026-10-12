import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../errors/mix_protocol_error.dart';
import 'animation_codec.dart';
import 'modifier_codec.dart';
import 'schema_field.dart';
import 'variant_codec.dart';

const stylerMetadataFields = {'variants', 'modifiers', 'animation'};

/// Returns Styler source-field metadata when [value] exposes it.
Set<String>? stylerFieldInventoryOf(Object value) => switch (value) {
  StylerFieldMetadata metadata => metadata.$stylerFieldNames,
  _ => null,
};

final class StylerMetadataFields<
  Owner extends Object,
  SpecType extends Spec<SpecType>
> {
  final SchemaField<Owner, List<VariantStyle<SpecType>>>? variants;

  final SchemaField<Owner, WidgetModifierConfig> modifiers;
  final SchemaField<Owner, AnimationConfig> animation;
  final List<VariantStyle<SpecType>>? Function(Owner value) _readVariants;
  StylerMetadataFields({
    required AckSchema<JsonMap, Object>? rootStyleSchema,
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
               schemaSemantics: listEntryFieldSemantics,
             ),
       modifiers = directField<Owner, WidgetModifierConfig>(
         'modifiers',
         modifierConfigCodec(rootStyleSchema: rootStyleSchema),
         readModifier,
         inventoryName: 'modifier',
         schemaSemantics: const SchemaFieldSemantics(
           listEntryPaths: [
             [],
             ['order'],
             ['items'],
           ],
         ),
       ),
       animation = directField<Owner, AnimationConfig>(
         'animation',
         animationConfigCodec(),
         readAnimation,
       );

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

/// Creates a schema object for a standard Mix styler, including its shared
/// metadata fields and generated field-inventory check.
SchemaObject<Styler> stylerSchemaObject<
  Styler extends Style<SpecType>,
  SpecType extends Spec<SpecType>
>({
  required AckSchema<JsonMap, Object>? rootStyleSchema,
  required List<SchemaFieldBase<Styler>> fields,
  required Styler Function(
    JsonMap data,
    StylerMetadataFields<Styler, SpecType> metadata,
  )
  build,
}) {
  final metadata = StylerMetadataFields<Styler, SpecType>(
    rootStyleSchema: rootStyleSchema,
    readVariants: (value) => value.$variants,
    readModifier: (value) => value.$modifier,
    readAnimation: (value) => value.$animation,
  );

  return SchemaObject<Styler>(
    fields: [...fields, ...metadata.fields],
    build: (data) => build(data, metadata),
    unsupportedFields: metadata.unsupportedFields(),
    ownerFieldInventoryOf: stylerFieldInventoryOf,
    actualFieldCount: (value) => value.props.length,
  );
}

JsonMap encodedNestedStylerFields<
  Owner extends Object,
  Styler extends Style<SpecType>,
  SpecType extends Spec<SpecType>
>(
  Owner value, {
  required Prop<StyleSpec<SpecType>>? Function(Owner value) read,
  required JsonMap Function(Styler value, {bool includeStylerMetadata})
  encodeFields,
  required String fieldName,
}) {
  final styler = mergeNestedStyler<Styler, SpecType>(read(value), fieldName);
  if (styler != null) {
    _failNestedMetadata(fieldName, 'variants', styler.$variants);
    _failNestedMetadata(fieldName, 'modifiers', styler.$modifier);
    _failNestedMetadata(fieldName, 'animation', styler.$animation);
  }

  return styler == null
      ? const {}
      : encodeFields(styler, includeStylerMetadata: false);
}

void _failNestedMetadata(String fieldName, String metadata, Object? value) {
  if (value == null) return;

  throw _unsupportedNestedStyler(
    '$fieldName/$metadata',
    value,
    'Field "$fieldName.$metadata" is not representable by this schema.',
  );
}

/// Builds a path-qualified diagnostic for an unrepresentable composite slot.
///
/// Composite slots (`box`/`flex`/`stack`) are read from the object-level encode
/// callback, outside any Ack field codec, so a bare [UnsupportedEncodeValueError]
/// would surface with an empty path — and, because the root styler schema is a
/// union, without a specific path the sibling-branch "Expected ..." noise is not
/// filtered. Emitting a [SchemaPathError] anchored at the slot both satisfies the
/// path-qualified diagnostics contract and lets the root union collapse to this
/// single error. The code stays [MixProtocolErrorCode.unsupportedEncodeValue].
SchemaPathError _unsupportedNestedStyler(
  String relativePath,
  Object? value,
  String reason,
) {
  return SchemaPathError(
    code: MixProtocolErrorCode.unsupportedEncodeValue,
    relativePath: '/$relativePath',
    reason: reason,
    value: value,
  );
}

/// Collapses every compatible nested [Styler] source on [prop] into a single
/// styler using Mix merge semantics, preserving source order.
///
/// Fluent chaining (`FlexBoxStyler().color(...).padding(...)`) accumulates
/// one nested [MixSource] per authoring call, so a normally-composed composite
/// slot can carry several `BoxStyler`/`FlexStyler`/`StackStyler` sources.
/// Merging here is what lets the per-field encoders emit the ordinary v1
/// property grammar (including ordered `$merge` terms when two sources touch the
/// same field) instead of rejecting representable styles. See issue #980.
///
/// Fails atomically — no partial output — for unsupported source kinds
/// (tokens/raw values) or outer directives, each surfaced as a path-qualified
/// diagnostic anchored at the composite slot (see [_unsupportedNestedStyler]).
///
/// Schema fields share this preparation within one encoding operation.
/// The operation releases the prepared values when encoding finishes.
Styler? mergeNestedStyler<
  Styler extends Style<SpecType>,
  SpecType extends Spec<SpecType>
>(Prop<StyleSpec<SpecType>>? prop, String fieldName) {
  if (prop == null) return null;
  if (prop.$directives?.isNotEmpty == true) {
    throw _unsupportedNestedStyler(
      fieldName,
      prop,
      'Field "$fieldName" has directives and cannot be represented.',
    );
  }
  if (prop.sources.isEmpty) {
    throw _unsupportedNestedStyler(
      fieldName,
      prop,
      'Field "$fieldName" has no value sources.',
    );
  }

  Styler? merged;
  for (final source in prop.sources) {
    final styler = _nestedStylerSource<Styler, SpecType>(source, fieldName);
    merged = merged == null ? styler : merged.merge(styler) as Styler;
  }

  return merged;
}

Styler _nestedStylerSource<
  Styler extends Style<SpecType>,
  SpecType extends Spec<SpecType>
>(PropSource<StyleSpec<SpecType>> source, String fieldName) {
  if (source is MixSource<StyleSpec<SpecType>> && source.mix is Styler) {
    return source.mix as Styler;
  }
  if (source is ValueSource<StyleSpec<SpecType>> && source.value is Styler) {
    return source.value as Styler;
  }

  throw _unsupportedNestedStyler(
    fieldName,
    source,
    'Field "$fieldName" is ${source.runtimeType}; expected $Styler.',
  );
}
