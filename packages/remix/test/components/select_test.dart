import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../utils/interaction_tests.dart';

enum Options {
  banana,
  apple,
  orange,
}

void main() {
  group('RxSelect', () {
    group('Constructor', () {
      const label = 'Select an item';
      const selectedValue = Options.apple;
      final items = Options.values
          .map((e) => RxSelectItem(value: e, label: e.name))
          .toList();
      final style = RxSelectStyle();
      void onSelectedValueChanged(Options? value) {}

      testWidgets('should initialize with correct properties',
          (WidgetTester tester) async {
        final widget = RxSelect<Options>(
          selectedValue: selectedValue,
          onSelectedValueChanged: onSelectedValueChanged,
          items: items,
          style: style,
          child: const RxSelectTrigger(label: label),
        );

        await tester.pumpRxWidget(widget);

        expect(widget.selectedValue, selectedValue);
        expect(widget.items, items);
        expect(widget.style, style);
        expect(widget.onSelectedValueChanged, onSelectedValueChanged);

        expect(find.text(label), findsOneWidget);
      });
    });

    testWidgets('should display items when trigger is tapped',
        (WidgetTester tester) async {
      final items = Options.values
          .map((e) => RxSelectItem(value: e, label: e.name))
          .toList();

      await tester.pumpRxWidget(
        RxSelect<Options>(
          selectedValue: Options.banana,
          onSelectedValueChanged: (_) {},
          items: items,
          child: const RxSelectTrigger(label: 'Select an item'),
        ),
      );

      await tester.tap(find.text('Select an item'));
      await tester.pumpAndSettle();

      for (var option in Options.values) {
        expect(find.text(option.name), findsOneWidget);
      }
    });

    testWidgets(
        'should close or keep menu open based on closeOnSelect property when item is selected',
        (WidgetTester tester) async {
      for (final closeOnSelect in [true, false]) {
        final items = Options.values
            .map((e) => RxSelectItem(value: e, label: e.name))
            .toList();

        await tester.pumpRxWidget(
          RxSelect<Options>(
            selectedValue: Options.banana,
            closeOnSelect: closeOnSelect,
            onSelectedValueChanged: (_) {},
            items: items,
            child: const RxSelectTrigger(label: 'Select an item'),
          ),
        );

        // Open dropdown
        await tester.tap(find.text('Select an item'));
        await tester.pumpAndSettle();

        // Verify dropdown is open
        expect(find.text(Options.apple.name), findsOneWidget);
        expect(find.text(Options.orange.name), findsOneWidget);

        // Select an item
        await tester.tap(find.text(Options.apple.name));
        await tester.pumpAndSettle();

        // Verify dropdown behavior based on closeOnSelect
        if (closeOnSelect) {
          // Verify dropdown is closed
          expect(find.text(Options.apple.name), findsNothing);
          expect(find.text(Options.orange.name), findsNothing);
        } else {
          // Verify dropdown remains open
          expect(find.text(Options.apple.name), findsOneWidget);
          expect(find.text(Options.orange.name), findsOneWidget);
        }
      }
    });

    testWidgets('should call onSelectedValueChanged when item is selected',
        (WidgetTester tester) async {
      Options? selectedValue;
      final items = Options.values
          .map((e) => RxSelectItem(value: e, label: e.name))
          .toList();

      await tester.pumpRxWidget(
        RxSelect<Options>(
          selectedValue: selectedValue,
          onSelectedValueChanged: (value) {
            selectedValue = value;
          },
          items: items,
          child: const RxSelectTrigger(label: 'Select an item'),
        ),
      );

      // Open dropdown
      await tester.tap(find.text('Select an item'));
      await tester.pumpAndSettle();

      // Select an item
      await tester.tap(find.text(Options.apple.name));
      await tester.pumpAndSettle();

      // Verify onSelectedValueChanged was called with correct value
      expect(selectedValue, equals(Options.apple));
    });

    group('interactions', () {
      testHoverWidget('should handle hover state', () {
        return RxSelect<Options>(
          selectedValue: Options.apple,
          onSelectedValueChanged: (_) {},
          items: Options.values
              .map((e) => RxSelectItem(value: e, label: e.name))
              .toList(),
          child: const RxSelectTrigger(label: 'Select an item'),
        );
      }, shouldExpectHover: true);

      testHoverWidget('should not handle hover state when disabled', () {
        return RxSelect<Options>(
          enabled: false,
          selectedValue: Options.apple,
          onSelectedValueChanged: (_) {},
          items: Options.values
              .map((e) => RxSelectItem(value: e, label: e.name))
              .toList(),
          child: const RxSelectTrigger(label: 'Select an item'),
        );
      }, shouldExpectHover: false);

      testFocusWidget('should handle focus state when enabled', (focusNode) {
        return RxSelect<Options>(
          selectedValue: Options.apple,
          onSelectedValueChanged: (_) {},
          items: Options.values
              .map((e) => RxSelectItem(value: e, label: e.name))
              .toList(),
          style: RxSelectStyle(),
          child: RxSelectTrigger(label: 'Select an item', focusNode: focusNode),
        );
      }, shouldExpectFocus: true);

      testFocusWidget('should not handle focus state when disabled',
          (focusNode) {
        return RxSelect<Options>(
          enabled: false,
          selectedValue: Options.apple,
          onSelectedValueChanged: (_) {},
          items: Options.values
              .map((e) => RxSelectItem(value: e, label: e.name))
              .toList(),
          child: RxSelectTrigger(label: 'Select an item', focusNode: focusNode),
        );
      }, shouldExpectFocus: false);
    });
  });

  group('RxSelectTrigger', () {
    group('Constructor', () {
      const label = 'Select an item';
      const semanticLabel = 'Choose an option';
      const cursor = SystemMouseCursors.precise;
      const enableHapticFeedback = false;
      const trailingIcon = Icons.arrow_drop_down;

      testWidgets('should initialize with correct properties',
          (WidgetTester tester) async {
        final focusNode = FocusNode();
        final widget = RxSelectTrigger(
          label: label,
          semanticLabel: semanticLabel,
          cursor: cursor,
          enableHapticFeedback: enableHapticFeedback,
          focusNode: focusNode,
          trailingIcon: trailingIcon,
        );

        expect(widget.label, label);
        expect(widget.semanticLabel, semanticLabel);
        expect(widget.cursor, cursor);
        expect(widget.enableHapticFeedback, enableHapticFeedback);
        expect(widget.focusNode, focusNode);
        expect(widget.trailingIcon, trailingIcon);
      });

      testWidgets('should throw exception when used outside RxSelect',
          (WidgetTester tester) async {
        await tester.pumpRxWidget(
          const RxSelectTrigger(label: 'Select an item'),
        );

        expect(tester.takeException(), isException);
      });

      testWidgets(
          'should initialize with correct properties for raw constructor',
          (WidgetTester tester) async {
        final focusNode = FocusNode();

        final child =
            Container(color: Colors.red, child: const Text('Custom Child'));

        final widget = RxSelect(
          items: const [],
          child: RxSelectTrigger.raw(
            semanticLabel: semanticLabel,
            cursor: cursor,
            enableHapticFeedback: enableHapticFeedback,
            focusNode: focusNode,
            child: child,
          ),
        );

        await tester.pumpRxWidget(widget);

        expect(find.byWidget(child), findsOneWidget);
      });
    });

    group('Layout', () {
      testWidgets('should display label and icon in horizontal layout',
          (WidgetTester tester) async {
        await tester.pumpRxWidget(
          const RxSelect(
            items: [],
            child: RxSelectTrigger(label: 'Select an item'),
          ),
        );

        final triggerFinder = find.byType(RxSelectTrigger);
        expect(triggerFinder, findsOneWidget);

        // Verify the label is displayed
        expect(find.text('Select an item'), findsOneWidget);

        // Verify the default icon is displayed
        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });

      testWidgets('should display custom icon when provided',
          (WidgetTester tester) async {
        await tester.pumpRxWidget(
          const RxSelect(
            items: [],
            child: RxSelectTrigger(
              label: 'Select an item',
              trailingIcon: Icons.abc,
            ),
          ),
        );

        expect(find.byIcon(Icons.abc), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
      });
    });
  });

  group('RxSelectItem', () {
    group('Constructor', () {
      const value = Options.apple;
      const label = 'Apple';
      const trailingIcon = Icons.star;
      const semanticLabel = 'Select apple';
      const cursor = SystemMouseCursors.precise;
      const enableHapticFeedback = false;

      testWidgets('should initialize with correct properties',
          (WidgetTester tester) async {
        final focusNode = FocusNode();

        final widget = RxSelectItem<Options>(
          value: value,
          label: label,
          trailingIcon: trailingIcon,
          enabled: false,
          semanticLabel: semanticLabel,
          cursor: cursor,
          enableHapticFeedback: enableHapticFeedback,
          focusNode: focusNode,
        );

        expect(widget.value, value);
        expect(widget.label, label);
        expect(widget.trailingIcon, trailingIcon);
        expect(widget.enabled, false);
        expect(widget.semanticLabel, semanticLabel);
        expect(widget.cursor, cursor);
        expect(widget.enableHapticFeedback, enableHapticFeedback);
        expect(widget.focusNode, focusNode);
      });

      testWidgets('should throw exception when not wrapped by RxSelect',
          (WidgetTester tester) async {
        await tester.pumpRxWidget(
          const RxSelectItem<Options>(
            value: Options.apple,
            label: 'Apple',
          ),
        );

        expect(tester.takeException(), isException);
      });
    });

    group('Layout', () {
      testWidgets('should display label and icon', (WidgetTester tester) async {
        await tester.pumpRxWidget(
          const RxSelect<Options>(
            items: [
              RxSelectItem<Options>(
                value: Options.apple,
                label: 'Apple',
                trailingIcon: Icons.star,
              ),
            ],
            child: RxSelectTrigger(label: 'Select an item'),
          ),
        );

        await tester.tap(find.text('Select an item'));
        await tester.pumpAndSettle();

        final itemFinder = find.byType(RxSelectItem<Options>);
        expect(itemFinder, findsOneWidget);

        // Verify the label is displayed
        expect(find.text('Apple'), findsOneWidget);

        // Verify the default icon is displayed
        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('should display custom widget with raw constructor',
          (WidgetTester tester) async {
        await tester.pumpRxWidget(
          const RxSelect<Options>(
            items: [
              RxSelectItem<Options>.raw(
                value: Options.apple,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite, color: Colors.red),
                    SizedBox(width: 8),
                    Text('heart'),
                  ],
                ),
              ),
            ],
            child: RxSelectTrigger(label: 'Select an item'),
          ),
        );

        await tester.tap(find.text('Select an item'));
        await tester.pumpAndSettle();

        final itemFinder = find.byType(RxSelectItem<Options>);
        expect(itemFinder, findsOneWidget);

        // Verify the custom widget is displayed
        expect(find.text('heart'), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsOneWidget);

        // Verify default label and icon are not displayed
        expect(find.byIcon(Icons.check), findsNothing);
      });

      testWidgets('should display custom icon when provided',
          (WidgetTester tester) async {
        await tester.pumpRxWidget(
          const RxSelect<Options>(
            items: [
              RxSelectItem<Options>(
                value: Options.apple,
                label: 'Apple',
                trailingIcon: Icons.star,
              ),
            ],
            child: RxSelectTrigger(label: 'Select an item'),
          ),
        );

        await tester.tap(find.text('Select an item'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNothing);
      });
    });
  });
}
