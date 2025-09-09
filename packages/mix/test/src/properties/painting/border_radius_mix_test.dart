import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/properties/painting/border_radius_mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BorderRadiusMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final borderRadiusMix = BorderRadiusMix(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(12.0),
          bottomLeft: const Radius.circular(16.0),
          bottomRight: const Radius.circular(20.0),
        );

        expect(
          borderRadiusMix.$topLeft,
          resolvesTo(const Radius.circular(8.0)),
        );
        expect(
          borderRadiusMix.$topRight,
          resolvesTo(const Radius.circular(12.0)),
        );
        expect(
          borderRadiusMix.$bottomLeft,
          resolvesTo(const Radius.circular(16.0)),
        );
        expect(
          borderRadiusMix.$bottomRight,
          resolvesTo(const Radius.circular(20.0)),
        );
      });

      test('value constructor extracts properties from BorderRadius', () {
        const borderRadius = BorderRadius.only(
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(20.0),
        );

        final borderRadiusMix = BorderRadiusMix.value(borderRadius);

        expect(
          borderRadiusMix.$topLeft,
          resolvesTo(const Radius.circular(5.0)),
        );
        expect(
          borderRadiusMix.$topRight,
          resolvesTo(const Radius.circular(10.0)),
        );
        expect(
          borderRadiusMix.$bottomLeft,
          resolvesTo(const Radius.circular(15.0)),
        );
        expect(
          borderRadiusMix.$bottomRight,
          resolvesTo(const Radius.circular(20.0)),
        );
      });

      test('maybeValue returns null for null input', () {
        final result = BorderRadiusMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns BorderRadiusMix for non-null input', () {
        final borderRadius = BorderRadius.circular(8.0);
        final result = BorderRadiusMix.maybeValue(borderRadius);

        expect(result, isNotNull);
        expect(result!.$topLeft, resolvesTo(const Radius.circular(8.0)));
        expect(result.$topRight, resolvesTo(const Radius.circular(8.0)));
        expect(result.$bottomLeft, resolvesTo(const Radius.circular(8.0)));
        expect(result.$bottomRight, resolvesTo(const Radius.circular(8.0)));
      });
    });

    group('Factory Constructors', () {
      test('circular factory creates BorderRadiusMix with circular radius', () {
        final borderRadiusMix = BorderRadiusMix.circular(10.0);

        expect(
          borderRadiusMix.$topLeft,
          resolvesTo(const Radius.circular(10.0)),
        );
        expect(
          borderRadiusMix.$topRight,
          resolvesTo(const Radius.circular(10.0)),
        );
        expect(
          borderRadiusMix.$bottomLeft,
          resolvesTo(const Radius.circular(10.0)),
        );
        expect(
          borderRadiusMix.$bottomRight,
          resolvesTo(const Radius.circular(10.0)),
        );
      });

      test(
        'elliptical factory creates BorderRadiusMix with elliptical radius',
        () {
          final borderRadiusMix = BorderRadiusMix.elliptical(8.0, 12.0);

          expect(
            borderRadiusMix.$topLeft,
            resolvesTo(const Radius.elliptical(8.0, 12.0)),
          );
          expect(
            borderRadiusMix.$topRight,
            resolvesTo(const Radius.elliptical(8.0, 12.0)),
          );
          expect(
            borderRadiusMix.$bottomLeft,
            resolvesTo(const Radius.elliptical(8.0, 12.0)),
          );
          expect(
            borderRadiusMix.$bottomRight,
            resolvesTo(const Radius.elliptical(8.0, 12.0)),
          );
        },
      );

      test('topLeft factory creates BorderRadiusMix with topLeft radius', () {
        final borderRadiusMix = BorderRadiusMix.topLeft(
          const Radius.circular(5.0),
        );

        expect(
          borderRadiusMix.$topLeft,
          resolvesTo(const Radius.circular(5.0)),
        );
        expect(borderRadiusMix.$topRight, isNull);
        expect(borderRadiusMix.$bottomLeft, isNull);
        expect(borderRadiusMix.$bottomRight, isNull);
      });

      test('topRight factory creates BorderRadiusMix with topRight radius', () {
        final borderRadiusMix = BorderRadiusMix.topRight(
          const Radius.circular(6.0),
        );

        expect(
          borderRadiusMix.$topRight,
          resolvesTo(const Radius.circular(6.0)),
        );
        expect(borderRadiusMix.$topLeft, isNull);
        expect(borderRadiusMix.$bottomLeft, isNull);
        expect(borderRadiusMix.$bottomRight, isNull);
      });

      test(
        'bottomLeft factory creates BorderRadiusMix with bottomLeft radius',
        () {
          final borderRadiusMix = BorderRadiusMix.bottomLeft(
            const Radius.circular(7.0),
          );

          expect(
            borderRadiusMix.$bottomLeft,
            resolvesTo(const Radius.circular(7.0)),
          );
          expect(borderRadiusMix.$topLeft, isNull);
          expect(borderRadiusMix.$topRight, isNull);
          expect(borderRadiusMix.$bottomRight, isNull);
        },
      );

      test(
        'bottomRight factory creates BorderRadiusMix with bottomRight radius',
        () {
          final borderRadiusMix = BorderRadiusMix.bottomRight(
            const Radius.circular(8.0),
          );

          expect(
            borderRadiusMix.$bottomRight,
            resolvesTo(const Radius.circular(8.0)),
          );
          expect(borderRadiusMix.$topLeft, isNull);
          expect(borderRadiusMix.$topRight, isNull);
          expect(borderRadiusMix.$bottomLeft, isNull);
        },
      );

      test(
        'all factory creates BorderRadiusMix with same radius for all corners',
        () {
          final borderRadiusMix = BorderRadiusMix.all(
            const Radius.circular(15.0),
          );

          expect(
            borderRadiusMix.$topLeft,
            resolvesTo(const Radius.circular(15.0)),
          );
          expect(
            borderRadiusMix.$topRight,
            resolvesTo(const Radius.circular(15.0)),
          );
          expect(
            borderRadiusMix.$bottomLeft,
            resolvesTo(const Radius.circular(15.0)),
          );
          expect(
            borderRadiusMix.$bottomRight,
            resolvesTo(const Radius.circular(15.0)),
          );
        },
      );
    });

    group('Utility Methods', () {
      test('topLeft utility works correctly', () {
        final borderRadiusMix = BorderRadiusMix().topLeft(
          const Radius.circular(5.0),
        );

        expect(
          borderRadiusMix.$topLeft,
          resolvesTo(const Radius.circular(5.0)),
        );
      });

      test('topRight utility works correctly', () {
        final borderRadiusMix = BorderRadiusMix().topRight(
          const Radius.circular(6.0),
        );

        expect(
          borderRadiusMix.$topRight,
          resolvesTo(const Radius.circular(6.0)),
        );
      });

      test('bottomLeft utility works correctly', () {
        final borderRadiusMix = BorderRadiusMix().bottomLeft(
          const Radius.circular(7.0),
        );

        expect(
          borderRadiusMix.$bottomLeft,
          resolvesTo(const Radius.circular(7.0)),
        );
      });

      test('bottomRight utility works correctly', () {
        final borderRadiusMix = BorderRadiusMix().bottomRight(
          const Radius.circular(8.0),
        );

        expect(
          borderRadiusMix.$bottomRight,
          resolvesTo(const Radius.circular(8.0)),
        );
      });
    });

    group('resolve', () {
      test('resolves to BorderRadius with correct properties', () {
        final borderRadiusMix = BorderRadiusMix(
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
        final borderRadiusMix = BorderRadiusMix(
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
        final borderRadiusMix = BorderRadiusMix(
          topLeft: const Radius.circular(8.0),
        );
        final merged = borderRadiusMix.merge(null);

        expect(merged, same(borderRadiusMix));
      });

      test('merges properties correctly', () {
        final first = BorderRadiusMix(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(12.0),
        );

        final second = BorderRadiusMix(
          topRight: const Radius.circular(16.0),
          bottomLeft: const Radius.circular(20.0),
        );

        final merged = first.merge(second);

        expect(merged.$topLeft, resolvesTo(const Radius.circular(8.0)));
        expect(merged.$topRight, resolvesTo(const Radius.circular(16.0)));
        expect(merged.$bottomLeft, resolvesTo(const Radius.circular(20.0)));
        expect(merged.$bottomRight, isNull);
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final borderRadiusMix1 = BorderRadiusMix(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(12.0),
        );

        final borderRadiusMix2 = BorderRadiusMix(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(12.0),
        );

        expect(borderRadiusMix1, borderRadiusMix2);
        expect(borderRadiusMix1.hashCode, borderRadiusMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final borderRadiusMix1 = BorderRadiusMix(
          topLeft: const Radius.circular(8.0),
        );
        final borderRadiusMix2 = BorderRadiusMix(
          topLeft: const Radius.circular(12.0),
        );

        expect(borderRadiusMix1, isNot(borderRadiusMix2));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final borderRadiusMix = BorderRadiusMix(
          topLeft: const Radius.circular(5.0),
          topRight: const Radius.circular(10.0),
          bottomLeft: const Radius.circular(15.0),
          bottomRight: const Radius.circular(20.0),
        );

        expect(borderRadiusMix.props.length, 4);
        expect(borderRadiusMix.props, contains(borderRadiusMix.$topLeft));
        expect(borderRadiusMix.props, contains(borderRadiusMix.$topRight));
        expect(borderRadiusMix.props, contains(borderRadiusMix.$bottomLeft));
        expect(borderRadiusMix.props, contains(borderRadiusMix.$bottomRight));
      });
    });
  });

  group('BorderRadiusDirectionalMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final borderRadiusDirectionalMix = BorderRadiusDirectionalMix(
          topStart: const Radius.circular(8.0),
          topEnd: const Radius.circular(12.0),
          bottomStart: const Radius.circular(16.0),
          bottomEnd: const Radius.circular(20.0),
        );

        expect(
          borderRadiusDirectionalMix.$topStart,
          resolvesTo(const Radius.circular(8.0)),
        );
        expect(
          borderRadiusDirectionalMix.$topEnd,
          resolvesTo(const Radius.circular(12.0)),
        );
        expect(
          borderRadiusDirectionalMix.$bottomStart,
          resolvesTo(const Radius.circular(16.0)),
        );
        expect(
          borderRadiusDirectionalMix.$bottomEnd,
          resolvesTo(const Radius.circular(20.0)),
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

          expect(
            borderRadiusDirectionalMix.$topStart,
            resolvesTo(const Radius.circular(5.0)),
          );
          expect(
            borderRadiusDirectionalMix.$topEnd,
            resolvesTo(const Radius.circular(10.0)),
          );
          expect(
            borderRadiusDirectionalMix.$bottomStart,
            resolvesTo(const Radius.circular(15.0)),
          );
          expect(
            borderRadiusDirectionalMix.$bottomEnd,
            resolvesTo(const Radius.circular(20.0)),
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
          expect(result!.$topStart, resolvesTo(const Radius.circular(8.0)));
        },
      );
    });

    group('resolve', () {
      test('resolves to BorderRadiusDirectional with correct properties', () {
        final borderRadiusDirectionalMix = BorderRadiusDirectionalMix(
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
        final borderRadiusDirectionalMix = BorderRadiusDirectionalMix(
          topStart: const Radius.circular(8.0),
        );
        final merged = borderRadiusDirectionalMix.merge(null);

        expect(merged, same(borderRadiusDirectionalMix));
      });

      test('merges properties correctly', () {
        final first = BorderRadiusDirectionalMix(
          topStart: const Radius.circular(8.0),
          topEnd: const Radius.circular(12.0),
        );

        final second = BorderRadiusDirectionalMix(
          topEnd: const Radius.circular(16.0),
          bottomStart: const Radius.circular(20.0),
        );

        final merged = first.merge(second);

        expect(merged.$topStart, resolvesTo(const Radius.circular(8.0)));
        expect(merged.$topEnd, resolvesTo(const Radius.circular(16.0)));
        expect(merged.$bottomStart, resolvesTo(const Radius.circular(20.0)));
        expect(merged.$bottomEnd, isNull);
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final borderRadiusDirectionalMix1 = BorderRadiusDirectionalMix(
          topStart: const Radius.circular(8.0),
          topEnd: const Radius.circular(12.0),
        );

        final borderRadiusDirectionalMix2 = BorderRadiusDirectionalMix(
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
        final borderRadiusDirectionalMix1 = BorderRadiusDirectionalMix(
          topStart: const Radius.circular(8.0),
        );
        final borderRadiusDirectionalMix2 = BorderRadiusDirectionalMix(
          topStart: const Radius.circular(12.0),
        );

        expect(borderRadiusDirectionalMix1, isNot(borderRadiusDirectionalMix2));
      });
    });

    group('Utility Methods', () {
      test('topStart utility works correctly', () {
        final borderRadiusDirectionalMix = BorderRadiusDirectionalMix()
            .topStart(const Radius.circular(5.0));

        expect(
          borderRadiusDirectionalMix.$topStart,
          resolvesTo(const Radius.circular(5.0)),
        );
      });

      test('topEnd utility works correctly', () {
        final borderRadiusDirectionalMix = BorderRadiusDirectionalMix().topEnd(
          const Radius.circular(6.0),
        );

        expect(
          borderRadiusDirectionalMix.$topEnd,
          resolvesTo(const Radius.circular(6.0)),
        );
      });

      test('bottomStart utility works correctly', () {
        final borderRadiusDirectionalMix = BorderRadiusDirectionalMix()
            .bottomStart(const Radius.circular(7.0));

        expect(
          borderRadiusDirectionalMix.$bottomStart,
          resolvesTo(const Radius.circular(7.0)),
        );
      });

      test('bottomEnd utility works correctly', () {
        final borderRadiusDirectionalMix = BorderRadiusDirectionalMix()
            .bottomEnd(const Radius.circular(8.0));

        expect(
          borderRadiusDirectionalMix.$bottomEnd,
          resolvesTo(const Radius.circular(8.0)),
        );
      });
    });
  });
}
