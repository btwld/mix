import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../utils/interaction_tests.dart';

void main() {
  group('RxDivider', () {
    group('Constructor', () {
      const variants = [Variant('primary')];
      final style = RxDividerStyle()..container.color.red();

      testWidgets('should initialize with correct properties',
          (WidgetTester tester) async {
        final widget = RxDivider(
          variants: variants,
          style: style,
        );

        await tester.pumpRxWidget(widget);

        expect(widget.variants, variants);
        expect(widget.style, style);
      });
    });

    testWidgets('should apply style correctly', (WidgetTester tester) async {
      final style = RxDividerStyle()..container.color.blue();

      final widget = RxDivider(
        style: style,
      );

      await tester.pumpRxWidget(widget);

      // Assuming the divider renders a container, we check the color
      final containerFinder = find.byType(Container);
      final containerWidget = tester.widget<Container>(containerFinder);
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.color, Colors.blue);
    });
  });
}
