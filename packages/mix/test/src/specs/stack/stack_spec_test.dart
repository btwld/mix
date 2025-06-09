import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('StackSpec', () {
    group('StackSpec comprehensive', () {
      test('constructor with all properties', () {
        const spec = StackSpec(
          alignment: Alignment.bottomRight,
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.antiAlias,
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
        expect(spec.alignment, Alignment.bottomRight);
        expect(spec.fit, StackFit.expand);
        expect(spec.textDirection, TextDirection.rtl);
        expect(spec.clipBehavior, Clip.antiAlias);
        expect(spec.animated?.duration, const Duration(milliseconds: 300));
        expect(spec.animated?.curve, Curves.easeInOut);
        expect(spec.modifiers?.value, [
          const OpacityModifierSpec(0.8),
          const SizedBoxModifierSpec(width: 100, height: 100),
        ]);
      });

      test('call method creates correct widget', () {
        const spec = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.expand,
        );

        final widget = spec.call(children: [
          const Text('Child 1'),
          const Text('Child 2'),
        ]);

        expect(widget, isA<StackSpecWidget>());
      });

      test('call method creates animated widget when animated', () {
        const spec = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.expand,
          animated: AnimatedData(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        );

        final widget = spec.call(children: [
          const Text('Child 1'),
          const Text('Child 2'),
        ]);

        expect(widget, isA<AnimatedStackSpecWidget>());
      });

      test('debugFillProperties includes all properties', () {
        const spec = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.antiAlias,
        );

        final builder = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties, isNotEmpty);
      });
    });
    test('StackSpec.from(MixData) resolves correctly', () {
      final mixData = MixData.create(
        MockBuildContext(),
        Style(
          const StackSpecAttribute(
            alignment: Alignment.center,
            fit: StackFit.expand,
            textDirection: TextDirection.ltr,
            clipBehavior: Clip.antiAlias,
          ),
        ),
      );

      final spec = StackSpec.from(mixData);

      expect(spec.alignment, Alignment.center);
      expect(spec.fit, StackFit.expand);
      expect(spec.textDirection, TextDirection.ltr);
      expect(spec.clipBehavior, Clip.antiAlias);
    });

    test('copyWith updates correctly and preserves unchanged properties', () {
      const original = StackSpec(
        alignment: Alignment.center,
        fit: StackFit.expand,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.antiAlias,
      );

      final updated = original.copyWith(
        alignment: Alignment.topLeft,
        fit: StackFit.loose,
        // Don't update textDirection and clipBehavior - test preservation
      );

      // Test updated properties
      expect(updated.alignment, Alignment.topLeft);
      expect(updated.fit, StackFit.loose);

      // Test preserved properties
      expect(updated.textDirection, TextDirection.ltr);
      expect(updated.clipBehavior, Clip.antiAlias);
    });

    test('lerp interpolates correctly', () {
      const spec1 = StackSpec(
        alignment: Alignment.topLeft,
        fit: StackFit.loose,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.none,
      );

      const spec2 = StackSpec(
        alignment: Alignment.bottomRight,
        fit: StackFit.expand,
        textDirection: TextDirection.rtl,
        clipBehavior: Clip.antiAlias,
      );

      const t = 0.5;
      final lerpedSpec = spec1.lerp(spec2, t);

      expect(
        lerpedSpec.alignment,
        Alignment.lerp(Alignment.topLeft, Alignment.bottomRight, t),
      );
      expect(lerpedSpec.fit, StackFit.expand);
      expect(lerpedSpec.textDirection, TextDirection.rtl);
      expect(lerpedSpec.clipBehavior, Clip.antiAlias);

      expect(lerpedSpec, isNot(spec1));
      expect(lerpedSpec, isNot(spec2));
    });

    test('equality operator works correctly', () {
      const spec1 = StackSpec(
        alignment: Alignment.center,
        fit: StackFit.expand,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.antiAlias,
      );

      const spec2 = StackSpec(
        alignment: Alignment.center,
        fit: StackFit.expand,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.antiAlias,
      );

      const spec3 = StackSpec(
        alignment: Alignment.topLeft,
        fit: StackFit.loose,
        textDirection: TextDirection.rtl,
        clipBehavior: Clip.none,
      );

      expect(spec1, spec2);
      expect(spec1, isNot(spec3));
      expect(spec2, isNot(spec3));
    });

    test('props returns correct list of properties', () {
      const spec = StackSpec(
        alignment: Alignment.center,
        fit: StackFit.expand,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.antiAlias,
        animated: AnimatedData.withDefaults(),
      );

      expect(spec.props.length,
          6); // All properties including animated and modifiers
      expect(spec.props.contains(spec.alignment), true);
      expect(spec.props.contains(spec.fit), true);
      expect(spec.props.contains(spec.textDirection), true);
      expect(spec.props.contains(spec.clipBehavior), true);
      expect(spec.props.contains(spec.animated), true);
      expect(spec.props.contains(spec.modifiers), true);
    });
  });

  group('StackSpecUtility fluent', () {
    test('fluent behavior', () {
      final stack = StackSpecUtility.self;

      final util = stack.chain
        ..alignment.topLeft()
        ..fit.expand()
        ..textDirection.rtl()
        ..clipBehavior.antiAlias();

      final attr = util.attributeValue!;

      expect(util, isA<Attribute>());
      expect(attr.alignment, Alignment.topLeft);
      expect(attr.fit, StackFit.expand);
      expect(attr.textDirection, TextDirection.rtl);
      expect(attr.clipBehavior, Clip.antiAlias);

      final style = Style(util);

      final stackAttribute = style.styles.attributeOfType<StackSpecAttribute>();

      expect(stackAttribute?.alignment, Alignment.topLeft);
      expect(stackAttribute?.fit, StackFit.expand);
      expect(stackAttribute?.textDirection, TextDirection.rtl);
      expect(stackAttribute?.clipBehavior, Clip.antiAlias);

      final mixData = style.of(MockBuildContext());
      final stackSpec = StackSpec.from(mixData);

      expect(stackSpec.alignment, Alignment.topLeft);
      expect(stackSpec.fit, StackFit.expand);
      expect(stackSpec.textDirection, TextDirection.rtl);
      expect(stackSpec.clipBehavior, Clip.antiAlias);
    });

    test('Immutable behavior when having multiple stacks', () {
      final stackUtil = StackSpecUtility.self;
      final stack1 = stackUtil.chain..alignment.topLeft();
      final stack2 = stackUtil.chain..alignment.bottomRight();

      final attr1 = stack1.attributeValue!;
      final attr2 = stack2.attributeValue!;

      expect(attr1.alignment, Alignment.topLeft);
      expect(attr2.alignment, Alignment.bottomRight);

      final style1 = Style(stack1);
      final style2 = Style(stack2);

      final stackAttribute1 =
          style1.styles.attributeOfType<StackSpecAttribute>();
      final stackAttribute2 =
          style2.styles.attributeOfType<StackSpecAttribute>();

      expect(stackAttribute1?.alignment, Alignment.topLeft);
      expect(stackAttribute2?.alignment, Alignment.bottomRight);

      final mixData1 = style1.of(MockBuildContext());
      final mixData2 = style2.of(MockBuildContext());

      final stackSpec1 = StackSpec.from(mixData1);
      final stackSpec2 = StackSpec.from(mixData2);

      expect(stackSpec1.alignment, Alignment.topLeft);
      expect(stackSpec2.alignment, Alignment.bottomRight);
    });

    test('Mutate behavior and not on same utility', () {
      final stack = StackSpecUtility.self;

      final stackValue = stack.chain;
      stackValue
        ..alignment.topLeft()
        ..fit.expand()
        ..textDirection.rtl();

      final stackAttribute = stackValue.attributeValue!;
      final stackAttribute2 = stack.alignment.bottomRight();

      expect(stackAttribute.alignment, Alignment.topLeft);
      expect(stackAttribute.fit, StackFit.expand);
      expect(stackAttribute.textDirection, TextDirection.rtl);

      expect(stackAttribute2.alignment, Alignment.bottomRight);
      expect(stackAttribute2.fit, isNull);
      expect(stackAttribute2.textDirection, isNull);
    });
  });
}
