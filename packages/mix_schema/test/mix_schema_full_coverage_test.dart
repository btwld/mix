import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('MixSchema full coverage', () {
    test('decodes every built-in styler type', () {
      final images = RegistryBuilder<ImageProvider<Object>>.builtIn(
        scope: MixSchemaScope.imageProvider,
      )..register('hero', MemoryImage(Uint8List.fromList([0, 0, 0, 0])));

      final decoder = MixSchemaDecoder.builtIn(registries: [images.freeze()]);

      final payloads = <String, Map<String, Object?>>{
        'box': {'type': 'box'},
        'text': {'type': 'text'},
        'flex': {'type': 'flex'},
        'icon': {'type': 'icon'},
        'image': {'type': 'image', 'image': 'hero'},
        'stack': {'type': 'stack'},
        'flex_box': {'type': 'flex_box'},
        'stack_box': {'type': 'stack_box'},
      };

      final expectedTypes = <String, Type>{
        'box': BoxStyler,
        'text': TextStyler,
        'flex': FlexStyler,
        'icon': IconStyler,
        'image': ImageStyler,
        'stack': StackStyler,
        'flex_box': FlexBoxStyler,
        'stack_box': StackBoxStyler,
      };

      for (final entry in payloads.entries) {
        final result = decoder.decode(entry.value);

        expect(result.ok, isTrue, reason: 'Expected ${entry.key} to decode');
        expect(result.value, isA<Object>());
        expect(result.value.runtimeType, expectedTypes[entry.key]);
      }
    });

    testWidgets(
      'decodes modifier ordering and active context builder variants',
      (tester) async {
        final builders =
            RegistryBuilder<BoxStyler Function(BuildContext)>.builtIn(
              scope: MixSchemaScope.contextVariantBuilder,
            )..register(
              'context-box',
              (_) => BoxStyler(margin: EdgeInsetsMix.all(6)),
            );

        final decoder = MixSchemaDecoder.builtIn(
          registries: [builders.freeze()],
        );
        final result = decoder.decode({
          'type': 'box',
          'modifiers': [
            {'type': 'blur', 'sigma': 2.0},
            {'type': 'opacity', 'value': 0.4},
          ],
          'modifierOrder': ['opacity', 'blur', 'missing'],
          'variants': [
            {
              'type': 'named',
              'name': 'primary',
              'style': {
                'padding': {'top': 4},
              },
            },
            {'type': 'context_variant_builder', 'id': 'context-box'},
            {
              'type': 'context_brightness',
              'brightness': 'dark',
              'style': {'clipBehavior': 'hardEdge'},
            },
          ],
        });

        expect(result.ok, isTrue);

        final style = result.value! as BoxStyler;
        expect(style.$variants, hasLength(3));

        late List<WidgetModifier> modifiers;
        late BoxStyler merged;
        late BoxStyler named;
        late BuildContext context;

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              size: Size(400, 800),
              platformBrightness: Brightness.dark,
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Builder(
                builder: (value) {
                  context = value;
                  modifiers = style.$modifier!.resolve(value);
                  named = style.applyVariants(const [NamedVariant('primary')]);
                  merged =
                      style.mergeActiveVariants(
                            value,
                            namedVariants: const <NamedVariant>{},
                          )
                          as BoxStyler;
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(
          named.resolve(context).spec.padding,
          const EdgeInsets.only(top: 4),
        );

        expect(
          modifiers.map((modifier) => modifier.runtimeType).toList(),
          const [OpacityModifier, BlurModifier],
        );
        expect(merged.resolve(context).spec.margin, const EdgeInsets.all(6));
        expect(merged.resolve(context).spec.clipBehavior, Clip.hardEdge);
      },
    );

    test('returns unsupported_value_type for icon payloads', () {
      final decoder = MixSchemaDecoder.builtIn();
      final result = decoder.decode({'type': 'icon', 'icon': 'home'});

      expect(result.ok, isFalse);
      expect(
        result.errors.single.code,
        MixSchemaErrorCode.unsupportedValueType,
      );
      expect(result.errors.single.path, '#');
    });

    test('returns transform_failed for registry type mismatches', () {
      final images = RegistryBuilder<Object>.builtIn(
        scope: MixSchemaScope.imageProvider,
      )..register('broken', 'not-an-image');

      final decoder = MixSchemaDecoder.builtIn(registries: [images.freeze()]);
      final result = decoder.decode({'type': 'image', 'image': 'broken'});

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.transformFailed);
      expect(result.errors.single.path, '#/image');
    });
  });
}
