import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexSpec', () {
    test('resolve', () {
      final mix = MixContext.create(
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
            gap: SpaceDto.value(10),
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

    test('copyWith', () {
      const spec = FlexSpec(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        direction: Axis.horizontal,
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.alphabetic,
        clipBehavior: Clip.antiAlias,
        gap: 10,
      );

      final copiedSpec = spec.copyWith(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.up,
        textDirection: TextDirection.rtl,
        textBaseline: TextBaseline.ideographic,
        clipBehavior: Clip.none,
        gap: 20,
      );

      expect(copiedSpec.crossAxisAlignment, CrossAxisAlignment.start);
      expect(copiedSpec.mainAxisAlignment, MainAxisAlignment.end);
      expect(copiedSpec.mainAxisSize, MainAxisSize.max);
      expect(copiedSpec.verticalDirection, VerticalDirection.up);
      expect(copiedSpec.direction, Axis.vertical);
      expect(copiedSpec.textDirection, TextDirection.rtl);
      expect(copiedSpec.textBaseline, TextBaseline.ideographic);
      expect(copiedSpec.clipBehavior, Clip.none);
      expect(copiedSpec.gap, 20);

      expect(copiedSpec, isNot(spec));
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
      expect(lerpedSpec.gap, MixHelpers.lerpDouble(spec1.gap, spec2.gap, t));

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

      final util = flex
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
      expect(util, isA<Style>());
      expect(attr.direction, Axis.horizontal);
      expect(attr.mainAxisAlignment, MainAxisAlignment.center);
      expect(attr.crossAxisAlignment, CrossAxisAlignment.center);
      expect(attr.mainAxisSize, MainAxisSize.min);
      expect(attr.verticalDirection, VerticalDirection.down);
      expect(attr.textDirection, TextDirection.ltr);
      expect(attr.textBaseline, TextBaseline.alphabetic);
      expect(attr.clipBehavior, Clip.antiAlias);
      expect(attr.gap, resolvesTo(10));

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
      expect(flexAttribute?.gap, resolvesTo(10));

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
      final flex1 = FlexSpecUtility((v) => v)..gap(10);
      final flex2 = FlexSpecUtility((v) => v)..gap(20);

      final attr1 = flex1.attributeValue!;
      final attr2 = flex2.attributeValue!;

      expect(attr1.gap, resolvesTo(10));
      expect(attr2.gap, resolvesTo(20));

      final attr3 = attr1.merge(attr2);

      final style1 = Style(flex1);
      final style2 = Style(flex2);
      final style3 = Style(attr3);

      final flexAttribute1 = style1.styles.attributeOfType<FlexSpecAttribute>();
      final flexAttribute2 = style2.styles.attributeOfType<FlexSpecAttribute>();
      final flexAttribute3 = style3.styles.attributeOfType<FlexSpecAttribute>();

      expect(flexAttribute1?.gap, resolvesTo(10));
      expect(flexAttribute2?.gap, resolvesTo(20));
      expect(flexAttribute3?.gap, resolvesTo(20));

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

      final flexValue = flex;
      flexValue
        ..gap(10)
        ..direction.horizontal()
        ..mainAxisAlignment.center();

      final flexAttribute = flexValue.attributeValue!;
      final flexAttribute2 = flex.gap(20);

      expect(flexAttribute.gap, resolvesTo(10));
      expect(flexAttribute.direction, Axis.horizontal);
      expect(flexAttribute.mainAxisAlignment, MainAxisAlignment.center);

      expect(flexAttribute2.gap, resolvesTo(20));
      expect(flexAttribute2.direction, isNull);
      expect(flexAttribute2.mainAxisAlignment, isNull);
    });
  });
}
