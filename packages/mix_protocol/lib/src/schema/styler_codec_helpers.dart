import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../errors/mix_protocol_error.dart';
import 'animation_codec.dart';
import 'modifier_codec.dart';
import 'schema_field.dart';
import 'variant_codec.dart';

const stylerMetadataFields = {'variants', 'modifiers', 'animation'};

final class StylerMetadataFields<
  Owner extends Object,
  SpecType extends Spec<SpecType>
> {
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
             ),
       modifiers = directField<Owner, WidgetModifierConfig>(
         'modifiers',
         modifierConfigCodec(rootStyleSchema: rootStyleSchema),
         readModifier,
         inventoryName: 'modifier',
       ),
       animation = directField<Owner, AnimationConfig>(
         'animation',
         animationConfigCodec(),
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
  final styler = mergeNestedStyler<Styler, SpecType>(read(value), fieldName);
  if (styler != null) {
    _failNestedMetadata(fieldName, 'variants', styler.$variants);
    _failNestedMetadata(fieldName, 'modifiers', styler.$modifier);
    _failNestedMetadata(fieldName, 'animation', styler.$animation);
  }

  return styler == null
      ? null
      : encodeFields(styler, includeStylerMetadata: false)[wire];
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
/// Fluent chaining (`FlexBoxStyler().color(...).paddingAll(...)`) accumulates
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
/// Invoked once per wire field of the composite slot (the [encodedNestedStylerField]
/// `read` callback fires per key), so the merge is intentionally re-derived each
/// time rather than memoized — it is pure and bounded by small field/source
/// counts, and the nested [encodeFields] it feeds was already recomputed per
/// field before this change.
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
