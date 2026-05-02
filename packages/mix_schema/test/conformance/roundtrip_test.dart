import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/_internal.dart' show deepEquals;
import 'package:test/test.dart';

import '../foundations/_helpers.dart';

void main() {
  late MixSchemaAssets assets;
  late Parser parser;
  late Serializer serializer;

  setUpAll(() {
    assets = MixSchemaAssets.fromFiles(testAssetsDir);
    parser = Parser(assets);
    serializer = const Serializer();
  });

  /// Round-trip invariant 1: `serialize(parse(x)) ≡ x` for canonical x.
  void roundTrip(String label, Map<String, Object?> canonical) {
    test('$label round-trips structurally', () {
      final parsed = parser.parseCanonical(canonical);
      final serialized = serializer.toMap(parsed);
      expect(deepEquals(canonical, serialized), isTrue,
          reason: '$label\nin:  $canonical\nout: $serialized');
    });
  }

  group('canonical round-trip', () {
    roundTrip('minimal Box', {
      'schema': '1.0.0',
      'root': {'widget': 'Box'},
    });

    roundTrip('Box with padding (canonical)', {
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

    roundTrip('FlexBox with children', {
      'schema': '1.0.0',
      'root': {
        'widget': 'FlexBox',
        'style': {
          'spec': 'flexbox',
          'flex': {
            'spec': 'flex',
            'props': {
              'mainAxisAlignment': {'value': 'center'},
            },
          },
        },
        'children': [
          {'widget': 'Box'},
          {
            'widget': 'StyledText',
            'text': 'Hello',
          },
        ],
      },
    });

    roundTrip('Variants and modifiers', {
      'schema': '1.0.0',
      'root': {
        'widget': 'Box',
        'style': {
          'spec': 'box',
          'props': {
            'alignment': {'token': 'color.primary'},
          },
          'variants': [
            {
              'when': 'onHovered',
              'style': {
                'spec': 'box',
                'props': {
                  'alignment': {'token': 'color.accent'},
                },
              },
            },
          ],
          'modifiers': [
            {
              'modifier': 'opacity',
              'props': {
                'opacity': {'value': 0.5},
              },
            },
            {'modifier': 'reset'},
          ],
        },
      },
    });

    roundTrip('Tokens bundle preserved', {
      'schema': '1.0.0',
      'tokens': {
        'color.primary': {'value': '#2196f3ff'},
        'space.md': {'value': 16},
      },
      'root': {'widget': 'Box'},
    });

    roundTrip('x: extension payload preserved (audit row G)', {
      'schema': '1.0.0',
      'root': {
        'widget': 'x:my-card',
        'tint': {'value': '#ff0000ff'},
        'children': [
          {'widget': 'Box'},
        ],
      },
    });
  });

  group('parseValidating', () {
    test('valid sugar document succeeds and produces typed model', () {
      final result = parser.parseValidating({
        'schema': '1.0.0',
        'root': {
          'widget': 'Box',
          'style': {
            'spec': 'box',
            'props': {'padding': 16},
          },
        },
      });
      expect(result.isValid, isTrue,
          reason: 'errors: ${result.validation.errors.join("\n")}');
      expect(result.document, isNotNull);
      expect(result.document!.root, isA<WidgetBox>());
    });

    test('over-bounds document fails before parse', () {
      final children = <Object?>[
        for (var i = 0; i < 1100; i++) {'widget': 'Box'}
      ];
      final result = parser.parseValidating({
        'schema': '1.0.0',
        'root': {'widget': 'FlexBox', 'children': children},
      });
      expect(result.isValid, isFalse);
      expect(result.document, isNull);
    });
  });

  group('Serializer.toJson string output', () {
    test('emits valid JSON', () {
      final doc = MixJsonDocument(schema: '1.0.0', root: const WidgetBox());
      final encoded = const Serializer().toJson(doc, pretty: false);
      expect(encoded, contains('"schema"'));
      expect(encoded, contains('"widget":"Box"'));
    });
  });
}
