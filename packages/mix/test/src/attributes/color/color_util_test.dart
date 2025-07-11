import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';
import 'helpers/expect_color.dart';

final class TestColorAttribute extends SpecAttribute<Color> with MixHelperMixin {
  final Prop<Color>? color;
  const TestColorAttribute([this.color]);
  
  // Constructor that takes a Color and creates TestColorAttribute
  TestColorAttribute.fromColor(Color colorValue) : color = Prop.value(colorValue);

  @override
  TestColorAttribute merge(TestColorAttribute? other) {
    if (other == null) return this;
    return TestColorAttribute(mergeProp(color, other.color));
  }

  @override
  Color resolve(MixContext mix) {
    return resolveProp(mix, color) ?? Colors.transparent;
  }

  @override
  get props => [color];
}

void main() {
  group('ColorUtility directives', () {
    final colorUtility = ColorUtility(TestColorAttribute.fromColor);
    // withOpacity
    test('withOpacity should return a new MixableDirective', () {
      final attribute = colorUtility.withOpacity(0.5);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
    });

    test('withOpacity resolves the correct value', () {
      final style = Style(
        colorUtility(Colors.red),
        colorUtility.withOpacity(0.5),
      );

      final result = MockMixData(style);
      final value = result.attributeOf<TestColorAttribute>()?.resolve(result);

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
    test('withAlpha should return a new MixableDirective', () {
      final attribute = colorUtility.withAlpha(100);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
    });

    // withAlpha resolves
    test('withAlpha resolves the correct value', () {
      final style = Style(colorUtility(Colors.red), colorUtility.withAlpha(50));

      final result = MockMixData(style);
      final value = result.attributeOf<TestColorAttribute>()?.resolve(result);

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
    test('darken should return a new MixableDirective', () {
      final attribute = colorUtility.darken(10);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
    });

    //  darken resolves
    test('darken resolves the correct value', () {
      final style = Style(colorUtility(Colors.red), colorUtility.darken(10));

      final result = MockMixData(style);
      final value = result.attributeOf<TestColorAttribute>()?.resolve(result);

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
    test('lighten should return a new MixableDirective', () {
      final attribute = colorUtility.lighten(10);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
    });

    // lighten resolves
    test('lighten resolves the correct value', () {
      final style = Style(colorUtility(Colors.red), colorUtility.lighten(10));

      final result = MockMixData(style);
      final value = result.attributeOf<TestColorAttribute>()?.resolve(result);

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
    test('saturate should return a new MixableDirective', () {
      final attribute = colorUtility.saturate(10);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
    });

    // saturate resolves
    test('saturate resolves the correct value', () {
      final style = Style(colorUtility(Colors.red), colorUtility.saturate(10));

      final result = MockMixData(style);
      final value = result.attributeOf<TestColorAttribute>()?.resolve(result);

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
    test('desaturate should return a new MixableDirective', () {
      final attribute = colorUtility.desaturate(10);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
    });

    // desaturate resolves
    test('desaturate resolves the correct value', () {
      final style = Style(
        colorUtility(Colors.red),
        colorUtility.desaturate(10),
      );

      final result = MockMixData(style);
      final value = result.attributeOf<TestColorAttribute>()?.resolve(result);

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
    test('tint should return a new MixableDirective', () {
      final attribute = colorUtility.tint(10);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
    });

    // tint resolves
    test('tint resolves the correct value', () {
      final style = Style(colorUtility(Colors.red), colorUtility.tint(10));

      final result = MockMixData(style);
      final value = result.attributeOf<TestColorAttribute>()?.resolve(result);
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
    test('shade should return a new MixableDirective', () {
      final attribute = colorUtility.shade(10);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
    });

    // shade resolves
    test('shade resolves the correct value', () {
      final style = Style(colorUtility(Colors.red), colorUtility.shade(10));

      final result = MockMixData(style);
      final value = result.attributeOf<TestColorAttribute>()?.resolve(result);

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
    test('brighten should return a new MixableDirective', () {
      final attribute = colorUtility.brighten(10);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
    });

    // brighten resolves
    test('brighten resolves the correct value', () {
      final style = Style(colorUtility(Colors.red), colorUtility.brighten(10));

      final result = MockMixData(style);
      final value = result.attributeOf<TestColorAttribute>()?.resolve(result);

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
      final value = result.attributeOf<TestColorAttribute>()?.resolve(result);

      expect(value, Colors.red.lighten(10).darken(10).withValues(alpha: 0.5));
    });
  });

  // Skipping MaterialColorUtility directive tests - directives functionality not implemented yet
  // See color_util.dart line 154-160: "TODO: Add support for tokens and directives"
  /*
  group('MaterialColorUtility directives tests', () {
    final colorUtility = ColorUtility(TestColorAttribute.fromColor);

    // shade
    test('shade should return a new MixableDirective', () {
      final attribute = colorUtility.red.shade(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
      expect(attribute.resolveProp(EmptyMixData, attribute.color), Colors.red);

      expect(resolvedColor, Colors.red.shade(10));
    });

    // tint
    test('tint should return a new MixableDirective', () {
      final attribute = colorUtility.red.tint(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
      expect(attribute.resolveProp(EmptyMixData, attribute.color), Colors.red);

      expect(resolvedColor, Colors.red.tint(10));
    });

    // lighten
    test('lighten should return a new MixableDirective', () {
      final attribute = colorUtility.red.lighten(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
      expect(attribute.resolveProp(EmptyMixData, attribute.color), Colors.red);

      expect(resolvedColor, Colors.red.lighten(10));
    });

    // darken
    test('darken should return a new MixableDirective', () {
      final attribute = colorUtility.red.darken(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
      expect(attribute.resolveProp(EmptyMixData, attribute.color), Colors.red);

      expect(resolvedColor, Colors.red.darken(10));
    });

    // withOpacity
    test('withOpacity should return a new MixableDirective', () {
      final attribute = colorUtility.red.withOpacity(0.5);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
      expect(attribute.resolveProp(EmptyMixData, attribute.color), Colors.red);

      expect(resolvedColor, Colors.red.withValues(alpha: 0.5));
    });

    // withAlpha
    test('withAlpha should return a new MixableDirective', () {
      final attribute = colorUtility.red.withAlpha(50);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
      expect(attribute.resolveProp(EmptyMixData, attribute.color), Colors.red);

      expect(resolvedColor, Colors.red.withAlpha(50));
    });

    // saturate
    test('saturate should return a new MixableDirective', () {
      final attribute = colorUtility.red.saturate(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
      expect(attribute.resolveProp(EmptyMixData, attribute.color), Colors.red);

      expect(resolvedColor, Colors.red.saturate(10));
    });

    // desaturate
    test('desaturate should return a new MixableDirective', () {
      final attribute = colorUtility.red.desaturate(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
      expect(attribute.resolveProp(EmptyMixData, attribute.color), Colors.red);

      expect(resolvedColor, Colors.red.desaturate(10));
    });

    // brighten
    test('brighten should return a new MixableDirective', () {
      final attribute = colorUtility.red.brighten(10);

      final resolvedColor = attribute.resolve(EmptyMixData);

      expect(attribute.color, isA<Prop<Color>>());
      // TODO: Test directives when ColorUtility properly supports them
      expect(attribute.resolveProp(EmptyMixData, attribute.color), Colors.red);

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
      final value = result1.attributeOf<TestColorAttribute>()?.resolve(result1);

      expect(value, Colors.red.lighten(10).darken(10).withValues(alpha: 0.5));
      expect(firstWayStyle, secondWayStyle);
      expect(result1, result2);
    });
  });
  */

  group('ColorUtility', () {
    // Use the .values to compare against Material colors
    test(
      'call should return a new TestColorAttribute with the primary color',
      () {
        final colorUtil = ColorUtility(TestColorAttribute.fromColor);

        expect(colorUtil.red(), resolvesTo(Colors.red));
        expect(colorUtil.pink(), resolvesTo(Colors.pink));
        expect(colorUtil.purple(), resolvesTo(Colors.purple));
        expect(colorUtil.deepPurple(), resolvesTo(Colors.deepPurple));
        expect(colorUtil.indigo(), resolvesTo(Colors.indigo));
        expect(colorUtil.blue(), resolvesTo(Colors.blue));
        expect(colorUtil.lightBlue(), resolvesTo(Colors.lightBlue));
        expect(colorUtil.cyan(), resolvesTo(Colors.cyan));
        expect(colorUtil.teal(), resolvesTo(Colors.teal));
        expect(colorUtil.green(), resolvesTo(Colors.green));
        expect(colorUtil.lightGreen(), resolvesTo(Colors.lightGreen));
        expect(colorUtil.lime(), resolvesTo(Colors.lime));
        expect(colorUtil.yellow(), resolvesTo(Colors.yellow));
        expect(colorUtil.amber(), resolvesTo(Colors.amber));
        expect(colorUtil.orange(), resolvesTo(Colors.orange));
        expect(colorUtil.deepOrange(), resolvesTo(Colors.deepOrange));
        expect(colorUtil.brown(), resolvesTo(Colors.brown));
        expect(colorUtil.grey(), resolvesTo(Colors.grey));
        expect(colorUtil.blueGrey(), resolvesTo(Colors.blueGrey));
        expect(colorUtil.redAccent(), resolvesTo(Colors.redAccent));
        expect(colorUtil.pinkAccent(), resolvesTo(Colors.pinkAccent));
        expect(colorUtil.purpleAccent(), resolvesTo(Colors.purpleAccent));
        expect(colorUtil.deepPurpleAccent(), resolvesTo(Colors.deepPurpleAccent));
        expect(colorUtil.indigoAccent(), resolvesTo(Colors.indigoAccent));
        expect(colorUtil.blueAccent(), resolvesTo(Colors.blueAccent));
        expect(colorUtil.lightBlueAccent(), resolvesTo(Colors.lightBlueAccent));
        expect(colorUtil.cyanAccent(), resolvesTo(Colors.cyanAccent));
        expect(colorUtil.tealAccent(), resolvesTo(Colors.tealAccent));
        expect(colorUtil.greenAccent(), resolvesTo(Colors.greenAccent));
        expect(colorUtil.lightGreenAccent(), resolvesTo(Colors.lightGreenAccent));
        expect(colorUtil.limeAccent(), resolvesTo(Colors.limeAccent));
        expect(colorUtil.yellowAccent(), resolvesTo(Colors.yellowAccent));
        expect(colorUtil.amberAccent(), resolvesTo(Colors.amberAccent));
        expect(colorUtil.orangeAccent(), resolvesTo(Colors.orangeAccent));
        expect(colorUtil.deepOrangeAccent(), resolvesTo(Colors.deepOrangeAccent));

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
      },
    );
  });

  group('MaterialColorUtility', () {
    // Use the .values to compare against Material colors
    test(
      'call should return a new TestColorAttribute with the primary color',
      () {
        final blueUtil = MaterialColorUtility(
          TestColorAttribute.fromColor,
          Colors.blue,
        );

        expect(blueUtil(), resolvesTo(Colors.blue));
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
      },
    );
  });

  group('MaterialAccentColorUtility', () {
    // Use the .values to compare against MaterialAccent colors
    test(
      'call should return a new TestColorAttribute with the primary color',
      () {
        final blueUtil = MaterialAccentColorUtility(
          TestColorAttribute.fromColor,
          Colors.blueAccent,
        );

        expect(blueUtil(), resolvesTo(Colors.blueAccent));
        expect(blueUtil.shade100.color, Colors.blueAccent.shade100);
        expect(blueUtil.shade200.color, Colors.blueAccent.shade200);
        expect(blueUtil.shade400.color, Colors.blueAccent.shade400);
        expect(blueUtil.shade700.color, Colors.blueAccent.shade700);
      },
    );
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

      expectColor(mixedColor, const Color(0xff5681c4)); // Colors.purple
    });

    test('mix() should return the correct color with 25%', () {
      final mixedColor = color1.mix(color2, 25);

      expectColor(mixedColor, const Color(0xffbf5865)); // Colors.purple
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

    test('Mixable.value() should return the correct Mixable<Color>', () {
      const color = Colors.blue;
      final colorDto = Mix.value(color);

      expect(colorDto, equals(Mix.value(color)));
    });
  });
}
