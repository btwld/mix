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

        final merged = first.merge(second) as RoundedRectangleBorderMix;

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

        final merged = first.merge(second) as CircleBorderMix;

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

        final merged = first.merge(second) as StadiumBorderMix;

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

        final merged = first.merge(second) as BeveledRectangleBorderMix;

        expect(merged.$borderRadius, isA<MixProp<BorderRadiusGeometry>>());
        expect(merged.$side, isA<MixProp<BorderSide>>());
      });
    });
  });
}
