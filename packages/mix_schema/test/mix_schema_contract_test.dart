import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('MixSchemaContract', () {
    test('builder can extend the built-in styler set before freeze', () {
      final builder = MixSchemaContractBuilder.builtIn()
        ..register(
          'demo',
          Ack.codec<JsonMap, JsonMap, Object>(
            input: Ack.object({'value': Ack.integer()}),
            output: Ack.instance<Object>(),
            decode: (data) => data['value']! as int,
            encode: (value) => {'type': 'demo', 'value': value as int},
          ),
        );

      expect(builder.registeredTypes, containsAll(const ['box', 'demo']));

      final contract = builder.freeze();
      final result = contract.decode({'type': 'demo', 'value': 42});
      final schema = contract.exportJsonSchema();
      final demoProperties = _branchProperties(schema, 'demo');

      expect(result.ok, isTrue);
      expect(result.value, 42);
      expect(_branchTypes(schema), contains('demo'));
      expect(demoProperties, contains('value'));
    });

    test('encodes custom object-backed codec branches', () {
      final contract =
          (MixSchemaContractBuilder()..register(
                'demo',
                Ack.codec<JsonMap, JsonMap, Object>(
                  input: Ack.object({'value': Ack.integer()}),
                  output: Ack.instance<Object>(),
                  decode: (data) => data['value']! as int,
                  encode: (value) => {'type': 'demo', 'value': value as int},
                ),
              ))
              .freeze();

      final result = contract.encode(42);

      expect(result.ok, isTrue);
      expect(result.value, {'type': 'demo', 'value': 42});
      expect(result.errors, isEmpty);
    });

    test('exports supported built-in styler types through JSON Schema', () {
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

    test('exposes the frozen root Ack schema', () {
      final contract = MixSchemaContract.builtIn();

      expect(contract.rootSchema, isA<AckSchema<JsonMap, Object>>());

      final result = contract.rootSchema.safeParse({'type': 'box'});
      expect(result.isOk, isTrue);
    });

    test('exports the root Ack JSON Schema artifact', () {
      final contract = MixSchemaContract.builtIn();

      final schema = contract.exportJsonSchema();
      final branches = schema['anyOf'] as List<Object?>;
      final boxBranch = branches.cast<Map>().singleWhere((branch) {
        final properties = branch['properties'] as Map;
        final type = properties['type'] as Map;

        return type['const'] == 'box';
      });
      final properties = boxBranch['properties'] as Map;

      expect(
        properties,
        containsPair('type', {'type': 'string', 'const': 'box'}),
      );
      expect(properties, contains('alignment'));
      expect(properties, contains('padding'));
      expect(properties, contains('animation'));
      expect(properties, contains('variants'));
      expect(boxBranch['x-ack-codec'], isTrue);
    });

    test('encodes BoxStyler payloads through the contract', () {
      final contract = MixSchemaContract.builtIn();
      final style = BoxStyler(
        alignment: Alignment.center,
        padding: EdgeInsetsMix(top: 8, left: 12),
        clipBehavior: Clip.antiAlias,
      );

      final result = contract.encode(style);

      expect(result.ok, isTrue);
      expect(result.value, {
        'type': 'box',
        'alignment': {'x': 0.0, 'y': 0.0},
        'padding': {'top': 8.0, 'left': 12.0},
        'clipBehavior': 'antiAlias',
      });
    });

    test('root schema encodes BoxStyler payloads directly', () {
      final contract = MixSchemaContract.builtIn();
      final style = BoxStyler(alignment: Alignment.centerRight);

      final result = contract.rootSchema.safeEncode(style);

      expect(result.isOk, isTrue);
      expect(result.getOrNull(), {
        'type': 'box',
        'alignment': {'x': 1.0, 'y': 0.0},
      });
    });

    test('reports encode errors for unsupported multi-source props', () {
      final contract = MixSchemaContract.builtIn();
      final style = BoxStyler(
        alignment: Alignment.center,
      ).merge(BoxStyler(alignment: Alignment.topLeft));

      final result = contract.encode(style);

      expect(result.ok, isFalse);
      expect(result.value, isNull);
      expect(
        result.errors.map((error) => error.message).join('\n'),
        contains('Only single-source'),
      );
    });

    test('validates valid payloads without errors', () {
      final contract = MixSchemaContract.builtIn();

      final result = contract.validate({'type': 'box'});

      expect(result.ok, isTrue);
      expect(result.errors, isEmpty);
    });

    test('returns mapped validation errors for invalid payloads', () {
      final contract = MixSchemaContract.builtIn();

      final result = contract.validate({'type': 'missing'});

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.unknownType);
      expect(result.errors.single.path, '#/type');
    });

    test('aggregates mixed invalid compound condition errors', () {
      final contract = MixSchemaContract.builtIn();

      final result = contract.validate({
        'type': 'box',
        'variants': [
          {
            'type': 'context_all_of',
            'conditions': [
              {'type': 'named', 'name': 'primary'},
              {'type': 'context_brightness', 'brightness': 'missing'},
              {'type': 'context_variant_builder', 'id': 'builder'},
            ],
            'style': {
              'constraints': {'minWidth': 200.0, 'maxWidth': 200.0},
            },
          },
        ],
      });

      expect(result.ok, isFalse);
      expect(
        result.errors.map((error) => (error.code, error.path)).toList(),
        containsAll(<(MixSchemaErrorCode, String)>[
          (MixSchemaErrorCode.unknownType, '#/variants/0/conditions/0/type'),
          (
            MixSchemaErrorCode.invalidEnum,
            '#/variants/0/conditions/1/brightness',
          ),
          (MixSchemaErrorCode.unknownType, '#/variants/0/conditions/2/type'),
        ]),
      );
    });

    test(
      'preserves nested error paths for invalid compound condition fields',
      () {
        final contract = MixSchemaContract.builtIn();

        final result = contract.validate({
          'type': 'box',
          'variants': [
            {
              'type': 'context_all_of',
              'conditions': [
                {'type': 'context_brightness', 'brightness': 'missing'},
                {'type': 'widget_state', 'state': 'hovered'},
              ],
              'style': {
                'constraints': {'minWidth': 200.0, 'maxWidth': 200.0},
              },
            },
          ],
        });

        expect(result.ok, isFalse);
        expect(result.errors.single.code, MixSchemaErrorCode.invalidEnum);
        expect(
          result.errors.single.path,
          '#/variants/0/conditions/0/brightness',
        );
      },
    );

    test('validates compound variants require at least two conditions', () {
      final contract = MixSchemaContract.builtIn();

      final result = contract.validate({
        'type': 'box',
        'variants': [
          {
            'type': 'context_all_of',
            'conditions': [
              {'type': 'widget_state', 'state': 'hovered'},
            ],
            'style': {
              'constraints': {'minWidth': 200.0, 'maxWidth': 200.0},
            },
          },
        ],
      });

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.validationFailed);
      expect(result.errors.single.path, '#/variants/0/conditions');
    });

    test('exports producer contract details through JSON Schema', () {
      final contract = MixSchemaContract.builtIn();
      final schema = contract.exportJsonSchema();
      final boxProperties = _branchProperties(schema, 'box');
      final textProperties = _branchProperties(schema, 'text');
      final iconProperties = _branchProperties(schema, 'icon');

      expect(boxProperties, contains('type'));
      expect(boxProperties, contains('alignment'));
      expect(boxProperties, contains('padding'));
      expect(boxProperties, contains('animation'));
      expect(boxProperties, contains('variants'));
      expect(textProperties, contains('style'));
      expect(textProperties, contains('textAlign'));
      expect(iconProperties, contains('icon'));
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
