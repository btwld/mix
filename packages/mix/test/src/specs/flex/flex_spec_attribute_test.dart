import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/mock_utils.dart';

void main() {
  group('FlexSpecAttribute', () {
    group('Constructor', () {
      test('creates FlexSpecAttribute with all properties', () {
        final attribute = FlexSpecAttribute(
          direction: Prop(Axis.horizontal),
          mainAxisAlignment: Prop(MainAxisAlignment.center),
          crossAxisAlignment: Prop(CrossAxisAlignment.stretch),
          mainAxisSize: Prop(MainAxisSize.max),
          verticalDirection: Prop(VerticalDirection.down),
          textDirection: Prop(TextDirection.ltr),
          textBaseline: Prop(TextBaseline.alphabetic),
          clipBehavior: Prop(Clip.antiAlias),
          gap: Prop(16.0),
        );

        expect(attribute.$direction?.getValue(), Axis.horizontal);
        expect(attribute.$mainAxisAlignment?.getValue(), MainAxisAlignment.center);
        expect(attribute.$crossAxisAlignment?.getValue(), CrossAxisAlignment.stretch);
        expect(attribute.$mainAxisSize?.getValue(), MainAxisSize.max);
        expect(attribute.$verticalDirection?.getValue(), VerticalDirection.down);
        expect(attribute.$textDirection?.getValue(), TextDirection.ltr);
        expect(attribute.$textBaseline?.getValue(), TextBaseline.alphabetic);
        expect(attribute.$clipBehavior?.getValue(), Clip.antiAlias);
        expect(attribute.$gap?.getValue(), 16.0);
      });

      test('creates FlexSpecAttribute with default values', () {
        final attribute = FlexSpecAttribute();

        expect(attribute.$direction, isNull);
        expect(attribute.$mainAxisAlignment, isNull);
        expect(attribute.$crossAxisAlignment, isNull);
        expect(attribute.$mainAxisSize, isNull);
        expect(attribute.$verticalDirection, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$textBaseline, isNull);
        expect(attribute.$clipBehavior, isNull);
        expect(attribute.$gap, isNull);
      });
    });

    group('only constructor', () {
      test('creates FlexSpecAttribute with only specified properties', () {
        final attribute = FlexSpecAttribute.only(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          gap: 16.0,
        );

        expect(attribute.$direction?.getValue(), Axis.horizontal);
        expect(attribute.$mainAxisAlignment?.getValue(), MainAxisAlignment.center);
        expect(attribute.$gap?.getValue(), 16.0);
        expect(attribute.$crossAxisAlignment, isNull);
        expect(attribute.$mainAxisSize, isNull);
      });

      test('handles null values correctly', () {
        final attribute = FlexSpecAttribute.only();

        expect(attribute.$direction, isNull);
        expect(attribute.$mainAxisAlignment, isNull);
        expect(attribute.$crossAxisAlignment, isNull);
        expect(attribute.$mainAxisSize, isNull);
        expect(attribute.$verticalDirection, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$textBaseline, isNull);
        expect(attribute.$clipBehavior, isNull);
        expect(attribute.$gap, isNull);
      });
    });

    group('value constructor', () {
      test('creates FlexSpecAttribute from FlexSpec', () {
        const spec = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
          clipBehavior: Clip.antiAlias,
          gap: 16.0,
        );

        final attribute = FlexSpecAttribute.value(spec);

        expect(attribute.$direction?.getValue(), Axis.horizontal);
        expect(attribute.$mainAxisAlignment?.getValue(), MainAxisAlignment.center);
        expect(attribute.$crossAxisAlignment?.getValue(), CrossAxisAlignment.stretch);
        expect(attribute.$mainAxisSize?.getValue(), MainAxisSize.max);
        expect(attribute.$verticalDirection?.getValue(), VerticalDirection.down);
        expect(attribute.$textDirection?.getValue(), TextDirection.ltr);
        expect(attribute.$textBaseline?.getValue(), TextBaseline.alphabetic);
        expect(attribute.$clipBehavior?.getValue(), Clip.antiAlias);
        expect(attribute.$gap?.getValue(), 16.0);
      });

      test('handles null properties in spec', () {
        const spec = FlexSpec(direction: Axis.horizontal);
        final attribute = FlexSpecAttribute.value(spec);

        expect(attribute.$direction?.getValue(), Axis.horizontal);
        expect(attribute.$mainAxisAlignment, isNull);
        expect(attribute.$crossAxisAlignment, isNull);
      });
    });

    group('maybeValue static method', () {
      test('returns FlexSpecAttribute when spec is not null', () {
        const spec = FlexSpec(direction: Axis.horizontal, gap: 16.0);
        final attribute = FlexSpecAttribute.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$direction?.getValue(), Axis.horizontal);
        expect(attribute.$gap?.getValue(), 16.0);
      });

      test('returns null when spec is null', () {
        final attribute = FlexSpecAttribute.maybeValue(null);
        expect(attribute, isNull);
      });
    });

    group('resolveSpec', () {
      test('resolves to FlexSpec with correct properties', () {
        final attribute = FlexSpecAttribute.only(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          gap: 16.0,
        );

        final context = SpecTestHelper.createMockContext();
        final spec = attribute.resolveSpec(context);

        expect(spec.direction, Axis.horizontal);
        expect(spec.mainAxisAlignment, MainAxisAlignment.center);
        expect(spec.crossAxisAlignment, CrossAxisAlignment.stretch);
        expect(spec.gap, 16.0);
      });

      test('resolves to FlexSpec with null properties when not set', () {
        final attribute = FlexSpecAttribute.only(direction: Axis.horizontal);
        final context = SpecTestHelper.createMockContext();
        final spec = attribute.resolveSpec(context);

        expect(spec.direction, Axis.horizontal);
        expect(spec.mainAxisAlignment, isNull);
        expect(spec.crossAxisAlignment, isNull);
        expect(spec.mainAxisSize, isNull);
        expect(spec.verticalDirection, isNull);
        expect(spec.textDirection, isNull);
        expect(spec.textBaseline, isNull);
        expect(spec.clipBehavior, isNull);
        expect(spec.gap, isNull);
      });
    });

    group('merge', () {
      test('merges two FlexSpecAttributes correctly', () {
        final attr1 = FlexSpecAttribute.only(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          gap: 8.0,
        );

        final attr2 = FlexSpecAttribute.only(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.center,
          gap: 16.0,
        );

        final merged = attr1.merge(attr2);

        expect(merged.$direction?.getValue(), Axis.vertical); // from attr2
        expect(merged.$mainAxisAlignment?.getValue(), MainAxisAlignment.start); // from attr1
        expect(merged.$crossAxisAlignment?.getValue(), CrossAxisAlignment.center); // from attr2
        expect(merged.$gap?.getValue(), 16.0); // from attr2
      });

      test('returns original when merging with null', () {
        final original = FlexSpecAttribute.only(direction: Axis.horizontal, gap: 16.0);
        final merged = original.merge(null);

        expect(merged, original);
      });

      test('handles complex merge scenarios', () {
        final attr1 = FlexSpecAttribute.only(
          direction: Axis.horizontal,
          textDirection: TextDirection.ltr,
        );

        final attr2 = FlexSpecAttribute.only(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.rtl,
        );

        final merged = attr1.merge(attr2);

        expect(merged.$direction?.getValue(), Axis.horizontal); // from attr1
        expect(merged.$mainAxisSize?.getValue(), MainAxisSize.min); // from attr2
        expect(merged.$textDirection?.getValue(), TextDirection.rtl); // from attr2 (takes precedence)
      });
    });

    group('Utility Properties', () {
      test('has all expected utility properties', () {
        final attribute = FlexSpecAttribute();

        // Basic properties - just check they exist
        expect(attribute.direction, isNotNull);
        expect(attribute.mainAxisAlignment, isNotNull);
        expect(attribute.crossAxisAlignment, isNotNull);
        expect(attribute.mainAxisSize, isNotNull);
        expect(attribute.verticalDirection, isNotNull);
        expect(attribute.textDirection, isNotNull);
        expect(attribute.textBaseline, isNotNull);
        expect(attribute.clipBehavior, isNotNull);
        expect(attribute.gap, isNotNull);
      });
    });

    group('Helper Methods', () {
      test('utility methods create proper attributes', () {
        final attribute = FlexSpecAttribute();

        // Test that utility methods exist and return proper types
        final directionAttr = attribute.direction(Axis.horizontal);
        expect(directionAttr, isA<FlexSpecAttribute>());

        final mainAxisAlignmentAttr = attribute.mainAxisAlignment(MainAxisAlignment.center);
        expect(mainAxisAlignmentAttr, isA<FlexSpecAttribute>());

        final crossAxisAlignmentAttr = attribute.crossAxisAlignment(CrossAxisAlignment.stretch);
        expect(crossAxisAlignmentAttr, isA<FlexSpecAttribute>());

        final gapAttr = attribute.gap(16.0);
        expect(gapAttr, isA<FlexSpecAttribute>());
      });
    });

    group('equality', () {
      test('attributes with same properties are equal', () {
        final attr1 = FlexSpecAttribute.only(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          gap: 16.0,
        );
        final attr2 = FlexSpecAttribute.only(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          gap: 16.0,
        );

        expect(attr1, attr2);
        expect(attr1.hashCode, attr2.hashCode);
      });

      test('attributes with different properties are not equal', () {
        final attr1 = FlexSpecAttribute.only(direction: Axis.horizontal, gap: 8.0);
        final attr2 = FlexSpecAttribute.only(direction: Axis.vertical, gap: 8.0);

        expect(attr1, isNot(attr2));
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        final attribute = FlexSpecAttribute.only(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
          clipBehavior: Clip.antiAlias,
          gap: 16.0,
        );

        final diagnostics = DiagnosticPropertiesBuilder();
        attribute.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'direction'), isTrue);
        expect(properties.any((p) => p.name == 'mainAxisAlignment'), isTrue);
        expect(properties.any((p) => p.name == 'crossAxisAlignment'), isTrue);
        expect(properties.any((p) => p.name == 'mainAxisSize'), isTrue);
        expect(properties.any((p) => p.name == 'verticalDirection'), isTrue);
        expect(properties.any((p) => p.name == 'textDirection'), isTrue);
        expect(properties.any((p) => p.name == 'textBaseline'), isTrue);
        expect(properties.any((p) => p.name == 'clipBehavior'), isTrue);
        expect(properties.any((p) => p.name == 'gap'), isTrue);
      });
    });

    group('props', () {
      test('includes all properties in props list', () {
        final attribute = FlexSpecAttribute.only(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
          clipBehavior: Clip.antiAlias,
          gap: 16.0,
        );

        expect(attribute.props.length, 9);
        expect(attribute.props, contains(attribute.$direction));
        expect(attribute.props, contains(attribute.$mainAxisAlignment));
        expect(attribute.props, contains(attribute.$crossAxisAlignment));
        expect(attribute.props, contains(attribute.$mainAxisSize));
        expect(attribute.props, contains(attribute.$verticalDirection));
        expect(attribute.props, contains(attribute.$textDirection));
        expect(attribute.props, contains(attribute.$textBaseline));
        expect(attribute.props, contains(attribute.$clipBehavior));
        expect(attribute.props, contains(attribute.$gap));
      });
    });
  });
}
