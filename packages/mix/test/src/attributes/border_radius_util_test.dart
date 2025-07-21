import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Border Radius Utilities', () {
    group('BorderRadiusUtility', () {
      final utility = BorderRadiusUtility(UtilityTestAttribute.new);

      test('call() creates BorderRadiusMix', () {
        final borderRadiusMix = BorderRadiusMix.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(12.0),
          bottomLeft: const Radius.circular(16.0),
          bottomRight: const Radius.circular(20.0),
        );
        final attr = utility(borderRadiusMix);
        expect(attr.value, isA<MixProp<BorderRadius>>());
      });

      test('as() creates BorderRadiusMix from BorderRadius', () {
        const borderRadius = BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(12.0),
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(20.0),
        );
        final attr = utility.as(borderRadius);
        expect(attr.value, isA<MixProp<BorderRadius>>());
      });

      group('Corner Utilities', () {
        test('topLeft() creates border radius with top left corner', () {
          final attr = utility.topLeft(const Radius.circular(8.0));
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('topLeft.circular() creates border radius with circular top left', () {
          final attr = utility.topLeft.circular(8.0);
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('topLeft.elliptical() creates border radius with elliptical top left', () {
          final attr = utility.topLeft.elliptical(8.0, 12.0);
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('topLeft.zero() creates border radius with zero top left', () {
          final attr = utility.topLeft.zero();
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('topRight() creates border radius with top right corner', () {
          final attr = utility.topRight(const Radius.circular(12.0));
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('topRight.circular() creates border radius with circular top right', () {
          final attr = utility.topRight.circular(12.0);
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('bottomLeft() creates border radius with bottom left corner', () {
          final attr = utility.bottomLeft(const Radius.circular(16.0));
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('bottomLeft.elliptical() creates border radius with elliptical bottom left', () {
          final attr = utility.bottomLeft.elliptical(16.0, 20.0);
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('bottomRight() creates border radius with bottom right corner', () {
          final attr = utility.bottomRight(const Radius.circular(20.0));
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('bottomRight.zero() creates border radius with zero bottom right', () {
          final attr = utility.bottomRight.zero();
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });
      });

      group('Side Utilities', () {
        test('top() creates border radius with top corners', () {
          final attr = utility.top(const Radius.circular(8.0));
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('top.circular() creates border radius with circular top corners', () {
          final attr = utility.top.circular(8.0);
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('bottom() creates border radius with bottom corners', () {
          final attr = utility.bottom(const Radius.circular(12.0));
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('bottom.elliptical() creates border radius with elliptical bottom corners', () {
          final attr = utility.bottom.elliptical(12.0, 16.0);
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('left() creates border radius with left corners', () {
          final attr = utility.left(const Radius.circular(10.0));
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('left.zero() creates border radius with zero left corners', () {
          final attr = utility.left.zero();
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('right() creates border radius with right corners', () {
          final attr = utility.right(const Radius.circular(14.0));
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('right.circular() creates border radius with circular right corners', () {
          final attr = utility.right.circular(14.0);
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });
      });

      group('All Corners Utilities', () {
        test('all() creates border radius with all corners', () {
          final attr = utility.all(const Radius.circular(16.0));
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('all.circular() creates border radius with all circular corners', () {
          final attr = utility.all.circular(16.0);
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('all.elliptical() creates border radius with all elliptical corners', () {
          final attr = utility.all.elliptical(16.0, 20.0);
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('all.zero() creates border radius with all zero corners', () {
          final attr = utility.all.zero();
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('circular() creates circular border radius', () {
          final attr = utility.circular(16.0);
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('elliptical() creates elliptical border radius', () {
          final attr = utility.elliptical(16.0, 20.0);
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });

        test('zero() creates zero border radius', () {
          final attr = utility.zero();
          expect(attr.value, isA<MixProp<BorderRadius>>());
        });
      });

      test('token() creates border radius from token', () {
        const token = MixToken<BorderRadius>('test.borderRadius');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<BorderRadius>>());
      });
    });

    group('BorderRadiusDirectionalUtility', () {
      final utility = BorderRadiusDirectionalUtility(UtilityTestAttribute.new);

      test('call() creates BorderRadiusDirectionalMix', () {
        final borderRadiusMix = BorderRadiusDirectionalMix.only(
          topStart: const Radius.circular(8.0),
          topEnd: const Radius.circular(12.0),
          bottomStart: const Radius.circular(16.0),
          bottomEnd: const Radius.circular(20.0),
        );
        final attr = utility(borderRadiusMix);
        expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
      });

      test('as() creates BorderRadiusDirectionalMix from BorderRadiusDirectional', () {
        const borderRadius = BorderRadiusDirectional.only(
          topStart: Radius.circular(8.0),
          topEnd: Radius.circular(12.0),
          bottomStart: Radius.circular(16.0),
          bottomEnd: Radius.circular(20.0),
        );
        final attr = utility.as(borderRadius);
        expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
      });

      group('Corner Utilities', () {
        test('topStart() creates border radius with top start corner', () {
          final attr = utility.topStart(const Radius.circular(8.0));
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('topStart.circular() creates border radius with circular top start', () {
          final attr = utility.topStart.circular(8.0);
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('topEnd() creates border radius with top end corner', () {
          final attr = utility.topEnd(const Radius.circular(12.0));
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('topEnd.elliptical() creates border radius with elliptical top end', () {
          final attr = utility.topEnd.elliptical(12.0, 16.0);
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('bottomStart() creates border radius with bottom start corner', () {
          final attr = utility.bottomStart(const Radius.circular(16.0));
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('bottomStart.zero() creates border radius with zero bottom start', () {
          final attr = utility.bottomStart.zero();
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('bottomEnd() creates border radius with bottom end corner', () {
          final attr = utility.bottomEnd(const Radius.circular(20.0));
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('bottomEnd.circular() creates border radius with circular bottom end', () {
          final attr = utility.bottomEnd.circular(20.0);
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });
      });

      group('Side Utilities', () {
        test('top() creates border radius with top corners', () {
          final attr = utility.top(const Radius.circular(8.0));
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('top.circular() creates border radius with circular top corners', () {
          final attr = utility.top.circular(8.0);
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('bottom() creates border radius with bottom corners', () {
          final attr = utility.bottom(const Radius.circular(12.0));
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('bottom.elliptical() creates border radius with elliptical bottom corners', () {
          final attr = utility.bottom.elliptical(12.0, 16.0);
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('start() creates border radius with start corners', () {
          final attr = utility.start(const Radius.circular(10.0));
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('start.zero() creates border radius with zero start corners', () {
          final attr = utility.start.zero();
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('end() creates border radius with end corners', () {
          final attr = utility.end(const Radius.circular(14.0));
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('end.circular() creates border radius with circular end corners', () {
          final attr = utility.end.circular(14.0);
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });
      });

      group('All Corners Utilities', () {
        test('all() creates border radius with all corners', () {
          final attr = utility.all(const Radius.circular(16.0));
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('all.circular() creates border radius with all circular corners', () {
          final attr = utility.all.circular(16.0);
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('all.elliptical() creates border radius with all elliptical corners', () {
          final attr = utility.all.elliptical(16.0, 20.0);
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('all.zero() creates border radius with all zero corners', () {
          final attr = utility.all.zero();
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('circular() creates circular border radius', () {
          final attr = utility.circular(16.0);
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('elliptical() creates elliptical border radius', () {
          final attr = utility.elliptical(16.0, 20.0);
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });

        test('zero() creates zero border radius', () {
          final attr = utility.zero();
          expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
        });
      });

      test('token() creates border radius directional from token', () {
        const token = MixToken<BorderRadiusDirectional>('test.borderRadiusDirectional');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<BorderRadiusDirectional>>());
      });
    });

    group('BorderRadiusGeometryUtility', () {
      final utility = BorderRadiusGeometryUtility(UtilityTestAttribute.new);

      test('call() creates BorderRadiusGeometryMix from BorderRadiusMix', () {
        final borderRadiusMix = BorderRadiusMix.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(12.0),
        );
        final attr = utility(borderRadiusMix);
        expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
      });

      test('call() creates BorderRadiusGeometryMix from BorderRadiusDirectionalMix', () {
        final borderRadiusMix = BorderRadiusDirectionalMix.only(
          topStart: const Radius.circular(8.0),
          topEnd: const Radius.circular(12.0),
        );
        final attr = utility(borderRadiusMix);
        expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
      });

      test('as() creates BorderRadiusGeometryMix from BorderRadius', () {
        const borderRadius = BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(12.0),
        );
        final attr = utility.as(borderRadius);
        expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
      });

      test('as() creates BorderRadiusGeometryMix from BorderRadiusDirectional', () {
        const borderRadius = BorderRadiusDirectional.only(
          topStart: Radius.circular(8.0),
          topEnd: Radius.circular(12.0),
        );
        final attr = utility.as(borderRadius);
        expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
      });

      group('Delegated Properties from BorderRadiusUtility', () {
        test('all() creates border radius geometry with all corners', () {
          final attr = utility.all(const Radius.circular(16.0));
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('topLeft() creates border radius geometry with top left corner', () {
          final attr = utility.topLeft(const Radius.circular(8.0));
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('topRight() creates border radius geometry with top right corner', () {
          final attr = utility.topRight(const Radius.circular(12.0));
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('bottomLeft() creates border radius geometry with bottom left corner', () {
          final attr = utility.bottomLeft(const Radius.circular(16.0));
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('bottomRight() creates border radius geometry with bottom right corner', () {
          final attr = utility.bottomRight(const Radius.circular(20.0));
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('top() creates border radius geometry with top corners', () {
          final attr = utility.top(const Radius.circular(8.0));
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('bottom() creates border radius geometry with bottom corners', () {
          final attr = utility.bottom(const Radius.circular(12.0));
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('left() creates border radius geometry with left corners', () {
          final attr = utility.left(const Radius.circular(10.0));
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('right() creates border radius geometry with right corners', () {
          final attr = utility.right(const Radius.circular(14.0));
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('circular() creates circular border radius geometry', () {
          final attr = utility.circular(16.0);
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('elliptical() creates elliptical border radius geometry', () {
          final attr = utility.elliptical(16.0, 20.0);
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('zero() creates zero border radius geometry', () {
          final attr = utility.zero();
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });
      });

      group('Directional Properties', () {
        test('directional() provides access to BorderRadiusDirectionalUtility', () {
          final attr = utility.directional.topStart(const Radius.circular(8.0));
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('directional.circular() creates circular directional border radius', () {
          final attr = utility.directional.circular(16.0);
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('directional.elliptical() creates elliptical directional border radius', () {
          final attr = utility.directional.elliptical(16.0, 20.0);
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });

        test('directional.zero() creates zero directional border radius', () {
          final attr = utility.directional.zero();
          expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
        });
      });

      test('token() creates border radius geometry from token', () {
        const token = MixToken<BorderRadiusGeometry>('test.borderRadiusGeometry');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<BorderRadiusGeometry>>());
      });
    });
  });
}
