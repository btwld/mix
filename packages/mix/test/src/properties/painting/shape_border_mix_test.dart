import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('RoundedRectangleBorderMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final roundedRectangleBorderMix = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix(topLeft: const Radius.circular(8.0)),
          side: BorderSideMix(color: Colors.red, width: 2.0),
        );

        expect(
          roundedRectangleBorderMix.$borderRadius,
          isA<MixProp<BorderRadiusGeometry>>(),
        );
        expect(roundedRectangleBorderMix.$side, isA<MixProp<BorderSide>>());
      });

      test(
        'value constructor extracts properties from RoundedRectangleBorder',
        () {
          final roundedRectangleBorder = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(color: Colors.blue, width: 1.0),
          );

          final roundedRectangleBorderMix = RoundedRectangleBorderMix.value(
            roundedRectangleBorder,
          );

          expect(
            roundedRectangleBorderMix.$borderRadius,
            isA<MixProp<BorderRadiusGeometry>>(),
          );
          expect(roundedRectangleBorderMix.$side, isA<MixProp<BorderSide>>());
        },
      );

      test('maybeValue returns null for null input', () {
        final result = RoundedRectangleBorderMix.maybeValue(null);
        expect(result, isNull);
      });

      test(
        'maybeValue returns RoundedRectangleBorderMix for non-null input',
        () {
          const roundedRectangleBorder = RoundedRectangleBorder();
          final result = RoundedRectangleBorderMix.maybeValue(
            roundedRectangleBorder,
          );

          expect(result, isNotNull);
        },
      );
    });

    group('resolve', () {
      test('resolves to RoundedRectangleBorder with correct properties', () {
        final roundedRectangleBorderMix = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix(topLeft: const Radius.circular(8.0)),
          side: BorderSideMix(color: Colors.red, width: 2.0),
        );

        const expectedBorder = RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0)),
          side: BorderSide(color: Colors.red, width: 2.0),
        );

        expect(roundedRectangleBorderMix, resolvesTo(expectedBorder));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final roundedRectangleBorderMix = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix(topLeft: const Radius.circular(8.0)),
        );
        final merged = roundedRectangleBorderMix.merge(null);

        expect(merged, same(roundedRectangleBorderMix));
      });

      test('merges properties correctly', () {
        final first = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix(topLeft: const Radius.circular(8.0)),
        );

        final second = RoundedRectangleBorderMix(
          side: BorderSideMix(color: Colors.red, width: 2.0),
        );

        final merged = first.merge(second);

        expect(merged.$borderRadius, isA<MixProp<BorderRadiusGeometry>>());
        expect(merged.$side, isA<MixProp<BorderSide>>());
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final borderRadius = BorderRadiusMix(
          topLeft: const Radius.circular(8.0),
        );
        final roundedRectangleBorderMix1 = RoundedRectangleBorderMix(
          borderRadius: borderRadius,
        );

        final roundedRectangleBorderMix2 = RoundedRectangleBorderMix(
          borderRadius: borderRadius,
        );

        expect(roundedRectangleBorderMix1, roundedRectangleBorderMix2);
        expect(
          roundedRectangleBorderMix1.hashCode,
          roundedRectangleBorderMix2.hashCode,
        );
      });

      test('returns false when properties are different', () {
        final roundedRectangleBorderMix1 = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix(topLeft: const Radius.circular(8.0)),
        );
        final roundedRectangleBorderMix2 = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix(topLeft: const Radius.circular(12.0)),
        );

        expect(roundedRectangleBorderMix1, isNot(roundedRectangleBorderMix2));
      });
    });
  });

  group('CircleBorderMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final circleBorderMix = CircleBorderMix(
          side: BorderSideMix(color: Colors.green, width: 3.0),
        );

        expect(circleBorderMix.$side, isA<MixProp<BorderSide>>());
      });

      test('value constructor extracts properties from CircleBorder', () {
        const circleBorder = CircleBorder(
          side: BorderSide(color: Colors.purple, width: 1.5),
        );

        final circleBorderMix = CircleBorderMix.value(circleBorder);

        expect(circleBorderMix.$side, isA<MixProp<BorderSide>>());
      });

      test('maybeValue returns null for null input', () {
        final result = CircleBorderMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns CircleBorderMix for non-null input', () {
        const circleBorder = CircleBorder();
        final result = CircleBorderMix.maybeValue(circleBorder);

        expect(result, isNotNull);
      });
    });

    group('resolve', () {
      test('resolves to CircleBorder with correct properties', () {
        final circleBorderMix = CircleBorderMix(
          side: BorderSideMix(color: Colors.green, width: 3.0),
        );

        const expectedBorder = CircleBorder(
          side: BorderSide(color: Colors.green, width: 3.0),
        );

        expect(circleBorderMix, resolvesTo(expectedBorder));
      });
    });

    group('merge', () {
      test('merges properties correctly', () {
        final first = CircleBorderMix(
          side: BorderSideMix(color: Colors.green, width: 3.0),
        );

        final second = CircleBorderMix(
          side: BorderSideMix(color: Colors.blue, width: 2.0),
        );

        final merged = first.merge(second);

        expect(merged.$side, isA<MixProp<BorderSide>>());
      });
    });
  });

  group('StadiumBorderMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final stadiumBorderMix = StadiumBorderMix(
          side: BorderSideMix(color: Colors.orange, width: 2.5),
        );

        expect(stadiumBorderMix.$side, isA<MixProp<BorderSide>>());
      });

      test('value constructor extracts properties from StadiumBorder', () {
        const stadiumBorder = StadiumBorder(
          side: BorderSide(color: Colors.cyan, width: 1.0),
        );

        final stadiumBorderMix = StadiumBorderMix.value(stadiumBorder);

        expect(stadiumBorderMix.$side, isA<MixProp<BorderSide>>());
      });

      test('maybeValue returns null for null input', () {
        final result = StadiumBorderMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns StadiumBorderMix for non-null input', () {
        const stadiumBorder = StadiumBorder();
        final result = StadiumBorderMix.maybeValue(stadiumBorder);

        expect(result, isNotNull);
      });
    });

    group('resolve', () {
      test('resolves to StadiumBorder with correct properties', () {
        final stadiumBorderMix = StadiumBorderMix(
          side: BorderSideMix(color: Colors.orange, width: 2.5),
        );

        const expectedBorder = StadiumBorder(
          side: BorderSide(color: Colors.orange, width: 2.5),
        );

        expect(stadiumBorderMix, resolvesTo(expectedBorder));
      });
    });

    group('merge', () {
      test('merges properties correctly', () {
        final first = StadiumBorderMix(
          side: BorderSideMix(color: Colors.orange, width: 2.5),
        );

        final second = StadiumBorderMix(
          side: BorderSideMix(color: Colors.pink, width: 1.5),
        );

        final merged = first.merge(second);

        expect(merged.$side, isA<MixProp<BorderSide>>());
      });
    });
  });

  group('BeveledRectangleBorderMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final beveledRectangleBorderMix = BeveledRectangleBorderMix(
          borderRadius: BorderRadiusMix(topLeft: const Radius.circular(6.0)),
          side: BorderSideMix(color: Colors.yellow, width: 1.5),
        );

        expect(
          beveledRectangleBorderMix.$borderRadius,
          isA<MixProp<BorderRadiusGeometry>>(),
        );
        expect(beveledRectangleBorderMix.$side, isA<MixProp<BorderSide>>());
      });

      test(
        'value constructor extracts properties from BeveledRectangleBorder',
        () {
          final beveledRectangleBorder = BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.teal, width: 2.0),
          );

          final beveledRectangleBorderMix = BeveledRectangleBorderMix.value(
            beveledRectangleBorder,
          );

          expect(
            beveledRectangleBorderMix.$borderRadius,
            isA<MixProp<BorderRadiusGeometry>>(),
          );
          expect(beveledRectangleBorderMix.$side, isA<MixProp<BorderSide>>());
        },
      );

      test('maybeValue returns null for null input', () {
        final result = BeveledRectangleBorderMix.maybeValue(null);
        expect(result, isNull);
      });

      test(
        'maybeValue returns BeveledRectangleBorderMix for non-null input',
        () {
          const beveledRectangleBorder = BeveledRectangleBorder();
          final result = BeveledRectangleBorderMix.maybeValue(
            beveledRectangleBorder,
          );

          expect(result, isNotNull);
        },
      );
    });

    group('resolve', () {
      test('resolves to BeveledRectangleBorder with correct properties', () {
        final beveledRectangleBorderMix = BeveledRectangleBorderMix(
          borderRadius: BorderRadiusMix(topLeft: const Radius.circular(6.0)),
          side: BorderSideMix(color: Colors.yellow, width: 1.5),
        );

        final resolved = beveledRectangleBorderMix.resolve(MockBuildContext());
        expect(resolved, isA<BeveledRectangleBorder>());
        expect(resolved.borderRadius, isA<BorderRadius>());
        expect(resolved.side.color, Colors.yellow);
        expect(resolved.side.width, 1.5);
      });
    });

    group('merge', () {
      test('merges properties correctly', () {
        final first = BeveledRectangleBorderMix(
          borderRadius: BorderRadiusMix(topLeft: const Radius.circular(6.0)),
        );

        final second = BeveledRectangleBorderMix(
          side: BorderSideMix(color: Colors.yellow, width: 1.5),
        );

        final merged = first.merge(second);

        expect(merged.$borderRadius, isA<MixProp<BorderRadiusGeometry>>());
        expect(merged.$side, isA<MixProp<BorderSide>>());
      });
    });
  });

  // Note: Cross-type merging is not supported for ShapeBorderMix.
  // Different shape border types cannot be merged directly.
  // Cross-type merging should be handled at a higher level through MixProp accumulation.
  /*
  group('Cross-Type Rectangle Variant Merging', () {
    group('RoundedRectangleBorderMix with other rectangle variants', () {
      test('merges with BeveledRectangleBorderMix preserving properties', () {
        final rounded = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix(topLeft: const Radius.circular(8.0)),
          side: BorderSideMix(color: Colors.red, width: 2.0),
        );
        final beveled = BeveledRectangleBorderMix(
          borderRadius: BorderRadiusMix(topRight: const Radius.circular(12.0)),
        );

        final merged = rounded.merge(beveled);

        expect(merged, isA<BeveledRectangleBorderMix>());
        final beveledResult = merged as BeveledRectangleBorderMix;

        // Second's borderRadius should take precedence
        final resolvedRadius =
            beveledResult.$borderRadius?.value as BorderRadiusMix;
        expect(
          resolvedRadius,
          equals(BorderRadiusMix(topRight: const Radius.circular(12.0))),
        );

        // First's side should be preserved since second doesn't have one
        expect(beveledResult.$side?.value, isA<BorderSideMix>());
        final resolvedSide = beveledResult.$side?.value as BorderSideMix;
        expect(resolvedSide.color, Colors.red);
        expect(resolvedSide.width, 2.0);
      });

      test('merges with ContinuousRectangleBorderMix using target type', () {
        final rounded = RoundedRectangleBorderMix(
          side: BorderSideMix(color: Colors.blue, width: 1.0),
        );
        final continuous = ContinuousRectangleBorderMix(
          borderRadius: BorderRadiusMix(bottomLeft: const Radius.circular(6.0)),
          side: BorderSideMix(color: Colors.green, width: 3.0),
        );

        final merged = rounded.merge(continuous);

        expect(merged, isA<ContinuousRectangleBorderMix>());
        final continuousResult = merged as ContinuousRectangleBorderMix;

        // Second's properties should take precedence
        final resolvedRadius =
            continuousResult.$borderRadius?.value as BorderRadiusMix;
        expect(
          resolvedRadius,
          equals(BorderRadiusMix(bottomLeft: const Radius.circular(6.0))),
        );

        final resolvedSide = continuousResult.$side?.value as BorderSideMix;
        expect(resolvedSide.color, Colors.green);
        expect(resolvedSide.width, 3.0);
      });

      test(
        'merges with RoundedSuperellipseBorderMix preserving first properties when second is null',
        () {
          final rounded = RoundedRectangleBorderMix(
            borderRadius: BorderRadiusMix(topLeft: const Radius.circular(10.0)),
            side: BorderSideMix(color: Colors.orange, width: 2.5),
          );
          final superellipse = RoundedSuperellipseBorderMix(
            // Only side, no borderRadius
            side: BorderSideMix(color: Colors.purple, width: 1.5),
          );

          final merged = rounded.merge(superellipse);

          expect(merged, isA<RoundedSuperellipseBorderMix>());
          final superellipseResult = merged as RoundedSuperellipseBorderMix;

          // First's borderRadius should be preserved since second doesn't have one
          final resolvedRadius =
              superellipseResult.$borderRadius?.value as BorderRadiusMix;
          expect(
            resolvedRadius,
            equals(BorderRadiusMix(topLeft: const Radius.circular(10.0))),
          );

          // Second's side should take precedence
          final resolvedSide = superellipseResult.$side?.value as BorderSideMix;
          expect(resolvedSide.color, Colors.purple);
          expect(resolvedSide.width, 1.5);
        },
      );
    });

    group('BeveledRectangleBorderMix with other rectangle variants', () {
      test('merges with ContinuousRectangleBorderMix', () {
        final beveled = BeveledRectangleBorderMix(
          borderRadius: BorderRadiusMix.circular(5.0),
        );
        final continuous = ContinuousRectangleBorderMix(
          side: BorderSideMix(color: Colors.cyan, width: 2.0),
        );

        final merged = beveled.merge(continuous);

        expect(merged, isA<ContinuousRectangleBorderMix>());
        final continuousResult = merged as ContinuousRectangleBorderMix;

        // First's borderRadius should be preserved
        final resolvedRadius =
            continuousResult.$borderRadius?.value as BorderRadiusMix;
        expect(resolvedRadius, equals(BorderRadiusMix.circular(5.0)));

        // Second's side should be used
        final resolvedSide = continuousResult.$side?.value as BorderSideMix;
        expect(resolvedSide.color, Colors.cyan);
        expect(resolvedSide.width, 2.0);
      });
    });

    group('Non-rectangle variants should use override behavior', () {
      test('RoundedRectangleBorderMix with CircleBorderMix overrides', () {
        final rounded = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix.circular(8.0),
          side: BorderSideMix(color: Colors.red, width: 2.0),
        );
        final circle = CircleBorderMix(
          side: BorderSideMix(color: Colors.blue, width: 3.0),
        );

        final merged = rounded.merge(circle);

        // Should simply override with circle
        expect(merged, same(circle));
      });

      test('CircleBorderMix with RoundedRectangleBorderMix overrides', () {
        final circle = CircleBorderMix(
          side: BorderSideMix(color: Colors.green, width: 1.0),
        );
        final rounded = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix.circular(10.0),
        );

        final merged = circle.merge(rounded);

        // Should simply override with rounded
        expect(merged, same(rounded));
      });

      test('StadiumBorderMix with BeveledRectangleBorderMix overrides', () {
        final stadium = StadiumBorderMix(
          side: BorderSideMix(color: Colors.yellow, width: 2.0),
        );
        final beveled = BeveledRectangleBorderMix(
          borderRadius: BorderRadiusMix.circular(6.0),
        );

        final merged = stadium.merge(beveled);

        // Should simply override with beveled
        expect(merged, same(beveled));
      });
    });

    group('Property preservation edge cases', () {
      test('handles null properties correctly in rectangle variants', () {
        final rounded = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix.circular(5.0),
          // No side
        );
        final beveled = BeveledRectangleBorderMix(
          // No borderRadius
          side: BorderSideMix(color: Colors.teal, width: 1.0),
        );

        final merged = rounded.merge(beveled);

        expect(merged, isA<BeveledRectangleBorderMix>());
        final beveledResult = merged as BeveledRectangleBorderMix;

        // First's borderRadius should be preserved
        final resolvedRadius =
            beveledResult.$borderRadius?.value as BorderRadiusMix;
        expect(resolvedRadius, equals(BorderRadiusMix.circular(5.0)));

        // Second's side should be used
        final resolvedSide = beveledResult.$side?.value as BorderSideMix;
        expect(resolvedSide.color, Colors.teal);
        expect(resolvedSide.width, 1.0);
      });

      test('handles both properties null correctly', () {
        final rounded = RoundedRectangleBorderMix();
        final continuous = ContinuousRectangleBorderMix();

        final merged = rounded.merge(continuous);

        expect(merged, isA<ContinuousRectangleBorderMix>());
        final continuousResult = merged as ContinuousRectangleBorderMix;

        // Both should be null
        expect(continuousResult.$borderRadius, isNull);
        expect(continuousResult.$side, isNull);
      });

      test('preserves complex borderRadius values', () {
        final complexRadius = BorderRadiusMix(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(12.0),
          bottomLeft: const Radius.circular(6.0),
          bottomRight: const Radius.circular(10.0),
        );

        final rounded = RoundedRectangleBorderMix(borderRadius: complexRadius);
        final beveled = BeveledRectangleBorderMix(
          side: BorderSideMix(color: Colors.indigo, width: 2.5),
        );

        final merged = rounded.merge(beveled);

        expect(merged, isA<BeveledRectangleBorderMix>());
        final beveledResult = merged as BeveledRectangleBorderMix;

        // Complex borderRadius should be preserved exactly
        final resolvedRadius =
            beveledResult.$borderRadius?.value as BorderRadiusMix;
        expect(resolvedRadius, equals(complexRadius));
      });
    });

    // Note: Cross-type merging is not supported for ShapeBorderMix.
    // Different shape border types cannot be merged directly.
    // Cross-type merging should be handled at a higher level through MixProp accumulation.
  */
}
