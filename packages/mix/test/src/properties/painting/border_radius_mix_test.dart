import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';
import 'package:mix/src/properties/painting/border_radius_mix.dart';

void main() {
  group('BorderRadiusMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final borderRadiusMix = BorderRadiusMix.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(12.0),
          bottomLeft: const Radius.circular(16.0),
          bottomRight: const Radius.circular(20.0),
        );

        expectProp(borderRadiusMix.$topLeft, const Radius.circular(8.0));
        expectProp(borderRadiusMix.$topRight, const Radius.circular(12.0));
        expectProp(borderRadiusMix.$bottomLeft, const Radius.circular(16.0));
        expectProp(borderRadiusMix.$bottomRight, const Radius.circular(20.0));
      });

      test('value constructor extracts properties from BorderRadius', () {
        const borderRadius = BorderRadius.only(
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(20.0),
        );

        final borderRadiusMix = BorderRadiusMix.value(borderRadius);

        expectProp(borderRadiusMix.$topLeft, const Radius.circular(5.0));
        expectProp(borderRadiusMix.$topRight, const Radius.circular(10.0));
        expectProp(borderRadiusMix.$bottomLeft, const Radius.circular(15.0));
        expectProp(borderRadiusMix.$bottomRight, const Radius.circular(20.0));
      });

      test('maybeValue returns null for null input', () {
        final result = BorderRadiusMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns BorderRadiusMix for non-null input', () {
        final borderRadius = BorderRadius.circular(8.0);
        final result = BorderRadiusMix.maybeValue(borderRadius);

        expect(result, isNotNull);
        expectProp(result!.$topLeft, const Radius.circular(8.0));
      });
    });

    group('resolve', () {
      test('resolves to BorderRadius with correct properties', () {
        final borderRadiusMix = BorderRadiusMix.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(12.0),
          bottomLeft: const Radius.circular(16.0),
          bottomRight: const Radius.circular(20.0),
        );

        const resolvedValue = BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(12.0),
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(20.0),
        );

        expect(borderRadiusMix, resolvesTo(resolvedValue));
      });

      test('uses zero radius for null properties', () {
        final borderRadiusMix = BorderRadiusMix.only(
          topLeft: const Radius.circular(8.0),
        );

        const resolvedValue = BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.zero,
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        );

        expect(borderRadiusMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final borderRadiusMix = BorderRadiusMix.only(
          topLeft: const Radius.circular(8.0),
        );
        final merged = borderRadiusMix.merge(null);

        expect(merged, same(borderRadiusMix));
      });

      test('merges properties correctly', () {
        final first = BorderRadiusMix.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(12.0),
        );

        final second = BorderRadiusMix.only(
          topRight: const Radius.circular(16.0),
          bottomLeft: const Radius.circular(20.0),
        );

        final merged = first.merge(second);

        expectProp(merged.$topLeft, const Radius.circular(8.0));
        expectProp(merged.$topRight, const Radius.circular(16.0));
        expectProp(merged.$bottomLeft, const Radius.circular(20.0));
        expect(merged.$bottomRight, isNull);
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final borderRadiusMix1 = BorderRadiusMix.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(12.0),
        );

        final borderRadiusMix2 = BorderRadiusMix.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(12.0),
        );

        expect(borderRadiusMix1, borderRadiusMix2);
        expect(borderRadiusMix1.hashCode, borderRadiusMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final borderRadiusMix1 = BorderRadiusMix.only(
          topLeft: const Radius.circular(8.0),
        );
        final borderRadiusMix2 = BorderRadiusMix.only(
          topLeft: const Radius.circular(12.0),
        );

        expect(borderRadiusMix1, isNot(borderRadiusMix2));
      });
    });
  });

  group('BorderRadiusDirectionalMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final borderRadiusDirectionalMix = BorderRadiusDirectionalMix.only(
          topStart: const Radius.circular(8.0),
          topEnd: const Radius.circular(12.0),
          bottomStart: const Radius.circular(16.0),
          bottomEnd: const Radius.circular(20.0),
        );

        expectProp(
          borderRadiusDirectionalMix.$topStart,
          const Radius.circular(8.0),
        );
        expectProp(
          borderRadiusDirectionalMix.$topEnd,
          const Radius.circular(12.0),
        );
        expectProp(
          borderRadiusDirectionalMix.$bottomStart,
          const Radius.circular(16.0),
        );
        expectProp(
          borderRadiusDirectionalMix.$bottomEnd,
          const Radius.circular(20.0),
        );
      });

      test(
        'value constructor extracts properties from BorderRadiusDirectional',
        () {
          const borderRadius = BorderRadiusDirectional.only(
            topStart: Radius.circular(5.0),
            topEnd: Radius.circular(10.0),
            bottomStart: Radius.circular(15.0),
            bottomEnd: Radius.circular(20.0),
          );

          final borderRadiusDirectionalMix = BorderRadiusDirectionalMix.value(
            borderRadius,
          );

          expectProp(
            borderRadiusDirectionalMix.$topStart,
            const Radius.circular(5.0),
          );
          expectProp(
            borderRadiusDirectionalMix.$topEnd,
            const Radius.circular(10.0),
          );
          expectProp(
            borderRadiusDirectionalMix.$bottomStart,
            const Radius.circular(15.0),
          );
          expectProp(
            borderRadiusDirectionalMix.$bottomEnd,
            const Radius.circular(20.0),
          );
        },
      );

      test('maybeValue returns null for null input', () {
        final result = BorderRadiusDirectionalMix.maybeValue(null);
        expect(result, isNull);
      });

      test(
        'maybeValue returns BorderRadiusDirectionalMix for non-null input',
        () {
          final borderRadius = BorderRadiusDirectional.circular(8.0);
          final result = BorderRadiusDirectionalMix.maybeValue(borderRadius);

          expect(result, isNotNull);
          expectProp(result!.$topStart, const Radius.circular(8.0));
        },
      );
    });

    group('resolve', () {
      test('resolves to BorderRadiusDirectional with correct properties', () {
        final borderRadiusDirectionalMix = BorderRadiusDirectionalMix.only(
          topStart: const Radius.circular(8.0),
          topEnd: const Radius.circular(12.0),
          bottomStart: const Radius.circular(16.0),
          bottomEnd: const Radius.circular(20.0),
        );

        const resolvedValue = BorderRadiusDirectional.only(
          topStart: Radius.circular(8.0),
          topEnd: Radius.circular(12.0),
          bottomStart: Radius.circular(16.0),
          bottomEnd: Radius.circular(20.0),
        );

        expect(borderRadiusDirectionalMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final borderRadiusDirectionalMix = BorderRadiusDirectionalMix.only(
          topStart: const Radius.circular(8.0),
        );
        final merged = borderRadiusDirectionalMix.merge(null);

        expect(merged, same(borderRadiusDirectionalMix));
      });

      test('merges properties correctly', () {
        final first = BorderRadiusDirectionalMix.only(
          topStart: const Radius.circular(8.0),
          topEnd: const Radius.circular(12.0),
        );

        final second = BorderRadiusDirectionalMix.only(
          topEnd: const Radius.circular(16.0),
          bottomStart: const Radius.circular(20.0),
        );

        final merged = first.merge(second);

        expectProp(merged.$topStart, const Radius.circular(8.0));
        expectProp(merged.$topEnd, const Radius.circular(16.0));
        expectProp(merged.$bottomStart, const Radius.circular(20.0));
        expect(merged.$bottomEnd, isNull);
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final borderRadiusDirectionalMix1 = BorderRadiusDirectionalMix.only(
          topStart: const Radius.circular(8.0),
          topEnd: const Radius.circular(12.0),
        );

        final borderRadiusDirectionalMix2 = BorderRadiusDirectionalMix.only(
          topStart: const Radius.circular(8.0),
          topEnd: const Radius.circular(12.0),
        );

        expect(borderRadiusDirectionalMix1, borderRadiusDirectionalMix2);
        expect(
          borderRadiusDirectionalMix1.hashCode,
          borderRadiusDirectionalMix2.hashCode,
        );
      });

      test('returns false when properties are different', () {
        final borderRadiusDirectionalMix1 = BorderRadiusDirectionalMix.only(
          topStart: const Radius.circular(8.0),
        );
        final borderRadiusDirectionalMix2 = BorderRadiusDirectionalMix.only(
          topStart: const Radius.circular(12.0),
        );

        expect(borderRadiusDirectionalMix1, isNot(borderRadiusDirectionalMix2));
      });
    });
  });
}
