import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ShadowMix', () {
    group('Constructor', () {
      test('creates ShadowMix with all properties', () {
        final shadowMix = ShadowMix(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(5.0, 8.0),
        );

        expect(shadowMix.$blurRadius, resolvesTo(10.0));
        expect(shadowMix.$color, resolvesTo(Colors.blue));
        expect(shadowMix.$offset, resolvesTo(const Offset(5.0, 8.0)));
      });

      test('creates empty ShadowMix', () {
        final shadowMix = ShadowMix();

        expect(shadowMix.$blurRadius, isNull);
        expect(shadowMix.$color, isNull);
        expect(shadowMix.$offset, isNull);
      });
    });

    group('Factory Constructors', () {
      test('color factory creates ShadowMix with color', () {
        final shadowMix = ShadowMix.color(Colors.red);

        expect(shadowMix.$color, resolvesTo(Colors.red));
        expect(shadowMix.$blurRadius, isNull);
        expect(shadowMix.$offset, isNull);
      });

      test('offset factory creates ShadowMix with offset', () {
        final shadowMix = ShadowMix.offset(const Offset(3.0, 4.0));

        expect(shadowMix.$offset, resolvesTo(const Offset(3.0, 4.0)));
        expect(shadowMix.$blurRadius, isNull);
        expect(shadowMix.$color, isNull);
      });

      test('blurRadius factory creates ShadowMix with blurRadius', () {
        final shadowMix = ShadowMix.blurRadius(8.0);

        expect(shadowMix.$blurRadius, resolvesTo(8.0));
        expect(shadowMix.$color, isNull);
        expect(shadowMix.$offset, isNull);
      });
    });

    group('value constructor', () {
      test('creates ShadowMix from Shadow', () {
        const shadow = Shadow(
          blurRadius: 15.0,
          color: Colors.red,
          offset: Offset(3.0, 6.0),
        );

        final shadowMix = ShadowMix.value(shadow);

        expect(shadowMix.$blurRadius, resolvesTo(15.0));
        expect(shadowMix.$color, resolvesTo(Colors.red));
        expect(shadowMix.$offset, resolvesTo(const Offset(3.0, 6.0)));
      });

      test('maybeValue returns null for null shadow', () {
        expect(ShadowMix.maybeValue(null), isNull);
      });

      test('maybeValue returns ShadowMix for non-null shadow', () {
        const shadow = Shadow(blurRadius: 5.0, color: Colors.green);
        final shadowMix = ShadowMix.maybeValue(shadow);

        expect(shadowMix, isNotNull);
        expect(shadowMix!.$blurRadius, resolvesTo(5.0));
        expect(shadowMix.$color, resolvesTo(Colors.green));
      });
    });

    group('Utility Methods', () {
      test('color utility works correctly', () {
        final shadowMix = ShadowMix().color(Colors.purple);

        expect(shadowMix.$color, resolvesTo(Colors.purple));
      });

      test('offset utility works correctly', () {
        final shadowMix = ShadowMix().offset(const Offset(2.0, 3.0));

        expect(shadowMix.$offset, resolvesTo(const Offset(2.0, 3.0)));
      });

      test('blurRadius utility works correctly', () {
        final shadowMix = ShadowMix().blurRadius(12.0);

        expect(shadowMix.$blurRadius, resolvesTo(12.0));
      });
    });

    group('Resolution', () {
      test('resolves to Shadow with correct properties', () {
        final shadowMix = ShadowMix(
          blurRadius: 12.0,
          color: Colors.green,
          offset: const Offset(2.0, 4.0),
        );

        const resolvedValue = Shadow(
          blurRadius: 12.0,
          color: Colors.green,
          offset: Offset(2.0, 4.0),
        );

        expect(shadowMix, resolvesTo(resolvedValue));
      });

      test('resolves with default values for null properties', () {
        final shadowMix = ShadowMix(blurRadius: 8.0);

        const resolvedValue = Shadow(
          blurRadius: 8.0,
          color: Color(0xFF000000),
          offset: Offset.zero,
        );

        expect(shadowMix, resolvesTo(resolvedValue));
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = ShadowMix(blurRadius: 10.0, color: Colors.blue);

        final second = ShadowMix(
          color: Colors.red,
          offset: const Offset(3.0, 3.0),
        );

        final merged = first.merge(second);

        expect(merged.$blurRadius, resolvesTo(10.0)); // from first
        expect(merged.$color, resolvesTo(Colors.red)); // second overrides
        expect(
          merged.$offset,
          resolvesTo(const Offset(3.0, 3.0)),
        ); // from second
      });

      test('returns equivalent instance when other is null', () {
        final shadowMix = ShadowMix(blurRadius: 5.0);
        final merged = shadowMix.merge(null);

        expect(identical(shadowMix, merged), isFalse);
        expect(merged, equals(shadowMix));
      });
    });

    group('Equality', () {
      test('equal shadows have same hashCode', () {
        final shadow1 = ShadowMix(blurRadius: 10.0, color: Colors.blue);
        final shadow2 = ShadowMix(blurRadius: 10.0, color: Colors.blue);

        expect(shadow1, equals(shadow2));
        expect(shadow1.hashCode, equals(shadow2.hashCode));
      });

      test('different shadows are not equal', () {
        final shadow1 = ShadowMix(blurRadius: 10.0);
        final shadow2 = ShadowMix(blurRadius: 15.0);

        expect(shadow1, isNot(equals(shadow2)));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final shadowMix = ShadowMix(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(5.0, 8.0),
        );

        expect(shadowMix.props.length, 3);
        expect(shadowMix.props, contains(shadowMix.$blurRadius));
        expect(shadowMix.props, contains(shadowMix.$color));
        expect(shadowMix.props, contains(shadowMix.$offset));
      });
    });

    group('Default Value', () {
      test('has correct default value', () {
        final shadowMix = ShadowMix();

        expect(shadowMix.defaultValue, const Shadow());
      });
    });
  });

  group('BoxShadowMix', () {
    group('Constructor', () {
      test('creates BoxShadowMix with all properties', () {
        final boxShadowMix = BoxShadowMix(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(5.0, 8.0),
          spreadRadius: 2.0,
        );

        expect(boxShadowMix.$blurRadius, resolvesTo(10.0));
        expect(boxShadowMix.$color, resolvesTo(Colors.blue));
        expect(boxShadowMix.$offset, resolvesTo(const Offset(5.0, 8.0)));
        expect(boxShadowMix.$spreadRadius, resolvesTo(2.0));
      });

      test('creates empty BoxShadowMix', () {
        final boxShadowMix = BoxShadowMix();

        expect(boxShadowMix.$blurRadius, isNull);
        expect(boxShadowMix.$color, isNull);
        expect(boxShadowMix.$offset, isNull);
        expect(boxShadowMix.$spreadRadius, isNull);
      });
    });

    group('Factory Constructors', () {
      test('color factory creates BoxShadowMix with color', () {
        final boxShadowMix = BoxShadowMix.color(Colors.red);

        expect(boxShadowMix.$color, resolvesTo(Colors.red));
        expect(boxShadowMix.$blurRadius, isNull);
        expect(boxShadowMix.$offset, isNull);
        expect(boxShadowMix.$spreadRadius, isNull);
      });

      test('offset factory creates BoxShadowMix with offset', () {
        final boxShadowMix = BoxShadowMix.offset(const Offset(3.0, 4.0));

        expect(boxShadowMix.$offset, resolvesTo(const Offset(3.0, 4.0)));
        expect(boxShadowMix.$blurRadius, isNull);
        expect(boxShadowMix.$color, isNull);
        expect(boxShadowMix.$spreadRadius, isNull);
      });

      test('blurRadius factory creates BoxShadowMix with blurRadius', () {
        final boxShadowMix = BoxShadowMix.blurRadius(8.0);

        expect(boxShadowMix.$blurRadius, resolvesTo(8.0));
        expect(boxShadowMix.$color, isNull);
        expect(boxShadowMix.$offset, isNull);
        expect(boxShadowMix.$spreadRadius, isNull);
      });

      test('spreadRadius factory creates BoxShadowMix with spreadRadius', () {
        final boxShadowMix = BoxShadowMix.spreadRadius(3.0);

        expect(boxShadowMix.$spreadRadius, resolvesTo(3.0));
        expect(boxShadowMix.$blurRadius, isNull);
        expect(boxShadowMix.$color, isNull);
        expect(boxShadowMix.$offset, isNull);
      });

      test(
        'fromElevation factory creates list of BoxShadowMix from elevation',
        () {
          final shadows = BoxShadowMix.fromElevation(ElevationShadow.two);

          expect(shadows, isNotEmpty);
          expect(shadows, isA<List<BoxShadowMix>>());
        },
      );
    });

    group('value constructor', () {
      test('creates BoxShadowMix from BoxShadow', () {
        const boxShadow = BoxShadow(
          blurRadius: 15.0,
          color: Colors.red,
          offset: Offset(3.0, 6.0),
          spreadRadius: 4.0,
        );

        final boxShadowMix = BoxShadowMix.value(boxShadow);

        expect(boxShadowMix.$blurRadius, resolvesTo(15.0));
        expect(boxShadowMix.$color, resolvesTo(Colors.red));
        expect(boxShadowMix.$offset, resolvesTo(const Offset(3.0, 6.0)));
        expect(boxShadowMix.$spreadRadius, resolvesTo(4.0));
      });

      test('maybeValue returns null for null boxShadow', () {
        expect(BoxShadowMix.maybeValue(null), isNull);
      });

      test('maybeValue returns BoxShadowMix for non-null boxShadow', () {
        const boxShadow = BoxShadow(blurRadius: 5.0, spreadRadius: 1.0);
        final boxShadowMix = BoxShadowMix.maybeValue(boxShadow);

        expect(boxShadowMix, isNotNull);
        expect(boxShadowMix!.$blurRadius, resolvesTo(5.0));
        expect(boxShadowMix.$spreadRadius, resolvesTo(1.0));
      });
    });

    group('Utility Methods', () {
      test('color utility works correctly', () {
        final boxShadowMix = BoxShadowMix().color(Colors.purple);

        expect(boxShadowMix.$color, resolvesTo(Colors.purple));
      });

      test('offset utility works correctly', () {
        final boxShadowMix = BoxShadowMix().offset(const Offset(2.0, 3.0));

        expect(boxShadowMix.$offset, resolvesTo(const Offset(2.0, 3.0)));
      });

      test('blurRadius utility works correctly', () {
        final boxShadowMix = BoxShadowMix().blurRadius(12.0);

        expect(boxShadowMix.$blurRadius, resolvesTo(12.0));
      });

      test('spreadRadius utility works correctly', () {
        final boxShadowMix = BoxShadowMix().spreadRadius(4.0);

        expect(boxShadowMix.$spreadRadius, resolvesTo(4.0));
      });
    });

    group('Resolution', () {
      test('resolves to BoxShadow with correct properties', () {
        final boxShadowMix = BoxShadowMix(
          blurRadius: 12.0,
          color: Colors.green,
          offset: const Offset(2.0, 4.0),
          spreadRadius: 3.0,
        );

        const resolvedValue = BoxShadow(
          blurRadius: 12.0,
          color: Colors.green,
          offset: Offset(2.0, 4.0),
          spreadRadius: 3.0,
        );

        expect(boxShadowMix, resolvesTo(resolvedValue));
      });

      test('resolves with default values for null properties', () {
        final boxShadowMix = BoxShadowMix(blurRadius: 8.0);

        const resolvedValue = BoxShadow(
          blurRadius: 8.0,
          color: Color(0xFF000000),
          offset: Offset.zero,
          spreadRadius: 0.0,
        );

        expect(boxShadowMix, resolvesTo(resolvedValue));
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = BoxShadowMix(
          blurRadius: 10.0,
          color: Colors.blue,
          spreadRadius: 1.0,
        );

        final second = BoxShadowMix(
          color: Colors.red,
          offset: const Offset(3.0, 3.0),
          spreadRadius: 2.0,
        );

        final merged = first.merge(second);

        expect(merged.$blurRadius, resolvesTo(10.0)); // from first
        expect(merged.$color, resolvesTo(Colors.red)); // second overrides
        expect(
          merged.$offset,
          resolvesTo(const Offset(3.0, 3.0)),
        ); // from second
        expect(merged.$spreadRadius, resolvesTo(2.0)); // second overrides
      });

      test('returns equivalent instance when other is null', () {
        final boxShadowMix = BoxShadowMix(blurRadius: 5.0);
        final merged = boxShadowMix.merge(null);

        expect(identical(boxShadowMix, merged), isFalse);
        expect(merged, equals(boxShadowMix));
      });
    });

    group('Equality', () {
      test('equal box shadows have same hashCode', () {
        final boxShadow1 = BoxShadowMix(
          blurRadius: 10.0,
          color: Colors.blue,
          spreadRadius: 2.0,
        );

        final boxShadow2 = BoxShadowMix(
          blurRadius: 10.0,
          color: Colors.blue,
          spreadRadius: 2.0,
        );

        expect(boxShadow1, equals(boxShadow2));
        expect(boxShadow1.hashCode, equals(boxShadow2.hashCode));
      });

      test('different box shadows are not equal', () {
        final boxShadow1 = BoxShadowMix(blurRadius: 10.0);
        final boxShadow2 = BoxShadowMix(blurRadius: 15.0);

        expect(boxShadow1, isNot(equals(boxShadow2)));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final boxShadowMix = BoxShadowMix(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(5.0, 8.0),
          spreadRadius: 2.0,
        );

        expect(boxShadowMix.props.length, 4);
        expect(boxShadowMix.props, contains(boxShadowMix.$blurRadius));
        expect(boxShadowMix.props, contains(boxShadowMix.$color));
        expect(boxShadowMix.props, contains(boxShadowMix.$offset));
        expect(boxShadowMix.props, contains(boxShadowMix.$spreadRadius));
      });
    });

    group('Default Value', () {
      test('has correct default value', () {
        final boxShadowMix = BoxShadowMix();

        expect(boxShadowMix.defaultValue, const BoxShadow());
      });
    });
  });
}
