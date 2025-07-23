import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('BorderRadiusUtility', () {
    final utility = BorderRadiusUtility<UtilityTestAttribute>(
      (prop) => UtilityTestAttribute(prop),
    );

    test('call() creates BorderRadiusMix from value', () {
      const borderRadius = BorderRadius.all(Radius.circular(8.0));

      final result = utility(BorderRadiusMix.value(borderRadius));
      expect(result, isA<UtilityTestAttribute>());
      expect(result.value, isA<Prop<Mix<BorderRadius>>>());

      final mix = result.value.value as BorderRadiusMix;
      expectProp(mix.topLeft, const Radius.circular(8.0));
      expectProp(mix.topRight, const Radius.circular(8.0));
      expectProp(mix.bottomLeft, const Radius.circular(8.0));
      expectProp(mix.bottomRight, const Radius.circular(8.0));
    });

    group('corner utilities', () {
      test('topLeft creates BorderRadiusMix with topLeft radius', () {
        final result = utility.topLeft(const Radius.circular(8.0));

        expect(result, isA<UtilityTestAttribute>());
        final mix = result.value.value as BorderRadiusMix;
        expectProp(mix.topLeft, const Radius.circular(8.0));
        expect(mix.topRight, isNull);
        expect(mix.bottomLeft, isNull);
        expect(mix.bottomRight, isNull);
      });

      test('topRight creates BorderRadiusMix with topRight radius', () {
        final result = utility.topRight(const Radius.circular(8.0));

        final mix = result.value.value as BorderRadiusMix;
        expect(mix.topLeft, isNull);
        expectProp(mix.topRight, const Radius.circular(8.0));
        expect(mix.bottomLeft, isNull);
        expect(mix.bottomRight, isNull);
      });

      test('bottomLeft creates BorderRadiusMix with bottomLeft radius', () {
        final result = utility.bottomLeft(const Radius.circular(8.0));

        final mix = result.value.value as BorderRadiusMix;
        expect(mix.topLeft, isNull);
        expect(mix.topRight, isNull);
        expectProp(mix.bottomLeft, const Radius.circular(8.0));
        expect(mix.bottomRight, isNull);
      });

      test('bottomRight creates BorderRadiusMix with bottomRight radius', () {
        final result = utility.bottomRight(const Radius.circular(8.0));

        final mix = result.value.value as BorderRadiusMix;
        expect(mix.topLeft, isNull);
        expect(mix.topRight, isNull);
        expect(mix.bottomLeft, isNull);
        expectProp(mix.bottomRight, const Radius.circular(8.0));
      });
    });

    group('side utilities', () {
      test('all creates uniform BorderRadiusMix', () {
        final result = utility.all(const Radius.circular(12.0));

        final mix = result.value.value as BorderRadiusMix;
        expectProp(mix.topLeft, const Radius.circular(12.0));
        expectProp(mix.topRight, const Radius.circular(12.0));
        expectProp(mix.bottomLeft, const Radius.circular(12.0));
        expectProp(mix.bottomRight, const Radius.circular(12.0));
      });

      test('top creates top corners BorderRadiusMix', () {
        final result = utility.top(const Radius.circular(8.0));

        final mix = result.value.value as BorderRadiusMix;
        expectProp(mix.topLeft, const Radius.circular(8.0));
        expectProp(mix.topRight, const Radius.circular(8.0));
        expect(mix.bottomLeft, isNull);
        expect(mix.bottomRight, isNull);
      });

      test('bottom creates bottom corners BorderRadiusMix', () {
        final result = utility.bottom(const Radius.circular(8.0));

        final mix = result.value.value as BorderRadiusMix;
        expect(mix.topLeft, isNull);
        expect(mix.topRight, isNull);
        expectProp(mix.bottomLeft, const Radius.circular(8.0));
        expectProp(mix.bottomRight, const Radius.circular(8.0));
      });

      test('left creates left corners BorderRadiusMix', () {
        final result = utility.left(const Radius.circular(8.0));

        final mix = result.value.value as BorderRadiusMix;
        expectProp(mix.topLeft, const Radius.circular(8.0));
        expect(mix.topRight, isNull);
        expectProp(mix.bottomLeft, const Radius.circular(8.0));
        expect(mix.bottomRight, isNull);
      });

      test('right creates right corners BorderRadiusMix', () {
        final result = utility.right(const Radius.circular(8.0));

        final mix = result.value.value as BorderRadiusMix;
        expect(mix.topLeft, isNull);
        expectProp(mix.topRight, const Radius.circular(8.0));
        expect(mix.bottomLeft, isNull);
        expectProp(mix.bottomRight, const Radius.circular(8.0));
      });
    });

    group('shape utilities', () {
      test('circular creates circular radius', () {
        final result = utility.circular(16.0);

        final mix = result.value.value as BorderRadiusMix;
        expectProp(mix.topLeft, const Radius.circular(16.0));
        expectProp(mix.topRight, const Radius.circular(16.0));
        expectProp(mix.bottomLeft, const Radius.circular(16.0));
        expectProp(mix.bottomRight, const Radius.circular(16.0));
      });

      test('elliptical creates elliptical radius', () {
        final result = utility.elliptical(20.0, 10.0);

        final mix = result.value.value as BorderRadiusMix;
        expectProp(mix.topLeft, const Radius.elliptical(20.0, 10.0));
        expectProp(mix.topRight, const Radius.elliptical(20.0, 10.0));
        expectProp(mix.bottomLeft, const Radius.elliptical(20.0, 10.0));
        expectProp(mix.bottomRight, const Radius.elliptical(20.0, 10.0));
      });

      test('zero creates zero radius', () {
        final result = utility.zero();

        final mix = result.value.value as BorderRadiusMix;
        expectProp(mix.topLeft, Radius.zero);
        expectProp(mix.topRight, Radius.zero);
        expectProp(mix.bottomLeft, Radius.zero);
        expectProp(mix.bottomRight, Radius.zero);
      });
    });
  });

  group('BorderRadiusDirectionalUtility', () {
    final utility = BorderRadiusDirectionalUtility<UtilityTestAttribute>(
      (prop) => UtilityTestAttribute(prop),
    );

    test('call() creates BorderRadiusDirectionalMix from value', () {
      const borderRadius = BorderRadiusDirectional.all(Radius.circular(8.0));

      final result = utility(BorderRadiusDirectionalMix.value(borderRadius));
      expect(result, isA<UtilityTestAttribute>());
      expect(result.value, isA<Prop<Mix<BorderRadiusDirectional>>>());

      final mix = result.value.value as BorderRadiusDirectionalMix;
      expectProp(mix.topStart, const Radius.circular(8.0));
      expectProp(mix.topEnd, const Radius.circular(8.0));
      expectProp(mix.bottomStart, const Radius.circular(8.0));
      expectProp(mix.bottomEnd, const Radius.circular(8.0));
    });

    group('corner utilities', () {
      test(
        'topStart creates BorderRadiusDirectionalMix with topStart radius',
        () {
          final result = utility.topStart(const Radius.circular(8.0));

          final mix = result.value.value as BorderRadiusDirectionalMix;
          expectProp(mix.topStart, const Radius.circular(8.0));
          expect(mix.topEnd, isNull);
          expect(mix.bottomStart, isNull);
          expect(mix.bottomEnd, isNull);
        },
      );

      test('topEnd creates BorderRadiusDirectionalMix with topEnd radius', () {
        final result = utility.topEnd(const Radius.circular(8.0));

        final mix = result.value.value as BorderRadiusDirectionalMix;
        expect(mix.topStart, isNull);
        expectProp(mix.topEnd, const Radius.circular(8.0));
        expect(mix.bottomStart, isNull);
        expect(mix.bottomEnd, isNull);
      });

      test(
        'bottomStart creates BorderRadiusDirectionalMix with bottomStart radius',
        () {
          final result = utility.bottomStart(const Radius.circular(8.0));

          final mix = result.value.value as BorderRadiusDirectionalMix;
          expect(mix.topStart, isNull);
          expect(mix.topEnd, isNull);
          expectProp(mix.bottomStart, const Radius.circular(8.0));
          expect(mix.bottomEnd, isNull);
        },
      );

      test(
        'bottomEnd creates BorderRadiusDirectionalMix with bottomEnd radius',
        () {
          final result = utility.bottomEnd(const Radius.circular(8.0));

          final mix = result.value.value as BorderRadiusDirectionalMix;
          expect(mix.topStart, isNull);
          expect(mix.topEnd, isNull);
          expect(mix.bottomStart, isNull);
          expectProp(mix.bottomEnd, const Radius.circular(8.0));
        },
      );
    });

    group('side utilities', () {
      test('all creates uniform BorderRadiusDirectionalMix', () {
        final result = utility.all(const Radius.circular(12.0));

        final mix = result.value.value as BorderRadiusDirectionalMix;
        expectProp(mix.topStart, const Radius.circular(12.0));
        expectProp(mix.topEnd, const Radius.circular(12.0));
        expectProp(mix.bottomStart, const Radius.circular(12.0));
        expectProp(mix.bottomEnd, const Radius.circular(12.0));
      });

      test('top creates top corners BorderRadiusDirectionalMix', () {
        final result = utility.top(const Radius.circular(8.0));

        final mix = result.value.value as BorderRadiusDirectionalMix;
        expectProp(mix.topStart, const Radius.circular(8.0));
        expectProp(mix.topEnd, const Radius.circular(8.0));
        expect(mix.bottomStart, isNull);
        expect(mix.bottomEnd, isNull);
      });

      test('bottom creates bottom corners BorderRadiusDirectionalMix', () {
        final result = utility.bottom(const Radius.circular(8.0));

        final mix = result.value.value as BorderRadiusDirectionalMix;
        expect(mix.topStart, isNull);
        expect(mix.topEnd, isNull);
        expectProp(mix.bottomStart, const Radius.circular(8.0));
        expectProp(mix.bottomEnd, const Radius.circular(8.0));
      });

      test('start creates start corners BorderRadiusDirectionalMix', () {
        final result = utility.start(const Radius.circular(8.0));

        final mix = result.value.value as BorderRadiusDirectionalMix;
        expectProp(mix.topStart, const Radius.circular(8.0));
        expect(mix.topEnd, isNull);
        expectProp(mix.bottomStart, const Radius.circular(8.0));
        expect(mix.bottomEnd, isNull);
      });

      test('end creates end corners BorderRadiusDirectionalMix', () {
        final result = utility.end(const Radius.circular(8.0));

        final mix = result.value.value as BorderRadiusDirectionalMix;
        expect(mix.topStart, isNull);
        expectProp(mix.topEnd, const Radius.circular(8.0));
        expect(mix.bottomStart, isNull);
        expectProp(mix.bottomEnd, const Radius.circular(8.0));
      });
    });

    group('shape utilities', () {
      test('circular creates circular radius', () {
        final result = utility.circular(16.0);

        final mix = result.value.value as BorderRadiusDirectionalMix;
        expectProp(mix.topStart, const Radius.circular(16.0));
        expectProp(mix.topEnd, const Radius.circular(16.0));
        expectProp(mix.bottomStart, const Radius.circular(16.0));
        expectProp(mix.bottomEnd, const Radius.circular(16.0));
      });

      test('elliptical creates elliptical radius', () {
        final result = utility.elliptical(20.0, 10.0);

        final mix = result.value.value as BorderRadiusDirectionalMix;
        expectProp(mix.topStart, const Radius.elliptical(20.0, 10.0));
        expectProp(mix.topEnd, const Radius.elliptical(20.0, 10.0));
        expectProp(mix.bottomStart, const Radius.elliptical(20.0, 10.0));
        expectProp(mix.bottomEnd, const Radius.elliptical(20.0, 10.0));
      });

      test('zero creates zero radius', () {
        final result = utility.zero();

        final mix = result.value.value as BorderRadiusDirectionalMix;
        expectProp(mix.topStart, Radius.zero);
        expectProp(mix.topEnd, Radius.zero);
        expectProp(mix.bottomStart, Radius.zero);
        expectProp(mix.bottomEnd, Radius.zero);
      });
    });
  });

  group('BorderRadiusGeometryUtility', () {
    final utility = BorderRadiusGeometryUtility<UtilityTestAttribute>(
      (prop) => UtilityTestAttribute(prop),
    );

    test('supports BorderRadius type', () {
      const borderRadius = BorderRadius.all(Radius.circular(8.0));

      final result = utility(BorderRadiusMix.value(borderRadius));
      expect(result, isA<UtilityTestAttribute>());
      expect(result.value, isA<Prop<Mix<BorderRadiusGeometry>>>());
    });

    test('supports BorderRadiusDirectional type', () {
      const borderRadiusDirectional = BorderRadiusDirectional.all(
        Radius.circular(8.0),
      );

      final result = utility(
        BorderRadiusDirectionalMix.value(borderRadiusDirectional),
      );
      expect(result, isA<UtilityTestAttribute>());
      expect(result.value, isA<Prop<Mix<BorderRadiusGeometry>>>());
    });

    group('directional access', () {
      test('directional property returns BorderRadiusDirectionalUtility', () {
        final result = utility.directional.topStart(const Radius.circular(8.0));

        expect(result, isA<UtilityTestAttribute>());
        final mix = result.value.value as BorderRadiusDirectionalMix;
        expectProp(mix.topStart, const Radius.circular(8.0));
      });
    });

    group('inherited utilities from BorderRadiusUtility', () {
      test('all creates uniform BorderRadiusMix', () {
        final result = utility.all(const Radius.circular(12.0));

        expect(result, isA<UtilityTestAttribute>());
        final mix = result.value.value as BorderRadiusMix;
        expectProp(mix.topLeft, const Radius.circular(12.0));
        expectProp(mix.topRight, const Radius.circular(12.0));
        expectProp(mix.bottomLeft, const Radius.circular(12.0));
        expectProp(mix.bottomRight, const Radius.circular(12.0));
      });

      test('circular creates circular radius', () {
        final result = utility.circular(16.0);

        expect(result, isA<UtilityTestAttribute>());
        final mix = result.value.value as BorderRadiusMix;
        expectProp(mix.topLeft, const Radius.circular(16.0));
      });

      test('corner utilities work', () {
        final topLeft = utility.topLeft(const Radius.circular(8.0));
        final topRight = utility.topRight(const Radius.circular(10.0));
        final bottomLeft = utility.bottomLeft(const Radius.circular(12.0));
        final bottomRight = utility.bottomRight(const Radius.circular(14.0));

        expect(topLeft, isA<UtilityTestAttribute>());
        expect(topRight, isA<UtilityTestAttribute>());
        expect(bottomLeft, isA<UtilityTestAttribute>());
        expect(bottomRight, isA<UtilityTestAttribute>());
      });
    });

    group('resolution', () {
      test('resolves BorderRadius correctly', () {
        final result = utility.all(const Radius.circular(8.0));

        final mix = result.value.value as BorderRadiusMix;
        const resolvedValue = BorderRadius.all(Radius.circular(8.0));

        expect(mix, resolvesTo(resolvedValue));
      });

      test('resolves BorderRadiusDirectional correctly', () {
        final result = utility.directional.all(const Radius.circular(12.0));

        final mix = result.value.value as BorderRadiusDirectionalMix;
        const resolvedValue = BorderRadiusDirectional.all(Radius.circular(12.0));

        expect(mix, resolvesTo(resolvedValue));
      });
    });
  });
}
