import 'dart:ui' show SemanticsAction, SemanticsActionEvent;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_showcase/examples/snacks/spring_check.dart' as example;

void main() {
  testWidgets('strike stays vertically centered while toggling', (
    tester,
  ) async {
    example.main();
    await tester.pumpAndSettle();
    final label = find.text('Ship the build');
    final strike = find.descendant(
      of: find.descendant(
        of: find.byType(example.SpringCheck),
        matching: find.byType(Positioned),
      ),
      matching: find.byType(DecoratedBox),
    );

    void expectCentered() => expect(
      tester.getCenter(strike).dy,
      closeTo(tester.getCenter(label).dy, 0.01),
    );

    expectCentered();
    await tester.tap(find.byKey(const Key('spring-check')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 90));
    expectCentered();
    await tester.pumpAndSettle();
    expectCentered();
    expect(tester.getSize(strike).width, tester.getSize(label).width);
    await tester.tap(find.byKey(const Key('spring-check')));
    await tester.pumpAndSettle();
    expectCentered();
  });

  testWidgets('one checkbox semantic node owns its label and activation', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    example.main();
    await tester.pumpAndSettle();
    final control = find.byKey(const Key('spring-check'));
    final node = tester.getSemantics(control);
    expect(
      node,
      matchesSemantics(
        label: 'Ship the build',
        hasCheckedState: true,
        isChecked: false,
        isButton: false,
        hasTapAction: true,
      ),
    );
    tester.binding.performSemanticsAction(
      SemanticsActionEvent(
        type: SemanticsAction.tap,
        viewId: tester.view.viewId,
        nodeId: node.id,
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(control),
      matchesSemantics(
        label: 'Ship the build',
        hasCheckedState: true,
        isChecked: true,
        isButton: false,
        hasTapAction: true,
      ),
    );
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('standalone shell retains Material typography and interaction', (
    tester,
  ) async {
    final label = find.text('Ship the build');
    final originalTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF7C6AF7),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: example.pageColor,
      useMaterial3: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: originalTheme,
        home: const Scaffold(body: Text('Ship the build')),
      ),
    );
    final original = DefaultTextStyle.of(tester.element(label)).style;
    example.main();
    await tester.pumpAndSettle();
    final inherited = DefaultTextStyle.of(tester.element(label)).style;
    expect(inherited.fontFamily, original.fontFamily);
    expect(inherited.fontSize, original.fontSize);
    expect(inherited.height, original.height);
    expect(inherited.letterSpacing, original.letterSpacing);
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      example.pageColor,
    );

    Semantics checkedState() => tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.checked != null,
      ),
    );
    expect(checkedState().properties.checked, isFalse);
    await tester.tap(find.byKey(const Key('spring-check')));
    await tester.pumpAndSettle();
    expect(checkedState().properties.checked, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(checkedState().properties.checked, isFalse);
    expect(tester.takeException(), isNull);
  });
}
