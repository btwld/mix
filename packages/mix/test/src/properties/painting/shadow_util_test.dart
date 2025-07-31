import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Shadow Utilities', () {
    group('ShadowUtility', () {
      final utility = ShadowUtility(UtilityTestAttribute.new);

      test('call() creates ShadowMix', () {
        final shadowMix = ShadowMix(
          color: Colors.black,
          blurRadius: 5.0,
          offset: const Offset(2, 2),
        );
        final attr = utility(shadowMix);
        expect(attr.value, isA<MixProp<Shadow>>());
      });

      test('as() creates ShadowMix from Shadow', () {
        const shadow = Shadow(
          color: Colors.red,
          blurRadius: 10.0,
          offset: Offset(1, 1),
        );
        final attr = utility.as(shadow);
        expect(attr.value, isA<MixProp<Shadow>>());
      });

      group('Property Utilities', () {
        test('blurRadius() creates shadow with blur radius', () {
          final attr = utility.blurRadius(8.0);
          expect(attr.value, isA<MixProp<Shadow>>());
        });

        test('color() creates shadow with color', () {
          final attr = utility.color(Colors.blue);
          expect(attr.value, isA<MixProp<Shadow>>());
        });

        test('color.red() creates shadow with red color', () {
          final attr = utility.color.red();
          expect(attr.value, isA<MixProp<Shadow>>());
        });

        test('offset() creates shadow with offset', () {
          final attr = utility.offset(const Offset(3, 3));
          expect(attr.value, isA<MixProp<Shadow>>());
        });

        test('offset.zero() creates shadow with zero offset', () {
          final attr = utility.offset.zero();
          expect(attr.value, isA<MixProp<Shadow>>());
        });
      });
    });

    group('BoxShadowUtility', () {
      final utility = BoxShadowUtility(UtilityTestAttribute.new);

      test('call() creates BoxShadowMix', () {
        final boxShadowMix = BoxShadowMix(
          color: Colors.black,
          blurRadius: 5.0,
          spreadRadius: 2.0,
          offset: const Offset(2, 2),
        );
        final attr = utility(boxShadowMix);
        expect(attr.value, isA<MixProp<BoxShadow>>());
      });

      test('as() creates BoxShadowMix from BoxShadow', () {
        const boxShadow = BoxShadow(
          color: Colors.grey,
          blurRadius: 10.0,
          spreadRadius: 1.0,
          offset: Offset(1, 1),
        );
        final attr = utility.as(boxShadow);
        expect(attr.value, isA<MixProp<BoxShadow>>());
      });

      group('Property Utilities', () {
        test('color() creates box shadow with color', () {
          final attr = utility.color(Colors.green);
          expect(attr.value, isA<MixProp<BoxShadow>>());
        });

        test('color.black() creates box shadow with black color', () {
          final attr = utility.color.black();
          expect(attr.value, isA<MixProp<BoxShadow>>());
        });

        test('offset() creates box shadow with offset', () {
          final attr = utility.offset(const Offset(4, 4));
          expect(attr.value, isA<MixProp<BoxShadow>>());
        });

        test('offset.infinite() creates box shadow with infinite offset', () {
          final attr = utility.offset.infinite();
          expect(attr.value, isA<MixProp<BoxShadow>>());
        });

        test('blurRadius() creates box shadow with blur radius', () {
          final attr = utility.blurRadius(12.0);
          expect(attr.value, isA<MixProp<BoxShadow>>());
        });

        test('blurRadius.zero() creates box shadow with zero blur radius', () {
          final attr = utility.blurRadius.zero();
          expect(attr.value, isA<MixProp<BoxShadow>>());
        });

        test('spreadRadius() creates box shadow with spread radius', () {
          final attr = utility.spreadRadius(3.0);
          expect(attr.value, isA<MixProp<BoxShadow>>());
        });

        test(
          'spreadRadius.infinity() creates box shadow with infinite spread',
          () {
            final attr = utility.spreadRadius.infinity();
            expect(attr.value, isA<MixProp<BoxShadow>>());
          },
        );
      });

      test('token() creates box shadow from token', () {
        const token = MixToken<BoxShadow>('test.boxShadow');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<BoxShadow>>());
      });
    });

    group('ElevationMixPropUtility', () {
      final utility = ElevationMixPropUtility(UtilityTestAttribute.new);

      test('call() creates elevation shadows', () {
        final attr = utility(4);
        expect(attr.value, isA<List<MixProp<BoxShadow>>>());
      });

      test('call() throws for invalid elevation', () {
        expect(() => utility(5), throwsA(isA<FlutterError>()));
      });

      group('Predefined Elevations', () {
        test('one creates elevation 1', () {
          final attr = utility.one;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('e1 creates elevation 1', () {
          final attr = utility.e1;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('two creates elevation 2', () {
          final attr = utility.two;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('e2 creates elevation 2', () {
          final attr = utility.e2;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('three creates elevation 3', () {
          final attr = utility.three;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('e3 creates elevation 3', () {
          final attr = utility.e3;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('four creates elevation 4', () {
          final attr = utility.four;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('e4 creates elevation 4', () {
          final attr = utility.e4;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('six creates elevation 6', () {
          final attr = utility.six;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('e6 creates elevation 6', () {
          final attr = utility.e6;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('eight creates elevation 8', () {
          final attr = utility.eight;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('e8 creates elevation 8', () {
          final attr = utility.e8;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('nine creates elevation 9', () {
          final attr = utility.nine;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('e9 creates elevation 9', () {
          final attr = utility.e9;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('twelve creates elevation 12', () {
          final attr = utility.twelve;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('e12 creates elevation 12', () {
          final attr = utility.e12;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('sixteen creates elevation 16', () {
          final attr = utility.sixteen;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('e16 creates elevation 16', () {
          final attr = utility.e16;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('twentyFour creates elevation 24', () {
          final attr = utility.twentyFour;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });

        test('e24 creates elevation 24', () {
          final attr = utility.e24;
          expect(attr.value, isA<List<MixProp<BoxShadow>>>());
        });
      });
    });
  });
}
