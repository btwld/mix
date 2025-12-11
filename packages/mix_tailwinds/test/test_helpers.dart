import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

/// Helper to pump widget at specific viewport size.
Future<void> pumpSized(
  WidgetTester tester,
  Widget child, {
  required double width,
  double height = 800,
}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() => tester.view.resetPhysicalSize());

  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: child)),
  );
}

/// Helper to create parser with warning capture.
class ParserTestHelper {
  final List<String> unsupported = [];
  late final TwParser parser;

  ParserTestHelper([TwConfig? config]) {
    parser = TwParser(
      config: config ?? TwConfig.standard(),
      onUnsupported: unsupported.add,
    );
  }

  void expectNoWarnings() => expect(unsupported, isEmpty);
  void expectWarning(String token) => expect(unsupported, contains(token));
  void expectWarnings(List<String> tokens) {
    for (final token in tokens) {
      expect(unsupported, contains(token));
    }
  }
}

/// Extract box decoration from rendered Div.
Future<BoxDecoration?> boxDecorationFor(
  WidgetTester tester,
  String classNames,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Div(classNames: classNames, child: const SizedBox()),
      ),
    ),
  );
  final container = tester.widget<Container>(find.byType(Container));
  return container.decoration as BoxDecoration?;
}
