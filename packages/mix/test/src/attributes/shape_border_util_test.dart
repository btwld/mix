import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Shape Border Utilities', () {
    group('ShapeBorderUtility', () {
      final utility = ShapeBorderUtility(UtilityTestAttribute.new);

      test('call() creates ShapeBorderMix', () {
        final shapeBorderMix = RoundedRectangleBorderMix.only(
          borderRadius: BorderRadiusMix.only(
            topLeft: const Radius.circular(8.0),
            topRight: const Radius.circular(8.0),
          ),
          side: BorderSideMix.only(color: Colors.red, width: 2.0),
        );
        final attr = utility(shapeBorderMix);
        expect(attr.value, isA<Prop<Mix<ShapeBorder>>>());
      });

      test('as() creates ShapeBorderMix from RoundedRectangleBorder', () {
        const shapeBorder = RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          side: BorderSide(color: Colors.blue, width: 1.0),
        );
        final attr = utility.as(shapeBorder);
        expect(attr.value, isA<Prop<Mix<ShapeBorder>>>());
      });

      test('as() creates ShapeBorderMix from CircleBorder', () {
        const shapeBorder = CircleBorder(
          side: BorderSide(color: Colors.green, width: 3.0),
        );
        final attr = utility.as(shapeBorder);
        expect(attr.value, isA<Prop<Mix<ShapeBorder>>>());
      });

      group('Nested Utilities', () {
        test(
          'roundedRectangle provides access to RoundedRectangleBorderUtility',
          () {
            final attr = utility.roundedRectangle.borderRadius.circular(8.0);
            expect(attr.value, isA<Prop<Mix<ShapeBorder>>>());
          },
        );

        test('beveled provides access to BeveledRectangleBorderUtility', () {
          final attr = utility.beveled.borderRadius.circular(6.0);
          expect(attr.value, isA<Prop<Mix<ShapeBorder>>>());
        });

        test(
          'continuous provides access to ContinuousRectangleBorderUtility',
          () {
            final attr = utility.continuous.borderRadius.circular(10.0);
            expect(attr.value, isA<Prop<Mix<ShapeBorder>>>());
          },
        );

        test('circle provides access to CircleBorderUtility', () {
          final attr = utility.circle.side.color(Colors.red);
          expect(attr.value, isA<Prop<Mix<ShapeBorder>>>());
        });

        test('star provides access to StarBorderUtility', () {
          final attr = utility.star.points(5);
          expect(attr.value, isA<Prop<Mix<ShapeBorder>>>());
        });

        test('linear provides access to LinearBorderUtility', () {
          final attr = utility.linear.side.width(2.0);
          expect(attr.value, isA<Prop<Mix<ShapeBorder>>>());
        });

        test('stadium provides access to StadiumBorderUtility', () {
          final attr = utility.stadium.side.color(Colors.blue);
          expect(attr.value, isA<Prop<Mix<ShapeBorder>>>());
        });
      });

      test('token() creates shape border from token', () {
        const token = MixToken<ShapeBorderMix>('test.shapeBorder');
        final attr = utility.token(token);
        expect(attr.value, isA<Prop<Mix<ShapeBorder>>>());
      });
    });

    group('RoundedRectangleBorderUtility', () {
      final utility = RoundedRectangleBorderUtility(UtilityTestAttribute.new);

      test('call() creates RoundedRectangleBorderMix', () {
        final borderMix = RoundedRectangleBorderMix.only(
          borderRadius: BorderRadiusMix.only(
            topLeft: const Radius.circular(8.0),
            bottomRight: const Radius.circular(12.0),
          ),
          side: BorderSideMix.only(color: Colors.red, width: 2.0),
        );
        final attr = utility(borderMix);
        expect(attr.value, isA<Prop<Mix<RoundedRectangleBorder>>>());
      });

      test(
        'as() creates RoundedRectangleBorderMix from RoundedRectangleBorder',
        () {
          const border = RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            side: BorderSide(color: Colors.blue, width: 1.5),
          );
          final attr = utility.as(border);
          expect(attr.value, isA<Prop<Mix<RoundedRectangleBorder>>>());
        },
      );

      group('Property Utilities', () {
        test(
          'borderRadius() creates rounded rectangle border with border radius',
          () {
            final borderRadiusMix = BorderRadiusMix.only(
              topLeft: const Radius.circular(8.0),
              topRight: const Radius.circular(8.0),
            );
            final attr = utility.borderRadius(borderRadiusMix);
            expect(attr.value, isA<Prop<Mix<RoundedRectangleBorder>>>());
          },
        );

        test(
          'borderRadius.circular() creates rounded rectangle border with circular radius',
          () {
            final attr = utility.borderRadius.circular(12.0);
            expect(attr.value, isA<Prop<Mix<RoundedRectangleBorder>>>());
          },
        );

        test(
          'borderRadius.topLeft() creates rounded rectangle border with top left radius',
          () {
            final attr = utility.borderRadius.topLeft.circular(8.0);
            expect(attr.value, isA<Prop<Mix<RoundedRectangleBorder>>>());
          },
        );

        test('side() creates rounded rectangle border with side', () {
          final borderSideMix = BorderSideMix.only(
            color: Colors.green,
            width: 3.0,
          );
          final attr = utility.side(borderSideMix);
          expect(attr.value, isA<Prop<Mix<RoundedRectangleBorder>>>());
        });

        test(
          'side.color() creates rounded rectangle border with side color',
          () {
            final attr = utility.side.color(Colors.purple);
            expect(attr.value, isA<Prop<Mix<RoundedRectangleBorder>>>());
          },
        );

        test(
          'side.width() creates rounded rectangle border with side width',
          () {
            final attr = utility.side.width(2.5);
            expect(attr.value, isA<Prop<Mix<RoundedRectangleBorder>>>());
          },
        );

        test(
          'side.style() creates rounded rectangle border with side style',
          () {
            final attr = utility.side.style(BorderStyle.solid);
            expect(attr.value, isA<Prop<Mix<RoundedRectangleBorder>>>());
          },
        );
      });

      test('token() creates rounded rectangle border from token', () {
        const token = MixToken<RoundedRectangleBorderMix>(
          'test.roundedRectangleBorder',
        );
        final attr = utility.token(token);
        expect(attr.value, isA<Prop<Mix<RoundedRectangleBorder>>>());
      });
    });

    group('CircleBorderUtility', () {
      final utility = CircleBorderUtility(UtilityTestAttribute.new);

      test('call() creates CircleBorderMix', () {
        final borderMix = CircleBorderMix.only(
          side: BorderSideMix.only(color: Colors.red, width: 2.0),
          eccentricity: 0.5,
        );
        final attr = utility(borderMix);
        expect(attr.value, isA<Prop<Mix<CircleBorder>>>());
      });

      test('as() creates CircleBorderMix from CircleBorder', () {
        const border = CircleBorder(
          side: BorderSide(color: Colors.blue, width: 1.5),
          eccentricity: 0.8,
        );
        final attr = utility.as(border);
        expect(attr.value, isA<Prop<Mix<CircleBorder>>>());
      });

      group('Property Utilities', () {
        test('side() creates circle border with side', () {
          final borderSideMix = BorderSideMix.only(
            color: Colors.green,
            width: 3.0,
          );
          final attr = utility.side(borderSideMix);
          expect(attr.value, isA<Prop<Mix<CircleBorder>>>());
        });

        test('side.color() creates circle border with side color', () {
          final attr = utility.side.color(Colors.orange);
          expect(attr.value, isA<Prop<Mix<CircleBorder>>>());
        });

        test('side.width() creates circle border with side width', () {
          final attr = utility.side.width(4.0);
          expect(attr.value, isA<Prop<Mix<CircleBorder>>>());
        });

        test('eccentricity() creates circle border with eccentricity', () {
          final attr = utility.eccentricity(0.7);
          expect(attr.value, isA<Prop<Mix<CircleBorder>>>());
        });

        test(
          'eccentricity.zero() creates circle border with zero eccentricity',
          () {
            final attr = utility.eccentricity.zero();
            expect(attr.value, isA<Prop<Mix<CircleBorder>>>());
          },
        );

        test(
          'eccentricity.infinity() creates circle border with infinite eccentricity',
          () {
            final attr = utility.eccentricity.infinity();
            expect(attr.value, isA<Prop<Mix<CircleBorder>>>());
          },
        );
      });

      test('token() creates circle border from token', () {
        const token = MixToken<CircleBorderMix>('test.circleBorder');
        final attr = utility.token(token);
        expect(attr.value, isA<Prop<Mix<CircleBorder>>>());
      });
    });

    group('StadiumBorderUtility', () {
      final utility = StadiumBorderUtility(UtilityTestAttribute.new);

      test('call() creates StadiumBorderMix', () {
        final borderMix = StadiumBorderMix.only(
          side: BorderSideMix.only(color: Colors.red, width: 2.0),
        );
        final attr = utility(borderMix);
        expect(attr.value, isA<Prop<Mix<StadiumBorder>>>());
      });

      test('as() creates StadiumBorderMix from StadiumBorder', () {
        const border = StadiumBorder(
          side: BorderSide(color: Colors.blue, width: 1.5),
        );
        final attr = utility.as(border);
        expect(attr.value, isA<Prop<Mix<StadiumBorder>>>());
      });

      group('Property Utilities', () {
        test('side() creates stadium border with side', () {
          final borderSideMix = BorderSideMix.only(
            color: Colors.green,
            width: 3.0,
          );
          final attr = utility.side(borderSideMix);
          expect(attr.value, isA<Prop<Mix<StadiumBorder>>>());
        });

        test('side.color() creates stadium border with side color', () {
          final attr = utility.side.color(Colors.pink);
          expect(attr.value, isA<Prop<Mix<StadiumBorder>>>());
        });

        test('side.width() creates stadium border with side width', () {
          final attr = utility.side.width(2.5);
          expect(attr.value, isA<Prop<Mix<StadiumBorder>>>());
        });

        test('side.style() creates stadium border with side style', () {
          final attr = utility.side.style(BorderStyle.solid);
          expect(attr.value, isA<Prop<Mix<StadiumBorder>>>());
        });
      });

      test('token() creates stadium border from token', () {
        const token = MixToken<StadiumBorderMix>('test.stadiumBorder');
        final attr = utility.token(token);
        expect(attr.value, isA<Prop<Mix<StadiumBorder>>>());
      });
    });

    group('BeveledRectangleBorderUtility', () {
      final utility = BeveledRectangleBorderUtility(UtilityTestAttribute.new);

      test('call() creates BeveledRectangleBorderMix', () {
        final borderMix = BeveledRectangleBorderMix.only(
          borderRadius: BorderRadiusMix.only(
            topLeft: const Radius.circular(8.0),
            bottomRight: const Radius.circular(12.0),
          ),
          side: BorderSideMix.only(color: Colors.red, width: 2.0),
        );
        final attr = utility(borderMix);
        expect(attr.value, isA<Prop<Mix<BeveledRectangleBorder>>>());
      });

      test(
        'as() creates BeveledRectangleBorderMix from BeveledRectangleBorder',
        () {
          const border = BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            side: BorderSide(color: Colors.blue, width: 1.5),
          );
          final attr = utility.as(border);
          expect(attr.value, isA<Prop<Mix<BeveledRectangleBorder>>>());
        },
      );

      group('Property Utilities', () {
        test(
          'borderRadius() creates beveled rectangle border with border radius',
          () {
            final borderRadiusMix = BorderRadiusMix.only(
              topLeft: const Radius.circular(6.0),
              topRight: const Radius.circular(6.0),
            );
            final attr = utility.borderRadius(borderRadiusMix);
            expect(attr.value, isA<Prop<Mix<BeveledRectangleBorder>>>());
          },
        );

        test(
          'borderRadius.circular() creates beveled rectangle border with circular radius',
          () {
            final attr = utility.borderRadius.circular(10.0);
            expect(attr.value, isA<Prop<Mix<BeveledRectangleBorder>>>());
          },
        );

        test('side() creates beveled rectangle border with side', () {
          final borderSideMix = BorderSideMix.only(
            color: Colors.green,
            width: 3.0,
          );
          final attr = utility.side(borderSideMix);
          expect(attr.value, isA<Prop<Mix<BeveledRectangleBorder>>>());
        });

        test(
          'side.color() creates beveled rectangle border with side color',
          () {
            final attr = utility.side.color(Colors.yellow);
            expect(attr.value, isA<Prop<Mix<BeveledRectangleBorder>>>());
          },
        );
      });

      test('token() creates beveled rectangle border from token', () {
        const token = MixToken<BeveledRectangleBorderMix>(
          'test.beveledRectangleBorder',
        );
        final attr = utility.token(token);
        expect(attr.value, isA<Prop<Mix<BeveledRectangleBorder>>>());
      });
    });

    group('ContinuousRectangleBorderUtility', () {
      final utility = ContinuousRectangleBorderUtility(
        UtilityTestAttribute.new,
      );

      test('call() creates ContinuousRectangleBorderMix', () {
        final borderMix = ContinuousRectangleBorderMix.only(
          borderRadius: BorderRadiusMix.only(
            topLeft: const Radius.circular(8.0),
            bottomRight: const Radius.circular(12.0),
          ),
          side: BorderSideMix.only(color: Colors.red, width: 2.0),
        );
        final attr = utility(borderMix);
        expect(attr.value, isA<Prop<Mix<ContinuousRectangleBorder>>>());
      });

      test(
        'as() creates ContinuousRectangleBorderMix from ContinuousRectangleBorder',
        () {
          const border = ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            side: BorderSide(color: Colors.blue, width: 1.5),
          );
          final attr = utility.as(border);
          expect(attr.value, isA<Prop<Mix<ContinuousRectangleBorder>>>());
        },
      );

      group('Property Utilities', () {
        test(
          'borderRadius() creates continuous rectangle border with border radius',
          () {
            final borderRadiusMix = BorderRadiusMix.only(
              topLeft: const Radius.circular(14.0),
              topRight: const Radius.circular(14.0),
            );
            final attr = utility.borderRadius(borderRadiusMix);
            expect(attr.value, isA<Prop<Mix<ContinuousRectangleBorder>>>());
          },
        );

        test(
          'borderRadius.circular() creates continuous rectangle border with circular radius',
          () {
            final attr = utility.borderRadius.circular(18.0);
            expect(attr.value, isA<Prop<Mix<ContinuousRectangleBorder>>>());
          },
        );

        test('side() creates continuous rectangle border with side', () {
          final borderSideMix = BorderSideMix.only(
            color: Colors.green,
            width: 3.0,
          );
          final attr = utility.side(borderSideMix);
          expect(attr.value, isA<Prop<Mix<ContinuousRectangleBorder>>>());
        });

        test(
          'side.color() creates continuous rectangle border with side color',
          () {
            final attr = utility.side.color(Colors.cyan);
            expect(attr.value, isA<Prop<Mix<ContinuousRectangleBorder>>>());
          },
        );
      });

      test('token() creates continuous rectangle border from token', () {
        const token = MixToken<ContinuousRectangleBorderMix>(
          'test.continuousRectangleBorder',
        );
        final attr = utility.token(token);
        expect(attr.value, isA<Prop<Mix<ContinuousRectangleBorder>>>());
      });
    });
  });
}
