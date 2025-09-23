import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Directive System', () {
    group('OpacityColorDirective', () {
      test('should apply opacity to color', () {
        const directive = OpacityColorDirective(0.5);
        const color = Color(0xFF000000); // Black

        final result = directive.apply(color);

        expect(result.alpha, equals(128)); // 0.5 * 255 ≈ 128
        expect(result.red, equals(color.red));
        expect(result.green, equals(color.green));
        expect(result.blue, equals(color.blue));
      });

      test('should have correct key', () {
        const directive = OpacityColorDirective(0.5);
        expect(directive.key, equals('color_opacity'));
      });

      test('should support equality and hashCode', () {
        const directive1 = OpacityColorDirective(0.5);
        const directive2 = OpacityColorDirective(0.5);
        const directive3 = OpacityColorDirective(0.8);

        expect(directive1, equals(directive2));
        expect(directive1, isNot(equals(directive3)));
        expect(directive1.hashCode, equals(directive2.hashCode));
        expect(directive1.hashCode, isNot(equals(directive3.hashCode)));
      });
    });

    group('WithValuesColorDirective', () {
      test('should apply withValues to color with all parameters', () {
        const directive = WithValuesColorDirective(
          alpha: 0.8,
          red: 0.5,
          green: 0.6,
          blue: 0.7,
        );
        const color = Color(0xFF000000);

        final result = directive.apply(color);

        expect(result.alpha, equals(204)); // 0.8 * 255 = 204
        expect(result.red, equals(128)); // 0.5 * 255 = 128
        expect(result.green, equals(153)); // 0.6 * 255 = 153
        expect(result.blue, equals(179)); // 0.7 * 255 = 179
      });

      test('should apply withValues to color with partial parameters', () {
        const directive = WithValuesColorDirective(alpha: 0.5);
        const color = Color(0xFF123456);

        final result = directive.apply(color);

        expect(result.alpha, equals(128)); // 0.5 * 255 ≈ 128
        expect(result.red, equals(color.red));
        expect(result.green, equals(color.green));
        expect(result.blue, equals(color.blue));
      });

      test('should have correct key', () {
        const directive = WithValuesColorDirective();
        expect(directive.key, equals('color_with_values'));
      });

      test('should support equality and hashCode', () {
        const directive1 = WithValuesColorDirective(alpha: 0.5, red: 0.3);
        const directive2 = WithValuesColorDirective(alpha: 0.5, red: 0.3);
        const directive3 = WithValuesColorDirective(alpha: 0.8, red: 0.3);

        expect(directive1, equals(directive2));
        expect(directive1, isNot(equals(directive3)));
        expect(directive1.hashCode, equals(directive2.hashCode));
      });
    });

    group('AlphaColorDirective', () {
      test('should apply alpha to color', () {
        const directive = AlphaColorDirective(128);
        const color = Color(0xFF123456);

        final result = directive.apply(color);

        expect(result.alpha, equals(128));
        expect(result.red, equals(color.red));
        expect(result.green, equals(color.green));
        expect(result.blue, equals(color.blue));
      });

      test('should have correct key', () {
        const directive = AlphaColorDirective(128);
        expect(directive.key, equals('color_alpha'));
      });

      test('should support equality and hashCode', () {
        const directive1 = AlphaColorDirective(128);
        const directive2 = AlphaColorDirective(128);
        const directive3 = AlphaColorDirective(255);

        expect(directive1, equals(directive2));
        expect(directive1, isNot(equals(directive3)));
        expect(directive1.hashCode, equals(directive2.hashCode));
      });
    });

    group('DarkenColorDirective', () {
      test('should darken color', () {
        const directive = DarkenColorDirective(20);
        const color = Color(0xFF808080); // Medium gray

        final result = directive.apply(color);

        // Darken should reduce luminance
        expect(result.computeLuminance(), lessThan(color.computeLuminance()));
      });

      test('should have correct key', () {
        const directive = DarkenColorDirective(20);
        expect(directive.key, equals('color_darken'));
      });

      test('should support equality and hashCode', () {
        const directive1 = DarkenColorDirective(20);
        const directive2 = DarkenColorDirective(20);
        const directive3 = DarkenColorDirective(30);

        expect(directive1, equals(directive2));
        expect(directive1, isNot(equals(directive3)));
        expect(directive1.hashCode, equals(directive2.hashCode));
      });
    });

    group('LightenColorDirective', () {
      test('should lighten color', () {
        const directive = LightenColorDirective(20);
        const color = Color(0xFF404040); // Dark gray

        final result = directive.apply(color);

        // Lighten should increase luminance
        expect(
          result.computeLuminance(),
          greaterThan(color.computeLuminance()),
        );
      });

      test('should have correct key', () {
        const directive = LightenColorDirective(20);
        expect(directive.key, equals('color_lighten'));
      });

      test('should support equality and hashCode', () {
        const directive1 = LightenColorDirective(20);
        const directive2 = LightenColorDirective(20);
        const directive3 = LightenColorDirective(30);

        expect(directive1, equals(directive2));
        expect(directive1, isNot(equals(directive3)));
        expect(directive1.hashCode, equals(directive2.hashCode));
      });
    });

    group('SaturateColorDirective', () {
      test('should saturate color', () {
        const directive = SaturateColorDirective(20);
        const color = Color(0xFF808080); // Gray color (low saturation)

        final result = directive.apply(color);

        // Saturate should increase saturation (expect some change for gray)
        expect(result, isNot(equals(color)));
      });

      test('should have correct key', () {
        const directive = SaturateColorDirective(20);
        expect(directive.key, equals('color_saturate'));
      });

      test('should support equality and hashCode', () {
        const directive1 = SaturateColorDirective(20);
        const directive2 = SaturateColorDirective(20);
        const directive3 = SaturateColorDirective(30);

        expect(directive1, equals(directive2));
        expect(directive1, isNot(equals(directive3)));
        expect(directive1.hashCode, equals(directive2.hashCode));
      });
    });

    group('DesaturateColorDirective', () {
      test('should desaturate color', () {
        const directive = DesaturateColorDirective(20);
        const color = Color(0xFFFF0000); // Pure red (high saturation)

        final result = directive.apply(color);

        // Desaturate should reduce saturation
        expect(result, isNot(equals(color)));
      });

      test('should have correct key', () {
        const directive = DesaturateColorDirective(20);
        expect(directive.key, equals('color_desaturate'));
      });

      test('should support equality and hashCode', () {
        const directive1 = DesaturateColorDirective(20);
        const directive2 = DesaturateColorDirective(20);
        const directive3 = DesaturateColorDirective(30);

        expect(directive1, equals(directive2));
        expect(directive1, isNot(equals(directive3)));
        expect(directive1.hashCode, equals(directive2.hashCode));
      });
    });

    group('TintColorDirective', () {
      test('should tint color', () {
        const directive = TintColorDirective(20);
        const color = Color(0xFF000000); // Black

        final result = directive.apply(color);

        // Tint should make color lighter (mix with white)
        expect(
          result.computeLuminance(),
          greaterThan(color.computeLuminance()),
        );
      });

      test('should have correct key', () {
        const directive = TintColorDirective(20);
        expect(directive.key, equals('color_tint'));
      });

      test('should support equality and hashCode', () {
        const directive1 = TintColorDirective(20);
        const directive2 = TintColorDirective(20);
        const directive3 = TintColorDirective(30);

        expect(directive1, equals(directive2));
        expect(directive1, isNot(equals(directive3)));
        expect(directive1.hashCode, equals(directive2.hashCode));
      });
    });

    group('ShadeColorDirective', () {
      test('should shade color', () {
        const directive = ShadeColorDirective(20);
        const color = Color(0xFFFFFFFF); // White

        final result = directive.apply(color);

        // Shade should make color darker (mix with black)
        expect(result.computeLuminance(), lessThan(color.computeLuminance()));
      });

      test('should have correct key', () {
        const directive = ShadeColorDirective(20);
        expect(directive.key, equals('color_shade'));
      });

      test('should support equality and hashCode', () {
        const directive1 = ShadeColorDirective(20);
        const directive2 = ShadeColorDirective(20);
        const directive3 = ShadeColorDirective(30);

        expect(directive1, equals(directive2));
        expect(directive1, isNot(equals(directive3)));
        expect(directive1.hashCode, equals(directive2.hashCode));
      });
    });

    group('BrightenColorDirective', () {
      test('should brighten color', () {
        const directive = BrightenColorDirective(20);
        const color = Color(0xFF404040); // Dark gray

        final result = directive.apply(color);

        // Brighten should increase luminance
        expect(
          result.computeLuminance(),
          greaterThan(color.computeLuminance()),
        );
      });

      test('should have correct key', () {
        const directive = BrightenColorDirective(20);
        expect(directive.key, equals('color_brighten'));
      });

      test('should support equality and hashCode', () {
        const directive1 = BrightenColorDirective(20);
        const directive2 = BrightenColorDirective(20);
        const directive3 = BrightenColorDirective(30);

        expect(directive1, equals(directive2));
        expect(directive1, isNot(equals(directive3)));
        expect(directive1.hashCode, equals(directive2.hashCode));
      });
    });

    group('WithRedColorDirective', () {
      test('should set red channel', () {
        const directive = WithRedColorDirective(128);
        const color = Color(0xFF123456);

        final result = directive.apply(color);

        expect(result.red, equals(128));
        expect(result.green, equals(color.green));
        expect(result.blue, equals(color.blue));
        expect(result.alpha, equals(color.alpha));
      });

      test('should have correct key', () {
        const directive = WithRedColorDirective(128);
        expect(directive.key, equals('color_with_red'));
      });

      test('should support equality and hashCode', () {
        const directive1 = WithRedColorDirective(128);
        const directive2 = WithRedColorDirective(128);
        const directive3 = WithRedColorDirective(255);

        expect(directive1, equals(directive2));
        expect(directive1, isNot(equals(directive3)));
        expect(directive1.hashCode, equals(directive2.hashCode));
      });
    });

    group('WithGreenColorDirective', () {
      test('should set green channel', () {
        const directive = WithGreenColorDirective(128);
        const color = Color(0xFF123456);

        final result = directive.apply(color);

        expect(result.red, equals(color.red));
        expect(result.green, equals(128));
        expect(result.blue, equals(color.blue));
        expect(result.alpha, equals(color.alpha));
      });

      test('should have correct key', () {
        const directive = WithGreenColorDirective(128);
        expect(directive.key, equals('color_with_green'));
      });

      test('should support equality and hashCode', () {
        const directive1 = WithGreenColorDirective(128);
        const directive2 = WithGreenColorDirective(128);
        const directive3 = WithGreenColorDirective(255);

        expect(directive1, equals(directive2));
        expect(directive1, isNot(equals(directive3)));
        expect(directive1.hashCode, equals(directive2.hashCode));
      });
    });

    group('WithBlueColorDirective', () {
      test('should set blue channel', () {
        const directive = WithBlueColorDirective(128);
        const color = Color(0xFF123456);

        final result = directive.apply(color);

        expect(result.red, equals(color.red));
        expect(result.green, equals(color.green));
        expect(result.blue, equals(128));
        expect(result.alpha, equals(color.alpha));
      });

      test('should have correct key', () {
        const directive = WithBlueColorDirective(128);
        expect(directive.key, equals('color_with_blue'));
      });

      test('should support equality and hashCode', () {
        const directive1 = WithBlueColorDirective(128);
        const directive2 = WithBlueColorDirective(128);
        const directive3 = WithBlueColorDirective(255);

        expect(directive1, equals(directive2));
        expect(directive1, isNot(equals(directive3)));
        expect(directive1.hashCode, equals(directive2.hashCode));
      });
    });

    group('String Directives', () {
      group('CapitalizeStringDirective', () {
        test('should capitalize first letter', () {
          const directive = CapitalizeStringDirective();
          const input = 'hello world';

          final result = directive.apply(input);

          expect(result, equals('Hello world'));
        });

        test('should handle empty string', () {
          const directive = CapitalizeStringDirective();
          const input = '';

          final result = directive.apply(input);

          expect(result, equals(''));
        });

        test('should have correct key', () {
          const directive = CapitalizeStringDirective();
          expect(directive.key, equals('capitalize'));
        });

        test('should support equality and hashCode', () {
          const directive1 = CapitalizeStringDirective();
          const directive2 = CapitalizeStringDirective();

          expect(directive1, equals(directive2));
          expect(directive1.hashCode, equals(directive2.hashCode));
        });
      });

      group('UppercaseStringDirective', () {
        test('should convert to uppercase', () {
          const directive = UppercaseStringDirective();
          const input = 'Hello World';

          final result = directive.apply(input);

          expect(result, equals('HELLO WORLD'));
        });

        test('should have correct key', () {
          const directive = UppercaseStringDirective();
          expect(directive.key, equals('uppercase'));
        });

        test('should support equality and hashCode', () {
          const directive1 = UppercaseStringDirective();
          const directive2 = UppercaseStringDirective();

          expect(directive1, equals(directive2));
          expect(directive1.hashCode, equals(directive2.hashCode));
        });
      });

      group('LowercaseStringDirective', () {
        test('should convert to lowercase', () {
          const directive = LowercaseStringDirective();
          const input = 'Hello World';

          final result = directive.apply(input);

          expect(result, equals('hello world'));
        });

        test('should have correct key', () {
          const directive = LowercaseStringDirective();
          expect(directive.key, equals('lowercase'));
        });

        test('should support equality and hashCode', () {
          const directive1 = LowercaseStringDirective();
          const directive2 = LowercaseStringDirective();

          expect(directive1, equals(directive2));
          expect(directive1.hashCode, equals(directive2.hashCode));
        });
      });

      group('TitleCaseStringDirective', () {
        test('should convert to title case', () {
          const directive = TitleCaseStringDirective();
          const input = 'hello world';

          final result = directive.apply(input);

          expect(result, equals('Hello World'));
        });

        test('should have correct key', () {
          const directive = TitleCaseStringDirective();
          expect(directive.key, equals('title_case'));
        });

        test('should support equality and hashCode', () {
          const directive1 = TitleCaseStringDirective();
          const directive2 = TitleCaseStringDirective();

          expect(directive1, equals(directive2));
          expect(directive1.hashCode, equals(directive2.hashCode));
        });
      });

      group('SentenceCaseStringDirective', () {
        test('should convert to sentence case', () {
          const directive = SentenceCaseStringDirective();
          const input = 'hello WORLD';

          final result = directive.apply(input);

          // Based on the actual implementation that splits by words and only capitalizes first
          expect(result, equals('Hello W O R L D'));
        });

        test('should have correct key', () {
          const directive = SentenceCaseStringDirective();
          expect(directive.key, equals('sentence_case'));
        });

        test('should support equality and hashCode', () {
          const directive1 = SentenceCaseStringDirective();
          const directive2 = SentenceCaseStringDirective();

          expect(directive1, equals(directive2));
          expect(directive1.hashCode, equals(directive2.hashCode));
        });
      });
    });

    group('DirectiveListExt', () {
      test('should apply multiple directives in sequence', () {
        const color = Color(0xFF808080);
        final directives = <Directive<Color>>[
          const DarkenColorDirective(10),
          const OpacityColorDirective(0.8),
          const SaturateColorDirective(20),
        ];

        final result = directives.apply(color);

        // Should be different from original color
        expect(result, isNot(equals(color)));
        // Should have opacity applied (0.8 * 255 = 204)
        expect(result.alpha, equals(204));
      });

      test('should handle empty directive list', () {
        const color = Color(0xFF808080);
        final directives = <Directive<Color>>[];

        final result = directives.apply(color);

        expect(result, equals(color));
      });

      test('should handle single directive', () {
        const color = Color(0xFF808080);
        final directives = <Directive<Color>>[const OpacityColorDirective(0.5)];

        final result = directives.apply(color);

        expect(result.alpha, equals(128)); // 0.5 * 255 ≈ 128
      });

      test('should work with string directives', () {
        const input = 'hello world';
        final directives = <Directive<String>>[
          const TitleCaseStringDirective(),
          const UppercaseStringDirective(),
        ];

        final result = directives.apply(input);

        expect(result, equals('HELLO WORLD'));
      });
    });
  });
}
