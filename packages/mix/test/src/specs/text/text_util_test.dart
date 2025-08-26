import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextSpecUtility', () {
    late TextSpecUtility util;

    setUp(() {
      util = TextSpecUtility();
    });

    group('Constructor', () {
      test('creates with provided TextMix attribute', () {
        final textMix = TextMix(maxLines: 3);
        final utility = TextSpecUtility(textMix);

        expect(utility.value, equals(textMix));
        expect(utility.value.$maxLines, resolvesTo(3));
      });
    });

    group('Text utility properties', () {
      test('textOverflow utility is MixUtility', () {
        expect(util.textOverflow, isA<MixUtility<TextMix, TextOverflow>>());
      });

      test('strutStyle utility is StrutStyleUtility', () {
        expect(util.strutStyle, isA<StrutStyleUtility<TextMix>>());
      });

      test('textAlign utility is MixUtility', () {
        expect(util.textAlign, isA<MixUtility<TextMix, TextAlign>>());
      });

      test('textScaler utility is MixUtility', () {
        expect(util.textScaler, isA<MixUtility<TextMix, TextScaler>>());
      });

      test('maxLines utility is function', () {
        expect(util.maxLines, isA<Function>());
      });

      test('style utility is TextStyleUtility', () {
        expect(util.style, isA<TextStyleUtility<TextMix>>());
      });

      test('textWidthBasis utility is MixUtility', () {
        expect(util.textWidthBasis, isA<MixUtility<TextMix, TextWidthBasis>>());
      });

      test('textHeightBehavior utility is TextHeightBehaviorUtility', () {
        expect(
          util.textHeightBehavior,
          isA<TextHeightBehaviorUtility<TextMix>>(),
        );
      });

      test('textDirection utility is MixUtility', () {
        expect(util.textDirection, isA<MixUtility<TextMix, TextDirection>>());
      });

      test('softWrap utility is function', () {
        expect(util.softWrap, isA<Function>());
      });

      test('directives utility is MixUtility', () {
        expect(util.directives, isA<MixUtility<TextMix, Directive<String>>>());
      });

      test('selectionColor utility is ColorUtility', () {
        expect(util.selectionColor, isA<ColorUtility<TextMix>>());
      });

      test('semanticsLabel utility is function', () {
        expect(util.semanticsLabel, isA<Function>());
      });

      test('locale utility is MixUtility', () {
        expect(util.locale, isA<MixUtility<TextMix, Locale>>());
      });

      test('on utility is OnContextVariantUtility', () {
        expect(util.on, isA<OnContextVariantUtility<TextSpec, TextMix>>());
      });

      test('wrap utility is ModifierUtility', () {
        expect(util.wrap, isA<ModifierUtility<TextMix>>());
      });
    });

    group('Flattened access properties', () {
      test('color utility provides color access', () {
        expect(util.color, isNotNull);
      });

      test('fontFamily utility provides fontFamily access', () {
        expect(util.fontFamily, isNotNull);
      });

      test('fontSize utility provides fontSize access', () {
        expect(util.fontSize, isNotNull);
      });

      test('fontWeight utility provides fontWeight access', () {
        expect(util.fontWeight, isNotNull);
      });

      test('fontStyle utility provides fontStyle access', () {
        expect(util.fontStyle, isNotNull);
      });

      test('decoration utility provides decoration access', () {
        expect(util.decoration, isNotNull);
      });

      test('backgroundColor utility provides backgroundColor access', () {
        expect(util.backgroundColor, isNotNull);
      });

      test('decorationColor utility provides decorationColor access', () {
        expect(util.decorationColor, isNotNull);
      });

      test('decorationStyle utility provides decorationStyle access', () {
        expect(util.decorationStyle, isNotNull);
      });

      test('textBaseline utility provides textBaseline access', () {
        expect(util.textBaseline, isNotNull);
      });

      test('height utility provides height access', () {
        expect(util.height, isNotNull);
      });

      test('letterSpacing utility provides letterSpacing access', () {
        expect(util.letterSpacing, isNotNull);
      });

      test('wordSpacing utility provides wordSpacing access', () {
        expect(util.wordSpacing, isNotNull);
      });

      test('fontVariations utility provides fontVariations access', () {
        expect(util.fontVariations, isNotNull);
      });

      test('shadows utility provides shadows access', () {
        expect(util.shadows, isNotNull);
      });

      test('foreground utility provides foreground access', () {
        expect(util.foreground, isNotNull);
      });

      test('background utility provides background access', () {
        expect(util.background, isNotNull);
      });

      test('fontFeatures utility provides fontFeatures access', () {
        expect(util.fontFeatures, isNotNull);
      });

      test('debugLabel utility provides debugLabel access', () {
        expect(util.debugLabel, isNotNull);
      });

      test(
        'decorationThickness utility provides decorationThickness access',
        () {
          expect(util.decorationThickness, isNotNull);
        },
      );

      test('fontFamilyFallback utility provides fontFamilyFallback access', () {
        expect(util.fontFamilyFallback, isNotNull);
      });
    });

    group('Text property utilities', () {
      test('textOverflow utility creates correct TextMix', () {
        final result = util.textOverflow(TextOverflow.ellipsis);
        expect(result.$overflow, resolvesTo(TextOverflow.ellipsis));
      });

      test('textAlign utility creates correct TextMix', () {
        final result = util.textAlign(TextAlign.center);
        expect(result.$textAlign, resolvesTo(TextAlign.center));
      });

      test('maxLines utility creates correct TextMix', () {
        final result = util.maxLines(3);
        expect(result.$maxLines, resolvesTo(3));
      });

      test('textWidthBasis utility creates correct TextMix', () {
        final result = util.textWidthBasis(TextWidthBasis.longestLine);
        expect(result.$textWidthBasis, resolvesTo(TextWidthBasis.longestLine));
      });

      test('textDirection utility creates correct TextMix', () {
        final result = util.textDirection(TextDirection.rtl);
        expect(result.$textDirection, resolvesTo(TextDirection.rtl));
      });

      test('softWrap utility creates correct TextMix', () {
        final result = util.softWrap(false);
        expect(result.$softWrap, resolvesTo(false));
      });

      test('selectionColor utility creates correct TextMix', () {
        final result = util.selectionColor(Colors.blue);
        expect(result.$selectionColor, resolvesTo(Colors.blue));
      });

      test('semanticsLabel utility creates correct TextMix', () {
        final result = TextSpecUtility().semanticsLabel('Custom label');
        expect(result.$semanticsLabel, resolvesTo('Custom label'));
      });

      test('locale utility creates correct TextMix', () {
        const locale = Locale('en', 'US');
        final result = util.locale(locale);
        expect(result.$locale, resolvesTo(locale));
      });
    });

    group('Convenience methods', () {
      test('bold() creates bold text style', () {
        final result = util.bold();
        expect(result, isA<TextMix>());
      });

      test('italic() creates italic text style', () {
        final result = util.italic();
        expect(result, isA<TextMix>());
      });
    });

    group('Animation', () {
      test('animate() adds animation config', () {
        final animationConfig = AnimationConfig.linear(
          const Duration(seconds: 1),
        );
        final result = util.animate(animationConfig);

        expect(result.$animation, animationConfig);
      });
    });

    group('Variant utilities', () {
      test('on utility creates VariantAttributeBuilder', () {
        final hoverBuilder = util.on.hover;

        expect(hoverBuilder, isA<VariantAttributeBuilder<TextSpec>>());
      });
    });

    group('Modifier utilities', () {
      test('wrap utility creates modifier TextMix', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<TextMix>());
        expect(result.$modifier, isNotNull);
        expect(result.$modifier!.$modifiers!.length, 1);
      });
    });

    group('Merge functionality', () {
      test('merge with null returns same instance', () {
        final result = util.merge(null);
        expect(result, same(util));
      });

      test('merge with TextSpecUtility creates new instance', () {
        final other = TextSpecUtility(TextMix(maxLines: 5));
        final result = util.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<TextSpecUtility>());
        expect(spec.spec.maxLines, 5);
      });

      test('merge with TextMix creates new instance', () {
        final otherMix = TextMix(textAlign: TextAlign.center);
        final result = util.merge(otherMix);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<TextSpecUtility>());
        expect(spec.spec.textAlign, TextAlign.center);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<TextSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        final util1 = TextSpecUtility(
          TextMix(maxLines: 3, textAlign: TextAlign.left),
        );
        final other = TextSpecUtility(
          TextMix(textAlign: TextAlign.center, softWrap: false),
        );

        final result = util1.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.spec.maxLines, 3);
        expect(spec.spec.textAlign, TextAlign.center); // other takes precedence
        expect(spec.spec.softWrap, false);
      });
    });

    group('Resolve functionality', () {
      test('resolve returns TextSpec with resolved properties', () {
        final testUtil = TextSpecUtility(
          TextMix(
            maxLines: 3,
            textAlign: TextAlign.center,
            softWrap: false,
            selectionColor: Colors.blue,
            semanticsLabel: 'Test label',
            locale: const Locale('fr', 'FR'),
          ),
        );

        final context = MockBuildContext();
        final spec = testUtil.resolve(context);

        const expectedSpec = TextSpec(
          maxLines: 3,
          textAlign: TextAlign.center,
          softWrap: false,
          selectionColor: Colors.blue,
          semanticsLabel: 'Test label',
          locale: Locale('fr', 'FR'),
        );

        expect(spec, equals(WidgetSpec(spec: expectedSpec)));
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        const expectedSpec = TextSpec();

        expect(spec, equals(WidgetSpec(spec: expectedSpec)));
      });
    });

    group('Utility method behavior', () {
      test('utilities return new TextMix instances', () {
        final result1 = util.maxLines(3);
        final result2 = util.textAlign(TextAlign.center);
        final result3 = util.softWrap(false);

        expect(result1.$maxLines, resolvesTo(3));
        expect(result2.$textAlign, resolvesTo(TextAlign.center));
        expect(result3.$softWrap, resolvesTo(false));
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('utility resolves to correct TextSpec', () {
        final testUtil = TextSpecUtility(
          TextMix(maxLines: 3, textAlign: TextAlign.center, softWrap: false),
        );

        expect(
          testUtil,
          resolvesTo(
            WidgetSpec(
              spec: const TextSpec(
                maxLines: 3,
                textAlign: TextAlign.center,
                softWrap: false,
              ),
            ),
          ),
        );
      });
    });

    group('Token support', () {
      test('resolves maxLines token with context', () {
        const maxLinesToken = MixToken<int>('maxLines');
        final context = MockBuildContext(
          tokens: {maxLinesToken.defineValue(5)},
        );

        final testUtil = TextSpecUtility(
          TextMix.create(maxLines: Prop.token(maxLinesToken)),
        );
        final spec = testUtil.resolve(context);

        expect(spec.spec.maxLines, 5);
      });

      test('resolves textAlign token with context', () {
        const textAlignToken = MixToken<TextAlign>('textAlign');
        final context = MockBuildContext(
          tokens: {textAlignToken.defineValue(TextAlign.center)},
        );

        final testUtil = TextSpecUtility(
          TextMix.create(textAlign: Prop.token(textAlignToken)),
        );
        final spec = testUtil.resolve(context);

        expect(spec.spec.textAlign, TextAlign.center);
      });

      test('resolves softWrap token with context', () {
        const softWrapToken = MixToken<bool>('softWrap');
        final context = MockBuildContext(
          tokens: {softWrapToken.defineValue(false)},
        );

        final testUtil = TextSpecUtility(
          TextMix.create(softWrap: Prop.token(softWrapToken)),
        );
        final spec = testUtil.resolve(context);

        expect(spec.spec.softWrap, false);
      });

      test('resolves selectionColor token with context', () {
        const selectionColorToken = MixToken<Color>('selectionColor');
        final context = MockBuildContext(
          tokens: {selectionColorToken.defineValue(Colors.red)},
        );

        final testUtil = TextSpecUtility(
          TextMix.create(selectionColor: Prop.token(selectionColorToken)),
        );
        final spec = testUtil.resolve(context);

        expect(spec.spec.selectionColor, Colors.red);
      });

      test('resolves textDirection token with context', () {
        const textDirectionToken = MixToken<TextDirection>('textDirection');
        final context = MockBuildContext(
          tokens: {textDirectionToken.defineValue(TextDirection.rtl)},
        );

        final testUtil = TextSpecUtility(
          TextMix.create(textDirection: Prop.token(textDirectionToken)),
        );
        final spec = testUtil.resolve(context);

        expect(spec.spec.textDirection, TextDirection.rtl);
      });

      test('resolves semanticsLabel token with context', () {
        const semanticsLabelToken = MixToken<String>('semanticsLabel');
        final context = MockBuildContext(
          tokens: {semanticsLabelToken.defineValue('Custom label')},
        );

        final testUtil = TextSpecUtility(
          TextMix.create(semanticsLabel: Prop.token(semanticsLabelToken)),
        );
        final spec = testUtil.resolve(context);

        expect(spec.spec.semanticsLabel, 'Custom label');
      });

      test('resolves locale token with context', () {
        const localeToken = MixToken<Locale>('locale');
        const locale = Locale('en', 'US');
        final context = MockBuildContext(
          tokens: {localeToken.defineValue(locale)},
        );

        final testUtil = TextSpecUtility(
          TextMix.create(locale: Prop.token(localeToken)),
        );
        final spec = testUtil.resolve(context);

        expect(spec.spec.locale, locale);
      });

      test('resolves multiple tokens with context', () {
        const maxLinesToken = MixToken<int>('maxLines');
        const textAlignToken = MixToken<TextAlign>('textAlign');
        const selectionColorToken = MixToken<Color>('selectionColor');
        const semanticsLabelToken = MixToken<String>('semanticsLabel');
        const localeToken = MixToken<Locale>('locale');

        final context = MockBuildContext(
          tokens: {
            maxLinesToken.defineValue(2),
            textAlignToken.defineValue(TextAlign.right),
            selectionColorToken.defineValue(Colors.green),
            semanticsLabelToken.defineValue('Test label'),
            localeToken.defineValue(const Locale('es', 'ES')),
          },
        );

        final testUtil = TextSpecUtility(
          TextMix.create(
            maxLines: Prop.token(maxLinesToken),
            textAlign: Prop.token(textAlignToken),
            selectionColor: Prop.token(selectionColorToken),
            semanticsLabel: Prop.token(semanticsLabelToken),
            locale: Prop.token(localeToken),
          ),
        );
        final spec = testUtil.resolve(context);

        const expectedSpec = TextSpec(
          maxLines: 2,
          textAlign: TextAlign.right,
          selectionColor: Colors.green,
          semanticsLabel: 'Test label',
          locale: Locale('es', 'ES'),
        );

        expect(spec, equals(WidgetSpec(spec: expectedSpec)));
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        // Test individual utility calls
        final maxLinesResult = util.maxLines(3);
        final alignResult = util.textAlign(TextAlign.center);
        final wrapResult = util.softWrap(false);

        expect(maxLinesResult.$maxLines, resolvesTo(3));
        expect(alignResult.$textAlign, resolvesTo(TextAlign.center));
        expect(wrapResult.$softWrap, resolvesTo(false));
      });

      test('handles multiple merges correctly', () {
        final util1 = TextSpecUtility(TextMix(maxLines: 3));
        final util2 = TextSpecUtility(TextMix(textAlign: TextAlign.center));
        final util3 = TextSpecUtility(TextMix(softWrap: false));

        final result = util1.merge(util2).merge(util3);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.spec.maxLines, 3);
        expect(spec.spec.textAlign, TextAlign.center);
        expect(spec.spec.softWrap, false);
      });
    });

    group('Edge cases', () {
      test('handles empty utility', () {
        final emptyUtil = TextSpecUtility();
        final context = MockBuildContext();
        final spec = emptyUtil.resolve(context);

        expect(spec.spec.maxLines, isNull);
        expect(spec.spec.textAlign, isNull);
        expect(spec.spec.softWrap, isNull);
      });

      test('merge with self returns new instance', () {
        final testUtil = TextSpecUtility(TextMix(maxLines: 3));
        final result = testUtil.merge(testUtil);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(testUtil)));
        expect(spec.spec.maxLines, 3);
      });
    });

    group('Chaining methods', () {
      test('basic maxLines mutation test', () {
        final util = TextSpecUtility();

        final result = util.maxLines(5);
        expect(result, isA<TextMix>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.maxLines, 5);
      });

      test('basic color mutation test', () {
        final util = TextSpecUtility();

        final result = util.color.red();
        expect(result, isA<TextMix>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.style?.color, Colors.red);
      });

      test('chaining utility methods accumulates properties', () {
        final util = TextSpecUtility();

        // Chain multiple method calls - these mutate internal state
        util.color.red();
        util.fontSize(16);
        util.maxLines(3);

        // Verify accumulated state through resolution
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.style?.color, Colors.red);
        expect(spec.spec.style?.fontSize, 16);
        expect(spec.spec.maxLines, 3);
      });

      test('cascade notation works with utility methods', () {
        final util = TextSpecUtility()
          ..color.red()
          ..fontSize(16)
          ..maxLines(3);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.style?.color, Colors.red);
        expect(spec.spec.style?.fontSize, 16);
        expect(spec.spec.maxLines, 3);
      });

      test('individual utility calls return TextMix for further chaining', () {
        final util = TextSpecUtility();

        // Each utility call should return a TextStyle
        final colorResult = util.color.red();
        final fontResult = util.fontSize(16);
        final linesResult = util.maxLines(3);

        expect(colorResult, isA<TextMix>());
        expect(fontResult, isA<TextMix>());
        expect(linesResult, isA<TextMix>());

        // But the utility itself should have accumulated all changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.style?.color, Colors.red);
        expect(spec.spec.style?.fontSize, 16);
        expect(spec.spec.maxLines, 3);
      });
    });

    group('Mutating behavior vs Builder pattern', () {
      test('utility mutates internal state (not builder pattern)', () {
        final util = TextSpecUtility();

        // Store initial resolution
        final context = MockBuildContext();
        final initialSpec = util.resolve(context);
        expect(initialSpec.spec.style?.color, isNull);

        // Mutate the utility
        util.color.red();

        // Same utility instance should now resolve with the color
        final mutatedSpec = util.resolve(context);
        expect(mutatedSpec.spec.style?.color, Colors.red);

        // This proves it's mutating, not building new instances
      });

      test('multiple calls accumulate on same instance', () {
        final util = TextSpecUtility();

        util.color.red();
        util.fontSize(16);
        util.maxLines(3);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        // All properties should be present in the same instance
        expect(spec.spec.style?.color, Colors.red);
        expect(spec.spec.style?.fontSize, 16);
        expect(spec.spec.maxLines, 3);
      });

      test('demonstrates difference from immutable builder pattern', () {
        final util = TextSpecUtility();

        // In a builder pattern, this would create new instances
        // In mutable pattern, this modifies the same instance
        final result1 = util.color.red();
        final result2 = util.fontSize(16);

        // Both results are different TextStyle instances
        expect(result1, isNot(same(result2)));

        // But the utility itself has accumulated both changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.style?.color, Colors.red);
        expect(spec.spec.style?.fontSize, 16);
      });
    });
  });
}