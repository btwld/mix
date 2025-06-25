import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../utils/interaction_tests.dart';

void main() {
  group('RxChip', () {
    group('Constructor', () {
      const label = 'Test Label';
      const iconLeft = Icons.check;
      const iconRight = Icons.close;
      const isSelected = true;
      const isEnabled = true;
      const variants = [Variant('primary')];
      final style = RxChipStyle()..container.color.red();
      void onChanged(bool value) {}

      testWidgets('should initialize with correct properties',
          (WidgetTester tester) async {
        final widget = RxChip(
          label: label,
          iconLeft: iconLeft,
          iconRight: iconRight,
          selected: isSelected,
          enabled: isEnabled,
          variants: variants,
          style: style,
          onChanged: onChanged,
        );

        await tester.pumpRxWidget(widget);

        expect(widget.label, label);
        expect(widget.iconLeft, iconLeft);
        expect(widget.iconRight, iconRight);
        expect(widget.selected, isSelected);
        expect(widget.enabled, isEnabled);
        expect(widget.variants, variants);
        expect(widget.style, style);
        expect(widget.onChanged, onChanged);

        expect(find.text(label), findsOneWidget);
        expect(find.byIcon(iconLeft), findsOneWidget);
        expect(find.byIcon(iconRight), findsOneWidget);
      });

      testWidgets('Raw should initialize with correct properties',
          (WidgetTester tester) async {
        const child = SizedBox(
          width: 100,
          height: 100,
          child: Icon(iconLeft),
        );

        final widget = RxChip.raw(
          label: label,
          iconLeft: iconLeft,
          iconRight: iconRight,
          selected: isSelected,
          enabled: isEnabled,
          variants: variants,
          style: style,
          onChanged: onChanged,
          child: child,
        );

        await tester.pumpRxWidget(widget);

        expect(widget.label, label);
        expect(widget.iconLeft, iconLeft);
        expect(widget.iconRight, iconRight);
        expect(widget.selected, isSelected);
        expect(widget.enabled, isEnabled);
        expect(widget.variants, variants);
        expect(widget.style, style);
        expect(widget.onChanged, onChanged);

        expect(find.byWidget(child), findsOneWidget);
      });
    });

    testWidgets('should display icons in correct positions',
        (WidgetTester tester) async {
      const iconLeft = Icons.check;
      const iconRight = Icons.close;

      await tester.pumpRxWidget(
        RxChip(
          label: 'Test',
          iconLeft: iconLeft,
          iconRight: iconRight,
          onChanged: (_) {},
        ),
      );

      final iconLeftFinder = find.byIcon(iconLeft);
      final iconRightFinder = find.byIcon(iconRight);

      expect(
          tester.getTopLeft(iconLeftFinder).dx <
              tester.getTopLeft(iconRightFinder).dx,
          isTrue);
    });

    testWidgets('should change selection state on tap',
        (WidgetTester tester) async {
      bool isSelected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RxChip(
              label: 'Test',
              selected: isSelected,
              onChanged: (bool newValue) {
                isSelected = newValue;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(RxChip));
      await tester.pumpAndSettle();

      expect(isSelected, isTrue);
    });

    testWidgets('should not change selection state when disabled',
        (WidgetTester tester) async {
      bool isSelected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RxChip(
              label: 'Test',
              selected: isSelected,
              enabled: false,
              onChanged: (bool newValue) {
                isSelected = newValue;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(RxChip));
      await tester.pumpAndSettle();

      expect(isSelected, isFalse);
    });

    group('interactions', () {
      testTapWidget('should call onChanged when tapped', (holder) {
        return RxChip(
          label: 'Test',
          selected: holder.value,
          onChanged: (newValue) {
            holder.value = newValue;
          },
        );
      }, shouldExpectPress: true);

      testTapWidget('should not call onChanged when tapped and disabled',
          (holder) {
        return RxChip(
          label: 'Test',
          selected: holder.value,
          enabled: false,
          onChanged: (newValue) {
            holder.value = newValue;
          },
        );
      }, shouldExpectPress: false);

      testHoverWidget('should handle hover state correctly', () {
        return RxChip(
          label: 'Test',
          selected: false,
          onChanged: (newValue) {},
        );
      }, shouldExpectHover: true);

      testFocusWidget('should handle focus state correctly', (focusNode) {
        return RxChip(
          label: 'Test',
          selected: false,
          focusNode: focusNode,
          onChanged: (newValue) {},
        );
      }, shouldExpectFocus: true);

      testFocusWidget('should handle focus state correctly when disabled',
          (focusNode) {
        return RxChip(
          label: 'Test',
          selected: false,
          enabled: false,
          focusNode: focusNode,
          onChanged: (newValue) {},
        );
      }, shouldExpectFocus: false);

      testSelectStateWidget('should handle select state correctly', (holder) {
        return RxChip(
          label: 'Test',
          selected: holder.value,
          onChanged: (newValue) {
            holder.value = newValue;
          },
        );
      }, shouldExpectSelect: true);
    });
  });
}
