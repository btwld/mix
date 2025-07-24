import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('ShadowMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final shadowMix = ShadowMix.only(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(5.0, 8.0),
        );

        expectProp(shadowMix.blurRadius, 10.0);
        expectProp(shadowMix.color, Colors.blue);
        expectProp(shadowMix.offset, const Offset(5.0, 8.0));
      });

      test('value constructor extracts properties from Shadow', () {
        const shadow = Shadow(
          blurRadius: 15.0,
          color: Colors.red,
          offset: Offset(3.0, 6.0),
        );

        final shadowMix = ShadowMix.value(shadow);

        expectProp(shadowMix.blurRadius, 15.0);
        expectProp(shadowMix.color, Colors.red);
        expectProp(shadowMix.offset, const Offset(3.0, 6.0));
      });

      test('maybeValue returns null for null input', () {
        final result = ShadowMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns ShadowMix for non-null input', () {
        const shadow = Shadow(blurRadius: 5.0);
        final result = ShadowMix.maybeValue(shadow);

        expect(result, isNotNull);
        expectProp(result!.blurRadius, 5.0);
      });
    });

    group('resolve', () {
      test('resolves to Shadow with correct properties', () {
        final shadowMix = ShadowMix.only(
          blurRadius: 12.0,
          color: Colors.green,
          offset: const Offset(2.0, 4.0),
        );

        const resolvedValue = Shadow(
          blurRadius: 12.0,
          color: Colors.green,
          offset: Offset(2.0, 4.0),
        );

        expect(shadowMix, resolvesTo(resolvedValue));
      });

      test('uses default values for null properties', () {
        final shadowMix = ShadowMix.only(blurRadius: 8.0);

        const resolvedValue = Shadow(
          blurRadius: 8.0,
          color: Color(0xFF000000),
          offset: Offset.zero,
        );

        expect(shadowMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final shadowMix = ShadowMix.only(blurRadius: 5.0);
        final merged = shadowMix.merge(null);

        expect(merged, same(shadowMix));
      });

      test('merges properties correctly', () {
        final first = ShadowMix.only(blurRadius: 10.0, color: Colors.blue);

        final second = ShadowMix.only(
          color: Colors.red,
          offset: const Offset(3.0, 3.0),
        );

        final merged = first.merge(second);

        expectProp(merged.blurRadius, 10.0);
        expectProp(merged.color, Colors.red);
        expectProp(merged.offset, const Offset(3.0, 3.0));
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final shadowMix1 = ShadowMix.only(blurRadius: 10.0, color: Colors.blue);

        final shadowMix2 = ShadowMix.only(blurRadius: 10.0, color: Colors.blue);

        expect(shadowMix1, shadowMix2);
        expect(shadowMix1.hashCode, shadowMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final shadowMix1 = ShadowMix.only(blurRadius: 10.0);
        final shadowMix2 = ShadowMix.only(blurRadius: 15.0);

        expect(shadowMix1, isNot(shadowMix2));
      });
    });
  });

  group('BoxShadowMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final boxShadowMix = BoxShadowMix.only(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(5.0, 8.0),
          spreadRadius: 2.0,
        );

        expectProp(boxShadowMix.blurRadius, 10.0);
        expectProp(boxShadowMix.color, Colors.blue);
        expectProp(boxShadowMix.offset, const Offset(5.0, 8.0));
        expectProp(boxShadowMix.spreadRadius, 2.0);
      });

      test('value constructor extracts properties from BoxShadow', () {
        const boxShadow = BoxShadow(
          blurRadius: 15.0,
          color: Colors.red,
          offset: Offset(3.0, 6.0),
          spreadRadius: 4.0,
        );

        final boxShadowMix = BoxShadowMix.value(boxShadow);

        expectProp(boxShadowMix.blurRadius, 15.0);
        expectProp(boxShadowMix.color, Colors.red);
        expectProp(boxShadowMix.offset, const Offset(3.0, 6.0));
        expectProp(boxShadowMix.spreadRadius, 4.0);
      });

      test('maybeValue returns null for null input', () {
        final result = BoxShadowMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns BoxShadowMix for non-null input', () {
        const boxShadow = BoxShadow(blurRadius: 5.0);
        final result = BoxShadowMix.maybeValue(boxShadow);

        expect(result, isNotNull);
        expectProp(result!.blurRadius, 5.0);
      });
    });

    group('resolve', () {
      test('resolves to BoxShadow with correct properties', () {
        final boxShadowMix = BoxShadowMix.only(
          blurRadius: 12.0,
          color: Colors.green,
          offset: const Offset(2.0, 4.0),
          spreadRadius: 3.0,
        );

        const resolvedValue = BoxShadow(
          blurRadius: 12.0,
          color: Colors.green,
          offset: Offset(2.0, 4.0),
          spreadRadius: 3.0,
        );

        expect(boxShadowMix, resolvesTo(resolvedValue));
      });

      test('uses default values for null properties', () {
        final boxShadowMix = BoxShadowMix.only(blurRadius: 8.0);

        const resolvedValue = BoxShadow(
          blurRadius: 8.0,
          color: Color(0xFF000000),
          offset: Offset.zero,
          spreadRadius: 0.0,
        );

        expect(boxShadowMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final boxShadowMix = BoxShadowMix.only(blurRadius: 5.0);
        final merged = boxShadowMix.merge(null);

        expect(merged, same(boxShadowMix));
      });

      test('merges properties correctly', () {
        final first = BoxShadowMix.only(
          blurRadius: 10.0,
          color: Colors.blue,
          spreadRadius: 1.0,
        );

        final second = BoxShadowMix.only(
          color: Colors.red,
          offset: const Offset(3.0, 3.0),
          spreadRadius: 2.0,
        );

        final merged = first.merge(second);

        expectProp(merged.blurRadius, 10.0);
        expectProp(merged.color, Colors.red);
        expectProp(merged.offset, const Offset(3.0, 3.0));
        expectProp(merged.spreadRadius, 2.0);
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final boxShadowMix1 = BoxShadowMix.only(
          blurRadius: 10.0,
          color: Colors.blue,
          spreadRadius: 2.0,
        );

        final boxShadowMix2 = BoxShadowMix.only(
          blurRadius: 10.0,
          color: Colors.blue,
          spreadRadius: 2.0,
        );

        expect(boxShadowMix1, boxShadowMix2);
        expect(boxShadowMix1.hashCode, boxShadowMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final boxShadowMix1 = BoxShadowMix.only(blurRadius: 10.0);
        final boxShadowMix2 = BoxShadowMix.only(blurRadius: 15.0);

        expect(boxShadowMix1, isNot(boxShadowMix2));
      });
    });
  });
}
