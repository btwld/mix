import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('IconSpec', () {
    test('resolve', () {
      final mix = MixData.create(
        MockBuildContext(),
        Style(
          IconSpecAttribute(
            size: 20.0,
            color: Colors.red.toDto(),
            applyTextScaling: true,
            fill: 2,
            grade: 2,
            opticalSize: 2,
            shadows: [
              ShadowDto(
                color: Colors.black.toDto(),
              ),
              ShadowDto(
                color: Colors.black.toDto(),
              ),
            ],
            textDirection: TextDirection.ltr,
            weight: 2,
          ),
        ),
      );

      final spec = IconSpec.from(mix);

      expect(spec.color, Colors.red);
      expect(spec.size, 20.0);
      expect(spec.applyTextScaling, isTrue);
      expect(spec.grade, 2);
      expect(spec.opticalSize, 2);
      expect(spec.shadows, [
        const Shadow(
          color: Colors.black,
        ),
        const Shadow(
          color: Colors.black,
        ),
      ]);
      expect(spec.fill, 2);
      expect(spec.textDirection, TextDirection.ltr);
      expect(spec.weight, 2);
    });

    test('copyWith', () {
      const spec = IconSpec(color: Colors.red, size: 20.0);

      final copiedSpec = spec.copyWith(color: Colors.blue, size: 30.0);

      expect(copiedSpec.color, Colors.blue);
      expect(copiedSpec.size, 30.0);
    });

    test('lerp', () {
      const spec1 = IconSpec(color: Colors.red, size: 20.0);

      const spec2 = IconSpec(color: Colors.blue, size: 30.0);

      const t = 0.5;
      final lerpedSpec = spec1.lerp(spec2, t);

      expect(lerpedSpec.color, Color.lerp(Colors.red, Colors.blue, t));
      expect(lerpedSpec.size, lerpDouble(20.0, 30.0, t));
    });

    test('IconSpec.empty() constructor', () {
      const spec = IconSpec();

      expect(spec.color, isNull);
      expect(spec.size, isNull);
      expect(spec.weight, isNull);
      expect(spec.grade, isNull);
      expect(spec.opticalSize, isNull);
      expect(spec.shadows, isNull);
      expect(spec.textDirection, isNull);
      expect(spec.applyTextScaling, isNull);
      expect(spec.fill, isNull);
    });

    test('IconSpec.of(BuildContext context)', () {
      final mixData = MixData.create(
        MockBuildContext(),
        Style(IconSpecAttribute(size: 20.0, color: Colors.red.toDto())),
      );

      final spec = IconSpec.from(mixData);

      expect(spec.color, Colors.red);
      expect(spec.size, 20.0);
    });

    test('IconSpecTween lerp', () {
      const spec1 = IconSpec(color: Colors.red, size: 20.0);
      const spec2 = IconSpec(color: Colors.blue, size: 30.0);

      final tween = IconSpecTween(begin: spec1, end: spec2);

      final lerpedSpec = tween.lerp(0.5);
      expect(lerpedSpec.color, Color.lerp(Colors.red, Colors.blue, 0.5));
      expect(lerpedSpec.size, lerpDouble(20.0, 30.0, 0.5));
    });
  });

  group('IconSpecUtility fluent', () {
    test('fluent behavior', () {
      final icon = IconSpecUtility.self;

      final util = icon.chain
        ..color.red()
        ..size(24)
        ..weight(500)
        ..grade(200)
        ..opticalSize(48)
        ..textDirection.rtl()
        ..applyTextScaling(true)
        ..fill(0.5);

      final attr = util.attributeValue!;

      expect(util, isA<Attribute>());
      expect(attr.color, Colors.red.toDto());
      expect(attr.size, 24);
      expect(attr.weight, 500);
      expect(attr.grade, 200);
      expect(attr.opticalSize, 48);
      expect(attr.textDirection, TextDirection.rtl);
      expect(attr.applyTextScaling, true);
      expect(attr.fill, 0.5);

      final style = Style(util);

      final iconAttribute = style.styles.attributeOfType<IconSpecAttribute>();

      expect(iconAttribute?.color, Colors.red.toDto());
      expect(iconAttribute?.size, 24);
      expect(iconAttribute?.weight, 500);
      expect(iconAttribute?.grade, 200);
      expect(iconAttribute?.opticalSize, 48);
      expect(iconAttribute?.textDirection, TextDirection.rtl);
      expect(iconAttribute?.applyTextScaling, true);
      expect(iconAttribute?.fill, 0.5);

      final mixData = style.of(MockBuildContext());
      final iconSpec = IconSpec.from(mixData);

      expect(iconSpec.color, Colors.red);
      expect(iconSpec.size, 24);
      expect(iconSpec.weight, 500);
      expect(iconSpec.grade, 200);
      expect(iconSpec.opticalSize, 48);
      expect(iconSpec.textDirection, TextDirection.rtl);
      expect(iconSpec.applyTextScaling, true);
      expect(iconSpec.fill, 0.5);
    });

    test('Immutable behavior when having multiple icons', () {
      final iconUtil = IconSpecUtility.self;
      final icon1 = iconUtil.chain..size(24);
      final icon2 = iconUtil.chain..size(48);

      final attr1 = icon1.attributeValue!;
      final attr2 = icon2.attributeValue!;

      expect(attr1.size, 24);
      expect(attr2.size, 48);

      final style1 = Style(icon1);
      final style2 = Style(icon2);

      final iconAttribute1 = style1.styles.attributeOfType<IconSpecAttribute>();
      final iconAttribute2 = style2.styles.attributeOfType<IconSpecAttribute>();

      expect(iconAttribute1?.size, 24);
      expect(iconAttribute2?.size, 48);

      final mixData1 = style1.of(MockBuildContext());
      final mixData2 = style2.of(MockBuildContext());

      final iconSpec1 = IconSpec.from(mixData1);
      final iconSpec2 = IconSpec.from(mixData2);

      expect(iconSpec1.size, 24);
      expect(iconSpec2.size, 48);
    });

    test('Mutate behavior and not on same utility', () {
      final icon = IconSpecUtility.self;

      final iconValue = icon.chain;
      iconValue
        ..size(24)
        ..color.red()
        ..weight(500);

      final iconAttribute = iconValue.attributeValue!;
      final iconAttribute2 = icon.size(48);

      expect(iconAttribute.size, 24);
      expect(iconAttribute.color, Colors.red.toDto());
      expect(iconAttribute.weight, 500);

      expect(iconAttribute2.size, 48);
      expect(iconAttribute2.color, isNull);
      expect(iconAttribute2.weight, isNull);
    });
  });
}
