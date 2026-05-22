import 'package:ack/ack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('schema export fidelity', () {
    final contract = MixSchemaContract.builtIn();
    final schema = contract.exportJsonSchema();

    test('only shared context leaf types appear under context_all_of', () {
      final variantsSchema = _firstVariantsItemSchema(schema, branch: 'box');
      final compoundBranch = _branchByType(
        variantsSchema['anyOf'] as List<Object?>,
        'context_all_of',
      );

      final conditionTypes = _discriminatedBranchTypes(
        (compoundBranch['properties'] as Map<Object?, Object?>)['conditions']
            as Map<Object?, Object?>,
        key: 'items',
      );

      expect(conditionTypes, [
        'widget_state',
        'enabled',
        'context_brightness',
        'context_breakpoint',
        'context_not_widget_state',
      ]);
      expect(conditionTypes, isNot(contains('named')));
      expect(conditionTypes, isNot(contains('context_variant_builder')));
      expect(conditionTypes, isNot(contains('context_all_of')));
    });

    test('every top-level styler branch carries a discriminator literal', () {
      final branches = schema['anyOf'] as List<Object?>;

      for (final branch in branches.cast<Map<Object?, Object?>>()) {
        final properties = branch['properties'] as Map<Object?, Object?>;
        final typeProperty = properties['type'] as Map<Object?, Object?>;
        expect(typeProperty['const'], isA<String>());
      }
    });

    test('custom styler types must match the wire grammar', () {
      expect(
        () => MixSchemaContractBuilder().register(
          'BadName',
          Ack.codec<JsonMap, JsonMap, Object>(
            input: Ack.object({'value': Ack.integer()}),
            output: Ack.instance<Object>(),
            decode: (data) => data['value']! as int,
            encode: (value) => {'type': 'BadName', 'value': value as int},
          ),
        ),
        throwsArgumentError,
      );
    });

    test('custom registry scopes must match the wire grammar', () {
      expect(
        () => RegistryBuilder<String>(scope: 'BadScope'),
        throwsArgumentError,
      );
    });

    test('custom registry ids must match the wire grammar', () {
      final builder = RegistryBuilder<String>(scope: 'demo');
      expect(
        () => builder.register('bad id', 'value'),
        throwsArgumentError,
      );
    });
  });
}

Map<Object?, Object?> _branchByType(
  List<Object?> branches,
  String type,
) {
  return branches.cast<Map<Object?, Object?>>().firstWhere((branch) {
    final properties = branch['properties'] as Map<Object?, Object?>;
    final typeProperty = properties['type'] as Map<Object?, Object?>;
    return typeProperty['const'] == type;
  });
}

Map<Object?, Object?> _firstVariantsItemSchema(
  Map<String, Object?> schema, {
  required String branch,
}) {
  final branches = schema['anyOf'] as List<Object?>;
  final match = _branchByType(branches, branch);
  final properties = match['properties'] as Map<Object?, Object?>;
  final variants = properties['variants'] as Map<Object?, Object?>;
  return variants['items'] as Map<Object?, Object?>;
}

List<String> _discriminatedBranchTypes(
  Map<Object?, Object?> schema, {
  String? key,
}) {
  final target = key == null
      ? schema
      : schema[key] as Map<Object?, Object?>;
  final branches = target['anyOf'] as List<Object?>;
  return [
    for (final branch in branches.cast<Map<Object?, Object?>>())
      ((branch['properties'] as Map<Object?, Object?>)['type']
              as Map<Object?, Object?>)['const']
          as String,
  ];
}
