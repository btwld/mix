import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';
import 'helpers/expect_color.dart';

void main() {
  group('ColorDirectives', () {
    test('OpacityColorDirective modifies color opacity', () {
      const color = Color(0xFFFF0000);
      const directive = OpacityColorDirective(0.5);
      expectColor(directive.modify(color), const Color(0x80FF0000));
    });

    test('ValueColorDirective modifies color value', () {
      const color = Color(0xFFFF0000);
      const directive = ValueColorDirective(0.5);
      expect(directive.modify(color), equals(const Color(0xFF800000)));
    });

    test('SaturationColorDirective modifies color saturation', () {
      const color = Color(0xFFFF0000);
      const directive = SaturationColorDirective(0.5);
      expect(directive.modify(color), equals(const Color(0xFFBF4040)));
    });

    test('HueColorDirective modifies color hue', () {
      const color = Color(0xFFFF0000);
      const directive = HueColorDirective(120);
      expect(directive.modify(color), equals(const Color(0xFF00FF00)));
    });

    test('LightnessColorDirective modifies color lightness', () {
      const color = Color(0xFFFF0000);
      const directive = LightnessColorDirective(0.75);
      expect(directive.modify(color), equals(const Color(0xFFFF8080)));
    });

    test('AlphaColorDirective modifies color alpha', () {
      const color = Color(0xFFFF0000);
      const directive = AlphaColorDirective(128);
      expect(directive.modify(color), equals(const Color(0x80FF0000)));
    });
  });

  group('ColorExtUtilities', () {
    test('mix blends two colors', () {
      const color1 = Color(0xFFFF0000);
      const color2 = Color(0xFF0000FF);
      expectColor(color1.mix(color2), const Color(0xFF800080));
    });

    test('lighten increases color lightness', () {
      const color = Color(0xFF800000);
      expectColor(color.lighten(20), const Color(0xffe60000));
    });

    test('brighten increases color brightness', () {
      const color = Color(0xFF800000);
      expectColor(color.brighten(20), const Color(0xffb33333));
    });

    test('contrast returns lighter color for dark input', () {
      const color = Color(0xFF200000);
      expectColor(color.contrast(), const Color(0xff230303));
    });

    test('contrast returns darker color for light input', () {
      const color = Color(0xFFE00000);
      expectColor(color.contrast(), const Color(0xffe30303));
    });

    test('darken decreases color lightness', () {
      const color = Color(0xFFFF0000);
      expectColor(color.darken(20), const Color(0xff990000));
    });

    test('tint mixes color with white', () {
      const color = Color(0xFF800000);
      expectColor(color.tint(20), const Color(0xFF993333));
    });

    test('shade mixes color with black', () {
      const color = Color(0xFF800000);
      expectColor(color.shade(20), const Color(0xFF660000));
    });

    test('desaturate decreases color saturation', () {
      const color = Color(0xFFFF0000);
      expectColor(color.desaturate(50), const Color(0xFFBF4040));
    });

    test('saturate increases color saturation', () {
      const color = Color(0xFFBF4040);
      expectColor(color.saturate(50), const Color(0xFFFF0000));
    });

    test('greyscale fully desaturates color', () {
      const color = Color(0xFFFF0000);
      expectColor(color.greyscale(), const Color(0xff808080));
    });

    test('complement returns opposite hue', () {
      const color = Color(0xFFFF0000);
      expectColor(color.complement(), const Color(0xFF00FFFF));
    });
  });

  group('Merges', () {
    test('LightnessColorDirective', () {
      const colorDto = ColorDto.raw(value: Colors.black, directives: [
        LightnessColorDirective(0.5),
        LightnessColorDirective(0.5),
      ]);

      final color = colorDto.resolve(
        MixData.create(
          MockBuildContext(),
          Style(),
        ),
      );

      expect(0.5, HSLColor.fromColor(color).lightness);
    });

    test('SaturationColorDirective', () {
      const colorDto = ColorDto.raw(value: Colors.red, directives: [
        SaturationColorDirective(0.6),
        SaturationColorDirective(0.6),
      ]);

      final color = colorDto.resolve(
        MixData.create(
          MockBuildContext(),
          Style(),
        ),
      );

      expect(
        0.6.toString(),
        HSLColor.fromColor(color).saturation.toStringAsFixed(1),
      );
    });

    test('HueColorDirective', () {
      const colorDto = ColorDto.raw(value: Colors.red, directives: [
        HueColorDirective(180),
        HueColorDirective(180),
      ]);

      final color = colorDto.resolve(
        MixData.create(
          MockBuildContext(),
          Style(),
        ),
      );

      expect(180, HSLColor.fromColor(color).hue);
    });

    test('OpacityColorDirective', () {
      const colorDto = ColorDto.raw(value: Colors.red, directives: [
        OpacityColorDirective(0.5),
        OpacityColorDirective(0.5),
      ]);

      final color = colorDto.resolve(
        MixData.create(
          MockBuildContext(),
          Style(),
        ),
      );

      expect(0.5.toString(), color.a.toStringAsFixed(1));
    });

    test('TintColorDirective', () {
      const colorDto = ColorDto.raw(value: Color(0xFF800000), directives: [
        TintColorDirective(10),
        TintColorDirective(10),
      ]);

      final color = colorDto.resolve(
        MixData.create(
          MockBuildContext(),
          Style(),
        ),
      );

      expectColor(const Color(0xff983030), color);
    });

    test('ShadeColorDirective', () {
      const colorDto = ColorDto.raw(value: Colors.red, directives: [
        ShadeColorDirective(10),
        ShadeColorDirective(10),
      ]);

      final color = colorDto.resolve(
        MixData.create(
          MockBuildContext(),
          Style(),
        ),
      );

      expectColor(const Color(0xffc6362c), color);
    });

    test('DesaturateColorDirective', () {
      const colorDto = ColorDto.raw(value: Colors.red, directives: [
        DesaturateColorDirective(10),
        DesaturateColorDirective(10),
      ]);

      final color = colorDto.resolve(
        MixData.create(
          MockBuildContext(),
          Style(),
        ),
      );

      expect(const Color(0xffde554c), color);
    });

    test('SaturateColorDirective', () {
      const colorDto = ColorDto.raw(value: Color(0xffcc3333), directives: [
        SaturateColorDirective(10),
        SaturateColorDirective(10),
      ]);

      final color = colorDto.resolve(
        MixData.create(
          MockBuildContext(),
          Style(),
        ),
      );

      expect(const Color(0xffe61919), color);
    });

    test('DarkenColorDirective', () {
      const colorDto = ColorDto.raw(value: Colors.red, directives: [
        DarkenColorDirective(10),
        DarkenColorDirective(10),
      ]);

      final color = colorDto.resolve(
        MixData.create(
          MockBuildContext(),
          Style(),
        ),
      );

      expect(const Color(0xffba160a), color);
    });

    test('BrightenColorDirective', () {
      const colorDto = ColorDto.raw(value: Colors.red, directives: [
        BrightenColorDirective(10),
        BrightenColorDirective(10),
      ]);

      final color = colorDto.resolve(
        MixData.create(
          MockBuildContext(),
          Style(),
        ),
      );

      expectColor(const Color(0xffff7669), color);
    });

    test('LightenColorDirective', () {
      const colorDto = ColorDto.raw(value: Colors.red, directives: [
        LightenColorDirective(10),
        LightenColorDirective(10),
      ]);

      final color = colorDto.resolve(
        MixData.create(
          MockBuildContext(),
          Style(),
        ),
      );

      expect(const Color(0xfffa9d96), color);
    });
  });
}
