import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
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

    test('borderRadius.circular creates circular BorderRadiusMix', () {
      final result = util.borderRadius.circular(10.0);
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
          const BorderRadius.vertical(top: Radius.circular(12.0)),
        );
      });

      test('bottom utility sets bottom corners', () {
        final result = util.bottom(const Radius.circular(16.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          const BorderRadius.vertical(bottom: Radius.circular(16.0)),
        );
      });

      test('left utility sets left corners', () {
        final result = util.left(const Radius.circular(4.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          const BorderRadius.horizontal(left: Radius.circular(4.0)),
        );
      });

      test('right utility sets right corners', () {
        final result = util.right(const Radius.circular(6.0));
        final borderRadius = result.value;
        final resolved = borderRadius.resolve(MockBuildContext());

        expect(
          resolved,
          const BorderRadius.horizontal(right: Radius.circular(6.0)),
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

        expect(resolved, BorderRadius.all(const Radius.elliptical(8.0, 12.0)));
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

      test('only method sets specified corners', () {
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

      test('only method sets specified corners', () {
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
      const radiusValueToken = TestToken<Radius>('radiusValue');
      final context = MockBuildContext(
        tokens: {radiusValueToken: const Radius.circular(16.0)},
      );

      final borderRadiusMix = BorderRadiusMix.create(
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
