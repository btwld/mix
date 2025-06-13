import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('StackSpec', () {
    test('resolve', () {
      const attribute = StackSpecAttribute(
        alignment: Alignment.center,
        fit: StackFit.expand,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.antiAlias,
      );

      final mixture = attribute.resolve(EmptyMixData);

      expect(mixture.alignment, Alignment.center);
      expect(mixture.fit, StackFit.expand);
      expect(mixture.textDirection, TextDirection.ltr);
      expect(mixture.clipBehavior, Clip.antiAlias);
    });

    test('copyWith', () {
      const spec = StackSpec(
        alignment: Alignment.center,
        fit: StackFit.expand,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.antiAlias,
      );

      final copiedSpec = spec.copyWith(
        alignment: Alignment.topLeft,
        fit: StackFit.loose,
        textDirection: TextDirection.rtl,
        clipBehavior: Clip.none,
      );

      expect(copiedSpec.alignment, Alignment.topLeft);
      expect(copiedSpec.fit, StackFit.loose);
      expect(copiedSpec.textDirection, TextDirection.rtl);
      expect(copiedSpec.clipBehavior, Clip.none);
    });

    test('lerp', () {
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

      expect(util, isA<StyleElement>());
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
