import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BorderSideUtility', () {
    final utility = BorderSideUtility(UtilityTestAttribute.new);

    test('call() creates BorderSideMix from parameters', () {
      final result = utility(
        color: Colors.red,
        width: 2.0,
        style: BorderStyle.solid,
      );
      expect(result, isA<UtilityTestAttribute>());
      expect(result.value, isA<MixProp<BorderSide>>());

      final mix = result.value.value as BorderSideMix;
      expectProp(mix.$color, Colors.red);
      expectProp(mix.$width, 2.0);
      expectProp(mix.$style, BorderStyle.solid);
    });

    test('none() creates BorderSideMix.none', () {
      final result = utility.none();
      expect(result, isA<UtilityTestAttribute>());

      final mix = result.value.value as BorderSideMix;
      expectProp(mix.$style, BorderStyle.none);
      expectProp(mix.$width, 0.0);
    });

    test('only() creates BorderSideMix with specified properties', () {
      final result = utility.only(
        color: Colors.blue,
        width: 3.0,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignCenter,
      );

      expect(result, isA<UtilityTestAttribute>());

      final mix = result.value.value as BorderSideMix;
      expectProp(mix.$color, Colors.blue);
      expectProp(mix.$width, 3.0);
      expectProp(mix.$style, BorderStyle.solid);
      expectProp(mix.$strokeAlign, BorderSide.strokeAlignCenter);
    });

    group('property utilities', () {
      test('color utility creates BorderSideMix with color', () {
        final result = utility.color(Colors.green);

        final mix = result.value.value as BorderSideMix;
        expectProp(mix.$color, Colors.green);
      });

      test('width utility creates BorderSideMix with width', () {
        final result = utility.width(4.0);

        final mix = result.value.value as BorderSideMix;
        expectProp(mix.$width, 4.0);
      });

      test('style utility creates BorderSideMix with style', () {
        final result = utility.style(BorderStyle.solid);

        final mix = result.value.value as BorderSideMix;
        expectProp(mix.$style, BorderStyle.solid);
      });

      test('strokeAlign utility creates BorderSideMix with strokeAlign', () {
        final result = utility.strokeAlign(BorderSide.strokeAlignInside);

        final mix = result.value.value as BorderSideMix;
        expectProp(mix.$strokeAlign, BorderSide.strokeAlignInside);
      });
    });
  });

  group('BorderUtility', () {
    final utility = BorderUtility(UtilityTestAttribute.new);

    test('call() creates BorderMix from value', () {
      final border = Border.all(color: Colors.red, width: 2.0);

      final result = utility(BorderMix.value(border));
      expect(result, isA<UtilityTestAttribute>());
      expect(result.value, isA<MixProp<Border>>());
    });

    test('none() creates BorderMix.none', () {
      final result = utility.none();
      expect(result, isA<UtilityTestAttribute>());

      final mix = result.value.value;
      expect(mix, BorderMix.all(BorderSideMix.none));
    });

    test('only() creates BorderMix with specified sides', () {
      final topSide = BorderSideMix(color: Colors.red, width: 1.0);
      final bottomSide = BorderSideMix(color: Colors.blue, width: 2.0);

      final result = utility.only(top: topSide, bottom: bottomSide);

      expect(result, isA<UtilityTestAttribute>());

      final mix = result.value.value as BorderMix;
      expect(mix.$top, isNotNull);
      expect(mix.$bottom, isNotNull);
      expect(mix.$left, isNull);
      expect(mix.$right, isNull);
    });

    group('side utilities', () {
      test('all creates uniform border', () {
        final result = utility.all(
          BorderSideMix(color: Colors.red, width: 2.0),
        );

        final mix = result.value.value as BorderMix;
        expect(mix.$top, isNotNull);
        expect(mix.$bottom, isNotNull);
        expect(mix.$left, isNotNull);
        expect(mix.$right, isNotNull);
      });

      test('top creates top border only', () {
        final result = utility.top(BorderSideMix(width: 1.0));

        final mix = result.value.value as BorderMix;
        expect(mix.$top, isNotNull);
        expect(mix.$bottom, isNull);
        expect(mix.$left, isNull);
        expect(mix.$right, isNull);
      });

      test('bottom creates bottom border only', () {
        final result = utility.bottom(BorderSideMix(width: 1.0));

        final mix = result.value.value as BorderMix;
        expect(mix.$top, isNull);
        expect(mix.$bottom, isNotNull);
        expect(mix.$left, isNull);
        expect(mix.$right, isNull);
      });

      test('left creates left border only', () {
        final result = utility.left(BorderSideMix(width: 1.0));

        final mix = result.value.value as BorderMix;
        expect(mix.$top, isNull);
        expect(mix.$bottom, isNull);
        expect(mix.$left, isNotNull);
        expect(mix.$right, isNull);
      });

      test('right creates right border only', () {
        final result = utility.right(BorderSideMix(width: 1.0));

        final mix = result.value.value as BorderMix;
        expect(mix.$top, isNull);
        expect(mix.$bottom, isNull);
        expect(mix.$left, isNull);
        expect(mix.$right, isNotNull);
      });

      test('horizontal creates left and right borders', () {
        final result = utility.horizontal(BorderSideMix(width: 1.0));

        final mix = result.value.value as BorderMix;
        expect(mix.$top, isNull);
        expect(mix.$bottom, isNull);
        expect(mix.$left, isNotNull);
        expect(mix.$right, isNotNull);
      });

      test('vertical creates top and bottom borders', () {
        final result = utility.vertical(BorderSideMix(width: 1.0));

        final mix = result.value.value as BorderMix;
        expect(mix.$top, isNotNull);
        expect(mix.$bottom, isNotNull);
        expect(mix.$left, isNull);
        expect(mix.$right, isNull);
      });
    });

    group('property utilities', () {
      test('color applies to all sides', () {
        final result = utility.color(Colors.green);

        final mix = result.value.value as BorderMix;
        expect(mix.$top, isNotNull);
        expect(mix.$bottom, isNotNull);
        expect(mix.$left, isNotNull);
        expect(mix.$right, isNotNull);
      });

      test('width applies to all sides', () {
        final result = utility.width(3.0);

        final mix = result.value.value as BorderMix;
        expect(mix.$top, isNotNull);
        expect(mix.$bottom, isNotNull);
        expect(mix.$left, isNotNull);
        expect(mix.$right, isNotNull);
      });

      test('style applies to all sides', () {
        final result = utility.style(BorderStyle.solid);

        final mix = result.value.value as BorderMix;
        expect(mix.$top, isNotNull);
        expect(mix.$bottom, isNotNull);
        expect(mix.$left, isNotNull);
        expect(mix.$right, isNotNull);
      });
    });
  });

  group('BorderDirectionalUtility', () {
    final utility = BorderDirectionalUtility(UtilityTestAttribute.new);

    test('call() creates BorderDirectionalMix from value', () {
      const borderDirectional = BorderDirectional(
        top: BorderSide(color: Colors.red),
        bottom: BorderSide(color: Colors.blue),
        start: BorderSide(color: Colors.green),
        end: BorderSide(color: Colors.yellow),
      );

      final result = utility(BorderDirectionalMix.value(borderDirectional));
      expect(result, isA<UtilityTestAttribute>());
      expect(result.value, isA<MixProp<BorderDirectional>>());
    });

    test('none() creates BorderDirectionalMix.none', () {
      final result = utility.none();
      expect(result, isA<UtilityTestAttribute>());

      final mix = result.value.value;
      expect(mix, BorderDirectionalMix.none);
    });

    test('only() creates BorderDirectionalMix with specified sides', () {
      final topSide = BorderSideMix(color: Colors.red, width: 1.0);
      final startSide = BorderSideMix(color: Colors.green, width: 2.0);

      final result = utility.only(top: topSide, start: startSide);

      expect(result, isA<UtilityTestAttribute>());

      final mix = result.value.value as BorderDirectionalMix;
      expect(mix.$top, isNotNull);
      expect(mix.$bottom, isNull);
      expect(mix.$start, isNotNull);
      expect(mix.$end, isNull);
    });

    group('side utilities', () {
      test('all creates uniform border', () {
        final result = utility.all(
          BorderSideMix(color: Colors.red, width: 2.0),
        );

        final mix = result.value.value as BorderDirectionalMix;
        expect(mix.$top, isNotNull);
        expect(mix.$bottom, isNotNull);
        expect(mix.$start, isNotNull);
        expect(mix.$end, isNotNull);
      });

      test('horizontal creates start and end borders', () {
        final result = utility.horizontal(BorderSideMix(width: 1.0));

        final mix = result.value.value as BorderDirectionalMix;
        expect(mix.$top, isNull);
        expect(mix.$bottom, isNull);
        expect(mix.$start, isNotNull);
        expect(mix.$end, isNotNull);
      });

      test('vertical creates top and bottom borders', () {
        final result = utility.vertical(BorderSideMix(width: 1.0));

        final mix = result.value.value as BorderDirectionalMix;
        expect(mix.$top, isNotNull);
        expect(mix.$bottom, isNotNull);
        expect(mix.$start, isNull);
        expect(mix.$end, isNull);
      });

      test('start creates start border only', () {
        final result = utility.start(BorderSideMix(width: 1.0));

        final mix = result.value.value as BorderDirectionalMix;
        expect(mix.$top, isNull);
        expect(mix.$bottom, isNull);
        expect(mix.$start, isNotNull);
        expect(mix.$end, isNull);
      });

      test('end creates end border only', () {
        final result = utility.end(BorderSideMix(width: 1.0));

        final mix = result.value.value as BorderDirectionalMix;
        expect(mix.$top, isNull);
        expect(mix.$bottom, isNull);
        expect(mix.$start, isNull);
        expect(mix.$end, isNotNull);
      });
    });
  });

  group('BoxBorderUtility', () {
    final utility = BoxBorderUtility<UtilityTestAttribute>(
      (prop) => UtilityTestAttribute(prop),
    );

    test('supports Border type', () {
      final border = Border.all(color: Colors.red, width: 2.0);

      final result = utility(BorderMix.value(border));
      expect(result, isA<UtilityTestAttribute>());
      expect(result.value, isA<MixProp<BoxBorder>>());
    });

    test('supports BorderDirectional type', () {
      const borderDirectional = BorderDirectional(
        top: BorderSide(color: Colors.red),
        bottom: BorderSide(color: Colors.blue),
      );

      final result = utility(BorderDirectionalMix.value(borderDirectional));
      expect(result, isA<UtilityTestAttribute>());
      expect(result.value, isA<MixProp<BoxBorder>>());
    });

    test('only() creates BorderMix', () {
      final topSide = BorderSideMix(color: Colors.red, width: 1.0);

      final result = utility.border.only(top: topSide);

      expect(result, isA<UtilityTestAttribute>());

      final mix = result.value.value as BorderMix;
      expect(mix.$top, isNotNull);
    });

    test('none creates border with no sides', () {
      final result = utility.border.none();
      expect(result, isA<UtilityTestAttribute>());
    });

    group('directional access', () {
      test('start and end utilities work through directional', () {
        final resultStart = utility.borderDirectional.start(
          BorderSideMix(width: 1.0),
        );
        final resultEnd = utility.borderDirectional.end(
          BorderSideMix(width: 2.0),
        );

        expect(resultStart, isA<UtilityTestAttribute>());
        expect(resultEnd, isA<UtilityTestAttribute>());
      });
    });

    group('inherited utilities from BorderUtility', () {
      test('all creates uniform border', () {
        final result = utility.border.all(
          BorderSideMix(color: Colors.red, width: 2.0),
        );
        expect(result, isA<UtilityTestAttribute>());
      });

      test('color applies to all sides', () {
        final result = utility.border.color(Colors.green);
        expect(result, isA<UtilityTestAttribute>());
      });

      test('width applies to all sides', () {
        final result = utility.border.width(3.0);
        expect(result, isA<UtilityTestAttribute>());
      });

      test('style applies to all sides', () {
        final result = utility.border.style(BorderStyle.solid);
        expect(result, isA<UtilityTestAttribute>());
      });
    });
  });
}
