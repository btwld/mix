import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('BorderSideMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final borderSideMix = BorderSideMix.only(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
          strokeAlign: 1.0,
        );

        expectProp(borderSideMix.color, Colors.red);
        expectProp(borderSideMix.width, 2.0);
        expectProp(borderSideMix.style, BorderStyle.solid);
        expectProp(borderSideMix.strokeAlign, 1.0);
      });

      test('value constructor extracts properties from BorderSide', () {
        const borderSide = BorderSide(
          color: Colors.blue,
          width: 3.0,
          style: BorderStyle.solid,
          strokeAlign: 0.5,
        );

        final borderSideMix = BorderSideMix.value(borderSide);

        expectProp(borderSideMix.color, Colors.blue);
        expectProp(borderSideMix.width, 3.0);
        expectProp(borderSideMix.style, BorderStyle.solid);
        expectProp(borderSideMix.strokeAlign, 0.5);
      });

      test('maybeValue returns null for null input', () {
        final result = BorderSideMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns BorderSideMix for non-null input', () {
        const borderSide = BorderSide(width: 1.0);
        final result = BorderSideMix.maybeValue(borderSide);

        expect(result, isNotNull);
        expectProp(result!.width, 1.0);
      });

      test('none static instance has correct properties', () {
        final none = BorderSideMix.none;

        // BorderSideMix.none is created with BorderSideMix() (no parameters)
        // so all properties are null
        expect(none.style, isNull);
        expect(none.width, isNull);
        expect(none.color, isNull);
        expect(none.strokeAlign, isNull);
      });
    });

    group('resolve', () {
      test('resolves to BorderSide with correct properties', () {
        final borderSideMix = BorderSideMix.only(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
        );

        const resolvedValue = BorderSide(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
        );

        expect(borderSideMix, resolvesTo(resolvedValue));
      });

      test('uses default values for null properties', () {
        final borderSideMix = BorderSideMix.only(width: 2.0);

        const resolvedValue = BorderSide(
          width: 2.0,
          color: Color(0xFF000000),
          style: BorderStyle.solid,
        );

        expect(borderSideMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final borderSideMix = BorderSideMix.only(width: 2.0);
        final merged = borderSideMix.merge(null);

        expect(merged, same(borderSideMix));
      });

      test('merges properties correctly', () {
        final first = BorderSideMix.only(color: Colors.red, width: 2.0);

        final second = BorderSideMix.only(width: 3.0, style: BorderStyle.solid);

        final merged = first.merge(second);

        // Property that exists only in first remains as direct value
        expectProp(merged.color, Colors.red);
        // Property that exists in both - second value replaces first (Prop replacement strategy)
        expectProp(merged.width, 3.0);
        // Property that exists only in second remains as direct value
        expectProp(merged.style, BorderStyle.solid);
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final borderSideMix1 = BorderSideMix.only(
          color: Colors.red,
          width: 2.0,
        );

        final borderSideMix2 = BorderSideMix.only(
          color: Colors.red,
          width: 2.0,
        );

        expect(borderSideMix1, borderSideMix2);
        expect(borderSideMix1.hashCode, borderSideMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final borderSideMix1 = BorderSideMix.only(width: 2.0);
        final borderSideMix2 = BorderSideMix.only(width: 3.0);

        expect(borderSideMix1, isNot(borderSideMix2));
      });
    });
  });

  group('BorderMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final topSide = BorderSideMix.only(color: Colors.red, width: 1.0);
        final bottomSide = BorderSideMix.only(color: Colors.blue, width: 2.0);
        final leftSide = BorderSideMix.only(color: Colors.green, width: 3.0);
        final rightSide = BorderSideMix.only(color: Colors.yellow, width: 4.0);

        final borderMix = BorderMix.only(
          top: topSide,
          bottom: bottomSide,
          left: leftSide,
          right: rightSide,
        );

        expect(borderMix.top, isA<MixProp<BorderSide>>());
        expect(borderMix.bottom, isA<MixProp<BorderSide>>());
        expect(borderMix.left, isA<MixProp<BorderSide>>());
        expect(borderMix.right, isA<MixProp<BorderSide>>());
      });

      test('all constructor creates uniform border', () {
        final side = BorderSideMix.only(color: Colors.red, width: 2.0);
        final borderMix = BorderMix.all(side);

        expect(borderMix.top, isA<MixProp<BorderSide>>());
        expect(borderMix.bottom, isA<MixProp<BorderSide>>());
        expect(borderMix.left, isA<MixProp<BorderSide>>());
        expect(borderMix.right, isA<MixProp<BorderSide>>());
      });

      test('value constructor extracts properties from Border', () {
        const border = Border(
          top: BorderSide(color: Colors.red, width: 1.0),
          bottom: BorderSide(color: Colors.blue, width: 2.0),
          left: BorderSide(color: Colors.green, width: 3.0),
          right: BorderSide(color: Colors.yellow, width: 4.0),
        );

        final borderMix = BorderMix.value(border);

        expect(borderMix.top, isA<MixProp<BorderSide>>());
        expect(borderMix.bottom, isA<MixProp<BorderSide>>());
        expect(borderMix.left, isA<MixProp<BorderSide>>());
        expect(borderMix.right, isA<MixProp<BorderSide>>());
      });

      test('maybeValue returns null for null input', () {
        final result = BorderMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns BorderMix for non-null input', () {
        final border = Border.all(width: 1.0);
        final result = BorderMix.maybeValue(border);

        expect(result, isNotNull);
        expect(result!.top, isA<MixProp<BorderSide>>());
      });

      test('none static instance has correct properties', () {
        final none = BorderMix.none;

        expect(none.top, isA<MixProp<BorderSide>>());
        expect(none.bottom, isA<MixProp<BorderSide>>());
        expect(none.left, isA<MixProp<BorderSide>>());
        expect(none.right, isA<MixProp<BorderSide>>());
      });
    });

    group('resolve', () {
      test('resolves to Border with correct properties', () {
        final borderMix = BorderMix.only(
          top: BorderSideMix.only(color: Colors.red, width: 1.0),
          bottom: BorderSideMix.only(color: Colors.blue, width: 2.0),
          left: BorderSideMix.only(color: Colors.green, width: 3.0),
          right: BorderSideMix.only(color: Colors.yellow, width: 4.0),
        );

        const resolvedValue = Border(
          top: BorderSide(color: Colors.red, width: 1.0),
          bottom: BorderSide(color: Colors.blue, width: 2.0),
          left: BorderSide(color: Colors.green, width: 3.0),
          right: BorderSide(color: Colors.yellow, width: 4.0),
        );

        expect(borderMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final borderMix = BorderMix.only(top: BorderSideMix.only(width: 1.0));
        final merged = borderMix.merge(null);

        expect(merged, same(borderMix));
      });

      test('merges properties correctly', () {
        final first = BorderMix.only(
          top: BorderSideMix.only(color: Colors.red, width: 1.0),
          left: BorderSideMix.only(color: Colors.green, width: 3.0),
        );

        final second = BorderMix.only(
          top: BorderSideMix.only(color: Colors.blue, width: 2.0),
          right: BorderSideMix.only(color: Colors.yellow, width: 4.0),
        );

        final merged = first.merge(second);

        expect(merged.top, isA<MixProp<BorderSide>>());
        expect(merged.bottom, isNull);
        expect(merged.left, isA<MixProp<BorderSide>>());
        expect(merged.right, isA<MixProp<BorderSide>>());
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final side = BorderSideMix.only(color: Colors.red, width: 2.0);
        final borderMix1 = BorderMix.only(top: side, left: side);
        final borderMix2 = BorderMix.only(top: side, left: side);

        expect(borderMix1, borderMix2);
        expect(borderMix1.hashCode, borderMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final side1 = BorderSideMix.only(width: 1.0);
        final side2 = BorderSideMix.only(width: 2.0);
        final borderMix1 = BorderMix.only(top: side1);
        final borderMix2 = BorderMix.only(top: side2);

        expect(borderMix1, isNot(borderMix2));
      });
    });
  });
}
