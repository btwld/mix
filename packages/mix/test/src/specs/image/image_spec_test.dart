import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ImageSpec', () {
    group('ImageSpec comprehensive', () {
      test('constructor with all properties', () {
        const spec = ImageSpec(
          width: 150.0,
          height: 200.0,
          color: Colors.blue,
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
          centerSlice: Rect.fromLTRB(1, 2, 3, 4),
          filterQuality: FilterQuality.high,
          colorBlendMode: BlendMode.colorDodge,
          animated: AnimatedData(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          modifiers: WidgetModifiersData([
            OpacityModifierSpec(0.8),
            SizedBoxModifierSpec(width: 100, height: 100),
          ]),
        );

        // Test ALL properties are set correctly
        expect(spec.width, 150.0);
        expect(spec.height, 200.0);
        expect(spec.color, Colors.blue);
        expect(spec.repeat, ImageRepeat.repeat);
        expect(spec.fit, BoxFit.cover);
        expect(spec.alignment, Alignment.bottomCenter);
        expect(spec.centerSlice, const Rect.fromLTRB(1, 2, 3, 4));
        expect(spec.filterQuality, FilterQuality.high);
        expect(spec.colorBlendMode, BlendMode.colorDodge);
        expect(spec.animated?.duration, const Duration(milliseconds: 300));
        expect(spec.animated?.curve, Curves.easeInOut);
        expect(spec.modifiers?.value, [
          const OpacityModifierSpec(0.8),
          const SizedBoxModifierSpec(width: 100, height: 100),
        ]);
      });

      test('call method creates correct widget', () {
        const spec = ImageSpec(
          width: 150.0,
          height: 200.0,
          color: Colors.blue,
        );

        final widget = spec.call(
          image: const AssetImage('assets/test.png'),
        );

        expect(widget, isA<ImageSpecWidget>());
      });

      test('call method creates animated widget when animated', () {
        const spec = ImageSpec(
          width: 150.0,
          height: 200.0,
          color: Colors.blue,
          animated: AnimatedData(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        );

        final widget = spec.call(
          image: const AssetImage('assets/test.png'),
        );

        expect(widget, isA<AnimatedImageSpecWidget>());
      });

      test('debugFillProperties includes all properties', () {
        const spec = ImageSpec(
          width: 150.0,
          height: 200.0,
          color: Colors.blue,
          fit: BoxFit.cover,
        );

        final builder = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties, isNotEmpty);
      });
    });
    test('ImageSpec.from(MixData) resolves correctly', () {
      final recipe = ImageSpec.from(EmptyMixData);

      expect(recipe.width, null);
      expect(recipe.height, null);
      expect(recipe.color, null);
      expect(recipe.repeat, null);
      expect(recipe.fit, null);
    });

    test('lerp interpolates correctly', () {
      const spec1 = ImageSpec(
        width: 100,
        height: 200,
        color: Colors.red,
        repeat: ImageRepeat.repeat,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
        centerSlice: Rect.zero,
        filterQuality: FilterQuality.low,
        colorBlendMode: BlendMode.srcOver,
      );
      const spec2 = ImageSpec(
        width: 150,
        height: 250,
        color: Colors.blue,
        repeat: ImageRepeat.noRepeat,
        fit: BoxFit.fill,
        alignment: Alignment.bottomCenter,
        centerSlice: Rect.fromLTRB(0, 0, 0, 0),
        filterQuality: FilterQuality.high,
        colorBlendMode: BlendMode.colorBurn,
      );
      final lerpSpec = spec1.lerp(spec2, 0.5);

      expect(lerpSpec.width, lerpDouble(100, 150, 0.5));
      expect(lerpSpec.height, lerpDouble(200, 250, 0.5));
      expect(lerpSpec.color, Color.lerp(Colors.red, Colors.blue, 0.5));
      expect(lerpSpec.repeat, ImageRepeat.noRepeat);
      expect(lerpSpec.fit, BoxFit.fill);
      expect(lerpSpec.alignment, Alignment.bottomCenter);
      expect(lerpSpec.centerSlice, const Rect.fromLTRB(0, 0, 0, 0));
      expect(lerpSpec.filterQuality, FilterQuality.high);
      expect(lerpSpec.colorBlendMode, BlendMode.colorBurn);
    });

    test('copyWith updates correctly and preserves unchanged properties', () {
      const original = ImageSpec(
        width: 100.0,
        height: 150.0,
        color: Colors.red,
        fit: BoxFit.contain,
        repeat: ImageRepeat.repeat,
      );

      final updated = original.copyWith(
        width: 200.0,
        color: Colors.blue,
        // Don't update height, fit, repeat - test preservation
      );

      // Test updated properties
      expect(updated.width, 200.0);
      expect(updated.color, Colors.blue);

      // Test preserved properties
      expect(updated.height, 150.0);
      expect(updated.fit, BoxFit.contain);
      expect(updated.repeat, ImageRepeat.repeat);
    });

    test('equality operator works correctly', () {
      const spec1 = ImageSpec(
        width: 100.0,
        height: 150.0,
        color: Colors.red,
        fit: BoxFit.contain,
        repeat: ImageRepeat.repeat,
      );

      const spec2 = ImageSpec(
        width: 100.0,
        height: 150.0,
        color: Colors.red,
        fit: BoxFit.contain,
        repeat: ImageRepeat.repeat,
      );

      const spec3 = ImageSpec(
        width: 200.0,
        height: 250.0,
        color: Colors.blue,
        fit: BoxFit.cover,
        repeat: ImageRepeat.noRepeat,
      );

      expect(spec1, spec2);
      expect(spec1, isNot(spec3));
      expect(spec2, isNot(spec3));
    });

    test('props returns correct list of properties', () {
      const spec = ImageSpec(
        width: 100,
        height: 200,
        color: Colors.red,
        repeat: ImageRepeat.repeat,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
        centerSlice: Rect.zero,
        filterQuality: FilterQuality.low,
        colorBlendMode: BlendMode.srcOver,
        animated: AnimatedData.withDefaults(),
      );

      T getValueOf<T>(T field) => (spec.props[spec.props.indexOf(field)]) as T;

      expect(getValueOf(spec.width), 100);
      expect(getValueOf(spec.height), 200);
      expect(getValueOf(spec.color), Colors.red);
      expect(getValueOf(spec.repeat), ImageRepeat.repeat);
      expect(getValueOf(spec.fit), BoxFit.cover);
      expect(getValueOf(spec.alignment), Alignment.bottomCenter);
      expect(getValueOf(spec.centerSlice), Rect.zero);
      expect(getValueOf(spec.filterQuality), FilterQuality.low);
      expect(getValueOf(spec.colorBlendMode), BlendMode.srcOver);
      expect(getValueOf(spec.modifiers), null);
      expect(getValueOf(spec.animated), const AnimatedData.withDefaults());
      expect(spec.props.length, 11);
    });
  });

  group('ImageSpecUtility fluent', () {
    test('fluent behavior', () {
      final image = ImageSpecUtility.self;

      final util = image.chain
        ..width(100)
        ..height(200)
        ..color.red()
        ..fit.cover();

      final attr = util.attributeValue!;

      expect(util, isA<Attribute>());
      expect(attr.width, 100);
      expect(attr.height, 200);
      expect(attr.color, Colors.red.toDto());
      expect(attr.fit, BoxFit.cover);

      final style = Style(util);

      final imageAttribute = style.styles.attributeOfType<ImageSpecAttribute>();

      expect(imageAttribute?.width, 100);
      expect(imageAttribute?.height, 200);
      expect(imageAttribute?.color, Colors.red.toDto());
      expect(imageAttribute?.fit, BoxFit.cover);

      final mixData = style.of(MockBuildContext());
      final imageSpec = ImageSpec.from(mixData);

      expect(imageSpec.width, 100);
      expect(imageSpec.height, 200);
      expect(imageSpec.color, Colors.red);
      expect(imageSpec.fit, BoxFit.cover);
    });

    test('Immutable behavior when having multiple images', () {
      final imageUtil = ImageSpecUtility.self;
      final image1 = imageUtil.chain..width(100);
      final image2 = imageUtil.chain..width(200);

      final attr1 = image1.attributeValue!;
      final attr2 = image2.attributeValue!;

      expect(attr1.width, 100);
      expect(attr2.width, 200);

      final style1 = Style(image1);
      final style2 = Style(image2);

      final imageAttribute1 =
          style1.styles.attributeOfType<ImageSpecAttribute>();
      final imageAttribute2 =
          style2.styles.attributeOfType<ImageSpecAttribute>();

      expect(imageAttribute1?.width, 100);
      expect(imageAttribute2?.width, 200);

      final mixData1 = style1.of(MockBuildContext());
      final mixData2 = style2.of(MockBuildContext());

      final imageSpec1 = ImageSpec.from(mixData1);
      final imageSpec2 = ImageSpec.from(mixData2);

      expect(imageSpec1.width, 100);
      expect(imageSpec2.width, 200);
    });

    test('Mutate behavior and not on same utility', () {
      final image = ImageSpecUtility.self;

      final imageValue = image.chain;
      imageValue
        ..width(100)
        ..color.red()
        ..fit.cover();

      final imageAttribute = imageValue.attributeValue!;
      final imageAttribute2 = image.width(200);

      expect(imageAttribute.width, 100);
      expect(imageAttribute.color, Colors.red.toDto());
      expect(imageAttribute.fit, BoxFit.cover);

      expect(imageAttribute2.width, 200);
      expect(imageAttribute2.color, isNull);
      expect(imageAttribute2.fit, isNull);
    });
  });
}
