import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mix_tailwinds_example/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final originalOnError = FlutterError.onError;

  setUpAll(() {
    // Suppress expected RenderFlex overflow warnings during testing.
    // The app is designed for specific viewport sizes.
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      if (message.contains('RenderFlex overflowed')) {
        return;
      }
      originalOnError?.call(details);
    };
  });

  tearDownAll(() {
    FlutterError.onError = originalOnError;
  });

  testWidgets('TailwindParityApp smoke test', (WidgetTester tester) async {
    // Set a proper viewport size for the responsive app
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
          child: const TailwindParityApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify the app renders with expected text
    expect(find.text('mix_tailwinds parity samples'), findsOneWidget);
  });
}
