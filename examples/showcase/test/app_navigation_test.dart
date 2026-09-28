import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_showcase/main.dart';
import 'package:mix_showcase/ui/ui.dart';

void main() {
  for (final width in [320.0, 390.0, 1200.0]) {
    testWidgets('catalog and Box detail fit at ${width.toInt()}px', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const MixExamplesApp());
      expect(find.text('Explore Mix'), findsOneWidget);
      expect(find.text('Core widgets'), findsOneWidget);
      expect(find.byType(UiCard), findsWidgets);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Box').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('Live preview'), findsOneWidget);
      expect(find.text('Style with Mix'), findsOneWidget);
      expect(find.text('Copy code'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Snacks catalog can filter live examples', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MixExamplesApp());

    await tester.tap(find.text('View all').at(2));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(
      find.text('Small interactive recipes built with Mix.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Agent').first);
    await tester.pump();
    expect(find.text('Prompt Bar'), findsWidgets);
    expect(find.text('Squish Switch').hitTestable(), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
