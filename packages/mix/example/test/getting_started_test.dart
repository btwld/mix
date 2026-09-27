import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_example/basics/getting_started.dart';

void main() {
  testWidgets('saves and undoes with pointer and keyboard', (tester) async {
    await tester.pumpWidget(const GettingStartedApp());
    await tester.pumpAndSettle();
    expect(find.text('Make it yours.'), findsOneWidget);
    expect(
      tester.getSemantics(find.text('Save example')),
      matchesSemantics(
        label: 'Save example',
        isButton: true,
        isFocusable: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(
      Focus.of(tester.element(find.text('Save example'))).hasFocus,
      isTrue,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Saved — undo'), findsOneWidget);

    await tester.tap(find.text('Saved — undo'));
    await tester.pumpAndSettle();
    expect(find.text('Save example'), findsOneWidget);
  });

  testWidgets('fits a compact screen with larger text', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const GettingStartedApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Save example'), findsOneWidget);
  });
}
