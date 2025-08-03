import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/properties/typography/strut_style_mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('StrutStyleMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final strutStyleMix = StrutStyleMix(
          fontFamily: 'Roboto',
          fontFamilyFallback: const ['Arial', 'Helvetica'],
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          height: 1.5,
          leading: 2.0,
          forceStrutHeight: true,
        );

        expectProp(strutStyleMix.$fontFamily, 'Roboto');
        expectProp(strutStyleMix.$fontSize, 16.0);
        expectProp(strutStyleMix.$fontWeight, FontWeight.bold);
        expectProp(strutStyleMix.$fontStyle, FontStyle.italic);
        expectProp(strutStyleMix.$height, 1.5);
        expectProp(strutStyleMix.$leading, 2.0);
        expectProp(strutStyleMix.$forceStrutHeight, true);

        // Test fontFamilyFallback list
        expect(strutStyleMix.$fontFamilyFallback, hasLength(2));
        expectProp(strutStyleMix.$fontFamilyFallback![0], 'Arial');
        expectProp(strutStyleMix.$fontFamilyFallback![1], 'Helvetica');
      });

      test('value constructor extracts properties from StrutStyle', () {
        const strutStyle = StrutStyle(
          fontFamily: 'Roboto',
          fontFamilyFallback: ['Arial'],
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          height: 1.2,
          leading: 1.0,
          forceStrutHeight: false,
        );

        final strutStyleMix = StrutStyleMix.value(strutStyle);

        expectProp(strutStyleMix.$fontFamily, 'Roboto');
        expectProp(strutStyleMix.$fontSize, 14.0);
        expectProp(strutStyleMix.$fontWeight, FontWeight.w500);
        expectProp(strutStyleMix.$fontStyle, FontStyle.normal);
        expectProp(strutStyleMix.$height, 1.2);
        expectProp(strutStyleMix.$leading, 1.0);
        expectProp(strutStyleMix.$forceStrutHeight, false);

        expect(strutStyleMix.$fontFamilyFallback, hasLength(1));
        expectProp(strutStyleMix.$fontFamilyFallback![0], 'Arial');
      });

      test('maybeValue returns null for null input', () {
        final result = StrutStyleMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns StrutStyleMix for non-null input', () {
        const strutStyle = StrutStyle(fontSize: 16.0);
        final result = StrutStyleMix.maybeValue(strutStyle);

        expect(result, isNotNull);
        expectProp(result!.$fontSize, 16.0);
      });
    });

    group('Factory Constructors', () {
      test('fontFamily factory creates StrutStyleMix with fontFamily', () {
        final strutStyleMix = StrutStyleMix.fontFamily('Times');

        expectProp(strutStyleMix.$fontFamily, 'Times');
        expect(strutStyleMix.$fontFamilyFallback, isNull);
        expect(strutStyleMix.$fontSize, isNull);
        expect(strutStyleMix.$height, isNull);
        expect(strutStyleMix.$leading, isNull);
        expect(strutStyleMix.$fontWeight, isNull);
        expect(strutStyleMix.$fontStyle, isNull);
        expect(strutStyleMix.$forceStrutHeight, isNull);
      });

      test(
        'fontFamilyFallback factory creates StrutStyleMix with fontFamilyFallback',
        () {
          final fontFamilyFallback = ['Georgia', 'serif'];
          final strutStyleMix = StrutStyleMix.fontFamilyFallback(
            fontFamilyFallback,
          );

          expect(strutStyleMix.$fontFamilyFallback?.length, 2);
          expectProp(strutStyleMix.$fontFamilyFallback![0], 'Georgia');
          expectProp(strutStyleMix.$fontFamilyFallback![1], 'serif');
          expect(strutStyleMix.$fontFamily, isNull);
          expect(strutStyleMix.$fontSize, isNull);
          expect(strutStyleMix.$height, isNull);
          expect(strutStyleMix.$leading, isNull);
          expect(strutStyleMix.$fontWeight, isNull);
          expect(strutStyleMix.$fontStyle, isNull);
          expect(strutStyleMix.$forceStrutHeight, isNull);
        },
      );

      test('fontSize factory creates StrutStyleMix with fontSize', () {
        final strutStyleMix = StrutStyleMix.fontSize(18.0);

        expectProp(strutStyleMix.$fontSize, 18.0);
        expect(strutStyleMix.$fontFamily, isNull);
        expect(strutStyleMix.$fontFamilyFallback, isNull);
        expect(strutStyleMix.$height, isNull);
        expect(strutStyleMix.$leading, isNull);
        expect(strutStyleMix.$fontWeight, isNull);
        expect(strutStyleMix.$fontStyle, isNull);
        expect(strutStyleMix.$forceStrutHeight, isNull);
      });

      test('height factory creates StrutStyleMix with height', () {
        final strutStyleMix = StrutStyleMix.height(1.8);

        expectProp(strutStyleMix.$height, 1.8);
        expect(strutStyleMix.$fontFamily, isNull);
        expect(strutStyleMix.$fontFamilyFallback, isNull);
        expect(strutStyleMix.$fontSize, isNull);
        expect(strutStyleMix.$leading, isNull);
        expect(strutStyleMix.$fontWeight, isNull);
        expect(strutStyleMix.$fontStyle, isNull);
        expect(strutStyleMix.$forceStrutHeight, isNull);
      });

      test('leading factory creates StrutStyleMix with leading', () {
        final strutStyleMix = StrutStyleMix.leading(1.3);

        expectProp(strutStyleMix.$leading, 1.3);
        expect(strutStyleMix.$fontFamily, isNull);
        expect(strutStyleMix.$fontFamilyFallback, isNull);
        expect(strutStyleMix.$fontSize, isNull);
        expect(strutStyleMix.$height, isNull);
        expect(strutStyleMix.$fontWeight, isNull);
        expect(strutStyleMix.$fontStyle, isNull);
        expect(strutStyleMix.$forceStrutHeight, isNull);
      });

      test('fontWeight factory creates StrutStyleMix with fontWeight', () {
        final strutStyleMix = StrutStyleMix.fontWeight(FontWeight.w600);

        expectProp(strutStyleMix.$fontWeight, FontWeight.w600);
        expect(strutStyleMix.$fontFamily, isNull);
        expect(strutStyleMix.$fontFamilyFallback, isNull);
        expect(strutStyleMix.$fontSize, isNull);
        expect(strutStyleMix.$height, isNull);
        expect(strutStyleMix.$leading, isNull);
        expect(strutStyleMix.$fontStyle, isNull);
        expect(strutStyleMix.$forceStrutHeight, isNull);
      });

      test('fontStyle factory creates StrutStyleMix with fontStyle', () {
        final strutStyleMix = StrutStyleMix.fontStyle(FontStyle.normal);

        expectProp(strutStyleMix.$fontStyle, FontStyle.normal);
        expect(strutStyleMix.$fontFamily, isNull);
        expect(strutStyleMix.$fontFamilyFallback, isNull);
        expect(strutStyleMix.$fontSize, isNull);
        expect(strutStyleMix.$height, isNull);
        expect(strutStyleMix.$leading, isNull);
        expect(strutStyleMix.$fontWeight, isNull);
        expect(strutStyleMix.$forceStrutHeight, isNull);
      });

      test(
        'forceStrutHeight factory creates StrutStyleMix with forceStrutHeight',
        () {
          final strutStyleMix = StrutStyleMix.forceStrutHeight(false);

          expectProp(strutStyleMix.$forceStrutHeight, false);
          expect(strutStyleMix.$fontFamily, isNull);
          expect(strutStyleMix.$fontFamilyFallback, isNull);
          expect(strutStyleMix.$fontSize, isNull);
          expect(strutStyleMix.$height, isNull);
          expect(strutStyleMix.$leading, isNull);
          expect(strutStyleMix.$fontWeight, isNull);
          expect(strutStyleMix.$fontStyle, isNull);
        },
      );
    });

    group('resolve', () {
      test('resolves to StrutStyle with correct properties', () {
        final strutStyleMix = StrutStyleMix(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          height: 1.5,
          forceStrutHeight: true,
        );

        const resolvedValue = StrutStyle(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          height: 1.5,
          forceStrutHeight: true,
        );

        expect(strutStyleMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final strutStyleMix = StrutStyleMix(fontSize: 16.0);
        final merged = strutStyleMix.merge(null);

        expect(merged, same(strutStyleMix));
      });

      test('merges properties correctly', () {
        final first = StrutStyleMix(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        );

        final second = StrutStyleMix(
          fontSize: 18.0,
          fontStyle: FontStyle.italic,
          height: 1.5,
        );

        final merged = first.merge(second);

        expectProp(merged.$fontFamily, 'Roboto');
        expectProp(merged.$fontSize, 18.0);
        expectProp(merged.$fontWeight, FontWeight.normal);
        expectProp(merged.$fontStyle, FontStyle.italic);
        expectProp(merged.$height, 1.5);
      });

      test('merges fontFamilyFallback lists by concatenating', () {
        final first = StrutStyleMix(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final second = StrutStyleMix(
          fontFamilyFallback: const ['Times', 'Georgia'],
        );

        final merged = first.merge(second);

        expect(merged.$fontFamilyFallback, hasLength(2));

        expectProp(merged.$fontFamilyFallback![0], 'Times');
        expectProp(merged.$fontFamilyFallback![1], 'Georgia');
      });

      test('preserves all properties in complex merge', () {
        final base = StrutStyleMix(
          fontFamily: 'Roboto',
          fontSize: 14.0,
          fontFamilyFallback: const ['Arial'],
        );

        final override = StrutStyleMix(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontFamilyFallback: const ['Times'],
        );

        final merged = base.merge(override);

        expectProp(merged.$fontFamily, 'Roboto'); // preserved
        expectProp(merged.$fontSize, 16.0); // overridden
        expectProp(merged.$fontWeight, FontWeight.bold); // added
        expect(merged.$fontFamilyFallback, hasLength(1)); // concatenated
        expectProp(merged.$fontFamilyFallback![0], 'Times');
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final strutStyleMix1 = StrutStyleMix(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        );

        final strutStyleMix2 = StrutStyleMix(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        );

        expect(strutStyleMix1, strutStyleMix2);
        expect(strutStyleMix1.hashCode, strutStyleMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final strutStyleMix1 = StrutStyleMix(fontSize: 16.0);
        final strutStyleMix2 = StrutStyleMix(fontSize: 18.0);

        expect(strutStyleMix1, isNot(strutStyleMix2));
      });

      test('handles fontFamilyFallback list equality correctly', () {
        final strutStyleMix1 = StrutStyleMix(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final strutStyleMix2 = StrutStyleMix(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final strutStyleMix3 = StrutStyleMix(
          fontFamilyFallback: const ['Arial', 'Times'],
        );

        expect(strutStyleMix1, strutStyleMix2);
        expect(strutStyleMix1, isNot(strutStyleMix3));
      });
    });

    group('Utility Methods', () {
      test('fontFamily utility works correctly', () {
        final strutStyleMix = StrutStyleMix().fontFamily('Courier');

        expectProp(strutStyleMix.$fontFamily, 'Courier');
      });

      test('fontFamilyFallback utility works correctly', () {
        final fontFamilyFallback = ['Verdana', 'sans-serif'];
        final strutStyleMix = StrutStyleMix().fontFamilyFallback(
          fontFamilyFallback,
        );

        expect(strutStyleMix.$fontFamilyFallback?.length, 2);
        expectProp(strutStyleMix.$fontFamilyFallback![0], 'Verdana');
        expectProp(strutStyleMix.$fontFamilyFallback![1], 'sans-serif');
      });

      test('fontSize utility works correctly', () {
        final strutStyleMix = StrutStyleMix().fontSize(20.0);

        expectProp(strutStyleMix.$fontSize, 20.0);
      });

      test('height utility works correctly', () {
        final strutStyleMix = StrutStyleMix().height(2.0);

        expectProp(strutStyleMix.$height, 2.0);
      });

      test('leading utility works correctly', () {
        final strutStyleMix = StrutStyleMix().leading(1.8);

        expectProp(strutStyleMix.$leading, 1.8);
      });

      test('fontWeight utility works correctly', () {
        final strutStyleMix = StrutStyleMix().fontWeight(FontWeight.w300);

        expectProp(strutStyleMix.$fontWeight, FontWeight.w300);
      });

      test('fontStyle utility works correctly', () {
        final strutStyleMix = StrutStyleMix().fontStyle(FontStyle.italic);

        expectProp(strutStyleMix.$fontStyle, FontStyle.italic);
      });

      test('forceStrutHeight utility works correctly', () {
        final strutStyleMix = StrutStyleMix().forceStrutHeight(true);

        expectProp(strutStyleMix.$forceStrutHeight, true);
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final strutStyleMix = StrutStyleMix(
          fontFamily: 'Arial',
          fontFamilyFallback: ['Helvetica', 'sans-serif'],
          fontSize: 16.0,
          height: 1.5,
          leading: 1.2,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          forceStrutHeight: true,
        );

        expect(strutStyleMix.props.length, 8);
        expect(strutStyleMix.props, contains(strutStyleMix.$fontFamily));
        expect(
          strutStyleMix.props,
          contains(strutStyleMix.$fontFamilyFallback),
        );
        expect(strutStyleMix.props, contains(strutStyleMix.$fontSize));
        expect(strutStyleMix.props, contains(strutStyleMix.$height));
        expect(strutStyleMix.props, contains(strutStyleMix.$leading));
        expect(strutStyleMix.props, contains(strutStyleMix.$fontWeight));
        expect(strutStyleMix.props, contains(strutStyleMix.$fontStyle));
        expect(strutStyleMix.props, contains(strutStyleMix.$forceStrutHeight));
      });
    });

    group('debugFillProperties', () {
      test('adds all properties to diagnostic properties', () {
        final strutStyleMix = StrutStyleMix(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        );

        final properties = DiagnosticPropertiesBuilder();
        strutStyleMix.debugFillProperties(properties);

        expect(properties.properties.length, greaterThan(0));
      });
    });
  });
}
