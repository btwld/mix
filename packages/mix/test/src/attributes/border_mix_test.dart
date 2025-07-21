import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  // BorderSideMix tests - Test this first as it's a dependency
  group('BorderSideMix', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('only constructor creates BorderSideMix with all properties', () {
        final mix = BorderSideMix.only(
          color: Colors.red,
          style: BorderStyle.solid,
          width: 2.0,
          strokeAlign: BorderSide.strokeAlignCenter,
        );

        expect(mix.color, resolvesTo(Colors.red));
        expect(mix.style, resolvesTo(BorderStyle.solid));
        expect(mix.width, resolvesTo(2.0));
        expect(mix.strokeAlign, resolvesTo(BorderSide.strokeAlignCenter));
      });

      test('value constructor from BorderSide', () {
        const borderSide = BorderSide(
          color: Colors.blue,
          width: 3.0,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignInside,
        );

        final mix = BorderSideMix.value(borderSide);

        expect(mix.color, resolvesTo(borderSide.color));
        expect(mix.width, resolvesTo(borderSide.width));
        expect(mix.style, resolvesTo(borderSide.style));
        expect(mix.strokeAlign, resolvesTo(borderSide.strokeAlign));
      });

      test('main constructor with Prop values', () {
        final mix = BorderSideMix(
          color: Prop(Colors.green),
          width: Prop(4.0),
          style: Prop(BorderStyle.none),
          strokeAlign: Prop(BorderSide.strokeAlignOutside),
        );

        expect(mix.color, resolvesTo(Colors.green));
        expect(mix.width, resolvesTo(4.0));
        expect(mix.style, resolvesTo(BorderStyle.none));
        expect(mix.strokeAlign, resolvesTo(BorderSide.strokeAlignOutside));
      });

      test('none constant creates BorderSideMix with default values', () {
        final mix = BorderSideMix.none;

        final resolved = mix.resolve(MockBuildContext());
        expect(resolved, const BorderSide());
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns BorderSideMix for non-null BorderSide', () {
        const borderSide = BorderSide(color: Colors.red, width: 2.0);
        final mix = BorderSideMix.maybeValue(borderSide);

        expect(mix, isNotNull);
        expect(mix?.color, resolvesTo(Colors.red));
        expect(mix?.width, resolvesTo(2.0));
      });

      test('maybeValue returns null for null BorderSide', () {
        final mix = BorderSideMix.maybeValue(null);
        expect(mix, isNull);
      });

      test('maybeValue returns null for BorderSide.none', () {
        final mix = BorderSideMix.maybeValue(BorderSide.none);
        expect(mix, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves all properties correctly', () {
        final mix = BorderSideMix.only(
          color: Colors.purple,
          width: 5.0,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignCenter,
        );

        expect(
          dto,
          resolvesTo(
            const BorderSide(
              color: Colors.purple,
              width: 5.0,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        const dto = BorderSideMix();

        final resolved = mix.resolve(MockBuildContext());
        expect(resolved.color, const BorderSide().color);
        expect(resolved.width, const BorderSide().width);
        expect(resolved.style, const BorderSide().style);
        expect(resolved.strokeAlign, const BorderSide().strokeAlign);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another BorderSideMix - all properties', () {
        final mix1 = BorderSideMix.only(
          color: Colors.red,
          style: BorderStyle.solid,
          width: 1.0,
          strokeAlign: BorderSide.strokeAlignInside,
        );

        final mix2 = BorderSideMix.only(
          color: Colors.blue,
          style: BorderStyle.none,
          width: 2.0,
          strokeAlign: BorderSide.strokeAlignOutside,
        );

        final merged = dto1.merge(mix2);

        expect(merged.color, resolvesTo(Colors.blue));
        expect(merged.style, resolvesTo(BorderStyle.none));
        expect(merged.width, resolvesTo(2.0));
        expect(merged.strokeAlign, resolvesTo(BorderSide.strokeAlignOutside));
      });

      test('merge with partial properties', () {
        final mix1 = BorderSideMix.only(color: Colors.red, width: 1.0);

        final mix2 = BorderSideMix.only(width: 2.0, style: BorderStyle.solid);

        final merged = dto1.merge(mix2);

        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.width, resolvesTo(2.0));
        expect(merged.style, resolvesTo(BorderStyle.solid));
      });

      test('merge with null returns original', () {
        final mix = BorderSideMix.only(color: Colors.green, width: 3.0);

        final merged = mix.merge(null);
        expect(merged, same(mix));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal BorderSideMixs', () {
        final mix1 = BorderSideMix.only(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignCenter,
        );

        final mix2 = BorderSideMix.only(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignCenter,
        );

        expect(mix1, equals(mix2));
        expect(mix1.hashCode, equals(mix2.hashCode));
      });

      test('not equal BorderSideMixs', () {
        final mix1 = BorderSideMix.only(color: Colors.red);
        final mix2 = BorderSideMix.only(color: Colors.blue);

        expect(mix1, isNot(equals(mix2)));
      });
    });
  });

  // BorderMix tests
  group('BorderMix', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('only constructor creates BorderMix with all sides', () {
        final mix = BorderMix.only(
          top: BorderSideMix.only(width: 1.0),
          bottom: BorderSideMix.only(width: 2.0),
          left: BorderSideMix.only(width: 3.0),
          right: BorderSideMix.only(width: 4.0),
        );

        final resolved = mix.resolve(MockBuildContext());
        expect(resolved.top.width, 1.0);
        expect(resolved.bottom.width, 2.0);
        expect(resolved.left.width, 3.0);
        expect(resolved.right.width, 4.0);
      });

      test('main constructor with MixProp values', () {
        final mix = BorderMix(
          top: MixProp(BorderSideMix.only(width: 1.0)),
          bottom: MixProp(BorderSideMix.only(width: 2.0)),
          left: MixProp(BorderSideMix.only(width: 3.0)),
          right: MixProp(BorderSideMix.only(width: 4.0)),
        );

        final resolved = mix.resolve(MockBuildContext());
        expect(resolved.top.width, 1.0);
        expect(resolved.bottom.width, 2.0);
        expect(resolved.left.width, 3.0);
        expect(resolved.right.width, 4.0);
      });

      test('all constructor creates uniform BorderMix', () {
        final side = BorderSideMix.only(color: Colors.red, width: 2.0);
        final mix = BorderMix.all(side);

        const expectedSide = BorderSide(color: Colors.red, width: 2.0);
        expect(mix.top, resolvesTo(expectedSide));
        expect(mix.bottom, resolvesTo(expectedSide));
        expect(mix.left, resolvesTo(expectedSide));
        expect(mix.right, resolvesTo(expectedSide));
        expect(mix.isUniform, isTrue);
      });

      test('symmetric constructor', () {
        final vertical = BorderSideMix.only(color: Colors.red);
        final horizontal = BorderSideMix.only(color: Colors.blue);

        final mix = BorderMix.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        );

        const expectedVertical = BorderSide(color: Colors.red);
        const expectedHorizontal = BorderSide(color: Colors.blue);
        expect(mix.left, resolvesTo(expectedVertical));
        expect(mix.right, resolvesTo(expectedVertical));
        expect(mix.top, resolvesTo(expectedHorizontal));
        expect(mix.bottom, resolvesTo(expectedHorizontal));
      });

      test('vertical constructor', () {
        final side = BorderSideMix.only(width: 2.0);
        final mix = BorderMix.vertical(side);

        const expectedSide = BorderSide(width: 2.0);
        expect(mix.left, resolvesTo(expectedSide));
        expect(mix.right, resolvesTo(expectedSide));
        expect(mix.top, isNull);
        expect(mix.bottom, isNull);
      });

      test('horizontal constructor', () {
        final side = BorderSideMix.only(width: 3.0);
        final mix = BorderMix.horizontal(side);

        const expectedSide = BorderSide(width: 3.0);
        expect(mix.top, resolvesTo(expectedSide));
        expect(mix.bottom, resolvesTo(expectedSide));
        expect(mix.left, isNull);
        expect(mix.right, isNull);
      });

      test('value constructor from Border', () {
        const border = Border(
          top: BorderSide(color: Colors.red, width: 1.0),
          bottom: BorderSide(color: Colors.blue, width: 2.0),
          left: BorderSide(color: Colors.green, width: 3.0),
          right: BorderSide(color: Colors.yellow, width: 4.0),
        );

        final mix = BorderMix.value(border);

        expect(
          mix.top,
          resolvesTo(const BorderSide(color: Colors.red, width: 1.0)),
        );
        expect(
          mix.bottom,
          resolvesTo(const BorderSide(color: Colors.blue, width: 2.0)),
        );
        expect(
          mix.left,
          resolvesTo(const BorderSide(color: Colors.green, width: 3.0)),
        );
        expect(
          mix.right,
          resolvesTo(const BorderSide(color: Colors.yellow, width: 4.0)),
        );
      });

      test('none constant', () {
        final none = BorderMix.none;
        expect(none.top, resolvesTo(BorderSide.none));
        expect(none.bottom, resolvesTo(BorderSide.none));
        expect(none.left, resolvesTo(BorderSide.none));
        expect(none.right, resolvesTo(BorderSide.none));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns BorderMix for non-null Border', () {
        final border = Border.all(color: Colors.red, width: 2.0);
        final mix = BorderMix.maybeValue(border);

        expect(mix, isNotNull);
        expect(
          dto?.top,
          resolvesTo(const BorderSide(color: Colors.red, width: 2.0)),
        );
      });

      test('maybeValue returns null for null Border', () {
        final mix = BorderMix.maybeValue(null);
        expect(mix, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to Border with all sides', () {
        final mix = BorderMix.only(
          top: BorderSideMix.only(width: 5.0),
          bottom: BorderSideMix.only(width: 10.0),
          left: BorderSideMix.only(width: 15.0),
          right: BorderSideMix.only(width: 20.0),
        );

        expect(
          dto,
          resolvesTo(
            const Border(
              top: BorderSide(width: 5.0),
              bottom: BorderSide(width: 10.0),
              left: BorderSide(width: 15.0),
              right: BorderSide(width: 20.0),
            ),
          ),
        );
      });

      test('resolves with default values for missing sides', () {
        final mix = BorderMix.only(
          top: BorderSideMix.only(width: 5.0),
          left: BorderSideMix.only(width: 15.0),
        );

        expect(
          dto,
          resolvesTo(
            const Border(
              top: BorderSide(width: 5.0),
              bottom: BorderSide.none,
              left: BorderSide(width: 15.0),
              right: BorderSide.none,
            ),
          ),
        );
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another BorderMix', () {
        final mix1 = BorderMix.only(
          top: BorderSideMix.only(color: Colors.red, width: 1.0),
          bottom: BorderSideMix.only(color: Colors.red, width: 1.0),
          left: BorderSideMix.only(color: Colors.red, width: 1.0),
          right: BorderSideMix.only(color: Colors.red, width: 1.0),
        );

        final mix2 = BorderMix.only(
          top: BorderSideMix.only(width: 2.0),
          bottom: BorderSideMix.only(width: 2.0),
          left: BorderSideMix.only(width: 2.0),
          right: BorderSideMix.only(width: 2.0),
        );

        final merged = dto1.merge(mix2);

        expect(
          merged.top,
          resolvesTo(const BorderSide(color: Colors.red, width: 2.0)),
        );
        expect(
          merged.bottom,
          resolvesTo(const BorderSide(color: Colors.red, width: 2.0)),
        );
        expect(
          merged.left,
          resolvesTo(const BorderSide(color: Colors.red, width: 2.0)),
        );
        expect(
          merged.right,
          resolvesTo(const BorderSide(color: Colors.red, width: 2.0)),
        );
      });

      test('merge with null returns original', () {
        final mix = BorderMix.all(BorderSideMix.only(width: 1.0));
        final merged = mix.merge(null);

        expect(merged, same(mix));
      });
    });

    // Property Tests
    group('Property Tests', () {
      test('isDirectional returns false', () {
        final mix = BorderMix();
        expect(mix.isDirectional, isFalse);
      });

      test('isUniform with all sides equal', () {
        final side = BorderSideMix.only(width: 2.0);
        final mix = BorderMix.all(side);
        expect(mix.isUniform, isTrue);
      });

      test('isUniform with different sides', () {
        final mix = BorderMix.only(
          top: BorderSideMix.only(width: 1.0),
          bottom: BorderSideMix.only(width: 2.0),
        );
        expect(mix.isUniform, isFalse);
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal BorderMixs', () {
        final mix1 = BorderMix.only(
          top: BorderSideMix.only(width: 1.0),
          bottom: BorderSideMix.only(width: 2.0),
          left: BorderSideMix.only(width: 3.0),
          right: BorderSideMix.only(width: 4.0),
        );

        final mix2 = BorderMix.only(
          top: BorderSideMix.only(width: 1.0),
          bottom: BorderSideMix.only(width: 2.0),
          left: BorderSideMix.only(width: 3.0),
          right: BorderSideMix.only(width: 4.0),
        );

        expect(mix1, equals(mix2));
        expect(mix1.hashCode, equals(mix2.hashCode));
      });

      test('not equal BorderMixs', () {
        final mix1 = BorderMix.only(top: BorderSideMix.only(width: 1.0));
        final mix2 = BorderMix.only(top: BorderSideMix.only(width: 2.0));

        expect(mix1, isNot(equals(mix2)));
      });
    });
  });

  // BorderDirectionalMix tests
  group('BorderDirectionalMix', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('only constructor creates BorderDirectionalMix with all sides', () {
        final mix = BorderDirectionalMix.only(
          top: BorderSideMix.only(width: 1.0),
          bottom: BorderSideMix.only(width: 2.0),
          start: BorderSideMix.only(width: 3.0),
          end: BorderSideMix.only(width: 4.0),
        );

        expect(mix.top, resolvesTo(const BorderSide(width: 1.0)));
        expect(mix.bottom, resolvesTo(const BorderSide(width: 2.0)));
        expect(mix.start, resolvesTo(const BorderSide(width: 3.0)));
        expect(mix.end, resolvesTo(const BorderSide(width: 4.0)));
      });

      test('main constructor with MixProp values', () {
        final mix = BorderDirectionalMix(
          top: MixProp(BorderSideMix.only(width: 1.0)),
          bottom: MixProp(BorderSideMix.only(width: 2.0)),
          start: MixProp(BorderSideMix.only(width: 3.0)),
          end: MixProp(BorderSideMix.only(width: 4.0)),
        );

        expect(mix.top, resolvesTo(const BorderSide(width: 1.0)));
        expect(mix.bottom, resolvesTo(const BorderSide(width: 2.0)));
        expect(mix.start, resolvesTo(const BorderSide(width: 3.0)));
        expect(mix.end, resolvesTo(const BorderSide(width: 4.0)));
      });

      test('all constructor creates uniform BorderDirectionalMix', () {
        final side = BorderSideMix.only(color: Colors.red, width: 2.0);
        final mix = BorderDirectionalMix.all(side);

        const expectedSide = BorderSide(color: Colors.red, width: 2.0);
        expect(mix.top, resolvesTo(expectedSide));
        expect(mix.bottom, resolvesTo(expectedSide));
        expect(mix.start, resolvesTo(expectedSide));
        expect(mix.end, resolvesTo(expectedSide));
        expect(mix.isUniform, isTrue);
      });

      test('symmetric constructor', () {
        final vertical = BorderSideMix.only(color: Colors.red);
        final horizontal = BorderSideMix.only(color: Colors.blue);

        final mix = BorderDirectionalMix.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        );

        const expectedVertical = BorderSide(color: Colors.red);
        const expectedHorizontal = BorderSide(color: Colors.blue);
        expect(mix.start, resolvesTo(expectedVertical));
        expect(mix.end, resolvesTo(expectedVertical));
        expect(mix.top, resolvesTo(expectedHorizontal));
        expect(mix.bottom, resolvesTo(expectedHorizontal));
      });

      test('value constructor from BorderDirectional', () {
        const border = BorderDirectional(
          top: BorderSide(color: Colors.red, width: 1.0),
          bottom: BorderSide(color: Colors.blue, width: 2.0),
          start: BorderSide(color: Colors.green, width: 3.0),
          end: BorderSide(color: Colors.yellow, width: 4.0),
        );

        final mix = BorderDirectionalMix.value(border);

        expect(
          mix.top,
          resolvesTo(const BorderSide(color: Colors.red, width: 1.0)),
        );
        expect(
          mix.bottom,
          resolvesTo(const BorderSide(color: Colors.blue, width: 2.0)),
        );
        expect(
          mix.start,
          resolvesTo(const BorderSide(color: Colors.green, width: 3.0)),
        );
        expect(
          mix.end,
          resolvesTo(const BorderSide(color: Colors.yellow, width: 4.0)),
        );
      });

      test('none constant', () {
        final none = BorderDirectionalMix.none;
        expect(none.top, resolvesTo(BorderSide.none));
        expect(none.bottom, resolvesTo(BorderSide.none));
        expect(none.start, resolvesTo(BorderSide.none));
        expect(none.end, resolvesTo(BorderSide.none));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns BorderDirectionalMix for non-null', () {
        const border = BorderDirectional(
          top: BorderSide(color: Colors.red),
          bottom: BorderSide(color: Colors.red),
          start: BorderSide(color: Colors.red),
          end: BorderSide(color: Colors.red),
        );
        final mix = BorderDirectionalMix.maybeValue(border);

        expect(mix, isNotNull);
        expect(
          dto?.top,
          resolvesTo(const BorderSide(color: Colors.red, width: 2.0)),
        );
      });

      test('maybeValue returns null for null', () {
        final mix = BorderDirectionalMix.maybeValue(null);
        expect(mix, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to BorderDirectional', () {
        final mix = BorderDirectionalMix.only(
          top: BorderSideMix.only(width: 5.0),
          bottom: BorderSideMix.only(width: 10.0),
          start: BorderSideMix.only(width: 15.0),
          end: BorderSideMix.only(width: 20.0),
        );

        expect(
          dto,
          resolvesTo(
            const BorderDirectional(
              top: BorderSide(width: 5.0),
              bottom: BorderSide(width: 10.0),
              start: BorderSide(width: 15.0),
              end: BorderSide(width: 20.0),
            ),
          ),
        );
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another BorderDirectionalMix', () {
        final mix1 = BorderDirectionalMix.only(
          top: BorderSideMix.only(color: Colors.red),
          start: BorderSideMix.only(width: 1.0),
        );

        final mix2 = BorderDirectionalMix.only(
          top: BorderSideMix.only(width: 2.0),
          end: BorderSideMix.only(color: Colors.blue),
        );

        final merged = dto1.merge(mix2);

        expect(
          merged.top,
          resolvesTo(const BorderSide(color: Colors.red, width: 2.0)),
        );
        expect(merged.start, resolvesTo(const BorderSide(width: 1.0)));
        expect(merged.end, resolvesTo(const BorderSide(color: Colors.blue)));
      });
    });

    // Property Tests
    group('Property Tests', () {
      test('isDirectional returns true', () {
        final mix = BorderDirectionalMix();
        expect(mix.isDirectional, isTrue);
      });

      test('isUniform with all sides equal', () {
        final side = BorderSideMix.only(width: 2.0);
        final mix = BorderDirectionalMix.all(side);
        expect(mix.isUniform, isTrue);
      });
    });
  });

  // BoxBorderMix cross-type tests
  group('BoxBorderMix cross-type tests', () {
    test('tryToMerge with BorderMix and BorderDirectionalMix', () {
      final borderMix = BorderMix.all(
        BorderSideMix.only(color: Colors.yellow, width: 3.0),
      );

      final borderDirectionalDto = BorderDirectionalMix.only(
        top: BorderSideMix.only(color: Colors.green),
        bottom: BorderSideMix.only(width: 4.0),
        start: BorderSideMix.only(color: Colors.red, width: 1.0),
        end: BorderSideMix.only(color: Colors.blue, width: 2.0),
      );

      final merged =
          BoxBorderMix.tryToMerge(borderMix, borderDirectionalDto)
              as BorderDirectionalMix?;

      expect(
        merged?.top,
        resolvesTo(const BorderSide(color: Colors.green, width: 3.0)),
      );
      expect(
        merged?.bottom,
        resolvesTo(const BorderSide(color: Colors.yellow, width: 4.0)),
      );
      expect(
        merged?.start,
        resolvesTo(const BorderSide(color: Colors.red, width: 1.0)),
      );
      expect(
        merged?.end,
        resolvesTo(const BorderSide(color: Colors.blue, width: 2.0)),
      );
    });

    test('tryToMerge with BorderDirectionalMix and BorderMix', () {
      final borderDirectionalDto = BorderDirectionalMix.only(
        top: BorderSideMix.only(color: Colors.green),
        start: BorderSideMix.only(width: 1.0),
      );

      final borderMix = BorderMix.only(
        top: BorderSideMix.only(width: 3.0),
        left: BorderSideMix.only(color: Colors.red),
      );

      final merged =
          BoxBorderMix.tryToMerge(borderDirectionalDto, borderMix)
              as BorderMix?;

      expect(
        merged?.top,
        resolvesTo(const BorderSide(color: Colors.green, width: 3.0)),
      );
      expect(merged?.left, resolvesTo(const BorderSide(color: Colors.red)));
    });

    test('tryToMerge with null values', () {
      final mix = BorderMix.all(BorderSideMix.only(width: 1.0));

      expect(BoxBorderMix.tryToMerge(mix, null), same(mix));
      expect(BoxBorderMix.tryToMerge(null, dto), same(mix));
      expect(BoxBorderMix.tryToMerge(null, null), isNull);
    });

    test('value factory with Border', () {
      final border = Border.all(color: Colors.red);
      final mix = BoxBorderMix.value(border);

      expect(mix, isA<BorderMix>());
      expect(
        (mix as BorderMix).top,
        resolvesTo(const BorderSide(color: Colors.red)),
      );
    });

    test('value factory with BorderDirectional', () {
      const border = BorderDirectional(
        top: BorderSide(color: Colors.blue),
        bottom: BorderSide(color: Colors.blue),
        start: BorderSide(color: Colors.blue),
        end: BorderSide(color: Colors.blue),
      );
      final mix = BoxBorderMix.value(border);

      expect(mix, isA<BorderDirectionalMix>());
      expect(
        (mix as BorderDirectionalMix).top,
        resolvesTo(const BorderSide(color: Colors.blue)),
      );
    });

    test('maybeValue factory', () {
      final border = Border.all(color: Colors.red);
      final mix = BoxBorderMix.maybeValue(border);

      expect(mix, isNotNull);
      expect(mix, isA<BorderMix>());

      final nullDto = BoxBorderMix.maybeValue(null);
      expect(nullDto, isNull);
    });
  });
}
