import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';
import '../../helpers/testing_utils.dart';

void main() {
  group('TextHeightBehaviorMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final textHeightBehaviorMix = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        expect(textHeightBehaviorMix.applyHeightToFirstAscent, isProp(false));
        expect(textHeightBehaviorMix.applyHeightToLastDescent, isProp(true));
        expect(textHeightBehaviorMix.leadingDistribution, isProp(TextLeadingDistribution.even));
      });

      test('value constructor extracts properties from TextHeightBehavior', () {
        const textHeightBehavior = TextHeightBehavior(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.proportional,
        );

        final textHeightBehaviorMix = TextHeightBehaviorMix.value(textHeightBehavior);

        expect(textHeightBehaviorMix.applyHeightToFirstAscent, isProp(true));
        expect(textHeightBehaviorMix.applyHeightToLastDescent, isProp(false));
        expect(textHeightBehaviorMix.leadingDistribution, isProp(TextLeadingDistribution.proportional));
      });

      test('maybeValue returns null for null input', () {
        final result = TextHeightBehaviorMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns TextHeightBehaviorMix for non-null input', () {
        const textHeightBehavior = TextHeightBehavior(applyHeightToFirstAscent: false);
        final result = TextHeightBehaviorMix.maybeValue(textHeightBehavior);

        expect(result, isNotNull);
        expect(result!.applyHeightToFirstAscent, isProp(false));
      });
    });

    group('resolve', () {
      test('resolves to TextHeightBehavior with correct properties', () {
        final textHeightBehaviorMix = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final context = MockBuildContext();
        final resolved = textHeightBehaviorMix.resolve(context);

        expect(resolved.applyHeightToFirstAscent, false);
        expect(resolved.applyHeightToLastDescent, true);
        expect(resolved.leadingDistribution, TextLeadingDistribution.even);
      });

      test('uses default values for null properties', () {
        final textHeightBehaviorMix = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: false,
        );

        final context = MockBuildContext();
        final resolved = textHeightBehaviorMix.resolve(context);

        expect(resolved.applyHeightToFirstAscent, false);
        expect(resolved.applyHeightToLastDescent, true); // default
        expect(resolved.leadingDistribution, TextLeadingDistribution.proportional); // default
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final textHeightBehaviorMix = TextHeightBehaviorMix.only(applyHeightToFirstAscent: false);
        final merged = textHeightBehaviorMix.merge(null);

        expect(merged, same(textHeightBehaviorMix));
      });

      test('merges properties correctly', () {
        final first = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
        );

        final second = TextHeightBehaviorMix.only(
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final merged = first.merge(second);

        expect(merged.applyHeightToFirstAscent, isProp(false));
        expect(merged.applyHeightToLastDescent, isProp(false));
        expect(merged.leadingDistribution, isProp(TextLeadingDistribution.even));
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final textHeightBehaviorMix1 = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
        );

        final textHeightBehaviorMix2 = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
        );

        expect(textHeightBehaviorMix1, textHeightBehaviorMix2);
        expect(textHeightBehaviorMix1.hashCode, textHeightBehaviorMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final textHeightBehaviorMix1 = TextHeightBehaviorMix.only(applyHeightToFirstAscent: false);
        final textHeightBehaviorMix2 = TextHeightBehaviorMix.only(applyHeightToFirstAscent: true);

        expect(textHeightBehaviorMix1, isNot(textHeightBehaviorMix2));
      });
    });
  });
}
