import 'package:mix_example/layouts/grid/grid_example.dart';
import 'package:mix_example/main.dart';
import 'package:mix_example/layouts/wrap/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens both galleries and returns to the layouts section', (
    tester,
  ) async {
    await tester.pumpWidget(const MixExamplesApp());
    expect(find.text('Mix examples'), findsOneWidget);

    await tester.tap(find.text('Layouts'));
    await tester.pumpAndSettle();

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
    expect(find.text('Mix examples'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
