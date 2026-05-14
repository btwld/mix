import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/registry/registry_catalog.dart';
import 'package:mix_schema/src/schema/mix_schema_catalog.dart';
import 'package:mix_schema/src/schema/painting/gradient_schemas.dart';

void main() {
  group('strict enum wire contract', () {
    test('rejects integer enum indexes at top level', () {
      final result = MixSchemaContract.builtIn().decode({
        'type': 'box',
        'clipBehavior': 1,
      });

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.typeMismatch);
      expect(result.errors.single.path, '#/clipBehavior');
    });

    test('rejects integer enum indexes inside variants', () {
      final result = MixSchemaContract.builtIn().decode({
        'type': 'box',
        'variants': [
          {
            'type': 'widget_state',
            'state': 0,
            'style': {'clipBehavior': 'hardEdge'},
          },
        ],
      });

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.typeMismatch);
      expect(result.errors.single.path, '#/variants/0/state');
    });

    test('rejects integer enum indexes inside modifiers', () {
      final result = MixSchemaContract.builtIn().decode({
        'type': 'box',
        'modifiers': [
          {'type': 'default_text_style', 'overflow': 1},
        ],
      });

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.typeMismatch);
      expect(result.errors.single.path, '#/modifiers/0/overflow');
    });

    test(
      'rejects integer enum indexes inside painting and text style fields',
      () {
        final contract = MixSchemaContract.builtIn();
        final result = contract.decode({
          'type': 'box',
          'decoration': {
            'type': 'box_decoration',
            'shape': 0,
            'gradient': {
              'type': 'linear_gradient',
              'colors': ['#000000FF', '#FFFFFFFF'],
              'tileMode': 1,
            },
          },
        });
        final textResult = contract.decode({
          'type': 'text',
          'style': {'fontStyle': 0},
        });

        expect(result.ok, isFalse);
        expect(textResult.ok, isFalse);
        expect(
          result.errors.map((error) => (error.code, error.path)),
          containsAll(<(MixSchemaErrorCode, String)>[
            (MixSchemaErrorCode.typeMismatch, '#/decoration/gradient/tileMode'),
            (MixSchemaErrorCode.typeMismatch, '#/decoration/shape'),
          ]),
        );
        expect(textResult.errors.single.code, MixSchemaErrorCode.typeMismatch);
        expect(textResult.errors.single.path, '#/style/fontStyle');
      },
    );
  });

  group('registry-backed runtime values', () {
    test('decodes and encodes icon data through icon_data registry ids', () {
      const icon = IconData(0xe145, fontFamily: 'MaterialIcons');
      final icons = RegistryBuilder<IconData>.builtIn(
        scope: MixSchemaScope.iconData,
      )..register('add', icon);
      final contract = MixSchemaContract.builtIn(registries: [icons.freeze()]);

      final decoded = contract.decode({'type': 'icon', 'icon': 'add'});

      expect(decoded.ok, isTrue);
      expect(contract.encode(decoded.value!).value, {
        'type': 'icon',
        'icon': 'add',
      });
    });

    test('reports unknown_registry_id for missing registry ids', () {
      final result = MixSchemaContract.builtIn().decode({
        'type': 'icon',
        'icon': 'missing',
      });

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.unknownRegistryId);
      expect(result.errors.single.path, '#/icon');
    });

    test('reports unknown_registry_value for unregistered runtime values', () {
      final contract = MixSchemaContract.builtIn();
      final image = MemoryImage(Uint8List.fromList([0, 0, 0, 0]));
      void onEnd() {}

      final imageResult = contract.encode(ImageStyler(image: image));
      final iconResult = contract.encode(
        IconStyler(icon: const IconData(0xe145)),
      );
      final animationResult = contract.encode(
        BoxStyler(
          animation: AnimationConfig.curve(
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
            onEnd: onEnd,
          ),
        ),
      );
      final contextBuilderResult = contract.encode(
        BoxStyler(
          variants: [
            VariantStyle<BoxSpec>(
              ContextVariantBuilder<BoxStyler>((_) => BoxStyler()),
              BoxStyler(),
            ),
          ],
        ),
      );

      expect(imageResult.ok, isFalse);
      expect(
        imageResult.errors.single.code,
        MixSchemaErrorCode.unknownRegistryValue,
      );
      expect(iconResult.ok, isFalse);
      expect(
        iconResult.errors.single.code,
        MixSchemaErrorCode.unknownRegistryValue,
      );
      expect(animationResult.ok, isFalse);
      expect(
        animationResult.errors.single.code,
        MixSchemaErrorCode.unknownRegistryValue,
      );
      expect(contextBuilderResult.ok, isFalse);
      expect(
        contextBuilderResult.errors.single.code,
        MixSchemaErrorCode.unknownRegistryValue,
      );
    });

    test('encodes context_variant_builder through reverse registry lookup', () {
      final style = BoxStyler();
      BoxStyler buildVariant(BuildContext context) => style;

      final builders =
          RegistryBuilder<BoxStyler Function(BuildContext)>.builtIn(
            scope: MixSchemaScope.contextVariantBuilder,
          )..register('context-box', buildVariant);
      final contract = MixSchemaContract.builtIn(
        registries: [builders.freeze()],
      );
      final source = BoxStyler(
        variants: [
          VariantStyle<BoxSpec>(
            ContextVariantBuilder<BoxStyler>(buildVariant),
            BoxStyler(),
          ),
        ],
      );

      final result = contract.encode(source);

      expect(result.ok, isTrue);
      expect(result.value, {
        'type': 'box',
        'variants': [
          {'type': 'context_variant_builder', 'id': 'context-box'},
        ],
      });
    });
  });

  group('stable encode errors', () {
    test(
      'reports unsupported_encode_value for unsupported non-registry values',
      () {
        final contract = MixSchemaContract.builtIn();
        final multiSource = BoxStyler(
          alignment: Alignment.center,
        ).merge(BoxStyler(alignment: Alignment.topLeft));
        final directional = StackStyler(
          alignment: AlignmentDirectional.topStart,
        );
        final unsupportedAnimation = BoxStyler(
          animation: AnimationConfig.curve(
            duration: const Duration(milliseconds: 100),
            curve: const Cubic(0.1, 0.2, 0.3, 0.4),
          ),
        );

        for (final style in [multiSource, directional, unsupportedAnimation]) {
          final result = contract.encode(style);

          expect(result.ok, isFalse);
          expect(
            result.errors.single.code,
            MixSchemaErrorCode.unsupportedEncodeValue,
          );
        }
      },
    );
  });

  group('payload limits', () {
    test('rejects payloads that exceed structural limits before decode', () {
      final deep =
          MixSchemaContract.builtIn(
            limits: const MixSchemaLimits(maxDepth: 4),
          ).validate({
            'type': 'box',
            'decoration': {
              'type': 'box_decoration',
              'borderRadius': {
                'type': 'border_radius',
                'topLeft': {'x': 1},
              },
            },
          });
      final longString =
          MixSchemaContract.builtIn(
            limits: const MixSchemaLimits(maxStringLength: 8),
          ).validate({
            'type': 'box',
            'variants': [
              {'type': 'named', 'name': 'long-name', 'style': {}},
            ],
          });
      final tooManyVariants =
          MixSchemaContract.builtIn(
            limits: const MixSchemaLimits(maxVariantsPerStyler: 1),
          ).validate({
            'type': 'box',
            'variants': [
              {'type': 'named', 'name': 'a', 'style': {}},
              {'type': 'named', 'name': 'b', 'style': {}},
            ],
          });
      final tooManyModifiers =
          MixSchemaContract.builtIn(
            limits: const MixSchemaLimits(maxModifiersPerStyler: 1),
          ).validate({
            'type': 'box',
            'modifiers': [
              {'type': 'opacity', 'value': 0.5},
              {'type': 'blur'},
            ],
          });
      final tooManyColors =
          MixSchemaContract.builtIn(
            limits: const MixSchemaLimits(maxListLength: 2),
          ).validate({
            'type': 'box',
            'decoration': {
              'type': 'box_decoration',
              'gradient': {
                'type': 'linear_gradient',
                'colors': ['#000000FF', '#111111FF', '#FFFFFFFF'],
              },
            },
          });

      expect(deep.errors.single.path, '#/decoration/borderRadius/topLeft/x');
      expect(longString.errors.single.path, '#/variants/0/name');
      expect(tooManyVariants.errors.single.path, '#/variants');
      expect(tooManyModifiers.errors.single.path, '#/modifiers');
      expect(tooManyColors.errors.single.path, '#/decoration/gradient/colors');
      expect(
        {
          deep,
          longString,
          tooManyVariants,
          tooManyModifiers,
          tooManyColors,
        }.every(
          (result) =>
              result.errors.single.code ==
              MixSchemaErrorCode.payloadLimitExceeded,
        ),
        isTrue,
      );
    });

    test('applies registry id length limits to registry-backed schemas', () {
      final contract = MixSchemaContract.builtIn(
        limits: const MixSchemaLimits(maxRegistryIdLength: 4),
      );

      final result = contract.decode({'type': 'icon', 'icon': 'too-long'});

      expect(result.ok, isFalse);
      expect(
        result.errors.single.code,
        MixSchemaErrorCode.payloadLimitExceeded,
      );
      expect(result.errors.single.path, '#/icon');
    });

    test('applies structural limits after encoding runtime styles', () {
      final longVariantName =
          MixSchemaContract.builtIn(
            limits: const MixSchemaLimits(maxStringLength: 8),
          ).encode(
            BoxStyler(
              variants: [
                VariantStyle<BoxSpec>(Variant.named('long-name'), BoxStyler()),
              ],
            ),
          );
      final tooManyVariants =
          MixSchemaContract.builtIn(
            limits: const MixSchemaLimits(maxVariantsPerStyler: 1),
          ).encode(
            BoxStyler(
              variants: [
                VariantStyle<BoxSpec>(Variant.named('a'), BoxStyler()),
                VariantStyle<BoxSpec>(Variant.named('b'), BoxStyler()),
              ],
            ),
          );
      final tooManyModifiers =
          MixSchemaContract.builtIn(
            limits: const MixSchemaLimits(maxModifiersPerStyler: 1),
          ).encode(
            BoxStyler(
              modifier: WidgetModifierConfig(
                modifiers: [
                  OpacityModifierMix(opacity: 0.5),
                  BlurModifierMix(sigma: 2),
                ],
              ),
            ),
          );

      expect(longVariantName.ok, isFalse);
      _expectPayloadLimitError(longVariantName.errors, '#/variants/0/name');
      expect(tooManyVariants.ok, isFalse);
      _expectPayloadLimitError(tooManyVariants.errors, '#/variants');
      expect(tooManyModifiers.ok, isFalse);
      _expectPayloadLimitError(tooManyModifiers.errors, '#/modifiers');
    });
  });

  group('JSON Schema export metadata', () {
    test('adds mix_schema artifact metadata to the exported schema', () {
      final schema = MixSchemaContract.builtIn().exportJsonSchema();

      expect(schema['\$schema'], 'http://json-schema.org/draft-07/schema#');
      expect(schema['x-mix-schema-contract'], 'mix_schema');
      expect(schema['x-mix-schema-version'], MixSchemaContract.contractVersion);
      expect(schema['x-mix-schema-limits'], {
        'maxDepth': 32,
        'maxListLength': 256,
        'maxStringLength': 4096,
        'maxRegistryIdLength': 256,
        'maxVariantsPerStyler': 64,
        'maxModifiersPerStyler': 64,
      });
      expect(schema['anyOf'], isA<List<Object?>>());
    });

    test('exports custom limits in JSON Schema metadata', () {
      final schema = MixSchemaContract.builtIn(
        limits: const MixSchemaLimits(
          maxDepth: 4,
          maxListLength: 5,
          maxStringLength: 6,
          maxRegistryIdLength: 7,
          maxVariantsPerStyler: 8,
          maxModifiersPerStyler: 9,
        ),
      ).exportJsonSchema();

      expect(schema['x-mix-schema-limits'], {
        'maxDepth': 4,
        'maxListLength': 5,
        'maxStringLength': 6,
        'maxRegistryIdLength': 7,
        'maxVariantsPerStyler': 8,
        'maxModifiersPerStyler': 9,
      });
    });
  });

  group('neutral gradient transform naming', () {
    test('decodes and encodes css linear keyword transforms', () {
      final catalog = MixSchemaCatalog(registries: RegistryCatalog(const []));
      final payload = {
        'type': 'linear_gradient',
        'colors': ['#000000FF', '#FFFFFFFF'],
        'transform': {
          'type': 'css_linear_keyword_transform',
          'direction': 'to_bottom_right',
        },
      };

      final decoded = catalog.gradient.parse(payload);
      final source =
          (decoded as LinearGradientMix).$transform!.sources.single
              as ValueSource<GradientTransform>;

      expect(source.value, isA<CssLinearKeywordGradientTransform>());
      expect(catalog.gradient.encode(decoded), payload);
    });

    test('rejects old tailwind-specific transform and direction names', () {
      final catalog = MixSchemaCatalog(registries: RegistryCatalog(const []));
      final oldTransform = catalog.gradient.safeParse({
        'type': 'linear_gradient',
        'colors': ['#000000FF', '#FFFFFFFF'],
        'transform': {'type': 'tailwind_css_angle_rect', 'direction': 'to-br'},
      });
      final oldDirection = catalog.gradient.safeParse({
        'type': 'linear_gradient',
        'colors': ['#000000FF', '#FFFFFFFF'],
        'transform': {
          'type': 'css_linear_keyword_transform',
          'direction': 'to-br',
        },
      });

      expect(oldTransform.isFail, isTrue);
      expect(oldDirection.isFail, isTrue);
    });
  });
}

void _expectPayloadLimitError(Iterable<MixSchemaError> errors, String path) {
  expect(
    errors,
    contains(
      isA<MixSchemaError>()
          .having(
            (error) => error.code,
            'code',
            MixSchemaErrorCode.payloadLimitExceeded,
          )
          .having((error) => error.path, 'path', path),
    ),
  );
}
