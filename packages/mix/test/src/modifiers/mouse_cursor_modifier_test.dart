import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  testWidgets('uses custom mouseCursor when provided', (
    WidgetTester tester,
  ) async {
    const cursor = SystemMouseCursors.resizeUpRight;
    await tester.pumpStyledWidget(Box(style: Style($box.wrap.cursor(cursor))));

    final finder = find.byType(MouseRegion);
    expect(finder, findsAtLeastNWidgets(1));

    // Find the MouseRegion with our custom cursor
    final mouseRegions = tester.widgetList<MouseRegion>(finder);
    final customMouseRegion = mouseRegions.firstWhere(
      (region) => region.cursor == cursor,
    );
    expect(customMouseRegion.cursor, equals(cursor));
  });
}
