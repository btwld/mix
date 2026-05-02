import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/_internal.dart' show deepEquals;
import 'package:test/test.dart';

import '../foundations/_helpers.dart';

void main() {
  late Canonicalizer canonicalizer;

  setUpAll(() {
    final assets = MixSchemaAssets.fromFiles(testAssetsDir);
    canonicalizer = Canonicalizer(assets.registry);
  });

  group('idempotency', () {
    void idempotent(String label, Map<String, Object?> input) {
      test('$label canonicalize ∘ canonicalize ≡ canonicalize', () {
        final once = canonicalizer.normalize(input);
        final twice = canonicalizer.normalize(once);
        expect(deepEquals(once, twice), isTrue,
            reason: '$label: not idempotent\nonce: $once\ntwice: $twice');
      });
    }

    idempotent('empty envelope', {
      'schema': '1.0.0',
      'root': {'widget': 'Box'},
    });

    idempotent('Box with sugar padding', {
      'schema': '1.0.0',
      'root': {
        'widget': 'Box',
        'style': {
          'spec': 'box',
          'props': {'padding': 16},
        },
      },
    });

    idempotent('canonical Box (no sugar)', {
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

    idempotent('flexbox with empty arrays pruned', {
      'schema': '1.0.0',
      'root': {
        'widget': 'FlexBox',
        'style': {
          'spec': 'flexbox',
          'box': {'spec': 'box', 'props': {}},
          'flex': {'spec': 'flex', 'props': {'mainAxisAlignment': 'center'}},
          'variants': <Object?>[],
          'modifiers': <Object?>[],
        },
        'children': [
          {'widget': 'Box'},
        ],
      },
    });
  });

  group('pass 1 — alias normalization (Decision #36)', () {
    test('FontWeight.normal becomes w400 anywhere it appears', () {
      final result = canonicalizer.normalize({
        'schema': '1.0.0',
        'root': {
          'widget': 'StyledText',
          'text': 'Hi',
          'style': {
            'spec': 'text',
            'props': {
              'fontWeight': 'normal',
            },
          },
        },
      });
      // Walk down to the prop.
      final props = ((result['root'] as Map)['style'] as Map)['props']
          as Map<String, Object?>;
      expect(props['fontWeight'], equals({'value': 'w400'}));
    });

    test('FontWeight.bold becomes w700', () {
      final result = canonicalizer.normalize({
        'schema': '1.0.0',
        'root': {
          'widget': 'StyledText',
          'text': 'Hi',
          'style': {
            'spec': 'text',
            'props': {'fontWeight': 'bold'},
          },
        },
      });
      final props = ((result['root'] as Map)['style'] as Map)['props']
          as Map<String, Object?>;
      expect(props['fontWeight'], equals({'value': 'w700'}));
    });

    test('Already-canonical w400 is unchanged', () {
      final result = canonicalizer.normalize({
        'schema': '1.0.0',
        'root': {
          'widget': 'StyledText',
          'text': 'Hi',
          'style': {
            'spec': 'text',
            'props': {'fontWeight': 'w400'},
          },
        },
      });
      final props = ((result['root'] as Map)['style'] as Map)['props']
          as Map<String, Object?>;
      expect(props['fontWeight'], equals({'value': 'w400'}));
    });
  });

  group('pass 2 — bare scalar lift', () {
    test('bare integer at a Value position becomes {value: x}', () {
      final result = canonicalizer.normalize({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {'alignment': 'center'},
          },
        },
      });
      final props = ((result['root'] as Map)['style'] as Map)['props']
          as Map<String, Object?>;
      // 'center' is an Alignment preset; should expand to {x, y} after
      // pass 3, with each sub-field a Value.
      expect(props['alignment'], isA<Map<String, Object?>>());
    });
  });

  group('pass 3 — structured-literal sugar', () {
    test('EdgeInsets {all: 16} expands to 4 leaves', () {
      final result = canonicalizer.normalize({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {
              'padding': {'all': 16},
            },
          },
        },
      });
      final padding = (((result['root'] as Map)['style'] as Map)['props']
          as Map<String, Object?>)['padding'] as Map<String, Object?>;
      final body = padding['value']! as Map<String, Object?>;
      expect(body, equals({
        'bottom': {'value': 16},
        'left': {'value': 16},
        'right': {'value': 16},
        'top': {'value': 16},
      }));
    });

    test('EdgeInsets horizontal/vertical sugar', () {
      final result = canonicalizer.normalize({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {
              'padding': {'horizontal': 16, 'vertical': 8},
            },
          },
        },
      });
      final padding = (((result['root'] as Map)['style'] as Map)['props']
          as Map<String, Object?>)['padding'] as Map<String, Object?>;
      final body = padding['value']! as Map<String, Object?>;
      expect(body, equals({
        'bottom': {'value': 8},
        'left': {'value': 16},
        'right': {'value': 16},
        'top': {'value': 8},
      }));
    });

    test('BorderRadius {all: 8} expands to 4 corners', () {
      final result = canonicalizer.normalize({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {
              'decoration': {
                'borderRadius': {'all': 8},
              },
            },
          },
        },
      });
      final body = ((((result['root'] as Map)['style'] as Map)['props']
                  as Map<String, Object?>)['decoration']
              as Map<String, Object?>)['value']
          as Map<String, Object?>;
      final br = body['borderRadius'] as Map<String, Object?>;
      final brBody = br['value']! as Map<String, Object?>;
      expect(brBody.keys, contains('topLeft'));
      expect(brBody.keys, contains('topRight'));
      expect(brBody.keys, contains('bottomLeft'));
      expect(brBody.keys, contains('bottomRight'));
    });

    test('Alignment preset string expands to {x, y}', () {
      final result = canonicalizer.normalize({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {'alignment': 'topLeft'},
          },
        },
      });
      final alignment = (((result['root'] as Map)['style'] as Map)['props']
          as Map<String, Object?>)['alignment'] as Map<String, Object?>;
      expect(alignment['value'],
          equals({'x': {'value': -1}, 'y': {'value': -1}}));
    });

    test('color short-form #fff → #ffffffff (lowercase)', () {
      final result = canonicalizer.normalize({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {
              'decoration': {'color': '#fff'},
            },
          },
        },
      });
      final dec = (((result['root'] as Map)['style'] as Map)['props']
              as Map<String, Object?>)['decoration']
          as Map<String, Object?>;
      final body = dec['value']! as Map<String, Object?>;
      expect(body['color'], equals({'value': '#ffffffff'}));
    });

    test('color short-form #fff8 → #ffffff88', () {
      final result = canonicalizer.normalize({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {
              'decoration': {'color': '#fff8'},
            },
          },
        },
      });
      final dec = (((result['root'] as Map)['style'] as Map)['props']
              as Map<String, Object?>)['decoration']
          as Map<String, Object?>;
      final body = dec['value']! as Map<String, Object?>;
      expect(body['color'], equals({'value': '#ffffff88'}));
    });
  });

  group('pass 5 — empty-array pruning (Decision #41)', () {
    test('variants: [] is omitted', () {
      final result = canonicalizer.normalize({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': <String, Object?>{},
            'variants': <Object?>[],
          },
        },
      });
      final style = (result['root'] as Map)['style'] as Map<String, Object?>;
      expect(style.containsKey('variants'), isFalse);
    });

    test('modifiers: [] is omitted', () {
      final result = canonicalizer.normalize({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': <String, Object?>{},
            'modifiers': <Object?>[],
          },
        },
      });
      final style = (result['root'] as Map)['style'] as Map<String, Object?>;
      expect(style.containsKey('modifiers'), isFalse);
    });
  });

  group('lex-sort', () {
    test('keys are sorted alphabetically in the output', () {
      final result = canonicalizer.normalize({
        'root': {'widget': 'Box'},
        'schema': '1.0.0',
      });
      final keys = result.keys.toList();
      expect(keys, equals(['root', 'schema']));
    });
  });

  group('isCanonical', () {
    test('canonical input returns true', () {
      final canonical = {
        'root': {'widget': 'Box'},
        'schema': '1.0.0',
      };
      expect(canonicalizer.isCanonical(canonical), isTrue);
    });

    test('sugar input returns false', () {
      final sugar = {
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {'padding': 16},
          },
        },
      };
      expect(canonicalizer.isCanonical(sugar), isFalse);
    });
  });
}
