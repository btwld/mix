import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../utils/interaction_tests.dart';

void main() {
  group('RxBadge', () {
    group('Constructor', () {
      const label = 'Badge Label';
      const icon = Icons.star;
      const variants = [Variant('primary')];
      final style = RxBadgeStyle();

      testWidgets('should initialize with correct properties',
          (WidgetTester tester) async {
        final widget = RxBadge(
          label: label,
          icon: icon,
          variants: variants,
          style: style,
        );

        await tester.pumpRxWidget(widget);

        expect(widget.variants, variants);
        expect(widget.style, style);
      });

      testWidgets('Raw should initialize with correct properties',
          (WidgetTester tester) async {
        const child = SizedBox(
          width: 100,
          height: 100,
          child: Icon(icon),
        );

        final widget = RxBadge.raw(
          variants: variants,
          style: style,
          child: child,
        );

        await tester.pumpRxWidget(widget);

        expect(widget.child, child);
        expect(widget.variants, variants);
        expect(widget.style, style);
      });
    });

    testWidgets('should render correct UI output', (WidgetTester tester) async {
      await tester.pumpRxWidget(
        RxBadge(
          label: 'Badge Label',
          icon: Icons.star,
        ),
      );

      expect(find.text('Badge Label'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
