import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

Future<Icon> _iconFor(
  WidgetTester tester,
  String classNames, {
  Color fallbackColor = const Color(0xFF123456),
}) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: fallbackColor),
        child: TwIcon(
          Icons.add,
          classNames: classNames,
          config: TwConfig.standard(),
        ),
      ),
    ),
  );

  return tester.widget<Icon>(find.byIcon(Icons.add));
}

void main() {
  testWidgets('TwIcon applies size and color from base utilities', (
    tester,
  ) async {
    final icon = await _iconFor(tester, 'w-6 text-blue-700');

    expect(icon.size, 24);
    expect(icon.color, const Color(0xFF1D4ED8));
  });

  testWidgets('TwIcon takes the min of w-* and h-* for size', (tester) async {
    final icon = await _iconFor(tester, 'w-8 h-4');

    expect(icon.size, 16);
  });

  testWidgets('TwIcon falls back to inherited text color', (tester) async {
    final icon = await _iconFor(tester, 'w-6');

    expect(icon.color, const Color(0xFF123456));
  });

  testWidgets('TwIcon text color overrides the inherited fallback', (
    tester,
  ) async {
    final icon = await _iconFor(tester, 'text-blue-700');

    expect(icon.color, const Color(0xFF1D4ED8));
  });

  testWidgets('TwIcon ignores hover:/dark: color variants as base', (
    tester,
  ) async {
    final hover = await _iconFor(tester, 'hover:text-red-500');
    expect(hover.color, const Color(0xFF123456));

    final dark = await _iconFor(tester, 'dark:text-white');
    expect(dark.color, const Color(0xFF123456));
  });

  testWidgets('TwIcon ignores md:w-* size variants as base', (tester) async {
    final icon = await _iconFor(tester, 'md:w-6');

    expect(icon.size, isNull);
  });

  testWidgets('TwIcon applies opacity from opacity-* utility', (tester) async {
    final style = TwParser(config: TwConfig.standard()).parseIcon('opacity-50');
    double? opacity;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            opacity = style.resolve(context).spec.opacity;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(opacity, 0.5);
  });

  testWidgets('TwIcon applies logical margin as padding', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: TwIcon(
          Icons.add,
          classNames: 'w-3 h-3 me-1',
          config: TwConfig.standard(),
        ),
      ),
    );

    final padding = tester.widget<Padding>(find.byType(Padding));
    expect(padding.padding.resolve(TextDirection.ltr).right, 4);
  });

  testWidgets('TwIcon ignores variant-prefixed logical margins', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: TwIcon(
          Icons.add,
          classNames: 'hover:me-1',
          config: TwConfig.standard(),
        ),
      ),
    );

    expect(find.byType(Padding), findsNothing);
  });
}
