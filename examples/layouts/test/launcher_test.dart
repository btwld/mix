import 'package:example_layouts/grid/grid_example.dart';
import 'package:example_layouts/main.dart';
import 'package:example_layouts/wrap/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens both galleries and returns to the launcher', (
    tester,
  ) async {
    await tester.pumpWidget(const LayoutsApp());
    expect(find.text('Mix Layouts'), findsOneWidget);

    await tester.tap(find.text('WrapBox'));
    await tester.pumpAndSettle();
    expect(find.byType(WrapBoxExampleScreen), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text('GridBox'));
    await tester.pumpAndSettle();
    expect(find.byType(GridBoxExampleScreen), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Mix Layouts'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
