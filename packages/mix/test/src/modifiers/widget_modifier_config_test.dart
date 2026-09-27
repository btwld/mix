import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('WidgetModifierConfig.mouseCursor', () {
    test('matches the equivalent explicit modifier', () {
      expect(
        WidgetModifierConfig.mouseCursor(SystemMouseCursors.click),
        WidgetModifierConfig.modifier(
          MouseCursorModifierMix(mouseCursor: SystemMouseCursors.click),
        ),
      );
    });

    test('chaining matches merging the factory result', () {
      final base = WidgetModifierConfig.opacity(0.8);

      expect(
        base.mouseCursor(SystemMouseCursors.click),
        base.merge(WidgetModifierConfig.mouseCursor(SystemMouseCursors.click)),
      );
    });

    test('resolves to a MouseCursorModifier carrying the cursor', () {
      final resolved = WidgetModifierConfig.mouseCursor(
        SystemMouseCursors.grab,
      ).resolve(MockBuildContext());

      expect(resolved, [
        const MouseCursorModifier(mouseCursor: SystemMouseCursors.grab),
      ]);
    });

    test('MouseCursor.defer keeps the inherited cursor', () {
      final resolved = WidgetModifierConfig.mouseCursor(
        MouseCursor.defer,
      ).resolve(MockBuildContext());

      expect(resolved, [
        const MouseCursorModifier(mouseCursor: MouseCursor.defer),
      ]);
    });

    testWidgets('wraps the child in a MouseRegion with the cursor', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Box(
            style: BoxStyler().wrap(.mouseCursor(SystemMouseCursors.click)),
            child: const SizedBox(width: 50, height: 50),
          ),
        ),
      );

      final region = tester.widget<MouseRegion>(
        find
            .ancestor(
              of: find.byType(SizedBox).last,
              matching: find.byType(MouseRegion),
            )
            .first,
      );
      expect(region.cursor, SystemMouseCursors.click);
    });
  });

  group('WidgetModifierConfig.scrollView', () {
    test('matches the equivalent explicit modifier', () {
      expect(
        WidgetModifierConfig.scrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsetsGeometryMix.all(16),
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.antiAlias,
        ),
        WidgetModifierConfig.modifier(
          ScrollViewModifierMix(
            scrollDirection: Axis.horizontal,
            reverse: true,
            padding: EdgeInsetsGeometryMix.all(16),
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.antiAlias,
          ),
        ),
      );
    });

    test('forwards every option to the resolved modifier', () {
      final resolved = WidgetModifierConfig.scrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: EdgeInsetsGeometryMix.all(16),
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.antiAlias,
      ).resolve(MockBuildContext());

      expect(
        resolved.single,
        isA<ScrollViewModifier>()
            .having(
              (m) => m.scrollDirection,
              'scrollDirection',
              Axis.horizontal,
            )
            .having((m) => m.reverse, 'reverse', isTrue)
            .having((m) => m.padding, 'padding', const EdgeInsets.all(16))
            .having((m) => m.physics, 'physics', isA<BouncingScrollPhysics>())
            .having((m) => m.clipBehavior, 'clipBehavior', Clip.antiAlias),
      );
    });

    test('omitted options stay null so the modifier keeps its defaults', () {
      final resolved = WidgetModifierConfig.scrollView().resolve(
        MockBuildContext(),
      );

      expect(resolved, [const ScrollViewModifier()]);
    });

    test('chaining matches merging the factory result', () {
      final base = WidgetModifierConfig.padding(EdgeInsetsGeometryMix.all(4));

      expect(
        base.scrollView(scrollDirection: Axis.horizontal, reverse: true),
        base.merge(
          WidgetModifierConfig.scrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
          ),
        ),
      );
    });

    testWidgets('wraps the child in a SingleChildScrollView', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Box(
            style: BoxStyler().wrap(
              .scrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsetsGeometryMix.all(8),
              ),
            ),
            child: const SizedBox(width: 2000, height: 50),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.horizontal);
      expect(scrollView.padding, const EdgeInsets.all(8));
      expect(scrollView.clipBehavior, Clip.hardEdge);
      expect(tester.takeException(), isNull);
    });
  });

  group('WidgetModifierConfig chaining parity with factories', () {
    test('skew', () {
      final base = WidgetModifierConfig.opacity(0.5);

      expect(
        base.skew(skewX: 0.2, skewY: 0.3, alignment: Alignment.topLeft),
        base.merge(
          WidgetModifierConfig.skew(
            skewX: 0.2,
            skewY: 0.3,
            alignment: Alignment.topLeft,
          ),
        ),
      );
    });

    test('defaultIcon', () {
      final iconMix = IconStyler(color: Colors.red, size: 24);
      final base = WidgetModifierConfig.opacity(0.5);

      expect(
        base.defaultIcon(iconMix),
        base.merge(WidgetModifierConfig.defaultIcon(iconMix)),
      );
    });

    test('iconTheme forwards every option', () {
      final base = WidgetModifierConfig.opacity(0.5);

      expect(
        base.iconTheme(
          color: Colors.red,
          size: 24,
          fill: 0.5,
          weight: 300,
          grade: 10,
          opticalSize: 48,
          opacity: 0.7,
          shadows: const [Shadow(blurRadius: 2)],
          applyTextScaling: true,
        ),
        base.merge(
          WidgetModifierConfig.iconTheme(
            color: Colors.red,
            size: 24,
            fill: 0.5,
            weight: 300,
            grade: 10,
            opticalSize: 48,
            opacity: 0.7,
            shadows: const [Shadow(blurRadius: 2)],
            applyTextScaling: true,
          ),
        ),
      );
    });

    test('iconTheme leaves omitted options unset', () {
      final resolved = WidgetModifierConfig.iconTheme(
        size: 24,
      ).resolve(MockBuildContext());

      expect(
        resolved.single,
        isA<IconThemeModifier>()
            .having((m) => m.data.size, 'data.size', 24)
            .having((m) => m.data.color, 'data.color', isNull),
      );
    });

    test('box', () {
      final spec = BoxStyler(padding: EdgeInsetsGeometryMix.all(8));
      final base = WidgetModifierConfig.opacity(0.5);

      expect(base.box(spec), base.merge(WidgetModifierConfig.box(spec)));
    });
  });

  group('WidgetModifierConfig composition invariants', () {
    test('same-type modifiers merge instead of duplicating', () {
      final config = WidgetModifierConfig.mouseCursor(
        SystemMouseCursors.basic,
      ).mouseCursor(SystemMouseCursors.click);

      expect(config.$modifiers, hasLength(1));
      expect(config.resolve(MockBuildContext()), [
        const MouseCursorModifier(mouseCursor: SystemMouseCursors.click),
      ]);
    });

    test('scrollView options accumulate across chained calls', () {
      final resolved = WidgetModifierConfig.scrollView(
        scrollDirection: Axis.horizontal,
      ).scrollView(reverse: true).resolve(MockBuildContext());

      expect(resolved, [
        const ScrollViewModifier(
          scrollDirection: Axis.horizontal,
          reverse: true,
        ),
      ]);
    });

    test('chaining leaves the source configuration untouched', () {
      final base = WidgetModifierConfig.opacity(0.5);
      final derived = base.mouseCursor(SystemMouseCursors.click);

      expect(base, WidgetModifierConfig.opacity(0.5));
      expect(base.$modifiers, hasLength(1));
      expect(derived.$modifiers, hasLength(2));
    });

    test('custom ordering survives chaining', () {
      final config = WidgetModifierConfig.orderOfModifiers([
        OpacityModifier,
        PaddingModifier,
      ]).mouseCursor(SystemMouseCursors.click).box(BoxStyler());

      expect(config.$orderOfModifiers, [OpacityModifier, PaddingModifier]);
    });
  });

  group('WidgetModifierConfig.reset', () {
    test('drops modifiers chained before it and keeps later ones', () {
      final config = WidgetModifierConfig.opacity(
        0.5,
      ).reset().padding(EdgeInsetsGeometryMix.all(8));

      final types = config
          .resolve(MockBuildContext())
          .map((m) => m.runtimeType);
      expect(types, [PaddingModifier]);
    });

    test('never leaks a ResetModifier into the resolved list', () {
      final resolved = WidgetModifierConfig.opacity(
        0.5,
      ).reset().resolve(MockBuildContext());

      expect(resolved, isEmpty);
    });

    test('is idempotent when repeated', () {
      final once = WidgetModifierConfig.opacity(0.5).reset();
      final twice = once.reset();

      expect(twice, once);
      expect(twice.resolve(MockBuildContext()), isEmpty);
    });

    test('on an empty configuration keeps the reset for later merges', () {
      final config = const WidgetModifierConfig().reset();

      expect(config.$modifiers, [const ResetModifierMix()]);
      expect(config.resolve(MockBuildContext()), isEmpty);
      expect(
        config
            .merge(WidgetModifierConfig.opacity(0.5))
            .resolve(MockBuildContext()),
        [const OpacityModifier(0.5)],
      );
    });

    test('keeps the configured ordering', () {
      final config = WidgetModifierConfig.orderOfModifiers([
        OpacityModifier,
      ]).opacity(0.5).reset();

      expect(config.$orderOfModifiers, [OpacityModifier]);
    });

    test(
      'clears only this configuration, unlike the reset factory when merged',
      () {
        final base = WidgetModifierConfig.opacity(0.5);

        // Chained reset collapses to an empty modifier list, so merging it
        // into another configuration no longer clears that one.
        expect(
          base
              .merge(WidgetModifierConfig.blur(2).reset())
              .resolve(MockBuildContext()),
          [const OpacityModifier(0.5)],
        );

        // The factory keeps the reset marker, so the merge clears the base.
        expect(
          base.merge(WidgetModifierConfig.reset()).resolve(MockBuildContext()),
          isEmpty,
        );
      },
    );
  });
}
