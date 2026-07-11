import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/core/internal/mix_interaction_detector.dart';

/// Regression tests for reactive inherited-style lookup and widget-state
/// dependency ownership.
///
/// These pin the corrections described in the "style resolution correctness"
/// change: inherited styles must react to provider changes, and a
/// state-independent style must not depend on widget-state changes above it.
void main() {
  Color? colorOf(BoxSpec spec) => (spec.decoration as BoxDecoration?)?.color;

  group('Inherited style reactivity', () {
    testWidgets(
      'a StyleProvider change re-resolves an identical child StyleBuilder',
      (tester) async {
        late BoxSpec resolved;

        // Captured once, so the child StyleBuilder instance is identical across
        // parent rebuilds. Only an inherited-widget dependency can make it
        // re-resolve — a stable child cannot rely on its own rebuild.
        final child = StyleBuilder<BoxSpec>(
          style: BoxStyler().width(10),
          builder: (context, spec) {
            resolved = spec;
            return const SizedBox();
          },
        );

        late StateSetter setOuter;
        var providerColor = Colors.red;

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                setOuter = setState;

                return StyleProvider<BoxSpec>(
                  style: BoxStyler().color(providerColor),
                  child: child,
                );
              },
            ),
          ),
        );

        expect(colorOf(resolved), Colors.red);

        setOuter(() => providerColor = Colors.green);
        await tester.pump();

        expect(
          colorOf(resolved),
          Colors.green,
          reason: 'inherited style change must re-resolve even a stable child',
        );
      },
    );
  });

  group('Widget-state dependency ownership', () {
    testWidgets(
      'a state-independent style does not re-resolve on ancestor state changes',
      (tester) async {
        final controller = WidgetStatesController();
        addTearDown(controller.dispose);

        var buildCount = 0;

        // Identical child across provider rebuilds isolates the dependency:
        // it re-resolves only if it subscribed to the WidgetStateProvider.
        final child = StyleBuilder<BoxSpec>(
          style: BoxStyler().color(Colors.blue),
          builder: (context, spec) {
            buildCount++;
            return const SizedBox();
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                return WidgetStateProvider(
                  states: controller.value,
                  child: child,
                );
              },
            ),
          ),
        );

        final baseline = buildCount;

        controller.hovered = true;
        await tester.pump();
        expect(
          buildCount,
          baseline,
          reason: 'hover change must not re-resolve a state-free style',
        );

        controller.pressed = true;
        await tester.pump();
        expect(
          buildCount,
          baseline,
          reason: 'press change must not re-resolve a state-free style',
        );

        controller.focused = true;
        await tester.pump();
        expect(
          buildCount,
          baseline,
          reason: 'focus change must not re-resolve a state-free style',
        );
      },
    );

    testWidgets('a pressed-only style depends on pressed but not hover', (
      tester,
    ) async {
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);

      var buildCount = 0;
      Color? color;

      final child = StyleBuilder<BoxSpec>(
        style: BoxStyler()
            .color(Colors.blue)
            .onPressed(BoxStyler().color(Colors.red)),
        builder: (context, spec) {
          buildCount++;
          color = colorOf(spec);
          return const SizedBox();
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return WidgetStateProvider(
                states: controller.value,
                child: child,
              );
            },
          ),
        ),
      );

      final baseline = buildCount;
      expect(color, Colors.blue);

      // Hover is unrelated to a pressed-only style: no re-resolution.
      controller.hovered = true;
      await tester.pump();
      expect(
        buildCount,
        baseline,
        reason: 'pressed-only style must not depend on hover',
      );
      expect(color, Colors.blue);

      // Pressed is a declared dependency: must re-resolve.
      controller.pressed = true;
      await tester.pump();
      expect(
        buildCount,
        greaterThan(baseline),
        reason: 'pressed-only style must react to pressed state',
      );
      expect(color, Colors.red);
    });
  });

  group('Interaction machinery installation', () {
    testWidgets('a state-free style installs no controller or detector', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StyleBuilder<BoxSpec>(
            style: BoxStyler().color(Colors.blue).width(10).height(10),
            builder: (context, spec) => const SizedBox(),
          ),
        ),
      );

      // No detector and no WidgetStateProvider means no controller was created
      // for a style that never reacts to widget state.
      expect(find.byType(MixInteractionDetector), findsNothing);
      expect(find.byType(WidgetStateProvider), findsNothing);
    });

    testWidgets(
      'a focus-only style installs no pointer detector that cannot activate it',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: BoxStyler()
                  .color(Colors.blue)
                  .onFocused(BoxStyler().color(Colors.red)),
              builder: (context, spec) => const SizedBox(),
            ),
          ),
        );

        // A pointer detector produces hover/press, never focus, so installing
        // one for a focus-only style would be dead work.
        expect(find.byType(MixInteractionDetector), findsNothing);
      },
    );

    testWidgets('a hover style installs exactly one pointer detector', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StyleBuilder<BoxSpec>(
            style: BoxStyler()
                .color(Colors.blue)
                .onHovered(BoxStyler().color(Colors.red)),
            builder: (context, spec) => const SizedBox(),
          ),
        ),
      );

      expect(find.byType(MixInteractionDetector), findsOneWidget);
    });
  });

  group('scrolledUnder through the public state path', () {
    testWidgets('activates through an external WidgetStatesController', (
      tester,
    ) async {
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);

      Color? color;

      await tester.pumpWidget(
        MaterialApp(
          home: StyleBuilder<BoxSpec>(
            controller: controller,
            style: BoxStyler()
                .color(Colors.blue)
                .variant(
                  ContextVariant.widgetState(WidgetState.scrolledUnder),
                  BoxStyler().color(Colors.red),
                ),
            builder: (context, spec) {
              color = colorOf(spec);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(color, Colors.blue);

      controller.scrolledUnder = true;
      await tester.pump();

      expect(
        color,
        Colors.red,
        reason: 'scrolledUnder must resolve through the state variant path',
      );
    });
  });
}
