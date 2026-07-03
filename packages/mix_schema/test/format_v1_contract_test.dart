import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  MixSchemaContract contract() => MixSchemaContractBuilder().builtIn().freeze();

  JsonMap encode(Object value) {
    return switch (contract().encode(value)) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => throw TestFailure('$errors'),
    };
  }

  MixSchemaDecodeSuccess<T> decodeSuccess<T extends Object>(
    JsonMap payload, {
    MixSchemaDecodeOptions options = const MixSchemaDecodeOptions(),
  }) {
    final result = contract().decode<T>(payload, options: options);

    return switch (result) {
      MixSchemaDecodeSuccess<T>() => result,
      MixSchemaDecodeFailure<T>(:final errors) => throw TestFailure('$errors'),
    };
  }

  List<MixSchemaError> decodeErrors<T extends Object>(
    JsonMap payload, {
    MixSchemaDecodeOptions options = const MixSchemaDecodeOptions(),
  }) {
    final result = contract().decode<T>(payload, options: options);

    return switch (result) {
      MixSchemaDecodeFailure<T>(:final errors) => errors,
      MixSchemaDecodeSuccess<T>() => throw TestFailure('expected failure'),
    };
  }

  group('format version envelope', () {
    test('accepts canonical v1 documents without warnings', () {
      final success = decodeSuccess<BoxStyler>({'v': 1, 'type': 'box'});

      expect(success.value, isA<BoxStyler>());
      expect(success.warnings, isEmpty);
    });

    test('treats a missing version as v1 during the transition window', () {
      final success = decodeSuccess<BoxStyler>({'type': 'box'});

      expect(success.value, isA<BoxStyler>());
      expect(success.warnings, hasLength(1));
      expect(success.warnings.single.code, MixSchemaErrorCode.requiredField);
      expect(success.warnings.single.path, '/v');
      expect(
        success.warnings.single.severity,
        MixSchemaDiagnosticSeverity.warning,
      );
    });

    test(
      'rejects unsupported and malformed versions with a dedicated code',
      () {
        for (final payload in [
          {'v': null, 'type': 'box'},
          {'v': 1.0, 'type': 'box'},
          {'v': true, 'type': 'box'},
          {'v': 2, 'type': 'box'},
          {'v': '1', 'type': 'box'},
          {'v': 0, 'type': 'box'},
        ]) {
          final errors = decodeErrors<BoxStyler>(payload);

          expect(errors, hasLength(1), reason: '$payload');
          expect(errors.single.code, MixSchemaErrorCode.unsupportedVersion);
          expect(errors.single.path, '/v');
        }
      },
    );

    test('encodes top-level style documents with v1', () {
      expect(encode(BoxStyler()), {'v': 1, 'type': 'box'});
    });
  });

  group('null policy and infinity sentinel', () {
    test('forbids explicit null at any payload position', () {
      for (final entry in <({JsonMap payload, String path})>[
        (payload: {'v': 1, 'type': 'box', 'padding': null}, path: '/padding'),
        (
          payload: {
            'v': 1,
            'type': 'box',
            'decoration': {'color': null},
          },
          path: '/decoration/color',
        ),
        (
          payload: {
            'v': 1,
            'type': 'box',
            'variants': [
              {
                'kind': 'named',
                'name': 'compact',
                'style': {'type': 'box', 'padding': null},
              },
            ],
          },
          path: '/variants/0/style/padding',
        ),
      ]) {
        final errors = decodeErrors<BoxStyler>(entry.payload);

        expect(errors, hasLength(1), reason: entry.path);
        expect(errors.single.code, MixSchemaErrorCode.nullForbidden);
        expect(errors.single.path, entry.path);
      }
    });

    test('round-trips unbounded max constraints through infinity sentinel', () {
      final encoded = encode(
        BoxStyler(
          constraints: BoxConstraintsMix(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
          ),
        ),
      );

      expect(encoded['constraints'], {
        'maxWidth': 'infinity',
        'maxHeight': 'infinity',
      });

      final decoded = decodeSuccess<BoxStyler>({
        'v': 1,
        'type': 'box',
        'constraints': {'maxWidth': 'infinity', 'maxHeight': 'infinity'},
      }).value;

      expect(encode(decoded)['constraints'], encoded['constraints']);
    });
  });

  group('strict and lenient decode modes', () {
    const lenient = MixSchemaDecodeOptions(mode: MixSchemaDecodeMode.lenient);

    test('lenient mode skips unknown top-level styler fields', () {
      final payload = {'v': 1, 'type': 'box', 'padding': 8, 'future': true};

      expect(
        decodeErrors<BoxStyler>(payload).single.code,
        MixSchemaErrorCode.unknownField,
      );

      final success = decodeSuccess<BoxStyler>(payload, options: lenient);
      final reencoded = encode(success.value);

      expect(success.warnings.single.path, '/future');
      expect(reencoded.containsKey('future'), isFalse);
      expect(reencoded['padding'], 8.0);
    });

    test('lenient mode skips an unknown nested key in a composite field', () {
      final payload = {
        'v': 1,
        'type': 'box',
        'padding': 4,
        'decoration': {'color': '#000000', 'future': true},
      };

      expect(
        decodeErrors<BoxStyler>(payload).single.code,
        MixSchemaErrorCode.unknownField,
      );

      final success = decodeSuccess<BoxStyler>(payload, options: lenient);
      final reencoded = encode(success.value);

      expect(success.warnings.single.path, '/decoration/future');
      expect(reencoded['decoration'], {'color': '#000000'});
      expect(reencoded['padding'], 4.0);
    });

    test('lenient mode skips unknown variant entries', () {
      final payload = {
        'v': 1,
        'type': 'box',
        'variants': [
          {
            'kind': 'future',
            'style': {'type': 'box', 'padding': 4},
          },
          {
            'kind': 'named',
            'name': 'ok',
            'style': {'type': 'box', 'margin': 2},
          },
        ],
      };

      expect(
        decodeErrors<BoxStyler>(payload).single.code,
        MixSchemaErrorCode.invalidEnum,
      );

      final success = decodeSuccess<BoxStyler>(payload, options: lenient);
      final reencoded = encode(success.value);
      final variants = reencoded['variants']! as List;

      expect(success.warnings.single.path, '/variants/0/kind');
      expect(variants, hasLength(1));
      expect((variants.single! as JsonMap)['kind'], 'named');
    });

    test('lenient mode reparses after each skipped list entry', () {
      final payload = {
        'v': 1,
        'type': 'box',
        'variants': [
          {
            'kind': 'future_one',
            'style': {'type': 'box', 'padding': 4},
          },
          {
            'kind': 'future_two',
            'style': {'type': 'box', 'margin': 2},
          },
          {
            'kind': 'named',
            'name': 'ok',
            'style': {'type': 'box', 'margin': 2},
          },
        ],
      };

      final success = decodeSuccess<BoxStyler>(payload, options: lenient);
      final reencoded = encode(success.value);
      final variants = reencoded['variants']! as List;

      expect(success.warnings, hasLength(2));
      expect(success.warnings.map((warning) => warning.path), [
        '/variants/0/kind',
        '/variants/1/kind',
      ]);
      expect(variants, hasLength(1));
      expect((variants.single! as JsonMap)['kind'], 'named');
    });

    test('lenient mode skips unknown enum-valued styler fields', () {
      final payload = {
        'v': 1,
        'type': 'box',
        'clipBehavior': 'future',
        'padding': 2,
      };

      expect(
        decodeErrors<BoxStyler>(payload).single.code,
        MixSchemaErrorCode.invalidEnum,
      );

      final success = decodeSuccess<BoxStyler>(payload, options: lenient);
      final reencoded = encode(success.value);

      expect(success.warnings.single.path, '/clipBehavior');
      expect(reencoded.containsKey('clipBehavior'), isFalse);
      expect(reencoded['padding'], 2.0);
    });

    test('lenient mode skips unknown directive ops', () {
      final payload = {
        'v': 1,
        'type': 'box',
        'padding': 2,
        'decoration': {
          'color': {
            r'$token': 'color.brand',
            'apply': [
              {'op': 'future_directive'},
            ],
          },
        },
      };

      final strictErrors = decodeErrors<BoxStyler>(payload);

      expect(strictErrors.single.code, MixSchemaErrorCode.invalidEnum);
      expect(strictErrors.single.path, '/decoration/color/apply/0/op');

      final success = decodeSuccess<BoxStyler>(payload, options: lenient);
      final reencoded = encode(success.value);

      expect(success.warnings.single.path, '/decoration/color/apply/0/op');
      expect(reencoded['decoration'], {
        'color': {r'$token': 'color.brand'},
      });
      expect(reencoded['padding'], 2.0);
    });

    test('lenient mode skips invalid merge source entries', () {
      final payload = {
        'v': 1,
        'type': 'box',
        'padding': 2,
        'clipBehavior': {
          r'$merge': ['hardEdge', 'future_clip', 'none'],
        },
      };

      final strictErrors = decodeErrors<BoxStyler>(payload);

      expect(strictErrors.single.code, MixSchemaErrorCode.invalidEnum);
      expect(strictErrors.single.path, r'/clipBehavior/$merge/1');

      final success = decodeSuccess<BoxStyler>(payload, options: lenient);
      final reencoded = encode(success.value);

      expect(success.warnings.single.path, r'/clipBehavior/$merge/1');
      expect(reencoded['clipBehavior'], {
        r'$merge': ['hardEdge', 'none'],
      });
      expect(reencoded['padding'], 2.0);
    });

    test('lenient mode skips unknown modifier entries', () {
      final payload = {
        'v': 1,
        'type': 'box',
        'modifiers': [
          {'type': 'future', 'value': 1},
          {'type': 'opacity', 'opacity': 0.5},
        ],
      };

      expect(
        decodeErrors<BoxStyler>(payload).map((error) => error.code),
        contains(MixSchemaErrorCode.unknownType),
      );

      final success = decodeSuccess<BoxStyler>(payload, options: lenient);
      final reencoded = encode(success.value);
      final modifiers = reencoded['modifiers']! as List;

      expect(success.warnings.single.path, '/modifiers/0/type');
      expect(modifiers, hasLength(1));
      expect((modifiers.single! as JsonMap)['type'], 'opacity');
    });

    test('lenient mode skips ordered modifier items', () {
      final payload = {
        'v': 1,
        'type': 'box',
        'modifiers': {
          'order': ['opacity'],
          'items': [
            {'type': 'future', 'value': 1},
            {'type': 'opacity', 'opacity': 0.5},
          ],
        },
      };

      expect(
        decodeErrors<BoxStyler>(payload).map((error) => error.code),
        contains(MixSchemaErrorCode.unknownType),
      );

      final success = decodeSuccess<BoxStyler>(payload, options: lenient);
      final reencoded = encode(success.value);
      final modifiers = reencoded['modifiers']! as JsonMap;
      final items = modifiers['items']! as List;

      expect(success.warnings.single.path, '/modifiers/items/0/type');
      expect(modifiers['order'], ['opacity']);
      expect(items, hasLength(1));
      expect((items.single! as JsonMap)['type'], 'opacity');
    });

    test('lenient mode skips unknown modifier order entries', () {
      final payload = {
        'v': 1,
        'type': 'box',
        'modifiers': {
          'order': ['future', 'opacity'],
          'items': [
            {'type': 'opacity', 'opacity': 0.5},
          ],
        },
      };

      final strictErrors = decodeErrors<BoxStyler>(payload);

      expect(
        strictErrors,
        contains(
          isA<MixSchemaError>()
              .having(
                (error) => error.code,
                'code',
                MixSchemaErrorCode.invalidEnum,
              )
              .having((error) => error.path, 'path', '/modifiers/order/0'),
        ),
      );

      final success = decodeSuccess<BoxStyler>(payload, options: lenient);
      final reencoded = encode(success.value);
      final modifiers = reencoded['modifiers']! as JsonMap;
      final items = modifiers['items']! as List;

      expect(
        success.warnings.map((warning) => warning.path),
        contains('/modifiers/order/0'),
      );
      expect(modifiers['order'], ['opacity']);
      expect(items, hasLength(1));
      expect((items.single! as JsonMap)['type'], 'opacity');
    });

    test('lenient mode skips ordinary list entries inside styler fields', () {
      final payload = {
        'v': 1,
        'type': 'text',
        'style': {
          'debugLabel': 'body',
          'fontFeatures': [
            {'feature': 'kern', 'value': 1, 'future': true},
            {'feature': 'liga', 'value': 1},
          ],
        },
      };

      expect(
        decodeErrors<TextStyler>(payload).map((error) => error.code),
        contains(MixSchemaErrorCode.unknownField),
      );

      final success = decodeSuccess<TextStyler>(payload, options: lenient);
      final reencoded = encode(success.value);
      final style = reencoded['style']! as JsonMap;

      expect(success.warnings.single.path, '/style/fontFeatures/0/future');
      expect(style['debugLabel'], 'body');
      expect(style['fontFeatures'], [
        {'feature': 'liga', 'value': 1},
      ]);
    });

    test('lenient mode skips shadow list entries inside styler fields', () {
      final payload = {
        'v': 1,
        'type': 'icon',
        'shadows': [
          {
            'color': '#000000',
            'offset': {'x': 1.0, 'y': 2.0},
            'future': true,
          },
          {
            'color': '#111111',
            'offset': {'x': 3.0, 'y': 4.0},
            'blurRadius': 5.0,
          },
        ],
      };

      expect(
        decodeErrors<IconStyler>(payload).map((error) => error.code),
        contains(MixSchemaErrorCode.unknownField),
      );

      final success = decodeSuccess<IconStyler>(payload, options: lenient);
      final reencoded = encode(success.value);

      expect(success.warnings.single.path, '/shadows/0/future');
      expect(reencoded['shadows'], [
        {
          'color': '#111111',
          'offset': {'x': 3.0, 'y': 4.0},
          'blurRadius': 5.0,
        },
      ]);
    });

    test('lenient mode keeps structural root failures fatal', () {
      final errors = decodeErrors<BoxStyler>({
        'v': 1,
        'type': 'future',
      }, options: lenient);

      expect(errors.single.code, MixSchemaErrorCode.unknownType);
      expect(errors.single.path, '/type');
    });

    test('lenient mode caps skipped payload removals', () {
      final result = contract().decode<BoxStyler>({
        'v': 1,
        'type': 'box',
        'variants': [
          for (var i = 0; i < 257; i += 1)
            {
              'kind': 'future_$i',
              'style': {'type': 'box'},
            },
        ],
      }, options: lenient);

      final failure = switch (result) {
        MixSchemaDecodeFailure<BoxStyler>() => result,
        MixSchemaDecodeSuccess<BoxStyler>() => fail('expected failure'),
      };

      expect(failure.errors.single.code, MixSchemaErrorCode.limitExceeded);
      expect(failure.warnings, hasLength(256));
      expect(failure.warnings.last.path, '/variants/255/kind');
    });

    test('lenient warning paths preserve numeric object keys', () {
      final payload = {
        'v': 1,
        'type': 'box',
        'variants': [
          {
            'kind': 'named',
            'name': 'ok',
            'style': {'type': 'box', 'padding': 2, '0': true, '1': true},
          },
        ],
      };

      final success = decodeSuccess<BoxStyler>(payload, options: lenient);
      final reencoded = encode(success.value);
      final variants = reencoded['variants']! as List;
      final style = (variants.single! as JsonMap)['style']! as JsonMap;

      expect(success.warnings.map((warning) => warning.path), [
        '/variants/0/style/0',
        '/variants/0/style/1',
      ]);
      expect(style['padding'], 2.0);
    });
  });

  group('resource limits', () {
    test('accepts depth 64 but rejects depth 65 during preflight', () {
      JsonMap deepPayload(int depth) {
        Object value = 'leaf';
        for (var i = depth - 1; i >= 1; i -= 1) {
          value = {'level_$i': value};
        }

        return {'v': 1, 'type': 'box', 'future': value};
      }

      final depth64Errors = decodeErrors<BoxStyler>(deepPayload(63));
      expect(depth64Errors.single.code, MixSchemaErrorCode.unknownField);

      final depth65Errors = decodeErrors<BoxStyler>(deepPayload(64));
      expect(depth65Errors.single.code, MixSchemaErrorCode.limitExceeded);
    });

    test('accepts 10000 nodes but rejects 10001 during preflight', () {
      JsonMap widePayload(int itemCount) {
        return {
          'v': 1,
          'type': 'box',
          'future': List<int>.generate(itemCount, (index) => index),
        };
      }

      final node10000Errors = decodeErrors<BoxStyler>(widePayload(9996));
      expect(node10000Errors.single.code, MixSchemaErrorCode.unknownField);

      final node10001Errors = decodeErrors<BoxStyler>(widePayload(9997));
      expect(node10001Errors.single.code, MixSchemaErrorCode.limitExceeded);
    });

    test('rejects deep nested variants before Ack traversal', () {
      var style = <String, Object?>{'type': 'box'};
      for (var i = 0; i < 70; i += 1) {
        style = <String, Object?>{
          'type': 'box',
          'variants': [
            {'kind': 'named', 'name': 'v$i', 'style': style},
          ],
        };
      }

      final errors = decodeErrors<BoxStyler>({'v': 1, ...style});

      expect(errors.single.code, MixSchemaErrorCode.limitExceeded);
      expect(errors.single.path, isNotEmpty);
    });

    test('rejects wide modifier arrays before Ack traversal', () {
      final payload = {
        'v': 1,
        'type': 'box',
        'modifiers': List.generate(
          10001,
          (_) => {'type': 'opacity', 'opacity': 0.5},
        ),
      };

      final errors = decodeErrors<BoxStyler>(payload);

      expect(errors.single.code, MixSchemaErrorCode.limitExceeded);
      expect(errors.single.path, startsWith('/modifiers/'));
    });
  });

  group('validation diagnostics', () {
    test('validate carries transition warnings on failures like decode', () {
      final payload = {'type': 'box', 'future': true};
      final decode = contract().decode<BoxStyler>(payload);
      final validation = contract().validate(payload);

      final decodeFailure = switch (decode) {
        MixSchemaDecodeFailure<BoxStyler>() => decode,
        MixSchemaDecodeSuccess<BoxStyler>() => fail('expected decode failure'),
      };
      final validationFailure = switch (validation) {
        MixSchemaValidationFailure() => validation,
        MixSchemaValidationSuccess() => fail('expected validation failure'),
      };

      expect(decodeFailure.warnings.map((warning) => warning.toJson()), [
        for (final warning in validationFailure.warnings) warning.toJson(),
      ]);
      expect(
        validationFailure.errors.single.code,
        MixSchemaErrorCode.unknownField,
      );
    });
  });
}
