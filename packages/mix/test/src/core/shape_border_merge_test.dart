import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/shape_border_merge.dart';
import 'package:mix/src/properties/painting/border_mix.dart';
import 'package:mix/src/properties/painting/border_radius_mix.dart';
import 'package:mix/src/properties/painting/shape_border_mix.dart';

void main() {
  group('ShapeBorderMerger', () {
    group('tryMerge', () {
      test('returns null when both shape borders are null', () {
        final result = ShapeBorderMerger.tryMerge(null, null);
        expect(result, isNull);
      });

      test('returns first shape border when second is null', () {
        final rounded = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix.circular(8.0),
        );
        final result = ShapeBorderMerger.tryMerge(rounded, null);
        expect(result, equals(rounded));
      });

      test('returns second shape border when first is null', () {
        final beveled = BeveledRectangleBorderMix(
          borderRadius: BorderRadiusMix.circular(12.0),
        );
        final result = ShapeBorderMerger.tryMerge(null, beveled);
        expect(result, equals(beveled));
      });

      test('merges same type shape borders using standard merge', () {
        final rounded1 = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix.circular(8.0),
        );
        final rounded2 = RoundedRectangleBorderMix(
          side: BorderSideMix(color: Colors.red, width: 2.0),
        );

        final result = ShapeBorderMerger.tryMerge(rounded1, rounded2) as RoundedRectangleBorderMix;

        expect(result.runtimeType, equals(RoundedRectangleBorderMix));
        expect(result.$borderRadius?.value, isA<BorderRadiusMix>());
        expect(result.$side?.value, isA<BorderSideMix>());
      });
    });

    group('Rectangle Variant Intelligent Merging', () {
      group('RoundedRectangleBorderMix with other rectangle variants', () {
        test('merges with BeveledRectangleBorderMix preserving properties', () {
          final rounded = RoundedRectangleBorderMix(
            borderRadius: BorderRadiusMix(topLeft: const Radius.circular(8.0)),
            side: BorderSideMix(color: Colors.red, width: 2.0),
          );
          final beveled = BeveledRectangleBorderMix(
            borderRadius: BorderRadiusMix(topRight: const Radius.circular(12.0)),
          );

          final result = ShapeBorderMerger.tryMerge(rounded, beveled);

          expect(result, isA<BeveledRectangleBorderMix>());
          final beveledResult = result as BeveledRectangleBorderMix;
          
          // Second's borderRadius should take precedence
          final resolvedRadius = beveledResult.$borderRadius?.value as BorderRadiusMix;
          expect(resolvedRadius, equals(BorderRadiusMix(topRight: const Radius.circular(12.0))));
          
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

          final result = ShapeBorderMerger.tryMerge(rounded, continuous);

          expect(result, isA<ContinuousRectangleBorderMix>());
          final continuousResult = result as ContinuousRectangleBorderMix;
          
          // Second's properties should take precedence
          final resolvedRadius = continuousResult.$borderRadius?.value as BorderRadiusMix;
          expect(resolvedRadius, equals(BorderRadiusMix(bottomLeft: const Radius.circular(6.0))));
          
          final resolvedSide = continuousResult.$side?.value as BorderSideMix;
          expect(resolvedSide.color, Colors.green);
          expect(resolvedSide.width, 3.0);
        });

        test('merges with RoundedSuperellipseBorderMix preserving first properties when second is null', () {
          final rounded = RoundedRectangleBorderMix(
            borderRadius: BorderRadiusMix(topLeft: const Radius.circular(10.0)),
            side: BorderSideMix(color: Colors.orange, width: 2.5),
          );
          final superellipse = RoundedSuperellipseBorderMix(
            side: BorderSideMix(color: Colors.purple, width: 1.5),
          );

          final result = ShapeBorderMerger.tryMerge(rounded, superellipse);

          expect(result, isA<RoundedSuperellipseBorderMix>());
          final superellipseResult = result as RoundedSuperellipseBorderMix;
          
          // First's borderRadius should be preserved since second doesn't have one
          final resolvedRadius = superellipseResult.$borderRadius?.value as BorderRadiusMix;
          expect(resolvedRadius, equals(BorderRadiusMix(topLeft: const Radius.circular(10.0))));
          
          // Second's side should take precedence
          final resolvedSide = superellipseResult.$side?.value as BorderSideMix;
          expect(resolvedSide.color, Colors.purple);
          expect(resolvedSide.width, 1.5);
        });
      });

      group('BeveledRectangleBorderMix with other rectangle variants', () {
        test('merges with ContinuousRectangleBorderMix', () {
          final beveled = BeveledRectangleBorderMix(
            borderRadius: BorderRadiusMix.circular(5.0),
          );
          final continuous = ContinuousRectangleBorderMix(
            side: BorderSideMix(color: Colors.cyan, width: 2.0),
          );

          final result = ShapeBorderMerger.tryMerge(beveled, continuous);

          expect(result, isA<ContinuousRectangleBorderMix>());
          final continuousResult = result as ContinuousRectangleBorderMix;
          
          // First's borderRadius should be preserved
          final resolvedRadius = continuousResult.$borderRadius?.value as BorderRadiusMix;
          expect(resolvedRadius, equals(BorderRadiusMix.circular(5.0)));
          
          // Second's side should be used
          final resolvedSide = continuousResult.$side?.value as BorderSideMix;
          expect(resolvedSide.color, Colors.cyan);
          expect(resolvedSide.width, 2.0);
        });
      });

      group('Property preservation edge cases', () {
        test('handles null properties correctly in rectangle variants', () {
          final rounded = RoundedRectangleBorderMix(
            borderRadius: BorderRadiusMix.circular(5.0),
          );
          final beveled = BeveledRectangleBorderMix(
            side: BorderSideMix(color: Colors.teal, width: 1.0),
          );

          final result = ShapeBorderMerger.tryMerge(rounded, beveled);

          expect(result, isA<BeveledRectangleBorderMix>());
          final beveledResult = result as BeveledRectangleBorderMix;
          
          // First's borderRadius should be preserved
          final resolvedRadius = beveledResult.$borderRadius?.value as BorderRadiusMix;
          expect(resolvedRadius, equals(BorderRadiusMix.circular(5.0)));
          
          // Second's side should be used
          final resolvedSide = beveledResult.$side?.value as BorderSideMix;
          expect(resolvedSide.color, Colors.teal);
          expect(resolvedSide.width, 1.0);
        });

        test('handles both properties null correctly', () {
          final rounded = RoundedRectangleBorderMix();
          final continuous = ContinuousRectangleBorderMix();

          final result = ShapeBorderMerger.tryMerge(rounded, continuous);

          expect(result, isA<ContinuousRectangleBorderMix>());
          final continuousResult = result as ContinuousRectangleBorderMix;
          
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
          
          final rounded = RoundedRectangleBorderMix(
            borderRadius: complexRadius,
          );
          final beveled = BeveledRectangleBorderMix(
            side: BorderSideMix(color: Colors.indigo, width: 2.5),
          );

          final result = ShapeBorderMerger.tryMerge(rounded, beveled);

          expect(result, isA<BeveledRectangleBorderMix>());
          final beveledResult = result as BeveledRectangleBorderMix;
          
          // Complex borderRadius should be preserved exactly
          final resolvedRadius = beveledResult.$borderRadius?.value as BorderRadiusMix;
          expect(resolvedRadius, equals(complexRadius));
        });
      });

      group('All rectangle variant combinations', () {
        final testCases = [
          ('RoundedRectangleBorderMix', () => RoundedRectangleBorderMix(borderRadius: BorderRadiusMix.circular(5.0))),
          ('BeveledRectangleBorderMix', () => BeveledRectangleBorderMix(side: BorderSideMix(color: Colors.red, width: 1.0))),
          ('ContinuousRectangleBorderMix', () => ContinuousRectangleBorderMix(borderRadius: BorderRadiusMix.circular(3.0))),
          ('RoundedSuperellipseBorderMix', () => RoundedSuperellipseBorderMix(side: BorderSideMix(color: Colors.blue, width: 2.0))),
        ];

        for (final (firstName, firstFactory) in testCases) {
          for (final (secondName, secondFactory) in testCases) {
            if (firstName != secondName) {
              test('$firstName merges with $secondName using target type', () {
                final first = firstFactory();
                final second = secondFactory();

                final result = ShapeBorderMerger.tryMerge(first, second);

                // Result should be of second's type
                expect(result!.runtimeType, equals(second.runtimeType));
                
                // Should not be the same instance (actual merging occurred)
                expect(result, isNot(same(second)));
              });
            }
          }
        }
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

        final result = ShapeBorderMerger.tryMerge(rounded, circle);

        // Should simply override with circle
        expect(result, same(circle));
      });

      test('CircleBorderMix with RoundedRectangleBorderMix overrides', () {
        final circle = CircleBorderMix(
          side: BorderSideMix(color: Colors.green, width: 1.0),
        );
        final rounded = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix.circular(10.0),
        );

        final result = ShapeBorderMerger.tryMerge(circle, rounded);

        // Should simply override with rounded
        expect(result, same(rounded));
      });

      test('StadiumBorderMix with BeveledRectangleBorderMix overrides', () {
        final stadium = StadiumBorderMix(
          side: BorderSideMix(color: Colors.yellow, width: 2.0),
        );
        final beveled = BeveledRectangleBorderMix(
          borderRadius: BorderRadiusMix.circular(6.0),
        );

        final result = ShapeBorderMerger.tryMerge(stadium, beveled);

        // Should simply override with beveled
        expect(result, same(beveled));
      });
    });

    group('canMerge', () {
      test('returns true when either shape border is null', () {
        final rounded = RoundedRectangleBorderMix(borderRadius: BorderRadiusMix.circular(8.0));
        expect(ShapeBorderMerger.canMerge(null, rounded), isTrue);
        expect(ShapeBorderMerger.canMerge(rounded, null), isTrue);
        expect(ShapeBorderMerger.canMerge(null, null), isTrue);
      });

      test('returns true for same type shape borders', () {
        final rounded1 = RoundedRectangleBorderMix(borderRadius: BorderRadiusMix.circular(8.0));
        final rounded2 = RoundedRectangleBorderMix(side: BorderSideMix(color: Colors.red, width: 2.0));
        expect(ShapeBorderMerger.canMerge(rounded1, rounded2), isTrue);

        final circle1 = CircleBorderMix(side: BorderSideMix(color: Colors.blue, width: 1.0));
        final circle2 = CircleBorderMix(eccentricity: 0.5);
        expect(ShapeBorderMerger.canMerge(circle1, circle2), isTrue);
      });

      test('returns true for rectangle variant combinations', () {
        final rounded = RoundedRectangleBorderMix(borderRadius: BorderRadiusMix.circular(8.0));
        final beveled = BeveledRectangleBorderMix(side: BorderSideMix(color: Colors.red, width: 2.0));
        expect(ShapeBorderMerger.canMerge(rounded, beveled), isTrue);

        final continuous = ContinuousRectangleBorderMix(borderRadius: BorderRadiusMix.circular(4.0));
        final superellipse = RoundedSuperellipseBorderMix(side: BorderSideMix(color: Colors.green, width: 1.0));
        expect(ShapeBorderMerger.canMerge(continuous, superellipse), isTrue);
      });

      test('returns true for non-rectangle variant combinations (override behavior)', () {
        final rounded = RoundedRectangleBorderMix(borderRadius: BorderRadiusMix.circular(8.0));
        final circle = CircleBorderMix(side: BorderSideMix(color: Colors.blue, width: 2.0));
        expect(ShapeBorderMerger.canMerge(rounded, circle), isTrue);

        final stadium = StadiumBorderMix(side: BorderSideMix(color: Colors.yellow, width: 1.0));
        final star = StarBorderMix(points: 6.0);
        expect(ShapeBorderMerger.canMerge(stadium, star), isTrue);
      });
    });

    group('Edge Cases', () {
      test('handles empty shape borders', () {
        final emptyRounded = RoundedRectangleBorderMix();
        final emptyBeveled = BeveledRectangleBorderMix();

        final result = ShapeBorderMerger.tryMerge(emptyRounded, emptyBeveled);
        expect(result!.runtimeType, equals(BeveledRectangleBorderMix));
      });

      test('handles shape borders with only one property each', () {
        final roundedWithRadius = RoundedRectangleBorderMix(
          borderRadius: BorderRadiusMix.circular(8.0),
        );
        final beveledWithSide = BeveledRectangleBorderMix(
          side: BorderSideMix(color: Colors.red, width: 2.0),
        );

        final result = ShapeBorderMerger.tryMerge(roundedWithRadius, beveledWithSide);
        expect(result, isA<BeveledRectangleBorderMix>());

        final beveledResult = result as BeveledRectangleBorderMix;
        expect(beveledResult.$borderRadius?.value, isA<BorderRadiusMix>());
        expect(beveledResult.$side?.value, isA<BorderSideMix>());
      });
    });
  });
}