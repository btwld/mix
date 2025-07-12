import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  final borderRadius = BorderRadiusUtility(UtilityTestAttribute.new);
  final borderRadiusDirectional = BorderRadiusDirectionalUtility(
    UtilityTestAttribute.new,
  );
  group('BorderRadiusUtility', () {
    test('zero returns zero radius for all corners', () {
      final result = borderRadius.zero();
      expect(result.value, resolvesTo(BorderRadius.all(Radius.zero)));
    });

    test('only sets specific radii for each corner', () {
      final result = borderRadius.only(
        topLeft: const Radius.circular(10),
        topRight: const Radius.circular(20),
        bottomLeft: const Radius.circular(30),
        bottomRight: const Radius.circular(40),
      );
      expect(
        result.value,
        resolvesTo(
          const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(40),
          ),
        ),
      );
    });

    test('all sets the same radius for all corners', () {
      final result = borderRadius.all.circular(10);
      expect(
        result.value,
        resolvesTo(const BorderRadius.all(Radius.circular(10))),
      );
    });

    test('vertical sets top and bottom radii', () {
      final resultTop = borderRadius.top.circular(10);
      final resultBottom = borderRadius.bottom.circular(20);
      expect(resultTop.value.topLeft, resolvesTo(const Radius.circular(10)));
      expect(resultTop.value.topRight, resolvesTo(const Radius.circular(10)));
      expect(
        resultBottom.value.bottomLeft,
        resolvesTo(const Radius.circular(20)),
      );
      expect(
        resultBottom.value.bottomRight,
        resolvesTo(const Radius.circular(20)),
      );
    });

    test('horizontal sets left and right radii', () {
      final resultLeft = borderRadius.left.circular(10);
      final resultRight = borderRadius.right.circular(20);
      expect(resultLeft.value.topLeft, resolvesTo(const Radius.circular(10)));
      expect(
        resultLeft.value.bottomLeft,
        resolvesTo(const Radius.circular(10)),
      );
      expect(resultRight.value.topRight, resolvesTo(const Radius.circular(20)));
      expect(
        resultRight.value.bottomRight,
        resolvesTo(const Radius.circular(20)),
      );
    });

    test('elliptical sets elliptical radii for all corners', () {
      final result = borderRadius.elliptical(10, 20);
      expect(result.value.topLeft, resolvesTo(const Radius.elliptical(10, 20)));
      expect(
        result.value.topRight,
        resolvesTo(const Radius.elliptical(10, 20)),
      );
      expect(
        result.value.bottomLeft,
        resolvesTo(const Radius.elliptical(10, 20)),
      );
      expect(
        result.value.bottomRight,
        resolvesTo(const Radius.elliptical(10, 20)),
      );
    });

    test('positional sets different radii for each corner', () {
      final result = borderRadius(10, 20, 30, 40);
      expect(result.value.topLeft, resolvesTo(const Radius.circular(10)));
      expect(result.value.topRight, resolvesTo(const Radius.circular(20)));
      expect(result.value.bottomLeft, resolvesTo(const Radius.circular(30)));
      expect(result.value.bottomRight, resolvesTo(const Radius.circular(40)));
    });

    test('circular sets the same circular radius for all corners', () {
      final result = borderRadius.circular(10);
      expect(result.value.topLeft, resolvesTo(const Radius.circular(10)));
      expect(result.value.topRight, resolvesTo(const Radius.circular(10)));
      expect(result.value.bottomLeft, resolvesTo(const Radius.circular(10)));
      expect(result.value.bottomRight, resolvesTo(const Radius.circular(10)));
    });

    test('topLeft sets radius for top-left corner only', () {
      final result = borderRadius.topLeft.circular(10);
      // Test individual properties are set correctly
      expect(result.value.topLeft, resolvesTo(const Radius.circular(10)));
      expect(result.value.topRight, isNull);
      expect(result.value.bottomLeft, isNull);
      expect(result.value.bottomRight, isNull);

      // Also test the whole resolved value
      expect(
        result.value,
        resolvesTo(const BorderRadius.only(topLeft: Radius.circular(10))),
      );
    });

    test('topRight sets radius for top-right corner only', () {
      final result = borderRadius.topRight.circular(10);
      expect(result.value.topLeft, isNull);
      expect(result.value.topRight, resolvesTo(const Radius.circular(10)));
      expect(result.value.bottomLeft, isNull);
      expect(result.value.bottomRight, isNull);

      // Also test the whole resolved value
      expect(
        result.value,
        resolvesTo(const BorderRadius.only(topRight: Radius.circular(10))),
      );
    });

    test('bottomLeft sets radius for bottom-left corner only', () {
      final result = borderRadius.bottomLeft.circular(10);
      expect(result.value.topLeft, isNull);
      expect(result.value.topRight, isNull);
      expect(result.value.bottomLeft, resolvesTo(const Radius.circular(10)));
      expect(result.value.bottomRight, isNull);
    });

    test('bottomRight sets radius for bottom-right corner only', () {
      final result = borderRadius.bottomRight.circular(10);
      expect(result.value.topLeft, isNull);
      expect(result.value.topRight, isNull);
      expect(result.value.bottomLeft, isNull);
      expect(result.value.bottomRight, resolvesTo(const Radius.circular(10)));
    });
  });
  group('BorderRadiusDirectionalUtility', () {
    test(
      'zero should return a BorderRadiusDirectionalAttribute with all corners set to zero radius',
      () {
        final result = borderRadiusDirectional.zero();
        expect(result.value.topStart, resolvesTo(Radius.zero));
        expect(result.value.topEnd, resolvesTo(Radius.zero));
        expect(result.value.bottomStart, resolvesTo(Radius.zero));
        expect(result.value.bottomEnd, resolvesTo(Radius.zero));
      },
    );

    test(
      'only should return a BorderRadiusDirectionalAttribute with each corner having a specified radius',
      () {
        final result = borderRadiusDirectional.only(
          topStart: const Radius.circular(10),
          topEnd: const Radius.circular(20),
          bottomStart: const Radius.circular(30),
          bottomEnd: const Radius.circular(40),
        );
        expect(result.value.topStart, resolvesTo(const Radius.circular(10)));
        expect(result.value.topEnd, resolvesTo(const Radius.circular(20)));
        expect(result.value.bottomStart, resolvesTo(const Radius.circular(30)));
        expect(result.value.bottomEnd, resolvesTo(const Radius.circular(40)));
      },
    );

    // top
    test(
      'top should return a BorderRadiusDirectionalAttribute with the top corners set to a specified radius and bottom corners to null',
      () {
        final result = borderRadiusDirectional.top.circular(10);
        expect(result.value.topStart, resolvesTo(const Radius.circular(10)));
        expect(result.value.topEnd, resolvesTo(const Radius.circular(10)));
        expect(result.value.bottomStart, isNull);
        expect(result.value.bottomEnd, isNull);
      },
    );

    // bottom
    test(
      'bottom should return a BorderRadiusDirectionalAttribute with the bottom corners set to a specified radius and top corners to null',
      () {
        final result = borderRadiusDirectional.bottom.circular(10);
        expect(result.value.topStart, isNull);
        expect(result.value.topEnd, isNull);
        expect(result.value.bottomStart, resolvesTo(const Radius.circular(10)));
        expect(result.value.bottomEnd, resolvesTo(const Radius.circular(10)));
      },
    );

    // start
    test(
      'start should return a BorderRadiusDirectionalAttribute with the start corners set to a specified radius and end corners to null',
      () {
        final result = borderRadiusDirectional.start.circular(10);
        expect(result.value.topStart, resolvesTo(const Radius.circular(10)));
        expect(result.value.topEnd, isNull);
        expect(result.value.bottomStart, resolvesTo(const Radius.circular(10)));
        expect(result.value.bottomEnd, isNull);
      },
    );

    // end
    test(
      'end should return a BorderRadiusDirectionalAttribute with the end corners set to a specified radius and start corners to null',
      () {
        final result = borderRadiusDirectional.end.circular(10);
        expect(result.value.topStart, isNull);
        expect(result.value.topEnd, resolvesTo(const Radius.circular(10)));
        expect(result.value.bottomStart, isNull);
        expect(result.value.bottomEnd, resolvesTo(const Radius.circular(10)));
      },
    );

    // circular
    test(
      'circular should return a BorderRadiusDirectionalAttribute with all corners set to the same specified radius',
      () {
        final result = borderRadiusDirectional.circular(10);
        expect(result.value.topStart, resolvesTo(const Radius.circular(10)));
        expect(result.value.topEnd, resolvesTo(const Radius.circular(10)));
        expect(result.value.bottomStart, resolvesTo(const Radius.circular(10)));
        expect(result.value.bottomEnd, resolvesTo(const Radius.circular(10)));
      },
    );

    // elliptical
    test(
      'elliptical should return a BorderRadiusDirectionalAttribute with all corners set to the specified elliptical radii',
      () {
        final result = borderRadiusDirectional.elliptical(10, 20);
        expect(
          result.value.topStart,
          resolvesTo(const Radius.elliptical(10, 20)),
        );
        expect(
          result.value.topEnd,
          resolvesTo(const Radius.elliptical(10, 20)),
        );
        expect(
          result.value.bottomStart,
          resolvesTo(const Radius.elliptical(10, 20)),
        );
        expect(
          result.value.bottomEnd,
          resolvesTo(const Radius.elliptical(10, 20)),
        );
      },
    );

    // call method with different parameter combinations
    test(
      'call method should return a BorderRadiusDirectionalAttribute with specified radii for different configurations',
      () {
        final result1 = borderRadiusDirectional(10);
        expect(result1.value.topStart, resolvesTo(const Radius.circular(10)));
        expect(result1.value.topEnd, resolvesTo(const Radius.circular(10)));
        expect(
          result1.value.bottomStart,
          resolvesTo(const Radius.circular(10)),
        );
        expect(result1.value.bottomEnd, resolvesTo(const Radius.circular(10)));

        final result2 = borderRadiusDirectional(10, 20);
        expect(result2.value.topStart, resolvesTo(const Radius.circular(10)));
        expect(result2.value.topEnd, resolvesTo(const Radius.circular(10)));
        expect(
          result2.value.bottomStart,
          resolvesTo(const Radius.circular(20)),
        );
        expect(result2.value.bottomEnd, resolvesTo(const Radius.circular(20)));

        final result3 = borderRadiusDirectional(10, 20, 30);
        expect(result3.value.topStart, resolvesTo(const Radius.circular(10)));
        expect(result3.value.topEnd, resolvesTo(const Radius.circular(20)));
        expect(
          result3.value.bottomStart,
          resolvesTo(const Radius.circular(20)),
        );
        expect(result3.value.bottomEnd, resolvesTo(const Radius.circular(30)));

        final result4 = borderRadiusDirectional(10, 20, 30, 40);
        expect(result4.value.topStart, resolvesTo(const Radius.circular(10)));
        expect(result4.value.topEnd, resolvesTo(const Radius.circular(20)));
        expect(
          result4.value.bottomStart,
          resolvesTo(const Radius.circular(30)),
        );
        expect(result4.value.bottomEnd, resolvesTo(const Radius.circular(40)));
      },
    );

    test(
      'all should return a BorderRadiusDirectionalAttribute with all corners set to the same specified radius',
      () {
        final result = borderRadiusDirectional.all.circular(10);
        expect(result.value.topStart, resolvesTo(const Radius.circular(10)));
        expect(result.value.topEnd, resolvesTo(const Radius.circular(10)));
        expect(result.value.bottomStart, resolvesTo(const Radius.circular(10)));
        expect(result.value.bottomEnd, resolvesTo(const Radius.circular(10)));
      },
    );

    test(
      'topStart should return a BorderRadiusDirectionalAttribute with only the topStart corner set to a specified radius',
      () {
        final result = borderRadiusDirectional.topStart.circular(10);
        expect(result.value.topStart, resolvesTo(const Radius.circular(10)));
        expect(result.value.topEnd, isNull);
        expect(result.value.bottomStart, isNull);
        expect(result.value.bottomEnd, isNull);
      },
    );

    test(
      'topEnd should return a BorderRadiusDirectionalAttribute with only the topEnd corner set to a specified radius',
      () {
        final result = borderRadiusDirectional.topEnd.circular(10);
        expect(result.value.topStart, isNull);
        expect(result.value.topEnd, resolvesTo(const Radius.circular(10)));
        expect(result.value.bottomStart, isNull);
        expect(result.value.bottomEnd, isNull);
      },
    );

    test(
      'bottomStart should return a BorderRadiusDirectionalAttribute with only the bottomStart corner set to a specified radius',
      () {
        final result = borderRadiusDirectional.bottomStart.circular(10);
        expect(result.value.topStart, isNull);
        expect(result.value.topEnd, isNull);
        expect(result.value.bottomStart, resolvesTo(const Radius.circular(10)));
        expect(result.value.bottomEnd, isNull);
      },
    );

    test(
      'bottomEnd should return a BorderRadiusDirectionalAttribute with only the bottomEnd corner set to a specified radius',
      () {
        final result = borderRadiusDirectional.bottomEnd.circular(10);
        expect(result.value.topStart, isNull);
        expect(result.value.topEnd, isNull);
        expect(result.value.bottomStart, isNull);
        expect(result.value.bottomEnd, resolvesTo(const Radius.circular(10)));
      },
    );
  });
}
