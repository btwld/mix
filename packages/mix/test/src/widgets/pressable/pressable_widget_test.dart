import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Pressable', () {
    const attribute1 = MockIntScalarAttribute(1);
    const attribute2 = MockStringScalarAttribute('attribute2');
    const attribute3 = MockBooleanScalarAttribute(true);

    testWidgets('Pressable', (tester) async {
      final firstKey = UniqueKey();
      final secondKey = UniqueKey();
      final thirdKey = UniqueKey();
      await tester.pumpWidget(Column(
        children: [
          Pressable(
            onPress: null,
            enabled: false,
            child: Container(key: firstKey),
          ),
          Pressable(
            enabled: false,
            onPress: null,
            child: Container(key: secondKey),
          ),
          // Test with a onpress function
          Pressable(
            onPress: () {},
            enabled: true,
            child: Container(key: thirdKey),
          ),
        ],
      ));

      final onEnabledAttr = $on.enabled(attribute1, attribute2, attribute3);

      final firstContext = tester.element(find.byKey(firstKey));
      final secondContext = tester.element(find.byKey(secondKey));
      final thirdContext = tester.element(find.byKey(thirdKey));

      final firstNotifier = MixWidgetStateModel.of(firstContext);
      final secondNotifier = MixWidgetStateModel.of(secondContext);
      final thirdNotifier = MixWidgetStateModel.of(thirdContext);

      expect(onEnabledAttr.variant.when(firstContext), false,
          reason: 'First Pressable should be disabled');
      expect(firstNotifier!.disabled, true,
          reason: 'First Pressable should have disabled state');
      expect(onEnabledAttr.variant.when(secondContext), false,
          reason: 'Second Pressable should be disabled');
      expect(secondNotifier!.disabled, true,
          reason: 'Second Pressable should have disabled state');

      expect(onEnabledAttr.variant.when(thirdContext), true,
          reason: 'Third Pressable should be enabled');
      expect(thirdNotifier!.disabled, false,
          reason: 'Third Pressable should not have disabled state');
    });

    testWidgets('is disposing the controller correcly', (widgetTester) async {
      await widgetTester.pumpWidget(const _DisposalPressable());
    });

    testWidgets(
      'must be clickable when enabled is setted to true',
      (tester) async {
        int counter = 0;

        await tester.pumpWidget(
          Pressable(
            enabled: true,
            onPress: () {
              counter++;
            },
            child: Container(),
          ),
        );

        final pressableFinder = find.byType(Pressable);
        expect(pressableFinder, findsOneWidget);

        await tester.tap(pressableFinder);
        await tester.pumpAndSettle(const Duration(milliseconds: 200));

        expect(counter, 1);
      },
    );

    testWidgets(
      'must be unclickable when enabled is setted to false',
      (tester) async {
        int counter = 0;

        await tester.pumpWidget(
          Pressable(
            enabled: false,
            onPress: () {
              counter++;
            },
            child: Container(),
          ),
        );

        final pressableFinder = find.byType(Pressable);
        expect(pressableFinder, findsOneWidget);

        await tester.tap(pressableFinder);
        await tester.pumpAndSettle();

        expect(counter, 0);
      },
    );

    testWidgets('Pressable responds to keyboard events',
        (WidgetTester tester) async {
      var wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Pressable(
              autofocus: true,
              unpressDelay: Duration.zero,
              onPress: () {
                wasPressed = true;
              },
              child: const Text('Tap me'),
            ),
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      expect(wasPressed, isTrue);
    });

    testWidgets(
      'should propagate the onTap when it doesn\'t receive null',
      (tester) async {
        bool onTapCalled = false;

        await tester.pumpWidget(
          GestureDetector(
            onTap: () {
              onTapCalled = true;
            },
            child: const Pressable(
              child: Box(),
            ),
          ),
        );

        await tester.tap(find.byType(Pressable));

        expect(onTapCalled, isTrue);
      },
    );

    testWidgets('GestureDetector as parent should not affected by Pressable',
        (tester) async {
      bool onTapCalled = false;

      await tester.pumpWidget(
        GestureDetector(
          onTap: () {
            onTapCalled = true;
          },
          child: PressableBox(
            style: Style(
              $box.color.red(),
              $on.hover(
                $box.color.blue(),
              ),
            ),
            child: const Box(),
          ),
        ),
      );
      expect(find.byType(Pressable), findsOneWidget);
      await tester.tap(find.byType(GestureDetector).first);

      expect(onTapCalled, isTrue);
    });
  });

  testWidgets('Pressable cancel timer on dispose', (WidgetTester tester) async {
    var wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Pressable(
            autofocus: true,
            unpressDelay: const Duration(minutes: 1),
            onPress: () {
              wasPressed = !wasPressed;
            },
            child: const Text('Tap me'),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(wasPressed, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(wasPressed, isFalse);
  });

  group('PressableBox', () {
    testWidgets(
      'must be clickable when enable is setted to true',
      (tester) async {
        int counter = 0;

        await tester.pumpWidget(
          PressableBox(
            unpressDelay: Duration.zero,
            onPress: () {
              counter++;
            },
            enabled: true,
            child: Container(),
          ),
        );

        final pressableFinder = find.byType(PressableBox);
        expect(pressableFinder, findsOneWidget);

        await tester.tap(pressableFinder);
        await tester.pumpAndSettle();

        expect(counter, 1);
      },
    );

    testWidgets(
      'must be unclickable when enable is setted to false',
      (tester) async {
        int counter = 0;

        await tester.pumpWidget(
          PressableBox(
            unpressDelay: Duration.zero,
            onPress: () {
              counter++;
            },
            enabled: false,
            child: Container(),
          ),
        );

        final pressableFinder = find.byType(PressableBox);
        expect(pressableFinder, findsOneWidget);

        await tester.tap(pressableFinder);
        await tester.pumpAndSettle();

        expect(counter, 0);
      },
    );

    testWidgets('PressableBox responds to keyboard events',
        (WidgetTester tester) async {
      var wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PressableBox(
              autofocus: true,
              unpressDelay: Duration.zero,
              onPress: () {
                wasPressed = true;
              },
              child: const Text('Tap me'),
            ),
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      expect(wasPressed, isTrue);
    });

    testWidgets('animates correctly on hover', (WidgetTester tester) async {
      await tester.pumpMaterialApp(
        PressableBox(
          unpressDelay: const Duration(milliseconds: 200),
          style: Style(
            $with.opacity(1.0),
            $on.hover(
              $with.opacity(0.0),
            ),
          ).animate(
            duration: const Duration(milliseconds: 200),
          ),
          child: const Box(),
        ),
      );

      final finder = find.byType(Opacity);
      expect(finder, findsOneWidget);

      Opacity opacityWidget = tester.widget(finder);
      expect(opacityWidget.opacity, 1.0);

      await tester.hover(finder);
      await tester.pump(const Duration(milliseconds: 100));

      opacityWidget = tester.widget(finder);
      expect(opacityWidget.opacity, 0.5);
    });

    testWidgets(r'must change to attributes in $on.hover variant when hovered',
        (WidgetTester tester) async {
      await pumpTestCase(
        tester: tester,
        condition: $on.hover,
        action: () => tester.hoverAndSettle(find.byType(PressableBox)),
      );
    });

    testWidgets(r'must restyle using attributes inside $on.press when pressed',
        (WidgetTester tester) async {
      await pumpTestCase(
        tester: tester,
        duration: const Duration(milliseconds: 250),
        condition: $on.press,
        action: () async {
          await tester.tap(find.byType(PressableBox));
          await tester.pump();
        },
      );
    });

    testWidgets(
        r'must restyle using attributes inside ($on.hover | $on.press) when pressed',
        (WidgetTester tester) async {
      await pumpTestCase(
        tester: tester,
        duration: const Duration(milliseconds: 250),
        condition: ($on.hover | $on.press),
        action: () async {
          await tester.tap(find.byType(PressableBox));
          await tester.pump();
        },
      );
    });

    testWidgets(
        r'must restyle using attributes inside ($on.hover | $on.press) when hovered',
        (WidgetTester tester) async {
      await pumpTestCase(
        tester: tester,
        duration: const Duration(milliseconds: 250),
        condition: ($on.hover | $on.press),
        action: () async {
          await tester.hoverAndSettle(find.byType(PressableBox));
        },
      );
    });

    testWidgets(
        r'must NOT restyle using attributes inside ($on.hover | $on.press) when tapped without long press',
        (WidgetTester tester) async {
      await pumpTestCase(
        tester: tester,
        duration: const Duration(milliseconds: 250),
        condition: ($on.hover | $on.press),
        action: () async {
          await tester.tap(find.byType(PressableBox));
          await tester.pump();
        },
        finalExpectedOpacity: 1.0,
      );
    });

    testWidgets(
        r'must restyle using attributes inside ($on.hover & $on.press) when hovered & pressed',
        (WidgetTester tester) async {
      await pumpTestCase(
        tester: tester,
        duration: const Duration(milliseconds: 250),
        condition: ($on.hover & $on.press),
        action: () async {
          await tester.hoverAndSettle(find.byType(PressableBox));
          await tester.pump();
          await tester.tap(find.byType(PressableBox));
          await tester.pump();
        },
      );
    });

    testWidgets(
      'should propagate the onTap when it doesn\'t receive null',
      (tester) async {
        bool onTapCalled = false;

        await tester.pumpWidget(
          GestureDetector(
            onTap: () {
              onTapCalled = true;
            },
            child: const PressableBox(
              child: Box(),
            ),
          ),
        );

        await tester.tap(find.byType(PressableBox));

        expect(onTapCalled, isTrue);
      },
    );
  });

  group('Mouse Cursor tests', () {
    testWidgets('uses custom mouseCursor when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const Pressable(
          mouseCursor: SystemMouseCursors.help,
          child: SizedBox(),
        ),
      );

      final finder = find.byType(Pressable);
      expect(finder, findsOneWidget);

      final pressableState = tester.state<PressableWidgetState>(finder);
      expect(pressableState.mouseCursor, equals(SystemMouseCursors.help));
    });

    testWidgets('uses forbidden mouseCursor when disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const Pressable(
          enabled: false,
          child: SizedBox(),
        ),
      );

      final finder = find.byType(Pressable);
      expect(finder, findsOneWidget);

      final pressableState = tester.state<PressableWidgetState>(finder);
      expect(pressableState.mouseCursor, equals(SystemMouseCursors.forbidden));
    });

    testWidgets('uses click mouseCursor when enabled and onPress provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Pressable(
          onPress: () {},
          child: const SizedBox(),
        ),
      );

      final finder = find.byType(Pressable);
      expect(finder, findsOneWidget);

      final pressableState = tester.state<PressableWidgetState>(finder);
      expect(pressableState.mouseCursor, equals(SystemMouseCursors.click));
    });

    testWidgets('defers mouseCursor when enabled and onPress not provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const Pressable(
          child: SizedBox(),
        ),
      );

      final finder = find.byType(Pressable);
      expect(finder, findsOneWidget);

      final pressableState = tester.state<PressableWidgetState>(finder);
      expect(pressableState.mouseCursor, equals(MouseCursor.defer));
    });
  });

  group('Interactable', () {
    testWidgets('GestureDetector as parent should not affected by Interactable',
        (tester) async {
      bool onTapCalled = false;

      await tester.pumpWidget(
        GestureDetector(
          onTap: () {
            onTapCalled = true;
          },
          child: Box(
            style: Style(
              $box.color.red(),
              $on.hover(
                $box.color.blue(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Interactable), findsOneWidget);

      await tester.tap(find.byType(GestureDetector));

      expect(onTapCalled, isTrue);
    });
  });
}

extension WidgetTesterExt on WidgetTester {
  Future<void> hoverAndSettle(Finder finder) async {
    await hover(finder);
    await pumpAndSettle();
  }

  Future<void> hover(Finder finder) async {
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;

    final gesture = await createGesture(kind: PointerDeviceKind.mouse);

    await gesture.addPointer(location: Offset.zero);
    await pump();
    await gesture.moveTo(getCenter(finder));

    addTearDown(gesture.removePointer);
  }
}

Future<void> pumpTestCase({
  required WidgetTester tester,
  Duration duration = Duration.zero,
  required condition,
  required Future<void> Function() action,
  double finalExpectedOpacity = 1,
}) async {
  await tester.pumpWidget(
    PressableBox(
      unpressDelay: duration,
      onPress: () {},
      enabled: true,
      style: Style(
        $with.opacity(0.5),
        $box.height(50),
        $box.width(50),
        condition(
          $with.opacity(1),
        ),
      ),
      child: const SizedBox(),
    ),
  );

  final opacityFinder = find.byType(Opacity);
  expect(opacityFinder, findsOneWidget);

  final oldValue = tester.widget<Opacity>(opacityFinder).opacity;
  expect(oldValue, 0.5);

  await action();
  final newValue = tester.widget<Opacity>(opacityFinder).opacity;

  expect(opacityFinder, findsOneWidget);
  expect(newValue, finalExpectedOpacity);

  await tester.pumpAndSettle(const Duration(milliseconds: 250));
}

class _DisposalPressable extends StatefulWidget {
  const _DisposalPressable();

  @override
  _DisposalPressableState createState() => _DisposalPressableState();
}

class _DisposalPressableState extends State<_DisposalPressable> {
  late final WidgetStatesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WidgetStatesController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Pressable(
      controller: _controller,
      child: const Box(),
    );
  }
}
