import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextHeightBehaviorUtility', () {
    late TextHeightBehaviorUtility<MockStyle<TextHeightBehaviorMix>> util;

    setUp(() {
      util = TextHeightBehaviorUtility<MockStyle<TextHeightBehaviorMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has heightToFirstAscent utility', () {
        expect(util.heightToFirstAscent, isA<MixUtility>());
      });

      test('has heightToLastDescent utility', () {
        expect(util.heightToLastDescent, isA<MixUtility>());
      });

      test('has leadingDistribution utility', () {
        expect(util.leadingDistribution, isA<MixUtility>());
      });
    });

    group('property setters', () {
      test('heightToFirstAscent sets applyHeightToFirstAscent', () {
        final result = util.heightToFirstAscent(false);

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(applyHeightToFirstAscent: false),
        );
      });

      test('heightToLastDescent sets applyHeightToLastDescent', () {
        final result = util.heightToLastDescent(false);

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(applyHeightToLastDescent: false),
        );
      });

      test('leadingDistribution sets leading distribution', () {
        final result = util.leadingDistribution(TextLeadingDistribution.even);

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(
            leadingDistribution: TextLeadingDistribution.even,
          ),
        );
      });
    });

    group('only method', () {
      test('sets all properties', () {
        final result = util(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        );
      });

      test('sets partial properties', () {
        final result = util(
          applyHeightToFirstAscent: true,
          leadingDistribution: TextLeadingDistribution.proportional,
        );

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(
            applyHeightToFirstAscent: true,
            leadingDistribution: TextLeadingDistribution.proportional,
          ),
        );
      });

      test('handles null values with defaults', () {
        final result = util();

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(
            applyHeightToFirstAscent: true, // Default value
            applyHeightToLastDescent: true, // Default value
            leadingDistribution:
                TextLeadingDistribution.proportional, // Default
          ),
        );
      });

      test('sets only applyHeightToFirstAscent', () {
        final result = util(applyHeightToFirstAscent: false);

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: true, // Default
            leadingDistribution:
                TextLeadingDistribution.proportional, // Default
          ),
        );
      });

      test('sets only applyHeightToLastDescent', () {
        final result = util(applyHeightToLastDescent: false);

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(
            applyHeightToFirstAscent: true, // Default
            applyHeightToLastDescent: false,
            leadingDistribution:
                TextLeadingDistribution.proportional, // Default
          ),
        );
      });

      test('sets only leadingDistribution', () {
        final result = util(leadingDistribution: TextLeadingDistribution.even);

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(
            applyHeightToFirstAscent: true, // Default
            applyHeightToLastDescent: true, // Default
            leadingDistribution: TextLeadingDistribution.even,
          ),
        );
      });
    });

    group('call method', () {
      test('delegates to only method with all properties', () {
        final result = util(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: false,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        );
      });

      test('handles partial parameters', () {
        final result = util(
          applyHeightToFirstAscent: false,
          leadingDistribution: TextLeadingDistribution.proportional,
        );

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: true, // Default
            leadingDistribution: TextLeadingDistribution.proportional,
          ),
        );
      });

      test('handles empty parameters with defaults', () {
        final result = util();

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(
            applyHeightToFirstAscent: true, // Default
            applyHeightToLastDescent: true, // Default
            leadingDistribution:
                TextLeadingDistribution.proportional, // Default
          ),
        );
      });
    });

    group('as method', () {
      test('accepts TextHeightBehavior with all properties', () {
        const behavior = TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );
        final result = util.as(behavior);

        expect(
          result.value,
          TextHeightBehaviorMix(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: true,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        );
      });

      test('accepts default TextHeightBehavior', () {
        const behavior = TextHeightBehavior();
        final result = util.as(behavior);

        final resolved = result.value.resolve(MockBuildContext());
        expect(
          resolved.applyHeightToFirstAscent,
          behavior.applyHeightToFirstAscent,
        );
        expect(
          resolved.applyHeightToLastDescent,
          behavior.applyHeightToLastDescent,
        );
        expect(resolved.leadingDistribution, behavior.leadingDistribution);
      });

      test('accepts TextHeightBehavior with mixed properties', () {
        const behavior = TextHeightBehavior(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.proportional,
        );
        final result = util.as(behavior);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, behavior);
      });
    });

    group('boolean property variations', () {
      test('handles all combinations of boolean properties', () {
        final combinations = [
          (true, true),
          (true, false),
          (false, true),
          (false, false),
        ];

        for (final (firstAscent, lastDescent) in combinations) {
          final result = util(
            applyHeightToFirstAscent: firstAscent,
            applyHeightToLastDescent: lastDescent,
          );

          final behavior = result.value.resolve(MockBuildContext());

          expect(behavior.applyHeightToFirstAscent, firstAscent);
          expect(behavior.applyHeightToLastDescent, lastDescent);
        }
      });

      test('heightToFirstAscent utility handles true', () {
        final result = util.heightToFirstAscent(true);

        final behavior = result.value.resolve(MockBuildContext());

        expect(behavior.applyHeightToFirstAscent, true);
      });

      test('heightToFirstAscent utility handles false', () {
        final result = util.heightToFirstAscent(false);

        final behavior = result.value.resolve(MockBuildContext());

        expect(behavior.applyHeightToFirstAscent, false);
      });

      test('heightToLastDescent utility handles true', () {
        final result = util.heightToLastDescent(true);

        final behavior = result.value.resolve(MockBuildContext());

        expect(behavior.applyHeightToLastDescent, true);
      });

      test('heightToLastDescent utility handles false', () {
        final result = util.heightToLastDescent(false);

        final behavior = result.value.resolve(MockBuildContext());

        expect(behavior.applyHeightToLastDescent, false);
      });
    });

    group('leading distribution variations', () {
      test('handles TextLeadingDistribution.proportional', () {
        final result = util.leadingDistribution(
          TextLeadingDistribution.proportional,
        );

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior.leadingDistribution,
          TextLeadingDistribution.proportional,
        );
      });

      test('handles TextLeadingDistribution.even', () {
        final result = util.leadingDistribution(TextLeadingDistribution.even);

        final behavior = result.value.resolve(MockBuildContext());

        expect(behavior.leadingDistribution, TextLeadingDistribution.even);
      });

      test('validates all TextLeadingDistribution values', () {
        final distributions = [
          TextLeadingDistribution.proportional,
          TextLeadingDistribution.even,
        ];

        for (final distribution in distributions) {
          final result = util.leadingDistribution(distribution);
          final behavior = result.value.resolve(MockBuildContext());
          expect(behavior.leadingDistribution, distribution);
        }
      });
    });

    group('property combinations', () {
      test('combines height properties with proportional distribution', () {
        final result = util(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.proportional,
        );

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
            leadingDistribution: TextLeadingDistribution.proportional,
          ),
        );
      });

      test('combines height properties with even distribution', () {
        final result = util(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: true,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        );
      });

      test('combines mixed boolean values with different distributions', () {
        final result = util(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final behavior = result.value.resolve(MockBuildContext());

        expect(
          behavior,
          const TextHeightBehavior(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: false,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        );
      });
    });

    group('merge behavior validation', () {
      test('merging preserves individual properties', () {
        final behavior1 = TextHeightBehaviorMix(
          applyHeightToFirstAscent: true,
          leadingDistribution: TextLeadingDistribution.proportional,
        );
        final behavior2 = TextHeightBehaviorMix(
          applyHeightToLastDescent: false,
        );

        final merged = behavior1.merge(behavior2);
        final resolved = merged.resolve(MockBuildContext());

        expect(
          resolved,
          const TextHeightBehavior(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: false,
            leadingDistribution: TextLeadingDistribution.proportional,
          ),
        );
      });

      test('merging overwrites conflicting properties', () {
        final behavior1 = TextHeightBehaviorMix(
          applyHeightToFirstAscent: true,
          leadingDistribution: TextLeadingDistribution.proportional,
        );
        final behavior2 = TextHeightBehaviorMix(
          applyHeightToFirstAscent: false,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final merged = behavior1.merge(behavior2);
        final resolved = merged.resolve(MockBuildContext());

        expect(
          resolved,
          const TextHeightBehavior(
            applyHeightToFirstAscent: false, // Should use merged value
            applyHeightToLastDescent: true, // Default
            leadingDistribution:
                TextLeadingDistribution.even, // Should use merged value
          ),
        );
      });

      test('merging with null returns original', () {
        final behavior = TextHeightBehaviorMix(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final merged = behavior.merge(null);

        expect(merged, behavior);
      });
    });

    group('default value behavior', () {
      test('uses correct default values when properties are null', () {
        final result = util();

        final behavior = result.value.resolve(MockBuildContext());

        // Check that defaults match Flutter's TextHeightBehavior defaults
        expect(behavior.applyHeightToFirstAscent, true);
        expect(behavior.applyHeightToLastDescent, true);
        expect(
          behavior.leadingDistribution,
          TextLeadingDistribution.proportional,
        );
      });

      test('partial properties use defaults for unspecified values', () {
        final result = util(applyHeightToFirstAscent: false);

        final behavior = result.value.resolve(MockBuildContext());

        expect(behavior.applyHeightToFirstAscent, false);
        expect(behavior.applyHeightToLastDescent, true); // Default
        expect(
          behavior.leadingDistribution,
          TextLeadingDistribution.proportional,
        ); // Default
      });
    });

    group('individual utility methods', () {
      test('heightToFirstAscent utility works independently', () {
        final result = util.heightToFirstAscent(false);

        final behavior = result.value.resolve(MockBuildContext());

        expect(behavior.applyHeightToFirstAscent, false);
        expect(behavior.applyHeightToLastDescent, true); // Default
        expect(
          behavior.leadingDistribution,
          TextLeadingDistribution.proportional,
        ); // Default
      });

      test('heightToLastDescent utility works independently', () {
        final result = util.heightToLastDescent(false);

        final behavior = result.value.resolve(MockBuildContext());

        expect(behavior.applyHeightToFirstAscent, true); // Default
        expect(behavior.applyHeightToLastDescent, false);
        expect(
          behavior.leadingDistribution,
          TextLeadingDistribution.proportional,
        ); // Default
      });

      test('leadingDistribution utility works independently', () {
        final result = util.leadingDistribution(TextLeadingDistribution.even);

        final behavior = result.value.resolve(MockBuildContext());

        expect(behavior.applyHeightToFirstAscent, true); // Default
        expect(behavior.applyHeightToLastDescent, true); // Default
        expect(behavior.leadingDistribution, TextLeadingDistribution.even);
      });
    });

    group('edge cases and validation', () {
      test('handles creating from existing TextHeightBehavior', () {
        const originalBehavior = TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );

        final result = util.as(originalBehavior);
        final resolved = result.value.resolve(MockBuildContext());

        expect(resolved, originalBehavior);
      });

      test(
        'ensures consistency between utility properties and only method',
        () {
          final utilityResult = util.heightToFirstAscent(false);
          final onlyResult = util(applyHeightToFirstAscent: false);

          final utilityBehavior = utilityResult.value.resolve(
            MockBuildContext(),
          );
          final onlyBehavior = onlyResult.value.resolve(MockBuildContext());

          expect(
            utilityBehavior.applyHeightToFirstAscent,
            onlyBehavior.applyHeightToFirstAscent,
          );
        },
      );

      test('maintains immutability after operations', () {
        final original = TextHeightBehaviorMix(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.proportional,
        );

        final modified = original.applyHeightToFirstAscent(false);

        // Original should remain unchanged
        expect(
          original.resolve(MockBuildContext()).applyHeightToFirstAscent,
          true,
        );
        // Modified should have the new value
        expect(
          modified.resolve(MockBuildContext()).applyHeightToFirstAscent,
          false,
        );
      });
    });
  });

  group('TextHeightBehavior integration tests', () {
    test('utility works with Mix context', () {
      final util = TextHeightBehaviorUtility<MockStyle<TextHeightBehaviorMix>>(
        (mix) => MockStyle(mix),
      );

      final result = util(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: true,
        leadingDistribution: TextLeadingDistribution.even,
      );

      expect(result.value, isA<TextHeightBehaviorMix>());

      final resolved = result.value.resolve(MockBuildContext());
      expect(resolved, isA<TextHeightBehavior>());
      expect(resolved.applyHeightToFirstAscent, false);
      expect(resolved.applyHeightToLastDescent, true);
      expect(resolved.leadingDistribution, TextLeadingDistribution.even);
    });

    test('utility properties work independently and can be combined', () {
      final util = TextHeightBehaviorUtility<MockStyle<TextHeightBehaviorMix>>(
        (mix) => MockStyle(mix),
      );

      final heightFirstResult = util.heightToFirstAscent(false);
      final heightLastResult = util.heightToLastDescent(false);
      final distributionResult = util.leadingDistribution(
        TextLeadingDistribution.even,
      );

      // Individual properties work
      expect(
        heightFirstResult.value
            .resolve(MockBuildContext())
            .applyHeightToFirstAscent,
        false,
      );
      expect(
        heightLastResult.value
            .resolve(MockBuildContext())
            .applyHeightToLastDescent,
        false,
      );
      expect(
        distributionResult.value
            .resolve(MockBuildContext())
            .leadingDistribution,
        TextLeadingDistribution.even,
      );

      // Properties can be combined through merging
      final combined = heightFirstResult.value
          .merge(heightLastResult.value)
          .merge(distributionResult.value);

      final combinedResolved = combined.resolve(MockBuildContext());
      expect(combinedResolved.applyHeightToFirstAscent, false);
      expect(combinedResolved.applyHeightToLastDescent, false);
      expect(
        combinedResolved.leadingDistribution,
        TextLeadingDistribution.even,
      );
    });

    test('preserves Flutter TextHeightBehavior semantics', () {
      final util = TextHeightBehaviorUtility<MockStyle<TextHeightBehaviorMix>>(
        (mix) => MockStyle(mix),
      );

      // Test that our Mix version produces equivalent results to Flutter's TextHeightBehavior
      const flutterBehavior = TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: true,
        leadingDistribution: TextLeadingDistribution.even,
      );

      final mixResult = util.as(flutterBehavior);
      final mixResolved = mixResult.value.resolve(MockBuildContext());

      expect(
        mixResolved.applyHeightToFirstAscent,
        flutterBehavior.applyHeightToFirstAscent,
      );
      expect(
        mixResolved.applyHeightToLastDescent,
        flutterBehavior.applyHeightToLastDescent,
      );
      expect(
        mixResolved.leadingDistribution,
        flutterBehavior.leadingDistribution,
      );
    });
  });
}
