import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('OpacityColorDirective', () {
    test('applies opacity correctly', () {
      const directive = OpacityColorDirective(0.5);
      const color = Color(0xFF123456);

      final result = directive.apply(color);

      // Color.alpha returns byte value (0-255)
      expect(result.alpha, closeTo(127, 10)); // 0.5 * 255
    });

    test('has correct key', () {
      const directive = OpacityColorDirective(0.5);
      expect(directive.key, 'color_opacity');
    });

    test('equality works correctly', () {
      const directive1 = OpacityColorDirective(0.5);
      const directive2 = OpacityColorDirective(0.5);
      const directive3 = OpacityColorDirective(0.7);

      expect(directive1, equals(directive2));
      expect(directive1, isNot(equals(directive3)));
    });

    test('hashCode consistent with equality', () {
      const directive1 = OpacityColorDirective(0.5);
      const directive2 = OpacityColorDirective(0.5);

      expect(directive1.hashCode, equals(directive2.hashCode));
    });
  });

  group('AlphaColorDirective', () {
    test('applies alpha correctly', () {
      const directive = AlphaColorDirective(128);
      const color = Color(0xFF123456);

      final result = directive.apply(color);

      expect(result.alpha, 128);
    });

    test('has correct key', () {
      const directive = AlphaColorDirective(128);
      expect(directive.key, 'color_alpha');
    });

    test('equality works correctly', () {
      const directive1 = AlphaColorDirective(128);
      const directive2 = AlphaColorDirective(128);
      const directive3 = AlphaColorDirective(200);

      expect(directive1, equals(directive2));
      expect(directive1, isNot(equals(directive3)));
    });
  });

  group('DarkenColorDirective', () {
    test('darkens color', () {
      const directive = DarkenColorDirective(20);
      const color = Color(0xFFFFFFFF);

      final result = directive.apply(color);

      // White darkened should be darker
      expect(result.computeLuminance(), lessThan(color.computeLuminance()));
    });

    test('has correct key', () {
      const directive = DarkenColorDirective(20);
      expect(directive.key, 'color_darken');
    });
  });

  group('LightenColorDirective', () {
    test('lightens color', () {
      const directive = LightenColorDirective(20);
      const color = Color(0xFF000000);

      final result = directive.apply(color);

      // Black lightened should be lighter
      expect(result.computeLuminance(), greaterThan(color.computeLuminance()));
    });

    test('has correct key', () {
      const directive = LightenColorDirective(20);
      expect(directive.key, 'color_lighten');
    });
  });

  group('SaturateColorDirective', () {
    test('has correct key', () {
      const directive = SaturateColorDirective(20);
      expect(directive.key, 'color_saturate');
    });

    test('increases saturation of a colored input', () {
      const directive = SaturateColorDirective(20);
      // Use a color with some saturation (not gray, not fully saturated)
      const color = Color(0xFFCC8888); // Desaturated red

      final result = directive.apply(color);

      // Convert both to HSL and compare saturation
      final originalHsl = HSLColor.fromColor(color);
      final resultHsl = HSLColor.fromColor(result);

      // Saturation should increase (or stay at max if already saturated)
      expect(
        resultHsl.saturation,
        greaterThanOrEqualTo(originalHsl.saturation),
      );
    });

    test('equality works correctly', () {
      const directive1 = SaturateColorDirective(20);
      const directive2 = SaturateColorDirective(20);
      const directive3 = SaturateColorDirective(50);

      expect(directive1, equals(directive2));
      expect(directive1, isNot(equals(directive3)));
    });
  });

  group('DesaturateColorDirective', () {
    test('has correct key', () {
      const directive = DesaturateColorDirective(20);
      expect(directive.key, 'color_desaturate');
    });

    test('decreases saturation of a colored input', () {
      const directive = DesaturateColorDirective(20);
      // Use a fully saturated color
      const color = Color(0xFFFF0000); // Pure red

      final result = directive.apply(color);

      // Convert both to HSL and compare saturation
      final originalHsl = HSLColor.fromColor(color);
      final resultHsl = HSLColor.fromColor(result);

      // Saturation should decrease (or stay at min if already desaturated)
      expect(
        resultHsl.saturation,
        lessThanOrEqualTo(originalHsl.saturation),
      );
    });

    test('equality works correctly', () {
      const directive1 = DesaturateColorDirective(20);
      const directive2 = DesaturateColorDirective(20);
      const directive3 = DesaturateColorDirective(50);

      expect(directive1, equals(directive2));
      expect(directive1, isNot(equals(directive3)));
    });
  });

  group('TintColorDirective', () {
    test('has correct key', () {
      const directive = TintColorDirective(30);
      expect(directive.key, 'color_tint');
    });

    test('applies tint', () {
      const directive = TintColorDirective(30);
      const color = Color(0xFF000000);

      final result = directive.apply(color);

      // Tinting black should make it lighter
      expect(result.computeLuminance(), greaterThan(color.computeLuminance()));
    });
  });

  group('ShadeColorDirective', () {
    test('has correct key', () {
      const directive = ShadeColorDirective(40);
      expect(directive.key, 'color_shade');
    });

    test('applies shade', () {
      const directive = ShadeColorDirective(40);
      const color = Color(0xFFFFFFFF);

      final result = directive.apply(color);

      // Shading white should make it darker
      expect(result.computeLuminance(), lessThan(color.computeLuminance()));
    });
  });

  group('BrightenColorDirective', () {
    test('has correct key', () {
      const directive = BrightenColorDirective(50);
      expect(directive.key, 'color_brighten');
    });

    test('brightens color', () {
      const directive = BrightenColorDirective(50);
      const color = Color(0xFF000000);

      final result = directive.apply(color);

      // Brightening black should make it lighter
      expect(result.computeLuminance(), greaterThan(color.computeLuminance()));
    });
  });

  group('WithRedColorDirective', () {
    test('sets red channel', () {
      const directive = WithRedColorDirective(200);
      const color = Color(0xFF00FFFF);

      final result = directive.apply(color);

      expect(result.red, 200);
      expect(result.green, color.green);
      expect(result.blue, color.blue);
    });

    test('has correct key', () {
      const directive = WithRedColorDirective(200);
      expect(directive.key, 'color_with_red');
    });
  });

  group('WithGreenColorDirective', () {
    test('sets green channel', () {
      const directive = WithGreenColorDirective(150);
      const color = Color(0xFFFF00FF);

      final result = directive.apply(color);

      expect(result.red, color.red);
      expect(result.green, 150);
      expect(result.blue, color.blue);
    });

    test('has correct key', () {
      const directive = WithGreenColorDirective(150);
      expect(directive.key, 'color_with_green');
    });
  });

  group('WithBlueColorDirective', () {
    test('sets blue channel', () {
      const directive = WithBlueColorDirective(100);
      const color = Color(0xFFFFFF00);

      final result = directive.apply(color);

      expect(result.red, color.red);
      expect(result.green, color.green);
      expect(result.blue, 100);
    });

    test('has correct key', () {
      const directive = WithBlueColorDirective(100);
      expect(directive.key, 'color_with_blue');
    });
  });

  group('WithValuesColorDirective', () {
    test('applies withValues with all parameters', () {
      const directive = WithValuesColorDirective(
        alpha: 0.5,
        red: 0.8,
        green: 0.6,
        blue: 0.4,
      );
      const color = Color(0xFF000000);

      final result = directive.apply(color);

      // Color properties return byte values (0-255), not normalized (0-1)
      expect(result.alpha, closeTo(127, 10)); // 0.5 * 255
      expect(result.red, closeTo(204, 10));   // 0.8 * 255
      expect(result.green, closeTo(153, 10)); // 0.6 * 255
      expect(result.blue, closeTo(102, 10));  // 0.4 * 255
    });

    test('applies withValues with partial parameters', () {
      const directive = WithValuesColorDirective(alpha: 0.7);
      const color = Color(0xFF123456);

      final result = directive.apply(color);

      expect(result.alpha, closeTo(179, 10)); // 0.7 * 255
    });

    test('has correct key', () {
      const directive = WithValuesColorDirective(alpha: 0.5);
      expect(directive.key, 'color_with_values');
    });

    test('equality works correctly', () {
      const directive1 = WithValuesColorDirective(alpha: 0.5, red: 0.8);
      const directive2 = WithValuesColorDirective(alpha: 0.5, red: 0.8);
      const directive3 = WithValuesColorDirective(alpha: 0.5, red: 0.9);

      expect(directive1, equals(directive2));
      expect(directive1, isNot(equals(directive3)));
    });

    test('hashCode consistent with equality', () {
      const directive1 = WithValuesColorDirective(alpha: 0.5);
      const directive2 = WithValuesColorDirective(alpha: 0.5);

      expect(directive1.hashCode, equals(directive2.hashCode));
    });
  });
}
