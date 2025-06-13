import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexSpec', () {
    group('FlexSpec comprehensive', () {
      test('constructor with all properties', () {
        const spec = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.up,
          textDirection: TextDirection.rtl,
          textBaseline: TextBaseline.ideographic,
          clipBehavior: Clip.antiAlias,
          gap: 16,
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
        expect(spec.direction, Axis.horizontal);
        expect(spec.mainAxisAlignment, MainAxisAlignment.spaceBetween);
        expect(spec.crossAxisAlignment, CrossAxisAlignment.stretch);
        expect(spec.mainAxisSize, MainAxisSize.min);
        expect(spec.verticalDirection, VerticalDirection.up);
        expect(spec.textDirection, TextDirection.rtl);
        expect(spec.textBaseline, TextBaseline.ideographic);
        expect(spec.clipBehavior, Clip.antiAlias);
        expect(spec.gap, 16);
        expect(spec.animated?.duration, const Duration(milliseconds: 300));
        expect(spec.animated?.curve, Curves.easeInOut);
        expect(spec.modifiers?.value, [
          const OpacityModifierSpec(0.8),
          const SizedBoxModifierSpec(width: 100, height: 100),
        ]);
      });

      test('call method creates correct widget', () {
        const spec = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
        );

        final widget = spec.call(
          direction: Axis.horizontal,
          children: [
            const Text('Child 1'),
            const Text('Child 2'),
          ],
        );

        expect(widget, isA<FlexSpecWidget>());
      });

      test('call method creates animated widget when animated', () {
        const spec = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          animated: AnimatedData(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        );

        final widget = spec.call(
          direction: Axis.horizontal,
          children: [
            const Text('Child 1'),
            const Text('Child 2'),
          ],
        );

        expect(widget, isA<AnimatedFlexSpecWidget>());
      });

      test('debugFillProperties includes all properties', () {
        const spec = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          gap: 16,
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
          const FlexSpecAttribute(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            textDirection: TextDirection.ltr,
            textBaseline: TextBaseline.alphabetic,
            clipBehavior: Clip.antiAlias,
            gap: SpaceDto(10),
          ),
        ),
      );

      final spec = FlexSpec.from(mix);

      expect(spec.crossAxisAlignment, CrossAxisAlignment.center);
      expect(spec.mainAxisAlignment, MainAxisAlignment.center);
      expect(spec.mainAxisSize, MainAxisSize.min);
      expect(spec.verticalDirection, VerticalDirection.down);
      expect(spec.direction, Axis.horizontal);
      expect(spec.textDirection, TextDirection.ltr);
      expect(spec.textBaseline, TextBaseline.alphabetic);
      expect(spec.clipBehavior, Clip.antiAlias);
      expect(spec.gap, 10);
    });

    test('copyWith updates correctly and preserves unchanged properties', () {
      const original = FlexSpec(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.alphabetic,
        clipBehavior: Clip.antiAlias,
        gap: 8,
      );

      final updated = original.copyWith(
        direction: Axis.horizontal,
        gap: 16,
        // Don't update other properties - test preservation
      );

      // Test updated properties
      expect(updated.direction, Axis.horizontal);
      expect(updated.gap, 16);

      // Test preserved properties
      expect(updated.mainAxisAlignment, MainAxisAlignment.start);
      expect(updated.crossAxisAlignment, CrossAxisAlignment.center);
      expect(updated.mainAxisSize, MainAxisSize.min);
      expect(updated.verticalDirection, VerticalDirection.down);
      expect(updated.textDirection, TextDirection.ltr);
      expect(updated.textBaseline, TextBaseline.alphabetic);
      expect(updated.clipBehavior, Clip.antiAlias);

      expect(updated, isNot(original));
    });

    test('lerp', () {
      const spec1 = FlexSpec(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        direction: Axis.horizontal,
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.alphabetic,
        clipBehavior: Clip.none,
        gap: 10,
      );

      const spec2 = FlexSpec(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.up,
        direction: Axis.vertical,
        textDirection: TextDirection.rtl,
        textBaseline: TextBaseline.ideographic,
        clipBehavior: Clip.antiAlias,
        gap: 20,
      );

      const t = 0.5;
      final lerpedSpec = spec1.lerp(spec2, t);

      expect(lerpedSpec.crossAxisAlignment, CrossAxisAlignment.end);
      expect(lerpedSpec.mainAxisAlignment, MainAxisAlignment.end);
      expect(lerpedSpec.mainAxisSize, MainAxisSize.max);
      expect(lerpedSpec.verticalDirection, VerticalDirection.up);
      expect(lerpedSpec.direction, Axis.vertical);
      expect(lerpedSpec.textDirection, TextDirection.rtl);
      expect(lerpedSpec.textBaseline, TextBaseline.ideographic);
      expect(lerpedSpec.clipBehavior, Clip.antiAlias);
      expect(lerpedSpec.gap, lerpDouble(spec1.gap, spec2.gap, t));

      expect(lerpedSpec, isNot(spec1));
    });

    // equality
    test('equality', () {
      const spec1 = FlexSpec(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        direction: Axis.horizontal,
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.alphabetic,
        clipBehavior: Clip.none,
        gap: 10,
      );

      const spec2 = FlexSpec(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        direction: Axis.horizontal,
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.alphabetic,
        clipBehavior: Clip.none,
        gap: 10,
      );

      const spec3 = FlexSpec(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.up,
        direction: Axis.vertical,
        textDirection: TextDirection.rtl,
        textBaseline: TextBaseline.ideographic,
        clipBehavior: Clip.antiAlias,
        gap: 20,
      );

      expect(spec1, spec2);
      expect(spec1, isNot(spec3));
    });
  });

  group('FlexSpecUtility fluent', () {
    test('fluent behavior', () {
      final flex = FlexSpecUtility.self;

      final util = flex.chain
        ..direction.horizontal()
        ..mainAxisAlignment.center()
        ..crossAxisAlignment.center()
        ..mainAxisSize.min()
        ..verticalDirection.down()
        ..textDirection.ltr()
        ..textBaseline.alphabetic()
        ..clipBehavior.antiAlias()
        ..gap(10);

      final attr = util.attributeValue!;
      expect(util, isA<Attribute>());
      expect(attr.direction, Axis.horizontal);
      expect(attr.mainAxisAlignment, MainAxisAlignment.center);
      expect(attr.crossAxisAlignment, CrossAxisAlignment.center);
      expect(attr.mainAxisSize, MainAxisSize.min);
      expect(attr.verticalDirection, VerticalDirection.down);
      expect(attr.textDirection, TextDirection.ltr);
      expect(attr.textBaseline, TextBaseline.alphabetic);
      expect(attr.clipBehavior, Clip.antiAlias);
      expect(attr.gap, const SpaceDto(10));

      final style = Style(util);
      final flexAttribute = style.styles.attributeOfType<FlexSpecAttribute>();
      expect(flexAttribute?.direction, Axis.horizontal);
      expect(flexAttribute?.mainAxisAlignment, MainAxisAlignment.center);
      expect(flexAttribute?.crossAxisAlignment, CrossAxisAlignment.center);
      expect(flexAttribute?.mainAxisSize, MainAxisSize.min);
      expect(flexAttribute?.verticalDirection, VerticalDirection.down);
      expect(flexAttribute?.textDirection, TextDirection.ltr);
      expect(flexAttribute?.textBaseline, TextBaseline.alphabetic);
      expect(flexAttribute?.clipBehavior, Clip.antiAlias);
      expect(flexAttribute?.gap, const SpaceDto(10));

      final mixData = style.of(MockBuildContext());
      final flexSpec = FlexSpec.from(mixData);
      expect(flexSpec.direction, Axis.horizontal);
      expect(flexSpec.mainAxisAlignment, MainAxisAlignment.center);
      expect(flexSpec.crossAxisAlignment, CrossAxisAlignment.center);
      expect(flexSpec.mainAxisSize, MainAxisSize.min);
      expect(flexSpec.verticalDirection, VerticalDirection.down);
      expect(flexSpec.textDirection, TextDirection.ltr);
      expect(flexSpec.textBaseline, TextBaseline.alphabetic);
      expect(flexSpec.clipBehavior, Clip.antiAlias);
      expect(flexSpec.gap, 10);
    });

    test('Immutable behavior when having multiple flexes', () {
      final flexUtil = FlexSpecUtility.self;
      final flex1 = flexUtil.chain..gap(10);
      final flex2 = flexUtil.chain..gap(20);

      final attr1 = flex1.attributeValue!;
      final attr2 = flex2.attributeValue!;

      expect(attr1.gap, const SpaceDto(10));
      expect(attr2.gap, const SpaceDto(20));

      final attr3 = attr1.merge(attr2);

      final style1 = Style(flex1);
      final style2 = Style(flex2);
      final style3 = Style(attr3);

      final flexAttribute1 = style1.styles.attributeOfType<FlexSpecAttribute>();
      final flexAttribute2 = style2.styles.attributeOfType<FlexSpecAttribute>();
      final flexAttribute3 = style3.styles.attributeOfType<FlexSpecAttribute>();

      expect(flexAttribute1?.gap, const SpaceDto(10));
      expect(flexAttribute2?.gap, const SpaceDto(20));
      expect(flexAttribute3?.gap, const SpaceDto(20));

      final mixData1 = style1.of(MockBuildContext());
      final mixData2 = style2.of(MockBuildContext());
      final mixData3 = style3.of(MockBuildContext());

      final flexSpec1 = FlexSpec.from(mixData1);
      final flexSpec2 = FlexSpec.from(mixData2);
      final flexSpec3 = FlexSpec.from(mixData3);

      expect(flexSpec1.gap, 10);
      expect(flexSpec2.gap, 20);
      expect(flexSpec3.gap, 20);
    });

    test('Mutate behavior and not on same utility', () {
      final flex = FlexSpecUtility.self;

      final flexValue = flex.chain;
      flexValue
        ..gap(10)
        ..direction.horizontal()
        ..mainAxisAlignment.center();

      final flexAttribute = flexValue.attributeValue!;
      final flexAttribute2 = flex.gap(20);

      expect(flexAttribute.gap, const SpaceDto(10));
      expect(flexAttribute.direction, Axis.horizontal);
      expect(flexAttribute.mainAxisAlignment, MainAxisAlignment.center);

      expect(flexAttribute2.gap, const SpaceDto(20));
      expect(flexAttribute2.direction, isNull);
      expect(flexAttribute2.mainAxisAlignment, isNull);
    });
  });
}
