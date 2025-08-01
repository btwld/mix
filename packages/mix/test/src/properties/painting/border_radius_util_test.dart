import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

// Test class that extends MockStyle and uses BorderRadiusMixin
class TestBorderRadiusStyle extends MockStyle<BorderRadiusGeometryMix>
    with BorderRadiusMixin<TestBorderRadiusStyle> {
  TestBorderRadiusStyle([BorderRadiusGeometryMix? value])
    : super(value ?? BorderRadiusMix());

  @override
  TestBorderRadiusStyle borderRadius(BorderRadiusGeometryMix value) {
    return TestBorderRadiusStyle(value);
  }
}

void main() {
  group('BorderRadiusMixin', () {
    late TestBorderRadiusStyle style;

    setUp(() {
      style = TestBorderRadiusStyle();
    });

    group('corners method', () {
      test('sets all corners with all parameter', () {
        final result = style.corners(all: const Radius.circular(10.0));

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(borderRadius, BorderRadius.circular(10.0));
      });

      test('sets horizontal corners', () {
        final result = style.corners(horizontal: const Radius.circular(8.0));

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(borderRadius, BorderRadius.circular(8.0));
      });

      test('sets vertical corners', () {
        final result = style.corners(vertical: const Radius.circular(12.0));

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(borderRadius, BorderRadius.circular(12.0));
      });

      test('sets top edge corners', () {
        final result = style.corners(top: const Radius.circular(5.0));

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(
          borderRadius,
          const BorderRadius.vertical(
            top: Radius.circular(5.0),
          ),
        );
      });

      test('sets bottom edge corners', () {
        final result = style.corners(bottom: const Radius.circular(15.0));

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(
          borderRadius,
          const BorderRadius.vertical(
            bottom: Radius.circular(15.0),
          ),
        );
      });

      test('sets left side corners (physical)', () {
        final result = style.corners(left: const Radius.circular(7.0));

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(
          borderRadius,
          const BorderRadius.horizontal(
            left: Radius.circular(7.0),
          ),
        );
      });

      test('sets right side corners (physical)', () {
        final result = style.corners(right: const Radius.circular(9.0));

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(
          borderRadius,
          const BorderRadius.horizontal(
            right: Radius.circular(9.0),
          ),
        );
      });

      test('sets start side corners (logical)', () {
        final result = style.corners(start: const Radius.circular(6.0));

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(
          borderRadius,
          const BorderRadius.horizontal(
            left: Radius.circular(6.0),
          ),
        );
      });

      test('sets end side corners (logical)', () {
        final result = style.corners(end: const Radius.circular(11.0));

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(
          borderRadius,
          const BorderRadius.horizontal(
            right: Radius.circular(11.0),
          ),
        );
      });

      test('sets individual physical corners', () {
        final result = style.corners(
          topLeft: const Radius.circular(1.0),
          topRight: const Radius.circular(2.0),
          bottomLeft: const Radius.circular(3.0),
          bottomRight: const Radius.circular(4.0),
        );

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(
          borderRadius,
          const BorderRadius.only(
            topLeft: Radius.circular(1.0),
            topRight: Radius.circular(2.0),
            bottomLeft: Radius.circular(3.0),
            bottomRight: Radius.circular(4.0),
          ),
        );
      });

      test('sets individual logical corners', () {
        final result = style.corners(
          topStart: const Radius.circular(1.0),
          topEnd: const Radius.circular(2.0),
          bottomStart: const Radius.circular(3.0),
          bottomEnd: const Radius.circular(4.0),
        );

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(
          borderRadius,
          const BorderRadius.only(
            topLeft: Radius.circular(1.0),
            topRight: Radius.circular(2.0),
            bottomLeft: Radius.circular(3.0),
            bottomRight: Radius.circular(4.0),
          ),
        );
      });

      test('priority order: specific corners override edges', () {
        final result = style.corners(
          all: const Radius.circular(10.0),
          top: const Radius.circular(20.0),
          topLeft: const Radius.circular(30.0),
        );

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(
          borderRadius,
          const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        );
      });

      test('priority order: horizontal/vertical override all', () {
        final result = style.corners(
          all: const Radius.circular(5.0),
          horizontal: const Radius.circular(10.0),
          vertical: const Radius.circular(15.0),
        );

        final borderRadius = result.value.resolve(MockBuildContext());

        // vertical applied last, so it wins
        expect(borderRadius, BorderRadius.circular(15.0));
      });

      test('throws error when mixing physical and logical sides', () {
        expect(
          () => style.corners(
            left: const Radius.circular(5.0),
            start: const Radius.circular(10.0),
          ),
          throwsArgumentError,
        );
      });

      test('throws error when mixing physical and logical corners', () {
        expect(
          () => style.corners(
            topLeft: const Radius.circular(5.0),
            topStart: const Radius.circular(10.0),
          ),
          throwsArgumentError,
        );
      });

      test('allows physical sides with physical corners', () {
        expect(
          () => style.corners(
            left: const Radius.circular(5.0),
            topLeft: const Radius.circular(10.0),
          ),
          returnsNormally,
        );
      });

      test('allows logical sides with logical corners', () {
        expect(
          () => style.corners(
            start: const Radius.circular(5.0),
            topStart: const Radius.circular(10.0),
          ),
          returnsNormally,
        );
      });
    });

    group('rounded method', () {
      test('sets all corners with circular radius', () {
        final result = style.rounded(all: 10.0);

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(borderRadius, BorderRadius.circular(10.0));
      });

      test('converts double values to Radius.circular', () {
        final result = style.rounded(
          topLeft: 1.0,
          topRight: 2.0,
          bottomLeft: 3.0,
          bottomRight: 4.0,
        );

        final borderRadius = result.value.resolve(MockBuildContext());

        expect(
          borderRadius,
          const BorderRadius.only(
            topLeft: Radius.circular(1.0),
            topRight: Radius.circular(2.0),
            bottomLeft: Radius.circular(3.0),
            bottomRight: Radius.circular(4.0),
          ),
        );
      });

      test('delegates to corners method', () {
        final result = style.rounded(
          horizontal: 8.0,
          vertical: 12.0,
          top: 16.0,
        );

        final borderRadius = result.value.resolve(MockBuildContext());

        // top overrides vertical for top corners
        expect(
          borderRadius,
          const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
            bottomLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
        );
      });
    });
  });

  group('BorderRadiusGeometryUtility', () {
    late BorderRadiusGeometryUtility<MockStyle<BorderRadiusGeometryMix>> util;

    setUp(() {
      util = BorderRadiusGeometryUtility<MockStyle<BorderRadiusGeometryMix>>(
        (mix) => MockStyle(mix),
      );
    });

    test('has borderRadiusDirectional property', () {
      expect(
        util.borderRadiusDirectional,
        isA<BorderRadiusDirectionalUtility>(),
      );
    });

    test('has borderRadius property', () {
      expect(util.borderRadius, isA<BorderRadiusUtility>());
    });

    test('call method creates circular BorderRadiusMix', () {
      final result = util(10.0);
      final borderRadius = result.value as BorderRadiusMix;
      final resolved = borderRadius.resolve(MockBuildContext());

      expect(resolved, BorderRadius.circular(10.0));
    });

    test('as method accepts BorderRadiusGeometry', () {
      const borderRadius = BorderRadius.only(
        topLeft: Radius.circular(5.0),
        bottomRight: Radius.circular(15.0),
      );
      final result = util.as(borderRadius);
      final borderRadiusMix = result.value as BorderRadiusMix;
      final resolved = borderRadiusMix.resolve(MockBuildContext());

      expect(resolved, equals(borderRadius));
    });
  });

  group('BorderRadiusUtility', () {
    late BorderRadiusUtility<MockStyle<BorderRadiusMix>> util;

    setUp(() {
      util = BorderRadiusUtility<MockStyle<BorderRadiusMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('corner utilities', () {
      test('topLeft utility creates correct BorderRadiusMix', () {
        final result = util.topLeft(const Radius.circular(5.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          const BorderRadius.only(topLeft: Radius.circular(5.0)),
        );
      });

      test('topRight utility creates correct BorderRadiusMix', () {
        final result = util.topRight(const Radius.circular(10.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          const BorderRadius.only(topRight: Radius.circular(10.0)),
        );
      });

      test('bottomLeft utility creates correct BorderRadiusMix', () {
        final result = util.bottomLeft(const Radius.circular(15.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          const BorderRadius.only(bottomLeft: Radius.circular(15.0)),
        );
      });

      test('bottomRight utility creates correct BorderRadiusMix', () {
        final result = util.bottomRight(const Radius.circular(20.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          const BorderRadius.only(bottomRight: Radius.circular(20.0)),
        );
      });

      test('all utility sets all corners', () {
        final result = util.all(const Radius.circular(8.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(resolved, BorderRadius.circular(8.0));
      });

      test('top utility sets top corners', () {
        final result = util.top(const Radius.circular(12.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          const BorderRadius.vertical(
            top: Radius.circular(12.0),
          ),
        );
      });

      test('bottom utility sets bottom corners', () {
        final result = util.bottom(const Radius.circular(16.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          const BorderRadius.vertical(
            bottom: Radius.circular(16.0),
          ),
        );
      });

      test('left utility sets left corners', () {
        final result = util.left(const Radius.circular(4.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          const BorderRadius.horizontal(
            left: Radius.circular(4.0),
          ),
        );
      });

      test('right utility sets right corners', () {
        final result = util.right(const Radius.circular(6.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          const BorderRadius.horizontal(
            right: Radius.circular(6.0),
          ),
        );
      });
    });

    group('convenience methods', () {
      test('circular method sets circular radius for all corners', () {
        final result = util.circular(10.0);
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(resolved, BorderRadius.circular(10.0));
      });

      test('elliptical method sets elliptical radius for all corners', () {
        final result = util.elliptical(8.0, 12.0);
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          BorderRadius.all(const Radius.elliptical(8.0, 12.0)),
        );
      });

      test('zero method sets zero radius for all corners', () {
        final result = util.zero();
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(resolved, BorderRadius.zero);
      });
    });

    group('only and call methods', () {
      test('only method sets specified corners', () {
        final result = util.only(
          topLeft: const Radius.circular(5.0),
          bottomRight: const Radius.circular(15.0),
        );
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          const BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(15.0),
          ),
        );
      });

      test('call method delegates to only', () {
        final result = util.only(
          topRight: const Radius.circular(8.0),
          bottomLeft: const Radius.circular(12.0),
        );
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          const BorderRadius.only(
            topRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(12.0),
          ),
        );
      });
    });

    test('as method accepts BorderRadius', () {
      const borderRadius = BorderRadius.only(
        topLeft: Radius.circular(3.0),
        topRight: Radius.circular(6.0),
        bottomLeft: Radius.circular(9.0),
        bottomRight: Radius.circular(12.0),
      );
      final result = util.as(borderRadius);
      final borderRadiusMix = result.value;
      final resolved = borderRadiusMix.resolve(MockBuildContext());

      expect(resolved, equals(borderRadius));
    });
  });

  group('BorderRadiusDirectionalUtility', () {
    late BorderRadiusDirectionalUtility<MockStyle<BorderRadiusDirectionalMix>>
    util;

    setUp(() {
      util =
          BorderRadiusDirectionalUtility<MockStyle<BorderRadiusDirectionalMix>>(
            (mix) => MockStyle(mix),
          );
    });

    group('corner utilities', () {
      test('topStart utility creates correct BorderRadiusDirectionalMix', () {
        final result = util.topStart(const Radius.circular(5.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(resolved.topStart, const Radius.circular(5.0));
        expect(resolved.topEnd, Radius.zero);
        expect(resolved.bottomStart, Radius.zero);
        expect(resolved.bottomEnd, Radius.zero);
      });

      test('topEnd utility creates correct BorderRadiusDirectionalMix', () {
        final result = util.topEnd(const Radius.circular(10.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(resolved.topStart, Radius.zero);
        expect(resolved.topEnd, const Radius.circular(10.0));
        expect(resolved.bottomStart, Radius.zero);
        expect(resolved.bottomEnd, Radius.zero);
      });

      test(
        'bottomStart utility creates correct BorderRadiusDirectionalMix',
        () {
          final result = util.bottomStart(const Radius.circular(15.0));
          final borderRadius = result.value;
          final resolved = borderRadius.resolve(MockBuildContext());

          expect(resolved.topStart, Radius.zero);
          expect(resolved.topEnd, Radius.zero);
          expect(resolved.bottomStart, const Radius.circular(15.0));
          expect(resolved.bottomEnd, Radius.zero);
        },
      );

      test('bottomEnd utility creates correct BorderRadiusDirectionalMix', () {
        final result = util.bottomEnd(const Radius.circular(20.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(resolved.topStart, Radius.zero);
        expect(resolved.topEnd, Radius.zero);
        expect(resolved.bottomStart, Radius.zero);
        expect(resolved.bottomEnd, const Radius.circular(20.0));
      });

      test('all utility sets all corners', () {
        final result = util.all(const Radius.circular(8.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(resolved.topStart, const Radius.circular(8.0));
        expect(resolved.topEnd, const Radius.circular(8.0));
        expect(resolved.bottomStart, const Radius.circular(8.0));
        expect(resolved.bottomEnd, const Radius.circular(8.0));
      });

      test('top utility sets top corners', () {
        final result = util.top(const Radius.circular(12.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(resolved.topStart, const Radius.circular(12.0));
        expect(resolved.topEnd, const Radius.circular(12.0));
        expect(resolved.bottomStart, Radius.zero);
        expect(resolved.bottomEnd, Radius.zero);
      });

      test('bottom utility sets bottom corners', () {
        final result = util.bottom(const Radius.circular(16.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(resolved.topStart, Radius.zero);
        expect(resolved.topEnd, Radius.zero);
        expect(resolved.bottomStart, const Radius.circular(16.0));
        expect(resolved.bottomEnd, const Radius.circular(16.0));
      });

      test('start utility sets start corners', () {
        final result = util.start(const Radius.circular(4.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          equals(
            BorderRadiusDirectional.only(
              topStart: const Radius.circular(4.0),
              bottomStart: const Radius.circular(4.0),
            ),
          ),
        );
      });

      test('end utility sets end corners', () {
        final result = util.end(const Radius.circular(6.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          equals(
            BorderRadiusDirectional.only(
              topEnd: const Radius.circular(6.0),
              bottomEnd: const Radius.circular(6.0),
            ),
          ),
        );
      });
    });

    group('convenience methods', () {
      test('circular method sets circular radius for all corners', () {
        final result = util.circular(10.0);
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(resolved, BorderRadiusDirectional.circular(10.0));
      });

      test('elliptical method sets elliptical radius for all corners', () {
        final result = util.elliptical(8.0, 12.0);
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());
        expect(
          resolved,
          BorderRadiusDirectional.all(const Radius.elliptical(8.0, 12.0)),
        );
      });

      test('zero method sets zero radius for all corners', () {
        final result = util.zero();
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(resolved, BorderRadiusDirectional.zero);
      });
    });

    group('only and call methods', () {
      test('only method sets specified corners', () {
        final result = util.only(
          topStart: const Radius.circular(5.0),
          bottomEnd: const Radius.circular(15.0),
        );
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          equals(
            BorderRadiusDirectional.only(
              topStart: const Radius.circular(5.0),
              bottomEnd: const Radius.circular(15.0),
            ),
          ),
        );
      });

      test('call method delegates to only', () {
        final result = util.only(
          topEnd: const Radius.circular(8.0),
          bottomStart: const Radius.circular(12.0),
        );
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          equals(
            BorderRadiusDirectional.only(
              topEnd: const Radius.circular(8.0),
              bottomStart: const Radius.circular(12.0),
            ),
          ),
        );
      });
    });

    test('as method accepts BorderRadiusDirectional', () {
      const borderRadius = BorderRadiusDirectional.only(
        topStart: Radius.circular(3.0),
        topEnd: Radius.circular(6.0),
        bottomStart: Radius.circular(9.0),
        bottomEnd: Radius.circular(12.0),
      );
      final result = util.as(borderRadius);
      final borderRadiusMix = result.value;
      final resolved = borderRadiusMix.resolve(MockBuildContext());
      expect(resolved, equals(borderRadius));

      expect(
        borderRadiusMix,
        equals(
          BorderRadiusDirectionalMix(
            topStart: const Radius.circular(3.0),
            topEnd: const Radius.circular(6.0),
            bottomStart: const Radius.circular(9.0),
            bottomEnd: const Radius.circular(12.0),
          ),
        ),
      );
    });
  });

  group('MixUtility usage', () {
    test('MixUtility creates properties that work like function calls', () {
      // Create a utility that wraps the builder function
      final radiusUtility =
          MixUtility<MockStyle<BorderRadiusGeometryMix>, Radius>(
            (radius) => MockStyle(BorderRadiusMix(topLeft: radius)),
          );

      // Call the utility like a function
      final result = radiusUtility.call(const Radius.circular(16.0));
      final borderRadius = result.value as BorderRadiusMix;
      final resolved = borderRadius.resolve(MockBuildContext());

      expect(resolved, const BorderRadius.only(topLeft: Radius.circular(16.0)));
    });
  });

  group('Token Support', () {
    test('resolves radius tokens with context', () {
      // Create a BorderRadiusMix with tokens
      // We need to use a Radius token instead of double token
      const radiusValueToken = MixToken<Radius>('radiusValue');
      final context = MockBuildContext(
        mixScopeData: MixScopeData.static(
          tokens: {radiusValueToken: const Radius.circular(16.0)},
        ),
      );

      final borderRadiusMix = BorderRadiusMix.raw(
        topLeft: Prop.token(radiusValueToken),
        topRight: Prop.token(radiusValueToken),
        bottomLeft: Prop.token(radiusValueToken),
        bottomRight: Prop.token(radiusValueToken),
      );

      final resolved = borderRadiusMix.resolve(context);

      expect(resolved, BorderRadius.circular(16.0));
    });
  });
}
