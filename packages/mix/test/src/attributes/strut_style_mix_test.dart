import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('StrutStyleMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final strutStyleMix = StrutStyleMix.only(
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

    group('resolve', () {
      test('resolves to StrutStyle with correct properties', () {
        final strutStyleMix = StrutStyleMix.only(
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
        final strutStyleMix = StrutStyleMix.only(fontSize: 16.0);
        final merged = strutStyleMix.merge(null);

        expect(merged, same(strutStyleMix));
      });

      test('merges properties correctly', () {
        final first = StrutStyleMix.only(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        );

        final second = StrutStyleMix.only(
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
        final first = StrutStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final second = StrutStyleMix.only(
          fontFamilyFallback: const ['Times', 'Georgia'],
        );

        final merged = first.merge(second);

        expect(merged.$fontFamilyFallback, hasLength(4));
        expectProp(merged.$fontFamilyFallback![0], 'Arial');
        expectProp(merged.$fontFamilyFallback![1], 'Helvetica');
        expectProp(merged.$fontFamilyFallback![2], 'Times');
        expectProp(merged.$fontFamilyFallback![3], 'Georgia');
      });

      test('preserves all properties in complex merge', () {
        final base = StrutStyleMix.only(
          fontFamily: 'Roboto',
          fontSize: 14.0,
          fontFamilyFallback: const ['Arial'],
        );

        final override = StrutStyleMix.only(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontFamilyFallback: const ['Times'],
        );

        final merged = base.merge(override);

        expectProp(merged.$fontFamily, 'Roboto'); // preserved
        expectProp(merged.$fontSize, 16.0); // overridden
        expectProp(merged.$fontWeight, FontWeight.bold); // added
        expect(merged.$fontFamilyFallback, hasLength(2)); // concatenated
        expectProp(merged.$fontFamilyFallback![0], 'Arial');
        expectProp(merged.$fontFamilyFallback![1], 'Times');
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final strutStyleMix1 = StrutStyleMix.only(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        );

        final strutStyleMix2 = StrutStyleMix.only(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        );

        expect(strutStyleMix1, strutStyleMix2);
        expect(strutStyleMix1.hashCode, strutStyleMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final strutStyleMix1 = StrutStyleMix.only(fontSize: 16.0);
        final strutStyleMix2 = StrutStyleMix.only(fontSize: 18.0);

        expect(strutStyleMix1, isNot(strutStyleMix2));
      });

      test('handles fontFamilyFallback list equality correctly', () {
        final strutStyleMix1 = StrutStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final strutStyleMix2 = StrutStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final strutStyleMix3 = StrutStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Times'],
        );

        expect(strutStyleMix1, strutStyleMix2);
        expect(strutStyleMix1, isNot(strutStyleMix3));
      });
    });

    group('debugFillProperties', () {
      test('adds all properties to diagnostic properties', () {
        final strutStyleMix = StrutStyleMix.only(
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
