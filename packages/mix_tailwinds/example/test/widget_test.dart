import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mix_tailwinds_example/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TailwindParityApp smoke test', (WidgetTester tester) async {
    const width = 768.0;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(width, 2000);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(width, 2000)),
          child: MaterialApp(home: TailwindParityScreen(initialWidth: width)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify the app renders with expected text
    expect(find.text('mix_tailwinds parity samples'), findsOneWidget);
  });
}
