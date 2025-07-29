import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextSpecAttribute', () {
    group('Constructor', () {
      test('creates TextSpecAttribute with all properties', () {
        final attribute = TextMix.raw(
          overflow: Prop(TextOverflow.ellipsis),
          strutStyle: MixProp(StrutStyleMix.raw(fontSize: Prop(16.0))),
          textAlign: Prop(TextAlign.center),
          textScaler: Prop(TextScaler.linear(1.2)),
          maxLines: Prop(3),
          style: MixProp(TextStyleMix.raw($fontSize: Prop(14.0))),
          textWidthBasis: Prop(TextWidthBasis.longestLine),
          textHeightBehavior: MixProp(TextHeightBehaviorMix()),
          textDirection: Prop(TextDirection.rtl),
          softWrap: Prop(false),
          directives: [],
        );

        expect(attribute.$overflow, resolvesTo(TextOverflow.ellipsis));
        expect(attribute.$textAlign, resolvesTo(TextAlign.center));
        expect(attribute.$textScaler, resolvesTo(TextScaler.linear(1.2)));
        expect(attribute.$maxLines, resolvesTo(3));
        expect(
          attribute.$textWidthBasis,
          resolvesTo(TextWidthBasis.longestLine),
        );
        expect(attribute.$textDirection, resolvesTo(TextDirection.rtl));
        expect(attribute.$softWrap, resolvesTo(false));
        expect(attribute.$directives, isEmpty);
      });

      test('creates TextSpecAttribute with default values', () {
        final attribute = TextMix();

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
        final attribute = TextMix(
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyleMix(fontSize: 16.0),
        );

        expect(attribute.$overflow, resolvesTo(TextOverflow.ellipsis));
        expect(attribute.$maxLines, resolvesTo(3));
        expect(attribute.$textAlign, resolvesTo(TextAlign.center));
        expect(attribute.$style, isNotNull);
        expect(attribute.$strutStyle, isNull);
        expect(attribute.$textScaler, isNull);
      });

      test('handles null values correctly', () {
        final attribute = TextMix();

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

        final attribute = TextMix.value(spec);

        expect(attribute.$overflow, resolvesTo(TextOverflow.ellipsis));
        expect(attribute.$textAlign, resolvesTo(TextAlign.center));
        expect(attribute.$textScaler, resolvesTo(TextScaler.linear(1.2)));
        expect(attribute.$maxLines, resolvesTo(3));
        expect(
          attribute.$textWidthBasis,
          resolvesTo(TextWidthBasis.longestLine),
        );
        expect(attribute.$textDirection, resolvesTo(TextDirection.rtl));
        expect(attribute.$softWrap, resolvesTo(false));
        expect(attribute.$directives, isEmpty);
      });

      test('handles null properties in spec', () {
        const spec = TextSpec(maxLines: 3);
        final attribute = TextMix.value(spec);

        expect(attribute.$maxLines, resolvesTo(3));
        expect(attribute.$overflow, isNull);
        expect(attribute.$textAlign, isNull);
      });
    });

    group('maybeValue static method', () {
      test('returns TextSpecAttribute when spec is not null', () {
        const spec = TextSpec(maxLines: 3, overflow: TextOverflow.ellipsis);
        final attribute = TextMix.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$maxLines, resolvesTo(3));
        expect(attribute.$overflow, resolvesTo(TextOverflow.ellipsis));
      });

      test('returns null when spec is null', () {
        final attribute = TextMix.maybeValue(null);
        expect(attribute, isNull);
      });
    });

    group('Resolution', () {
      test('resolves to TextSpec with correct properties', () {
        final attribute = TextMix(
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyleMix(fontSize: 16.0),
          strutStyle: StrutStyleMix(fontSize: 16.0),
          softWrap: true,
        );

        final context = MockBuildContext();
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
        final attribute = TextMix(maxLines: 3);
        final context = MockBuildContext();
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
        final attr1 = TextMix(
          maxLines: 3,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.left,
        );

        final attr2 = TextMix(
          maxLines: 5,
          style: TextStyleMix(fontSize: 16.0),
          softWrap: true,
        );

        final merged = attr1.merge(attr2);

        expect(merged.$maxLines, resolvesTo(5)); // from attr2
        expect(merged.$overflow, resolvesTo(TextOverflow.clip)); // from attr1
        expect(merged.$textAlign, resolvesTo(TextAlign.left)); // from attr1
        expect(merged.$style, isNotNull); // from attr2
        expect(merged.$softWrap, resolvesTo(true)); // from attr2
      });

      test('returns original when merging with null', () {
        final original = TextMix(maxLines: 3, overflow: TextOverflow.ellipsis);
        final merged = original.merge(null);

        expect(merged, original);
      });

      test('handles complex merge scenarios', () {
        final attr1 = TextMix(
          style: TextStyleMix(fontSize: 14.0),
          strutStyle: StrutStyleMix(fontSize: 14.0),
        );

        final attr2 = TextMix(
          style: TextStyleMix(color: Colors.blue),
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
        final attribute = TextMix();

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
        final attribute = TextMix();

        // Test that utility methods exist and return proper types
        final fontSizeAttr = attribute.fontSize(16.0);
        expect(fontSizeAttr, isA<TextMix>());

        final fontWeightAttr = attribute.fontWeight(FontWeight.bold);
        expect(fontWeightAttr, isA<TextMix>());

        final colorAttr = attribute.color(Colors.blue);
        expect(colorAttr, isA<TextMix>());
      });
    });

    group('Builder pattern', () {
      test('builder methods create new instances', () {
        final original = TextMix();
        final modified = original.maxLines(3);

        expect(identical(original, modified), isFalse);
        expect(original.$maxLines, isNull);
        expect(modified.$maxLines, resolvesTo(3));
      });

      test('chaining utilities accumulates properties correctly', () {
        // Chaining now properly accumulates all properties
        final chained = TextMix()
            .maxLines(3)
            .overflow(TextOverflow.ellipsis)
            .textAlign(TextAlign.center)
            .fontSize(16.0)
            .fontWeight(FontWeight.bold)
            .color(Colors.blue)
            .letterSpacing(1.5)
            .softWrap(false);

        final context = MockBuildContext();
        final spec = chained.resolve(context);

        // All properties should be accumulated
        expect(spec.maxLines, 3);
        expect(spec.overflow, TextOverflow.ellipsis);
        expect(spec.textAlign, TextAlign.center);
        expect(spec.style, isNotNull);
        expect(spec.style!.fontSize, 16.0);
        expect(spec.style!.fontWeight, FontWeight.bold);
        expect(spec.style!.color, Colors.blue);
        expect(spec.style!.letterSpacing, 1.5);
        expect(spec.softWrap, false);
      });

      test('chaining with complex properties works correctly', () {
        // Test chaining with more complex properties
        final chained = TextMix()
            .fontFamily('Roboto')
            .shadows([
              ShadowMix(
                color: Colors.black,
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ])
            .decoration(TextDecoration.underline)
            .decorationColor(Colors.red)
            .decorationStyle(TextDecorationStyle.wavy)
            .uppercase(); // directive

        final context = MockBuildContext();
        final spec = chained.resolve(context);

        expect(spec.style, isNotNull);
        expect(spec.style!.fontFamily, 'Roboto');
        expect(spec.style!.shadows, isNotNull);
        expect(spec.style!.shadows!.length, 1);
        expect(spec.style!.decoration, TextDecoration.underline);
        expect(spec.style!.decorationColor, Colors.red);
        expect(spec.style!.decorationStyle, TextDecorationStyle.wavy);
        // Note: directives are handled separately in TextSpec
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final attribute = TextMix(
          overflow: TextOverflow.ellipsis,
          strutStyle: StrutStyleMix(fontSize: 16.0),
          textAlign: TextAlign.center,
          maxLines: 3,
          style: TextStyleMix(fontSize: 14.0),
          softWrap: false,
        );

        expect(attribute.props.length, 14);
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
        final attr1 = TextMix(
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        );
        final attr2 = TextMix(
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        );

        expect(attr1, attr2);
        expect(attr1.hashCode, attr2.hashCode);
      });

      test('attributes with different properties are not equal', () {
        final attr1 = TextMix(maxLines: 3, overflow: TextOverflow.ellipsis);
        final attr2 = TextMix(maxLines: 5, overflow: TextOverflow.ellipsis);

        expect(attr1, isNot(attr2));
      });
    });
  });
}
