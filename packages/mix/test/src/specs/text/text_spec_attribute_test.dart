import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/mock_utils.dart';

void main() {
  group('TextSpecAttribute', () {
    group('Constructor', () {
      test('creates TextSpecAttribute with all properties', () {
        final attribute = TextSpecAttribute(
          overflow: Prop(TextOverflow.ellipsis),
          strutStyle: MixProp(StrutStyleMix(fontSize: Prop(16.0))),
          textAlign: Prop(TextAlign.center),
          textScaler: Prop(TextScaler.linear(1.2)),
          maxLines: Prop(3),
          style: MixProp(TextStyleMix(fontSize: Prop(14.0))),
          textWidthBasis: Prop(TextWidthBasis.longestLine),
          textHeightBehavior: MixProp(TextHeightBehaviorMix()),
          textDirection: Prop(TextDirection.rtl),
          softWrap: Prop(false),
          directives: [],
        );

        expect(attribute.$overflow?.getValue(), TextOverflow.ellipsis);
        expect(attribute.$textAlign?.getValue(), TextAlign.center);
        expect(attribute.$textScaler?.getValue(), isA<TextScaler>());
        expect(attribute.$maxLines?.getValue(), 3);
        expect(
          attribute.$textWidthBasis?.getValue(),
          TextWidthBasis.longestLine,
        );
        expect(attribute.$textDirection?.getValue(), TextDirection.rtl);
        expect(attribute.$softWrap?.getValue(), false);
        expect(attribute.$directives, isEmpty);
      });

      test('creates TextSpecAttribute with default values', () {
        final attribute = TextSpecAttribute();

        expect(attribute.$overflow, isNull);
        expect(attribute.$strutStyle, isNull);
        expect(attribute.$textAlign, isNull);
        expect(attribute.$textScaler, isNull);
        expect(attribute.$maxLines, isNull);
        expect(attribute.$style, isNull);
        expect(attribute.$textWidthBasis, isNull);
        expect(attribute.$textHeightBehavior, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$softWrap, isNull);
        expect(attribute.$directives, isNull);
      });
    });

    group('only constructor', () {
      test('creates TextSpecAttribute with only specified properties', () {
        final attribute = TextSpecAttribute.only(
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyleMix(fontSize: Prop(16.0)),
        );

        expect(attribute.$overflow?.getValue(), TextOverflow.ellipsis);
        expect(attribute.$maxLines?.getValue(), 3);
        expect(attribute.$textAlign?.getValue(), TextAlign.center);
        expect(attribute.$style, isNotNull);
        expect(attribute.$strutStyle, isNull);
        expect(attribute.$textScaler, isNull);
      });

      test('handles null values correctly', () {
        final attribute = TextSpecAttribute.only();

        expect(attribute.$overflow, isNull);
        expect(attribute.$strutStyle, isNull);
        expect(attribute.$textAlign, isNull);
        expect(attribute.$textScaler, isNull);
        expect(attribute.$maxLines, isNull);
        expect(attribute.$style, isNull);
        expect(attribute.$textWidthBasis, isNull);
        expect(attribute.$textHeightBehavior, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$softWrap, isNull);
        expect(attribute.$directives, isNull);
      });
    });

    group('value constructor', () {
      test('creates TextSpecAttribute from TextSpec', () {
        const spec = TextSpec(
          overflow: TextOverflow.ellipsis,
          strutStyle: StrutStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
          textScaler: TextScaler.linear(1.2),
          maxLines: 3,
          style: TextStyle(fontSize: 14.0, color: Colors.blue),
          textWidthBasis: TextWidthBasis.longestLine,
          textHeightBehavior: TextHeightBehavior(),
          textDirection: TextDirection.rtl,
          softWrap: false,
          directives: [],
        );

        final attribute = TextSpecAttribute.value(spec);

        expect(attribute.$overflow?.getValue(), TextOverflow.ellipsis);
        expect(attribute.$textAlign?.getValue(), TextAlign.center);
        expect(attribute.$textScaler?.getValue(), isA<TextScaler>());
        expect(attribute.$maxLines?.getValue(), 3);
        expect(
          attribute.$textWidthBasis?.getValue(),
          TextWidthBasis.longestLine,
        );
        expect(attribute.$textDirection?.getValue(), TextDirection.rtl);
        expect(attribute.$softWrap?.getValue(), false);
        expect(attribute.$directives, isEmpty);
      });

      test('handles null properties in spec', () {
        const spec = TextSpec(maxLines: 3);
        final attribute = TextSpecAttribute.value(spec);

        expect(attribute.$maxLines?.getValue(), 3);
        expect(attribute.$overflow, isNull);
        expect(attribute.$textAlign, isNull);
      });
    });

    group('maybeValue static method', () {
      test('returns TextSpecAttribute when spec is not null', () {
        const spec = TextSpec(maxLines: 3, overflow: TextOverflow.ellipsis);
        final attribute = TextSpecAttribute.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$maxLines?.getValue(), 3);
        expect(attribute.$overflow?.getValue(), TextOverflow.ellipsis);
      });

      test('returns null when spec is null', () {
        final attribute = TextSpecAttribute.maybeValue(null);
        expect(attribute, isNull);
      });
    });

    group('Resolution', () {
      test('resolves to TextSpec with correct properties', () {
        final attribute = TextSpecAttribute.only(
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyleMix(fontSize: Prop(16.0)),
          strutStyle: StrutStyleMix(fontSize: Prop(16.0)),
          softWrap: true,
        );

        final context = SpecTestHelper.createMockContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.overflow, TextOverflow.ellipsis);
        expect(spec.maxLines, 3);
        expect(spec.textAlign, TextAlign.center);
        expect(spec.style, isA<TextStyle>());
        expect(spec.strutStyle, isA<StrutStyle>());
        expect(spec.softWrap, true);
      });

      test('resolves to TextSpec with null properties when not set', () {
        final attribute = TextSpecAttribute.only(maxLines: 3);
        final context = SpecTestHelper.createMockContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.maxLines, 3);
        expect(spec.overflow, isNull);
        expect(spec.textAlign, isNull);
        expect(spec.style, isNull);
        expect(spec.strutStyle, isNull);
        expect(spec.textWidthBasis, isNull);
        expect(spec.textHeightBehavior, isNull);
        expect(spec.textDirection, isNull);
        expect(spec.softWrap, isNull);
        expect(spec.directives, isNull);
      });
    });

    group('merge', () {
      test('merges two TextSpecAttributes correctly', () {
        final attr1 = TextSpecAttribute.only(
          maxLines: 3,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.left,
        );

        final attr2 = TextSpecAttribute.only(
          maxLines: 5,
          style: TextStyleMix(fontSize: Prop(16.0)),
          softWrap: true,
        );

        final merged = attr1.merge(attr2);

        expect(merged.$maxLines?.getValue(), 5); // from attr2
        expect(merged.$overflow?.getValue(), TextOverflow.clip); // from attr1
        expect(merged.$textAlign?.getValue(), TextAlign.left); // from attr1
        expect(merged.$style, isNotNull); // from attr2
        expect(merged.$softWrap?.getValue(), true); // from attr2
      });

      test('returns original when merging with null', () {
        final original = TextSpecAttribute.only(
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        );
        final merged = original.merge(null);

        expect(merged, original);
      });

      test('handles complex merge scenarios', () {
        final attr1 = TextSpecAttribute.only(
          style: TextStyleMix(fontSize: Prop(14.0)),
          strutStyle: StrutStyleMix(fontSize: Prop(14.0)),
        );

        final attr2 = TextSpecAttribute.only(
          style: TextStyleMix(color: Prop(Colors.blue)),
          textHeightBehavior: TextHeightBehaviorMix(),
        );

        final merged = attr1.merge(attr2);

        // Style should be merged (attr2 takes precedence)
        expect(merged.$style, isNotNull);
        expect(merged.$textHeightBehavior, isNotNull);
        expect(merged.$strutStyle, isNotNull);
      });
    });

    group('Utility Properties', () {
      test('has all expected utility properties', () {
        final attribute = TextSpecAttribute();

        // Basic properties - just check they exist
        expect(attribute.overflow, isNotNull);
        expect(attribute.strutStyle, isNotNull);
        expect(attribute.textAlign, isNotNull);
        expect(attribute.textScaler, isNotNull);
        expect(attribute.maxLines, isNotNull);
        expect(attribute.style, isNotNull);
        expect(attribute.textWidthBasis, isNotNull);
        expect(attribute.textHeightBehavior, isNotNull);
        expect(attribute.textDirection, isNotNull);
        expect(attribute.softWrap, isNotNull);

        // Text style utilities
        expect(attribute.fontSize, isNotNull);
        expect(attribute.fontWeight, isNotNull);
        expect(attribute.fontStyle, isNotNull);
        expect(attribute.letterSpacing, isNotNull);
        expect(attribute.wordSpacing, isNotNull);
        expect(attribute.textBaseline, isNotNull);
        expect(attribute.height, isNotNull);
        expect(attribute.foreground, isNotNull);
        expect(attribute.background, isNotNull);
        expect(attribute.shadows, isNotNull);
        expect(attribute.fontFeatures, isNotNull);
        expect(attribute.fontVariations, isNotNull);
        expect(attribute.decoration, isNotNull);
        expect(attribute.decorationColor, isNotNull);
        expect(attribute.decorationStyle, isNotNull);
        expect(attribute.decorationThickness, isNotNull);
        expect(attribute.debugLabel, isNotNull);
        expect(attribute.fontFamily, isNotNull);
        expect(attribute.fontFamilyFallback, isNotNull);

        // Text directive utilities
        expect(attribute.directive, isNotNull);
        expect(attribute.uppercase, isNotNull);
        expect(attribute.lowercase, isNotNull);
        expect(attribute.capitalize, isNotNull);
        expect(attribute.titleCase, isNotNull);
        expect(attribute.sentenceCase, isNotNull);
      });
    });

    group('Helper Methods', () {
      test('utility methods create proper attributes', () {
        final attribute = TextSpecAttribute();

        // Test that utility methods exist and return proper types
        final fontSizeAttr = attribute.fontSize(16.0);
        expect(fontSizeAttr, isA<TextSpecAttribute>());

        final fontWeightAttr = attribute.fontWeight(FontWeight.bold);
        expect(fontWeightAttr, isA<TextSpecAttribute>());

        final colorAttr = attribute.color(Colors.blue);
        expect(colorAttr, isA<TextSpecAttribute>());
      });
    });

    group('Builder pattern', () {
      test('builder methods create new instances', () {
        final original = TextSpecAttribute();
        final modified = original.maxLines(3);

        expect(identical(original, modified), isFalse);
        expect(original.$maxLines, isNull);
        expect(modified.$maxLines?.getValue(), 3);
      });

      test('builder methods can be chained fluently with merge', () {
        final attribute = TextSpecAttribute()
            .maxLines(3)
            .merge(TextSpecAttribute().overflow(TextOverflow.ellipsis))
            .merge(TextSpecAttribute().textAlign(TextAlign.center))
            .merge(TextSpecAttribute().fontSize(16.0));

        final context = SpecTestHelper.createMockContext();
        final spec = attribute.resolve(context);

        expect(spec.maxLines, 3);
        expect(spec.overflow, TextOverflow.ellipsis);
        expect(spec.textAlign, TextAlign.center);
        expect(spec.style, isA<TextStyle>());
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final attribute = TextSpecAttribute(
          overflow: Prop(TextOverflow.ellipsis),
          strutStyle: MixProp(StrutStyleMix(fontSize: Prop(16.0))),
          textAlign: Prop(TextAlign.center),
          maxLines: Prop(3),
          style: MixProp(TextStyleMix(fontSize: Prop(14.0))),
          softWrap: Prop(false),
        );

        expect(attribute.props.length, 11);
        expect(attribute.props, contains(attribute.$overflow));
        expect(attribute.props, contains(attribute.$strutStyle));
        expect(attribute.props, contains(attribute.$textAlign));
        expect(attribute.props, contains(attribute.$maxLines));
        expect(attribute.props, contains(attribute.$style));
        expect(attribute.props, contains(attribute.$softWrap));
      });
    });

    group('equality', () {
      test('attributes with same properties are equal', () {
        final attr1 = TextSpecAttribute.only(
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        );
        final attr2 = TextSpecAttribute.only(
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        );

        expect(attr1, attr2);
        expect(attr1.hashCode, attr2.hashCode);
      });

      test('attributes with different properties are not equal', () {
        final attr1 = TextSpecAttribute.only(
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        );
        final attr2 = TextSpecAttribute.only(
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        );

        expect(attr1, isNot(attr2));
      });
    });
  });
}
