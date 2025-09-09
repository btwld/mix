import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('MixColors', () {
    group('Basic Colors', () {
      test('transparent is fully transparent', () {
        expect(MixColors.transparent.toARGB32(), 0x00000000);
      });

      test('black is fully opaque black', () {
        expect(MixColors.black.toARGB32(), 0xFF000000);
      });

      test('white is fully opaque white', () {
        expect(MixColors.white.toARGB32(), 0xFFFFFFFF);
      });
    });

    group('Black Variants', () {
      test('black87 has correct value', () {
        expect(MixColors.black87.toARGB32(), 0xDD000000);
      });

      test('black54 has correct value', () {
        expect(MixColors.black54.toARGB32(), 0x8A000000);
      });

      test('black45 has correct value', () {
        expect(MixColors.black45.toARGB32(), 0x73000000);
      });

      test('black38 has correct value', () {
        expect(MixColors.black38.toARGB32(), 0x61000000);
      });

      test('black26 has correct value', () {
        expect(MixColors.black26.toARGB32(), 0x42000000);
      });

      test('black12 has correct value', () {
        expect(MixColors.black12.toARGB32(), 0x1F000000);
      });
    });

    group('White Variants', () {
      test('white70 has correct value', () {
        expect(MixColors.white70.toARGB32(), 0xB3FFFFFF);
      });

      test('white60 has correct value', () {
        expect(MixColors.white60.toARGB32(), 0x99FFFFFF);
      });

      test('white54 has correct value', () {
        expect(MixColors.white54.toARGB32(), 0x8AFFFFFF);
      });

      test('white38 has correct value', () {
        expect(MixColors.white38.toARGB32(), 0x62FFFFFF);
      });

      test('white30 has correct value', () {
        expect(MixColors.white30.toARGB32(), 0x4DFFFFFF);
      });

      test('white24 has correct value', () {
        expect(MixColors.white24.toARGB32(), 0x3DFFFFFF);
      });

      test('white12 has correct value', () {
        expect(MixColors.white12.toARGB32(), 0x1FFFFFFF);
      });

      test('white10 has correct value', () {
        expect(MixColors.white10.toARGB32(), 0x1AFFFFFF);
      });
    });

    group('Primary Color Swatches', () {
      test('red swatch has correct primary color and shades', () {
        expect(MixColors.red, MixColors.redSwatch);
        expect(MixColors.redSwatch.toARGB32(), 0xFFF44336);
        expect(MixColors.redSwatch[50]!.toARGB32(), 0xFFFFEBEE);
        expect(MixColors.redSwatch[500]!.toARGB32(), 0xFFF44336);
        expect(MixColors.redSwatch[900]!.toARGB32(), 0xFFB71C1C);
      });

      test('blue swatch has correct primary color and shades', () {
        expect(MixColors.blue, MixColors.blueSwatch);
        expect(MixColors.blueSwatch.toARGB32(), 0xFF2196F3);
        expect(MixColors.blueSwatch[50]!.toARGB32(), 0xFFE3F2FD);
        expect(MixColors.blueSwatch[500]!.toARGB32(), 0xFF2196F3);
        expect(MixColors.blueSwatch[900]!.toARGB32(), 0xFF0D47A1);
      });

      test('green swatch has correct primary color and shades', () {
        expect(MixColors.green, MixColors.greenSwatch);
        expect(MixColors.greenSwatch.toARGB32(), 0xFF4CAF50);
        expect(MixColors.greenSwatch[50]!.toARGB32(), 0xFFE8F5E9);
        expect(MixColors.greenSwatch[500]!.toARGB32(), 0xFF4CAF50);
        expect(MixColors.greenSwatch[900]!.toARGB32(), 0xFF1B5E20);
      });

      test('purple swatch has correct primary color and shades', () {
        expect(MixColors.purple, MixColors.purpleSwatch);
        expect(MixColors.purpleSwatch.toARGB32(), 0xFF9C27B0);
        expect(MixColors.purpleSwatch[50]!.toARGB32(), 0xFFF3E5F5);
        expect(MixColors.purpleSwatch[500]!.toARGB32(), 0xFF9C27B0);
        expect(MixColors.purpleSwatch[900]!.toARGB32(), 0xFF4A148C);
      });

      test(
        'grey swatch has correct primary color and shades including 350 and 850',
        () {
          expect(MixColors.grey, MixColors.greySwatch);
          expect(MixColors.greySwatch.toARGB32(), 0xFF9E9E9E);
          expect(MixColors.greySwatch[50]!.toARGB32(), 0xFFFAFAFA);
          expect(MixColors.greySwatch[350]!.toARGB32(), 0xFFD6D6D6);
          expect(MixColors.greySwatch[500]!.toARGB32(), 0xFF9E9E9E);
          expect(MixColors.greySwatch[850]!.toARGB32(), 0xFF303030);
          expect(MixColors.greySwatch[900]!.toARGB32(), 0xFF212121);
        },
      );
    });

    group('Accent Color Swatches', () {
      test('redAccent swatch has correct primary color and limited shades', () {
        expect(MixColors.redAccent, MixColors.redAccentSwatch);
        expect(MixColors.redAccentSwatch.toARGB32(), 0xFFFF5252);
        expect(MixColors.redAccentSwatch[100]!.toARGB32(), 0xFFFF8A80);
        expect(MixColors.redAccentSwatch[200]!.toARGB32(), 0xFFFF5252);
        expect(MixColors.redAccentSwatch[400]!.toARGB32(), 0xFFFF1744);
        expect(MixColors.redAccentSwatch[700]!.toARGB32(), 0xFFD50000);
      });

      test(
        'blueAccent swatch has correct primary color and limited shades',
        () {
          expect(MixColors.blueAccent, MixColors.blueAccentSwatch);
          expect(MixColors.blueAccentSwatch.toARGB32(), 0xFF448AFF);
          expect(MixColors.blueAccentSwatch[100]!.toARGB32(), 0xFF82B1FF);
          expect(MixColors.blueAccentSwatch[200]!.toARGB32(), 0xFF448AFF);
          expect(MixColors.blueAccentSwatch[400]!.toARGB32(), 0xFF2979FF);
          expect(MixColors.blueAccentSwatch[700]!.toARGB32(), 0xFF2962FF);
        },
      );
    });

    group('Color Alias Consistency', () {
      test('all color aliases point to correct swatches', () {
        expect(MixColors.red, MixColors.redSwatch);
        expect(MixColors.pink, MixColors.pinkSwatch);
        expect(MixColors.purple, MixColors.purpleSwatch);
        expect(MixColors.deepPurple, MixColors.deepPurpleSwatch);
        expect(MixColors.indigo, MixColors.indigoSwatch);
        expect(MixColors.blue, MixColors.blueSwatch);
        expect(MixColors.lightBlue, MixColors.lightBlueSwatch);
        expect(MixColors.cyan, MixColors.cyanSwatch);
        expect(MixColors.teal, MixColors.tealSwatch);
        expect(MixColors.green, MixColors.greenSwatch);
        expect(MixColors.lightGreen, MixColors.lightGreenSwatch);
        expect(MixColors.lime, MixColors.limeSwatch);
        expect(MixColors.yellow, MixColors.yellowSwatch);
        expect(MixColors.amber, MixColors.amberSwatch);
        expect(MixColors.orange, MixColors.orangeSwatch);
        expect(MixColors.deepOrange, MixColors.deepOrangeSwatch);
        expect(MixColors.brown, MixColors.brownSwatch);
        expect(MixColors.grey, MixColors.greySwatch);
        expect(MixColors.blueGrey, MixColors.blueGreySwatch);
      });

      test('all accent color aliases point to correct swatches', () {
        expect(MixColors.redAccent, MixColors.redAccentSwatch);
        expect(MixColors.pinkAccent, MixColors.pinkAccentSwatch);
        expect(MixColors.purpleAccent, MixColors.purpleAccentSwatch);
        expect(MixColors.deepPurpleAccent, MixColors.deepPurpleAccentSwatch);
        expect(MixColors.indigoAccent, MixColors.indigoAccentSwatch);
        expect(MixColors.blueAccent, MixColors.blueAccentSwatch);
        expect(MixColors.lightBlueAccent, MixColors.lightBlueAccentSwatch);
        expect(MixColors.cyanAccent, MixColors.cyanAccentSwatch);
        expect(MixColors.tealAccent, MixColors.tealAccentSwatch);
        expect(MixColors.greenAccent, MixColors.greenAccentSwatch);
        expect(MixColors.lightGreenAccent, MixColors.lightGreenAccentSwatch);
        expect(MixColors.limeAccent, MixColors.limeAccentSwatch);
        expect(MixColors.yellowAccent, MixColors.yellowAccentSwatch);
        expect(MixColors.amberAccent, MixColors.amberAccentSwatch);
        expect(MixColors.orangeAccent, MixColors.orangeAccentSwatch);
        expect(MixColors.deepOrangeAccent, MixColors.deepOrangeAccentSwatch);
      });
    });

    group('ColorSwatch Properties', () {
      test('standard shades exist in primary color swatches', () {
        final standardShades = [
          50,
          100,
          200,
          300,
          400,
          500,
          600,
          700,
          800,
          900,
        ];

        for (final shade in standardShades) {
          expect(MixColors.redSwatch[shade], isNotNull);
          expect(MixColors.blueSwatch[shade], isNotNull);
          expect(MixColors.greenSwatch[shade], isNotNull);
          expect(MixColors.yellowSwatch[shade], isNotNull);
        }
      });

      test('accent shades exist in accent color swatches', () {
        final accentShades = [100, 200, 400, 700];

        for (final shade in accentShades) {
          expect(MixColors.redAccentSwatch[shade], isNotNull);
          expect(MixColors.blueAccentSwatch[shade], isNotNull);
          expect(MixColors.greenAccentSwatch[shade], isNotNull);
          expect(MixColors.yellowAccentSwatch[shade], isNotNull);
        }
      });
    });

    group('Shade Access', () {
      test('MixColors shade access works with specific shades', () {
        final lightBlue = MixColors.blueSwatch[100];
        final darkBlue = MixColors.blueSwatch[900];

        expect(lightBlue, isNotNull);
        expect(darkBlue, isNotNull);
        expect(lightBlue!.toARGB32(), 0xFFBBDEFB);
        expect(darkBlue!.toARGB32(), 0xFF0D47A1);
      });
    });
  });
}
