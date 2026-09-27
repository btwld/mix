import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example_snacks/gallery/examples.dart';
import 'helpers/snacks_test_harness.dart' show paintedBounds;

void main() {
  Future<void> show(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );

  for (final demo in <(Widget, String)>[
    (const SwipeToast(), 'Notify'),
    (const FuseButton(), 'Archive'),
    (const BellToggle(), 'Muted'),
  ]) {
    testWidgets('${demo.$2} shrinks during press and restores on cancel', (
      t,
    ) async {
      await show(t, demo.$1);
      final label = find.text(demo.$2);
      final width = paintedBounds(t, label).width;
      final gesture = await t.startGesture(t.getCenter(label));
      await t.pump();
      await t.pump(const Duration(milliseconds: 120));
      expect(paintedBounds(t, label).width, lessThan(width * 0.99));
      await gesture.cancel();
      await t.pumpAndSettle();
      expect(paintedBounds(t, label).width, closeTo(width, 0.1));
    });
  }

  testWidgets('Enter sends and completion preserves a newer draft', (t) async {
    await show(t, const PromptBar());
    await t.enterText(find.byType(TextField), 'Sent request');
    await t.testTextInput.receiveAction(TextInputAction.send);
    await t.pump();
    expect(find.byIcon(Icons.stop_rounded), findsOneWidget);
    await t.enterText(find.byType(TextField), 'Next draft');
    await t.pump(const Duration(milliseconds: 1000));
    expect(
      t.widget<TextField>(find.byType(TextField)).controller!.text,
      'Next draft',
    );
    expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
  });

  testWidgets('collapsed menu items cannot receive keyboard focus', (t) async {
    await show(t, const BranchedMenu());
    bool focused(String text) {
      final context = t.element(find.text(text));
      return Focus.of(context).hasFocus;
    }

    for (var i = 0; i < 12; i++) {
      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pump();
      expect(focused('Spring'), isFalse);
      expect(focused('Keyframes'), isFalse);
    }
    await t.tap(find.text('Motion'));
    await t.pumpAndSettle();
    Focus.of(t.element(find.text('Spring'))).requestFocus();
    await t.pump();
    expect(focused('Spring'), isTrue);
    await t.tap(find.text('Design'));
    await t.pumpAndSettle();
    expect(focused('Spring'), isFalse);
    expect(Focus.of(t.element(find.text('Spring'))).canRequestFocus, isFalse);
  });

  testWidgets('bell keeps its layout footprint across activation', (t) async {
    await show(t, const BellToggle());
    final target = find.byKey(const Key('bell-toggle'));
    final size = t.getSize(target);
    await t.tap(target);
    await t.pump();
    await t.pump(const Duration(milliseconds: 100));
    expect(t.getSize(target), size);
    await t.pumpAndSettle();
    expect(t.getSize(target), size);
    expect(find.text('Notify me'), findsOneWidget);
  });
}
