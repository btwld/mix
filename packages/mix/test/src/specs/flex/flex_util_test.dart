import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexUtility', () {
    final flexUtility = FlexSpecUtility(MixUtility.selfBuilder);
    test('call() returns correct instance', () {
      final flex = flexUtility.only(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
      );

      expect(flex.direction, Axis.horizontal);
      expect(flex.mainAxisAlignment, MainAxisAlignment.center);
      expect(flex.crossAxisAlignment, CrossAxisAlignment.center);
      expect(flex.mainAxisSize, MainAxisSize.max);
    });

    // direction()
    test('direction() returns correct instance', () {
      final flex = flexUtility.direction(Axis.horizontal);

      expect(flex.direction, Axis.horizontal);
    });

    // mainAxisAlignment()
    test('mainAxisAlignment() returns correct instance', () {
      final flex = flexUtility.mainAxisAlignment(MainAxisAlignment.center);

      expect(flex.mainAxisAlignment, MainAxisAlignment.center);
    });

    // crossAxisAlignment()
    test('crossAxisAlignment() returns correct instance', () {
      final flex = flexUtility.crossAxisAlignment(CrossAxisAlignment.center);

      expect(flex.crossAxisAlignment, CrossAxisAlignment.center);
    });

    // mainAxisSize()
    test('mainAxisSize() returns correct instance', () {
      final flex = flexUtility.mainAxisSize(MainAxisSize.max);
      final helper = flexUtility.mainAxisSize.max();

      expect(flex.mainAxisSize, MainAxisSize.max);
      expect(helper.mainAxisSize, MainAxisSize.max);
    });

    // verticalDirection()
    test('verticalDirection() returns correct instance', () {
      final flex = flexUtility.verticalDirection(VerticalDirection.down);
      final helper = flexUtility.verticalDirection.down();

      expect(flex.verticalDirection, VerticalDirection.down);
      expect(helper.verticalDirection, VerticalDirection.down);
    });

    // textDirection()
    test('textDirection() returns correct instance', () {
      final flex = flexUtility.textDirection(TextDirection.ltr);
      final helper = flexUtility.textDirection.ltr();

      expect(flex.textDirection, TextDirection.ltr);
      expect(helper.textDirection, TextDirection.ltr);
    });

    // textBaseline()
    test('textBaseline() returns correct instance', () {
      final flex = flexUtility.textBaseline(TextBaseline.alphabetic);
      final helper = flexUtility.textBaseline.alphabetic();

      expect(flex.textBaseline, TextBaseline.alphabetic);
      expect(helper.textBaseline, TextBaseline.alphabetic);
    });

    // clipBehavior()
    test('clipBehavior() returns correct instance', () {
      final flex = flexUtility.clipBehavior(Clip.antiAlias);
      final helper = flexUtility.clipBehavior.antiAlias();

      expect(flex.clipBehavior, Clip.antiAlias);
      expect(helper.clipBehavior, Clip.antiAlias);
    });

    // gap()
    test('gap() returns correct instance', () {
      final flex = flexUtility.gap(10);

      expect(flex.gap, const SpaceDto.value(10));
    });

    // row()
    test('row() returns correct instance', () {
      final flex = flexUtility.row();

      expect(flex.direction, Axis.horizontal);
    });

    // column()
    test('column() returns correct instance', () {
      final flex = flexUtility.column();

      expect(flex.direction, Axis.vertical);
    });
  });

  group('FlexSpecUtility fluent', () {
    test('fluent behavior', () {
      final flex = FlexSpecUtility.self;

      final util = flex
        ..crossAxisAlignment.center()
        ..mainAxisAlignment.spaceBetween()
        ..mainAxisSize.min()
        ..verticalDirection.down()
        ..direction.horizontal()
        ..textDirection.ltr()
        ..textBaseline.alphabetic()
        ..clipBehavior.antiAlias()
        ..gap(10);

      final attr = util.attribute;

      expect(util, isA<Style>());
      expect(attr.crossAxisAlignment, CrossAxisAlignment.center);
      expect(attr.mainAxisAlignment, MainAxisAlignment.spaceBetween);
      expect(attr.mainAxisSize, MainAxisSize.min);
      expect(attr.verticalDirection, VerticalDirection.down);
      expect(attr.direction, Axis.horizontal);
      expect(attr.textDirection, TextDirection.ltr);
      expect(attr.textBaseline, TextBaseline.alphabetic);
      expect(attr.clipBehavior, Clip.antiAlias);
      expect(attr.gap, const SpaceDto.value(10));

      final style = Style(util);

      final flexAttribute = style.styles.attributeOfType<FlexSpecAttribute>();

      expect(flexAttribute?.crossAxisAlignment, CrossAxisAlignment.center);
      expect(flexAttribute?.mainAxisAlignment, MainAxisAlignment.spaceBetween);
      expect(flexAttribute?.mainAxisSize, MainAxisSize.min);
      expect(flexAttribute?.verticalDirection, VerticalDirection.down);
      expect(flexAttribute?.direction, Axis.horizontal);
      expect(flexAttribute?.textDirection, TextDirection.ltr);
      expect(flexAttribute?.textBaseline, TextBaseline.alphabetic);
      expect(flexAttribute?.clipBehavior, Clip.antiAlias);
      expect(flexAttribute?.gap, const SpaceDto.value(10));

      final mixData = style.of(MockBuildContext());
      final flexSpec = FlexSpec.from(mixData);

      expect(flexSpec.crossAxisAlignment, CrossAxisAlignment.center);
      expect(flexSpec.mainAxisAlignment, MainAxisAlignment.spaceBetween);
      expect(flexSpec.mainAxisSize, MainAxisSize.min);
      expect(flexSpec.verticalDirection, VerticalDirection.down);
      expect(flexSpec.direction, Axis.horizontal);
      expect(flexSpec.textDirection, TextDirection.ltr);
      expect(flexSpec.textBaseline, TextBaseline.alphabetic);
      expect(flexSpec.clipBehavior, Clip.antiAlias);
      expect(flexSpec.gap, 10);
    });

    test('Immutable behavior when having multiple flex', () {
      final flex1 = FlexSpecUtility.self..crossAxisAlignment.start();
      final flex2 = FlexSpecUtility.self..crossAxisAlignment.end();

      final attr1 = flex1.attribute;
      final attr2 = flex2.attribute;

      expect(attr1.crossAxisAlignment, CrossAxisAlignment.start);
      expect(attr2.crossAxisAlignment, CrossAxisAlignment.end);

      final style1 = Style(flex1);
      final style2 = Style(flex2);

      final flexAttribute1 = style1.styles.attributeOfType<FlexSpecAttribute>();
      final flexAttribute2 = style2.styles.attributeOfType<FlexSpecAttribute>();

      expect(flexAttribute1?.crossAxisAlignment, CrossAxisAlignment.start);
      expect(flexAttribute2?.crossAxisAlignment, CrossAxisAlignment.end);

      final mixData1 = style1.of(MockBuildContext());
      final mixData2 = style2.of(MockBuildContext());

      final flexSpec1 = FlexSpec.from(mixData1);
      final flexSpec2 = FlexSpec.from(mixData2);

      expect(flexSpec1.crossAxisAlignment, CrossAxisAlignment.start);
      expect(flexSpec2.crossAxisAlignment, CrossAxisAlignment.end);
    });

    test('Mutate behavior and not on same utility', () {
      final flex = FlexSpecUtility.self;

      final flexValue = flex;
      flexValue
        ..crossAxisAlignment.center()
        ..mainAxisAlignment.spaceBetween()
        ..mainAxisSize.min();

      final flexAttribute = flexValue.attribute;
      final flexAttribute2 = flex.crossAxisAlignment.end();

      expect(flexAttribute.crossAxisAlignment, CrossAxisAlignment.center);
      expect(flexAttribute.mainAxisAlignment, MainAxisAlignment.spaceBetween);
      expect(flexAttribute.mainAxisSize, MainAxisSize.min);

      expect(flexAttribute2.crossAxisAlignment, CrossAxisAlignment.end);
      expect(flexAttribute2.mainAxisAlignment, isNull);
      expect(flexAttribute2.mainAxisSize, isNull);
    });
  });
}
