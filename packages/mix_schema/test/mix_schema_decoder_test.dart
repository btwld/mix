import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('MixSchemaContract decode', () {
    testWidgets('decodes a box payload into Mix runtime objects', (
      tester,
    ) async {
      var didComplete = false;
      final callbacks =
          RegistryBuilder<VoidCallback>.builtIn(
            scope: MixSchemaScope.animationOnEnd,
          )..register('done', () {
            didComplete = true;
          });

      final contract = MixSchemaContract.builtIn(
        registries: [callbacks.freeze()],
      );

      final result = contract.decode({
        'type': 'box',
        'alignment': {'x': -1, 'y': 0},
        'padding': {'top': 8, 'left': 16},
        'margin': {'bottom': 12, 'right': 4},
        'constraints': {'minWidth': 100, 'maxWidth': 200, 'minHeight': 50},
        'clipBehavior': 'hardEdge',
        'decoration': {
          'type': 'box_decoration',
          'color': 'rgba(51, 102, 153, 1)',
          'border': {
            'type': 'border',
            'top': {'color': 'rgb(0, 0, 0)', 'width': 2},
          },
          'borderRadius': {
            'type': 'border_radius',
            'topLeft': {'x': 12},
            'bottomRight': {'x': 4, 'y': 8},
          },
          'boxShadow': [
            {
              'color': '#00000033',
              'offset': {'dx': 1, 'dy': 2},
              'blurRadius': 4,
              'spreadRadius': 1,
            },
          ],
        },
        'foregroundDecoration': {
          'type': 'box_decoration',
          'gradient': {
            'type': 'linear_gradient',
            'colors': ['#000000', '#FFFFFFFF'],
            'begin': {'x': -1, 'y': 0},
            'end': {'x': 1, 'y': 0},
            'tileMode': 'clamp',
          },
        },
        'animation': {'duration': 200, 'curve': 'easeIn', 'onEnd': 'done'},
      });

      expect(result.ok, isTrue);
      expect(result.errors, isEmpty);

      final style = result.value! as BoxStyler;
      late StyleSpec<BoxSpec> resolved;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              resolved = style.resolve(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolved.spec.padding, const EdgeInsets.only(top: 8, left: 16));
      expect(resolved.spec.margin, const EdgeInsets.only(bottom: 12, right: 4));
      expect(resolved.spec.alignment, const Alignment(-1, 0));
      expect(
        resolved.spec.constraints,
        const BoxConstraints(minWidth: 100, maxWidth: 200, minHeight: 50),
      );
      expect(resolved.spec.clipBehavior, Clip.hardEdge);

      final decoration = resolved.spec.decoration! as BoxDecoration;
      expect(decoration.color, const Color(0xFF336699));
      expect(decoration.border!.top.color, const Color(0xFF000000));
      expect(decoration.border!.top.width, 2);
      expect(
        decoration.borderRadius,
        const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomRight: Radius.elliptical(4, 8),
        ),
      );
      expect(decoration.boxShadow, hasLength(1));
      expect(decoration.boxShadow!.single.offset, const Offset(1, 2));

      final foregroundDecoration =
          resolved.spec.foregroundDecoration! as BoxDecoration;
      final gradient = foregroundDecoration.gradient! as LinearGradient;
      expect(gradient.colors, const [Color(0xFF000000), Color(0xFFFFFFFF)]);
      expect(gradient.begin, const Alignment(-1, 0));
      expect(gradient.end, const Alignment(1, 0));
      expect(gradient.tileMode, TileMode.clamp);

      final animation = resolved.animation! as CurveAnimationConfig;
      expect(animation.duration, const Duration(milliseconds: 200));
      expect(animation.curve, Curves.easeIn);

      animation.onEnd?.call();
      expect(didComplete, isTrue);
    });

    testWidgets('decodes text locales without countryCode', (tester) async {
      final contract = MixSchemaContract.builtIn();
      final result = contract.decode({
        'type': 'text',
        'locale': {'languageCode': 'en'},
      });

      expect(result.ok, isTrue);
      expect(result.errors, isEmpty);

      final style = result.value! as TextStyler;
      late StyleSpec<TextSpec> resolved;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              resolved = style.resolve(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolved.spec.locale, const Locale('en'));
    });

    testWidgets('decodes decoration images for box and shape decorations', (
      tester,
    ) async {
      final heroImage = MemoryImage(Uint8List.fromList([0, 0, 0, 0]));
      final images = RegistryBuilder<ImageProvider<Object>>.builtIn(
        scope: MixSchemaScope.imageProvider,
      )..register('hero', heroImage);

      final contract = MixSchemaContract.builtIn(registries: [images.freeze()]);
      final result = contract.decode({
        'type': 'box',
        'decoration': {
          'type': 'box_decoration',
          'image': {'image': 'hero', 'fit': 'cover', 'isAntiAlias': true},
        },
        'foregroundDecoration': {
          'type': 'shape_decoration',
          'image': {'image': 'hero', 'repeat': 'repeatX', 'invertColors': true},
        },
      });

      expect(result.ok, isTrue);
      expect(result.errors, isEmpty);

      final style = result.value! as BoxStyler;
      late StyleSpec<BoxSpec> resolved;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              resolved = style.resolve(context);
              return const SizedBox();
            },
          ),
        ),
      );

      final decoration = resolved.spec.decoration! as BoxDecoration;
      expect(decoration.image, isNotNull);
      expect(decoration.image!.image, same(heroImage));
      expect(decoration.image!.fit, BoxFit.cover);
      expect(decoration.image!.isAntiAlias, isTrue);

      final foregroundDecoration =
          resolved.spec.foregroundDecoration! as ShapeDecoration;
      expect(foregroundDecoration.image, isNotNull);
      expect(foregroundDecoration.image!.image, same(heroImage));
      expect(foregroundDecoration.image!.repeat, ImageRepeat.repeatX);
      expect(foregroundDecoration.image!.invertColors, isTrue);
    });

    test('returns required_field when type is missing', () {
      final contract = MixSchemaContract.builtIn();
      final result = contract.decode({});

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.requiredField);
      expect(result.errors.single.path, '#/type');
    });

    test('returns unknown_type for unregistered styler ids', () {
      final contract = MixSchemaContract.builtIn();
      final result = contract.decode({'type': 'missing'});

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.unknownType);
      expect(result.errors.single.path, '#/type');
    });

    test('returns unknown_field for unexpected root fields', () {
      final contract = MixSchemaContract.builtIn();
      final result = contract.decode({'type': 'box', 'unknown': true});

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.unknownField);
      expect(result.errors.single.path, '#/unknown');
    });

    test('returns type_mismatch for invalid field types', () {
      final contract = MixSchemaContract.builtIn();
      final result = contract.decode({'type': 'box', 'padding': 'invalid'});

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.typeMismatch);
      expect(result.errors.single.path, '#/padding');
    });

    test('returns constraint_violation for invalid constrained values', () {
      final contract = MixSchemaContract.builtIn();
      final result = contract.decode({
        'type': 'box',
        'animation': {'duration': -1, 'curve': 'ease'},
      });

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.constraintViolation);
      expect(result.errors.single.path, '#/animation/duration');
    });

    test('returns unknown_registry_id for missing runtime references', () {
      final contract = MixSchemaContract.builtIn();
      final result = contract.decode({
        'type': 'box',
        'animation': {'duration': 200, 'curve': 'linear', 'onEnd': 'missing'},
      });

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.unknownRegistryId);
      expect(result.errors.single.path, '#/animation/onEnd');
    });

    test('returns nested errors with stable paths', () {
      final contract = MixSchemaContract.builtIn();
      final result = contract.decode({
        'type': 'box',
        'decoration': {
          'type': 'box_decoration',
          'border': {
            'type': 'border',
            'top': {'color': 'blue'},
          },
        },
      });

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.constraintViolation);
      expect(result.errors.single.path, '#/decoration/border/top/color');
    });

    test('returns validation_failed for invalid shared schema refinements', () {
      final contract = MixSchemaContract.builtIn();
      final result = contract.decode({
        'type': 'box',
        'constraints': {'minWidth': 200, 'maxWidth': 100},
      });

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.validationFailed);
      expect(result.errors.single.path, '#/constraints');
    });
  });
}
