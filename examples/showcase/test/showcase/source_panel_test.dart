import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_showcase/catalog/catalog.dart';
import 'package:mix_showcase/showcase/source_panel.dart';
import 'package:mix_showcase/ui/ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('all visible examples omit the standalone app shell', () async {
    for (final example in examples) {
      final full = await rootBundle.loadString(example.source);
      final visible = widgetExcerpt(full, focusClass: example.codeFocus);
      expect(visible, contains('class '), reason: example.title);
      expect(visible, isNot(contains('void main()')), reason: example.title);
      expect(visible, isNot(contains('MaterialApp(')), reason: example.title);
      expect(visible, isNot(contains('WidgetsApp(')), reason: example.title);
      expect(visible, isNot(contains('import ')), reason: example.title);
      expect(full, contains('void main()'), reason: example.title);
      if (example.codeFocus case final name?) {
        expect(
          visible.indexOf('class $name'),
          lessThan(visible.indexOf('// Supporting styles and values')),
          reason: example.title,
        );
      }
    }
  });

  testWidgets('Snack detail expands code and copies its full DartPad file', (
    tester,
  ) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        calls.add(call);
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });

    const path = 'lib/examples/snacks/squish_switch.dart';
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => UiThemeScope(mode: .light, child: child!),
        home: const Scaffold(
          body: SingleChildScrollView(
            child: SourcePanel(
              path: path,
              focusClass: 'SquishSwitch',
              expandable: true,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.ensureVisible(find.text('Show more code'));
    await tester.pump();
    await tester.tap(find.text('Show more code'));
    await tester.pump();
    expect(find.text('Show less code'), findsOneWidget);

    await tester.tap(find.text('Copy code'));
    await tester.runAsync(() async {
      for (var i = 0; i < 20 && calls.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    final copyCall = calls.singleWhere(
      (call) => call.method == 'Clipboard.setData',
    );
    final copied =
        (copyCall.arguments as Map<Object?, Object?>)['text']! as String;
    final expected = await tester.runAsync(() => rootBundle.loadString(path));
    expect(copied, expected);
    expect(copied, contains('void main()'));
  });

  testWidgets('Layout detail copies its complete runnable file', (
    tester,
  ) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        calls.add(call);
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });

    const path = 'lib/examples/layouts/grid.dart';
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => UiThemeScope(mode: .light, child: child!),
        home: const Scaffold(
          body: SingleChildScrollView(
            child: SourcePanel(
              path: path,
              focusClass: 'GridExample',
              summary:
                  'Widget first, supporting styles below · Copy the full runnable file',
            ),
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump();
    expect(find.textContaining('class GridExample'), findsWidgets);
    expect(find.textContaining('void main()'), findsNothing);
    expect(
      find.text(
        'Widget first, supporting styles below · Copy the full runnable file',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Copy code'));
    await tester.runAsync(() async {
      for (var i = 0; i < 20 && calls.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    final copyCall = calls.singleWhere(
      (call) => call.method == 'Clipboard.setData',
    );
    final copied =
        (copyCall.arguments as Map<Object?, Object?>)['text']! as String;
    final expected = await tester.runAsync(() => rootBundle.loadString(path));
    expect(copied, expected);
    expect(copied, contains('void main()'));
    expect(copied, contains('responsiveGrid'));
  });
}
