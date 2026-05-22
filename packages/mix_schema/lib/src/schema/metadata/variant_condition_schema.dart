import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/schema_wire_types.dart';
import 'context_variant_leaf_schema.dart';
import 'variant_condition_definition.dart';

DiscriminatedObjectSchema<ContextVariantLeaf>
buildContextConditionInputSchema() {
  return Ack.discriminated(
    discriminatorKey: 'type',
    schemas: {
      for (final type in sharedContextVariantLeafTypes)
        type.wireValue: buildContextVariantLeafSchema(type: type),
    },
  );
}

ListSchema<JsonMap, ContextVariantLeaf> buildContextConditionListSchema() {
  return Ack.list(buildContextConditionInputSchema()).refine(
    (conditions) => conditions.length >= 2,
    message: 'context_all_of requires at least two conditions.',
  );
}

final class ContextConditionSet {
  final List<ContextVariantLeaf> leaves;

  const ContextConditionSet._(this.leaves);

  factory ContextConditionSet.leaf(ContextVariantLeaf leaf) {
    return ContextConditionSet._(List.unmodifiable([leaf]));
  }

  /// Builds a compound condition set from a list of pre-validated leaves.
  ///
  /// Leaves come from [buildContextConditionListSchema] (the single Ack-owned
  /// definition for the allowed conditions list), so nested `context_all_of`
  /// rejection happens at schema validation rather than in this constructor.
  factory ContextConditionSet.compound(Iterable<ContextVariantLeaf> leaves) {
    return ContextConditionSet._(_normalizeConditionLeaves(leaves));
  }

  ContextVariant toVariant() {
    if (leaves.length == 1) {
      return leaves.single.variant;
    }

    return _CompoundContextVariant(leaves);
  }
}

ContextConditionSet? contextConditionSetFromVariant(Variant variant) {
  if (variant is _CompoundContextVariant) {
    return ContextConditionSet._(variant.leaves);
  }

  return null;
}

List<ContextVariantLeaf> _normalizeConditionLeaves(
  Iterable<ContextVariantLeaf> leaves,
) {
  final normalized = List.of(leaves);
  normalized.sort((left, right) {
    return left.canonicalKey.compareTo(right.canonicalKey);
  });

  return List.unmodifiable(normalized);
}

final class _CompoundContextVariant extends ContextVariant
    implements VariantPriority {
  final List<ContextVariantLeaf> leaves;

  @override
  final int sortPriority;

  _CompoundContextVariant(this.leaves)
    : sortPriority = leaves.fold<int>(
        0,
        (current, leaf) =>
            current >= leaf.sortPriority ? current : leaf.sortPriority,
      ),
      super(_compoundKey(leaves), (context) {
        return leaves.every((leaf) => leaf.variant.when(context));
      });

  static String _compoundKey(List<ContextVariantLeaf> leaves) {
    final keys = leaves.map((leaf) => leaf.canonicalKey).join('|');

    return '${SchemaVariant.contextAllOf.wireValue}:$keys';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _CompoundContextVariant && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}
