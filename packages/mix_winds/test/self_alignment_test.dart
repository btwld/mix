import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';

/// Mirrors the launch-command header: a row whose cross alignment is
/// `items-center`, holding a tall block and a short `self-start` badge.
///
/// The row sits inside a column so its height shrink-wraps to the tall child. A
/// row stretched by its parent would make every alignment look correct for the
/// wrong reason.
Future<void> _pumpRow(
  WidgetTester tester,
  String badgeClasses, {
  String rowClasses = 'flex flex-row items-center',
  double? height = 96,
  TwDiagnosticCallback? onDiagnostic,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 600,
            height: height,
            child: Div(
              classNames: rowClasses,
              onDiagnostic: onDiagnostic,
              children: [
                Div(
                  key: const Key('tall'),
                  classNames: 'h-24 w-20 bg-slate-800',
                ),
                Div(key: const Key('badge'), classNames: badgeClasses),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// The painted box inside a Tailwind element.
///
/// A self-aligned child contains an [Align], and the custom flex can reposition
/// that wrapper. Assertions target the decorated box so they describe what is
/// actually on screen.
Finder _painted(String key) =>
    find.descendant(of: find.byKey(Key(key)), matching: find.byType(Container));

double _top(WidgetTester tester, String key) =>
    tester.getTopLeft(_painted(key)).dy;
double _bottom(WidgetTester tester, String key) =>
    tester.getBottomLeft(_painted(key)).dy;
double _height(WidgetTester tester, String key) =>
    tester.getSize(_painted(key)).height;

void main() {
  group('align-self overrides align-items in a content-height row', () {
    testWidgets('self-start pins the badge to the top', (tester) async {
      await _pumpRow(tester, 'self-start h-6 w-20 bg-emerald-400');

      expect(_top(tester, 'badge'), _top(tester, 'tall'));
      expect(_height(tester, 'badge'), 24);
    });

    testWidgets('self-end pins the badge to the bottom', (tester) async {
      await _pumpRow(tester, 'self-end h-6 w-20 bg-emerald-400');

      expect(_bottom(tester, 'badge'), _bottom(tester, 'tall'));
      expect(_height(tester, 'badge'), 24);
    });

    testWidgets('self-center centers against an items-start row', (
      tester,
    ) async {
      await _pumpRow(
        tester,
        'self-center h-6 w-20 bg-emerald-400',
        rowClasses: 'flex flex-row items-start',
      );

      final rowTop = _top(tester, 'tall');
      expect(_top(tester, 'badge'), closeTo(rowTop + (96 - 24) / 2, 0.5));
    });

    testWidgets('self conflicts resolve independently of token order', (
      tester,
    ) async {
      Future<double> topFor(String classes) async {
        await _pumpRow(tester, '$classes h-6 w-20 bg-emerald-400');
        return _top(tester, 'badge');
      }

      final forward = await topFor('self-end self-start');
      final reverse = await topFor('self-start self-end');

      expect(forward, 0);
      expect(reverse, forward);
    });

    testWidgets('self-start opts out of explicit items-stretch', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 600,
                height: 96,
                child: Div(
                  classNames: 'flex flex-row items-stretch',
                  children: const [
                    Div(
                      key: Key('badge'),
                      classNames: 'self-start h-6 w-20 bg-emerald-400',
                    ),
                    Div(key: Key('sibling'), classNames: 'w-20 bg-cyan-400'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(_top(tester, 'badge'), 0);
      expect(_height(tester, 'badge'), 24);
      expect(_height(tester, 'sibling'), 96);
    });

    testWidgets('siblings keep the container alignment and natural size', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 600,
                height: 96,
                child: Div(
                  classNames: 'flex flex-row items-center',
                  children: [
                    Div(
                      key: const Key('tall'),
                      classNames: 'h-24 w-20 bg-slate-800',
                    ),
                    Div(
                      key: const Key('badge'),
                      classNames: 'self-start h-6 w-20 bg-emerald-400',
                    ),
                    Div(
                      key: const Key('sibling'),
                      classNames: 'h-6 w-20 bg-cyan-400',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // The self-aligned child moves; the plain sibling must not be stretched
      // to the row height, and must stay centered.
      expect(_top(tester, 'badge'), _top(tester, 'tall'));
      expect(_height(tester, 'sibling'), 24);
      expect(
        tester.getCenter(_painted('sibling')).dy,
        closeTo(tester.getCenter(_painted('tall')).dy, 0.5),
      );
    });

    testWidgets('without self-*, the badge stays centered', (tester) async {
      await _pumpRow(tester, 'h-6 w-20 bg-emerald-400');

      expect(
        tester.getCenter(_painted('badge')).dy,
        closeTo(tester.getCenter(_painted('tall')).dy, 0.5),
      );
    });

    testWidgets('self-start works in a column too', (tester) async {
      await _pumpRow(
        tester,
        'self-start h-6 w-20 bg-emerald-400',
        rowClasses: 'flex flex-col items-center',
        height: 400,
      );

      // The column is 600 wide, so items-center puts the 80-wide tall child at
      // 260 while the self-start badge stays flush with the leading edge.
      expect(tester.getTopLeft(_painted('badge')).dx, 0);
      expect(tester.getTopLeft(_painted('tall')).dx, 260);
    });

    testWidgets('honors self-start when the cross axis is unbounded', (
      tester,
    ) async {
      final diagnostics = <TwDiagnostic>[];

      // A row nested in a column receives an unbounded height, so the flex sizes
      // its own cross axis from its children. This is the shape the parity
      // examples use, and the one a container-level stretch cannot serve.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 600,
                child: Div(
                  classNames: 'flex flex-col',
                  children: [
                    Div(
                      classNames: 'flex flex-row items-center',
                      onDiagnostic: diagnostics.add,
                      children: [
                        Div(
                          key: const Key('tall'),
                          classNames: 'h-24 w-20 bg-slate-800',
                        ),
                        Div(
                          key: const Key('badge'),
                          classNames: 'self-start h-6 w-20 bg-emerald-400',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(_top(tester, 'badge'), _top(tester, 'tall'));
      expect(_height(tester, 'badge'), 24);
      expect(
        diagnostics,
        isEmpty,
        reason: 'the utility is honored, so nothing should be reported',
      );
    });
  });
}
