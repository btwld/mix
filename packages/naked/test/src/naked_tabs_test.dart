import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked/naked.dart';

import 'helpers/simulate_hover.dart';

extension _WidgetTesterX on WidgetTester {
  SemanticsNode getSemanticsNode({required Type of, required Type matching}) {
    return getSemantics(
      find
          .descendant(
            of: find.byType(of),
            matching: find.byType(matching),
          )
          .first,
    );
  }
}

class _Counter extends StatefulWidget {
  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Count: $_count'),
        ElevatedButton(
          onPressed: _increment,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}

void main() {
  group('Basic Functionality', () {
    testWidgets('renders child widgets', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        const NakedTabGroup(
          selectedTabId: 'tab1',
          child: Column(
            children: [
              NakedTabList(
                child: Row(
                  children: [
                    NakedTab(
                      tabId: 'tab1',
                      child: Text('Tab 1'),
                    ),
                  ],
                ),
              ),
              NakedTabPanel(
                tabId: 'tab1',
                child: Text('Panel 1'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Panel 1'), findsOneWidget);
    });

    testWidgets('shows selected tab panel', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        const NakedTabGroup(
          selectedTabId: 'tab2',
          child: Column(
            children: [
              NakedTabList(
                child: Row(
                  children: [
                    NakedTab(
                      tabId: 'tab1',
                      child: Text('Tab 1'),
                    ),
                    NakedTab(
                      tabId: 'tab2',
                      child: Text('Tab 2'),
                    ),
                  ],
                ),
              ),
              NakedTabPanel(
                tabId: 'tab1',
                child: Text('Panel 1'),
              ),
              NakedTabPanel(
                tabId: 'tab2',
                child: Text('Panel 2'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('Panel 1'), findsNothing);
      expect(find.text('Panel 2'), findsOneWidget);
    });

    testWidgets('changes selected tab on tap', (WidgetTester tester) async {
      String selectedTabId = 'tab1';
      await tester.pumpMaterialWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return NakedTabGroup(
              selectedTabId: selectedTabId,
              onSelectedTabIdChanged: (id) =>
                  setState(() => selectedTabId = id),
              child: const Column(
                children: [
                  NakedTabList(
                    child: Row(
                      children: [
                        NakedTab(
                          tabId: 'tab1',
                          child: Text('Tab 1'),
                        ),
                        NakedTab(
                          tabId: 'tab2',
                          child: Text('Tab 2'),
                        ),
                      ],
                    ),
                  ),
                  NakedTabPanel(
                    tabId: 'tab1',
                    child: Text('Panel 1'),
                  ),
                  NakedTabPanel(
                    tabId: 'tab2',
                    child: Text('Panel 2'),
                  ),
                ],
              ),
            );
          },
        ),
      );

      expect(find.text('Panel 1'), findsOneWidget);
      expect(find.text('Panel 2'), findsNothing);

      await tester.tap(find.text('Tab 2'));
      await tester.pump();

      expect(find.text('Panel 1'), findsNothing);
      expect(find.text('Panel 2'), findsOneWidget);
    });

    testWidgets('ignores tab selection when NakedTabs is disabled',
        (WidgetTester tester) async {
      String selectedTabId = 'tab1';
      await tester.pumpMaterialWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return NakedTabGroup(
              selectedTabId: selectedTabId,
              enabled: false,
              onSelectedTabIdChanged: (id) =>
                  setState(() => selectedTabId = id),
              child: const Column(
                children: [
                  NakedTabList(
                    child: Row(
                      children: [
                        NakedTab(
                          tabId: 'tab1',
                          child: Text('Tab 1'),
                        ),
                        NakedTab(
                          tabId: 'tab2',
                          child: Text('Tab 2'),
                        ),
                      ],
                    ),
                  ),
                  NakedTabPanel(
                    tabId: 'tab1',
                    child: Text('Panel 1'),
                  ),
                  NakedTabPanel(
                    tabId: 'tab2',
                    child: Text('Panel 2'),
                  ),
                ],
              ),
            );
          },
        ),
      );

      await tester.tap(find.text('Tab 2'));
      await tester.pump();

      expect(find.text('Panel 1'), findsOneWidget);
      expect(find.text('Panel 2'), findsNothing);
    });

    testWidgets('ignores tab selection when individual tab is disabled',
        (WidgetTester tester) async {
      String selectedTabId = 'tab1';
      await tester.pumpMaterialWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return NakedTabGroup(
              selectedTabId: selectedTabId,
              onSelectedTabIdChanged: (id) =>
                  setState(() => selectedTabId = id),
              child: const Column(
                children: [
                  NakedTabList(
                    child: Row(
                      children: [
                        NakedTab(
                          tabId: 'tab1',
                          child: Text('Tab 1'),
                        ),
                        NakedTab(
                          tabId: 'tab2',
                          enabled: false,
                          child: Text('Tab 2'),
                        ),
                        NakedTab(
                          tabId: 'tab3',
                          child: Text('Tab 3'),
                        ),
                      ],
                    ),
                  ),
                  NakedTabPanel(
                    tabId: 'tab1',
                    child: Text('Panel 1'),
                  ),
                  NakedTabPanel(
                    tabId: 'tab2',
                    child: Text('Panel 2'),
                  ),
                  NakedTabPanel(
                    tabId: 'tab3',
                    child: Text('Panel 3'),
                  ),
                ],
              ),
            );
          },
        ),
      );

      expect(find.text('Panel 1'), findsOneWidget);
      expect(find.text('Panel 2'), findsNothing);
      expect(find.text('Panel 3'), findsNothing);

      await tester.tap(find.text('Tab 2'));
      await tester.pump();

      expect(find.text('Panel 1'), findsOneWidget);
      expect(find.text('Panel 2'), findsNothing);
      expect(find.text('Panel 3'), findsNothing);

      await tester.tap(find.text('Tab 3'));
      await tester.pump();

      expect(find.text('Panel 1'), findsNothing);
      expect(find.text('Panel 2'), findsNothing);
      expect(find.text('Panel 3'), findsOneWidget);
    });
  });

  group('State Callbacks', () {
    testWidgets('calls onHoverState when hovered', (WidgetTester tester) async {
      bool isHovered = false;
      final key = GlobalKey();
      await tester.pumpMaterialWidget(
        Padding(
          padding: const EdgeInsets.all(1),
          child: NakedTabGroup(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                NakedTabList(
                  child: Row(
                    children: [
                      NakedTab(
                        key: key,
                        tabId: 'tab1',
                        onHoverState: (value) => isHovered = value,
                        child: const Text('Tab 1'),
                      ),
                    ],
                  ),
                ),
                const NakedTabPanel(
                  tabId: 'tab1',
                  child: Text('Panel 1'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.simulateHover(key, onHover: () {
        expect(isHovered, true);
      });

      expect(isHovered, false);
    });

    testWidgets('calls onPressedState on tap down/up',
        (WidgetTester tester) async {
      bool isPressed = false;
      await tester.pumpMaterialWidget(
        NakedTabGroup(
          selectedTabId: 'tab1',
          child: Column(
            children: [
              NakedTabList(
                child: Row(
                  children: [
                    NakedTab(
                      tabId: 'tab1',
                      onPressedState: (value) => isPressed = value,
                      child: const Text('Tab 1'),
                    ),
                  ],
                ),
              ),
              const NakedTabPanel(
                tabId: 'tab1',
                child: Text('Panel 1'),
              ),
            ],
          ),
        ),
      );

      final gesture = await tester.press(find.byType(NakedTab));
      await tester.pump();
      expect(isPressed, true);

      await gesture.up();
      await tester.pump();
      expect(isPressed, false);
    });

    testWidgets('calls onFocusState when focused/unfocused',
        (WidgetTester tester) async {
      bool isFocused = false;
      final focusNode = FocusNode();

      await tester.pumpMaterialWidget(
        NakedTabGroup(
          selectedTabId: 'tab1',
          child: Column(
            children: [
              NakedTabList(
                child: Row(
                  children: [
                    NakedTab(
                      tabId: 'tab1',
                      focusNode: focusNode,
                      onFocusState: (value) => isFocused = value,
                      child: const Text('Tab 1'),
                    ),
                  ],
                ),
              ),
              const NakedTabPanel(
                tabId: 'tab1',
                child: Text('Panel 1'),
              ),
            ],
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      expect(isFocused, true);

      focusNode.unfocus();
      await tester.pump();
      expect(isFocused, false);
    });
  });

  group('Keyboard Interaction', () {
    testWidgets('activates tab with Space key', (WidgetTester tester) async {
      String selectedTabId = 'tab1';
      final focusNode = FocusNode();

      await tester.pumpMaterialWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return NakedTabGroup(
              selectedTabId: selectedTabId,
              onSelectedTabIdChanged: (id) =>
                  setState(() => selectedTabId = id),
              child: Column(
                children: [
                  NakedTabList(
                    child: Row(
                      children: [
                        const NakedTab(
                          tabId: 'tab1',
                          child: Text('Tab 1'),
                        ),
                        NakedTab(
                          tabId: 'tab2',
                          focusNode: focusNode,
                          child: const Text('Tab 2'),
                        ),
                      ],
                    ),
                  ),
                  const NakedTabPanel(
                    tabId: 'tab1',
                    child: Text('Panel 1'),
                  ),
                  const NakedTabPanel(
                    tabId: 'tab2',
                    child: Text('Panel 2'),
                  ),
                ],
              ),
            );
          },
        ),
      );

      focusNode.requestFocus();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(selectedTabId, 'tab2');
    });

    testWidgets('navigates tabs with arrow keys in horizontal orientation',
        (WidgetTester tester) async {
      String selectedTabId = 'tab1';
      await tester.pumpMaterialWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return NakedTabGroup(
              selectedTabId: selectedTabId,
              onSelectedTabIdChanged: (id) =>
                  setState(() => selectedTabId = id),
              child: const Column(
                children: [
                  NakedTabList(
                    child: Row(
                      children: [
                        NakedTab(
                          tabId: 'tab1',
                          child: Text('Tab 1'),
                        ),
                        NakedTab(
                          tabId: 'tab2',
                          child: Text('Tab 2'),
                        ),
                        NakedTab(
                          tabId: 'tab3',
                          child: Text('Tab 3'),
                        ),
                      ],
                    ),
                  ),
                  NakedTabPanel(
                    tabId: 'tab1',
                    child: Text('Panel 1'),
                  ),
                  NakedTabPanel(
                    tabId: 'tab2',
                    child: Text('Panel 2'),
                  ),
                  NakedTabPanel(
                    tabId: 'tab3',
                    child: Text('Panel 3'),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Focus the component
      await tester.tap(find.text('Tab 1'));
      await tester.pump();

      // Navigate to next tab with right arrow
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(selectedTabId, 'tab2');

      // Navigate to next tab with right arrow
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(selectedTabId, 'tab3');

      // Navigate to first tab with left arrow from last tab
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(selectedTabId, 'tab2');
    });

    testWidgets(
        'navigates tabs with arrow keys in horizontal orientation with MaterialApp',
        (WidgetTester tester) async {
      String selectedTabId = 'tab1';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return NakedTabGroup(
                  selectedTabId: selectedTabId,
                  onSelectedTabIdChanged: (id) =>
                      setState(() => selectedTabId = id),
                  child: const Column(
                    children: [
                      NakedTabList(
                        child: Row(
                          children: [
                            NakedTab(
                              tabId: 'tab1',
                              child: Text('Tab 1'),
                            ),
                            NakedTab(
                              tabId: 'tab2',
                              child: Text('Tab 2'),
                            ),
                            NakedTab(
                              tabId: 'tab3',
                              child: Text('Tab 3'),
                            ),
                          ],
                        ),
                      ),
                      NakedTabPanel(
                        tabId: 'tab1',
                        child: Text('Panel 1'),
                      ),
                      NakedTabPanel(
                        tabId: 'tab2',
                        child: Text('Panel 2'),
                      ),
                      NakedTabPanel(
                        tabId: 'tab3',
                        child: Text('Panel 3'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Focus the component
      await tester.tap(find.text('Tab 1'));
      await tester.pump();

      // Navigate to next tab with right arrow
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(selectedTabId, 'tab2');

      // Navigate to next tab with right arrow
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(selectedTabId, 'tab3');

      // Navigate to first tab with left arrow from last tab
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(selectedTabId, 'tab2');
    });
  });

  group('Accessibility', () {
    testWidgets('provides correct semantics for tab list',
        (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        const NakedTabGroup(
          selectedTabId: 'tab1',
          child: Column(
            children: [
              NakedTabList(
                semanticLabel: 'Custom Tab List',
                child: Row(
                  children: [
                    NakedTab(
                      tabId: 'tab1',
                      child: Text('Tab 1'),
                    ),
                  ],
                ),
              ),
              NakedTabPanel(
                tabId: 'tab1',
                child: Text('Panel 1'),
              ),
            ],
          ),
        ),
      );

      final semantics = tester.getSemanticsNode(
        of: NakedTabList,
        matching: Semantics,
      );
      expect(semantics.label, 'Custom Tab List');
    });

    testWidgets('provides correct semantics for tab',
        (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        const NakedTabGroup(
          selectedTabId: 'tab1',
          child: Column(
            children: [
              NakedTabList(
                child: Row(
                  children: [
                    NakedTab(
                      tabId: 'tab1',
                      semanticLabel: 'Custom Tab',
                      child: Text('Tab 1'),
                    ),
                  ],
                ),
              ),
              NakedTabPanel(
                tabId: 'tab1',
                child: Text('Panel 1'),
              ),
            ],
          ),
        ),
      );

      final semantics = tester.getSemanticsNode(
        of: NakedTab,
        matching: Semantics,
      );
      expect(semantics.label, 'Custom Tab');
      expect(semantics.hasFlag(SemanticsFlag.isSelected), true);
    });

    testWidgets('provides selected state for selected tab',
        (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        const NakedTabGroup(
          selectedTabId: 'tab1',
          child: Column(
            children: [
              NakedTabList(
                child: Row(
                  children: [
                    NakedTab(
                      tabId: 'tab1',
                      child: Text('Tab 1'),
                    ),
                    NakedTab(
                      tabId: 'tab2',
                      child: Text('Tab 2'),
                    ),
                  ],
                ),
              ),
              NakedTabPanel(
                tabId: 'tab1',
                child: Text('Panel 1'),
              ),
              NakedTabPanel(
                tabId: 'tab2',
                child: Text('Panel 2'),
              ),
            ],
          ),
        ),
      );

      final semantics2 = tester.getSemanticsNode(
        of: NakedTab,
        matching: Semantics,
      );
      expect(semantics2.hasFlag(SemanticsFlag.isSelected), true);
    });
  });

  group('Orientation', () {
    testWidgets('handles vertical orientation', (WidgetTester tester) async {
      String selectedTabId = 'tab1';
      await tester.pumpMaterialWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return NakedTabGroup(
              selectedTabId: selectedTabId,
              orientation: Axis.vertical,
              onSelectedTabIdChanged: (id) =>
                  setState(() => selectedTabId = id),
              child: const Row(
                children: [
                  NakedTabList(
                    child: Column(
                      children: [
                        NakedTab(
                          tabId: 'tab1',
                          child: Text('Tab 1'),
                        ),
                        NakedTab(
                          tabId: 'tab2',
                          child: Text('Tab 2'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        NakedTabPanel(
                          tabId: 'tab1',
                          child: Text('Panel 1'),
                        ),
                        NakedTabPanel(
                          tabId: 'tab2',
                          child: Text('Panel 2'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Navigate with vertical arrow keys
      await tester.tap(find.text('Tab 1'));
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(selectedTabId, 'tab2');

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(selectedTabId, 'tab1');
    });
  });

  group('Panel Behavior', () {
    testWidgets('maintains state based on maintainState value',
        (WidgetTester tester) async {
      String selectedTabId = 'tab1';

      for (final conditions in [
        (maintainState: true, expectedCount: 2),
        (maintainState: false, expectedCount: 1),
      ]) {
        await tester.pumpMaterialWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return NakedTabGroup(
                    selectedTabId: selectedTabId,
                    onSelectedTabIdChanged: (id) =>
                        setState(() => selectedTabId = id),
                    child: Column(
                      children: [
                        const NakedTabList(
                          child: Row(
                            children: [
                              NakedTab(
                                tabId: 'tab1',
                                child: Text('Tab 1'),
                              ),
                              NakedTab(
                                tabId: 'tab2',
                                child: Text('Tab 2'),
                              ),
                            ],
                          ),
                        ),
                        const NakedTabPanel(
                          tabId: 'tab1',
                          child: Text('Panel 1'),
                        ),
                        NakedTabPanel(
                          tabId: 'tab2',
                          maintainState: conditions.maintainState,
                          child: _Counter(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );

        _CounterState getCounterState() {
          return tester.state<_CounterState>(find.byType(_Counter));
        }

        await tester.tap(find.text('Tab 2'));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();
        expect(getCounterState()._count, 1);

        await tester.tap(find.text('Tab 1'));
        await tester.pump();

        await tester.tap(find.text('Tab 2'));
        await tester.pump();

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(getCounterState()._count, conditions.expectedCount);
      }
    });
  });

  group('Cursor', () {
    testWidgets('shows appropriate cursor based on interactive state',
        (WidgetTester tester) async {
      final key = GlobalKey();
      final disabledKey = GlobalKey();

      await tester.pumpMaterialWidget(
        NakedTabGroup(
          selectedTabId: 'tab1',
          child: Column(
            children: [
              NakedTabList(
                child: Row(
                  children: [
                    NakedTab(
                      key: key,
                      tabId: 'tab1',
                      child: const Text('Enabled Tab'),
                    ),
                    NakedTab(
                      key: disabledKey,
                      tabId: 'tab2',
                      enabled: false,
                      child: const Text('Disabled Tab'),
                    ),
                  ],
                ),
              ),
              const NakedTabPanel(
                tabId: 'tab1',
                child: Text('Panel 1'),
              ),
            ],
          ),
        ),
      );

      tester.expectCursor(
        SystemMouseCursors.click,
        on: key,
      );

      tester.expectCursor(
        SystemMouseCursors.forbidden,
        on: disabledKey,
      );
    });
  });
}
