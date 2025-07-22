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

        expect(strutStyleMix.fontFamily, isProp('Roboto'));
        expect(strutStyleMix.fontSize, isProp(16.0));
        expect(strutStyleMix.fontWeight, isProp(FontWeight.bold));
        expect(strutStyleMix.fontStyle, isProp(FontStyle.italic));
        expect(strutStyleMix.height, isProp(1.5));
        expect(strutStyleMix.leading, isProp(2.0));
        expect(strutStyleMix.forceStrutHeight, isProp(true));

        // Test fontFamilyFallback list
        expect(strutStyleMix.fontFamilyFallback, hasLength(2));
        expect(strutStyleMix.fontFamilyFallback![0], isProp('Arial'));
        expect(strutStyleMix.fontFamilyFallback![1], isProp('Helvetica'));
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

        expect(strutStyleMix.fontFamily, isProp('Roboto'));
        expect(strutStyleMix.fontSize, isProp(14.0));
        expect(strutStyleMix.fontWeight, isProp(FontWeight.w500));
        expect(strutStyleMix.fontStyle, isProp(FontStyle.normal));
        expect(strutStyleMix.height, isProp(1.2));
        expect(strutStyleMix.leading, isProp(1.0));
        expect(strutStyleMix.forceStrutHeight, isProp(false));

        expect(strutStyleMix.fontFamilyFallback, hasLength(1));
        expect(strutStyleMix.fontFamilyFallback![0], isProp('Arial'));
      });

      test('maybeValue returns null for null input', () {
        final result = StrutStyleMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns StrutStyleMix for non-null input', () {
        const strutStyle = StrutStyle(fontSize: 16.0);
        final result = StrutStyleMix.maybeValue(strutStyle);

        expect(result, isNotNull);
        expect(result!.fontSize, isProp(16.0));
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

        final context = MockBuildContext();
        final resolved = strutStyleMix.resolve(context);

        expect(resolved.fontFamily, 'Roboto');
        expect(resolved.fontSize, 16.0);
        expect(resolved.fontWeight, FontWeight.bold);
        expect(resolved.height, 1.5);
        expect(resolved.forceStrutHeight, true);
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

        expect(merged.fontFamily, isProp('Roboto'));
        expect(merged.fontSize, isProp(18.0));
        expect(merged.fontWeight, isProp(FontWeight.normal));
        expect(merged.fontStyle, isProp(FontStyle.italic));
        expect(merged.height, isProp(1.5));
      });

      test('merges fontFamilyFallback lists by concatenating', () {
        final first = StrutStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final second = StrutStyleMix.only(
          fontFamilyFallback: const ['Times', 'Georgia'],
        );

        final merged = first.merge(second);

        expect(merged.fontFamilyFallback, hasLength(4));
        expect(merged.fontFamilyFallback![0], isProp('Arial'));
        expect(merged.fontFamilyFallback![1], isProp('Helvetica'));
        expect(merged.fontFamilyFallback![2], isProp('Times'));
        expect(merged.fontFamilyFallback![3], isProp('Georgia'));
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

        expect(merged.fontFamily, isProp('Roboto')); // preserved
        expect(merged.fontSize, isProp(16.0)); // overridden
        expect(merged.fontWeight, isProp(FontWeight.bold)); // added
        expect(merged.fontFamilyFallback, hasLength(2)); // concatenated
        expect(merged.fontFamilyFallback![0], isProp('Arial'));
        expect(merged.fontFamilyFallback![1], isProp('Times'));
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
