import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxSpec', () {
    group('BoxSpec comprehensive', () {
      test('constructor with all properties', () {
        final spec = BoxSpec(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          constraints: const BoxConstraints(maxWidth: 400.0, minHeight: 200.0),
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          foregroundDecoration: const BoxDecoration(
            color: Colors.red,
            border: Border.fromBorderSide(
                BorderSide(color: Colors.black, width: 2.0)),
          ),
          transform: Matrix4.rotationZ(0.1),
          transformAlignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          width: 300.0,
          height: 200.0,
          animated: const AnimatedData(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          modifiers: const WidgetModifiersData([
            OpacityModifierSpec(0.8),
            SizedBoxModifierSpec(width: 100, height: 100),
          ]),
        );

        // Test ALL properties are set correctly
        expect(spec.alignment, Alignment.bottomRight);
        expect(spec.padding, const EdgeInsets.all(16.0));
        expect(spec.margin,
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0));
        expect(spec.constraints,
            const BoxConstraints(maxWidth: 400.0, minHeight: 200.0));
        expect(spec.decoration, isA<BoxDecoration>());
        expect(spec.foregroundDecoration, isA<BoxDecoration>());
        expect(spec.transform, isA<Matrix4>());
        expect(spec.transformAlignment, Alignment.center);
        expect(spec.clipBehavior, Clip.antiAlias);
        expect(spec.width, 300.0);
        expect(spec.height, 200.0);
        expect(spec.animated?.duration, const Duration(milliseconds: 300));
        expect(spec.animated?.curve, Curves.easeInOut);
        expect(spec.modifiers?.value, [
          const OpacityModifierSpec(0.8),
          const SizedBoxModifierSpec(width: 100, height: 100),
        ]);
      });

      test('call method creates correct widget', () {
        const spec = BoxSpec(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
        );

        final widget = spec.call(child: const Text('Child'));

        expect(widget, isA<BoxSpecWidget>());
      });

      test('call method creates animated widget when animated', () {
        const spec = BoxSpec(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          animated: AnimatedData(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        );

        final widget = spec.call(child: const Text('Child'));

        expect(widget, isA<AnimatedBoxSpecWidget>());
      });

      test('debugFillProperties includes all properties', () {
        const spec = BoxSpec(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          width: 100.0,
          height: 100.0,
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
          BoxSpecAttribute(
            alignment: Alignment.center,
            padding: EdgeInsetsGeometryDto.only(top: 8, bottom: 16),
            margin: EdgeInsetsGeometryDto.only(top: 10.0, bottom: 12.0),
            constraints:
                const BoxConstraintsDto(maxWidth: 300.0, minHeight: 200.0),
            decoration: const BoxDecorationDto(color: ColorDto(Colors.blue)),
            transform: Matrix4.translationValues(10.0, 10.0, 0.0),
            clipBehavior: Clip.antiAlias,
            modifiers: const WidgetModifiersDataDto([
              OpacityModifierSpecAttribute(opacity: 1),
              SizedBoxModifierSpecAttribute(height: 10, width: 10),
            ]),
            width: 300,
            height: 200,
          ),
        ),
      );

      final spec = mix.attributeOf<BoxSpecAttribute>()!.resolve(mix);

      expect(spec.alignment, Alignment.center);
      expect(spec.padding, const EdgeInsets.only(top: 8.0, bottom: 16.0));
      expect(spec.margin, const EdgeInsets.only(top: 10.0, bottom: 12.0));
      expect(
        spec.constraints,
        const BoxConstraints(maxWidth: 300.0, minHeight: 200.0),
      );
      expect(spec.decoration, const BoxDecoration(color: Colors.blue));

      expect(spec.transform, Matrix4.translationValues(10.0, 10.0, 0.0));
      expect(spec.modifiers!.value, [
        const OpacityModifierSpec(1),
        const SizedBoxModifierSpec(height: 10, width: 10),
      ]);
      expect(spec.clipBehavior, Clip.antiAlias);
    });

    test('copyWith updates correctly and preserves unchanged properties', () {
      const original = BoxSpec(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        width: 100.0,
        height: 100.0,
        clipBehavior: Clip.antiAlias,
      );

      final updated = original.copyWith(
        alignment: Alignment.topLeft,
        width: 200.0,
        // Don't update padding, height, clipBehavior - test preservation
      );

      // Test updated properties
      expect(updated.alignment, Alignment.topLeft);
      expect(updated.width, 200.0);

      // Test preserved properties
      expect(updated.padding, const EdgeInsets.all(8.0));
      expect(updated.height, 100.0);
      expect(updated.clipBehavior, Clip.antiAlias);
    });

    test('lerp', () {
      final spec1 = BoxSpec(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(top: 4.0),
        constraints: const BoxConstraints(maxWidth: 200.0),
        decoration: const BoxDecoration(color: Colors.red),
        foregroundDecoration: const BoxDecoration(color: Colors.blue),
        transform: Matrix4.identity(),
        transformAlignment: Alignment.center,
        clipBehavior: Clip.none,
        width: 300,
        height: 200,
        modifiers: const WidgetModifiersData([
          OpacityModifierSpec(0.5),
          SizedBoxModifierSpec(height: 10, width: 10),
        ]),
      );

      final spec2 = BoxSpec(
        alignment: Alignment.bottomRight,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(top: 8.0),
        constraints: const BoxConstraints(maxWidth: 400.0),
        decoration: const BoxDecoration(color: Colors.blue),
        foregroundDecoration: const BoxDecoration(color: Colors.red),
        transform: Matrix4.rotationZ(0.5),
        clipBehavior: Clip.antiAlias,
        transformAlignment: Alignment.center,
        width: 400,
        height: 300,
        modifiers: const WidgetModifiersData([
          OpacityModifierSpec(1),
          SizedBoxModifierSpec(height: 100, width: 100),
        ]),
      );

      const t = 0.5;
      final lerpedSpec = spec1.lerp(spec2, t);

      expect(
        lerpedSpec.alignment,
        Alignment.lerp(Alignment.topLeft, Alignment.bottomRight, t),
      );
      expect(
        lerpedSpec.padding,
        EdgeInsets.lerp(
          const EdgeInsets.all(8.0),
          const EdgeInsets.all(16.0),
          t,
        ),
      );
      expect(
        lerpedSpec.margin,
        EdgeInsets.lerp(
          const EdgeInsets.only(top: 4.0),
          const EdgeInsets.only(top: 8.0),
          t,
        ),
      );
      expect(
        lerpedSpec.constraints,
        BoxConstraints.lerp(
          const BoxConstraints(maxWidth: 200.0),
          const BoxConstraints(maxWidth: 400.0),
          t,
        ),
      );
      expect(
        lerpedSpec.decoration,
        DecorationTween(
          begin: const BoxDecoration(color: Colors.red),
          end: const BoxDecoration(color: Colors.blue),
        ).lerp(t),
      );

      expect(
        lerpedSpec.foregroundDecoration,
        DecorationTween(
          begin: const BoxDecoration(color: Colors.blue),
          end: const BoxDecoration(color: Colors.red),
        ).lerp(t),
      );

      expect(lerpedSpec.width, lerpDouble(300, 400, t));
      expect(lerpedSpec.height, lerpDouble(200, 300, t));

      expect(
        lerpedSpec.transform,
        Matrix4Tween(begin: Matrix4.identity(), end: Matrix4.rotationZ(0.5))
            .lerp(t),
      );
      expect(lerpedSpec.clipBehavior, t < 0.5 ? Clip.none : Clip.antiAlias);
    });

    test('lerp modifiers', () {
      const spec1 = BoxSpec(
        modifiers: WidgetModifiersData([
          OpacityModifierSpec(0.5),
          SizedBoxModifierSpec(height: 10, width: 10),
        ]),
      );

      const spec2 = BoxSpec(
        modifiers: WidgetModifiersData([
          OpacityModifierSpec(1),
          SizedBoxModifierSpec(height: 100, width: 100),
        ]),
      );

      final lerpedSpecStart = spec1.lerp(spec2, 0.0);

      expect(
        lerpedSpecStart.modifiers,
        const WidgetModifiersData([
          OpacityModifierSpec(1),
          SizedBoxModifierSpec(height: 100, width: 100),
        ]),
      );

      final lerpedSpecMid = spec1.lerp(spec2, 0.5);

      expect(
        lerpedSpecMid.modifiers,
        const WidgetModifiersData([
          OpacityModifierSpec(1),
          SizedBoxModifierSpec(height: 100, width: 100),
        ]),
      );

      final lerpedSpecEnd = spec1.lerp(spec2, 0.5);

      expect(
        lerpedSpecEnd.modifiers,
        const WidgetModifiersData([
          OpacityModifierSpec(1),
          SizedBoxModifierSpec(height: 100, width: 100),
        ]),
      );
    });

    // equality
    test('equality', () {
      final spec1 = BoxSpec(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(top: 4.0),
        constraints: const BoxConstraints(maxWidth: 200.0),
        decoration: const BoxDecoration(color: Colors.red),
        foregroundDecoration: const BoxDecoration(color: Colors.blue),
        transform: Matrix4.identity(),
        transformAlignment: Alignment.center,
        clipBehavior: Clip.none,
        width: 300,
        height: 200,
        modifiers: const WidgetModifiersData([
          OpacityModifierSpec(0.5),
          SizedBoxModifierSpec(height: 10, width: 10),
        ]),
      );

      final spec2 = BoxSpec(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(top: 4.0),
        constraints: const BoxConstraints(maxWidth: 200.0),
        decoration: const BoxDecoration(color: Colors.red),
        foregroundDecoration: const BoxDecoration(color: Colors.blue),
        transform: Matrix4.identity(),
        transformAlignment: Alignment.center,
        clipBehavior: Clip.none,
        width: 300,
        height: 200,
        modifiers: const WidgetModifiersData([
          OpacityModifierSpec(0.5),
          SizedBoxModifierSpec(height: 10, width: 10),
        ]),
      );

      expect(spec1, spec2);
    });

    // merge()
    test('merge() returns correct instance', () {
      final containerSpecAttribute = BoxSpecAttribute(
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
        foregroundDecoration:
            const BoxDecorationDto(color: ColorDto(Colors.blue)),
        transform: Matrix4.identity(),
        clipBehavior: Clip.antiAlias,
        width: 100,
        height: 100,
        modifiers: const WidgetModifiersDataDto([
          OpacityModifierSpecAttribute(opacity: 0.5),
          SizedBoxModifierSpecAttribute(height: 10, width: 10),
        ]),
      );

      final mergedBoxSpecAttribute = containerSpecAttribute.merge(
        BoxSpecAttribute(
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
          foregroundDecoration:
              const BoxDecorationDto(color: ColorDto(Colors.amber)),
          transform: Matrix4.identity(),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          width: 200,
          height: 200,
          modifiers: const WidgetModifiersDataDto([
            SizedBoxModifierSpecAttribute(width: 100),
          ]),
        ),
      );

      expect(mergedBoxSpecAttribute.alignment, Alignment.centerLeft);
      expect(mergedBoxSpecAttribute.clipBehavior, Clip.antiAliasWithSaveLayer);

      expect(
        mergedBoxSpecAttribute.constraints,
        const BoxConstraintsDto(maxHeight: 200),
      );
      expect(
        mergedBoxSpecAttribute.decoration,
        const BoxDecorationDto(color: ColorDto(Colors.red)),
      );
      expect(
        mergedBoxSpecAttribute.foregroundDecoration,
        const BoxDecorationDto(color: ColorDto(Colors.amber)),
      );
      expect(mergedBoxSpecAttribute.height, 200);
      expect(
        mergedBoxSpecAttribute.margin,
        EdgeInsetsGeometryDto.only(top: 20, bottom: 20, left: 20, right: 20),
      );
      expect(
        mergedBoxSpecAttribute.padding,
        EdgeInsetsGeometryDto.only(top: 30, bottom: 30, left: 30, right: 30),
      );
      expect(mergedBoxSpecAttribute.transform, Matrix4.identity());
      expect(mergedBoxSpecAttribute.width, 200);
      expect(
        mergedBoxSpecAttribute.modifiers!.value,
        [
          const OpacityModifierSpecAttribute(opacity: 0.5),
          const SizedBoxModifierSpecAttribute(height: 10, width: 100),
        ],
      );
    });
  });

  group('BoxSpecUtility fluent', () {
    test('fluent behavior', () {
      final box = BoxSpecUtility.self;

      final util = box.chain
        ..alignment.center()
        ..padding(8);

      final attr = util.attributeValue!;

      expect(util, isA<Attribute>());
      expect(attr.alignment, Alignment.center);
      expect(attr.padding, const EdgeInsets.all(8.0).toDto());
      expect(attr.margin, null);

      final style = Style(util);

      final boxAttribute = style.styles.attributeOfType<BoxSpecAttribute>();

      expect(boxAttribute?.alignment, Alignment.center);
      expect(boxAttribute?.padding, const EdgeInsets.all(8.0).toDto());
      expect(boxAttribute?.margin, null);

      final mixData = style.of(MockBuildContext());
      final boxSpec = BoxSpec.from(mixData);

      expect(boxSpec.alignment, Alignment.center);
      expect(boxSpec.padding, const EdgeInsets.all(8.0));
      expect(boxSpec.margin, null);
    });

    // Test mutable behavior for multiple boxes
    test('Immutable behavior when having multiple boxes', () {
      final boxUtil = BoxSpecUtility.self;
      final box1 = boxUtil.chain..padding(10);
      final box2 = boxUtil.chain..padding(20);

      final attr1 = box1.attributeValue!;
      final attr2 = box2.attributeValue!;

      expect(attr1.padding, const EdgeInsets.all(10.0).toDto());
      expect(attr2.padding, const EdgeInsets.all(20.0).toDto());

      final style1 = Style(box1);
      final style2 = Style(box2);

      final boxAttribute1 = style1.styles.attributeOfType<BoxSpecAttribute>();
      final boxAttribute2 = style2.styles.attributeOfType<BoxSpecAttribute>();

      expect(boxAttribute1?.padding, const EdgeInsets.all(10.0).toDto());
      expect(boxAttribute2?.padding, const EdgeInsets.all(20.0).toDto());

      final mixData1 = style1.of(MockBuildContext());
      final mixData2 = style2.of(MockBuildContext());

      final boxSpec1 = BoxSpec.from(mixData1);
      final boxSpec2 = BoxSpec.from(mixData2);

      expect(boxSpec1.padding, const EdgeInsets.all(10.0));
      expect(boxSpec2.padding, const EdgeInsets.all(20.0));
    });

    test('Mutate behavior and not on same utility', () {
      final box = BoxSpecUtility.self;

      final boxValue = box.chain;
      boxValue
        ..padding(10)
        ..color.red()
        ..alignment.center();

      final boxAttribute = boxValue.attributeValue!;
      final boxAttribute2 = box.padding(20);

      expect(boxAttribute.padding, const EdgeInsets.all(10.0).toDto());
      expect(
        (boxAttribute.decoration as BoxDecorationDto).color,
        const ColorDto(
          Colors.red,
        ),
      );
      expect(boxAttribute.alignment, Alignment.center);

      expect(boxAttribute2.padding, const EdgeInsets.all(20.0).toDto());
      expect((boxAttribute2.decoration as BoxDecorationDto?)?.color, isNull);

      expect(
        boxAttribute2.alignment,
        isNull,
      );
    });
  });
}
