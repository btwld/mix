import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/mock_utils.dart';

void main() {
  group('StackSpecAttribute', () {
    group('Constructor', () {
      test('creates StackSpecAttribute with all properties', () {
        final attribute = StackSpecAttribute(
          alignment: Prop(Alignment.center),
          fit: Prop(StackFit.expand),
          textDirection: Prop(TextDirection.rtl),
          clipBehavior: Prop(Clip.antiAlias),
        );

        expect(attribute.$alignment?.getValue(), Alignment.center);
        expect(attribute.$fit?.getValue(), StackFit.expand);
        expect(attribute.$textDirection?.getValue(), TextDirection.rtl);
        expect(attribute.$clipBehavior?.getValue(), Clip.antiAlias);
      });

      test('creates StackSpecAttribute with default values', () {
        final attribute = StackSpecAttribute();

        expect(attribute.$alignment, isNull);
        expect(attribute.$fit, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$clipBehavior, isNull);
      });
    });

    group('only constructor', () {
      test('creates StackSpecAttribute with only specified properties', () {
        final attribute = StackSpecAttribute.only(
          alignment: Alignment.center,
          fit: StackFit.expand,
        );

        expect(attribute.$alignment?.getValue(), Alignment.center);
        expect(attribute.$fit?.getValue(), StackFit.expand);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$clipBehavior, isNull);
      });

      test('handles null values correctly', () {
        final attribute = StackSpecAttribute.only();

        expect(attribute.$alignment, isNull);
        expect(attribute.$fit, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$clipBehavior, isNull);
      });
    });

    group('value constructor', () {
      test('creates StackSpecAttribute from StackSpec', () {
        const spec = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.antiAlias,
        );

        final attribute = StackSpecAttribute.value(spec);

        expect(attribute.$alignment?.getValue(), Alignment.center);
        expect(attribute.$fit?.getValue(), StackFit.expand);
        expect(attribute.$textDirection?.getValue(), TextDirection.rtl);
        expect(attribute.$clipBehavior?.getValue(), Clip.antiAlias);
      });

      test('handles null properties in spec', () {
        const spec = StackSpec(alignment: Alignment.center);
        final attribute = StackSpecAttribute.value(spec);

        expect(attribute.$alignment?.getValue(), Alignment.center);
        expect(attribute.$fit, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$clipBehavior, isNull);
      });
    });

    group('maybeValue static method', () {
      test('returns StackSpecAttribute when spec is not null', () {
        const spec = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.expand,
        );
        final attribute = StackSpecAttribute.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$alignment?.getValue(), Alignment.center);
        expect(attribute.$fit?.getValue(), StackFit.expand);
      });

      test('returns null when spec is null', () {
        final attribute = StackSpecAttribute.maybeValue(null);
        expect(attribute, isNull);
      });
    });

    group('Resolution', () {
      test('resolves to StackSpec with correct properties', () {
        final attribute = StackSpecAttribute.only(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.antiAlias,
        );

        final context = SpecTestHelper.createMockContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.alignment, Alignment.center);
        expect(spec.fit, StackFit.expand);
        expect(spec.textDirection, TextDirection.rtl);
        expect(spec.clipBehavior, Clip.antiAlias);
      });

      test('resolves to StackSpec with null properties when not set', () {
        final attribute = StackSpecAttribute.only(alignment: Alignment.center);
        final context = SpecTestHelper.createMockContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.alignment, Alignment.center);
        expect(spec.fit, isNull);
        expect(spec.textDirection, isNull);
        expect(spec.clipBehavior, isNull);
      });
    });

    group('merge', () {
      test('merges two StackSpecAttributes correctly', () {
        final attr1 = StackSpecAttribute.only(
          alignment: Alignment.topLeft,
          fit: StackFit.loose,
        );

        final attr2 = StackSpecAttribute.only(
          alignment: Alignment.center,
          textDirection: TextDirection.rtl,
        );

        final merged = attr1.merge(attr2);

        expect(merged.$alignment?.getValue(), Alignment.center); // from attr2
        expect(merged.$fit?.getValue(), StackFit.loose); // from attr1
        expect(
          merged.$textDirection?.getValue(),
          TextDirection.rtl,
        ); // from attr2
        expect(merged.$clipBehavior, isNull);
      });

      test('returns original when merging with null', () {
        final original = StackSpecAttribute.only(
          alignment: Alignment.center,
          fit: StackFit.expand,
        );
        final merged = original.merge(null);

        expect(merged, original);
      });

      test('handles complex merge scenarios', () {
        final attr1 = StackSpecAttribute.only(
          alignment: Alignment.topLeft,
          clipBehavior: Clip.none,
        );

        final attr2 = StackSpecAttribute.only(
          fit: StackFit.expand,
          clipBehavior: Clip.antiAlias,
        );

        final merged = attr1.merge(attr2);

        expect(merged.$alignment?.getValue(), Alignment.topLeft); // from attr1
        expect(merged.$fit?.getValue(), StackFit.expand); // from attr2
        expect(
          merged.$clipBehavior?.getValue(),
          Clip.antiAlias,
        ); // from attr2 (takes precedence)
      });
    });

    group('Utility Properties', () {
      test('has all expected utility properties', () {
        final attribute = StackSpecAttribute();

        // Basic properties - just check they exist
        expect(attribute.alignment, isNotNull);
        expect(attribute.fit, isNotNull);
        expect(attribute.textDirection, isNotNull);
        expect(attribute.clipBehavior, isNotNull);
      });
    });

    group('Helper Methods', () {
      test('utility methods create proper attributes', () {
        final attribute = StackSpecAttribute();

        // Test that utility methods exist and return proper types
        final alignmentAttr = attribute.alignment(Alignment.center);
        expect(alignmentAttr, isA<StackSpecAttribute>());

        final fitAttr = attribute.fit(StackFit.expand);
        expect(fitAttr, isA<StackSpecAttribute>());

        final textDirectionAttr = attribute.textDirection(TextDirection.rtl);
        expect(textDirectionAttr, isA<StackSpecAttribute>());

        final clipBehaviorAttr = attribute.clipBehavior(Clip.antiAlias);
        expect(clipBehaviorAttr, isA<StackSpecAttribute>());
      });
    });

    group('equality', () {
      test('attributes with same properties are equal', () {
        final attr1 = StackSpecAttribute.only(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
        );
        final attr2 = StackSpecAttribute.only(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
        );

        expect(attr1, attr2);
        expect(attr1.hashCode, attr2.hashCode);
      });

      test('attributes with different properties are not equal', () {
        final attr1 = StackSpecAttribute.only(
          alignment: Alignment.center,
          fit: StackFit.expand,
        );
        final attr2 = StackSpecAttribute.only(
          alignment: Alignment.topLeft,
          fit: StackFit.expand,
        );

        expect(attr1, isNot(attr2));
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        final attribute = StackSpecAttribute.only(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.antiAlias,
        );

        final diagnostics = DiagnosticPropertiesBuilder();
        attribute.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'alignment'), isTrue);
        expect(properties.any((p) => p.name == 'fit'), isTrue);
        expect(properties.any((p) => p.name == 'textDirection'), isTrue);
        expect(properties.any((p) => p.name == 'clipBehavior'), isTrue);
      });
    });

    group('props', () {
      test('includes all properties in props list', () {
        final attribute = StackSpecAttribute.only(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.antiAlias,
        );

        expect(attribute.props.length, 4);
        expect(attribute.props, contains(attribute.$alignment));
        expect(attribute.props, contains(attribute.$fit));
        expect(attribute.props, contains(attribute.$textDirection));
        expect(attribute.props, contains(attribute.$clipBehavior));
      });
    });
  });
}
