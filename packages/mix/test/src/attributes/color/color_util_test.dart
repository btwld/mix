import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';
import 'helpers/expect_color.dart';

final class TestColorAttribute extends SpecAttribute<Color> {
  final ColorDto? value;
  const TestColorAttribute([this.value]);

  @override
  TestColorAttribute merge(TestColorAttribute? other) {
    return TestColorAttribute(value?.merge(other?.value) ?? other?.value);
  }

  @override
  Color resolve(MixData mix) {
    return value?.resolve(mix) ?? Colors.transparent;
  }

  @override
  get props => [value];
}

void main() {
  group('ColorUtility directives', () {
    final colorUtility = ColorUtility(TestColorAttribute.new);
    // withOpacity
    test('withOpacity should return a new ColorDirective', () {
      final attribute = colorUtility.withOpacity(0.5);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<OpacityColorDirective>());
    });

    test('withOpacity resolves the correct value', () {
      final style = Style(
        colorUtility(Colors.red),
        colorUtility.withOpacity(0.5),
      );

      final result = MockMixData(style);
      final value = result.resolvableOf<Color, TestColorAttribute>()!;

      expect(value, Colors.red.withValues(alpha: 0.5));
    });

    test('withOpacity equality is correct', () {
      final attribute1 = colorUtility.withOpacity(0.5);
      final attribute2 = colorUtility.withOpacity(0.5);
      final attribute3 = colorUtility.withOpacity(0.6);

      expect(attribute1, attribute2);
      expect(attribute1, isNot(attribute3));
    });

    // withAlpha
    test('withAlpha should return a new ColorDirective', () {
      final attribute = colorUtility.withAlpha(100);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<AlphaColorDirective>());
    });

    // withAlpha resolves
    test('withAlpha resolves the correct value', () {
      final style = Style(
        colorUtility(Colors.red),
        colorUtility.withAlpha(50),
      );

      final result = MockMixData(style);
      final value = result.resolvableOf<Color, TestColorAttribute>()!;

      expect(value, Colors.red.withAlpha(50));
    });

    // withAlpha equality is correct
    test('withAlpha equality is correct', () {
      final attribute1 = colorUtility.withAlpha(100);
      final attribute2 = colorUtility.withAlpha(100);
      final attribute3 = colorUtility.withAlpha(200);

      expect(attribute1, attribute2);
      expect(attribute1, isNot(attribute3));
    });

    // darken
    test('darken should return a new ColorDirective', () {
      final attribute = colorUtility.darken(10);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<DarkenColorDirective>());
    });

    //  darken resolves
    test('darken resolves the correct value', () {
      final style = Style(colorUtility(Colors.red), colorUtility.darken(10));

      final result = MockMixData(style);
      final value = result.resolvableOf<Color, TestColorAttribute>()!;

      expect(value, Colors.red.darken(10));
    });

    // darken equality
    test('darken equality is correct', () {
      final attribute1 = colorUtility.darken(10);
      final attribute2 = colorUtility.darken(10);
      final attribute3 = colorUtility.darken(20);

      expect(attribute1, attribute2);
      expect(attribute1, isNot(attribute3));
    });

    // lighten
    test('lighten should return a new ColorDirective', () {
      final attribute = colorUtility.lighten(10);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<LightenColorDirective>());
    });

    // lighten resolves
    test('lighten resolves the correct value', () {
      final style = Style(
        colorUtility(Colors.red),
        colorUtility.lighten(10),
      );

      final result = MockMixData(style);
      final value = result.resolvableOf<Color, TestColorAttribute>()!;

      expect(value, Colors.red.lighten(10));
    });

    // lighten equality
    test('lighten equality is correct', () {
      final attribute1 = colorUtility.lighten(10);
      final attribute2 = colorUtility.lighten(10);
      final attribute3 = colorUtility.lighten(20);

      expect(attribute1, attribute2);
      expect(attribute1, isNot(attribute3));
    });

    // saturate
    test('saturate should return a new ColorDirective', () {
      final attribute = colorUtility.saturate(10);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<SaturateColorDirective>());
    });

    // saturate resolves
    test('saturate resolves the correct value', () {
      final style = Style(
        colorUtility(Colors.red),
        colorUtility.saturate(10),
      );

      final result = MockMixData(style);
      final value = result.resolvableOf<Color, TestColorAttribute>()!;

      expect(value, Colors.red.saturate(10));
    });

    // saturate equality
    test('saturate equality is correct', () {
      final attribute1 = colorUtility.saturate(10);
      final attribute2 = colorUtility.saturate(10);
      final attribute3 = colorUtility.saturate(20);

      expect(attribute1, attribute2);
      expect(attribute1, isNot(attribute3));
    });

    // desaturate
    test('desaturate should return a new ColorDirective', () {
      final attribute = colorUtility.desaturate(10);

      expect(attribute.value?.directives.length, 1);
      expect(
        attribute.value?.directives.first,
        isA<DesaturateColorDirective>(),
      );
    });

    // desaturate resolves
    test('desaturate resolves the correct value', () {
      final style = Style(
        colorUtility(Colors.red),
        colorUtility.desaturate(10),
      );

      final result = MockMixData(style);
      final value = result.resolvableOf<Color, TestColorAttribute>()!;

      expect(value, Colors.red.desaturate(10));
    });

    // desaturate equality
    test('desaturate equality is correct', () {
      final attribute1 = colorUtility.desaturate(10);
      final attribute2 = colorUtility.desaturate(10);
      final attribute3 = colorUtility.desaturate(20);

      expect(attribute1, attribute2);
      expect(attribute1, isNot(attribute3));
    });

    // tint
    test('tint should return a new ColorDirective', () {
      final attribute = colorUtility.tint(10);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<TintColorDirective>());
    });

    // tint resolves
    test('tint resolves the correct value', () {
      final style = Style(colorUtility(Colors.red), colorUtility.tint(10));

      final result = MockMixData(style);
      final value = result.resolvableOf<Color, TestColorAttribute>()!;
      expect(value, Colors.red.tint(10));
    });

    //tint equality
    test('tint equality is correct', () {
      final attribute1 = colorUtility.tint(10);
      final attribute2 = colorUtility.tint(10);
      final attribute3 = colorUtility.tint(20);

      expect(attribute1, attribute2);
      expect(attribute1, isNot(attribute3));
    });

    // shade
    test('shade should return a new ColorDirective', () {
      final attribute = colorUtility.shade(10);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<ShadeColorDirective>());
    });

    // shade resolves
    test('shade resolves the correct value', () {
      final style = Style(colorUtility(Colors.red), colorUtility.shade(10));

      final result = MockMixData(style);
      final value = result.resolvableOf<Color, TestColorAttribute>()!;

      expect(value, Colors.red.shade(10));
    });

    // shade equality
    test('shade equality is correct', () {
      final attribute1 = colorUtility.shade(10);
      final attribute2 = colorUtility.shade(10);
      final attribute3 = colorUtility.shade(20);

      expect(attribute1, attribute2);
      expect(attribute1, isNot(attribute3));
    });

    // brighten
    test('brighten should return a new ColorDirective', () {
      final attribute = colorUtility.brighten(10);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<BrightenColorDirective>());
    });

    // brighten resolves
    test('brighten resolves the correct value', () {
      final style = Style(
        colorUtility(Colors.red),
        colorUtility.brighten(10),
      );

      final result = MockMixData(style);
      final value = result.resolvableOf<Color, TestColorAttribute>()!;

      expect(value, Colors.red.brighten(10));
    });

    // brighten equality
    test('brighten equality is correct', () {
      final attribute1 = colorUtility.brighten(10);
      final attribute2 = colorUtility.brighten(10);
      final attribute3 = colorUtility.brighten(20);

      expect(attribute1, attribute2);
      expect(attribute1, isNot(attribute3));
    });

    // lighten and darken and opacity
    test('lighten and darken and opacity resolves the correct value', () {
      final style = Style(
        colorUtility(Colors.red),
        colorUtility.lighten(10),
        colorUtility.darken(10),
        colorUtility.withOpacity(0.5),
      );

      final result = MockMixData(style);
      final value = result.resolvableOf<Color, TestColorAttribute>()!;

      expect(value, Colors.red.lighten(10).darken(10).withValues(alpha: 0.5));
    });
  });
  // group MaterialColorUtility
  group('MaterialColorUtility directives', () {
    final colorUtility = ColorUtility(TestColorAttribute.new);

    // shade
    test('shade should return a new ColorDirective', () {
      final attribute = colorUtility.red.shade(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<ShadeColorDirective>());
      expect(attribute.value?.value, Colors.red);

      expect(resolvedColor, Colors.red.shade(10));
    });

    // tint
    test('tint should return a new ColorDirective', () {
      final attribute = colorUtility.red.tint(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<TintColorDirective>());
      expect(attribute.value?.value, Colors.red);

      expect(resolvedColor, Colors.red.tint(10));
    });

    // lighten
    test('lighten should return a new ColorDirective', () {
      final attribute = colorUtility.red.lighten(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<LightenColorDirective>());
      expect(attribute.value?.value, Colors.red);

      expect(resolvedColor, Colors.red.lighten(10));
    });

    // darken
    test('darken should return a new ColorDirective', () {
      final attribute = colorUtility.red.darken(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<DarkenColorDirective>());
      expect(attribute.value?.value, Colors.red);

      expect(resolvedColor, Colors.red.darken(10));
    });

    // withOpacity
    test('withOpacity should return a new ColorDirective', () {
      final attribute = colorUtility.red.withOpacity(0.5);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<OpacityColorDirective>());
      expect(attribute.value?.value, Colors.red);

      expect(resolvedColor, Colors.red.withValues(alpha: 0.5));
    });

    // withAlpha
    test('withAlpha should return a new ColorDirective', () {
      final attribute = colorUtility.red.withAlpha(50);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<AlphaColorDirective>());
      expect(attribute.value?.value, Colors.red);

      expect(resolvedColor, Colors.red.withAlpha(50));
    });

    // saturate
    test('saturate should return a new ColorDirective', () {
      final attribute = colorUtility.red.saturate(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<SaturateColorDirective>());
      expect(attribute.value?.value, Colors.red);

      expect(resolvedColor, Colors.red.saturate(10));
    });

    // desaturate
    test('desaturate should return a new ColorDirective', () {
      final attribute = colorUtility.red.desaturate(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.value?.directives.length, 1);
      expect(
        attribute.value?.directives.first,
        isA<DesaturateColorDirective>(),
      );
      expect(attribute.value?.value, Colors.red);

      expect(resolvedColor, Colors.red.desaturate(10));
    });

    // brighten
    test('brighten should return a new ColorDirective', () {
      final attribute = colorUtility.red.brighten(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.value?.directives.length, 1);
      expect(attribute.value?.directives.first, isA<BrightenColorDirective>());
      expect(attribute.value?.value, Colors.red);

      expect(resolvedColor, Colors.red.brighten(10));
    });

    // lighten and darken and opacity
    test('lighten and darken and opacity resolves the correct value', () {
      final firstWayStyle = Style(
        colorUtility.red(),
        colorUtility.red.lighten(10),
        colorUtility.red.darken(10),
        colorUtility.red.withOpacity(0.5),
      );

      final secondWayStyle = Style(
        colorUtility.red(),
        colorUtility.lighten(10),
        colorUtility.darken(10),
        colorUtility.withOpacity(0.5),
      );

      final result1 = firstWayStyle.of(MockBuildContext());
      final result2 = secondWayStyle.of(MockBuildContext());
      final value = result1.resolvableOf<Color, TestColorAttribute>()!;

      expect(value, Colors.red.lighten(10).darken(10).withValues(alpha: 0.5));
      expect(firstWayStyle, secondWayStyle);
      expect(result1, result2);
    });
  });

  group('ColorUtility', () {
    // Use the .values to compare against Material colors
    test('call should return a new TestColorAttribute with the primary color',
        () {
      final colorUtil = ColorUtility(TestColorAttribute.new);

      expect(colorUtil.red().value?.value, Colors.red);
      expect(colorUtil.pink().value?.value, Colors.pink);
      expect(colorUtil.purple().value?.value, Colors.purple);
      expect(colorUtil.deepPurple().value?.value, Colors.deepPurple);
      expect(colorUtil.indigo().value?.value, Colors.indigo);
      expect(colorUtil.blue().value?.value, Colors.blue);
      expect(colorUtil.lightBlue().value?.value, Colors.lightBlue);
      expect(colorUtil.cyan().value?.value, Colors.cyan);
      expect(colorUtil.teal().value?.value, Colors.teal);
      expect(colorUtil.green().value?.value, Colors.green);
      expect(colorUtil.lightGreen().value?.value, Colors.lightGreen);
      expect(colorUtil.lime().value?.value, Colors.lime);
      expect(colorUtil.yellow().value?.value, Colors.yellow);
      expect(colorUtil.amber().value?.value, Colors.amber);
      expect(colorUtil.orange().value?.value, Colors.orange);
      expect(colorUtil.deepOrange().value?.value, Colors.deepOrange);
      expect(colorUtil.brown().value?.value, Colors.brown);
      expect(colorUtil.grey().value?.value, Colors.grey);
      expect(colorUtil.blueGrey().value?.value, Colors.blueGrey);
      expect(colorUtil.redAccent().value?.value, Colors.redAccent);
      expect(colorUtil.pinkAccent().value?.value, Colors.pinkAccent);
      expect(colorUtil.purpleAccent().value?.value, Colors.purpleAccent);
      expect(
          colorUtil.deepPurpleAccent().value?.value, Colors.deepPurpleAccent);
      expect(colorUtil.indigoAccent().value?.value, Colors.indigoAccent);
      expect(colorUtil.blueAccent().value?.value, Colors.blueAccent);
      expect(colorUtil.lightBlueAccent().value?.value, Colors.lightBlueAccent);
      expect(colorUtil.cyanAccent().value?.value, Colors.cyanAccent);
      expect(colorUtil.tealAccent().value?.value, Colors.tealAccent);
      expect(colorUtil.greenAccent().value?.value, Colors.greenAccent);
      expect(
          colorUtil.lightGreenAccent().value?.value, Colors.lightGreenAccent);
      expect(colorUtil.limeAccent().value?.value, Colors.limeAccent);
      expect(colorUtil.yellowAccent().value?.value, Colors.yellowAccent);
      expect(colorUtil.amberAccent().value?.value, Colors.amberAccent);
      expect(colorUtil.orangeAccent().value?.value, Colors.orangeAccent);
      expect(
          colorUtil.deepOrangeAccent().value?.value, Colors.deepOrangeAccent);

      // Test transparent color
      expect(colorUtil.transparent.color, Colors.transparent);

      // Test black colors
      expect(colorUtil.black.color, Colors.black);
      expect(colorUtil.black87.color, Colors.black87);
      expect(colorUtil.black54.color, Colors.black54);
      expect(colorUtil.black45.color, Colors.black45);
      expect(colorUtil.black38.color, Colors.black38);
      expect(colorUtil.black26.color, Colors.black26);
      expect(colorUtil.black12.color, Colors.black12);

      // Test white colors
      expect(colorUtil.white.color, Colors.white);
      expect(colorUtil.white70.color, Colors.white70);
      expect(colorUtil.white60.color, Colors.white60);
      expect(colorUtil.white54.color, Colors.white54);
      expect(colorUtil.white38.color, Colors.white38);
      expect(colorUtil.white30.color, Colors.white30);
      expect(colorUtil.white24.color, Colors.white24);
      expect(colorUtil.white12.color, Colors.white12);
    });
  });

  group('MaterialColorUtility', () {
    // Use the .values to compare against Material colors
    test('call should return a new TestColorAttribute with the primary color',
        () {
      final blueUtil =
          MaterialColorUtility(TestColorAttribute.new, Colors.blue);

      expect(blueUtil().value?.value, Colors.blue);
      expect(blueUtil.shade50.color, Colors.blue.shade50);
      expect(blueUtil.shade100.color, Colors.blue.shade100);
      expect(blueUtil.shade200.color, Colors.blue.shade200);
      expect(blueUtil.shade300.color, Colors.blue.shade300);
      expect(blueUtil.shade400.color, Colors.blue.shade400);
      expect(blueUtil.shade500.color, Colors.blue.shade500);
      expect(blueUtil.shade600.color, Colors.blue.shade600);
      expect(blueUtil.shade700.color, Colors.blue.shade700);
      expect(blueUtil.shade800.color, Colors.blue.shade800);
      expect(blueUtil.shade900.color, Colors.blue.shade900);
    });
  });

  group('MaterialAccentColorUtility', () {
    // Use the .values to compare against MaterialAccent colors
    test('call should return a new TestColorAttribute with the primary color',
        () {
      final blueUtil =
          MaterialAccentColorUtility(TestColorAttribute.new, Colors.blueAccent);

      expect(blueUtil().value?.value, Colors.blueAccent);
      expect(blueUtil.shade100.color, Colors.blueAccent.shade100);
      expect(blueUtil.shade200.color, Colors.blueAccent.shade200);
      expect(blueUtil.shade400.color, Colors.blueAccent.shade400);
      expect(blueUtil.shade700.color, Colors.blueAccent.shade700);
    });
  });

  group('ColorExt', () {
    const color1 = Color.fromARGB(255, 244, 67, 54); // Colors.red
    const color2 = Color.fromARGB(255, 33, 150, 243); // Colors.blue
    test('mix() should return the correct color', () {
      final mixedColor = color1.mix(color2, 50);

      expectColor(
        mixedColor,
        const Color.fromARGB(255, 139, 109, 148),
      ); // Colors.purple
    });

    test('mix() should return the correct color with 75%', () {
      final mixedColor = color1.mix(color2, 75);

      expectColor(
        mixedColor,
        const Color(0xff5681c4),
      ); // Colors.purple
    });

    test('mix() should return the correct color with 25%', () {
      final mixedColor = color1.mix(color2, 25);

      expectColor(
        mixedColor,
        const Color(0xffbf5865),
      ); // Colors.purple
    });

    test('lighten() should return the correct color', () {
      final lightenedColor = color1.lighten(10);

      expectColor(lightenedColor, const Color.fromARGB(255, 247, 112, 102));
    });

    test('brighten() should return the correct color', () {
      final brightenedColor = color1.brighten(10);

      expectColor(brightenedColor, const Color.fromARGB(255, 255, 93, 80));
    });

    test('darken() should return the correct color', () {
      final darkenedColor = color1.darken(10);

      expectColor(darkenedColor, const Color.fromARGB(255, 234, 28, 13));
    });

    test('tint() should return the correct color', () {
      final tintedColor = color1.tint(10);

      expectColor(tintedColor, const Color.fromARGB(255, 245, 86, 74));
    });

    test('shade() should return the correct color', () {
      final shadedColor = color1.shade(10);

      expectColor(shadedColor, const Color.fromARGB(255, 220, 60, 49));
    });

    test('desaturate() should return the correct color', () {
      final desaturatedColor = color1.desaturate(10);

      expectColor(desaturatedColor, const Color.fromARGB(255, 233, 76, 65));
    });

    test('saturate() should return the correct color', () {
      final saturatedColor = color1.saturate(10);

      expectColor(saturatedColor, const Color.fromARGB(255, 255, 58, 43));
    });

    test('greyscale() should return the correct color', () {
      final greyscaleColor = color1.greyscale();

      expectColor(greyscaleColor, const Color.fromARGB(255, 149, 149, 149));
    });

    test('complement() should return the correct color', () {
      final complementColor = color1.complement();

      expectColor(complementColor, const Color.fromARGB(255, 54, 231, 244));
    });

    test('toDto() should return the correct ColorDto', () {
      const color = Colors.blue;
      final colorDto = color.toDto();

      expect(colorDto, equals(const ColorDto(color)));
    });
  });
}
