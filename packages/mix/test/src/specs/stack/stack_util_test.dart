import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('StackUtility', () {
    final stackUtility = StackSpecUtility(MixUtility.selfBuilder);

    test('only() returns correct instance', () {
      final stack = stackUtility.only(
        alignment: Alignment.topLeft,
        textDirection: TextDirection.rtl,
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
      );

      expect(stack.alignment, Alignment.topLeft);
      expect(stack.textDirection, TextDirection.rtl);
      expect(stack.fit, StackFit.expand);
      expect(stack.clipBehavior, Clip.hardEdge);
    });

    test('alignment utility returns correct instance', () {
      final stack = stackUtility.alignment(Alignment.bottomRight);
      expect(stack.alignment, Alignment.bottomRight);
    });

    test('textDirection utility returns correct instance', () {
      final stack = stackUtility.textDirection(TextDirection.ltr);
      expect(stack.textDirection, TextDirection.ltr);
    });

    test('fit utility returns correct instance', () {
      final stack = stackUtility.fit(StackFit.loose);
      expect(stack.fit, StackFit.loose);
    });

    test('clipBehavior utility returns correct instance', () {
      final stack = stackUtility.clipBehavior(Clip.antiAlias);
      expect(stack.clipBehavior, Clip.antiAlias);
    });

    group('Fluent chaining', () {
      test('should chain multiple properties', () {
        final stack = stackUtility.chain
          ..alignment.center()
          ..fit.expand()
          ..clipBehavior.antiAlias();

        expect(stack.attributeValue!.alignment, Alignment.center);
        expect(stack.attributeValue!.fit, StackFit.expand);
        expect(stack.attributeValue!.clipBehavior, Clip.antiAlias);
      });
    });

    group('Immutability', () {
      test('should create new instances on each call', () {
        final stack1 = stackUtility.alignment(Alignment.topLeft);
        final stack2 = stackUtility.alignment(Alignment.bottomRight);

        expect(stack1, isNot(same(stack2)));
        expect(stack1.alignment, isNot(equals(stack2.alignment)));
      });
    });

    group('Integration with Style', () {
      test('should work within Style composition', () {
        final style = Style(
          stackUtility.alignment(Alignment.center),
          stackUtility.fit(StackFit.expand),
          stackUtility.clipBehavior(Clip.hardEdge),
        );

        expect(style.styles.length,
            1); // Attributes are merged into one StackSpecAttribute
      });
    });

    group('Edge cases', () {
      test('should handle null values correctly', () {
        final stack = stackUtility.only();

        expect(stack.alignment, isNull);
        expect(stack.textDirection, isNull);
        expect(stack.fit, isNull);
        expect(stack.clipBehavior, isNull);
      });

      test('should handle all StackFit values', () {
        final stackLoose = stackUtility.fit(StackFit.loose);
        final stackExpand = stackUtility.fit(StackFit.expand);
        final stackPassthrough = stackUtility.fit(StackFit.passthrough);

        expect(stackLoose.fit, StackFit.loose);
        expect(stackExpand.fit, StackFit.expand);
        expect(stackPassthrough.fit, StackFit.passthrough);
      });

      test('should handle all Clip values', () {
        final clipNone = stackUtility.clipBehavior(Clip.none);
        final clipHardEdge = stackUtility.clipBehavior(Clip.hardEdge);
        final clipAntiAlias = stackUtility.clipBehavior(Clip.antiAlias);
        final clipAntiAliasWithSaveLayer =
            stackUtility.clipBehavior(Clip.antiAliasWithSaveLayer);

        expect(clipNone.clipBehavior, Clip.none);
        expect(clipHardEdge.clipBehavior, Clip.hardEdge);
        expect(clipAntiAlias.clipBehavior, Clip.antiAlias);
        expect(clipAntiAliasWithSaveLayer.clipBehavior,
            Clip.antiAliasWithSaveLayer);
      });
    });
  });
}
