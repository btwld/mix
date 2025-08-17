import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/properties/typography/text_height_behavior_mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextHeightBehaviorMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final textHeightBehaviorMix = TextHeightBehaviorMix(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        expect(textHeightBehaviorMix.$applyHeightToFirstAscent, resolvesTo(false));
        expect(textHeightBehaviorMix.$applyHeightToLastDescent, resolvesTo(true));
        expect(
          textHeightBehaviorMix.$leadingDistribution,
          resolvesTo(TextLeadingDistribution.even),
        );
      });

      test('value constructor extracts properties from TextHeightBehavior', () {
        const textHeightBehavior = TextHeightBehavior(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.proportional,
        );

        final textHeightBehaviorMix = TextHeightBehaviorMix.value(
          textHeightBehavior,
        );

        expect(textHeightBehaviorMix.$applyHeightToFirstAscent, resolvesTo(true));
        expect(textHeightBehaviorMix.$applyHeightToLastDescent, resolvesTo(false));
        expect(
          textHeightBehaviorMix.$leadingDistribution,
          resolvesTo(TextLeadingDistribution.proportional),
        );
      });

      test('maybeValue returns null for null input', () {
        final result = TextHeightBehaviorMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns TextHeightBehaviorMix for non-null input', () {
        const textHeightBehavior = TextHeightBehavior(
          applyHeightToFirstAscent: false,
        );
        final result = TextHeightBehaviorMix.maybeValue(textHeightBehavior);

        expect(result, isNotNull);
        expect(result!.$applyHeightToFirstAscent, resolvesTo(false));
      });
    });

    group('Factory Constructors', () {
      test(
        'applyHeightToFirstAscent factory creates TextHeightBehaviorMix with applyHeightToFirstAscent',
        () {
          final textHeightBehaviorMix =
              TextHeightBehaviorMix.applyHeightToFirstAscent(false);

          expect(textHeightBehaviorMix.$applyHeightToFirstAscent, resolvesTo(false));
          expect(textHeightBehaviorMix.$applyHeightToLastDescent, isNull);
          expect(textHeightBehaviorMix.$leadingDistribution, isNull);
        },
      );

      test(
        'applyHeightToLastDescent factory creates TextHeightBehaviorMix with applyHeightToLastDescent',
        () {
          final textHeightBehaviorMix =
              TextHeightBehaviorMix.applyHeightToLastDescent(true);

          expect(textHeightBehaviorMix.$applyHeightToLastDescent, resolvesTo(true));
          expect(textHeightBehaviorMix.$applyHeightToFirstAscent, isNull);
          expect(textHeightBehaviorMix.$leadingDistribution, isNull);
        },
      );

      test(
        'leadingDistribution factory creates TextHeightBehaviorMix with leadingDistribution',
        () {
          final textHeightBehaviorMix =
              TextHeightBehaviorMix.leadingDistribution(
                TextLeadingDistribution.even,
              );

          expect(
            textHeightBehaviorMix.$leadingDistribution,
            resolvesTo(TextLeadingDistribution.even),
          );
          expect(textHeightBehaviorMix.$applyHeightToFirstAscent, isNull);
          expect(textHeightBehaviorMix.$applyHeightToLastDescent, isNull);
        },
      );
    });

    group('Utility Methods', () {
      test('applyHeightToFirstAscent utility works correctly', () {
        final textHeightBehaviorMix = TextHeightBehaviorMix()
            .applyHeightToFirstAscent(true);

        expect(textHeightBehaviorMix.$applyHeightToFirstAscent, resolvesTo(true));
      });

      test('applyHeightToLastDescent utility works correctly', () {
        final textHeightBehaviorMix = TextHeightBehaviorMix()
            .applyHeightToLastDescent(false);

        expect(textHeightBehaviorMix.$applyHeightToLastDescent, resolvesTo(false));
      });

      test('leadingDistribution utility works correctly', () {
        final textHeightBehaviorMix = TextHeightBehaviorMix()
            .leadingDistribution(TextLeadingDistribution.proportional);

        expect(
          textHeightBehaviorMix.$leadingDistribution,
          resolvesTo(TextLeadingDistribution.proportional),
        );
      });
    });

    group('resolve', () {
      test('resolves to TextHeightBehavior with correct properties', () {
        final textHeightBehaviorMix = TextHeightBehaviorMix(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        const resolvedValue = TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        expect(textHeightBehaviorMix, resolvesTo(resolvedValue));
      });

      test('uses default values for null properties', () {
        final textHeightBehaviorMix = TextHeightBehaviorMix(
          applyHeightToFirstAscent: false,
        );

        const resolvedValue = TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true, // default
          leadingDistribution: TextLeadingDistribution.proportional, // default
        );

        expect(textHeightBehaviorMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final textHeightBehaviorMix = TextHeightBehaviorMix(
          applyHeightToFirstAscent: false,
        );
        final merged = textHeightBehaviorMix.merge(null);

        expect(merged, same(textHeightBehaviorMix));
      });

      test('merges properties correctly', () {
        final first = TextHeightBehaviorMix(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
        );

        final second = TextHeightBehaviorMix(
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final merged = first.merge(second);

        expect(merged.$applyHeightToFirstAscent, resolvesTo(false));
        expect(merged.$applyHeightToLastDescent, resolvesTo(false));
        expect(merged.$leadingDistribution, resolvesTo(TextLeadingDistribution.even));
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final textHeightBehaviorMix1 = TextHeightBehaviorMix(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
        );

        final textHeightBehaviorMix2 = TextHeightBehaviorMix(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
        );

        expect(textHeightBehaviorMix1, textHeightBehaviorMix2);
        expect(
          textHeightBehaviorMix1.hashCode,
          textHeightBehaviorMix2.hashCode,
        );
      });

      test('returns false when properties are different', () {
        final textHeightBehaviorMix1 = TextHeightBehaviorMix(
          applyHeightToFirstAscent: false,
        );
        final textHeightBehaviorMix2 = TextHeightBehaviorMix(
          applyHeightToFirstAscent: true,
        );

        expect(textHeightBehaviorMix1, isNot(textHeightBehaviorMix2));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final textHeightBehaviorMix = TextHeightBehaviorMix(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        expect(textHeightBehaviorMix.props.length, 3);
        expect(
          textHeightBehaviorMix.props,
          contains(textHeightBehaviorMix.$applyHeightToFirstAscent),
        );
        expect(
          textHeightBehaviorMix.props,
          contains(textHeightBehaviorMix.$applyHeightToLastDescent),
        );
        expect(
          textHeightBehaviorMix.props,
          contains(textHeightBehaviorMix.$leadingDistribution),
        );
      });
    });
  });
}