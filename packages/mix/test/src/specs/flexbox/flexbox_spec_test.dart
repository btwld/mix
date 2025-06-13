import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexBoxSpec', () {
    test('resolve', () {
      final mix = MixContext.create(
        MockBuildContext(),
        Style(
          FlexBoxSpecAttribute(
            box: BoxSpecAttribute(
              alignment: Alignment.center,
              padding: EdgeInsetsGeometryDto.only(top: 8, bottom: 16),
              margin: EdgeInsetsGeometryDto.only(top: 10.0, bottom: 12.0),
              constraints:
                  const BoxConstraintsDto(maxWidth: 300.0, minHeight: 200.0),
              decoration: const BoxDecorationDto(color: ColorDto(Colors.blue)),
              transform: Matrix4.translationValues(10.0, 10.0, 0.0),
              clipBehavior: Clip.antiAlias,
              width: 300,
              height: 200,
            ),
            flex: const FlexSpecAttribute(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              verticalDirection: VerticalDirection.down,
              textDirection: TextDirection.ltr,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ),
      );

      final spec = mix.attributeOf<FlexBoxSpecAttribute>()!.resolve(mix);

      expect(spec.box.alignment, Alignment.center);
      expect(spec.box.padding, const EdgeInsets.only(top: 8.0, bottom: 16.0));
      expect(spec.box.margin, const EdgeInsets.only(top: 10.0, bottom: 12.0));
      expect(
        spec.box.constraints,
        const BoxConstraints(maxWidth: 300.0, minHeight: 200.0),
      );
      expect(spec.box.decoration, const BoxDecoration(color: Colors.blue));
      expect(spec.box.transform, Matrix4.translationValues(10.0, 10.0, 0.0));
      expect(spec.box.clipBehavior, Clip.antiAlias);
      expect(spec.box.width, 300);
      expect(spec.box.height, 200);

      expect(spec.flex.mainAxisAlignment, MainAxisAlignment.center);
      expect(spec.flex.crossAxisAlignment, CrossAxisAlignment.center);
      expect(spec.flex.mainAxisSize, MainAxisSize.max);
      expect(spec.flex.verticalDirection, VerticalDirection.down);
      expect(spec.flex.textDirection, TextDirection.ltr);
      expect(spec.flex.textBaseline, TextBaseline.alphabetic);
    });

    test('copyWith', () {
      final spec = FlexBoxSpec(
        box: BoxSpec(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          constraints: const BoxConstraints(maxWidth: 300.0, minHeight: 200.0),
          decoration: const BoxDecoration(color: Colors.blue),
          transform: Matrix4.translationValues(10.0, 10.0, 0.0),
          clipBehavior: Clip.antiAlias,
          width: 300,
          height: 200,
        ),
        flex: const FlexSpec(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
        ),
      );

      final copiedSpec = spec.copyWith(
        box: spec.box.copyWith(
          width: 250.0,
          height: 150.0,
        ),
        flex: spec.flex.copyWith(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );

      expect(copiedSpec.box.alignment, Alignment.center);
      expect(copiedSpec.box.padding, const EdgeInsets.all(16.0));
      expect(
          copiedSpec.box.margin, const EdgeInsets.only(top: 8.0, bottom: 8.0));
      expect(copiedSpec.box.width, 250.0);
      expect(copiedSpec.box.height, 150.0);

      expect(copiedSpec.flex.mainAxisAlignment, MainAxisAlignment.start);
      expect(copiedSpec.flex.crossAxisAlignment, CrossAxisAlignment.start);
      expect(copiedSpec.flex.mainAxisSize, MainAxisSize.max);
      expect(copiedSpec.flex.verticalDirection, VerticalDirection.down);
      expect(copiedSpec.flex.textDirection, TextDirection.ltr);
      expect(copiedSpec.flex.textBaseline, TextBaseline.alphabetic);
    });

    test('lerp', () {
      final spec1 = FlexBoxSpec(
        box: BoxSpec(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(top: 4.0),
          constraints: const BoxConstraints(maxWidth: 200.0),
          decoration: const BoxDecoration(color: Colors.red),
          transform: Matrix4.identity(),
          clipBehavior: Clip.none,
          width: 300,
          height: 200,
        ),
        flex: const FlexSpec(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        ),
      );

      final spec2 = FlexBoxSpec(
        box: BoxSpec(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(top: 8.0),
          constraints: const BoxConstraints(maxWidth: 400.0),
          decoration: const BoxDecoration(color: Colors.blue),
          transform: Matrix4.rotationZ(0.5),
          clipBehavior: Clip.antiAlias,
          width: 400,
          height: 300,
        ),
        flex: const FlexSpec(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
        ),
      );

      const t = 0.5;
      final lerpedSpec = spec1.lerp(spec2, t);

      expect(
        lerpedSpec.box.alignment,
        Alignment.lerp(Alignment.topLeft, Alignment.bottomRight, t),
      );
      expect(
        lerpedSpec.box.padding,
        EdgeInsets.lerp(
          const EdgeInsets.all(8.0),
          const EdgeInsets.all(16.0),
          t,
        ),
      );
      expect(lerpedSpec.box.width, lerpDouble(300, 400, t));
      expect(lerpedSpec.box.height, lerpDouble(200, 300, t));

      expect(lerpedSpec.flex.mainAxisAlignment, MainAxisAlignment.end);
      expect(lerpedSpec.flex.crossAxisAlignment, CrossAxisAlignment.end);
      expect(lerpedSpec.flex.mainAxisSize, MainAxisSize.max);
    });

    test('equality', () {
      final spec1 = FlexBoxSpec(
        box: BoxSpec(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(top: 4.0),
          constraints: const BoxConstraints(maxWidth: 200.0),
          decoration: const BoxDecoration(color: Colors.red),
          transform: Matrix4.identity(),
          clipBehavior: Clip.none,
          width: 300,
          height: 200,
        ),
        flex: const FlexSpec(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        ),
      );

      final spec2 = FlexBoxSpec(
        box: BoxSpec(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(top: 4.0),
          constraints: const BoxConstraints(maxWidth: 200.0),
          decoration: const BoxDecoration(color: Colors.red),
          transform: Matrix4.identity(),
          clipBehavior: Clip.none,
          width: 300,
          height: 200,
        ),
        flex: const FlexSpec(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        ),
      );

      expect(spec1, spec2);
    });

    test('merge() returns correct instance', () {
      final flexBoxSpecAttribute = FlexBoxSpecAttribute(
        box: BoxSpecAttribute(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryDto.only(
              top: 20, bottom: 20, left: 20, right: 20),
          margin: EdgeInsetsGeometryDto.only(
            top: 10,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          constraints: const BoxConstraintsDto(maxHeight: 100),
          decoration: const BoxDecorationDto(color: ColorDto(Colors.blue)),
          transform: Matrix4.identity(),
          clipBehavior: Clip.antiAlias,
          width: 100,
          height: 100,
        ),
        flex: const FlexSpecAttribute(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
        ),
      );

      final mergedFlexBoxSpecAttribute = flexBoxSpecAttribute.merge(
        FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            alignment: Alignment.centerLeft,
            padding: EdgeInsetsGeometryDto.only(
                top: 30, bottom: 30, left: 30, right: 30),
            margin: EdgeInsetsGeometryDto.only(
              top: 20,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            constraints: const BoxConstraintsDto(maxHeight: 200),
            decoration: const BoxDecorationDto(color: ColorDto(Colors.red)),
            transform: Matrix4.identity(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: 200,
            height: 200,
          ),
          flex: const FlexSpecAttribute(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.up,
            textDirection: TextDirection.rtl,
            textBaseline: TextBaseline.ideographic,
          ),
        ),
      );

      expect(mergedFlexBoxSpecAttribute.box!.alignment, Alignment.centerLeft);
      expect(mergedFlexBoxSpecAttribute.box!.clipBehavior,
          Clip.antiAliasWithSaveLayer);
      expect(mergedFlexBoxSpecAttribute.box!.constraints,
          const BoxConstraintsDto(maxHeight: 200));
      expect(mergedFlexBoxSpecAttribute.box!.decoration,
          const BoxDecorationDto(color: ColorDto(Colors.red)));
      expect(mergedFlexBoxSpecAttribute.box!.height, 200);
      expect(
        mergedFlexBoxSpecAttribute.box!.margin,
        EdgeInsetsGeometryDto.only(top: 20, bottom: 20, left: 20, right: 20),
      );
      expect(
        mergedFlexBoxSpecAttribute.box!.padding,
        EdgeInsetsGeometryDto.only(top: 30, bottom: 30, left: 30, right: 30),
      );
      expect(mergedFlexBoxSpecAttribute.box!.transform, Matrix4.identity());
      expect(mergedFlexBoxSpecAttribute.box!.width, 200);

      expect(mergedFlexBoxSpecAttribute.flex!.mainAxisAlignment,
          MainAxisAlignment.start);
      expect(mergedFlexBoxSpecAttribute.flex!.crossAxisAlignment,
          CrossAxisAlignment.start);
      expect(mergedFlexBoxSpecAttribute.flex!.mainAxisSize, MainAxisSize.min);
      expect(mergedFlexBoxSpecAttribute.flex!.verticalDirection,
          VerticalDirection.up);
      expect(mergedFlexBoxSpecAttribute.flex!.textDirection, TextDirection.rtl);
      expect(mergedFlexBoxSpecAttribute.flex!.textBaseline,
          TextBaseline.ideographic);
    });
  });

  group('FlexBoxSpecUtility fluent', () {
    test('fluent behavior', () {
      final flexBox = FlexBoxSpecUtility.self;

      final util = flexBox
        ..box.alignment.center()
        ..box.padding(8)
        ..flex.mainAxisAlignment.center()
        ..flex.crossAxisAlignment.center();

      final attr = util.attributeValue!;

      expect(util, isA<StyleElement>());
      expect(attr.box!.alignment, Alignment.center);
      expect(attr.box!.padding, const EdgeInsets.all(8.0).toDto());
      expect(attr.box!.margin, null);
      expect(attr.flex!.mainAxisAlignment, MainAxisAlignment.center);
      expect(attr.flex!.crossAxisAlignment, CrossAxisAlignment.center);

      final style = Style(util);

      final flexBoxAttribute =
          style.styles.attributeOfType<FlexBoxSpecAttribute>();

      expect(flexBoxAttribute?.box!.alignment, Alignment.center);
      expect(flexBoxAttribute?.box!.padding, const EdgeInsets.all(8.0).toDto());
      expect(flexBoxAttribute?.box!.margin, null);
      expect(
          flexBoxAttribute?.flex!.mainAxisAlignment, MainAxisAlignment.center);
      expect(flexBoxAttribute?.flex!.crossAxisAlignment,
          CrossAxisAlignment.center);

      final mixData = style.of(MockBuildContext());
      final flexBoxSpec = FlexBoxSpec.from(mixData);

      expect(flexBoxSpec.box.alignment, Alignment.center);
      expect(flexBoxSpec.box.padding, const EdgeInsets.all(8.0));
      expect(flexBoxSpec.box.margin, null);
      expect(flexBoxSpec.flex.mainAxisAlignment, MainAxisAlignment.center);
      expect(flexBoxSpec.flex.crossAxisAlignment, CrossAxisAlignment.center);
    });

    test('Immutable behavior when having multiple flexboxes', () {
      final flexBoxUtil = FlexBoxSpecUtility.self;
      final flexBox1 = flexBoxUtil.chain
        ..box.padding(10)
        ..flex.mainAxisAlignment.start();
      final flexBox2 = flexBoxUtil.chain
        ..box.padding(20)
        ..flex.mainAxisAlignment.end();

      final attr1 = flexBox1.attributeValue!;
      final attr2 = flexBox2.attributeValue!;

      expect(attr1.box!.padding, const EdgeInsets.all(10.0).toDto());
      expect(attr2.box!.padding, const EdgeInsets.all(20.0).toDto());
      expect(attr1.flex!.mainAxisAlignment, MainAxisAlignment.start);
      expect(attr2.flex!.mainAxisAlignment, MainAxisAlignment.end);

      final style1 = Style(flexBox1);
      final style2 = Style(flexBox2);

      final flexBoxAttribute1 =
          style1.styles.attributeOfType<FlexBoxSpecAttribute>();
      final flexBoxAttribute2 =
          style2.styles.attributeOfType<FlexBoxSpecAttribute>();

      expect(
          flexBoxAttribute1?.box!.padding, const EdgeInsets.all(10.0).toDto());
      expect(
          flexBoxAttribute2?.box!.padding, const EdgeInsets.all(20.0).toDto());
      expect(
          flexBoxAttribute1?.flex!.mainAxisAlignment, MainAxisAlignment.start);
      expect(flexBoxAttribute2?.flex!.mainAxisAlignment, MainAxisAlignment.end);

      final mixData1 = style1.of(MockBuildContext());
      final mixData2 = style2.of(MockBuildContext());

      final flexBoxSpec1 = FlexBoxSpec.from(mixData1);
      final flexBoxSpec2 = FlexBoxSpec.from(mixData2);

      expect(flexBoxSpec1.box.padding, const EdgeInsets.all(10.0));
      expect(flexBoxSpec2.box.padding, const EdgeInsets.all(20.0));
      expect(flexBoxSpec1.flex.mainAxisAlignment, MainAxisAlignment.start);
      expect(flexBoxSpec2.flex.mainAxisAlignment, MainAxisAlignment.end);
    });

    test('Mutate behavior and not on same utility', () {
      final flexBox = FlexBoxSpecUtility.self;

      final flexBoxValue = flexBox;
      flexBoxValue
        ..box.padding(10)
        ..box.color.red()
        ..box.alignment.center()
        ..flex.mainAxisAlignment.center()
        ..flex.crossAxisAlignment.center();

      final flexBoxAttribute = flexBoxValue.attributeValue!;
      final flexBoxAttribute2 = flexBox.box.padding(20);

      expect(flexBoxAttribute.box!.padding, const EdgeInsets.all(10.0).toDto());
      expect(
        (flexBoxAttribute.box!.decoration as BoxDecorationDto).color,
        const ColorDto(Colors.red),
      );
      expect(flexBoxAttribute.box!.alignment, Alignment.center);
      expect(
          flexBoxAttribute.flex!.mainAxisAlignment, MainAxisAlignment.center);
      expect(
          flexBoxAttribute.flex!.crossAxisAlignment, CrossAxisAlignment.center);

      expect(
          flexBoxAttribute2.box!.padding, const EdgeInsets.all(20.0).toDto());
      expect((flexBoxAttribute2.box!.decoration as BoxDecorationDto?)?.color,
          isNull);
      expect(flexBoxAttribute2.box!.alignment, isNull);
    });
  });
}
