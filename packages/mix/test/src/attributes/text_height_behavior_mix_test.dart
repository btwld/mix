import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  group('TextHeightBehaviorMix', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test(
        'only constructor creates TextHeightBehaviorMix with all properties',
        () {
          final mix = TextHeightBehaviorMix.only(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: false,
            leadingDistribution: TextLeadingDistribution.even,
          );

          expect(mix.applyHeightToFirstAscent, resolvesTo(true));
          expect(mix.applyHeightToLastDescent, resolvesTo(false));
          expect(
            mix.leadingDistribution,
            resolvesTo(TextLeadingDistribution.even),
          );
        },
      );

      test(
        'main constructor creates TextHeightBehaviorMix with null properties',
        () {
          final mix = TextHeightBehaviorMix();

          expect(mix.applyHeightToFirstAscent, isNull);
          expect(mix.applyHeightToLastDescent, isNull);
          expect(mix.leadingDistribution, isNull);
        },
      );

      test('main constructor with Prop values', () {
        final mix = TextHeightBehaviorMix(
          applyHeightToFirstAscent: Prop(false),
          applyHeightToLastDescent: Prop(true),
          leadingDistribution: Prop(TextLeadingDistribution.proportional),
        );

        expect(mix.applyHeightToFirstAscent, resolvesTo(false));
        expect(mix.applyHeightToLastDescent, resolvesTo(true));
        expect(
          mix.leadingDistribution,
          resolvesTo(TextLeadingDistribution.proportional),
        );
      });

      test('value constructor from TextHeightBehavior', () {
        const behavior = TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );
        final mix = TextHeightBehaviorMix.value(behavior);

        expect(
          mix.applyHeightToFirstAscent,
          resolvesTo(behavior.applyHeightToFirstAscent),
        );
        expect(
          mix.applyHeightToLastDescent,
          resolvesTo(behavior.applyHeightToLastDescent),
        );
        expect(
          mix.leadingDistribution,
          resolvesTo(behavior.leadingDistribution),
        );
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test(
        'maybeValue returns TextHeightBehaviorMix for non-null TextHeightBehavior',
        () {
          const behavior = TextHeightBehavior(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: false,
          );
          final mix = TextHeightBehaviorMix.maybeValue(behavior);

          expect(mix, isNotNull);
          expect(
            dto?.applyHeightToFirstAscent,
            resolvesTo(behavior.applyHeightToFirstAscent),
          );
          expect(
            dto?.applyHeightToLastDescent,
            resolvesTo(behavior.applyHeightToLastDescent),
          );
        },
      );

      test('maybeValue returns null for null TextHeightBehavior', () {
        final mix = TextHeightBehaviorMix.maybeValue(null);
        expect(mix, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to TextHeightBehavior with all properties', () {
        final mix = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );

        expect(
          dto,
          resolvesTo(
            const TextHeightBehavior(
              applyHeightToFirstAscent: true,
              applyHeightToLastDescent: false,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        const dto = TextHeightBehaviorMix();

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.applyHeightToFirstAscent, true);
        expect(resolved.applyHeightToLastDescent, true);
        expect(
          resolved.leadingDistribution,
          TextLeadingDistribution.proportional,
        );
      });

      test('resolves with partial properties', () {
        final mix = TextHeightBehaviorMix.only(applyHeightToFirstAscent: false);

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.applyHeightToFirstAscent, false);
        expect(resolved.applyHeightToLastDescent, true); // default
        expect(
          resolved.leadingDistribution,
          TextLeadingDistribution.proportional,
        ); // default
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another TextHeightBehaviorMix - all properties', () {
        final mix1 = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.proportional,
        );
        final mix2 = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final merged = dto1.merge(mix2);

        expect(merged.applyHeightToFirstAscent, resolvesTo(false));
        expect(merged.applyHeightToLastDescent, resolvesTo(false));
        expect(
          merged.leadingDistribution,
          resolvesTo(TextLeadingDistribution.even),
        );
      });

      test('merge with partial properties', () {
        final mix1 = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.proportional,
        );
        final mix2 = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: false,
        );

        final merged = dto1.merge(mix2);

        expect(merged.applyHeightToFirstAscent, resolvesTo(false));
        expect(merged.applyHeightToLastDescent, resolvesTo(true));
        expect(
          merged.leadingDistribution,
          resolvesTo(TextLeadingDistribution.proportional),
        );
      });

      test('merge with null returns original', () {
        final mix = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final merged = mix.merge(null);
        expect(merged, same(mix));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal TextHeightBehaviorMixs', () {
        final mix1 = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );
        final mix2 = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );

        expect(mix1, equals(mix2));
        expect(mix1.hashCode, equals(mix2.hashCode));
      });

      test('not equal TextHeightBehaviorMixs', () {
        final mix1 = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
        );
        final mix2 = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
        );

        expect(mix1, isNot(equals(mix2)));
      });

      test('equal TextHeightBehaviorMixs with all null properties', () {
        final mix1 = TextHeightBehaviorMix.only();
        final mix2 = TextHeightBehaviorMix.only();

        expect(mix1, equals(mix2));
        expect(mix1.hashCode, equals(mix2.hashCode));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles all boolean combinations', () {
        final combinations = [
          (true, true),
          (true, false),
          (false, true),
          (false, false),
        ];

        for (final (first, last) in combinations) {
          final mix = TextHeightBehaviorMix.only(
            applyHeightToFirstAscent: first,
            applyHeightToLastDescent: last,
          );

          expect(mix.applyHeightToFirstAscent, resolvesTo(first));
          expect(mix.applyHeightToLastDescent, resolvesTo(last));
        }
      });

      test('handles all TextLeadingDistribution values', () {
        final distributions = [
          TextLeadingDistribution.proportional,
          TextLeadingDistribution.even,
        ];

        for (final distribution in distributions) {
          final mix = TextHeightBehaviorMix.only(
            leadingDistribution: distribution,
          );

          expect(mix.leadingDistribution, resolvesTo(distribution));
        }
      });

      test('handles mixed null and non-null properties', () {
        final mix = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: true,
          // applyHeightToLastDescent is null
          leadingDistribution: TextLeadingDistribution.even,
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.applyHeightToFirstAscent, true);
        expect(resolved.applyHeightToLastDescent, true); // default
        expect(resolved.leadingDistribution, TextLeadingDistribution.even);
      });
    });

    // Integration Tests
    group('Integration Tests', () {
      test('TextHeightBehaviorMix used in TextStyle context', () {
        final mix = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.applyHeightToFirstAscent, false);
        expect(resolved.applyHeightToLastDescent, true);
        expect(resolved.leadingDistribution, TextLeadingDistribution.even);
      });

      test('complex merge scenario', () {
        final baseStyle = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.proportional,
        );

        final overrideStyle = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final finalStyle = TextHeightBehaviorMix.only(
          applyHeightToLastDescent: false,
        );

        final merged = baseStyle.merge(overrideStyle).merge(finalStyle);

        expect(merged.applyHeightToFirstAscent, resolvesTo(false));
        expect(merged.applyHeightToLastDescent, resolvesTo(false));
        expect(
          merged.leadingDistribution,
          resolvesTo(TextLeadingDistribution.even),
        );
      });

      test('compatibility with TextStyle', () {
        final heightBehavior = TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final textStyle = TextStyleMix.only(fontSize: 16.0, height: 1.5);

        final context = MockBuildContext();
        final resolvedBehavior = heightBehavior.resolve(context);
        final resolvedStyle = textStyle.resolve(context);

        expect(resolvedBehavior.applyHeightToFirstAscent, false);
        expect(resolvedBehavior.applyHeightToLastDescent, true);
        expect(
          resolvedBehavior.leadingDistribution,
          TextLeadingDistribution.even,
        );
        expect(resolvedStyle.fontSize, 16.0);
        expect(resolvedStyle.height, 1.5);
      });

      test('merge preserves non-overlapping properties', () {
        final mix1 = TextHeightBehaviorMix.only(applyHeightToFirstAscent: true);
        final mix2 = TextHeightBehaviorMix.only(
          applyHeightToLastDescent: false,
        );
        final dto3 = TextHeightBehaviorMix.only(
          leadingDistribution: TextLeadingDistribution.even,
        );

        final merged = dto1.merge(mix2).merge(mix3);

        expect(merged.applyHeightToFirstAscent, resolvesTo(true));
        expect(merged.applyHeightToLastDescent, resolvesTo(false));
        expect(
          merged.leadingDistribution,
          resolvesTo(TextLeadingDistribution.even),
        );
      });
    });
  });

  // Utility tests removed due to missing UtilityTestAttribute infrastructure
  /*
  group('TextHeightBehaviorUtility', () {
    late TextHeightBehaviorUtility utility;

    setUp(() {
      utility = TextHeightBehaviorUtility(UtilityTestAttribute.new);
    });

    test('heightToFirstAscent sets applyHeightToFirstAscent', () {
      final result =
          utility.heightToFirstAscent(true)
              as UtilityTestAttribute<TextHeightBehaviorMix>;
      expect(result.value.applyHeightToFirstAscent, resolvesTo(true));
      expect(result.value.applyHeightToLastDescent, isNull);
      expect(result.value.leadingDistribution, isNull);
    });

    test('heightToLastDescent sets applyHeightToLastDescent', () {
      final result =
          utility.heightToLastDescent(false)
              as UtilityTestAttribute<TextHeightBehaviorMix>;
      expect(result.value.applyHeightToFirstAscent, isNull);
      expect(result.value.applyHeightToLastDescent, resolvesTo(false));
      expect(result.value.leadingDistribution, isNull);
    });

    test('leadingDistribution sets leadingDistribution', () {
      final result =
          utility.leadingDistribution(TextLeadingDistribution.proportional)
              as UtilityTestAttribute<TextHeightBehaviorMix>;
      expect(result.value.applyHeightToFirstAscent, isNull);
      expect(result.value.applyHeightToLastDescent, isNull);
      expect(
        result.value.leadingDistribution,
        resolvesTo(TextLeadingDistribution.proportional),
      );
    });

    test('only sets multiple properties', () {
      final result =
          utility.only(
                applyHeightToFirstAscent: true,
                applyHeightToLastDescent: false,
                leadingDistribution: TextLeadingDistribution.even,
              )
              as UtilityTestAttribute<TextHeightBehaviorMix>;
      expect(result.value.applyHeightToFirstAscent, resolvesTo(true));
      expect(result.value.applyHeightToLastDescent, resolvesTo(false));
      expect(
        result.value.leadingDistribution,
        resolvesTo(TextLeadingDistribution.even),
      );
    });
  });
  */
}
