import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('Public API contract', () {
    test('exports the intended core contract types', () {
      final builder = MixSchemaContractBuilder.builtIn();
      final contract = MixSchemaContract.builtIn();
      final frozenRegistry = FrozenRegistry<Object>(scope: 'demo', values: {});
      final validation = MixSchemaValidationResult.success();
      final encode = MixSchemaEncodeResult<JsonMap>.success({'type': 'demo'});

      expect(builder, isA<MixSchemaContractBuilder>());
      expect(contract, isA<MixSchemaContract>());
      expect(frozenRegistry, isA<FrozenRegistry<Object>>());
      expect(validation, isA<MixSchemaValidationResult>());
      expect(encode, isA<MixSchemaEncodeResult<JsonMap>>());
      expect(
        RegistryBuilder<Object>(scope: 'custom'),
        isA<RegistryBuilder<Object>>(),
      );
    });

    test('exposes stable built-in registry scopes', () {
      expect(
        MixSchemaScope.values.map((scope) => scope.wireValue).toList(),
        const [
          'animation_on_end',
          'icon_data',
          'image_provider',
          'context_variant_builder',
        ],
      );
    });

    test('exports stable built-in styler types through the contract', () {
      final contract = MixSchemaContract.builtIn();

      expect(_branchTypes(contract.exportJsonSchema()), const [
        'box',
        'text',
        'flex',
        'icon',
        'image',
        'stack',
        'flex_box',
        'stack_box',
      ]);
    });

    test('exports JSON Schema as the producer and tooling artifact', () {
      final contract = MixSchemaContract.builtIn();
      final schema = contract.exportJsonSchema();
      final boxProperties = _branchProperties(schema, 'box');
      final flexProperties = _branchProperties(schema, 'flex');
      final stackProperties = _branchProperties(schema, 'stack');
      final flexBoxProperties = _branchProperties(schema, 'flex_box');
      final stackBoxProperties = _branchProperties(schema, 'stack_box');
      final iconProperties = _branchProperties(schema, 'icon');

      expect(boxProperties, contains('type'));
      expect(boxProperties, contains('decoration'));
      expect(boxProperties, contains('animation'));
      expect(boxProperties, contains('variants'));
      expect(flexProperties, contains('direction'));
      expect(flexProperties, contains('mainAxisAlignment'));
      expect(stackProperties, contains('fit'));
      expect(flexBoxProperties, contains('flexClipBehavior'));
      expect(stackBoxProperties, contains('stackClipBehavior'));
      expect(iconProperties, contains('icon'));
    });

    test('keeps the stable public error vocabulary', () {
      expect(MixSchemaErrorCode.values.map((code) => code.wireValue).toSet(), {
        'type_mismatch',
        'required_field',
        'unknown_field',
        'invalid_enum',
        'constraint_violation',
        'payload_limit_exceeded',
        'validation_failed',
        'transform_failed',
        'unsupported_encode_value',
        'unknown_type',
        'unknown_registry_id',
        'unknown_registry_value',
      });
    });

    test('keeps wire-type identifiers off the root contract surface', () {
      final source = File('lib/mix_schema.dart').readAsStringSync();

      expect(source, isNot(contains('schema_wire_types.dart')));
    });

    test('keeps wire-type identifiers on the producer surface', () {
      final source = File('lib/encode.dart').readAsStringSync();

      expect(source, isNot(contains('schema_wire_types.dart')));
      expect(source, contains('primitive_payload_helpers.dart'));
    });

    test('keeps styler registry construction off the contract-facing APIs', () {
      final contractSource = File(
        'lib/src/contract/mix_schema_contract.dart',
      ).readAsStringSync();

      expect(
        contractSource,
        isNot(
          contains(
            'MixSchemaContract({required StylerRegistry stylerRegistry})',
          ),
        ),
      );
      expect(contractSource, contains('MixSchemaContractBuilder'));
    });

    test('keeps StylerRegistry off the root contract surface', () {
      final source = File('lib/mix_schema.dart').readAsStringSync();

      expect(source, isNot(contains('styler_registry.dart')));
    });

    test('does not expose the removed metadata contract surface', () {
      final rootExport = File('lib/mix_schema.dart').readAsStringSync();
      final contractSource = File(
        'lib/src/contract/mix_schema_contract.dart',
      ).readAsStringSync();

      expect(rootExport, isNot(contains('mix_schema_export_metadata.dart')));
      expect(contractSource, isNot(contains('exportMetadata')));
    });
  });
}

List<String> _branchTypes(Map<String, Object?> schema) {
  final branches = schema['anyOf'] as List<Object?>;

  return [
    for (final branch in branches)
      (((branch as Map<Object?, Object?>)['properties']!
                  as Map<Object?, Object?>)['type']!
              as Map<Object?, Object?>)['const']!
          as String,
  ];
}

Map<Object?, Object?> _branchProperties(
  Map<String, Object?> schema,
  String type,
) {
  final branches = schema['anyOf'] as List<Object?>;
  final branch = branches.cast<Map<Object?, Object?>>().singleWhere((branch) {
    final properties = branch['properties']! as Map<Object?, Object?>;
    final typeProperty = properties['type']! as Map<Object?, Object?>;

    return typeProperty['const'] == type;
  });

  return branch['properties']! as Map<Object?, Object?>;
}
