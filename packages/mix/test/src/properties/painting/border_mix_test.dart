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

        expect(borderSideMix.$color, resolvesTo(Colors.red));
        expect(borderSideMix.$width, resolvesTo(2.0));
        expect(borderSideMix.$style, resolvesTo(BorderStyle.solid));
        expect(borderSideMix.$strokeAlign, resolvesTo(1.0));
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

        expect(borderSideMix.$color, resolvesTo(Colors.blue));
        expect(borderSideMix.$width, isNull);
        expect(borderSideMix.$style, isNull);
        expect(borderSideMix.$strokeAlign, isNull);
      });

      test('width factory creates BorderSideMix with width', () {
        final borderSideMix = BorderSideMix.width(3.0);

        expect(borderSideMix.$width, resolvesTo(3.0));
        expect(borderSideMix.$color, isNull);
        expect(borderSideMix.$style, isNull);
        expect(borderSideMix.$strokeAlign, isNull);
      });

      test('style factory creates BorderSideMix with style', () {
        final borderSideMix = BorderSideMix.style(BorderStyle.none);

        expect(borderSideMix.$style, resolvesTo(BorderStyle.none));
        expect(borderSideMix.$color, isNull);
        expect(borderSideMix.$width, isNull);
        expect(borderSideMix.$strokeAlign, isNull);
      });

      test('strokeAlign factory creates BorderSideMix with strokeAlign', () {
        final borderSideMix = BorderSideMix.strokeAlign(0.5);

        expect(borderSideMix.$strokeAlign, resolvesTo(0.5));
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

        expect(borderSideMix.$color, resolvesTo(Colors.green));
        expect(borderSideMix.$width, resolvesTo(4.0));
        expect(borderSideMix.$style, resolvesTo(BorderStyle.solid));
        expect(borderSideMix.$strokeAlign, resolvesTo(0.8));
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
        expect(borderSideMix!.$width, resolvesTo(2.0));
        expect(borderSideMix.$color, resolvesTo(Colors.purple));
      });
    });

    group('Utility Methods', () {
      test('color utility works correctly', () {
        final borderSideMix = BorderSideMix().color(Colors.orange);

        expect(borderSideMix.$color, resolvesTo(Colors.orange));
      });

      test('width utility works correctly', () {
        final borderSideMix = BorderSideMix().width(5.0);

        expect(borderSideMix.$width, resolvesTo(5.0));
      });

      test('style utility works correctly', () {
        final borderSideMix = BorderSideMix().style(BorderStyle.none);

        expect(borderSideMix.$style, resolvesTo(BorderStyle.none));
      });

      test('strokeAlign utility works correctly', () {
        final borderSideMix = BorderSideMix().strokeAlign(0.3);

        expect(borderSideMix.$strokeAlign, resolvesTo(0.3));
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

        expect(merged.$color, resolvesTo(Colors.red)); // from first
        expect(merged.$width, resolvesTo(3.0)); // second overrides
        expect(merged.$style, resolvesTo(BorderStyle.solid)); // from second
      });

      test('returns equivalent instance when other is null', () {
        final borderSideMix = BorderSideMix(width: 2.0);
        final merged = borderSideMix.merge(null);

        expect(identical(borderSideMix, merged), isFalse);
        expect(merged, equals(borderSideMix));
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

  group('BorderMix', () {
    group('Constructor', () {
      test('creates BorderMix with all sides', () {
        final topSide = BorderSideMix(color: Colors.red, width: 1.0);
        final rightSide = BorderSideMix(color: Colors.green, width: 2.0);
        final bottomSide = BorderSideMix(color: Colors.blue, width: 3.0);
        final leftSide = BorderSideMix(color: Colors.yellow, width: 4.0);

        final borderMix = BorderMix(
          top: topSide,
          right: rightSide,
          bottom: bottomSide,
          left: leftSide,
        );

        // Check that each side's Mix is correctly stored
        expect(borderMix.$top, isNotNull);
        expect(borderMix.$top, PropMatcher.isMix(topSide));

        expect(borderMix.$right, isNotNull);
        expect(borderMix.$right, PropMatcher.isMix(rightSide));

        expect(borderMix.$bottom, isNotNull);
        expect(borderMix.$bottom, PropMatcher.isMix(bottomSide));

        expect(borderMix.$left, isNotNull);
        expect(borderMix.$left, PropMatcher.isMix(leftSide));
      });

      test('creates empty BorderMix', () {
        final borderMix = BorderMix();

        expect(borderMix.$top, isNull);
        expect(borderMix.$right, isNull);
        expect(borderMix.$bottom, isNull);
        expect(borderMix.$left, isNull);
      });
    });

    group('value constructor', () {
      test('creates BorderMix from Border with all sides', () {
        const border = Border(
          top: BorderSide(color: Colors.red, width: 1.0),
          right: BorderSide(color: Colors.green, width: 2.0),
          bottom: BorderSide(color: Colors.blue, width: 3.0),
          left: BorderSide(color: Colors.yellow, width: 4.0),
        );

        final borderMix = BorderMix.value(border);

        // Verify that the border resolves correctly
        final resolved = borderMix.resolve(MockBuildContext());
        expect(resolved.top.color, Colors.red);
        expect(resolved.top.width, 1.0);
        expect(resolved.right.color, Colors.green);
        expect(resolved.right.width, 2.0);
        expect(resolved.bottom.color, Colors.blue);
        expect(resolved.bottom.width, 3.0);
        expect(resolved.left.color, Colors.yellow);
        expect(resolved.left.width, 4.0);
      });

      test('creates BorderMix from Border.all', () {
        final border = Border.all(color: Colors.purple, width: 2.5);

        final borderMix = BorderMix.value(border);

        // All sides should be equivalent
        final resolved = borderMix.resolve(MockBuildContext());
        expect(resolved.top.color, Colors.purple);
        expect(resolved.top.width, 2.5);
        expect(resolved.right.color, Colors.purple);
        expect(resolved.right.width, 2.5);
        expect(resolved.bottom.color, Colors.purple);
        expect(resolved.bottom.width, 2.5);
        expect(resolved.left.color, Colors.purple);
        expect(resolved.left.width, 2.5);
      });

      test('handles Border with BorderSide.none correctly', () {
        const border = Border(
          top: BorderSide(color: Colors.red, width: 2.0),
          right: BorderSide.none,
          bottom: BorderSide(color: Colors.blue, width: 1.0),
          left: BorderSide.none,
        );

        final borderMix = BorderMix.value(border);

        // Verify the border resolves correctly with null sides
        final resolved = borderMix.resolve(MockBuildContext());
        expect(resolved.top.color, Colors.red);
        expect(resolved.top.width, 2.0);
        expect(resolved.right, BorderSide.none);
        expect(resolved.bottom.color, Colors.blue);
        expect(resolved.bottom.width, 1.0);
        expect(resolved.left, BorderSide.none);
      });

      test('maybeValue returns null for null border', () {
        expect(BorderMix.maybeValue(null), isNull);
      });

      test('maybeValue returns BorderMix for non-null border', () {
        final border = Border.all(color: Colors.orange, width: 1.5);
        final borderMix = BorderMix.maybeValue(border);

        expect(borderMix, isNotNull);
        final resolved = borderMix!.resolve(MockBuildContext());
        expect(resolved.top.color, Colors.orange);
        expect(resolved.top.width, 1.5);
      });
    });

    group('Resolution', () {
      test('resolves to Border with correct properties', () {
        final borderMix = BorderMix(
          top: BorderSideMix(color: Colors.red, width: 2.0),
          right: BorderSideMix(color: Colors.green, width: 3.0),
          bottom: BorderSideMix(color: Colors.blue, width: 1.0),
          left: BorderSideMix(color: Colors.yellow, width: 4.0),
        );

        const expectedBorder = Border(
          top: BorderSide(color: Colors.red, width: 2.0),
          right: BorderSide(color: Colors.green, width: 3.0),
          bottom: BorderSide(color: Colors.blue, width: 1.0),
          left: BorderSide(color: Colors.yellow, width: 4.0),
        );

        expect(borderMix, resolvesTo(expectedBorder));
      });

      test('resolves with default values for null sides', () {
        final borderMix = BorderMix(
          top: BorderSideMix(color: Colors.red, width: 2.0),
          // other sides are null
        );

        const expectedBorder = Border(
          top: BorderSide(color: Colors.red, width: 2.0),
          right: BorderSide.none,
          bottom: BorderSide.none,
          left: BorderSide.none,
        );

        expect(borderMix, resolvesTo(expectedBorder));
      });
    });

    group('Factory Constructors', () {
      test('all factory creates BorderMix with same side for all', () {
        final side = BorderSideMix(color: Colors.purple, width: 3.0);
        final borderMix = BorderMix.all(side);

        // All sides should contain the same BorderSideMix
        expect(borderMix.$top, PropMatcher.isMix(side));
        expect(borderMix.$right, PropMatcher.isMix(side));
        expect(borderMix.$bottom, PropMatcher.isMix(side));
        expect(borderMix.$left, PropMatcher.isMix(side));
      });

      test(
        'symmetric factory creates BorderMix with vertical and horizontal',
        () {
          final vertical = BorderSideMix(color: Colors.red, width: 2.0);
          final horizontal = BorderSideMix(color: Colors.blue, width: 3.0);
          final borderMix = BorderMix.symmetric(
            vertical: vertical,
            horizontal: horizontal,
          );

          // Check horizontal and vertical sides
          expect(borderMix.$top, PropMatcher.isMix(horizontal));
          expect(borderMix.$right, PropMatcher.isMix(vertical));
          expect(borderMix.$bottom, PropMatcher.isMix(horizontal));
          expect(borderMix.$left, PropMatcher.isMix(vertical));
        },
      );

      test('only factory creates BorderMix with specified sides', () {
        final topSide = BorderSideMix(color: Colors.red, width: 1.0);
        final bottomSide = BorderSideMix(color: Colors.blue, width: 2.0);

        final borderMix = BorderMix(top: topSide, bottom: bottomSide);

        // Check that the top and bottom sides are properly set
        expect(borderMix.$top, PropMatcher.isMix(topSide));
        expect(borderMix.$right, isNull);
        expect(borderMix.$bottom, PropMatcher.isMix(bottomSide));
        expect(borderMix.$left, isNull);
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = BorderMix(
          top: BorderSideMix(color: Colors.red, width: 1.0),
          right: BorderSideMix(color: Colors.green, width: 2.0),
        );

        final second = BorderMix(
          right: BorderSideMix(color: Colors.blue, width: 3.0),
          bottom: BorderSideMix(color: Colors.yellow, width: 4.0),
        );

        final merged = first.merge(second);

        // Verify merged border resolves correctly
        final resolved = merged.resolve(MockBuildContext());

        // Top from first (unchanged)
        expect(resolved.top.color, Colors.red);
        expect(resolved.top.width, 1.0);

        // Right from second (overrides first)
        expect(resolved.right.color, Colors.blue);
        expect(resolved.right.width, 3.0);

        // Bottom from second (new)
        expect(resolved.bottom.color, Colors.yellow);
        expect(resolved.bottom.width, 4.0);

        // Left is none
        expect(resolved.left, BorderSide.none);
      });

      test('returns equivalent instance when other is null', () {
        final borderMix = BorderMix(top: BorderSideMix(color: Colors.red));
        final merged = borderMix.merge(null);

        expect(identical(borderMix, merged), isFalse);
        expect(merged, equals(borderMix));
      });
    });

    group('Equality', () {
      test('equal borders have same hashCode', () {
        final side = BorderSideMix(color: Colors.red, width: 2.0);
        final border1 = BorderMix(top: side, right: side);
        final border2 = BorderMix(top: side, right: side);

        expect(border1, equals(border2));
        expect(border1.hashCode, equals(border2.hashCode));
      });

      test('different borders are not equal', () {
        final border1 = BorderMix(top: BorderSideMix(color: Colors.red));
        final border2 = BorderMix(top: BorderSideMix(color: Colors.blue));

        expect(border1, isNot(equals(border2)));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final borderMix = BorderMix(
          top: BorderSideMix(color: Colors.red),
          right: BorderSideMix(color: Colors.green),
          bottom: BorderSideMix(color: Colors.blue),
          left: BorderSideMix(color: Colors.yellow),
        );

        expect(borderMix.props.length, 4);
        expect(borderMix.props, contains(borderMix.$top));
        expect(borderMix.props, contains(borderMix.$right));
        expect(borderMix.props, contains(borderMix.$bottom));
        expect(borderMix.props, contains(borderMix.$left));
      });
    });

    group('Default Value', () {
      test('has correct default value', () {
        final borderMix = BorderMix();

        expect(borderMix.defaultValue, const Border());
      });
    });
  });
}
