import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('IconSpec', () {
    group('IconSpec comprehensive', () {
      test('constructor with all properties', () {
        const spec = IconSpec(
          color: Colors.blue,
          size: 24.0,
          weight: 400.0,
          grade: 0.0,
          opticalSize: 24.0,
          shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
          textDirection: TextDirection.ltr,
          applyTextScaling: true,
          fill: 1.0,
          animated: AnimatedData(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          modifiers: WidgetModifiersData([
            OpacityModifierSpec(0.8),
            SizedBoxModifierSpec(width: 50, height: 50),
          ]),
        );

        // Test ALL properties are set correctly
        expect(spec.color, Colors.blue);
        expect(spec.size, 24.0);
        expect(spec.weight, 400.0);
        expect(spec.grade, 0.0);
        expect(spec.opticalSize, 24.0);
        expect(spec.shadows,
            [const Shadow(color: Colors.black, offset: Offset(1, 1))]);
        expect(spec.textDirection, TextDirection.ltr);
        expect(spec.applyTextScaling, true);
        expect(spec.fill, 1.0);
        expect(spec.animated?.duration, const Duration(milliseconds: 300));
        expect(spec.animated?.curve, Curves.easeInOut);
        expect(spec.modifiers?.value, [
          const OpacityModifierSpec(0.8),
          const SizedBoxModifierSpec(width: 50, height: 50),
        ]);
      });

      test('call method creates correct widget', () {
        const spec = IconSpec(
          color: Colors.blue,
          size: 24.0,
        );

        final widget = spec.call(Icons.star);

        expect(widget, isA<IconSpecWidget>());
      });

      test('call method creates animated widget when animated', () {
        const spec = IconSpec(
          color: Colors.blue,
          size: 24.0,
          animated: AnimatedData(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        );

        final widget = spec.call(Icons.star);

        expect(widget, isA<AnimatedIconSpecWidget>());
      });

      test('debugFillProperties includes all properties', () {
        const spec = IconSpec(
          color: Colors.blue,
          size: 24.0,
          weight: 400.0,
          grade: 0.0,
        );

        final builder = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties, isNotEmpty);
      });
    });
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

    test('copyWith updates correctly and preserves unchanged properties', () {
      const original = IconSpec(
        color: Colors.red,
        size: 20.0,
        weight: 300.0,
        grade: -1.0,
      );

      final updated = original.copyWith(
        color: Colors.blue,
        size: 24.0,
        // Don't update weight and grade - test preservation
      );

      // Test updated properties
      expect(updated.color, Colors.blue);
      expect(updated.size, 24.0);

      // Test preserved properties
      expect(updated.weight, 300.0);
      expect(updated.grade, -1.0);
    });

    test('lerp', () {
      const spec1 = IconSpec(color: Colors.red, size: 20.0);

      const spec2 = IconSpec(color: Colors.blue, size: 30.0);

      const t = 0.5;
      final lerpedSpec = spec1.lerp(spec2, t);

      expect(lerpedSpec.color, Color.lerp(Colors.red, Colors.blue, t));
      expect(lerpedSpec.size, lerpDouble(20.0, 30.0, t));
    });

    test('equality operator works correctly', () {
      const spec1 = IconSpec(
        color: Colors.red,
        size: 20.0,
        weight: 300.0,
        grade: -1.0,
      );

      const spec2 = IconSpec(
        color: Colors.red,
        size: 20.0,
        weight: 300.0,
        grade: -1.0,
      );

      const spec3 = IconSpec(
        color: Colors.blue,
        size: 24.0,
        weight: 400.0,
        grade: 0.0,
      );

      expect(spec1, spec2);
      expect(spec1, isNot(spec3));
      expect(spec2, isNot(spec3));
    });

    test('props returns correct list of properties', () {
      const spec = IconSpec(
        color: Colors.red,
        size: 24.0,
        weight: 400.0,
        grade: 0.0,
        opticalSize: 24.0,
        shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
        textDirection: TextDirection.ltr,
        applyTextScaling: true,
        fill: 1.0,
        animated: AnimatedData.withDefaults(),
      );

      expect(spec.props.length,
          11); // All properties including animated and modifiers
      expect(spec.props.contains(spec.color), true);
      expect(spec.props.contains(spec.size), true);
      expect(spec.props.contains(spec.weight), true);
      expect(spec.props.contains(spec.grade), true);
      expect(spec.props.contains(spec.opticalSize), true);
      expect(spec.props.contains(spec.shadows), true);
      expect(spec.props.contains(spec.textDirection), true);
      expect(spec.props.contains(spec.applyTextScaling), true);
      expect(spec.props.contains(spec.fill), true);
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

    test('IconSpec.from(MixData) resolves correctly', () {
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
