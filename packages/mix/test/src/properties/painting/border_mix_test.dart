import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BorderSideMix', () {
    group('Constructor', () {
      test('creates BorderSideMix with all properties', () {
        final borderSideMix = BorderSideMix(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
          strokeAlign: 1.0,
        );

        expectProp(borderSideMix.$color, Colors.red);
        expectProp(borderSideMix.$width, 2.0);
        expectProp(borderSideMix.$style, BorderStyle.solid);
        expectProp(borderSideMix.$strokeAlign, 1.0);
      });

      test('creates empty BorderSideMix', () {
        final borderSideMix = BorderSideMix();

        expect(borderSideMix.$color, isNull);
        expect(borderSideMix.$width, isNull);
        expect(borderSideMix.$style, isNull);
        expect(borderSideMix.$strokeAlign, isNull);
      });
    });

    group('Factory Constructors', () {
      test('color factory creates BorderSideMix with color', () {
        final borderSideMix = BorderSideMix.color(Colors.blue);

        expectProp(borderSideMix.$color, Colors.blue);
        expect(borderSideMix.$width, isNull);
        expect(borderSideMix.$style, isNull);
        expect(borderSideMix.$strokeAlign, isNull);
      });

      test('width factory creates BorderSideMix with width', () {
        final borderSideMix = BorderSideMix.width(3.0);

        expectProp(borderSideMix.$width, 3.0);
        expect(borderSideMix.$color, isNull);
        expect(borderSideMix.$style, isNull);
        expect(borderSideMix.$strokeAlign, isNull);
      });

      test('style factory creates BorderSideMix with style', () {
        final borderSideMix = BorderSideMix.style(BorderStyle.none);

        expectProp(borderSideMix.$style, BorderStyle.none);
        expect(borderSideMix.$color, isNull);
        expect(borderSideMix.$width, isNull);
        expect(borderSideMix.$strokeAlign, isNull);
      });

      test('strokeAlign factory creates BorderSideMix with strokeAlign', () {
        final borderSideMix = BorderSideMix.strokeAlign(0.5);

        expectProp(borderSideMix.$strokeAlign, 0.5);
        expect(borderSideMix.$color, isNull);
        expect(borderSideMix.$width, isNull);
        expect(borderSideMix.$style, isNull);
      });
    });

    group('value constructor', () {
      test('creates BorderSideMix from BorderSide', () {
        const borderSide = BorderSide(
          color: Colors.green,
          width: 4.0,
          style: BorderStyle.solid,
          strokeAlign: 0.8,
        );

        final borderSideMix = BorderSideMix.value(borderSide);

        expectProp(borderSideMix.$color, Colors.green);
        expectProp(borderSideMix.$width, 4.0);
        expectProp(borderSideMix.$style, BorderStyle.solid);
        expectProp(borderSideMix.$strokeAlign, 0.8);
      });

      test('maybeValue returns null for null borderSide', () {
        expect(BorderSideMix.maybeValue(null), isNull);
      });

      test('maybeValue returns null for BorderSide.none', () {
        expect(BorderSideMix.maybeValue(BorderSide.none), isNull);
      });

      test('maybeValue returns BorderSideMix for non-null borderSide', () {
        const borderSide = BorderSide(width: 2.0, color: Colors.purple);
        final borderSideMix = BorderSideMix.maybeValue(borderSide);

        expect(borderSideMix, isNotNull);
        expectProp(borderSideMix!.$width, 2.0);
        expectProp(borderSideMix.$color, Colors.purple);
      });
    });

    group('Utility Methods', () {
      test('color utility works correctly', () {
        final borderSideMix = BorderSideMix().color(Colors.orange);

        expectProp(borderSideMix.$color, Colors.orange);
      });

      test('width utility works correctly', () {
        final borderSideMix = BorderSideMix().width(5.0);

        expectProp(borderSideMix.$width, 5.0);
      });

      test('style utility works correctly', () {
        final borderSideMix = BorderSideMix().style(BorderStyle.none);

        expectProp(borderSideMix.$style, BorderStyle.none);
      });

      test('strokeAlign utility works correctly', () {
        final borderSideMix = BorderSideMix().strokeAlign(0.3);

        expectProp(borderSideMix.$strokeAlign, 0.3);
      });
    });

    group('Resolution', () {
      test('resolves to BorderSide with correct properties', () {
        final borderSideMix = BorderSideMix(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
          strokeAlign: 1.0,
        );

        const resolvedValue = BorderSide(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
          strokeAlign: 1.0,
        );

        expect(borderSideMix, resolvesTo(resolvedValue));
      });

      test('resolves with default values for null properties', () {
        final borderSideMix = BorderSideMix(width: 2.0);

        const resolvedValue = BorderSide(
          width: 2.0,
          color: Color(0xFF000000),
          style: BorderStyle.solid,
          strokeAlign: -1.0,
        );

        expect(borderSideMix, resolvesTo(resolvedValue));
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = BorderSideMix(color: Colors.red, width: 2.0);

        final second = BorderSideMix(width: 3.0, style: BorderStyle.solid);

        final merged = first.merge(second);

        expectProp(merged.$color, Colors.red); // from first
        expectProp(merged.$width, 3.0); // second overrides
        expectProp(merged.$style, BorderStyle.solid); // from second
      });

      test('returns this when other is null', () {
        final borderSideMix = BorderSideMix(width: 2.0);
        final merged = borderSideMix.merge(null);

        expect(identical(borderSideMix, merged), isTrue);
      });
    });

    group('Equality', () {
      test('equal border sides have same hashCode', () {
        final border1 = BorderSideMix(color: Colors.red, width: 2.0);
        final border2 = BorderSideMix(color: Colors.red, width: 2.0);

        expect(border1, equals(border2));
        expect(border1.hashCode, equals(border2.hashCode));
      });

      test('different border sides are not equal', () {
        final border1 = BorderSideMix(width: 2.0);
        final border2 = BorderSideMix(width: 3.0);

        expect(border1, isNot(equals(border2)));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final borderSideMix = BorderSideMix(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
          strokeAlign: 1.0,
        );

        expect(borderSideMix.props.length, 4);
        expect(borderSideMix.props, contains(borderSideMix.$color));
        expect(borderSideMix.props, contains(borderSideMix.$width));
        expect(borderSideMix.props, contains(borderSideMix.$style));
        expect(borderSideMix.props, contains(borderSideMix.$strokeAlign));
      });
    });

    group('Default Value', () {
      test('has correct default value', () {
        final borderSideMix = BorderSideMix();

        expect(borderSideMix.defaultValue, const BorderSide());
      });
    });

    group('Static Values', () {
      test('none static value is correct', () {
        expect(BorderSideMix.none, resolvesTo(BorderSide.none));
      });
    });
  });
}
