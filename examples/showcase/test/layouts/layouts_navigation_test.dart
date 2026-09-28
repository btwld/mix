import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_showcase/main.dart';

void main() {
  for (final width in [390.0, 1200.0]) {
    testWidgets('shows all layout previews and code at ${width.toInt()}px', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const MixExamplesApp());
      expect(find.text('Mix Examples'), findsOneWidget);

      if (width < 800) {
        await tester.drag(find.byType(ListView).first, const Offset(0, -450));
        await tester.pump(const Duration(milliseconds: 350));
      }
      await tester.tap(find.text('View all').at(1));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('FlexBox'), findsWidgets);
      expect(find.text('WrapBox'), findsWidgets);
      expect(find.text('GridBox'), findsWidgets);
      expect(find.text('Live preview'), findsNWidgets(3));
      expect(find.text('Example code'), findsNWidgets(3));
      expect(find.text('Open interactive gallery'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
