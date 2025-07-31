import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/core/internal/internal_extensions.dart';

void main() {
  group('StringExt', () {
    group('words', () {
      test('splits camelCase correctly', () {
        expect('helloWorld'.words, ['hello', 'World']);
        expect('HelloWorld'.words, ['Hello', 'World']);
        expect('helloWorldTest'.words, ['hello', 'World', 'Test']);
      });

      test('splits snake_case correctly', () {
        expect('hello_world'.words, ['hello', 'world']);
        expect('HELLO_WORLD'.words, ['HELLO', 'WORLD']);
        expect('hello_world_test'.words, ['hello', 'world', 'test']);
      });

      test('splits param-case correctly', () {
        expect('hello-world'.words, ['hello', 'world']);
        expect('HELLO-WORLD'.words, ['HELLO', 'WORLD']);
        expect('hello-world-test'.words, ['hello', 'world', 'test']);
      });

      test('splits space separated correctly', () {
        expect('hello world'.words, ['hello', 'world']);
        expect('HELLO WORLD'.words, ['HELLO', 'WORLD']);
        expect('Hello World Test'.words, ['Hello', 'World', 'Test']);
      });

      test('handles edge cases', () {
        expect(''.words, []);
        expect('hello'.words, ['hello']);
        expect('Hello'.words, ['Hello']);
        expect('HELLO'.words, ['HELLO']);
        expect('12345'.words, ['12345']);
        expect('hello123World'.words, ['hello123', 'World']);
      });

      test('handles all caps words correctly', () {
        expect('HELLOWORLD'.words, ['HELLOWORLD']);
        expect('HELLO_WORLD'.words, ['HELLO', 'WORLD']);
        expect('HELLO-WORLD'.words, ['HELLO', 'WORLD']);
      });

      test('handles special characters', () {
        expect('!@#\$%^&*()'.words, ['!@#\$%^&*()']);
        expect('Hello!World'.words, ['Hello!', 'World']);
      });
    });

    group('case checks', () {
      test('isUpperCase works correctly', () {
        expect('HELLO'.isUpperCase, true);
        expect('hello'.isUpperCase, false);
        expect('Hello'.isUpperCase, false);
        expect('HELLO WORLD'.isUpperCase, true);
        expect('Hello World'.isUpperCase, false);
      });

      test('isLowerCase works correctly', () {
        expect('hello'.isLowerCase, true);
        expect('HELLO'.isLowerCase, false);
        expect('Hello'.isLowerCase, false);
        expect('hello world'.isLowerCase, true);
        expect('Hello world'.isLowerCase, false);
      });
    });

    group('case conversions', () {
      test('camelCase conversion works', () {
        expect('hello_world'.camelCase, 'helloWorld');
        expect('hello-world'.camelCase, 'helloWorld');
        expect('Hello World'.camelCase, 'helloWorld');
        expect('HelloWorld'.camelCase, 'helloWorld');
        expect('HELLO_WORLD'.camelCase, 'helloWorld');
        expect('hello'.camelCase, 'hello');
        expect(''.camelCase, '');
      });

      test('pascalCase conversion works', () {
        expect('hello_world'.pascalCase, 'HelloWorld');
        expect('hello-world'.pascalCase, 'HelloWorld');
        expect('Hello World'.pascalCase, 'HelloWorld');
        expect('helloWorld'.pascalCase, 'HelloWorld');
        expect('HELLO_WORLD'.pascalCase, 'HelloWorld');
        expect('hello'.pascalCase, 'Hello');
        expect(''.pascalCase, '');
      });

      test('capitalize works correctly', () {
        expect('hello'.capitalize, 'Hello');
        expect('HELLO'.capitalize, 'Hello');
        expect('hello world'.capitalize, 'Hello world');
        expect('hELLO'.capitalize, 'Hello');
        expect(''.capitalize, '');
      });

      test('constantCase conversion works', () {
        expect('hello_world'.constantCase, 'HELLO_WORLD');
        expect('hello-world'.constantCase, 'HELLO_WORLD');
        expect('Hello World'.constantCase, 'HELLO_WORLD');
        expect('helloWorld'.constantCase, 'HELLO_WORLD');
        expect('HelloWorld'.constantCase, 'HELLO_WORLD');
        expect('hello'.constantCase, 'HELLO');
      });

      test('snakeCase conversion works', () {
        expect('HelloWorld'.snakeCase, 'hello_world');
        expect('hello-world'.snakeCase, 'hello_world');
        expect('Hello World'.snakeCase, 'hello_world');
        expect('helloWorld'.snakeCase, 'hello_world');
        expect('HELLO_WORLD'.snakeCase, 'hello_world');
        expect('hello'.snakeCase, 'hello');
      });

      test('paramCase conversion works', () {
        expect('HelloWorld'.paramCase, 'hello-world');
        expect('hello_world'.paramCase, 'hello-world');
        expect('Hello World'.paramCase, 'hello-world');
        expect('helloWorld'.paramCase, 'hello-world');
        expect('HELLO_WORLD'.paramCase, 'hello-world');
        expect('hello'.paramCase, 'hello');
      });

      test('titleCase conversion works', () {
        expect('HELLO_WORLD'.titleCase, 'Hello World');
        expect('hello-world'.titleCase, 'Hello World');
        expect('hello world'.titleCase, 'Hello World');
        expect('helloWorld'.titleCase, 'Hello World');
        expect('hello'.titleCase, 'Hello');
      });

      test('sentenceCase conversion works', () {
        expect('hello_world'.sentenceCase, 'Hello world');
        expect('HELLO_WORLD'.sentenceCase, 'Hello WORLD');
        expect('hello-world'.sentenceCase, 'Hello world');
        expect('hello world'.sentenceCase, 'Hello world');
        expect(''.sentenceCase, '');
        expect('hello'.sentenceCase, 'Hello');
      });
    });
  });

  group('DoubleExt', () {
    test('toRadius creates Radius.circular', () {
      expect(10.0.toRadius(), const Radius.circular(10.0));
      expect(0.0.toRadius(), const Radius.circular(0.0));
      expect(25.5.toRadius(), const Radius.circular(25.5));
    });
  });

  group('Matrix4Ext', () {
    test('merge combines matrices correctly', () {
      final matrix1 = Matrix4.identity();
      final matrix2 = Matrix4.rotationZ(math.pi / 4);
      final matrix3 = Matrix4.translationValues(10, 20, 30);

      final merged = matrix1.merge(matrix2);
      expect(merged, isNot(same(matrix1)));
      expect(merged, isNot(equals(matrix1)));

      // Test merging with null returns original
      final nullMerged = matrix1.merge(null);
      expect(nullMerged, same(matrix1));

      // Test merging with self returns self
      final selfMerged = matrix1.merge(matrix1);
      expect(selfMerged, same(matrix1));

      // Test complex merge
      final complexMerged = matrix2.merge(matrix3);
      expect(complexMerged, isA<Matrix4>());
    });
  });

  group('ListStringExt', () {
    test('lowercase converts all strings', () {
      expect(['HELLO', 'WORLD'].lowercase, ['hello', 'world']);
      expect(['Hello', 'World'].lowercase, ['hello', 'world']);
      expect(['hello', 'world'].lowercase, ['hello', 'world']);
      expect(<String>[].lowercase, <String>[]);
    });

    test('uppercase converts all strings', () {
      expect(['hello', 'world'].uppercase, ['HELLO', 'WORLD']);
      expect(['Hello', 'World'].uppercase, ['HELLO', 'WORLD']);
      expect(['HELLO', 'WORLD'].uppercase, ['HELLO', 'WORLD']);
      expect(<String>[].uppercase, <String>[]);
    });
  });

  group('IterableExt', () {
    test('firstMaybeNull returns first element or null', () {
      expect([1, 2, 3, 4, 5].firstMaybeNull, 1);
      expect(<int>[].firstMaybeNull, null);
      expect(['hello'].firstMaybeNull, 'hello');
    });

    test('firstWhereOrNull finds matching element or null', () {
      final list = [1, 2, 3, 4, 5];
      expect(list.firstWhereOrNull((element) => element == 3), 3);
      expect(list.firstWhereOrNull((element) => element == 6), null);
      expect(list.firstWhereOrNull((element) => element > 3), 4);
      expect(<int>[].firstWhereOrNull((element) => element == 1), null);
    });

    test('elementAtOrNull returns element at index or null', () {
      final list = [1, 2, 3, 4, 5];
      expect(list.elementAtOrNull(2), 3);
      expect(list.elementAtOrNull(0), 1);
      expect(list.elementAtOrNull(4), 5);
      expect(list.elementAtOrNull(-1), null);
      expect(list.elementAtOrNull(5), null);
      expect(list.elementAtOrNull(10), null);
    });

    test('sorted returns sorted iterable', () {
      final list = [5, 2, 4, 1, 3];
      expect(list.sorted(), [1, 2, 3, 4, 5]);
      expect(list.sorted((a, b) => a.compareTo(b)), [1, 2, 3, 4, 5]);
      expect(list.sorted((a, b) => b.compareTo(a)), [5, 4, 3, 2, 1]);
      expect(<int>[].sorted(), <int>[]);

      final strings = ['zebra', 'apple', 'banana'];
      expect(strings.sorted(), ['apple', 'banana', 'zebra']);
    });
  });

  group('ListExt', () {
    test('merge combines lists correctly', () {
      final list1 = [1, 2, 3, 4, 5];
      final list2 = [10, 20, 30];
      final merged = list1.merge(list2);

      expect(merged, [10, 20, 30, 4, 5]);
      expect(merged.length, 5);

      // Test with equal length lists
      final list3 = [100, 200, 300, 400, 500];
      final merged2 = list1.merge(list3);
      expect(merged2, [100, 200, 300, 400, 500]);

      // Test with longer second list
      final list4 = [1, 2];
      final list5 = [10, 20, 30, 40];
      final merged3 = list4.merge(list5);
      expect(merged3, [10, 20, 30, 40]);

      // Test with null
      expect(list1.merge(null), list1);

      // Test with empty lists
      expect(<int>[].merge([1, 2, 3]), [1, 2, 3]);
      expect([1, 2, 3].merge(<int>[]), [1, 2, 3]);
      expect(<int>[].merge(<int>[]), <int>[]);
    });
  });

  group('ColorExtensions', () {
    const testColor = Color(0xFF808080); // Medium gray

    test('lighten increases lightness', () {
      final lightened = testColor.lighten(20);
      expect(lightened, isA<Color>());

      final hslOriginal = HSLColor.fromColor(testColor);
      final hslLightened = HSLColor.fromColor(lightened);
      expect(hslLightened.lightness, greaterThan(hslOriginal.lightness));
    });

    test('brighten increases lightness and saturation', () {
      const colorWithSaturation = Color(0xFF808040); // Yellowish gray
      final brightened = colorWithSaturation.brighten(20);
      expect(brightened, isA<Color>());

      final hslOriginal = HSLColor.fromColor(colorWithSaturation);
      final hslBrightened = HSLColor.fromColor(brightened);
      expect(hslBrightened.lightness, greaterThan(hslOriginal.lightness));
    });

    test('darken decreases lightness', () {
      final darkened = testColor.darken(20);
      expect(darkened, isA<Color>());

      final hslOriginal = HSLColor.fromColor(testColor);
      final hslDarkened = HSLColor.fromColor(darkened);
      expect(hslDarkened.lightness, lessThan(hslOriginal.lightness));
    });

    test('tint mixes with white', () {
      final tinted = testColor.tint(20);
      expect(tinted, isA<Color>());

      // Tinting should make it lighter
      final hslOriginal = HSLColor.fromColor(testColor);
      final hslTinted = HSLColor.fromColor(tinted);
      expect(hslTinted.lightness, greaterThan(hslOriginal.lightness));
    });

    test('shade mixes with black', () {
      final shaded = testColor.shade(20);
      expect(shaded, isA<Color>());

      // Shading should make it darker
      final hslOriginal = HSLColor.fromColor(testColor);
      final hslShaded = HSLColor.fromColor(shaded);
      expect(hslShaded.lightness, lessThan(hslOriginal.lightness));
    });

    test('desaturate decreases saturation', () {
      const colorWithSaturation = Color(0xFFFF8080); // Light red
      final desaturated = colorWithSaturation.desaturate(30);
      expect(desaturated, isA<Color>());

      final hslOriginal = HSLColor.fromColor(colorWithSaturation);
      final hslDesaturated = HSLColor.fromColor(desaturated);
      expect(hslDesaturated.saturation, lessThan(hslOriginal.saturation));
    });

    test('saturate increases saturation', () {
      const grayishColor = Color(
        0xFF9F9F8F,
      ); // Grayish color with low saturation
      final saturated = grayishColor.saturate(30);
      expect(saturated, isA<Color>());

      final hslOriginal = HSLColor.fromColor(grayishColor);
      final hslSaturated = HSLColor.fromColor(saturated);
      expect(hslSaturated.saturation, greaterThan(hslOriginal.saturation));
    });

    test('grayscale fully desaturates', () {
      const colorWithSaturation = Color(0xFFFF8080); // Light red
      final grayscaled = colorWithSaturation.grayscale();
      expect(grayscaled, isA<Color>());

      final hslGrayscaled = HSLColor.fromColor(grayscaled);
      expect(hslGrayscaled.saturation, closeTo(0.0, 0.01));
    });

    test('complement rotates hue by 180 degrees', () {
      const colorWithHue = Color(0xFFFF0000); // Red
      final complemented = colorWithHue.complement();
      expect(complemented, isA<Color>());

      final hslOriginal = HSLColor.fromColor(colorWithHue);
      final hslComplemented = HSLColor.fromColor(complemented);
      final expectedHue = (hslOriginal.hue + 180) % 360;
      expect(hslComplemented.hue, closeTo(expectedHue, 1.0));
    });

    test('_normalizeAmount handles valid ranges', () {
      // Testing through public methods that use _normalizeAmount
      expect(() => testColor.lighten(0), returnsNormally);
      expect(() => testColor.lighten(100), returnsNormally);
      expect(() => testColor.lighten(50), returnsNormally);
    });

    test('_normalizeAmount throws on invalid ranges', () {
      expect(() => testColor.lighten(-1), throwsA(isA<RangeError>()));
      expect(() => testColor.lighten(101), throwsA(isA<RangeError>()));
    });
  });

  group('BuildContextExt', () {
    testWidgets('provides correct context information', (
      WidgetTester tester,
    ) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: MixScope(
            data: const MixScopeData.empty(),
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // Test directionality
      expect(
        capturedContext.directionality,
        Directionality.of(capturedContext),
      );

      // Test orientation
      expect(
        capturedContext.orientation,
        MediaQuery.of(capturedContext).orientation,
      );

      // Test screen size
      expect(capturedContext.screenSize, MediaQuery.of(capturedContext).size);

      // Test brightness
      expect(capturedContext.brightness, Theme.of(capturedContext).brightness);

      // Test theme
      expect(capturedContext.theme, Theme.of(capturedContext));

      // Test color scheme
      expect(
        capturedContext.colorScheme,
        Theme.of(capturedContext).colorScheme,
      );

      // Test text theme
      expect(capturedContext.textTheme, Theme.of(capturedContext).textTheme);

      // Test mix theme
      expect(capturedContext.mixTheme, const MixScopeData.empty());

      // Test computed properties
      expect(
        capturedContext.isDarkMode,
        Theme.of(capturedContext).brightness == Brightness.dark,
      );
      expect(
        capturedContext.isLandscape,
        MediaQuery.of(capturedContext).orientation == Orientation.landscape,
      );
      expect(
        capturedContext.isPortrait,
        MediaQuery.of(capturedContext).orientation == Orientation.portrait,
      );
    });

    testWidgets('handles dark theme correctly', (WidgetTester tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: MixScope(
            data: const MixScopeData.empty(),
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(capturedContext.brightness, Brightness.dark);
      expect(capturedContext.isDarkMode, true);
    });

    testWidgets('handles orientation changes', (WidgetTester tester) async {
      late BuildContext capturedContext;

      // Set landscape orientation
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: MixScope(
            data: const MixScopeData.empty(),
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(capturedContext.orientation, Orientation.landscape);
      expect(capturedContext.isLandscape, true);
      expect(capturedContext.isPortrait, false);

      // Reset to portrait
      tester.view.physicalSize = const Size(400, 800);

      await tester.pump();

      expect(capturedContext.orientation, Orientation.portrait);
      expect(capturedContext.isLandscape, false);
      expect(capturedContext.isPortrait, true);
    });
  });

  group('_clamp utility function', () {
    test('clamps values between 0.0 and 1.0', () {
      // Testing through color methods that use _clamp internally
      const testColor = Color(0xFF808080);

      // These should not throw and should produce valid colors
      expect(() => testColor.lighten(100), returnsNormally);
      expect(() => testColor.darken(100), returnsNormally);
      expect(() => testColor.saturate(100), returnsNormally);
      expect(() => testColor.desaturate(100), returnsNormally);
    });
  });
}
