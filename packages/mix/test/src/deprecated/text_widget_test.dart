// ignore_for_file: deprecated_member_use_from_same_package, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  testWidgets('StyledText should apply modifiers only once', (tester) async {
    await tester.pumpStyledWidget(
      StyledText(
        'test',
        style: Style($box.height(100), $box.width(100), $with.align()),
      ),
    );

    expect(find.byType(Align), findsOneWidget);
  });

  testWidgets('TextSpec properties should match Text properties', (
    WidgetTester tester,
  ) async {
    const textSpec = TextSpec(
      style: TextStyle(fontSize: 20, color: Colors.red),
      strutStyle: StrutStyle(fontSize: 16),
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      textScaler: TextScaler.linear(1.5),
      maxLines: 3,
      textWidthBasis: TextWidthBasis.longestLine,
      textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
    );

    const textKey = Key('text');
    final text = Text(
      'Sample Text',
      key: textKey,
      style: textSpec.style,
      strutStyle: textSpec.strutStyle,
      textAlign: textSpec.textAlign,
      textDirection: textSpec.textDirection,
      softWrap: textSpec.softWrap,
      overflow: textSpec.overflow,
      textScaler: textSpec.textScaler,
      maxLines: textSpec.maxLines,
      textWidthBasis: textSpec.textWidthBasis,
      textHeightBehavior: textSpec.textHeightBehavior,
    );
    const mixedTextKey = Key('mixed_text');
    const mixedText = TextSpecWidget(
      'Mixed Text',
      key: mixedTextKey,
      spec: textSpec,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Column(children: [text, mixedText])),
      ),
    );

    final textFinder = find.byKey(textKey);
    final textWidget = tester.widget<Text>(textFinder);
    expect(textFinder, findsOneWidget);
    final mixedTextFinder = find.byKey(mixedTextKey);
    expect(mixedTextFinder, findsOneWidget);

    final mixedTextWidget = tester.widget<Text>(
      find.descendant(of: mixedTextFinder, matching: find.byType(Text)),
    );

    expect(textWidget.data, 'Sample Text');
    expect(mixedTextWidget.data, 'Mixed Text');
    expect(textWidget.style, mixedTextWidget.style);
    expect(textWidget.strutStyle, mixedTextWidget.strutStyle);
    expect(textWidget.textAlign, mixedTextWidget.textAlign);
    expect(textWidget.textDirection, mixedTextWidget.textDirection);
    expect(textWidget.softWrap, mixedTextWidget.softWrap);
    expect(textWidget.overflow, mixedTextWidget.overflow);
    expect(textWidget.textScaler, mixedTextWidget.textScaler);
    expect(textWidget.maxLines, mixedTextWidget.maxLines);
    expect(textWidget.textWidthBasis, mixedTextWidget.textWidthBasis);
    expect(textWidget.textHeightBehavior, mixedTextWidget.textHeightBehavior);
  });

  testWidgets('StyledText should apply TextSpec properties', (tester) async {
    await tester.pumpStyledWidget(
      StyledText(
        'Hello, World!',
        style: Style($text.style.color(Colors.red), $text.style.fontSize(24.0)),
      ),
    );

    final textFinder = find.byType(Text);
    expect(textFinder, findsOneWidget);

    final text = tester.widget<Text>(textFinder);
    expect(text.style?.color, Colors.red);
    expect(text.style?.fontSize, 24.0);
  });

  testWidgets('StyledText should handle inherit property', (tester) async {
    await tester.pumpStyledWidget(
      StyledText(
        'Hello, World!',
        style: Style($text.style.color(Colors.red)),
        inherit: false,
      ),
    );

    final textFinder = find.byType(Text);
    expect(textFinder, findsOneWidget);

    final text = tester.widget<Text>(textFinder);
    expect(text.style?.color, Colors.red);
  });

  testWidgets('StyledText should handle locale property', (tester) async {
    await tester.pumpStyledWidget(
      StyledText(
        'Hello, World!',
        style: Style($text.style.color(Colors.red)),
        locale: const Locale('en', 'US'),
      ),
    );

    final textFinder = find.byType(Text);
    expect(textFinder, findsOneWidget);

    final text = tester.widget<Text>(textFinder);
    expect(text.locale, const Locale('en', 'US'));
  });

  testWidgets('TextSpecWidget should handle semanticsLabel and locale', (
    tester,
  ) async {
    const spec = TextSpec(style: TextStyle(color: Colors.blue));

    await tester.pumpMaterialApp(
      const TextSpecWidget(
        'Hello, World!',
        spec: spec,
        semanticsLabel: 'Custom Text',
        locale: Locale('fr', 'FR'),
      ),
    );

    final textFinder = find.byType(Text);
    expect(textFinder, findsOneWidget);

    final text = tester.widget<Text>(textFinder);
    expect(text.semanticsLabel, 'Custom Text');
    expect(text.locale, const Locale('fr', 'FR'));
  });

  testWidgets('TextSpecWidget should apply TextSpec.directive', (tester) async {
    final spec = TextSpec(directive: TextDirective((v) => v.toUpperCase()));

    await tester.pumpMaterialApp(TextSpecWidget('Hello, World!', spec: spec));

    final textFinder = find.text('HELLO, WORLD!');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('AnimatedTextSpecWidget should animate TextSpec properties', (
    tester,
  ) async {
    const spec1 = TextSpec(style: TextStyle(color: Colors.red, fontSize: 16.0));
    const spec2 = TextSpec(
      style: TextStyle(color: Colors.blue, fontSize: 24.0),
    );

    await tester.pumpMaterialApp(
      const AnimatedTextSpecWidget(
        'Hello, World!',
        spec: spec1,
        duration: Duration(milliseconds: 500),
      ),
    );

    expect(find.byType(TextSpecWidget), findsOneWidget);
    Text text = tester.widget<Text>(find.byType(Text));
    expect(text.style?.color, Colors.red);
    expect(text.style?.fontSize, 16.0);

    await tester.pumpMaterialApp(
      const AnimatedTextSpecWidget(
        'Hello, World!',
        spec: spec2,
        duration: Duration(milliseconds: 500),
      ),
    );
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byType(TextSpecWidget), findsOneWidget);
    text = tester.widget<Text>(find.byType(Text));
    expect(text.style?.color, Color.lerp(Colors.red, Colors.blue, 0.5));
    expect(text.style?.fontSize, 20.0);

    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byType(TextSpecWidget), findsOneWidget);
    text = tester.widget<Text>(find.byType(Text));
    expect(text.style?.color, Colors.blue);
    expect(text.style?.fontSize, 24.0);
  });

  testWidgets(
    'AnimatedTextSpecWidget should handle semanticsLabel and locale',
    (tester) async {
      const spec = TextSpec(style: TextStyle(color: Colors.blue));

      await tester.pumpMaterialApp(
        const AnimatedTextSpecWidget(
          'Hello, World!',
          spec: spec,
          duration: Duration(milliseconds: 500),
          semanticsLabel: 'Custom Animated Text',
          locale: Locale('es', 'ES'),
        ),
      );

      expect(find.byType(TextSpecWidget), findsOneWidget);
      final textSpecWidget = tester.widget<TextSpecWidget>(
        find.byType(TextSpecWidget),
      );
      expect(textSpecWidget.semanticsLabel, 'Custom Animated Text');
      expect(textSpecWidget.locale, const Locale('es', 'ES'));
    },
  );
}
