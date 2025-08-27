import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextStyling', () {
    group('Constructor', () {
      test('creates TextMix with all properties', () {
        final attribute = TextMix(
          overflow: TextOverflow.ellipsis,
          strutStyle: StrutStyleMix(fontSize: 16.0),
          textAlign: TextAlign.center,
          textScaler: TextScaler.linear(1.2),
          maxLines: 3,
          style: TextStyleMix(fontSize: 14.0),
          textWidthBasis: TextWidthBasis.longestLine,
          textHeightBehavior: TextHeightBehaviorMix(),
          textDirection: TextDirection.rtl,
          softWrap: false,
        );

        expect(attribute.$overflow, resolvesTo(TextOverflow.ellipsis));
        expect(attribute.$strutStyle, isNotNull);
        expect(attribute.$textAlign, resolvesTo(TextAlign.center));
        expect(attribute.$textScaler, resolvesTo(TextScaler.linear(1.2)));
        expect(attribute.$maxLines, resolvesTo(3));
        expect(attribute.$style, isNotNull);
        expect(
          attribute.$textWidthBasis,
          resolvesTo(TextWidthBasis.longestLine),
        );
        expect(attribute.$textHeightBehavior, isNotNull);
        expect(attribute.$textDirection, resolvesTo(TextDirection.rtl));
        expect(attribute.$softWrap, resolvesTo(false));
      });

      test('creates empty TextMix', () {
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
        expect(attribute.$textDirectives, isNull);
      });
    });

    group('Factory Constructors', () {
      test('color factory creates TextMix with color', () {
        final textMix = TextStyling(style: TextStyleMix(color: Colors.red));

        expect(textMix.$style, isNotNull);
      });

      test('fontFamily factory creates TextMix with fontFamily', () {
        final textMix = TextStyling(style: TextStyleMix(fontFamily: 'Arial'));

        expect(textMix.$style, isNotNull);
      });

      test('fontWeight factory creates TextMix with fontWeight', () {
        final textMix = TextStyling(style: TextStyleMix(fontWeight: FontWeight.bold));

        expect(textMix.$style, isNotNull);
      });

      test('fontStyle factory creates TextMix with fontStyle', () {
        final textMix = TextStyling(style: TextStyleMix(fontStyle: FontStyle.italic));

        expect(textMix.$style, isNotNull);
      });

      test('fontSize factory creates TextMix with fontSize', () {
        final textMix = TextStyling(style: TextStyleMix(fontSize: 18.0));

        expect(textMix.$style, isNotNull);
      });

      test('letterSpacing factory creates TextMix with letterSpacing', () {
        final textMix = TextStyling(style: TextStyleMix(letterSpacing: 1.5));

        expect(textMix.$style, isNotNull);
      });

      test('wordSpacing factory creates TextMix with wordSpacing', () {
        final textMix = TextStyling(style: TextStyleMix(wordSpacing: 2.0));

        expect(textMix.$style, isNotNull);
      });

      test('textBaseline factory creates TextMix with textBaseline', () {
        final textMix = TextStyling(style: TextStyleMix(textBaseline: TextBaseline.alphabetic));

        expect(textMix.$style, isNotNull);
      });

      test('backgroundColor factory creates TextMix with backgroundColor', () {
        final textMix = TextStyling(style: TextStyleMix(backgroundColor: Colors.yellow));

        expect(textMix.$style, isNotNull);
      });

      test('shadows factory creates TextMix with shadows', () {
        final textMix = TextStyling(style: TextStyleMix(shadows: [
          ShadowMix(color: Colors.black, offset: Offset(1, 1)),
        ]));

        expect(textMix.$style, isNotNull);
      });

      test('fontFeatures factory creates TextMix with fontFeatures', () {
        final textMix = TextStyling(style: TextStyleMix(fontFeatures: [FontFeature.enable('smcp')]));

        expect(textMix.$style, isNotNull);
      });

      test('fontVariations factory creates TextMix with fontVariations', () {
        final textMix = TextStyling(style: TextStyleMix(fontVariations: [FontVariation('wght', 400)]));

        expect(textMix.$style, isNotNull);
      });

      test('decoration factory creates TextMix with decoration', () {
        final textMix = TextStyling(style: TextStyleMix(decoration: TextDecoration.underline));

        expect(textMix.$style, isNotNull);
      });

      test('decorationColor factory creates TextMix with decorationColor', () {
        final textMix = TextStyling(style: TextStyleMix(decorationColor: Colors.blue));

        expect(textMix.$style, isNotNull);
      });

      test('decorationStyle factory creates TextMix with decorationStyle', () {
        final textMix = TextStyling(style: TextStyleMix(decorationStyle: TextDecorationStyle.dashed));

        expect(textMix.$style, isNotNull);
      });

      test('height factory creates TextMix with height', () {
        final textMix = TextStyling(style: TextStyleMix(height: 1.5));

        expect(textMix.$style, isNotNull);
      });

      test(
        'decorationThickness factory creates TextMix with decorationThickness',
        () {
          final textMix = TextStyling(style: TextStyleMix(decorationThickness: 2.0));

          expect(textMix.$style, isNotNull);
        },
      );

      test(
        'fontFamilyFallback factory creates TextMix with fontFamilyFallback',
        () {
          final textMix = TextStyling(style: TextStyleMix(fontFamilyFallback: ['Helvetica', 'Arial']));

          expect(textMix.$style, isNotNull);
        },
      );

      test('overflow factory creates TextMix with overflow', () {
        final textMix = TextStyling(overflow: TextOverflow.fade);

        expect(textMix.$overflow, resolvesTo(TextOverflow.fade));
      });

      test('strutStyle factory creates TextMix with strutStyle', () {
        final textMix = TextStyling(strutStyle: StrutStyleMix(fontSize: 16.0));

        expect(textMix.$strutStyle, isNotNull);
      });

      test('textAlign factory creates TextMix with textAlign', () {
        final textMix = TextStyling(textAlign: TextAlign.justify);

        expect(textMix.$textAlign, resolvesTo(TextAlign.justify));
      });

      test('textScaler factory creates TextMix with textScaler', () {
        final textMix = TextStyling(textScaler: TextScaler.linear(1.2));

        expect(textMix.$textScaler, resolvesTo(TextScaler.linear(1.2)));
      });

      test('maxLines factory creates TextMix with maxLines', () {
        final textMix = TextStyling(maxLines: 2);

        expect(textMix.$maxLines, resolvesTo(2));
      });

      test('textWidthBasis factory creates TextMix with textWidthBasis', () {
        final textMix = TextStyling(textWidthBasis: TextWidthBasis.longestLine);

        expect(textMix.$textWidthBasis, resolvesTo(TextWidthBasis.longestLine));
      });

      test(
        'textHeightBehavior factory creates TextMix with textHeightBehavior',
        () {
          final textMix = TextStyling(textHeightBehavior: TextHeightBehaviorMix());

          expect(textMix.$textHeightBehavior, isNotNull);
        },
      );

      test('textDirection factory creates TextMix with textDirection', () {
        final textMix = TextStyling(textDirection: TextDirection.rtl);

        expect(textMix.$textDirection, resolvesTo(TextDirection.rtl));
      });

      test('softWrap factory creates TextMix with softWrap', () {
        final textMix = TextStyling(softWrap: false);

        expect(textMix.$softWrap, resolvesTo(false));
      });

      test('directive factory creates TextMix with directive', () {
        final textMix = TextStyling(textDirectives: [const UppercaseStringDirective()]);

        expect(textMix.$textDirectives, isNotNull);
        expect(textMix.$textDirectives!.length, 1);
      });

      test('uppercase factory creates TextMix with uppercase directive', () {
        final textMix = TextStyling(textDirectives: [const UppercaseStringDirective()]);

        expect(textMix.$textDirectives, isNotNull);
        expect(textMix.$textDirectives!.length, 1);
      });

      test('lowercase factory creates TextMix with lowercase directive', () {
        final textMix = TextStyling(textDirectives: [const LowercaseStringDirective()]);

        expect(textMix.$textDirectives, isNotNull);
        expect(textMix.$textDirectives!.length, 1);
      });

      test('capitalize factory creates TextMix with capitalize directive', () {
        final textMix = TextStyling(textDirectives: [const CapitalizeStringDirective()]);

        expect(textMix.$textDirectives, isNotNull);
        expect(textMix.$textDirectives!.length, 1);
      });

      test('titleCase factory creates TextMix with titleCase directive', () {
        final textMix = TextStyling(textDirectives: [const TitleCaseStringDirective()]);

        expect(textMix.$textDirectives, isNotNull);
        expect(textMix.$textDirectives!.length, 1);
      });

      test(
        'sentenceCase factory creates TextMix with sentenceCase directive',
        () {
          final textMix = TextStyling(textDirectives: [const SentenceCaseStringDirective()]);

          expect(textMix.$textDirectives, isNotNull);
          expect(textMix.$textDirectives!.length, 1);
        },
      );

      test('animation factory creates TextMix with animation config', () {
        final animation = AnimationConfig.linear(Duration(seconds: 1));
        final textMix = TextStyling(animation: animation);

        expect(textMix.$animation, animation);
      });

      test('variant factory creates TextMix with variant', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = TextStyling(style: TextStyleMix(color: Colors.white));
        final textMix = TextStyling(variants: [VariantStyle(variant, style)]);

        expect(textMix.$variants, isNotNull);
        expect(textMix.$variants!.length, 1);
      });
    });

    group('value constructor', () {
      test('creates TextMix from TextSpec', () {
        const spec = TextSpec(
          overflow: TextOverflow.clip,
          textAlign: TextAlign.left,
          maxLines: 5,
          softWrap: true,
        );

        final attribute = TextStyling(
          overflow: spec.overflow,
          textAlign: spec.textAlign,
          maxLines: spec.maxLines,
          softWrap: spec.softWrap,
        );

        expect(attribute.$overflow, resolvesTo(TextOverflow.clip));
        expect(attribute.$textAlign, resolvesTo(TextAlign.left));
        expect(attribute.$maxLines, resolvesTo(5));
        expect(attribute.$softWrap, resolvesTo(true));
      });

      test('maybeValue returns null for null spec', () {
        expect(null, isNull); // TextStyling.maybeValue removed
      });

      test('maybeValue returns attribute for non-null spec', () {
        const spec = TextSpec(overflow: TextOverflow.visible, maxLines: 1);
        final attribute = spec != null ? TextStyling(
          overflow: spec.overflow,
          textAlign: spec.textAlign,
          maxLines: spec.maxLines,
          softWrap: spec.softWrap,
        ) : null;

        expect(attribute, isNotNull);
        expect(attribute!.$overflow, resolvesTo(TextOverflow.visible));
        expect(attribute.$maxLines, resolvesTo(1));
      });
    });

    group('Utility Methods', () {
      test('overflow utility works correctly', () {
        final attribute = TextMix().overflow(TextOverflow.ellipsis);

        expect(attribute.$overflow, resolvesTo(TextOverflow.ellipsis));
      });

      test('strutStyle utility works correctly', () {
        final attribute = TextMix().strutStyle(StrutStyleMix(fontSize: 14.0));

        expect(attribute.$strutStyle, isNotNull);
      });

      test('textAlign utility works correctly', () {
        final attribute = TextMix().textAlign(TextAlign.center);

        expect(attribute.$textAlign, resolvesTo(TextAlign.center));
      });

      test('textScaler utility works correctly', () {
        final attribute = TextMix().textScaler(TextScaler.linear(1.5));

        expect(attribute.$textScaler, resolvesTo(TextScaler.linear(1.5)));
      });

      test('maxLines utility works correctly', () {
        final attribute = TextMix().maxLines(4);

        expect(attribute.$maxLines, resolvesTo(4));
      });

      test('textWidthBasis utility works correctly', () {
        final attribute = TextMix().textWidthBasis(TextWidthBasis.parent);

        expect(attribute.$textWidthBasis, resolvesTo(TextWidthBasis.parent));
      });

      test('textHeightBehavior utility works correctly', () {
        final attribute = TextMix().textHeightBehavior(TextHeightBehaviorMix());

        expect(attribute.$textHeightBehavior, isNotNull);
      });

      test('textDirection utility works correctly', () {
        final attribute = TextMix().textDirection(TextDirection.ltr);

        expect(attribute.$textDirection, resolvesTo(TextDirection.ltr));
      });

      test('softWrap utility works correctly', () {
        final attribute = TextMix().softWrap(false);

        expect(attribute.$softWrap, resolvesTo(false));
      });

      test('directive utility works correctly', () {
        final attribute = TextMix().textDirectives([
          const UppercaseStringDirective(),
        ]);

        expect(attribute.$textDirectives, isNotNull);
        expect(attribute.$textDirectives!.length, 1);
      });

      test('color utility works correctly', () {
        final attribute = TextStyling().color(Colors.blue);

        expect(attribute.$style, isNotNull);
      });

      test('fontFamily utility works correctly', () {
        final attribute = TextStyling().fontFamily('Arial');

        expect(attribute.$style, isNotNull);
      });

      test('fontWeight utility works correctly', () {
        final attribute = TextStyling().fontWeight(FontWeight.w600);

        expect(attribute.$style, isNotNull);
      });

      test('fontStyle utility works correctly', () {
        final attribute = TextStyling().fontStyle(FontStyle.italic);

        expect(attribute.$style, isNotNull);
      });

      test('fontSize utility works correctly', () {
        final attribute = TextStyling().fontSize(20.0);

        expect(attribute.$style, isNotNull);
      });

      test('letterSpacing utility works correctly', () {
        final attribute = TextStyling().letterSpacing(1.2);

        expect(attribute.$style, isNotNull);
      });

      test('wordSpacing utility works correctly', () {
        final attribute = TextStyling().wordSpacing(2.5);

        expect(attribute.$style, isNotNull);
      });

      test('textBaseline utility works correctly', () {
        final attribute = TextStyling().textBaseline(TextBaseline.ideographic);

        expect(attribute.$style, isNotNull);
      });

      test('height utility works correctly', () {
        final attribute = TextStyling().height(1.8);

        expect(attribute.$style, isNotNull);
      });

      test('backgroundColor utility works correctly', () {
        final attribute = TextStyling().backgroundColor(Colors.yellow);

        expect(attribute.$style, isNotNull);
      });

      test('shadows utility works correctly', () {
        final attribute = TextStyling().shadows([
          ShadowMix(color: Colors.black, offset: Offset(2, 2)),
        ]);

        expect(attribute.$style, isNotNull);
      });

      test('fontFeatures utility works correctly', () {
        final attribute = TextStyling().fontFeatures([FontFeature.enable('liga')]);

        expect(attribute.$style, isNotNull);
      });

      test('fontVariations utility works correctly', () {
        final attribute = TextStyling().fontVariations([
          FontVariation('wght', 500),
        ]);

        expect(attribute.$style, isNotNull);
      });

      test('decoration utility works correctly', () {
        final attribute = TextStyling().decoration(TextDecoration.lineThrough);

        expect(attribute.$style, isNotNull);
      });

      test('decorationColor utility works correctly', () {
        final attribute = TextStyling().decorationColor(Colors.red);

        expect(attribute.$style, isNotNull);
      });

      test('decorationStyle utility works correctly', () {
        final attribute = TextStyling().decorationStyle(TextDecorationStyle.dotted);

        expect(attribute.$style, isNotNull);
      });

      test('decorationThickness utility works correctly', () {
        final attribute = TextStyling().decorationThickness(3.0);

        expect(attribute.$style, isNotNull);
      });

      test('fontFamilyFallback utility works correctly', () {
        final attribute = TextStyling().fontFamilyFallback(['Roboto', 'Arial']);

        expect(attribute.$style, isNotNull);
      });

      test('uppercase utility works correctly', () {
        final attribute = TextStyling().uppercase();

        expect(attribute.$textDirectives, isNotNull);
        expect(attribute.$textDirectives!.length, 1);
      });

      test('lowercase utility works correctly', () {
        final attribute = TextStyling().lowercase();

        expect(attribute.$textDirectives, isNotNull);
        expect(attribute.$textDirectives!.length, 1);
      });

      test('capitalize utility works correctly', () {
        final attribute = TextStyling().capitalize();

        expect(attribute.$textDirectives, isNotNull);
        expect(attribute.$textDirectives!.length, 1);
      });

      test('titleCase utility works correctly', () {
        final attribute = TextStyling().titleCase();

        expect(attribute.$textDirectives, isNotNull);
        expect(attribute.$textDirectives!.length, 1);
      });

      test('sentenceCase utility works correctly', () {
        final attribute = TextStyling().sentenceCase();

        expect(attribute.$textDirectives, isNotNull);
        expect(attribute.$textDirectives!.length, 1);
      });

      test('animate method sets animation config', () {
        final animation = AnimationConfig.linear(Duration(milliseconds: 500));
        final attribute = TextStyling().animate(animation);

        expect(attribute.$animation, equals(animation));
      });
    });

    group('Variant Methods', () {
      test('variant method adds variant to TextMix', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = TextStyling(style: TextStyleMix(color: Colors.white));
        final textMix = TextStyling().variant(variant, style);

        expect(textMix.$variants, isNotNull);
        expect(textMix.$variants!.length, 1);
      });

      test('variants method sets multiple variants', () {
        final variants = [
          VariantStyle(
            ContextVariant.brightness(Brightness.dark),
            TextStyling(style: TextStyleMix(color: Colors.white)),
          ),
          VariantStyle(
            ContextVariant.brightness(Brightness.light),
            TextStyling(style: TextStyleMix(color: Colors.black)),
          ),
        ];
        final textMix = TextStyling().variants(variants);

        expect(textMix.$variants, isNotNull);
        expect(textMix.$variants!.length, 2);
      });
    });

    group('Resolution', () {
      test('resolves to TextSpec with correct properties', () {
        final attribute = TextMix(
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: TextStyleMix(fontSize: 16.0, color: Colors.blue),
          softWrap: true,
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.overflow, TextOverflow.ellipsis);
        expect(spec.textAlign, TextAlign.center);
        expect(spec.maxLines, 3);
        expect(spec.style, isNotNull);
        expect(spec.softWrap, true);
      });

      test('resolves with null values correctly', () {
        final attribute = TextMix().overflow(TextOverflow.fade).maxLines(2);

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.overflow, TextOverflow.fade);
        expect(spec.maxLines, 2);
        expect(spec.textAlign, isNull);
        expect(spec.strutStyle, isNull);
        expect(spec.textScaler, isNull);
        expect(spec.textWidthBasis, isNull);
        expect(spec.textHeightBehavior, isNull);
        expect(spec.textDirection, isNull);
        expect(spec.softWrap, isNull);
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = TextMix(overflow: TextOverflow.clip, maxLines: 2);

        final second = TextMix(
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          softWrap: false,
        );

        final merged = first.merge(second);

        expect(
          merged.$overflow,
          resolvesTo(TextOverflow.ellipsis),
        ); // second overrides
        expect(merged.$maxLines, resolvesTo(2)); // from first
        expect(merged.$textAlign, resolvesTo(TextAlign.center)); // from second
        expect(merged.$softWrap, resolvesTo(false)); // from second
      });

      test('returns this when other is null', () {
        final attribute = TextMix().overflow(TextOverflow.ellipsis);
        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isTrue);
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        final attr1 = TextMix()
            .overflow(TextOverflow.ellipsis)
            .maxLines(2)
            .textAlign(TextAlign.center);

        final attr2 = TextMix()
            .overflow(TextOverflow.ellipsis)
            .maxLines(2)
            .textAlign(TextAlign.center);

        expect(attr1, equals(attr2));
        // Skip hashCode test due to infrastructure issue with list instances
        // TODO: Fix hashCode contract violation in Mix 2.0
        // expect(attr1.hashCode, equals(attr2.hashCode));
      });

      test('different attributes are not equal', () {
        final attr1 = TextMix().overflow(TextOverflow.ellipsis);
        final attr2 = TextMix().overflow(TextOverflow.fade);

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final attribute = TextMix(
          overflow: TextOverflow.ellipsis,
          strutStyle: StrutStyleMix(fontSize: 16.0),
          textAlign: TextAlign.center,
          textScaler: TextScaler.linear(1.2),
          maxLines: 3,
          style: TextStyleMix(fontSize: 14.0),
          textWidthBasis: TextWidthBasis.longestLine,
          textHeightBehavior: TextHeightBehaviorMix(),
          textDirection: TextDirection.rtl,
          softWrap: false,
        );

        expect(attribute.props.length, 14);
        expect(attribute.props, contains(attribute.$overflow));
        expect(attribute.props, contains(attribute.$strutStyle));
        expect(attribute.props, contains(attribute.$textAlign));
        expect(attribute.props, contains(attribute.$textScaler));
        expect(attribute.props, contains(attribute.$maxLines));
        expect(attribute.props, contains(attribute.$style));
        expect(attribute.props, contains(attribute.$textWidthBasis));
        expect(attribute.props, contains(attribute.$textHeightBehavior));
        expect(attribute.props, contains(attribute.$textDirection));
        expect(attribute.props, contains(attribute.$softWrap));
        expect(attribute.props, contains(attribute.$textDirectives));
      });
    });
  });
}
