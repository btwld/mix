import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Color Utilities', () {
    group('ColorUtility', () {
      final utility = ColorUtility(UtilityTestAttribute.new);

      test('call() creates color from value', () {
        final attr = utility(Colors.red);
        expect(attr.value, resolvesTo(Colors.red));
      });

      test('token() creates color from token', () {
        const token = MixToken<Color>('test.color');
        final attr = utility.token(token);
        expect(attr.value.getToken(), token);
      });

      group('Basic Colors', () {
        test('transparent() creates transparent color', () {
          final attr = utility.transparent();
          expect(attr.value, resolvesTo(Colors.transparent));
        });

        test('black() creates black color', () {
          final attr = utility.black();
          expect(attr.value, resolvesTo(Colors.black));
        });

        test('black87() creates black87 color', () {
          final attr = utility.black87();
          expect(attr.value, resolvesTo(Colors.black87));
        });

        test('black54() creates black54 color', () {
          final attr = utility.black54();
          expect(attr.value, resolvesTo(Colors.black54));
        });

        test('black45() creates black45 color', () {
          final attr = utility.black45();
          expect(attr.value, resolvesTo(Colors.black45));
        });

        test('black38() creates black38 color', () {
          final attr = utility.black38();
          expect(attr.value, resolvesTo(Colors.black38));
        });

        test('black26() creates black26 color', () {
          final attr = utility.black26();
          expect(attr.value, resolvesTo(Colors.black26));
        });

        test('black12() creates black12 color', () {
          final attr = utility.black12();
          expect(attr.value, resolvesTo(Colors.black12));
        });

        test('white() creates white color', () {
          final attr = utility.white();
          expect(attr.value, resolvesTo(Colors.white));
        });

        test('white70() creates white70 color', () {
          final attr = utility.white70();
          expect(attr.value, resolvesTo(Colors.white70));
        });

        test('white60() creates white60 color', () {
          final attr = utility.white60();
          expect(attr.value, resolvesTo(Colors.white60));
        });

        test('white54() creates white54 color', () {
          final attr = utility.white54();
          expect(attr.value, resolvesTo(Colors.white54));
        });

        test('white38() creates white38 color', () {
          final attr = utility.white38();
          expect(attr.value, resolvesTo(Colors.white38));
        });

        test('white30() creates white30 color', () {
          final attr = utility.white30();
          expect(attr.value, resolvesTo(Colors.white30));
        });

        test('white24() creates white24 color', () {
          final attr = utility.white24();
          expect(attr.value, resolvesTo(Colors.white24));
        });

        test('white12() creates white12 color', () {
          final attr = utility.white12();
          expect(attr.value, resolvesTo(Colors.white12));
        });

        test('white10() creates white10 color', () {
          final attr = utility.white10();
          expect(attr.value, resolvesTo(Colors.white10));
        });
      });

      group('Material Colors', () {
        test('red() creates red color', () {
          final attr = utility.red();
          expect(attr.value, resolvesTo(Colors.red));
        });

        test('red(100) creates red shade 100', () {
          final attr = utility.red(100);
          expect(attr.value, resolvesTo(Colors.red.shade100));
        });

        test('red(200) creates red shade 200', () {
          final attr = utility.red(200);
          expect(attr.value, resolvesTo(Colors.red.shade200));
        });

        test('blue() creates blue color', () {
          final attr = utility.blue();
          expect(attr.value, resolvesTo(Colors.blue));
        });

        test('green() creates green color', () {
          final attr = utility.green();
          expect(attr.value, resolvesTo(Colors.green));
        });

        test('yellow() creates yellow color', () {
          final attr = utility.yellow();
          expect(attr.value, resolvesTo(Colors.yellow));
        });

        test('orange() creates orange color', () {
          final attr = utility.orange();
          expect(attr.value, resolvesTo(Colors.orange));
        });

        test('purple() creates purple color', () {
          final attr = utility.purple();
          expect(attr.value, resolvesTo(Colors.purple));
        });

        test('pink() creates pink color', () {
          final attr = utility.pink();
          expect(attr.value, resolvesTo(Colors.pink));
        });

        test('teal() creates teal color', () {
          final attr = utility.teal();
          expect(attr.value, resolvesTo(Colors.teal));
        });

        test('cyan() creates cyan color', () {
          final attr = utility.cyan();
          expect(attr.value, resolvesTo(Colors.cyan));
        });

        test('indigo() creates indigo color', () {
          final attr = utility.indigo();
          expect(attr.value, resolvesTo(Colors.indigo));
        });

        test('lime() creates lime color', () {
          final attr = utility.lime();
          expect(attr.value, resolvesTo(Colors.lime));
        });

        test('lightGreen() creates lightGreen color', () {
          final attr = utility.lightGreen();
          expect(attr.value, resolvesTo(Colors.lightGreen));
        });

        test('lightBlue() creates lightBlue color', () {
          final attr = utility.lightBlue();
          expect(attr.value, resolvesTo(Colors.lightBlue));
        });

        test('deepOrange() creates deepOrange color', () {
          final attr = utility.deepOrange();
          expect(attr.value, resolvesTo(Colors.deepOrange));
        });

        test('deepPurple() creates deepPurple color', () {
          final attr = utility.deepPurple();
          expect(attr.value, resolvesTo(Colors.deepPurple));
        });

        test('brown() creates brown color', () {
          final attr = utility.brown();
          expect(attr.value, resolvesTo(Colors.brown));
        });

        test('grey() creates grey color', () {
          final attr = utility.grey();
          expect(attr.value, resolvesTo(Colors.grey));
        });

        test('blueGrey() creates blueGrey color', () {
          final attr = utility.blueGrey();
          expect(attr.value, resolvesTo(Colors.blueGrey));
        });

        test('amber() creates amber color', () {
          final attr = utility.amber();
          expect(attr.value, resolvesTo(Colors.amber));
        });
      });

      group('Color Directives', () {
        test('withOpacity() applies opacity directive', () {
          final attr = utility.withOpacity(0.5);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives, isNotNull);
          expect(attr.value.directives, isNotEmpty);
        });

        test('withAlpha() applies alpha directive', () {
          final attr = utility.withAlpha(128);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives, isNotNull);
          expect(attr.value.directives, isNotEmpty);
        });

        test('darken() applies darken directive', () {
          final attr = utility.darken(10);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives, isNotNull);
          expect(attr.value.directives, isNotEmpty);
        });

        test('lighten() applies lighten directive', () {
          final attr = utility.lighten(10);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives, isNotNull);
          expect(attr.value.directives, isNotEmpty);
        });

        test('saturate() applies saturate directive', () {
          final attr = utility.saturate(10);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives, isNotNull);
          expect(attr.value.directives, isNotEmpty);
        });

        test('desaturate() applies desaturate directive', () {
          final attr = utility.desaturate(10);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives, isNotNull);
          expect(attr.value.directives, isNotEmpty);
        });

        test('tint() applies tint directive', () {
          final attr = utility.tint(10);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives, isNotNull);
          expect(attr.value.directives, isNotEmpty);
        });

        test('shade() applies shade directive', () {
          final attr = utility.shade(10);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives, isNotNull);
          expect(attr.value.directives, isNotEmpty);
        });

        test('brighten() applies brighten directive', () {
          final attr = utility.brighten(10);
          expect(attr.value, isA<Prop<Color>>());
          expect(attr.value.directives, isNotNull);
          expect(attr.value.directives, isNotEmpty);
        });
      });
    });

    group('CallableColorUtility', () {
      const utility = CallableColorUtility(
        UtilityTestAttribute.new,
        Colors.red,
      );

      test('call() creates color attribute', () {
        final attr = utility();
        expect(attr.value, resolvesTo(Colors.red));
      });

      test('withOpacity() creates color with opacity directive', () {
        final attr = utility.withOpacity(0.7);
        expect(attr.value, isA<Prop<Color>>());
        expect(attr.value.directives?.length, 1);
      });

      test('withAlpha() creates color with alpha directive', () {
        final attr = utility.withAlpha(200);
        expect(attr.value, isA<Prop<Color>>());
        expect(attr.value.directives?.length, 1);
      });
    });
  });
}
