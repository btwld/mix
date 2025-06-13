import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

const _tokens = MixTokensTest();
void main() {
  group('TextStyleToken', () {
    test('Constructor assigns name correctly', () {
      const textStyleToken = TextStyleToken('testName');
      expect(textStyleToken.name, 'testName');
    });

    test('Equality operator works correctly', () {
      const textStyleToken1 = TextStyleToken('testName');
      const textStyleToken2 = TextStyleToken('testName');
      const textStyleToken3 = TextStyleToken('differentName');

      expect(textStyleToken1 == textStyleToken2, isTrue);
      expect(textStyleToken1 == textStyleToken3, isFalse);
      expect(textStyleToken1 == Object(), isFalse);
    });

    test('hashCode is consistent with name', () {
      const textStyleToken1 = TextStyleToken('testName');
      const textStyleToken2 = TextStyleToken('testName');
      const textStyleToken3 = TextStyleToken('differentName');

      expect(textStyleToken1.hashCode, textStyleToken2.hashCode);
      expect(textStyleToken1.hashCode, isNot(textStyleToken3.hashCode));
    });

    testWidgets('Test it resolves correctly', (tester) async {
      const redtextStyleToken = TextStyleToken('red');
      const greentextStyleToken = TextStyleToken('green');
      const bluetextStyleToken = TextStyleToken('blue');
      final theme = MixThemeData(
        textStyles: {
          redtextStyleToken: const TextStyle(color: Colors.red),
          greentextStyleToken: const TextStyle(color: Colors.green),
          bluetextStyleToken: const TextStyle(color: Colors.blue),
        },
      );

      await tester.pumpWidget(createWithMixTheme(theme));

      final context = tester.element(find.byType(Container));

      final mixData = MixContext.create(context, const Style.empty());

      expect(
        mixData.tokens.textStyleToken(redtextStyleToken),
        const TextStyle(color: Colors.red),
      );
      expect(
        mixData.tokens.textStyleToken(greentextStyleToken),
        const TextStyle(color: Colors.green),
      );
      expect(
        mixData.tokens.textStyleToken(bluetextStyleToken),
        const TextStyle(color: Colors.blue),
      );
    });
  });

  testWidgets('Combined Test', (tester) async {
    final themeData = MixThemeData(
      colors: {
        $material.colorScheme.error: Colors.blue,
        $material.colorScheme.background: Colors.red,
      },
      spaces: {
        _tokens.space.large: 100,
        _tokens.space.medium: 50,
      },
      textStyles: {
        $material.textTheme.bodyText1: const TextStyle(
            color: Colors.red,
            fontSize: 10,
            fontVariations: [FontVariation('wght', 400)]),
        $material.textTheme.bodyText2: const TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontVariations: [FontVariation('wght', 700)]),
      },
      radii: {
        _tokens.radius.medium: const Radius.elliptical(10, 50),
        _tokens.radius.large: const Radius.elliptical(50, 50),
      },
    );

    const key = Key('box');

    await tester.pumpWithMixTheme(
      Box(
        style: Style(
          $text.style.ref($material.textTheme.bodyText1),
          $text.style.ref($material.textTheme.bodyText2),
          $box.color.ref($material.colorScheme.background),
          $box.color.ref($material.colorScheme.error),
          $box.borderRadius.all.ref(_tokens.radius.medium),
          $box.borderRadius.all.ref(_tokens.radius.large),
          $box.padding.horizontal.ref(_tokens.space.medium),
          $box.padding.horizontal.ref(_tokens.space.large),
        ),
        key: key,
        child: const StyledText('Hello'),
      ),
      theme: themeData,
    );

    final textWidget = tester.widget<Text>(
      find.descendant(of: find.byKey(key), matching: find.byType(Text)),
    );

    final containerWidget = tester.widget<Container>(
      find.descendant(of: find.byKey(key), matching: find.byType(Container)),
    );

    expect(
      textWidget.style!.color,
      themeData.textStyles[$material.textTheme.bodyText2]!.color,
    );

    expect(
      textWidget.style!.fontSize,
      themeData.textStyles[$material.textTheme.bodyText2]!.fontSize,
    );

    expect(
      textWidget.style!.fontVariations,
      themeData.textStyles[$material.textTheme.bodyText2]!.fontVariations,
    );

    expect(
      (containerWidget.decoration as BoxDecoration).color,
      themeData.colors[$material.colorScheme.error],
    );

    expect(
      (containerWidget.decoration as BoxDecoration).borderRadius,
      BorderRadius.all(themeData.radii[_tokens.radius.large]!),
    );

    expect(
      containerWidget.padding!.horizontal / 2,
      themeData.spaces[_tokens.space.large],
    );
  });

  group('TextStyleResolver', () {
    testWidgets('resolve method is called correctly', (tester) async {
      var resolverCalled = false;
      final resolver = TextStyleResolver((_) {
        resolverCalled = true;
        return const TextStyle();
      });

      await tester.pumpWidget(
        MixTheme(
          data: MixThemeData(
              textStyles: {const TextStyleToken('test'): resolver}),
          child: Container(),
        ),
      );

      final context = tester.element(find.byType(Container));
      resolver.resolve(context);

      expect(resolverCalled, isTrue);
    });
  });

  group('TextStyleRef', () {
    test('copyWith throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.copyWith(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('fontFamily throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.fontFamily,
        throwsA(isA<FlutterError>()),
      );
    });

    test('inherit throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.inherit,
        throwsA(isA<FlutterError>()),
      );
    });

    test('color throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.color,
        throwsA(isA<FlutterError>()),
      );
    });

    test('backgroundColor throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.backgroundColor,
        throwsA(isA<FlutterError>()),
      );
    });

    test('fontSize throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.fontSize,
        throwsA(isA<FlutterError>()),
      );
    });

    test('fontWeight throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.fontWeight,
        throwsA(isA<FlutterError>()),
      );
    });

    test('fontStyle throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.fontStyle,
        throwsA(isA<FlutterError>()),
      );
    });

    test('letterSpacing throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.letterSpacing,
        throwsA(isA<FlutterError>()),
      );
    });

    test('wordSpacing throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.wordSpacing,
        throwsA(isA<FlutterError>()),
      );
    });

    test('textBaseline throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.textBaseline,
        throwsA(isA<FlutterError>()),
      );
    });

    test('height throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.height,
        throwsA(isA<FlutterError>()),
      );
    });

    test('leadingDistribution throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.leadingDistribution,
        throwsA(isA<FlutterError>()),
      );
    });

    test('locale throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.locale,
        throwsA(isA<FlutterError>()),
      );
    });

    test('foreground throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.foreground,
        throwsA(isA<FlutterError>()),
      );
    });

    test('background throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.background,
        throwsA(isA<FlutterError>()),
      );
    });

    test('shadows throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.shadows,
        throwsA(isA<FlutterError>()),
      );
    });

    test('fontFeatures throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.fontFeatures,
        throwsA(isA<FlutterError>()),
      );
    });

    test('fontVariations throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.fontVariations,
        throwsA(isA<FlutterError>()),
      );
    });

    test('decoration throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.decoration,
        throwsA(isA<FlutterError>()),
      );
    });

    test('decorationColor throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.decorationColor,
        throwsA(isA<FlutterError>()),
      );
    });

    test('decorationStyle throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.decorationStyle,
        throwsA(isA<FlutterError>()),
      );
    });

    test('decorationThickness throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.decorationThickness,
        throwsA(isA<FlutterError>()),
      );
    });

    test('debugLabel throws FlutterError', () {
      const ref = TextStyleRef(TextStyleToken('test'));
      expect(
        () => ref.debugLabel,
        throwsA(isA<FlutterError>()),
      );
    });
  });

  testWidgets('Test fontVariations are applied', (tester) async {
    const test = TextStyleToken('test');
    final theme = MixThemeData(
      textStyles: {
        test: const TextStyle(
          color: Colors.red,
          fontVariations: [FontVariation('wght', 900)],
        ),
      },
    );

    await tester.pumpWidget(createWithMixTheme(
      theme,
      child: StyledText(
        'test',
        style: Style($text.style.ref(test)),
      ),
    ));

    final widget = tester.widget<Text>(find.byType(Text));

    expect(widget.style?.color, Colors.red);
    expect(
      widget.style?.fontVariations,
      const [FontVariation('wght', 900)],
    );
  });
}
