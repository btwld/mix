import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/specs/flex/flex_style.dart';

void main() {
  group('FlexStyle', () {
    test('should create empty FlexStyle', () {
      const style = FlexStyle();

      expect(style.attribute, equals(const FlexSpecAttribute()));
      expect(style.variants, isEmpty);
      expect(style.animation, isNull);
      expect(style.modifiers, isNull);
    });

    test('should create FlexStyle with attribute using withAttribute', () {
      const attribute = FlexSpecAttribute(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      );

      final style = const FlexStyle().withAttribute(attribute);

      expect(style.attribute, equals(attribute));
      expect(style.variants, isEmpty);
      expect(style.animation, isNull);
      expect(style.modifiers, isNull);
    });

    test('should merge FlexStyle correctly', () {
      const attribute1 = FlexSpecAttribute(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
      );

      const attribute2 = FlexSpecAttribute(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
      );

      final style1 = const FlexStyle().withAttribute(attribute1);
      final style2 = const FlexStyle().withAttribute(attribute2);

      final merged = style1.merge(style2);

      expect(merged.attribute.direction, equals(Axis.horizontal));
      expect(
        merged.attribute.mainAxisAlignment,
        equals(MainAxisAlignment.start),
      );
      expect(
        merged.attribute.crossAxisAlignment,
        equals(CrossAxisAlignment.center),
      );
      expect(merged.attribute.mainAxisSize, equals(MainAxisSize.min));
    });

    test('should handle null merge correctly', () {
      const attribute = FlexSpecAttribute(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.end,
      );

      final style = const FlexStyle().withAttribute(attribute);
      final merged = style.merge(null);

      expect(merged, equals(style));
      expect(merged.attribute.direction, equals(Axis.vertical));
      expect(merged.attribute.mainAxisAlignment, equals(MainAxisAlignment.end));
    });

    test('should have correct props for equality', () {
      const attribute = FlexSpecAttribute(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
      );

      final style1 = const FlexStyle().withAttribute(attribute);
      final style2 = const FlexStyle().withAttribute(attribute);

      expect(style1.props, equals(style2.props));
      expect(style1, equals(style2));
    });
  });
}
