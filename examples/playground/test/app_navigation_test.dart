import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_example/layouts/layouts_gallery.dart';
import 'package:mix_example/main.dart';
import 'package:mix_example/snacks/gallery.dart';
import 'package:mix_example/ui/ui.dart';

void main() {
  for (final width in [320.0, 390.0, 1200.0]) {
    testWidgets('all sections open at ${width.toInt()}px', (tester) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const MixExamplesApp());
      expect(find.text('Make it yours.'), findsOneWidget);
      expect(find.byType(UiButton), findsNWidgets(3));
      final header = tester.getRect(find.byType(UiCard).first);
      expect(header.left, greaterThanOrEqualTo(0));
      expect(header.right, lessThanOrEqualTo(width));
      final preview = tester.getRect(
        find
            .ancestor(
              of: find.text('Make it yours.'),
              matching: find.byType(FlexBox),
            )
            .first,
      );
      expect(preview.left, greaterThanOrEqualTo(0));
      expect(preview.right, lessThanOrEqualTo(width));
      expect(_button(tester, 'Basics').variant, UiButtonVariant.primary);
      expect(_button(tester, 'Layouts').variant, UiButtonVariant.secondary);
      final heading = tester.widget<RichText>(
        find.descendant(
          of: find.byType(StyledText).first,
          matching: find.byType(RichText),
        ),
      );
      expect(heading.text.style?.color?.computeLuminance(), lessThan(0.2));

      await tester.tap(find.text('Layouts'));
      await tester.pump();
      expect(find.byType(LayoutsGalleryScreen), findsOneWidget);
      expect(_button(tester, 'Layouts').variant, UiButtonVariant.primary);

      await tester.tap(find.text('Snacks'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(SnacksGalleryScreen), findsOneWidget);
      expect(find.text('Squish Switch'), findsOneWidget);
      expect(_button(tester, 'Snacks').variant, UiButtonVariant.primary);
      expect(tester.takeException(), isNull);
    });
  }
}

UiButton _button(WidgetTester tester, String label) => tester
    .widgetList<UiButton>(find.byType(UiButton))
    .singleWhere((button) => button.label == label);
