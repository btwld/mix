import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_showcase/main.dart';

void main() {
  for (final width in [390.0, 1200.0]) {
    testWidgets('opens one layout example at ${width.toInt()}px', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const MixExamplesApp());
      expect(find.text('Live preview'), findsNothing);
      expect(find.byType(Image), findsWidgets);

      if (width < 800) {
        await tester.drag(find.byType(ListView).first, const Offset(0, -450));
        await tester.pump(const Duration(milliseconds: 350));
      }
      await tester.tap(find.text('View all').at(1));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('FlexBox').hitTestable(), findsOneWidget);
      expect(find.text('WrapBox').hitTestable(), findsOneWidget);
      expect(find.text('GridBox').hitTestable(), findsOneWidget);
      expect(find.text('Live preview'), findsNothing);
      expect(find.text('Example code'), findsNothing);
      expect(find.text('Open interactive gallery'), findsNothing);

      await tester.tap(find.text('GridBox').hitTestable());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('Live preview'), findsOneWidget);
      expect(find.text('Example code'), findsOneWidget);
      expect(
        find.text(width >= 800 ? '420px offered' : '240px offered'),
        findsOneWidget,
      );
      expect(find.text('FlexBox').hitTestable(), findsNothing);
      expect(find.text('Show more code'), findsOneWidget);

      final preview = tester.getTopLeft(find.text('Live preview'));
      final code = tester.getTopLeft(find.text('Example code'));
      if (width >= 800) {
        expect((preview.dy - code.dy).abs(), lessThan(2));
        expect(code.dx, greaterThan(preview.dx));
      } else {
        expect(code.dy, greaterThan(preview.dy + 200));
        expect((preview.dx - code.dx).abs(), lessThan(2));
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('home layout cards open that example only', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MixExamplesApp());

    await tester.tap(find.text('FlexBox').hitTestable());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Spacing 8'), findsOneWidget);
    expect(find.text('Live preview'), findsOneWidget);
    expect(find.text('WrapBox').hitTestable(), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
