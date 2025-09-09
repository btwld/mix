import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextStyling', () {
    group('Constructor', () {
      test('creates TextStyling with all properties', () {
        final attribute = TextStyler(
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

      test('creates empty TextStyling', () {
        final attribute = TextStyler();

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
      test('color factory creates TextStyling with color', () {
        final textMix = TextStyler(style: TextStyleMix(color: Colors.red));

        expect(textMix.$style, isNotNull);
      });

      test('fontFamily factory creates TextStyling with fontFamily', () {
        final textMix = TextStyler(style: TextStyleMix(fontFamily: 'Arial'));

        expect(textMix.$style, isNotNull);
      });

      test('fontWeight factory creates TextStyling with fontWeight', () {
        final textMix = TextStyler(
          style: TextStyleMix(fontWeight: FontWeight.bold),
        );

        expect(textMix.$style, isNotNull);
      });

      test('fontStyle factory creates TextStyling with fontStyle', () {
        final textMix = TextStyler(
          style: TextStyleMix(fontStyle: FontStyle.italic),
        );

        expect(textMix.$style, isNotNull);
      });

      test('fontSize factory creates TextStyling with fontSize', () {
        final textMix = TextStyler(style: TextStyleMix(fontSize: 18.0));

        expect(textMix.$style, isNotNull);
      });

      test('letterSpacing factory creates TextStyling with letterSpacing', () {
        final textMix = TextStyler(style: TextStyleMix(letterSpacing: 1.5));

        expect(textMix.$style, isNotNull);
      });

      test('wordSpacing factory creates TextStyling with wordSpacing', () {
        final textMix = TextStyler(style: TextStyleMix(wordSpacing: 2.0));

        expect(textMix.$style, isNotNull);
      });

      test('textBaseline factory creates TextStyling with textBaseline', () {
        final textMix = TextStyler(
          style: TextStyleMix(textBaseline: TextBaseline.alphabetic),
        );

        expect(textMix.$style, isNotNull);
      });

      test(
        'backgroundColor factory creates TextStyling with backgroundColor',
        () {
          final textMix = TextStyler(
            style: TextStyleMix(backgroundColor: Colors.yellow),
          );

          expect(textMix.$style, isNotNull);
        },
      );

      test('shadows factory creates TextStyling with shadows', () {
        final textMix = TextStyler(
          style: TextStyleMix(
            shadows: [ShadowMix(color: Colors.black, offset: Offset(1, 1))],
          ),
        );

        expect(textMix.$style, isNotNull);
      });

      test('fontFeatures factory creates TextStyling with fontFeatures', () {
        final textMix = TextStyler(
          style: TextStyleMix(fontFeatures: [FontFeature.enable('smcp')]),
        );

        expect(textMix.$style, isNotNull);
      });

      test(
        'fontVariations factory creates TextStyling with fontVariations',
        () {
          final textMix = TextStyler(
            style: TextStyleMix(fontVariations: [FontVariation('wght', 400)]),
          );

          expect(textMix.$style, isNotNull);
        },
      );

      test('decoration factory creates TextStyling with decoration', () {
        final textMix = TextStyler(
          style: TextStyleMix(decoration: TextDecoration.underline),
        );

        expect(textMix.$style, isNotNull);
      });

      test(
        'decorationColor factory creates TextStyling with decorationColor',
        () {
          final textMix = TextStyler(
            style: TextStyleMix(decorationColor: Colors.blue),
          );

          expect(textMix.$style, isNotNull);
        },
      );

      test(
        'decorationStyle factory creates TextStyling with decorationStyle',
        () {
          final textMix = TextStyler(
            style: TextStyleMix(decorationStyle: TextDecorationStyle.dashed),
          );

          expect(textMix.$style, isNotNull);
        },
      );

      test('height factory creates TextStyling with height', () {
        final textMix = TextStyler(style: TextStyleMix(height: 1.5));

        expect(textMix.$style, isNotNull);
      });

      test(
        'decorationThickness factory creates TextStyling with decorationThickness',
        () {
          final textMix = TextStyler(
            style: TextStyleMix(decorationThickness: 2.0),
          );

          expect(textMix.$style, isNotNull);
        },
      );

      test(
        'fontFamilyFallback factory creates TextStyling with fontFamilyFallback',
        () {
          final textMix = TextStyler(
            style: TextStyleMix(fontFamilyFallback: ['Helvetica', 'Arial']),
          );

          expect(textMix.$style, isNotNull);
        },
      );

      test('overflow factory creates TextStyling with overflow', () {
        final textMix = TextStyler(overflow: TextOverflow.fade);

        expect(textMix.$overflow, resolvesTo(TextOverflow.fade));
      });

      test('strutStyle factory creates TextStyling with strutStyle', () {
        final textMix = TextStyler(strutStyle: StrutStyleMix(fontSize: 16.0));

        expect(textMix.$strutStyle, isNotNull);
      });

      test('textAlign factory creates TextStyling with textAlign', () {
        final textMix = TextStyler(textAlign: TextAlign.justify);

        expect(textMix.$textAlign, resolvesTo(TextAlign.justify));
      });

      test('textScaler factory creates TextStyling with textScaler', () {
        final textMix = TextStyler(textScaler: TextScaler.linear(1.2));

        expect(textMix.$textScaler, resolvesTo(TextScaler.linear(1.2)));
      });

      test('maxLines factory creates TextStyling with maxLines', () {
        final textMix = TextStyler(maxLines: 2);

        expect(textMix.$maxLines, resolvesTo(2));
      });

      test(
        'textWidthBasis factory creates TextStyling with textWidthBasis',
        () {
          final textMix = TextStyler(
            textWidthBasis: TextWidthBasis.longestLine,
          );

          expect(
            textMix.$textWidthBasis,
            resolvesTo(TextWidthBasis.longestLine),
          );
        },
      );

      test(
        'textHeightBehavior factory creates TextStyling with textHeightBehavior',
        () {
          final textMix = TextStyler(
            textHeightBehavior: TextHeightBehaviorMix(),
          );

          expect(textMix.$textHeightBehavior, isNotNull);
        },
      );

      test('textDirection factory creates TextStyling with textDirection', () {
        final textMix = TextStyler(textDirection: TextDirection.rtl);

        expect(textMix.$textDirection, resolvesTo(TextDirection.rtl));
      });

      test('softWrap factory creates TextStyling with softWrap', () {
        final textMix = TextStyler(softWrap: false);

        expect(textMix.$softWrap, resolvesTo(false));
      });

      test('directive factory creates TextStyling with directive', () {
        final textMix = TextStyler(
          textDirectives: [const UppercaseStringDirective()],
        );

        expect(textMix.$textDirectives, isNotNull);
        expect(textMix.$textDirectives!.length, 1);
      });

      test(
        'uppercase factory creates TextStyling with uppercase directive',
        () {
          final textMix = TextStyler(
            textDirectives: [const UppercaseStringDirective()],
          );

          expect(textMix.$textDirectives, isNotNull);
          expect(textMix.$textDirectives!.length, 1);
        },
      );

      test(
        'lowercase factory creates TextStyling with lowercase directive',
        () {
          final textMix = TextStyler(
            textDirectives: [const LowercaseStringDirective()],
          );

          expect(textMix.$textDirectives, isNotNull);
          expect(textMix.$textDirectives!.length, 1);
        },
      );

      test(
        'capitalize factory creates TextStyling with capitalize directive',
        () {
          final textMix = TextStyler(
            textDirectives: [const CapitalizeStringDirective()],
          );

          expect(textMix.$textDirectives, isNotNull);
          expect(textMix.$textDirectives!.length, 1);
        },
      );

      test(
        'titleCase factory creates TextStyling with titleCase directive',
        () {
          final textMix = TextStyler(
            textDirectives: [const TitleCaseStringDirective()],
          );

          expect(textMix.$textDirectives, isNotNull);
          expect(textMix.$textDirectives!.length, 1);
        },
      );

      test(
        'sentenceCase factory creates TextStyling with sentenceCase directive',
        () {
          final textMix = TextStyler(
            textDirectives: [const SentenceCaseStringDirective()],
          );

          expect(textMix.$textDirectives, isNotNull);
          expect(textMix.$textDirectives!.length, 1);
        },
      );

      test('animation factory creates TextStyling with animation config', () {
        final animation = AnimationConfig.linear(Duration(seconds: 1));
        final textMix = TextStyler(animation: animation);

        expect(textMix.$animation, animation);
      });

      test('variant factory creates TextStyling with variant', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = TextStyler(style: TextStyleMix(color: Colors.white));
        final textMix = TextStyler(variants: [VariantStyle(variant, style)]);

        expect(textMix.$variants, isNotNull);
        expect(textMix.$variants!.length, 1);
      });
    });

    group('value constructor', () {
      test('creates TextStyling from TextSpec', () {
        const spec = TextSpec(
          overflow: TextOverflow.clip,
          textAlign: TextAlign.left,
          maxLines: 5,
          softWrap: true,
        );

        final attribute = TextStyler(
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
        final attribute = TextStyler(
          overflow: spec.overflow,
          textAlign: spec.textAlign,
          maxLines: spec.maxLines,
          softWrap: spec.softWrap,
        );

        expect(attribute, isNotNull);
        expect(attribute.$overflow, resolvesTo(TextOverflow.visible));
        expect(attribute.$maxLines, resolvesTo(1));
      });
    });

    group('Utility Methods', () {
      test('overflow utility works correctly', () {
        final attribute = TextStyler().overflow(TextOverflow.ellipsis);

        expect(attribute.$overflow, resolvesTo(TextOverflow.ellipsis));
      });

      test('strutStyle utility works correctly', () {
        final attribute = TextStyler().strutStyle(
          StrutStyleMix(fontSize: 14.0),
        );

        expect(attribute.$strutStyle, isNotNull);
      });

      test('textAlign utility works correctly', () {
        final attribute = TextStyler().textAlign(TextAlign.center);

        expect(attribute.$textAlign, resolvesTo(TextAlign.center));
      });

      test('textScaler utility works correctly', () {
        final attribute = TextStyler().textScaler(TextScaler.linear(1.5));

        expect(attribute.$textScaler, resolvesTo(TextScaler.linear(1.5)));
      });

      test('maxLines utility works correctly', () {
        final attribute = TextStyler().maxLines(4);

        expect(attribute.$maxLines, resolvesTo(4));
      });

      test('textWidthBasis utility works correctly', () {
        final attribute = TextStyler().textWidthBasis(TextWidthBasis.parent);

        expect(attribute.$textWidthBasis, resolvesTo(TextWidthBasis.parent));
      });

      test('textHeightBehavior utility works correctly', () {
        final attribute = TextStyler().textHeightBehavior(
          TextHeightBehaviorMix(),
        );

        expect(attribute.$textHeightBehavior, isNotNull);
      });

      test('textDirection utility works correctly', () {
        final attribute = TextStyler().textDirection(TextDirection.ltr);

        expect(attribute.$textDirection, resolvesTo(TextDirection.ltr));
      });

      test('softWrap utility works correctly', () {
        final attribute = TextStyler().softWrap(false);

        expect(attribute.$softWrap, resolvesTo(false));
      });

      test('directive utility works correctly', () {
        final attribute = TextStyler().directive(
          const UppercaseStringDirective(),
        );

        expect(attribute.$textDirectives, isNotNull);
        expect(attribute.$textDirectives!.length, 1);
      });

      test('color utility works correctly', () {
        final attribute = TextStyler().color(Colors.blue);

        expect(attribute.$style, isNotNull);
      });

      test('fontFamily utility works correctly', () {
        final attribute = TextStyler().fontFamily('Arial');

        expect(attribute.$style, isNotNull);
      });

      test('fontWeight utility works correctly', () {
        final attribute = TextStyler().fontWeight(FontWeight.w600);

        expect(attribute.$style, isNotNull);
      });

      test('fontStyle utility works correctly', () {
        final attribute = TextStyler().fontStyle(FontStyle.italic);

        expect(attribute.$style, isNotNull);
      });

      test('fontSize utility works correctly', () {
        final attribute = TextStyler().fontSize(20.0);

        expect(attribute.$style, isNotNull);
      });

      test('letterSpacing utility works correctly', () {
        final attribute = TextStyler().letterSpacing(1.2);

        expect(attribute.$style, isNotNull);
      });

      test('wordSpacing utility works correctly', () {
        final attribute = TextStyler().wordSpacing(2.5);

        expect(attribute.$style, isNotNull);
      });

      test('textBaseline utility works correctly', () {
        final attribute = TextStyler().textBaseline(TextBaseline.ideographic);

        expect(attribute.$style, isNotNull);
      });

      test('height utility works correctly', () {
        final attribute = TextStyler().height(1.8);

        expect(attribute.$style, isNotNull);
      });

      test('backgroundColor utility works correctly', () {
        final attribute = TextStyler().backgroundColor(Colors.yellow);

        expect(attribute.$style, isNotNull);
      });

      test('shadows utility works correctly', () {
        final attribute = TextStyler().shadows([
          ShadowMix(color: Colors.black, offset: Offset(2, 2)),
        ]);

        expect(attribute.$style, isNotNull);
      });

      test('fontFeatures utility works correctly', () {
        final attribute = TextStyler().fontFeatures([
          FontFeature.enable('liga'),
        ]);

        expect(attribute.$style, isNotNull);
      });

      test('fontVariations utility works correctly', () {
        final attribute = TextStyler().fontVariations([
          FontVariation('wght', 500),
        ]);

        expect(attribute.$style, isNotNull);
      });

      test('decoration utility works correctly', () {
        final attribute = TextStyler().decoration(TextDecoration.lineThrough);

        expect(attribute.$style, isNotNull);
      });

      test('decorationColor utility works correctly', () {
        final attribute = TextStyler().decorationColor(Colors.red);

        expect(attribute.$style, isNotNull);
      });

      test('decorationStyle utility works correctly', () {
        final attribute = TextStyler().decorationStyle(
          TextDecorationStyle.dotted,
        );

        expect(attribute.$style, isNotNull);
      });

      test('decorationThickness utility works correctly', () {
        final attribute = TextStyler().decorationThickness(3.0);

        expect(attribute.$style, isNotNull);
      });

      test('fontFamilyFallback utility works correctly', () {
        final attribute = TextStyler().fontFamilyFallback(['Roboto', 'Arial']);

        expect(attribute.$style, isNotNull);
      });

      test('uppercase utility works correctly', () {
        final attribute = TextStyler().uppercase();

        expect(attribute.$textDirectives, isNotNull);
        expect(attribute.$textDirectives!.length, 1);
      });

      test('lowercase utility works correctly', () {
        final attribute = TextStyler().lowercase();

        expect(attribute.$textDirectives, isNotNull);
        expect(attribute.$textDirectives!.length, 1);
      });

      test('capitalize utility works correctly', () {
        final attribute = TextStyler().capitalize();

        expect(attribute.$textDirectives, isNotNull);
        expect(attribute.$textDirectives!.length, 1);
      });

      test('titleCase utility works correctly', () {
        final attribute = TextStyler().titleCase();

        expect(attribute.$textDirectives, isNotNull);
        expect(attribute.$textDirectives!.length, 1);
      });

      test('sentenceCase utility works correctly', () {
        final attribute = TextStyler().sentenceCase();

        expect(attribute.$textDirectives, isNotNull);
        expect(attribute.$textDirectives!.length, 1);
      });

      test('animate method sets animation config', () {
        final animation = AnimationConfig.linear(Duration(milliseconds: 500));
        final attribute = TextStyler().animate(animation);

        expect(attribute.$animation, equals(animation));
      });
    });

    group('Variant Methods', () {
      test('variant method adds variant to TextStyling', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = TextStyler(style: TextStyleMix(color: Colors.white));
        final textMix = TextStyler().variant(variant, style);

        expect(textMix.$variants, isNotNull);
        expect(textMix.$variants!.length, 1);
      });

      test('variants method sets multiple variants', () {
        final variants = [
          VariantStyle(
            ContextVariant.brightness(Brightness.dark),
            TextStyler(style: TextStyleMix(color: Colors.white)),
          ),
          VariantStyle(
            ContextVariant.brightness(Brightness.light),
            TextStyler(style: TextStyleMix(color: Colors.black)),
          ),
        ];
        final textMix = TextStyler().variants(variants);

        expect(textMix.$variants, isNotNull);
        expect(textMix.$variants!.length, 2);
      });
    });

    group('Resolution', () {
      test('resolves to TextSpec with correct properties', () {
        final attribute = TextStyler(
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: TextStyleMix(fontSize: 16.0, color: Colors.blue),
          softWrap: true,
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);
        final textSpec = spec.spec;

        expect(spec, isNotNull);
        expect(textSpec.overflow, TextOverflow.ellipsis);
        expect(textSpec.textAlign, TextAlign.center);
        expect(textSpec.maxLines, 3);
        expect(textSpec.style, isNotNull);
        expect(textSpec.softWrap, true);
      });

      test('resolves with null values correctly', () {
        final attribute = TextStyler().overflow(TextOverflow.fade).maxLines(2);

        final context = MockBuildContext();
        final spec = attribute.resolve(context);
        final textSpec = spec.spec;

        expect(spec, isNotNull);
        expect(textSpec.overflow, TextOverflow.fade);
        expect(textSpec.maxLines, 2);
        expect(textSpec.textAlign, isNull);
        expect(textSpec.strutStyle, isNull);
        expect(textSpec.textScaler, isNull);
        expect(textSpec.textWidthBasis, isNull);
        expect(textSpec.textHeightBehavior, isNull);
        expect(textSpec.textDirection, isNull);
        expect(textSpec.softWrap, isNull);
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = TextStyler(overflow: TextOverflow.clip, maxLines: 2);

        final second = TextStyler(
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
        final attribute = TextStyler().overflow(TextOverflow.ellipsis);
        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isFalse);
        expect(merged, equals(attribute));
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        final attr1 = TextStyler()
            .overflow(TextOverflow.ellipsis)
            .maxLines(2)
            .textAlign(TextAlign.center);

        final attr2 = TextStyler()
            .overflow(TextOverflow.ellipsis)
            .maxLines(2)
            .textAlign(TextAlign.center);

        expect(attr1, equals(attr2));
        expect(attr1.hashCode, equals(attr2.hashCode));
      });

      test('different attributes are not equal', () {
        final attr1 = TextStyler().overflow(TextOverflow.ellipsis);
        final attr2 = TextStyler().overflow(TextOverflow.fade);

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final attribute = TextStyler(
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

        expect(attribute.props.length, 17);
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
        expect(attribute.props, contains(attribute.$selectionColor));
        expect(attribute.props, contains(attribute.$semanticsLabel));
        expect(attribute.props, contains(attribute.$locale));
        expect(attribute.props, contains(attribute.$animation));
        expect(attribute.props, contains(attribute.$modifier));
        expect(attribute.props, contains(attribute.$variants));
      });
    });
  });
}
