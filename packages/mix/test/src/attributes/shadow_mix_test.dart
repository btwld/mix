import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';
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

        expect(shadowMix.blurRadius, isProp(10.0));
        expect(shadowMix.color, isProp(Colors.blue));
        expect(shadowMix.offset, isProp(const Offset(5.0, 8.0)));
      });

      test('value constructor extracts properties from Shadow', () {
        const shadow = Shadow(
          blurRadius: 15.0,
          color: Colors.red,
          offset: Offset(3.0, 6.0),
        );

        final shadowMix = ShadowMix.value(shadow);

        expect(shadowMix.blurRadius, isProp(15.0));
        expect(shadowMix.color, isProp(Colors.red));
        expect(shadowMix.offset, isProp(const Offset(3.0, 6.0)));
      });

      test('maybeValue returns null for null input', () {
        final result = ShadowMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns ShadowMix for non-null input', () {
        const shadow = Shadow(blurRadius: 5.0);
        final result = ShadowMix.maybeValue(shadow);

        expect(result, isNotNull);
        expect(result!.blurRadius, isProp(5.0));
      });
    });

    group('resolve', () {
      test('resolves to Shadow with correct properties', () {
        final shadowMix = ShadowMix.only(
          blurRadius: 12.0,
          color: Colors.green,
          offset: const Offset(2.0, 4.0),
        );

        final context = MockBuildContext();
        final resolved = shadowMix.resolve(context);

        expect(resolved.blurRadius, 12.0);
        expect(resolved.color, Colors.green);
        expect(resolved.offset, const Offset(2.0, 4.0));
      });

      test('uses default values for null properties', () {
        final shadowMix = ShadowMix.only(blurRadius: 8.0);

        final context = MockBuildContext();
        final resolved = shadowMix.resolve(context);

        expect(resolved.blurRadius, 8.0);
        expect(resolved.color, const Color(0xFF000000));
        expect(resolved.offset, Offset.zero);
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final shadowMix = ShadowMix.only(blurRadius: 5.0);
        final merged = shadowMix.merge(null);

        expect(merged, same(shadowMix));
      });

      test('merges properties correctly', () {
        final first = ShadowMix.only(
          blurRadius: 10.0,
          color: Colors.blue,
        );

        final second = ShadowMix.only(
          color: Colors.red,
          offset: const Offset(3.0, 3.0),
        );

        final merged = first.merge(second);

        expect(merged.blurRadius, isProp(10.0));
        expect(merged.color, isProp(Colors.red));
        expect(merged.offset, isProp(const Offset(3.0, 3.0)));
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final shadowMix1 = ShadowMix.only(
          blurRadius: 10.0,
          color: Colors.blue,
        );

        final shadowMix2 = ShadowMix.only(
          blurRadius: 10.0,
          color: Colors.blue,
        );

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

        expect(boxShadowMix.blurRadius, isProp(10.0));
        expect(boxShadowMix.color, isProp(Colors.blue));
        expect(boxShadowMix.offset, isProp(const Offset(5.0, 8.0)));
        expect(boxShadowMix.spreadRadius, isProp(2.0));
      });

      test('value constructor extracts properties from BoxShadow', () {
        const boxShadow = BoxShadow(
          blurRadius: 15.0,
          color: Colors.red,
          offset: Offset(3.0, 6.0),
          spreadRadius: 4.0,
        );

        final boxShadowMix = BoxShadowMix.value(boxShadow);

        expect(boxShadowMix.blurRadius, isProp(15.0));
        expect(boxShadowMix.color, isProp(Colors.red));
        expect(boxShadowMix.offset, isProp(const Offset(3.0, 6.0)));
        expect(boxShadowMix.spreadRadius, isProp(4.0));
      });

      test('maybeValue returns null for null input', () {
        final result = BoxShadowMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns BoxShadowMix for non-null input', () {
        const boxShadow = BoxShadow(blurRadius: 5.0);
        final result = BoxShadowMix.maybeValue(boxShadow);

        expect(result, isNotNull);
        expect(result!.blurRadius, isProp(5.0));
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

        final context = MockBuildContext();
        final resolved = boxShadowMix.resolve(context);

        expect(resolved.blurRadius, 12.0);
        expect(resolved.color, Colors.green);
        expect(resolved.offset, const Offset(2.0, 4.0));
        expect(resolved.spreadRadius, 3.0);
      });

      test('uses default values for null properties', () {
        final boxShadowMix = BoxShadowMix.only(blurRadius: 8.0);

        final context = MockBuildContext();
        final resolved = boxShadowMix.resolve(context);

        expect(resolved.blurRadius, 8.0);
        expect(resolved.color, const Color(0xFF000000));
        expect(resolved.offset, Offset.zero);
        expect(resolved.spreadRadius, 0.0);
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

        expect(merged.blurRadius, isProp(10.0));
        expect(merged.color, isProp(Colors.red));
        expect(merged.offset, isProp(const Offset(3.0, 3.0)));
        expect(merged.spreadRadius, isProp(2.0));
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
