import 'package:mix_schema/mix_schema.dart';
import 'package:test/test.dart';

import '../foundations/_helpers.dart';

void main() {
  late Validator validator;

  setUpAll(() {
    final assets = MixSchemaAssets.fromFiles(testAssetsDir);
    validator = Validator(assets);
  });

  group('stage 1 — bounds', () {
    test('depth-32 is rejected with canonical.depth-exceeded', () {
      Object? doc = 'leaf';
      // Wrap in 35 levels of nesting under 'children' arrays + maps.
      for (var i = 0; i < 35; i++) {
        doc = {
          'widget': 'Box',
          'child': doc is String
              ? const {'widget': 'Box'}
              : doc as Map<String, Object?>,
        };
      }
      final result = validator.validate({
        'schema': '1.0.0',
        'root': doc,
      });
      expect(result.isValid, isFalse);
      final errs = result.byCode(ErrorCode.canonicalDepthExceeded).toList();
      expect(errs, isNotEmpty);
    });

    test('arrays > 1024 elements are rejected', () {
      final children = <Object?>[
        for (var i = 0; i < 1100; i++) {'widget': 'Box'}
      ];
      final result = validator.validate({
        'schema': '1.0.0',
        'root': {'widget': 'FlexBox', 'children': children},
      });
      expect(result.isValid, isFalse);
      expect(result.byCode(ErrorCode.canonicalArrayTooLong), isNotEmpty);
    });

    test('directive chain > 16 is rejected', () {
      final directives = [
        for (var i = 0; i < 20; i++) {'op': 'darken', 'amount': 1}
      ];
      final result = validator.validate({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {
              'alignment': {
                'token': 'color.primary',
                'directives': directives,
              },
            },
          },
        },
      });
      expect(result.isValid, isFalse);
      expect(result.byCode(ErrorCode.directiveChainTooLong), isNotEmpty);
    });

    test('token path > 128 chars is rejected', () {
      final longToken = 'color.${'a' * 200}';
      final result = validator.validate({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {
              'alignment': {'token': longToken},
            },
          },
        },
      });
      expect(result.isValid, isFalse);
      expect(result.byCode(ErrorCode.tokenPathTooLong), isNotEmpty);
    });
  });

  group('stage 2 — structural', () {
    test('valid empty Box passes', () {
      final result = validator.validate({
        'schema': '1.0.0',
        'root': {'widget': 'Box'},
      });
      expect(result.isValid, isTrue);
    });

    test('missing schema field rejected', () {
      final result = validator.validate({
        'root': {'widget': 'Box'},
      });
      expect(result.isValid, isFalse);
      expect(result.byCode(ErrorCode.envelopeFieldMissing), isNotEmpty);
    });

    test('Pressable without child rejected (child REQUIRED)', () {
      final result = validator.validate({
        'schema': '1.0.0',
        'root': {'widget': 'Pressable'},
      });
      expect(result.isValid, isFalse);
      expect(result.errors, isNotEmpty);
    });

    test('PressableBox without child accepted (child OPTIONAL)', () {
      final result = validator.validate({
        'schema': '1.0.0',
        'root': {'widget': 'PressableBox'},
      });
      expect(result.isValid, isTrue);
    });

    test('Token without "." is rejected (token.form-invalid)', () {
      final result = validator.validate({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {
              'alignment': {'token': 'just_a_name'},
            },
          },
        },
      });
      expect(result.isValid, isFalse);
    });
  });

  group('full pipeline ordering', () {
    test('valid sugar document survives all 4 stages', () {
      final result = validator.validate({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {
              'padding': 16,
              'alignment': 'center',
            },
          },
        },
      });
      expect(result.isValid, isTrue,
          reason: 'errors: ${result.errors.join("\n")}');
    });

    test('canonical document also passes', () {
      final result = validator.validate({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {
              'padding': {
                'value': {
                  'top': {'value': 16},
                  'left': {'value': 16},
                  'right': {'value': 16},
                  'bottom': {'value': 16},
                },
              },
            },
          },
        },
      });
      expect(result.isValid, isTrue,
          reason: 'errors: ${result.errors.join("\n")}');
    });
  });
}
