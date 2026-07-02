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
          {'v': 2, 'type': 'box'},
          {'v': '1', 'type': 'box'},
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

    test('lenient mode skips a composite field with an unknown nested key', () {
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
      expect(reencoded.containsKey('decoration'), isFalse);
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
      expect(
        success.warnings.map((warning) => warning.path),
        everyElement(endsWith('/kind')),
      );
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
        decodeErrors<BoxStyler>(payload).single.code,
        MixSchemaErrorCode.unknownType,
      );

      final success = decodeSuccess<BoxStyler>(payload, options: lenient);
      final reencoded = encode(success.value);
      final modifiers = reencoded['modifiers']! as List;

      expect(success.warnings.single.path, '/modifiers/0/type');
      expect(modifiers, hasLength(1));
      expect((modifiers.single! as JsonMap)['type'], 'opacity');
    });

    test('lenient mode keeps structural root failures fatal', () {
      final errors = decodeErrors<BoxStyler>({
        'v': 1,
        'type': 'future',
      }, options: lenient);

      expect(errors.single.code, MixSchemaErrorCode.unknownType);
      expect(errors.single.path, '/type');
    });
  });

  group('resource limits', () {
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
}
