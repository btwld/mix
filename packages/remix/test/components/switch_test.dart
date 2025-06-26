import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/src/components/form/switch/switch.dart';

import '../utils/interaction_tests.dart';

void main() {
  group('RxSwitch', () {
    group('Constructor', () {
      const selected = true;
      const enabled = true;
      final style = RxSwitchStyle();
      void onChanged(bool value) {}
      const variants = [Variant('primary')];

      testWidgets('should initialize with correct properties', (tester) async {
        final switchWidget = RxSwitch(
          selected: selected,
          enabled: enabled,
          style: style,
          onChanged: onChanged,
          variants: variants,
        );

        await tester.pumpRxWidget(switchWidget);

        expect(switchWidget.selected, selected);
        expect(switchWidget.enabled, enabled);
        expect(switchWidget.style, style);
        expect(switchWidget.onChanged, onChanged);
        expect(switchWidget.variants, variants);
      });

      testWidgets('should render correct UI output', (tester) async {
        final switchWidget = RxSwitch(
          selected: selected,
          onChanged: onChanged,
        );

        await tester.pumpRxWidget(switchWidget);

        final switchFinder = find.byType(RxSwitch);
        expect(switchFinder, findsOneWidget);
      });
    });

    testWidgets('should toggle state on tap', (tester) async {
      bool isSelected = false;

      await tester.pumpRxWidget(
        MaterialApp(
          home: Scaffold(
            body: RxSwitch(
              selected: isSelected,
              onChanged: (bool newValue) {
                isSelected = newValue;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(RxSwitch));
      await tester.pumpAndSettle();

      expect(isSelected, isTrue);
    });

    testWidgets('should not toggle state when disabled', (tester) async {
      bool isSelected = false;

      await tester.pumpRxWidget(
        MaterialApp(
          home: Scaffold(
            body: RxSwitch(
              selected: isSelected,
              enabled: false,
              onChanged: (bool newValue) {
                isSelected = newValue;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(RxSwitch));
      await tester.pumpAndSettle();

      expect(isSelected, isFalse);
    });

    group('interactions', () {
      testTapWidget('should call onChanged when tapped', (holder) {
        return RxSwitch(
          selected: holder.value,
          onChanged: (newValue) {
            holder.value = newValue;
          },
        );
      }, shouldExpectPress: true);

      testTapWidget('should not call onChanged when tapped and disabled',
          (holder) {
        return RxSwitch(
          selected: holder.value,
          enabled: false,
          onChanged: (newValue) {
            holder.value = newValue;
          },
        );
      }, shouldExpectPress: false);

      testHoverWidget('should handle hover state correctly', () {
        return RxSwitch(
          selected: false,
          onChanged: (newValue) {},
        );
      }, shouldExpectHover: true);

      testHoverWidget('should handle hover state correctly when disabled', () {
        return RxSwitch(
          selected: false,
          enabled: false,
          onChanged: (newValue) {},
        );
      }, shouldExpectHover: false);

      testFocusWidget('should handle focus state correctly', (focusNode) {
        return RxSwitch(
          selected: false,
          focusNode: focusNode,
          onChanged: (newValue) {},
        );
      }, shouldExpectFocus: true);

      testFocusWidget('should handle focus state correctly when disabled',
          (focusNode) {
        return RxSwitch(
          selected: false,
          enabled: false,
          onChanged: (newValue) {},
        );
      }, shouldExpectFocus: false);

      testSelectStateWidget('should handle select state correctly', (holder) {
        return RxSwitch(
          selected: holder.value,
          onChanged: (newValue) {
            holder.value = newValue;
          },
        );
      }, shouldExpectSelect: true);
    });
  });
}
