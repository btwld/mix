import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('TextHeightBehaviorDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test(
        'main constructor creates TextHeightBehaviorDto with all properties',
        () {
          final dto = TextHeightBehaviorDto(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: false,
            leadingDistribution: TextLeadingDistribution.even,
          );

          expect(dto.applyHeightToFirstAscent, resolvesTo(true));
          expect(dto.applyHeightToLastDescent, resolvesTo(false));
          expect(
            dto.leadingDistribution,
            resolvesTo(TextLeadingDistribution.even),
          );
        },
      );

      test(
        'main constructor creates TextHeightBehaviorDto with null properties',
        () {
          final dto = TextHeightBehaviorDto();

          expect(dto.applyHeightToFirstAscent, isNull);
          expect(dto.applyHeightToLastDescent, isNull);
          expect(dto.leadingDistribution, isNull);
        },
      );

      test('props constructor with Prop values', () {
        const dto = TextHeightBehaviorDto.props(
          applyHeightToFirstAscent: Prop.fromValue(false),
          applyHeightToLastDescent: Prop.fromValue(true),
          leadingDistribution: Prop.fromValue(
            TextLeadingDistribution.proportional,
          ),
        );

        expect(dto.applyHeightToFirstAscent, resolvesTo(false));
        expect(dto.applyHeightToLastDescent, resolvesTo(true));
        expect(
          dto.leadingDistribution,
          resolvesTo(TextLeadingDistribution.proportional),
        );
      });

      test('value constructor from TextHeightBehavior', () {
        const behavior = TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );
        final dto = TextHeightBehaviorDto.value(behavior);

        expect(
          dto.applyHeightToFirstAscent,
          resolvesTo(behavior.applyHeightToFirstAscent),
        );
        expect(
          dto.applyHeightToLastDescent,
          resolvesTo(behavior.applyHeightToLastDescent),
        );
        expect(
          dto.leadingDistribution,
          resolvesTo(behavior.leadingDistribution),
        );
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test(
        'maybeValue returns TextHeightBehaviorDto for non-null TextHeightBehavior',
        () {
          const behavior = TextHeightBehavior(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: false,
          );
          final dto = TextHeightBehaviorDto.maybeValue(behavior);

          expect(dto, isNotNull);
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
        final dto = TextHeightBehaviorDto.maybeValue(null);
        expect(dto, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to TextHeightBehavior with all properties', () {
        final dto = TextHeightBehaviorDto(
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
        const dto = TextHeightBehaviorDto.props();

        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

        expect(resolved.applyHeightToFirstAscent, true);
        expect(resolved.applyHeightToLastDescent, true);
        expect(
          resolved.leadingDistribution,
          TextLeadingDistribution.proportional,
        );
      });

      test('resolves with partial properties', () {
        final dto = TextHeightBehaviorDto(applyHeightToFirstAscent: false);

        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

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
      test('merge with another TextHeightBehaviorDto - all properties', () {
        final dto1 = TextHeightBehaviorDto(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.proportional,
        );
        final dto2 = TextHeightBehaviorDto(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final merged = dto1.merge(dto2);

        expect(merged.applyHeightToFirstAscent, resolvesTo(false));
        expect(merged.applyHeightToLastDescent, resolvesTo(false));
        expect(
          merged.leadingDistribution,
          resolvesTo(TextLeadingDistribution.even),
        );
      });

      test('merge with partial properties', () {
        final dto1 = TextHeightBehaviorDto(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.proportional,
        );
        final dto2 = TextHeightBehaviorDto(applyHeightToFirstAscent: false);

        final merged = dto1.merge(dto2);

        expect(merged.applyHeightToFirstAscent, resolvesTo(false));
        expect(merged.applyHeightToLastDescent, resolvesTo(true));
        expect(
          merged.leadingDistribution,
          resolvesTo(TextLeadingDistribution.proportional),
        );
      });

      test('merge with null returns original', () {
        final dto = TextHeightBehaviorDto(
          applyHeightToFirstAscent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final merged = dto.merge(null);
        expect(merged, same(dto));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal TextHeightBehaviorDtos', () {
        final dto1 = TextHeightBehaviorDto(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );
        final dto2 = TextHeightBehaviorDto(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal TextHeightBehaviorDtos', () {
        final dto1 = TextHeightBehaviorDto(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
        );
        final dto2 = TextHeightBehaviorDto(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
        );

        expect(dto1, isNot(equals(dto2)));
      });

      test('equal TextHeightBehaviorDtos with all null properties', () {
        final dto1 = TextHeightBehaviorDto();
        final dto2 = TextHeightBehaviorDto();

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
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
          final dto = TextHeightBehaviorDto(
            applyHeightToFirstAscent: first,
            applyHeightToLastDescent: last,
          );

          expect(dto.applyHeightToFirstAscent, resolvesTo(first));
          expect(dto.applyHeightToLastDescent, resolvesTo(last));
        }
      });

      test('handles all TextLeadingDistribution values', () {
        final distributions = [
          TextLeadingDistribution.proportional,
          TextLeadingDistribution.even,
        ];

        for (final distribution in distributions) {
          final dto = TextHeightBehaviorDto(leadingDistribution: distribution);

          expect(dto.leadingDistribution, resolvesTo(distribution));
        }
      });

      test('handles mixed null and non-null properties', () {
        final dto = TextHeightBehaviorDto(
          applyHeightToFirstAscent: true,
          // applyHeightToLastDescent is null
          leadingDistribution: TextLeadingDistribution.even,
        );

        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

        expect(resolved.applyHeightToFirstAscent, true);
        expect(resolved.applyHeightToLastDescent, true); // default
        expect(resolved.leadingDistribution, TextLeadingDistribution.even);
      });
    });

    // Integration Tests
    group('Integration Tests', () {
      test('TextHeightBehaviorDto used in TextStyle context', () {
        final dto = TextHeightBehaviorDto(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

        expect(resolved.applyHeightToFirstAscent, false);
        expect(resolved.applyHeightToLastDescent, true);
        expect(resolved.leadingDistribution, TextLeadingDistribution.even);
      });

      test('complex merge scenario', () {
        final baseStyle = TextHeightBehaviorDto(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.proportional,
        );

        final overrideStyle = TextHeightBehaviorDto(
          applyHeightToFirstAscent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final finalStyle = TextHeightBehaviorDto(
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
        final heightBehavior = TextHeightBehaviorDto(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final textStyle = TextStyleDto(fontSize: 16.0, height: 1.5);

        final context = createEmptyMixData();
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
        final dto1 = TextHeightBehaviorDto(applyHeightToFirstAscent: true);
        final dto2 = TextHeightBehaviorDto(applyHeightToLastDescent: false);
        final dto3 = TextHeightBehaviorDto(
          leadingDistribution: TextLeadingDistribution.even,
        );

        final merged = dto1.merge(dto2).merge(dto3);

        expect(merged.applyHeightToFirstAscent, resolvesTo(true));
        expect(merged.applyHeightToLastDescent, resolvesTo(false));
        expect(
          merged.leadingDistribution,
          resolvesTo(TextLeadingDistribution.even),
        );
      });
    });
  });

  group('TextHeightBehaviorUtility', () {
    late TextHeightBehaviorUtility utility;

    setUp(() {
      utility = TextHeightBehaviorUtility(UtilityTestAttribute.new);
    });

    test('heightToFirstAscent sets applyHeightToFirstAscent', () {
      final result =
          utility.heightToFirstAscent(true)
              as UtilityTestAttribute<TextHeightBehaviorDto>;
      expect(result.value.applyHeightToFirstAscent, resolvesTo(true));
      expect(result.value.applyHeightToLastDescent, isNull);
      expect(result.value.leadingDistribution, isNull);
    });

    test('heightToLastDescent sets applyHeightToLastDescent', () {
      final result =
          utility.heightToLastDescent(false)
              as UtilityTestAttribute<TextHeightBehaviorDto>;
      expect(result.value.applyHeightToFirstAscent, isNull);
      expect(result.value.applyHeightToLastDescent, resolvesTo(false));
      expect(result.value.leadingDistribution, isNull);
    });

    test('leadingDistribution sets leadingDistribution', () {
      final result =
          utility.leadingDistribution(TextLeadingDistribution.proportional)
              as UtilityTestAttribute<TextHeightBehaviorDto>;
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
              as UtilityTestAttribute<TextHeightBehaviorDto>;
      expect(result.value.applyHeightToFirstAscent, resolvesTo(true));
      expect(result.value.applyHeightToLastDescent, resolvesTo(false));
      expect(
        result.value.leadingDistribution,
        resolvesTo(TextLeadingDistribution.even),
      );
    });
  });
}
