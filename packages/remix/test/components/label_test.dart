import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../utils/interaction_tests.dart';

void main() {
  group('RxLabel', () {
    const label = 'Test Label';
    const icon = Icons.star;
    const variants = [Variant('primary')];

    testWidgets('should initialize with correct properties and display label',
        (WidgetTester tester) async {
      const widget = RxLabel(
        label,
        icon: icon,
      );

      await tester.pumpRxWidget(widget);

      expect(find.text(label), findsOneWidget);
      expect(find.byIcon(icon), findsOneWidget);
    });

    testWidgets('should display label without icon when icon is null',
        (WidgetTester tester) async {
      final widget = RxLabel(
        label,
        icon: null,
        variants: variants,
        style: RxLabelStyle(),
      );

      await tester.pumpRxWidget(widget);

      expect(find.text(label), findsOneWidget);
      expect(find.byIcon(icon), findsNothing);
    });

    testWidgets('should create label with icon in different positions',
        (WidgetTester tester) async {
      for (var position in [IconPosition.start, IconPosition.end]) {
        await tester.pumpRxWidget(
          RxLabel(
            label,
            icon: icon,
            iconPosition: position,
            variants: variants,
            style: RxLabelStyle(),
          ),
        );

        expect(find.text(label), findsOneWidget);
        expect(find.byIcon(icon), findsOneWidget);

        final findPosition = position == IconPosition.start
            ? FindPosition.first
            : FindPosition.last;

        final iconWidget = findWidgetInFlex<Icon>(
          tester,
          parentType: RxLabel,
          widgetType: Icon,
          findPosition: findPosition,
        );

        expect(iconWidget.icon, icon);
      }
    });
  });
}
