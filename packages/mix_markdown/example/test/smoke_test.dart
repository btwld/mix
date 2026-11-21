import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_markdown_example/main.dart';

void main() {
  testWidgets('renders the document and switches theme', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MarkdownDemoApp());
    expect(find.text('mix_markdown', findRichText: true), findsWidgets);
    expect(find.text('Note'), findsOneWidget);
    expect(find.text('Caution'), findsOneWidget);

    await tester.tap(find.byTooltip('Toggle theme'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
