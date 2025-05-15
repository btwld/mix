import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked/naked.dart';

// Test extensions for NakedMenu
extension _NakedMenuFinders on CommonFinders {
  Finder nakedMenuContent() => byType(_NakedMenuContent);
  Finder nakedMenuItem() => byType(NakedMenuItem);
  Finder nakedMenuItemWithText(String text) =>
      find.descendant(of: nakedMenuItem(), matching: find.text(text));
}

// Test extensions for WidgetTester to interact with NakedMenu
extension _NakedMenuTester on WidgetTester {
  Future<void> pumpMenu(Widget widget) async {
    await pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp(
        home: Scaffold(
          body: widget,
        ),
      ),
    ));
  }

  Future<void> pressEsc() async {
    await sendKeyEvent(LogicalKeyboardKey.escape);
    await pumpAndSettle();
  }

  Future<TestGesture> hoverMenuItem(String text) async {
    final gesture = await createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    await pump();
    await gesture.moveTo(getCenter(find.nakedMenuItemWithText(text)));
    await pump();

    return gesture;
  }

  Future<void> tapOutsideMenu() async {
    await tapAt(const Offset(10, 10));
    await pump();
  }
}

// Helper for verifying states
extension _NakedMenuMatcher on WidgetTester {
  bool isMenuOpen() => any(find.nakedMenuContent());

  // bool isMenuClosed() => !any(find.nakedMenuContent());
}

