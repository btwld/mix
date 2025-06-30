import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../utils/interaction_tests.dart';

void main() {
  group('RxRadio', () {
    group('Constructor', () {
      const label = 'Option 1';
      const value = 'value1';
      const enabled = true;

      testWidgets('should initialize with correct properties', (tester) async {
        const radio = RxRadio<String>(
          value: value,
          label: label,
          enabled: enabled,
        );

        expect(radio.value, value);
        expect(radio.label, label);
        expect(radio.enabled, enabled);
      });

      testWidgets('should render correct UI output', (tester) async {
        final radio = RxRadioGroup<String>(
          value: 'value1',
          onChanged: (value) {},
          child: const RxRadio<String>(
            value: 'value1',
            label: 'Option 1',
          ),
        );

        await tester.pumpRxWidget(radio);

        final labelFinder = find.text('Option 1');
        expect(labelFinder, findsOneWidget);
      });

      testWidgets('should throw error when used outside of RxRadioGroup',
          (tester) async {
        await tester.pumpRxWidget(const RxRadio<String>(
          value: 'value1',
          label: 'Option 1',
        ));
        expect(tester.takeException(), isAssertionError);
      });
    });
  });

  group('RxRadioGroup', () {
    const value = 'value1';
    const enabled = true;
    void onChanged(String? value) {}

    group('Constructor', () {
      testWidgets('should initialize with correct properties', (tester) async {
        const label = 'Option 1';
        final radioGroup = RxRadioGroup<String>(
          value: value,
          onChanged: onChanged,
          child: const RxRadio<String>(
            value: value,
            label: label,
            enabled: enabled,
          ),
        );

        await tester.pumpRxWidget(radioGroup);

        expect(radioGroup.value, value);
        expect(radioGroup.onChanged, onChanged);
        expect(radioGroup.child, isA<RxRadio<String>>());
      });

      testWidgets('should render correct UI output', (tester) async {
        await tester.pumpRxWidget(
          RxRadioGroup<String>(
            value: 'value1',
            onChanged: (value) {},
            child: const RxRadio<String>(
              value: 'value1',
              label: 'Option 1',
            ),
          ),
        );

        final labelFinder = find.text('Option 1');
        expect(labelFinder, findsOneWidget);
      });
    });

    group('Interaction', () {
      testWidgets('should change selection state on tap when enabled',
          (tester) async {
        String? selectedValue;

        await tester.pumpRxWidget(
          RxRadioGroup<String>(
            value: selectedValue,
            onChanged: (newValue) {
              selectedValue = newValue;
            },
            child: const Column(
              children: [
                RxRadio<String>(
                  value: 'value1',
                  label: 'Option 1',
                ),
                RxRadio<String>(
                  value: 'value2',
                  label: 'Option 2',
                ),
              ],
            ),
          ),
        );

        await tester.tap(find.text('Option 1'));
        await tester.pumpAndSettle();

        expect(selectedValue, 'value1');
      });

      testWidgets(
          'should not change selection state when the group is disabled',
          (tester) async {
        String? selectedValue;

        await tester.pumpRxWidget(
          RxRadioGroup<String>(
            value: selectedValue,
            enabled: false,
            onChanged: (newValue) {
              selectedValue = newValue;
            },
            child: const Column(
              children: [
                RxRadio<String>(
                  value: 'value1',
                  label: 'Option 1',
                ),
                RxRadio<String>(
                  value: 'value2',
                  label: 'Option 2',
                ),
              ],
            ),
          ),
        );

        await tester.tap(find.text('Option 1'));
        await tester.pumpAndSettle();

        expect(selectedValue, isNull);
      });

      testWidgets(
          'should not change selection state when a disabled radio option is tapped',
          (tester) async {
        String? selectedValue;

        await tester.pumpRxWidget(
          RxRadioGroup<String>(
            value: selectedValue,
            onChanged: (newValue) {
              selectedValue = newValue;
            },
            child: const Column(
              children: [
                RxRadio<String>(
                  value: 'value1',
                  label: 'Option 1',
                  enabled: false,
                ),
                RxRadio<String>(
                  value: 'value2',
                  label: 'Option 2',
                ),
              ],
            ),
          ),
        );

        await tester.tap(find.text('Option 1'));
        await tester.pumpAndSettle();

        expect(selectedValue, isNull);
      });
    });

    group('State Management', () {
      Future<void> testPressedState(
        WidgetTester tester, {
        required bool enabled,
        required bool expectedPressedDuringTap,
      }) async {
        await tester.pumpRxWidget(
          RxRadioGroup<String>(
            value: 'value1',
            onChanged: (value) {},
            child: RxRadio<String>(
              enabled: enabled,
              value: 'value1',
              label: 'Option 1',
            ),
          ),
        );

        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Option 1')),
        );

        await tester.pumpAndSettle();

        final state = tester
            .widget<MixWidgetStateModel>(find.byType(MixWidgetStateModel));
        expect(state.pressed, expectedPressedDuringTap);

        await gesture.up();
        await tester.pumpAndSettle();

        final stateAfter = tester
            .widget<MixWidgetStateModel>(find.byType(MixWidgetStateModel));
        expect(stateAfter.pressed, false);
      }

      testWidgets('should update pressed state during tap', (tester) async {
        await testPressedState(
          tester,
          enabled: true,
          expectedPressedDuringTap: true,
        );
      });

      testWidgets('should not update pressed state during tap when disabled',
          (tester) async {
        await testPressedState(
          tester,
          enabled: false,
          expectedPressedDuringTap: false,
        );
      });

      Future<void> testHoverState(
        WidgetTester tester, {
        required bool enabled,
        required bool expectedHovered,
      }) async {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;

        final radio1 = RxRadio<String>(
          enabled: enabled,
          value: 'value1',
          label: 'Option 1',
        );

        final radio2 = RxRadio<String>(
          enabled: enabled,
          value: 'value2',
          label: 'Option 2',
        );

        await tester.pumpRxWidget(
          RxRadioGroup<String>(
            value: 'value1',
            onChanged: (value) {},
            child: Column(
              children: [
                radio1,
                radio2,
              ],
            ),
          ),
        );

        final gesture =
            await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer();
        await gesture.moveTo(tester.getCenter(find.byWidget(radio1)));

        await tester.pumpAndSettle();

        final state1 = tester
            .widgetList<MixWidgetStateModel>(find.byType(MixWidgetStateModel))
            .first;
        expect(state1.hovered, expectedHovered);

        final state2 = tester
            .widgetList<MixWidgetStateModel>(find.byType(MixWidgetStateModel))
            .last;
        expect(state2.hovered, false);

        await gesture.removePointer();
        await tester.pumpAndSettle();

        final stateAfter1 = tester
            .widgetList<MixWidgetStateModel>(find.byType(MixWidgetStateModel))
            .first;
        expect(stateAfter1.hovered, false);

        final stateAfter2 = tester
            .widgetList<MixWidgetStateModel>(find.byType(MixWidgetStateModel))
            .last;
        expect(stateAfter2.hovered, false);
      }

      testWidgets('should update hovered state during hover', (tester) async {
        await testHoverState(
          tester,
          enabled: true,
          expectedHovered: true,
        );
      });

      testWidgets('should not update hovered state during hover when disabled',
          (tester) async {
        await testHoverState(
          tester,
          enabled: false,
          expectedHovered: false,
        );
      });

      Future<void> testFocusState(
        WidgetTester tester, {
        required bool enabled,
        required bool expectedFocused,
      }) async {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;

        final focusNode1 = FocusNode();
        final focusNode2 = FocusNode();

        // Test first radio
        await tester.pumpRxWidget(
          RxRadioGroup<String>(
            value: null,
            onChanged: (_) {},
            child: Column(
              children: [
                RxRadio(
                  label: 'Option 1',
                  value: 'option1',
                  enabled: enabled,
                  focusNode: focusNode1,
                ),
                RxRadio(
                  label: 'Option 2',
                  value: 'option2',
                  enabled: enabled,
                  focusNode: focusNode2,
                ),
              ],
            ),
          ),
        );

        focusNode1.requestFocus();
        await tester.pumpAndSettle();

        final state1 = tester
            .widgetList<MixWidgetStateModel>(find.byType(MixWidgetStateModel))
            .first;
        expect(state1.focused, expectedFocused);

        final state2 = tester
            .widgetList<MixWidgetStateModel>(find.byType(MixWidgetStateModel))
            .last;
        expect(state2.focused, false);

        focusNode1.unfocus();
        await tester.pumpAndSettle();

        final stateAfter1 = tester
            .widgetList<MixWidgetStateModel>(find.byType(MixWidgetStateModel))
            .first;
        expect(stateAfter1.focused, false);

        final stateAfter2 = tester
            .widgetList<MixWidgetStateModel>(find.byType(MixWidgetStateModel))
            .last;
        expect(stateAfter2.focused, false);
      }

      testWidgets('should update focused state during focus', (tester) async {
        await testFocusState(
          tester,
          enabled: true,
          expectedFocused: true,
        );
      });

      testWidgets('should not update focused state during focus when disabled',
          (tester) async {
        await testFocusState(
          tester,
          enabled: false,
          expectedFocused: false,
        );
      });
    });
  });
}
