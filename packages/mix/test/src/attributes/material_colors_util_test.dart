import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Material Colors Utilities', () {
    group('MaterialColorUtility', () {
      final utility = MaterialColorUtility(
        UtilityTestAttribute.new,
        Colors.red,
      );

      test('call() creates color from MaterialColor', () {
        final attr = utility(Colors.blue);
        expectProp(attr.value, Colors.blue);
      });

      test('materialColor getter returns MaterialColor', () {
        expect(utility.materialColor, isA<MaterialColor>());
        expect(utility.materialColor, Colors.red);
      });

      group('Shade Utilities', () {
        test('shade50 creates color with shade 50', () {
          final attr = utility.shade50(Colors.red.shade50);
          expectProp(attr.value, Colors.red.shade50);
        });

        test('shade100 creates color with shade 100', () {
          final attr = utility.shade100(Colors.red.shade100);
          expectProp(attr.value, Colors.red.shade100);
        });

        test('shade200 creates color with shade 200', () {
          final attr = utility.shade200(Colors.red.shade200);
          expectProp(attr.value, Colors.red.shade200);
        });

        test('shade300 creates color with shade 300', () {
          final attr = utility.shade300(Colors.red.shade300);
          expectProp(attr.value, Colors.red.shade300);
        });

        test('shade400 creates color with shade 400', () {
          final attr = utility.shade400(Colors.red.shade400);
          expectProp(attr.value, Colors.red.shade400);
        });

        test('shade500 creates color with shade 500', () {
          final attr = utility.shade500(Colors.red.shade500);
          expectProp(attr.value, Colors.red.shade500);
        });

        test('shade600 creates color with shade 600', () {
          final attr = utility.shade600(Colors.red.shade600);
          expectProp(attr.value, Colors.red.shade600);
        });

        test('shade700 creates color with shade 700', () {
          final attr = utility.shade700(Colors.red.shade700);
          expectProp(attr.value, Colors.red.shade700);
        });

        test('shade800 creates color with shade 800', () {
          final attr = utility.shade800(Colors.red.shade800);
          expectProp(attr.value, Colors.red.shade800);
        });

        test('shade900 creates color with shade 900', () {
          final attr = utility.shade900(Colors.red.shade900);
          expectProp(attr.value, Colors.red.shade900);
        });
      });

      group('Color Directives on Shades', () {
        test('shade100 with opacity directive', () {
          final attr = utility.shade100.withOpacity(0.5);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives!.length, 1);
        });

        test('shade500 with alpha directive', () {
          final attr = utility.shade500.withAlpha(128);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives!.length, 1);
        });

        test('shade700 with darken directive', () {
          final attr = utility.shade700.darken(10);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives!.length, 1);
        });

        test('shade300 with lighten directive', () {
          final attr = utility.shade300.lighten(15);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives!.length, 1);
        });
      });

      group('Different Material Colors', () {
        test('blue MaterialColorUtility works correctly', () {
          final blueUtility = MaterialColorUtility(
            UtilityTestAttribute.new,
            Colors.blue,
          );
          final attr = blueUtility.shade200(Colors.blue.shade200);
          expectProp(attr.value, Colors.blue.shade200);
        });

        test('green MaterialColorUtility works correctly', () {
          final greenUtility = MaterialColorUtility(
            UtilityTestAttribute.new,
            Colors.green,
          );
          final attr = greenUtility.shade600(Colors.green.shade600);
          expectProp(attr.value, Colors.green.shade600);
        });

        test('purple MaterialColorUtility works correctly', () {
          final purpleUtility = MaterialColorUtility(
            UtilityTestAttribute.new,
            Colors.purple,
          );
          final attr = purpleUtility.shade400(Colors.purple.shade400);
          expectProp(attr.value, Colors.purple.shade400);
        });

        test('orange MaterialColorUtility works correctly', () {
          final orangeUtility = MaterialColorUtility(
            UtilityTestAttribute.new,
            Colors.orange,
          );
          final attr = orangeUtility.shade800(Colors.orange.shade800);
          expectProp(attr.value, Colors.orange.shade800);
        });
      });

      test('token() creates color from token', () {
        const token = MixToken<Color>('test.materialColor');
        final attr = utility.token(token);
        expect(attr.value.token, token);
      });
    });

    group('MaterialAccentColorUtility', () {
      final utility = MaterialAccentColorUtility(
        UtilityTestAttribute.new,
        Colors.redAccent,
      );

      test('call() creates color from MaterialAccentColor', () {
        final attr = utility(Colors.blueAccent);
        expectProp(attr.value, Colors.blueAccent);
      });

      test('materialAccentColor getter returns MaterialAccentColor', () {
        expect(utility.materialAccentColor, isA<MaterialAccentColor>());
        expect(utility.materialAccentColor, Colors.redAccent);
      });

      group('Accent Shade Utilities', () {
        test('shade100 creates accent color with shade 100', () {
          final attr = utility.shade100(Colors.redAccent.shade100);
          expectProp(attr.value, Colors.redAccent.shade100);
        });

        test('shade200 creates accent color with shade 200', () {
          final attr = utility.shade200(Colors.redAccent.shade200);
          expectProp(attr.value, Colors.redAccent.shade200);
        });

        test('shade400 creates accent color with shade 400', () {
          final attr = utility.shade400(Colors.redAccent.shade400);
          expectProp(attr.value, Colors.redAccent.shade400);
        });

        test('shade700 creates accent color with shade 700', () {
          final attr = utility.shade700(Colors.redAccent.shade700);
          expectProp(attr.value, Colors.redAccent.shade700);
        });
      });

      group('Color Directives on Accent Shades', () {
        test('shade100 with opacity directive', () {
          final attr = utility.shade100.withOpacity(0.7);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives!.length, 1);
        });

        test('shade400 with alpha directive', () {
          final attr = utility.shade400.withAlpha(200);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives!.length, 1);
        });

        test('shade700 with saturate directive', () {
          final attr = utility.shade700.saturate(20);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives!.length, 1);
        });

        test('shade200 with desaturate directive', () {
          final attr = utility.shade200.desaturate(10);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives!.length, 1);
        });
      });

      group('Different Material Accent Colors', () {
        test('blueAccent MaterialAccentColorUtility works correctly', () {
          final blueAccentUtility = MaterialAccentColorUtility(
            UtilityTestAttribute.new,
            Colors.blueAccent,
          );
          final attr = blueAccentUtility.shade200(Colors.blueAccent.shade200);
          expectProp(attr.value, Colors.blueAccent.shade200);
        });

        test('greenAccent MaterialAccentColorUtility works correctly', () {
          final greenAccentUtility = MaterialAccentColorUtility(
            UtilityTestAttribute.new,
            Colors.greenAccent,
          );
          final attr = greenAccentUtility.shade400(Colors.greenAccent.shade400);
          expectProp(attr.value, Colors.greenAccent.shade400);
        });

        test('purpleAccent MaterialAccentColorUtility works correctly', () {
          final purpleAccentUtility = MaterialAccentColorUtility(
            UtilityTestAttribute.new,
            Colors.purpleAccent,
          );
          final attr = purpleAccentUtility.shade100(
            Colors.purpleAccent.shade100,
          );
          expectProp(attr.value, Colors.purpleAccent.shade100);
        });

        test('orangeAccent MaterialAccentColorUtility works correctly', () {
          final orangeAccentUtility = MaterialAccentColorUtility(
            UtilityTestAttribute.new,
            Colors.orangeAccent,
          );
          final attr = orangeAccentUtility.shade700(
            Colors.orangeAccent.shade700,
          );
          expectProp(attr.value, Colors.orangeAccent.shade700);
        });
      });

      test('token() creates accent color from token', () {
        const token = MixToken<Color>('test.materialAccentColor');
        final attr = utility.token(token);
        expect(attr.value.token, token);
      });
    });

    group('ColorsUtilityMixin Integration', () {
      final colorUtility = ColorUtility(UtilityTestAttribute.new);

      group('Primary Material Colors', () {
        test('red() creates red color with default shade', () {
          final attr = colorUtility.red();
          expectProp(attr.value, Colors.red);
        });

        test('red(100) creates red color with shade 100', () {
          final attr = colorUtility.red(100);
          expectProp(attr.value, Colors.red.shade100);
        });

        test('blue(300) creates blue color with shade 300', () {
          final attr = colorUtility.blue(300);
          expectProp(attr.value, Colors.blue.shade300);
        });

        test('green(600) creates green color with shade 600', () {
          final attr = colorUtility.green(600);
          expectProp(attr.value, Colors.green.shade600);
        });

        test('purple(900) creates purple color with shade 900', () {
          final attr = colorUtility.purple(900);
          expectProp(attr.value, Colors.purple.shade900);
        });
      });

      group('Extended Material Colors', () {
        test('deepPurple() creates deep purple color', () {
          final attr = colorUtility.deepPurple();
          expectProp(attr.value, Colors.deepPurple);
        });

        test('lightBlue(200) creates light blue color with shade 200', () {
          final attr = colorUtility.lightBlue(200);
          expectProp(attr.value, Colors.lightBlue.shade200);
        });

        test('teal(500) creates teal color with shade 500', () {
          final attr = colorUtility.teal(500);
          expectProp(attr.value, Colors.teal.shade500);
        });

        test('amber(700) creates amber color with shade 700', () {
          final attr = colorUtility.amber(700);
          expectProp(attr.value, Colors.amber.shade700);
        });

        test('deepOrange(400) creates deep orange color with shade 400', () {
          final attr = colorUtility.deepOrange(400);
          expectProp(attr.value, Colors.deepOrange.shade400);
        });

        test('brown(800) creates brown color with shade 800', () {
          final attr = colorUtility.brown(800);
          expectProp(attr.value, Colors.brown.shade800);
        });

        test('grey(300) creates grey color with shade 300', () {
          final attr = colorUtility.grey(300);
          expectProp(attr.value, Colors.grey.shade300);
        });

        test('blueGrey(600) creates blue grey color with shade 600', () {
          final attr = colorUtility.blueGrey(600);
          expectProp(attr.value, Colors.blueGrey.shade600);
        });
      });

      group('Accent Material Colors', () {
        test('redAccent() creates red accent color with default shade', () {
          final attr = colorUtility.redAccent();
          expectProp(attr.value, Colors.redAccent);
        });

        test('blueAccent(100) creates blue accent color with shade 100', () {
          final attr = colorUtility.blueAccent(100);
          expectProp(attr.value, Colors.blueAccent.shade100);
        });

        test('greenAccent(400) creates green accent color with shade 400', () {
          final attr = colorUtility.greenAccent(400);
          expectProp(attr.value, Colors.greenAccent.shade400);
        });

        test(
          'purpleAccent(700) creates purple accent color with shade 700',
          () {
            final attr = colorUtility.purpleAccent(700);
            expectProp(attr.value, Colors.purpleAccent.shade700);
          },
        );

        test(
          'deepPurpleAccent(200) creates deep purple accent color with shade 200',
          () {
            final attr = colorUtility.deepPurpleAccent(200);
            expectProp(attr.value, Colors.deepPurpleAccent.shade200);
          },
        );

        test(
          'lightBlueAccent(100) creates light blue accent color with shade 100',
          () {
            final attr = colorUtility.lightBlueAccent(100);
            expectProp(attr.value, Colors.lightBlueAccent.shade100);
          },
        );

        test('tealAccent(400) creates teal accent color with shade 400', () {
          final attr = colorUtility.tealAccent(400);
          expectProp(attr.value, Colors.tealAccent.shade400);
        });

        test('amberAccent(700) creates amber accent color with shade 700', () {
          final attr = colorUtility.amberAccent(700);
          expectProp(attr.value, Colors.amberAccent.shade700);
        });

        test(
          'deepOrangeAccent(200) creates deep orange accent color with shade 200',
          () {
            final attr = colorUtility.deepOrangeAccent(200);
            expectProp(attr.value, Colors.deepOrangeAccent.shade200);
          },
        );
      });

      group('Edge Cases', () {
        test('handles invalid shade gracefully by using default', () {
          // When no shade is specified, _wrapColor returns the MaterialColor itself
          final attr = colorUtility.red();
          expectProp(attr.value, Colors.red);
        });

        test('handles all available shades for primary colors', () {
          final shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
          for (final shade in shades) {
            final attr = colorUtility.blue(shade);
            expectProp(attr.value, Colors.blue[shade]);
          }
        });

        test('handles all available shades for accent colors', () {
          final accentShades = [100, 200, 400, 700];
          for (final shade in accentShades) {
            final attr = colorUtility.redAccent(shade);
            expectProp(attr.value, Colors.redAccent[shade]);
          }
        });
      });
    });
  });
}
