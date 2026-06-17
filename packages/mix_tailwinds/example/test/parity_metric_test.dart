import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';
import 'package:mix_tailwinds_example/card_alert_preview.dart';
import 'package:mix_tailwinds_example/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const width = 768.0;
  const height = 1200.0;

  Future<void> pumpAt768(
    WidgetTester tester,
    Widget child, {
    Color background = const Color(0xFFF3F4F6),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(width, height);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: background,
          body: TwScope(config: TwConfig.standard(), child: child),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Rect rectForKey(WidgetTester tester, String key) {
    return tester.getRect(find.byKey(ValueKey(key)));
  }

  Border borderForKey(WidgetTester tester, String key) {
    final containers = tester
        .widgetList<Container>(
          find.descendant(
            of: find.byKey(ValueKey(key)),
            matching: find.byType(Container),
          ),
        )
        .where((container) => container.decoration is BoxDecoration)
        .map((container) => container.decoration! as BoxDecoration)
        .where((decoration) => decoration.border != null)
        .toList();

    expect(containers, isNotEmpty, reason: 'Expected $key to render a border.');
    return containers.first.border! as Border;
  }

  void expectTopOnlyBorder(Border border) {
    expect(border.top.width, 1);
    expect(border.top.style, BorderStyle.solid);

    for (final side in [border.right, border.bottom, border.left]) {
      expect(side.width, 0);
      expect(side.style, BorderStyle.none);
    }
  }

  testWidgets('card-alert 768px keeps Tailwind layout metrics', (tester) async {
    await pumpAt768(
      tester,
      const CardAlertPreview(),
      background: const Color(0xFF0F172A),
    );

    final content = rectForKey(tester, 'card-alert-content');
    final message = rectForKey(tester, 'card-alert-message');
    final messageText = tester.getRect(
      find.text(
        'Your profile changes are ready to publish. Review and confirm to update your public information.',
      ),
    );
    final warning = rectForKey(tester, 'card-alert-warning');
    final buttonRow = rectForKey(tester, 'card-alert-button-row');
    final cancel = rectForKey(tester, 'card-alert-cancel-button');
    final save = rectForKey(tester, 'card-alert-save-button');
    final cancelTextStyle = DefaultTextStyle.of(
      tester.element(find.text('Cancel')),
    ).style;
    final saveTextStyle = DefaultTextStyle.of(
      tester.element(find.text('Save Changes')),
    ).style;

    expect(content.width, closeTo(614, 0.1));
    expect(message.left, closeTo(content.left, 0.1));
    expect(message.width, closeTo(content.width, 0.1));

    expect(warning.left, closeTo(content.left, 0.1));
    expect(warning.width, closeTo(content.width, 0.1));
    expect(warning.top, closeTo(messageText.bottom + 16, 0.1));

    expect(buttonRow.left, closeTo(content.left, 0.1));
    expect(buttonRow.width, closeTo(content.width, 0.1));
    expect(buttonRow.top, closeTo(warning.bottom, 0.1));
    expect(cancel.width, closeTo(save.width, 1));
    expect(cancelTextStyle.fontSize, 16);
    expect(cancelTextStyle.fontWeight, FontWeight.w500);
    expect(saveTextStyle.fontSize, 16);
    expect(saveTextStyle.fontWeight, FontWeight.w500);
  });

  testWidgets('dashboard 768px keeps flex metrics and top-only separators', (
    tester,
  ) async {
    await pumpAt768(
      tester,
      const TailwindParityPreview(width: width, scrollable: false),
    );

    final spend = rectForKey(tester, 'dashboard-metric-Spend');
    final returnMetric = rectForKey(tester, 'dashboard-metric-Return');
    final cpa = rectForKey(tester, 'dashboard-metric-CPA');
    final viewButton = rectForKey(tester, 'dashboard-view-button');
    final downloadButton = rectForKey(tester, 'dashboard-download-button');

    expect(spend.width, closeTo(returnMetric.width, 1));
    expect(returnMetric.width, closeTo(cpa.width, 1));
    expect(viewButton.width, closeTo(downloadButton.width, 1));

    expectTopOnlyBorder(borderForKey(tester, 'dashboard-metric-row'));
    expectTopOnlyBorder(borderForKey(tester, 'dashboard-activity-Jalen Ruiz'));
    expectTopOnlyBorder(borderForKey(tester, 'dashboard-activity-Mara Singh'));
  });
}
