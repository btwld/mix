import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

const _boxKey = Key('focus-visible-box');

Future<FocusNode> _pumpFocusable(WidgetTester tester) async {
  final focusNode = FocusNode();
  addTearDown(focusNode.dispose);
  await tester.pumpWidget(
    MaterialApp(
      home: Align(
        alignment: Alignment.topLeft,
        child: Pressable(
          focusNode: focusNode,
          child: Box(
            key: _boxKey,
            style: BoxStyler()
                .size(100, 100)
                .color(Colors.blue)
                .onFocusVisible(.color(Colors.red)),
          ),
        ),
      ),
    ),
  );

  return focusNode;
}

Color? _colorOf(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.descendant(of: find.byKey(_boxKey), matching: find.byType(Container)),
  );

  return (container.decoration as BoxDecoration?)?.color;
}

// Presses away from the box, so focus stays where it is.
Future<void> _pressOutside(
  WidgetTester tester, {
  PointerDeviceKind kind = .mouse,
}) async {
  await tester.tapAt(const Offset(400, 400), kind: kind);
  await tester.pumpAndSettle();
}

void _dispatchKey(
  LogicalKeyboardKey logical,
  PhysicalKeyboardKey physical, {
  bool repeat = false,
}) {
  final KeyEvent event;
  if (repeat) {
    event = KeyRepeatEvent(
      physicalKey: physical,
      logicalKey: logical,
      timeStamp: Duration.zero,
    );
  } else {
    event = KeyDownEvent(
      physicalKey: physical,
      logicalKey: logical,
      timeStamp: Duration.zero,
    );
  }
  HardwareKeyboard.instance.handleKeyEvent(event);
}

void _releaseKey(LogicalKeyboardKey logical, PhysicalKeyboardKey physical) {
  HardwareKeyboard.instance.handleKeyEvent(
    KeyUpEvent(
      physicalKey: physical,
      logicalKey: logical,
      timeStamp: Duration.zero,
    ),
  );
}

class _ScopeRebuildProbe extends StatefulWidget {
  const _ScopeRebuildProbe();

  static var builds = 0;

  @override
  State<_ScopeRebuildProbe> createState() => _ScopeRebuildProbeState();
}

class _ScopeRebuildProbeState extends State<_ScopeRebuildProbe> {
  @override
  Widget build(BuildContext context) {
    _ScopeRebuildProbe.builds += 1;
    FocusVisibility.of(context);

    return const SizedBox.shrink();
  }
}