void main() {
  group('NakedMenu', () {
    group('Basic Functionality', () {
      NakedMenu buildBasicMenu(OverlayPortalController controller) {
        return NakedMenu(
          controller: controller,
          overlayBuilder: (_) => const _NakedMenuContent(
            child: Text('Menu Content'),
          ),
          builder: (_) => const Text('child'),
        );
      }

      testWidgets('Renders child widget', (WidgetTester tester) async {
        final controller = OverlayPortalController();
        await tester.pumpMenu(
          buildBasicMenu(controller),
        );

        expect(find.text('child'), findsOneWidget);
        expect(find.text('Menu Content'), findsNothing);
      });

      testWidgets('Renders menu content when open',
          (WidgetTester tester) async {
        final controller = OverlayPortalController();
        await tester.pumpMenu(
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

        await tester.pumpMenu(
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
                    overlayBuilder: (_) => const _NakedMenuContent(
                      child: Text('Menu Content'),
                    ),
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

      testWidgets('Closes when open property is false',
          (WidgetTester tester) async {
        final controller = OverlayPortalController();
        await tester.pumpMenu(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  NakedButton(
                    onPressed: () => controller.hide(),
                    child: const Text('Close Menu'),
                  ),
                  NakedMenu(
                    controller: controller,
                    overlayBuilder: (_) => const _NakedMenuContent(
                      child: Text('Menu Content'),
                    ),
                    builder: (_) => const Text('child'),
                  ),
                ],
              );
            },
          ),
        );
        controller.show();
        await tester.pump();
        expect(find.text('Menu Content'), findsOneWidget);
        await tester.tap(find.text('Close Menu'));
        await tester.pumpAndSettle();
        expect(find.text('Menu Content'), findsNothing);
      });

      testWidgets('Places menu according to menuAlignment parameter',
          (WidgetTester tester) async {
        final controller = OverlayPortalController();
        const trigger = Key('trigger');
        await tester.pumpMenu(
          Center(
            child: NakedMenu(
              controller: controller,
              menuAlignment: const PositionConfig(
                target: Alignment.bottomCenter,
                follower: Alignment.topCenter,
                offset: Offset.zero,
              ),
              overlayBuilder: (_) => const _NakedMenuContent(
                child: SizedBox(
                  width: 200,
                  height: 100,
                  child: Center(child: Text('Menu Content')),
                ),
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
        expect(find.byType(_NakedMenuContent), findsOneWidget);

        // Get the positions of the trigger and menu
        final triggerBottomLeft = tester.getBottomLeft(find.byKey(trigger));
        final menuTopLeft = tester.getTopLeft(find.byType(_NakedMenuContent));

        // Menu should be centered above the trigger with 4px gap
        expect(menuTopLeft.dy, triggerBottomLeft.dy);

        // Get the positions of the trigger and menu
        final triggerCenter = tester.getCenter(find.byKey(trigger));
        final menuCenter = tester.getCenter(find.byType(_NakedMenuContent));

        expect(menuCenter.dx, triggerCenter.dx);
      });
    });

    group('State Management', () {
      testWidgets('calls onMenuClose when Escape key pressed',
          (WidgetTester tester) async {
        bool onMenuCloseCalled = false;

        final controller = OverlayPortalController();
        await tester.pumpMenu(
          StatefulBuilder(
            builder: (context, setState) {
              return NakedMenu(
                onClose: () => onMenuCloseCalled = true,
                controller: controller,
                overlayBuilder: (_) => const _NakedMenuContent(
                  child: Text('Menu Content'),
                ),
                builder: (_) => const Text('child'),
              );
            },
          ),
        );
        controller.show();

        await tester.pumpAndSettle();
        expect(tester.isMenuOpen(), true);

        await tester.pressEsc();
        await tester.pumpAndSettle();
        expect(onMenuCloseCalled, true);
      });

      testWidgets(
          'calls onMenuClose when menu item selected (if closeOnSelect is true)',
          (WidgetTester tester) async {
        bool onMenuCloseCalled = false;
        final controller = OverlayPortalController();
        await tester.pumpMenu(
          StatefulBuilder(
            builder: (context, setState) {
              return NakedMenu(
                controller: controller,
                closeOnSelect: true,
                onClose: () => onMenuCloseCalled = true,
                overlayBuilder: (_) => _NakedMenuContent(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const NakedMenuItem(
                        child: Text('Item 1'),
                      ),
                      NakedMenuItem(
                        onPressed: () {},
                        child: const Text('Item 2'),
                      ),
                    ],
                  ),
                ),
                builder: (_) => const Text('child'),
              );
            },
          ),
        );

        controller.show();

        await tester.pump();
        expect(tester.isMenuOpen(), true);

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
        await tester.pumpMenu(
          Center(
            child: NakedMenu(
              controller: controller,
              overlayBuilder: (_) => _NakedMenuContent(
                child: Column(
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
      await tester.pumpMenu(
        const _NakedMenuContent(
          child: Text('Menu Content'),
        ),
      );

      expect(find.text('Menu Content'), findsOneWidget);
    });

    testWidgets(
        'calls onMenuClose when clicking outside (if consumeOutsideTaps is true)',
        (WidgetTester tester) async {
      bool onMenuCloseCalled = false;

      final controller = OverlayPortalController();

      await tester.pumpMenu(
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
                    overlayBuilder: (_) => const _NakedMenuContent(
                      consumeOutsideTaps: true,
                      child: SizedBox(
                        width: 100,
                        height: 50,
                        child: Center(child: Text('Menu Content')),
                      ),
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
      expect(tester.isMenuOpen(), true);

      // Tap outside the menu
      await tester.tapOutsideMenu();
      expect(onMenuCloseCalled, true);
    });
  });

  group('NakedMenuItem', () {
    group('Basic Functionality', () {
      testWidgets('Renders child widget', (WidgetTester tester) async {
        await tester.pumpMenu(
          const NakedMenuItem(
            child: Text('Menu Item'),
          ),
        );

        expect(find.text('Menu Item'), findsOneWidget);
      });

      testWidgets('Handles tap/click when enabled',
          (WidgetTester tester) async {
        bool pressed = false;

        await tester.pumpMenu(
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

        await tester.pumpMenu(
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
      testWidgets('Calls state callbacks appropriately',
          (WidgetTester tester) async {
        bool hovered = false;
        bool pressed = false;
        bool focused = false;

        await tester.pumpMenu(
          NakedMenuItem(
            onHoverState: (value) => hovered = value,
            onPressedState: (value) => pressed = value,
            onFocusState: (value) => focused = value,
            child: const Text('Menu Item'),
          ),
        );

        // Test hover
        final gesture = await tester.hoverMenuItem('Menu Item');
        expect(hovered, true);
        await gesture.removePointer();

        await tester.pump();
        expect(hovered, false);

        // Test pressed state
        final pressGesture = await tester.press(find.text('Menu Item'));
        expect(pressed, true);

        await pressGesture.removePointer();
        await tester.pumpAndSettle();
        expect(pressed, false);

        // Test focus state
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(focused, true);

        // Clean up
        await gesture.removePointer();
      });
    });

    group('Keyboard Interaction', () {
      testWidgets('Activates with Space and Enter keys',
          (WidgetTester tester) async {
        bool pressed = false;

        final focusNode = FocusNode();

        await tester.pumpMenu(
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
