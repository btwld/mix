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

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<OpacityColorDirective>());
      });

      test('withAlpha applies alpha directive', () {
        final result = util.withAlpha(128);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<AlphaColorDirective>());
      });

      test('darken applies darken directive', () {
        final result = util.darken(20);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<DarkenColorDirective>());
      });

      test('lighten applies lighten directive', () {
        final result = util.lighten(30);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<LightenColorDirective>());
      });

      test('saturate applies saturate directive', () {
        final result = util.saturate(25);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<SaturateColorDirective>());
      });

      test('desaturate applies desaturate directive', () {
        final result = util.desaturate(15);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<DesaturateColorDirective>());
      });

      test('tint applies tint directive', () {
        final result = util.tint(40);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<TintColorDirective>());
      });

      test('shade applies shade directive', () {
        final result = util.shade(35);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<ShadeColorDirective>());
      });

      test('brighten applies brighten directive', () {
        final result = util.brighten(50);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<BrightenColorDirective>());
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

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<OpacityColorDirective>());
      });

      test('withAlpha applies alpha directive', () {
        final result = util.withAlpha(200);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<AlphaColorDirective>());
      });

      test('darken applies darken directive', () {
        final result = util.darken(10);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<DarkenColorDirective>());
      });

      test('lighten applies lighten directive', () {
        final result = util.lighten(15);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<LightenColorDirective>());
      });

      test('saturate applies saturate directive', () {
        final result = util.saturate(20);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<SaturateColorDirective>());
      });

      test('desaturate applies desaturate directive', () {
        final result = util.desaturate(25);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<DesaturateColorDirective>());
      });

      test('tint applies tint directive', () {
        final result = util.tint(30);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<TintColorDirective>());
      });

      test('shade applies shade directive', () {
        final result = util.shade(40);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<ShadeColorDirective>());
      });

      test('brighten applies brighten directive', () {
        final result = util.brighten(45);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<BrightenColorDirective>());
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

      expect(result.value, isA<Prop<Color>>());
      expect(result.value.directives, hasLength(1));
      expect(result.value.directives!.first, isA<OpacityColorDirective>());
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

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<OpacityColorDirective>());
      });

      test('black.darken creates darkened black', () {
        final result = util.black.darken(10);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<DarkenColorDirective>());
      });
    });

    group('white variants with directives', () {
      test('white.withOpacity creates white with opacity', () {
        final result = util.white.withOpacity(0.9);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<OpacityColorDirective>());
      });

      test('white.lighten creates lightened white', () {
        final result = util.white.lighten(5);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<LightenColorDirective>());
      });
    });

    group('transparent with directives', () {
      test('transparent.withAlpha creates transparent with alpha', () {
        final result = util.transparent.withAlpha(100);

        expect(result.value, isA<Prop<Color>>());
        expect(result.value.directives, hasLength(1));
        expect(result.value.directives!.first, isA<AlphaColorDirective>());
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

    test('has material colors from ColorsUtilityMixin', () {
      // These properties should be available from the ColorsUtilityMixin
      expect(util.red, isA<CallableColorUtility>());
      expect(util.blue, isA<CallableColorUtility>());
      expect(util.green, isA<CallableColorUtility>());
    });

    test('material colors work with directives', () {
      final result = util.red.withOpacity(0.6);

      expect(result.value, isA<Prop<Color>>());
      expect(result.value.directives, hasLength(1));
      expect(result.value.directives!.first, isA<OpacityColorDirective>());
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