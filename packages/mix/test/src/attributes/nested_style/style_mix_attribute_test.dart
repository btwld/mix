import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/factory/style_mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('NestedStyleAttribute', () {
    test('should create an instance with the provided value', () {
      // Arrange
      final styleMix = Style(
        const MockIntScalarAttribute(1),
        const MockIntScalarAttribute(2),
      );

      // Act
      final attribute = styleMix;

      // Assert
      expect(attribute, isA<Style>());
      expect(attribute, equals(styleMix));
    });

    group('merge', () {
      test('should return the same object if other is null', () {
        // Arrange
        final styleMix = Style(const MockStringScalarAttribute('test'));

        // Act
        final mergedAttribute = styleMix.merge(null);

        // Assert
        expect(mergedAttribute, same(styleMix));
      });

      test(
        'should return a new object with merged values if other is not null',
        () {
          // Arrange
          final styleMix1 = Style(
            const MockDoubleScalarAttribute(1.0),
            const MockIntScalarAttribute(2),
          );
          final styleMix2 = Style(const MockDoubleScalarAttribute(2.0));

          final attribute1 = styleMix1;
          final attribute2 = styleMix2;

          // Act
          final mergedAttribute = attribute1.merge(attribute2);

          // Assert
          expect(mergedAttribute, isNot(same(attribute1)));
          expect(mergedAttribute, equals(styleMix1.merge(styleMix2)));
        },
      );
    });

    test('props should return a list containing styles and variants', () {
      // Arrange
      final styleMix = Style();
      final attribute = styleMix;

      // Act
      final props = attribute.props;

      // Assert
      expect(props, isList);
      expect(props.length, 2);
      expect(props[0], equals(styleMix.styles));
      expect(props[1], equals(styleMix.variants));
    });

    test('should contain all attributes after multiple merges', () {
      const attr1 = MockIntScalarAttribute(3);
      const attr2 = MockDoubleScalarAttribute(1);
      const attr3 = MockBooleanScalarAttribute(false);

      final styleMix1 = Style(attr1);
      final styleMix2 = Style(attr2);
      final styleMix3 = Style(attr3);

      final styleAttribute1 = styleMix1;
      final styleAttribute2 = styleMix2;
      final styleAttribute3 = styleMix3;

      // Act
      // Simulate the nested merge as it would occur during construction or setup.
      // This assumes Style.merge() not only merges attributes but also merges other Stylees.
      final mergedAttribute1 = styleAttribute1.merge(styleAttribute2);
      final mergedAttribute2 = mergedAttribute1.merge(styleAttribute3);

      final finalStyle = mergedAttribute1.merge(mergedAttribute2);

      expect(finalStyle.values, containsAll([attr1, attr2, attr3]));

      // Does not contain any attributes of type NestedStyleAttribute
      expect(finalStyle.values.whereType<Style>(), isEmpty);
    });

    test('should handle nested Style properly', () {
      const attr1 = MockIntScalarAttribute(3);
      const attr2 = MockDoubleScalarAttribute(1);
      const attr3 = MockBooleanScalarAttribute(false);

      final style = Style(attr1, attr2, attr3);

      final styleMix = Style(style);

      final level1Attribute = styleMix;

      final level2Attribute = Style(level1Attribute);

      final level3Attribute = Style(level2Attribute);

      expect(level1Attribute.values, containsAll([attr1, attr2, attr3]));
      expect(level2Attribute.values, containsAll([attr1, attr2, attr3]));
      expect(level3Attribute.values, containsAll([attr1, attr2, attr3]));

      expect(level1Attribute.values.whereType<Style>(), isEmpty);

      expect(level2Attribute.values.whereType<Style>(), isEmpty);
      expect(level3Attribute.values.whereType<Style>(), isEmpty);

      expect(level1Attribute.values.length, 3);
      expect(level2Attribute.values.length, 3);
      expect(level3Attribute.values.length, 3);

      expect(styleMix, level1Attribute);
      expect(styleMix, level2Attribute);
      expect(styleMix, level3Attribute);
    });
  });
}
