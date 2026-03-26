import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/schema_wire_types.dart';
import '../../errors/mix_schema_error.dart';
import '../../errors/schema_error_mapper.dart';
import '../../errors/schema_transform_exceptions.dart';
import '../discriminated_branch_registry.dart';
import 'context_variant_leaf_schema.dart';

VariantConditionParser buildVariantConditionParser() {
  final registry = DiscriminatedBranchRegistry<ContextVariantLeaf>(
    discriminatorKey: 'type',
  );

  for (final type in sharedContextVariantLeafTypes) {
    registry.register(
      type.wireValue,
      buildContextVariantLeafSchema(type: type),
    );
  }

  final compoundShapeSchema = Ack.object({
    'type': Ack.literal(SchemaVariant.contextAllOf.wireValue),
    'conditions': Ack.list(Ack.any()).refine(
      (conditions) => conditions.length >= 2,
      message: 'context_all_of requires at least two conditions.',
    ),
  }).transform<Map<String, Object?>>((data) => data);

  return VariantConditionParser._(
    leafSchema: registry.freeze(),
    compoundShapeSchema: compoundShapeSchema,
  );
}

final class VariantConditionParser {
  final AckSchema<ContextVariantLeaf> _leafSchema;
  final AckSchema<Map<String, Object?>> _compoundShapeSchema;
  final SchemaErrorMapper _errorMapper = const SchemaErrorMapper();

  VariantConditionParser._({
    required AckSchema<ContextVariantLeaf> leafSchema,
    required AckSchema<Map<String, Object?>> compoundShapeSchema,
  }) : _leafSchema = leafSchema,
       _compoundShapeSchema = compoundShapeSchema;

  List<ContextConditionSet> parseList(
    List<Object?> values, {
    String path = '#/conditions',
  }) {
    final errors = <MixSchemaError>[];
    final conditions = <ContextConditionSet>[];

    for (var index = 0; index < values.length; index++) {
      final condition = _parseValue(
        values[index],
        path: '$path/$index',
        errors: errors,
      );

      if (condition != null) {
        conditions.add(condition);
      }
    }

    if (errors.isNotEmpty) {
      throw NestedSchemaErrorsException(
        List<MixSchemaError>.unmodifiable(errors),
      );
    }

    return List<ContextConditionSet>.unmodifiable(conditions);
  }

  ContextConditionSet? _parseValue(
    Object? value, {
    required String path,
    required List<MixSchemaError> errors,
  }) {
    if (value is Map<String, Object?> &&
        value['type'] == SchemaVariant.contextAllOf.wireValue) {
      final shapeResult = _compoundShapeSchema.safeParse(value);
      if (shapeResult case Fail(error: final error)) {
        errors.addAll(_prefixErrors(error, path));
        return null;
      }

      final map = shapeResult.getOrThrow()!;
      final rawConditions = map['conditions'] as List<Object?>;
      final beforeChildErrors = errors.length;
      final conditions = <ContextConditionSet>[];

      for (var index = 0; index < rawConditions.length; index++) {
        final condition = _parseValue(
          rawConditions[index],
          path: '$path/conditions/$index',
          errors: errors,
        );

        if (condition != null) {
          conditions.add(condition);
        }
      }

      if (errors.length != beforeChildErrors) {
        return null;
      }

      return ContextConditionSet.compound(conditions);
    }

    final leafResult = _leafSchema.safeParse(value);
    if (leafResult case Fail(error: final error)) {
      errors.addAll(_prefixErrors(error, path));
      return null;
    }

    return ContextConditionSet.leaf(leafResult.getOrThrow()!);
  }

  List<MixSchemaError> _prefixErrors(SchemaError error, String prefix) {
    return _errorMapper
        .map(error)
        .map((mappedError) {
          return MixSchemaError(
            code: mappedError.code,
            path: _prefixPath(prefix, mappedError.path),
            message: mappedError.message,
            value: mappedError.value,
          );
        })
        .toList(growable: false);
  }

  String _prefixPath(String prefix, String nestedPath) {
    if (nestedPath == '#') {
      return prefix;
    }

    if (prefix == '#') {
      return nestedPath;
    }

    return '$prefix${nestedPath.substring(1)}';
  }
}

final class ContextConditionSet {
  final List<ContextVariantLeaf> leaves;

  const ContextConditionSet._(this.leaves);

  factory ContextConditionSet.leaf(ContextVariantLeaf leaf) {
    return ContextConditionSet._(List<ContextVariantLeaf>.unmodifiable([leaf]));
  }

  factory ContextConditionSet.compound(
    Iterable<ContextConditionSet> conditions,
  ) {
    final leaves = <ContextVariantLeaf>[];

    for (final condition in conditions) {
      leaves.addAll(condition.leaves);
    }

    return ContextConditionSet._(_normalizeConditionLeaves(leaves));
  }

  ContextVariant toVariant() {
    if (leaves.length == 1) {
      return leaves.single.variant;
    }

    return _CompoundContextVariant(leaves);
  }
}

List<ContextVariantLeaf> _normalizeConditionLeaves(
  Iterable<ContextVariantLeaf> leaves,
) {
  final normalized = List<ContextVariantLeaf>.of(leaves);
  normalized.sort((left, right) {
    return left.canonicalKey.compareTo(right.canonicalKey);
  });

  return List<ContextVariantLeaf>.unmodifiable(normalized);
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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _CompoundContextVariant && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;

  static String _compoundKey(List<ContextVariantLeaf> leaves) {
    final keys = leaves.map((leaf) => leaf.canonicalKey).join('|');
    return '${SchemaVariant.contextAllOf.wireValue}:$keys';
  }
}
