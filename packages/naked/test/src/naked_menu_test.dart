import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked/naked.dart';

import 'helpers/simulate_hover.dart';

extension _NakedMenuTester on WidgetTester {
  Future<void> pressEsc() async {
    await sendKeyEvent(LogicalKeyboardKey.escape);
    await pumpAndSettle();
  }

  Future<void> tapOutsideMenu() async {
    await tapAt(const Offset(10, 10));
    await pump();
  }
}

void main() {
  group('NakedMenu', () {
    group('Basic Functionality', () {
      NakedMenu buildBasicMenu(OverlayPortalController controller) {
        return NakedMenu(
          controller: controller,
          overlayBuilder: (_) => const Text('Menu Content'),
          builder: (_) => const Text('child'),
        );
      }

      testWidgets('Renders child widget', (WidgetTester tester) async {
        final controller = OverlayPortalController();
        await tester.pumpMaterialWidget(
          buildBasicMenu(controller),
        );

        expect(find.text('child'), findsOneWidget);
        expect(find.text('Menu Content'), findsNothing);
      });

      testWidgets('Renders menu content when open',
          (WidgetTester tester) async {
        final controller = OverlayPortalController();
        await tester.pumpMaterialWidget(
          buildBasicMenu(controller),
        );
        controller.show();
        await tester.pump();

        expect(find.text('child'), findsOneWidget);
        expect(find.text('Menu Content'), findsOneWidget);
      });

      testWidgets('Opens when controller.show() is called',
          (WidgetTester tester) async {
        final controller = OverlayPortalController();

        await tester.pumpMaterialWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  NakedButton(
                    onPressed: () => controller.show(),
                    child: const Text('Open Menu'),
                  ),
                  NakedMenu(
                    controller: controller,
                    overlayBuilder: (_) => const Text('Menu Content'),
                    builder: (_) => const Text('child'),
                  ),
                ],
              );
            },
          ),
        );

        expect(find.text('Menu Content'), findsNothing);
        await tester.tap(find.text('Open Menu'));
        await tester.pumpAndSettle();
        expect(find.text('Menu Content'), findsOneWidget);
      });

      testWidgets('Places menu according to menuAlignment parameter',
          (WidgetTester tester) async {
        final controller = OverlayPortalController();
        const trigger = Key('trigger');
        const menu = Key('menu');
        await tester.pumpMaterialWidget(
          Center(
            child: NakedMenu(
              controller: controller,
              menuAlignment: const PositionConfig(
                target: Alignment.bottomCenter,
                follower: Alignment.topCenter,
                offset: Offset.zero,
              ),
              overlayBuilder: (_) => const SizedBox(
                key: menu,
                width: 200,
                height: 100,
                child: Center(child: Text('Menu Content')),
              ),
              builder: (_) => Container(
                key: trigger,
                width: 100,
                height: 40,
                color: Colors.blue,
                child: const Center(child: Text('child')),
              ),
            ),
          ),
        );

        controller.show();

        await tester.pump();
        expect(find.byType(NakedMenu), findsOneWidget);
        expect(find.byKey(menu), findsOneWidget);

        // Get the positions of the trigger and menu
        final triggerBottomLeft = tester.getBottomLeft(find.byKey(trigger));
        final menuTopLeft = tester.getTopLeft(find.byKey(menu));

        // Menu should be centered above the trigger with 4px gap
        expect(menuTopLeft.dy, triggerBottomLeft.dy);

        // Get the positions of the trigger and menu
        final triggerCenter = tester.getCenter(find.byKey(trigger));
        final menuCenter = tester.getCenter(find.byKey(menu));

        expect(menuCenter.dx, triggerCenter.dx);
      });
    });

    group('State Management', () {
      testWidgets('calls onMenuClose when Escape key pressed',
          (WidgetTester tester) async {
        bool onMenuCloseCalled = false;

        final controller = OverlayPortalController();
        await tester.pumpMaterialWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return NakedMenu(
                onClose: () => onMenuCloseCalled = true,
                controller: controller,
                overlayBuilder: (_) => const Text('Menu Content'),
                builder: (_) => const Text('child'),
              );
            },
          ),
        );
        controller.show();

        await tester.pumpAndSettle();
        expect(find.text('Menu Content'), findsOneWidget);

        await tester.pressEsc();
        await tester.pumpAndSettle();
        expect(onMenuCloseCalled, true);
      });

      testWidgets(
          'calls onMenuClose when menu item selected (if closeOnSelect is true)',
          (WidgetTester tester) async {
        bool onMenuCloseCalled = false;
        const menuKey = Key('menu');
        const item1Key = Key('item1');
        final controller = OverlayPortalController();

        await tester.pumpMaterialWidget(
          NakedMenu(
            controller: controller,
            closeOnSelect: true,
            onClose: () => onMenuCloseCalled = true,
            overlayBuilder: (_) => Container(
              key: menuKey,
              constraints: const BoxConstraints(maxWidth: 100, maxHeight: 100),
              child: NakedMenuItem(
                key: item1Key,
                onPressed: () {},
                child: const Text('Item 1'),
              ),
            ),
            builder: (_) => const Text('child'),
          ),
        );

        controller.show();

        await tester.pump();
        expect(find.byKey(menuKey), findsOneWidget);

        await tester.tap(find.text('Item 1'));
        await tester.pumpAndSettle();

        expect(onMenuCloseCalled, true);
      });
    });

    group('Keyboard Interaction', () {
      testWidgets('Traps focus within menu when opens',
          (WidgetTester tester) async {
        bool item1Focused = false;
        bool item2Focused = false;
        final controller = OverlayPortalController();
        await tester.pumpMaterialWidget(
          Center(
            child: NakedMenu(
              controller: controller,
              overlayBuilder: (_) => Column(
                children: [
                  NakedMenuItem(
                    onPressed: () {},
                    onFocusState: (value) {
                      item1Focused = value;
                    },
                    child: const Text('Item 1'),
                  ),
                  NakedMenuItem(
                    onPressed: () {},
                    onFocusState: (value) {
                      item2Focused = value;
                    },
                    child: const Text('Item 2'),
                  ),
                ],
              ),
              builder: (_) => const Text('child'),
            ),
          ),
        );

        controller.show();

        await tester.pump();
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();

        expect(item1Focused, true);
        expect(item2Focused, false);

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();

        expect(item1Focused, false);
        expect(item2Focused, true);
      });
    });

    // group('Accessibility', () {
    //   testWidgets('Provides semantic labels when provided',
    //       (WidgetTester tester) async {
    //     await tester.pumpMenu(
    //       const NakedMenu(
    //         semanticLabel: 'Test Menu',
    //         menu: NakedMenuContent(
    //           child: Text('Menu Content'),
    //         ),
    //         child: Text('child'),
    //       ),
    //     );

    //     expect(
    //       tester.getSemantics(find.byType(Semantics).first),
    //       matchesSemantics(label: 'Test Menu'),
    //     );
    //   });
    // });
  });

  group('NakedMenuContent', () {
    testWidgets('Renders child widget(s)', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        const Text('Menu Content'),
      );

      expect(find.text('Menu Content'), findsOneWidget);
    });

    testWidgets(
        'calls onMenuClose when clicking outside (if consumeOutsideTaps is true)',
        (WidgetTester tester) async {
      bool onMenuCloseCalled = false;

      final controller = OverlayPortalController();

      await tester.pumpMaterialWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {},
                    child: const SizedBox(
                      width: 50,
                      height: 50,
                      child: ColoredBox(color: Colors.red),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 100,
                  child: NakedMenu(
                    controller: controller,
                    onClose: () => onMenuCloseCalled = true,
                    consumeOutsideTaps: true,
                    overlayBuilder: (_) => const SizedBox(
                      width: 100,
                      height: 50,
                      child: Center(child: Text('Menu Content')),
                    ),
                    builder: (_) => const Text('child'),
                  ),
                ),
              ],
            );
          },
        ),
      );
      controller.show();

      await tester.pump();
      expect(find.text('Menu Content'), findsOneWidget);

      // Tap outside the menu
      await tester.tapOutsideMenu();
      expect(onMenuCloseCalled, true);
    });
  });

  group('NakedMenuItem', () {
    group('Basic Functionality', () {
      testWidgets('Renders child widget', (WidgetTester tester) async {
        await tester.pumpMaterialWidget(
          const NakedMenuItem(
            child: Text('Menu Item'),
          ),
        );

        expect(find.text('Menu Item'), findsOneWidget);
      });

      testWidgets('Handles tap/click when enabled',
          (WidgetTester tester) async {
        bool pressed = false;

        await tester.pumpMaterialWidget(
          NakedMenuItem(
            onPressed: () => pressed = true,
            child: const Text('Menu Item'),
          ),
        );

        await tester.tap(find.text('Menu Item'));
        expect(pressed, true);
      });

      testWidgets('Does not respond when disabled',
          (WidgetTester tester) async {
        bool pressed = false;

        await tester.pumpMaterialWidget(
          NakedMenuItem(
            enabled: false,
            onPressed: () => pressed = true,
            child: const Text('Menu Item'),
          ),
        );

        await tester.tap(find.text('Menu Item'));
        expect(pressed, false);
      });
    });

    group('State Callbacks', () {
      testWidgets('Calls hover state callback', (WidgetTester tester) async {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;
        bool hovered = false;
        const key = Key('menuItem');
        await tester.pumpMaterialWidget(
          Padding(
            padding: const EdgeInsets.all(1),
            child: NakedMenuItem(
              key: key,
              onPressed: () {},
              onHoverState: (value) => hovered = value,
              child: const Text(
                'Menu Item',
              ),
            ),
          ),
        );

        await tester.simulateHover(key, onHover: () {
          expect(hovered, true);
        });
        expect(hovered, false);
      });

      testWidgets('Calls pressed state callback', (WidgetTester tester) async {
        bool pressed = false;
        const key = Key('menuItem');
        await tester.pumpMaterialWidget(
          NakedMenuItem(
            key: key,
            onPressed: () {},
            onPressedState: (value) => pressed = value,
            child: const Text('Menu Item'),
          ),
        );

        await tester.simulatePress(key, onPressed: () {
          expect(pressed, true);
        });
        expect(pressed, false);
      });

      testWidgets('Calls focus state callback', (WidgetTester tester) async {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;
        bool focused = false;
        final focusNode = FocusNode();

        await tester.pumpMaterialWidget(
          NakedMenuItem(
            onPressed: () {},
            focusNode: focusNode,
            onFocusState: (value) => focused = value,
            child: const Text('Menu Item'),
          ),
        );
        expect(focused, false);

        focusNode.requestFocus();
        await tester.pumpAndSettle();
        expect(focused, true);
      });
    });

    group('Keyboard Interaction', () {
      testWidgets('Activates with Space and Enter keys',
          (WidgetTester tester) async {
        bool pressed = false;

        final focusNode = FocusNode();

        await tester.pumpMaterialWidget(
          NakedMenuItem(
            focusNode: focusNode,
            onPressed: () => pressed = true,
            child: const Text('Menu Item'),
          ),
        );

        // Focus the item
        focusNode.requestFocus();
        await tester.pump();

        // Test space key
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pump();
        expect(pressed, true);

        // Reset and test enter key
        pressed = false;
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();
        expect(pressed, true);

        // Cleanup
        focusNode.dispose();
      });
    });
  });
}
