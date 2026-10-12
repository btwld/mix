import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_showcase/snacks/examples.dart';

void main() {
  Future<void> show(WidgetTester t, Widget child) => t.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );

  testWidgets('code input fills the slots and focuses from every gap', (
    t,
  ) async {
    await show(t, const CodeSlots());
    final slots = t.getRect(find.byKey(const Key('code-slots')));
    expect(t.getRect(find.byType(TextField)), slots);
    for (final dx in [21.0, 46.0, 96.0, 146.0, 171.0]) {
      FocusManager.instance.primaryFocus?.unfocus();
      await t.pump();
      await t.tapAt(Offset(slots.left + dx, slots.center.dy));
      await t.pump();
      expect(
        t.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
        isTrue,
      );
      expect(t.testTextInput.isVisible, isTrue);
    }
    t.testTextInput.enterText('12a34');
    await t.pumpAndSettle();
    expect(
      t.widget<EditableText>(find.byType(EditableText)).controller.text,
      '1234',
    );
    expect(find.text('4'), findsOneWidget);
    await t.tapAt(Offset(slots.left + 96, slots.center.dy));
    await t.pump();
    expect(
      t.widget<EditableText>(find.byType(EditableText)).controller.selection,
      const TextSelection(baseOffset: 0, extentOffset: 4),
    );
    t.testTextInput.enterText('9999');
    await t.pumpAndSettle();
    expect(find.text('9'), findsNWidgets(4));
  });

  testWidgets('scrub edit selects value, keeps units, and commits outside', (
    t,
  ) async {
    await show(t, const ScrubField());
    final target = find.byKey(const Key('scrub-field'));
    final size = t.getSize(target);
    await t.tap(target);
    await t.pumpAndSettle();
    final field = t.widget<TextField>(find.byType(TextField));
    expect(
      field.controller!.selection,
      const TextSelection(baseOffset: 0, extentOffset: 2),
    );
    expect(field.style!.fontSize, 14);
    expect(field.decoration!.suffixText, ' px');
    expect(t.getSize(target), size);
    await t.enterText(find.byType(TextField), '88');
    await t.tapAt(const Offset(10, 10));
    await t.pumpAndSettle();
    expect(find.text('88 px'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(t.getSize(target), size);
  });
}
