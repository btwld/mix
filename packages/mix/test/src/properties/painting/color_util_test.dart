import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ColorUtility', () {
    late ColorUtility<MockStyle<Prop<Color>>> util;

    setUp(() {
      util = ColorUtility<MockStyle<Prop<Color>>>(
        (prop) => MockStyle(prop),
      );
    });

    group('basic functionality', () {
      test('call method creates color prop', () {
        final result = util(Colors.red);

        final color = result.value.resolve(MockBuildContext());

        expect(color, Colors.red);
      });

      test('token method creates token prop', () {
        const colorToken = MixToken<Color>('primaryColor');
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(
            tokens: {colorToken: Colors.blue},
          ),
        );

        final result = util.token(colorToken);
        final color = result.value.resolve(context);

        expect(color, Colors.blue);
      });

      test('ref method (deprecated) delegates to token', () {
        const colorToken = MixToken<Color>('primaryColor');
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(
            tokens: {colorToken: Colors.green},
          ),
        );

        final result = util.ref(colorToken);
        final color = result.value.resolve(context);

        expect(color, Colors.green);
      });
    });

    group('BasicColorsMixin', () {
      test('has transparent color utility', () {
        expect(util.transparent, isA<CallableColorUtility>());
      });

      test('has black color utilities', () {
        expect(util.black, isA<CallableColorUtility>());
        expect(util.black87, isA<CallableColorUtility>());
        expect(util.black54, isA<CallableColorUtility>());
        expect(util.black45, isA<CallableColorUtility>());
        expect(util.black38, isA<CallableColorUtility>());
        expect(util.black26, isA<CallableColorUtility>());
        expect(util.black12, isA<CallableColorUtility>());
      });

      test('has white color utilities', () {
        expect(util.white, isA<CallableColorUtility>());
        expect(util.white70, isA<CallableColorUtility>());
        expect(util.white60, isA<CallableColorUtility>());
        expect(util.white54, isA<CallableColorUtility>());
        expect(util.white38, isA<CallableColorUtility>());
        expect(util.white30, isA<CallableColorUtility>());
        expect(util.white24, isA<CallableColorUtility>());
        expect(util.white12, isA<CallableColorUtility>());
        expect(util.white10, isA<CallableColorUtility>());
      });

      group('basic color values', () {
        test('transparent creates transparent color', () {
          final result = util.transparent();
          final color = result.value.resolve(MockBuildContext());

          expect(color, Colors.transparent);
        });

        test('black creates black color', () {
          final result = util.black();
          final color = result.value.resolve(MockBuildContext());

          expect(color, Colors.black);
        });

        test('black87 creates black87 color', () {
          final result = util.black87();
          final color = result.value.resolve(MockBuildContext());

          expect(color, Colors.black87);
        });

        test('white creates white color', () {
          final result = util.white();
          final color = result.value.resolve(MockBuildContext());

          expect(color, Colors.white);
        });

        test('white70 creates white70 color', () {
          final result = util.white70();
          final color = result.value.resolve(MockBuildContext());

          expect(color, Colors.white70);
        });
      });
    });

    group('ColorDirectiveMixin methods', () {
      test('withOpacity applies opacity directive', () {
        final result = util.withOpacity(0.5);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<OpacityColorDirective>());
        expect((directives.first as OpacityColorDirective).opacity, 0.5);
      });

      test('withAlpha applies alpha directive', () {
        final result = util.withAlpha(128);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<AlphaColorDirective>());
        expect((directives.first as AlphaColorDirective).alpha, 128);
      });

      test('darken applies darken directive', () {
        final result = util.darken(20);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<DarkenColorDirective>());
        expect((directives.first as DarkenColorDirective).amount, 20);
      });

      test('lighten applies lighten directive', () {
        final result = util.lighten(30);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<LightenColorDirective>());
        expect((directives.first as LightenColorDirective).amount, 30);
      });

      test('saturate applies saturate directive', () {
        final result = util.saturate(25);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<SaturateColorDirective>());
        expect((directives.first as SaturateColorDirective).amount, 25);
      });

      test('desaturate applies desaturate directive', () {
        final result = util.desaturate(15);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<DesaturateColorDirective>());
        expect((directives.first as DesaturateColorDirective).amount, 15);
      });

      test('tint applies tint directive', () {
        final result = util.tint(40);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<TintColorDirective>());
        expect((directives.first as TintColorDirective).amount, 40);
      });

      test('shade applies shade directive', () {
        final result = util.shade(35);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<ShadeColorDirective>());
        expect((directives.first as ShadeColorDirective).amount, 35);
      });

      test('brighten applies brighten directive', () {
        final result = util.brighten(50);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<BrightenColorDirective>());
        expect((directives.first as BrightenColorDirective).amount, 50);
      });
    });
  });

  group('CallableColorUtility', () {
    late CallableColorUtility<MockStyle<Prop<Color>>> util;

    setUp(() {
      util = CallableColorUtility<MockStyle<Prop<Color>>>(
        (prop) => MockStyle(prop),
        Colors.blue,
      );
    });

    test('call operator returns the predefined color', () {
      final result = util();
      final color = result.value.resolve(MockBuildContext());

      expect(color, Colors.blue);
    });

    group('color directive methods', () {
      test('withOpacity applies opacity directive', () {
        final result = util.withOpacity(0.7);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<OpacityColorDirective>());
        expect((directives.first as OpacityColorDirective).opacity, 0.7);
      });

      test('withAlpha applies alpha directive', () {
        final result = util.withAlpha(200);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<AlphaColorDirective>());
        expect((directives.first as AlphaColorDirective).alpha, 200);
      });

      test('darken applies darken directive', () {
        final result = util.darken(10);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<DarkenColorDirective>());
        expect((directives.first as DarkenColorDirective).amount, 10);
      });

      test('lighten applies lighten directive', () {
        final result = util.lighten(15);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<LightenColorDirective>());
        expect((directives.first as LightenColorDirective).amount, 15);
      });

      test('saturate applies saturate directive', () {
        final result = util.saturate(20);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<SaturateColorDirective>());
        expect((directives.first as SaturateColorDirective).amount, 20);
      });

      test('desaturate applies desaturate directive', () {
        final result = util.desaturate(25);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<DesaturateColorDirective>());
        expect((directives.first as DesaturateColorDirective).amount, 25);
      });

      test('tint applies tint directive', () {
        final result = util.tint(30);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<TintColorDirective>());
        expect((directives.first as TintColorDirective).amount, 30);
      });

      test('shade applies shade directive', () {
        final result = util.shade(40);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<ShadeColorDirective>());
        expect((directives.first as ShadeColorDirective).amount, 40);
      });

      test('brighten applies brighten directive', () {
        final result = util.brighten(45);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<BrightenColorDirective>());
        expect((directives.first as BrightenColorDirective).amount, 45);
      });
    });
  });

  group('FoundationColorUtility', () {
    late FoundationColorUtility<MockStyle<Prop<Color>>> util;

    setUp(() {
      util = FoundationColorUtility<MockStyle<Prop<Color>>>(
        (prop) => MockStyle(prop),
        Colors.red,
      );
    });

    test('has correct color value', () {
      expect(util.color, Colors.red);
    });

    test('can use ColorDirectiveMixin methods', () {
      final result = util.withOpacity(0.8);
      final directives = result.value.$directives;

      expect(result.value, isA<Prop<Color>>());
      expect(directives, isNotEmpty);
      expect(directives!.first, isA<OpacityColorDirective>());
      expect((directives.first as OpacityColorDirective).opacity, 0.8);
    });
  });

  group('Basic Colors from ColorUtility', () {
    late ColorUtility<MockStyle<Prop<Color>>> util;

    setUp(() {
      util = ColorUtility<MockStyle<Prop<Color>>>(
        (prop) => MockStyle(prop),
      );
    });

    group('black variants with directives', () {
      test('black.withOpacity creates black with opacity', () {
        final result = util.black.withOpacity(0.5);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<OpacityColorDirective>());
        expect((directives.first as OpacityColorDirective).opacity, 0.5);
      });

      test('black.darken creates darkened black', () {
        final result = util.black.darken(10);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<DarkenColorDirective>());
        expect((directives.first as DarkenColorDirective).amount, 10);
      });
    });

    group('white variants with directives', () {
      test('white.withOpacity creates white with opacity', () {
        final result = util.white.withOpacity(0.9);
        final directives = result.value.$directives;

        
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<OpacityColorDirective>
        ());
        expect((directives.first as OpacityColorDirective).opacity, 0.9);
      });

      test('white.lighten creates lightened white', () {
        final result = util.white.lighten(5);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<LightenColorDirective>());
        expect((directives.first as LightenColorDirective).amount, 5);
      });
    });

    group('transparent with directives', () {
      test('transparent.withAlpha creates transparent with alpha', () {
        final result = util.transparent.withAlpha(100);
        final directives = result.value.$directives;

        expect(result.value, isA<Prop<Color>>());
        expect(directives, isNotEmpty);
        expect(directives!.first, isA<AlphaColorDirective>());
        expect((directives.first as AlphaColorDirective).alpha, 100);
      });
    });
  });

  group('ColorsUtilityMixin integration', () {
    late ColorUtility<MockStyle<Prop<Color>>> util;

    setUp(() {
      util = ColorUtility<MockStyle<Prop<Color>>>(
        (prop) => MockStyle(prop),
      );
    });

    test('has material color methods from ColorsUtilityMixin', () {
      // These are methods that return T with the color value
      final redResult = util.red();
      final blueResult = util.blue();
      final greenResult = util.green();
      
      expect(redResult.value.resolve(MockBuildContext()), Colors.red);
      expect(blueResult.value.resolve(MockBuildContext()), Colors.blue);
      expect(greenResult.value.resolve(MockBuildContext()), Colors.green);
    });

    test('material color methods work with shades', () {
      final red100 = util.red(100);
      final blue500 = util.blue(500);
      final green900 = util.green(900);
      
      expect(red100.value.resolve(MockBuildContext()), Colors.red[100]);
      expect(blue500.value.resolve(MockBuildContext()), Colors.blue[500]);
      expect(green900.value.resolve(MockBuildContext()), Colors.green[900]);
    });

    test('can apply directives to material colors', () {
      // Apply directives to a red color by first creating it, then applying directives
      final redColor = util(Colors.red);
      final result = redColor.value.resolve(MockBuildContext());
      
      expect(result, Colors.red);
      
      // Test that directives can be applied using the base utility methods
      final withOpacity = util.withOpacity(0.6);
      expect(withOpacity.value.$directives, hasLength(1));
      expect(withOpacity.value.$directives!.first, isA<OpacityColorDirective>());
    });
  });

  group('Token and context resolution', () {
    test('token resolves from MixScopeData', () {
      const colorToken = MixToken<Color>('testColor');
      const expectedColor = Colors.purple;
      
      final context = MockBuildContext(
        mixScopeData: MixScopeData.static(
          tokens: {colorToken: expectedColor},
        ),
      );

      final util = ColorUtility<MockStyle<Prop<Color>>>(
        (prop) => MockStyle(prop),
      );

      final result = util.token(colorToken);
      final resolvedColor = result.value.resolve(context);

      expect(resolvedColor, expectedColor);
    });

    test('token falls back when not found in context', () {
      const colorToken = MixToken<Color>('missingColor');
      
      final context = MockBuildContext(
        mixScopeData: MixScopeData.static(tokens: {}),
      );

      final util = ColorUtility<MockStyle<Prop<Color>>>(
        (prop) => MockStyle(prop),
      );

      final result = util.token(colorToken);
      
      // Should not throw, but behavior depends on implementation
      expect(() => result.value.resolve(context), returnsNormally);
    });
  });
}