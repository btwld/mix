import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('StrutStyleUtility', () {
    late StrutStyleUtility<MockStyle<StrutStyleMix>> util;

    setUp(() {
      util = StrutStyleUtility<MockStyle<StrutStyleMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has fontWeight utility', () {
        expect(util.fontWeight, isA<MixUtility>());
      });

      test('has fontStyle utility', () {
        expect(util.fontStyle, isA<MixUtility>());
      });

      test('has fontSize utility', () {
        expect(util.fontSize, isA<MixUtility>());
      });

      test('has fontFamily utility', () {
        expect(util.fontFamily, isA<MixUtility>());
      });
    });

    group('property setters', () {
      test('fontWeight sets font weight', () {
        final result = util.fontWeight(FontWeight.bold);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle, const StrutStyle(fontWeight: FontWeight.bold));
      });

      test('fontStyle sets font style', () {
        final result = util.fontStyle(FontStyle.italic);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle, const StrutStyle(fontStyle: FontStyle.italic));
      });

      test('fontSize sets font size', () {
        final result = util.fontSize(16.0);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle, const StrutStyle(fontSize: 16.0));
      });

      test('fontFamily sets font family', () {
        final result = util.fontFamily('Roboto');

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle, const StrutStyle(fontFamily: 'Roboto'));
      });
    });

    group('only method', () {
      test('sets all properties', () {
        final result = util(
          fontFamily: 'Arial',
          fontFamilyFallback: ['Helvetica', 'sans-serif'],
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          height: 1.5,
          leading: 2.0,
          forceStrutHeight: true,
        );

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(
          strutStyle,
          const StrutStyle(
            fontFamily: 'Arial',
            fontFamilyFallback: ['Helvetica', 'sans-serif'],
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            height: 1.5,
            leading: 2.0,
            forceStrutHeight: true,
          ),
        );
      });

      test('sets partial properties', () {
        final result = util(fontFamily: 'Georgia', fontSize: 14.0, height: 1.2);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(
          strutStyle,
          const StrutStyle(fontFamily: 'Georgia', fontSize: 14.0, height: 1.2),
        );
      });

      test('handles null values', () {
        final result = util();

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle, const StrutStyle());
      });

      test('handles font family fallback only', () {
        final result = util(fontFamilyFallback: ['Times', 'serif']);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(
          strutStyle,
          const StrutStyle(fontFamilyFallback: ['Times', 'serif']),
        );
      });

      test('handles boolean properties', () {
        final result = util(forceStrutHeight: false);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle, const StrutStyle(forceStrutHeight: false));
      });

      test('handles leading property', () {
        final result = util(leading: 1.5);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle, const StrutStyle(leading: 1.5));
      });
    });

    group('call method', () {
      test('delegates to only method with all properties', () {
        final result = util(
          fontFamily: 'Courier New',
          fontFamilyFallback: ['Courier', 'monospace'],
          fontSize: 12.0,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          height: 1.8,
          leading: 0.5,
          forceStrutHeight: true,
        );

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(
          strutStyle,
          const StrutStyle(
            fontFamily: 'Courier New',
            fontFamilyFallback: ['Courier', 'monospace'],
            fontSize: 12.0,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
            height: 1.8,
            leading: 0.5,
            forceStrutHeight: true,
          ),
        );
      });

      test('handles partial parameters', () {
        final result = util(fontWeight: FontWeight.w800, fontSize: 20.0);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(
          strutStyle,
          const StrutStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
        );
      });

      test('handles empty parameters', () {
        final result = util();

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle, const StrutStyle());
      });
    });

    group('as method', () {
      test('accepts StrutStyle with all properties', () {
        const strutStyle = StrutStyle(
          fontFamily: 'Times New Roman',
          fontFamilyFallback: ['Times', 'serif'],
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          height: 1.4,
          leading: 1.0,
          forceStrutHeight: false,
        );
        final result = util.as(strutStyle);

        expect(
          result.value,
          StrutStyleMix(
            fontFamily: 'Times New Roman',
            fontFamilyFallback: const ['Times', 'serif'],
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
            height: 1.4,
            leading: 1.0,
            forceStrutHeight: false,
          ),
        );
      });

      test('accepts minimal StrutStyle', () {
        const strutStyle = StrutStyle();
        final result = util.as(strutStyle);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, strutStyle);
      });

      test('accepts StrutStyle with only font properties', () {
        const strutStyle = StrutStyle(
          fontFamily: 'Helvetica',
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        );
        final result = util.as(strutStyle);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, strutStyle);
      });

      test('accepts StrutStyle with only layout properties', () {
        const strutStyle = StrutStyle(
          height: 2.0,
          leading: 0.8,
          forceStrutHeight: true,
        );
        final result = util.as(strutStyle);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, strutStyle);
      });
    });

    group('font weight variations', () {
      test('handles all FontWeight values', () {
        final fontWeights = [
          FontWeight.w100,
          FontWeight.w200,
          FontWeight.w300,
          FontWeight.w400,
          FontWeight.w500,
          FontWeight.w600,
          FontWeight.w700,
          FontWeight.w800,
          FontWeight.w900,
        ];

        for (final weight in fontWeights) {
          final result = util.fontWeight(weight);
          final strutStyle = result.value.resolve(MockBuildContext());
          expect(strutStyle.fontWeight, weight);
        }
      });

      test('handles named FontWeight values', () {
        final namedWeights = {
          FontWeight.normal: FontWeight.w400,
          FontWeight.bold: FontWeight.w700,
        };

        namedWeights.forEach((namedWeight, expectedWeight) {
          final result = util.fontWeight(namedWeight);
          final strutStyle = result.value.resolve(MockBuildContext());
          expect(strutStyle.fontWeight, expectedWeight);
        });
      });
    });

    group('font style variations', () {
      test('handles FontStyle.normal', () {
        final result = util.fontStyle(FontStyle.normal);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.fontStyle, FontStyle.normal);
      });

      test('handles FontStyle.italic', () {
        final result = util.fontStyle(FontStyle.italic);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.fontStyle, FontStyle.italic);
      });
    });

    group('numeric properties validation', () {
      test('handles small font size', () {
        final result = util.fontSize(1.0);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.fontSize, 1.0);
      });

      test('handles large font size', () {
        final result = util.fontSize(100.0);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.fontSize, 100.0);
      });

      test('handles fractional font size', () {
        final result = util.fontSize(14.5);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.fontSize, 14.5);
      });

      test('handles small height', () {
        final result = util(height: 0.1);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.height, 0.1);
      });

      test('handles large height', () {
        final result = util(height: 5.0);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.height, 5.0);
      });

      test('handles zero leading', () {
        final result = util(leading: 0.0);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.leading, 0.0);
      });

      test('handles large leading', () {
        final result = util(leading: 10.0);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.leading, 10.0);
      });
    });

    group('font family variations', () {
      test('handles common font families', () {
        final fontFamilies = [
          'Arial',
          'Helvetica',
          'Times New Roman',
          'Courier New',
          'Georgia',
          'Verdana',
          'Roboto',
          'Open Sans',
        ];

        for (final family in fontFamilies) {
          final result = util.fontFamily(family);
          final strutStyle = result.value.resolve(MockBuildContext());
          expect(strutStyle.fontFamily, family);
        }
      });

      test('handles font family with spaces', () {
        final result = util.fontFamily('Comic Sans MS');

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.fontFamily, 'Comic Sans MS');
      });

      test('handles empty font family list', () {
        final result = util(fontFamilyFallback: []);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.fontFamilyFallback, isEmpty);
      });

      test('handles single font family fallback', () {
        final result = util(fontFamilyFallback: ['serif']);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.fontFamilyFallback, ['serif']);
      });

      test('handles multiple font family fallbacks', () {
        final fallbacks = ['Helvetica', 'Arial', 'sans-serif'];
        final result = util(fontFamilyFallback: fallbacks);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.fontFamilyFallback, fallbacks);
      });
    });

    group('boolean property variations', () {
      test('handles forceStrutHeight true', () {
        final result = util(forceStrutHeight: true);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.forceStrutHeight, true);
      });

      test('handles forceStrutHeight false', () {
        final result = util(forceStrutHeight: false);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.forceStrutHeight, false);
      });
    });

    group('property combinations', () {
      test('combines font properties', () {
        final result = util(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
        );

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(
          strutStyle,
          const StrutStyle(
            fontFamily: 'Roboto',
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        );
      });

      test('combines layout properties', () {
        final result = util(height: 1.6, leading: 0.2, forceStrutHeight: true);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(
          strutStyle,
          const StrutStyle(height: 1.6, leading: 0.2, forceStrutHeight: true),
        );
      });

      test('combines font family with fallbacks', () {
        final result = util(
          fontFamily: 'Custom Font',
          fontFamilyFallback: ['Helvetica', 'Arial', 'sans-serif'],
        );

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(
          strutStyle,
          const StrutStyle(
            fontFamily: 'Custom Font',
            fontFamilyFallback: ['Helvetica', 'Arial', 'sans-serif'],
          ),
        );
      });
    });

    group('merge behavior validation', () {
      test('merging preserves individual properties', () {
        final style1 = StrutStyleMix(
          fontFamily: 'Arial',
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        );
        final style2 = StrutStyleMix(fontStyle: FontStyle.italic, height: 1.5);

        final merged = style1.merge(style2);
        final resolved = merged.resolve(MockBuildContext());

        expect(
          resolved,
          const StrutStyle(
            fontFamily: 'Arial',
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
            height: 1.5,
          ),
        );
      });

      test('merging overwrites conflicting properties', () {
        final style1 = StrutStyleMix(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        );
        final style2 = StrutStyleMix(
          fontSize: 18.0,
          fontStyle: FontStyle.italic,
        );

        final merged = style1.merge(style2);
        final resolved = merged.resolve(MockBuildContext());

        expect(
          resolved,
          const StrutStyle(
            fontSize: 18.0, // Should use the merged value
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
          ),
        );
      });

      test('merging appends font family fallbacks', () {
        final style1 = StrutStyleMix(
          fontFamilyFallback: ['Arial', 'Helvetica'],
        );
        final style2 = StrutStyleMix(fontFamilyFallback: ['Times', 'serif']);

        final merged = style1.merge(style2);
        final resolved = merged.resolve(MockBuildContext());

        expect(resolved.fontFamilyFallback, [
          'Arial',
          'Helvetica',
          'Times',
          'serif',
        ]);
      });
    });

    group('edge cases', () {
      test('handles extremely small font size', () {
        final result = util.fontSize(0.1);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.fontSize, 0.1);
      });

      test('handles extremely small height', () {
        final result = util(height: 0.1);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.height, 0.1);
      });

      test('handles complex font family name', () {
        const complexName = 'SF Pro Display, -apple-system, BlinkMacSystemFont';
        final result = util.fontFamily(complexName);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.fontFamily, complexName);
      });

      test('handles long font family fallback list', () {
        final longFallbackList = List.generate(10, (i) => 'Font$i');
        final result = util(fontFamilyFallback: longFallbackList);

        final strutStyle = result.value.resolve(MockBuildContext());

        expect(strutStyle.fontFamilyFallback, longFallbackList);
      });
    });
  });

  group('StrutStyle integration tests', () {
    test('utility works with Mix context', () {
      final util = StrutStyleUtility<MockStyle<StrutStyleMix>>(
        (mix) => MockStyle(mix),
      );

      final result = util(
        fontFamily: 'Roboto',
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

      expect(result.value, isA<StrutStyleMix>());

      final resolved = result.value.resolve(MockBuildContext());
      expect(resolved, isA<StrutStyle>());
      expect(resolved.fontFamily, 'Roboto');
      expect(resolved.fontSize, 16.0);
      expect(resolved.fontWeight, FontWeight.w500);
      expect(resolved.height, 1.4);
    });

    test('utility properties work independently', () {
      final util = StrutStyleUtility<MockStyle<StrutStyleMix>>(
        (mix) => MockStyle(mix),
      );

      final weightResult = util.fontWeight(FontWeight.bold);
      final sizeResult = util.fontSize(18.0);
      final familyResult = util.fontFamily('Arial');
      final styleResult = util.fontStyle(FontStyle.italic);

      expect(
        weightResult.value.resolve(MockBuildContext()).fontWeight,
        FontWeight.bold,
      );
      expect(sizeResult.value.resolve(MockBuildContext()).fontSize, 18.0);
      expect(
        familyResult.value.resolve(MockBuildContext()).fontFamily,
        'Arial',
      );
      expect(
        styleResult.value.resolve(MockBuildContext()).fontStyle,
        FontStyle.italic,
      );
    });
  });
}
