import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/src/components/form/checkbox/checkbox.dart';

import '../utils/interaction_tests.dart';

void main() {
  group('RxCheckbox', () {
    group('Constructor', () {
      const iconChecked = Icons.check_rounded;
      const iconUnchecked = Icons.close_rounded;
      const label = 'Accept Terms';
      const enabled = true;
      const selected = true;
      final style = RxCheckboxStyle();
      void onChanged(bool value) {}
      const variants = [Variant('name')];

      testWidgets('should initialize with correct properties', (tester) async {
        final checkbox = RxCheckbox(
          selected: selected,
          iconChecked: iconChecked,
          iconUnchecked: iconUnchecked,
          label: label,
          enabled: enabled,
          style: style,
          onChanged: onChanged,
          variants: variants,
        );

        await tester.pumpRxWidget(checkbox);

        expect(checkbox.selected, selected);
        expect(checkbox.iconChecked, iconChecked);
        expect(checkbox.iconUnchecked, iconUnchecked);
        expect(checkbox.label, label);
        expect(checkbox.enabled, enabled);
        expect(checkbox.style, style);
        expect(checkbox.onChanged, onChanged);
        expect(checkbox.variants, variants);
      });

      testWidgets('should render correct UI output', (tester) async {
        const checkbox = RxCheckbox(
          selected: true,
          iconChecked: Icons.check_rounded,
          label: 'Accept Terms',
        );

        await tester.pumpRxWidget(checkbox);

        final iconFinder = find.byIcon(Icons.check_rounded);
        expect(iconFinder, findsOneWidget);

        final labelFinder = find.text('Accept Terms');
        expect(labelFinder, findsOneWidget);
      });
    });

    testWidgets('should apply style correctly', (tester) async {
      final style = RxCheckboxStyle()..indicator.color.blue();

      final checkbox = RxCheckbox(
        selected: true,
        iconChecked: Icons.check_rounded,
        style: style,
      );

      await tester.pumpRxWidget(checkbox);

      final iconFinder = find.byIcon(Icons.check_rounded);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.color, Colors.blue);
    });

    group('interactions', () {
      testTapWidget('should call onChanged when tapped', (holder) {
        return RxCheckbox(
          selected: holder.value,
          onChanged: (newValue) {
            holder.value = newValue;
          },
        );
      }, shouldExpectPress: true);

      testTapWidget('should not call onChanged when disabled', (holder) {
        return RxCheckbox(
          selected: holder.value,
          enabled: false,
          onChanged: (newValue) {
            holder.value = newValue;
          },
        );
      }, shouldExpectPress: false);

      testHoverWidget('should handle hover state when enabled', () {
        return RxCheckbox(
          selected: true,
          onChanged: (newValue) {},
        );
      }, shouldExpectHover: true);

      testHoverWidget('should handle hover state when disabled', () {
        return RxCheckbox(
          selected: true,
          enabled: false,
          onChanged: (newValue) {},
        );
      }, shouldExpectHover: false);

      testFocusWidget('should handle focus state when enabled', (focusNode) {
        return RxCheckbox(
          selected: true,
          onChanged: (newValue) {},
          focusNode: focusNode,
        );
      }, shouldExpectFocus: true);

      testFocusWidget('should not focus when disabled', (focusNode) {
        return RxCheckbox(
          selected: true,
          enabled: false,
          focusNode: focusNode,
        );
      }, shouldExpectFocus: false);

      testSelectStateWidget('should handle select state', (holder) {
        return RxCheckbox(
          selected: holder.value,
          onChanged: (newValue) {
            holder.value = newValue;
          },
        );
      }, shouldExpectSelect: true);
    });
  });
}