void main() {
  const desktop = TargetPlatformVariant({.macOS});

  group('FocusVisibility', () {
    testWidgets('keyboard input shows focus and a mouse press hides it', (
      tester,
    ) async {
      final focusNode = await _pumpFocusable(tester);
      focusNode.requestFocus();
      await tester.pumpAndSettle();
      // Before any input, desktop follows Flutter's traditional default.
      expect(_colorOf(tester), Colors.red);

      await _pressOutside(tester);
      expect(focusNode.hasFocus, isTrue);
      expect(FocusVisibility.isVisible, isFalse);
      expect(_colorOf(tester), Colors.blue);

      await tester.sendKeyEvent(.arrowDown);
      await tester.pump();
      expect(FocusVisibility.isVisible, isTrue);
      expect(_colorOf(tester), Colors.red);
    }, variant: desktop);

    testWidgets('focus moved in code after a mouse press stays hidden', (
      tester,
    ) async {
      final focusNode = await _pumpFocusable(tester);
      await _pressOutside(tester);

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);
      expect(_colorOf(tester), Colors.blue);
    }, variant: desktop);

    testWidgets('Tab after a mouse press shows focus', (tester) async {
      final focusNode = await _pumpFocusable(tester);
      await _pressOutside(tester);

      await tester.sendKeyEvent(.tab);
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);
      expect(_colorOf(tester), Colors.red);
    }, variant: desktop);

    testWidgets(
      'modifier keys and shortcuts do not count as keyboard input',
      (tester) async {
        final focusNode = await _pumpFocusable(tester);
        focusNode.requestFocus();
        await _pressOutside(tester);

        for (final modifier in [
          LogicalKeyboardKey.shiftLeft,
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.metaLeft,
          LogicalKeyboardKey.altLeft,
        ]) {
          await tester.sendKeyEvent(modifier);
        }
        await tester.sendKeyDownEvent(.metaLeft);
        await tester.sendKeyEvent(.keyB);
        await tester.sendKeyUpEvent(.metaLeft);
        await tester.sendKeyDownEvent(.controlLeft);
        await tester.sendKeyEvent(.keyB);
        await tester.sendKeyUpEvent(.controlLeft);
        await tester.pump();
        expect(_colorOf(tester), Colors.blue);

        await tester.sendKeyDownEvent(.shiftLeft);
        await tester.sendKeyEvent(.tab);
        await tester.sendKeyUpEvent(.shiftLeft);
        await tester.pump();
        expect(FocusVisibility.isVisible, isTrue);
      },
      variant: desktop,
    );

    for (final platform in [TargetPlatform.macOS, TargetPlatform.windows]) {
      final countsAsKeyboard = platform == .macOS;
      testWidgets(
        'Alt with a key ${countsAsKeyboard ? 'counts' : 'does not count'} '
        'as keyboard input on ${platform.name}',
        (tester) async {
          await _pumpFocusable(tester);
          await _pressOutside(tester);

          await tester.sendKeyDownEvent(.altLeft);
          await tester.sendKeyEvent(.keyB);
          await tester.sendKeyUpEvent(.altLeft);
          expect(FocusVisibility.isVisible, countsAsKeyboard);
        },
        variant: TargetPlatformVariant({platform}),
      );
    }

    testWidgets('a touch press hides focus', (tester) async {
      final focusNode = await _pumpFocusable(tester);
      await tester.sendKeyEvent(.tab);
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);
      expect(_colorOf(tester), Colors.red);

      await _pressOutside(tester, kind: .touch);
      expect(_colorOf(tester), Colors.blue);
    });

    testWidgets('alwaysTraditional shows focus after a pointer press', (
      tester,
    ) async {
      final focusManager = FocusManager.instance;
      await _pumpFocusable(tester);
      await _pressOutside(tester);

      focusManager.highlightStrategy = .alwaysTraditional;
      expect(FocusVisibility.isVisible, isTrue);
    }, variant: desktop);

    testWidgets('alwaysTouch hides focus after keyboard input', (tester) async {
      final focusManager = FocusManager.instance;
      await _pumpFocusable(tester);

      focusManager.highlightStrategy = .alwaysTouch;
      await tester.sendKeyEvent(.arrowDown);
      expect(FocusVisibility.isVisible, isFalse);
    }, variant: desktop);

    testWidgets(
      'a scope updates styles under a manually mounted widget-state scope',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: FocusVisibilityScope(
                child: WidgetStateProvider(
                  states: const {.focused},
                  child: Box(
                    key: _boxKey,
                    style: BoxStyler()
                        .size(100, 100)
                        .color(Colors.blue)
                        .onFocusVisible(.color(Colors.red)),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(_colorOf(tester), Colors.red);

        await _pressOutside(tester);
        expect(_colorOf(tester), Colors.blue);

        await tester.sendKeyEvent(.arrowDown);
        await tester.pump();
        expect(_colorOf(tester), Colors.red);
      },
      variant: desktop,
    );

    testWidgets(
      'alwaysTraditional after a mouse press applies on the next rebuild',
      (tester) async {
        final focusNode = await _pumpFocusable(tester);
        focusNode.requestFocus();
        await tester.pumpAndSettle();
        await _pressOutside(tester);
        expect(_colorOf(tester), Colors.blue);

        final focusManager = FocusManager.instance;
        focusManager.highlightStrategy = .alwaysTraditional;
        expect(FocusVisibility.isVisible, isTrue);
        expect(_colorOf(tester), Colors.blue);

        tester.element(find.byKey(_boxKey)).markNeedsBuild();
        await tester.pump();
        expect(_colorOf(tester), Colors.red);

        focusManager.highlightStrategy = .automatic;
        expect(FocusVisibility.isVisible, isFalse);
        expect(_colorOf(tester), Colors.red);

        tester.element(find.byKey(_boxKey)).markNeedsBuild();
        await tester.pump();
        expect(_colorOf(tester), Colors.blue);
      },
      variant: desktop,
    );

    testWidgets(
      'switching back to automatic after a touch press hides the ring',
      (tester) async {
        final focusNode = await _pumpFocusable(tester);
        FocusManager.instance.highlightStrategy = .alwaysTraditional;
        focusNode.requestFocus();
        await tester.pumpAndSettle();
        await _pressOutside(tester, kind: .touch);
        expect(_colorOf(tester), Colors.red);

        FocusManager.instance.highlightStrategy = .automatic;
        await tester.pump();
        expect(FocusVisibility.isVisible, isFalse);
        expect(_colorOf(tester), Colors.blue);
      },
      variant: desktop,
    );

    testWidgets(
      'alwaysTouch after keyboard input repaints on the next pump',
      (tester) async {
        final focusNode = await _pumpFocusable(tester);
        focusNode.requestFocus();
        await tester.sendKeyEvent(.arrowDown);
        await tester.pumpAndSettle();
        expect(_colorOf(tester), Colors.red);

        FocusManager.instance.highlightStrategy = .alwaysTouch;
        await tester.pump();
        expect(FocusVisibility.isVisible, isFalse);
        expect(_colorOf(tester), Colors.blue);
      },
      variant: desktop,
    );

    testWidgets('lock keys and extra modifiers do not restore visibility', (
      tester,
    ) async {
      await _pumpFocusable(tester);
      await _pressOutside(tester);
      expect(FocusVisibility.isVisible, isFalse);

      const keys = <(LogicalKeyboardKey, PhysicalKeyboardKey)>[
        (.numLock, .numLock),
        (.scrollLock, .scrollLock),
        (.fnLock, .fnLock),
        (.altGraph, .keyA),
        (.symbol, .keyB),
        (.symbolLock, .keyC),
        (.hyper, .hyper),
        (.superKey, .superKey),
      ];
      for (final (logical, physical) in keys) {
        _dispatchKey(logical, physical);
        expect(FocusVisibility.isVisible, isFalse);
        _releaseKey(logical, physical);
      }

      _dispatchKey(.superKey, .superKey);
      _dispatchKey(.arrowDown, .arrowDown);
      expect(FocusVisibility.isVisible, isFalse);
      _releaseKey(.arrowDown, .arrowDown);
      _releaseKey(.superKey, .superKey);

      _dispatchKey(.hyper, .hyper);
      _dispatchKey(.arrowDown, .arrowDown);
      expect(FocusVisibility.isVisible, isFalse);
      _releaseKey(.arrowDown, .arrowDown);
      _releaseKey(.hyper, .hyper);

      _dispatchKey(.arrowDown, .arrowDown, repeat: true);
      expect(FocusVisibility.isVisible, isTrue);
    }, variant: desktop);

    testWidgets(
      'alwaysTraditional input does not rebuild scope dependents',
      (tester) async {
        _ScopeRebuildProbe.builds = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: FocusVisibilityScope(child: const _ScopeRebuildProbe()),
          ),
        );
        FocusManager.instance.highlightStrategy = .alwaysTraditional;
        await tester.pump();
        final before = _ScopeRebuildProbe.builds;

        await _pressOutside(tester);
        await tester.sendKeyEvent(.arrowDown);
        await tester.pump();
        expect(FocusVisibility.isVisible, isTrue);
        expect(_ScopeRebuildProbe.builds, before);
      },
      variant: desktop,
    );

    testWidgets(
      'requestFocus during the pointer down keeps the focus ring hidden',
      (tester) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        await tester.pumpWidget(
          MaterialApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: Listener(
                onPointerDown: (_) => focusNode.requestFocus(),
                child: Pressable(
                  focusNode: focusNode,
                  child: Box(
                    key: _boxKey,
                    style: BoxStyler()
                        .size(100, 100)
                        .color(Colors.blue)
                        .onFocusVisible(.color(Colors.red)),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(_boxKey));
        await tester.pumpAndSettle();
        expect(focusNode.hasFocus, isTrue);
        expect(FocusVisibility.isVisible, isFalse);
        expect(_colorOf(tester), Colors.blue);
      },
      variant: desktop,
    );
  });
}
