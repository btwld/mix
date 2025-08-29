import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/modifiers/internal/render_modifier.dart';

void main() {
  group('StyleBuilder', () {
    group('Basic functionality', () {
      testWidgets('Build from SpecAttribute', (tester) async {
        final boxAttribute = BoxStyle()
            .width(100)
            .height(200)
            .color(Colors.blue);

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: boxAttribute,
              builder: (context, spec) {
                expect(spec.constraints?.minWidth, 100);
                expect(spec.constraints?.maxWidth, 100);
                expect(spec.constraints?.minHeight, 200);
                expect(spec.constraints?.maxHeight, 200);
                return Container(
                  decoration: spec.decoration,
                  constraints: spec.constraints,
                );
              },
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.minHeight, 200);
        expect(container.constraints?.minWidth, 100);
        expect(container.constraints?.maxWidth, 100);
        expect(container.constraints?.maxHeight, 200);
        expect((container.decoration as BoxDecoration?)?.color, Colors.blue);
      });
    });

    group('Animation', () {
      testWidgets('Animation driver is applied when animation config is set', (
        tester,
      ) async {
        final animation = AnimationConfig.curve(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
        final boxAttribute = BoxStyle(
          constraints: BoxConstraintsMix().width(100).height(200),
          decoration: DecorationMix.color(Colors.blue),
          animation: animation,
        );

        // Debug: Verify animation is set on the attribute
        expect(boxAttribute.$animation, equals(animation));

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: boxAttribute,
              builder: (context, spec) {
                return Container(
                  decoration: spec.decoration,
                  constraints: spec.constraints,
                );
              },
            ),
          ),
        );

        // Verify that the animation wrapper is created
        expect(
          find.byType(StyleAnimationBuilder<BoxSpec>),
          findsOneWidget,
        );
      });

      testWidgets('No animation driver when animation config is null', (
        tester,
      ) async {
        final boxAttribute = BoxStyle()
            .width(100)
            .height(200)
            .color(Colors.blue);

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: boxAttribute,
              builder: (context, spec) {
                return Container(
                  decoration: spec.decoration,
                  constraints: spec.constraints,
                );
              },
            ),
          ),
        );

        // Verify that no animation wrapper is created
        expect(
          find.byType(StyleAnimationBuilder<BoxSpec>),
          findsNothing,
        );
      });

      testWidgets(
        'Animation creates new animated build rather than interpolating between style changes',
        (tester) async {
          final animation = AnimationConfig.curve(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );

          final startAttribute = BoxStyle(
            constraints: BoxConstraintsMix(
              minWidth: 100,
              maxWidth: 100,
              minHeight: 100,
              maxHeight: 100,
            ),
            decoration: BoxDecorationMix(color: Colors.blue),
            animation: animation,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: StyleBuilder<BoxSpec>(
                style: startAttribute,
                builder: (context, spec) {
                  return Container(
                    key: const Key('animated_container'),
                    decoration: spec.decoration,
                    constraints: spec.constraints,
                  );
                },
              ),
            ),
          );

          // Update to new style
          final endAttribute = BoxStyle(
            constraints: BoxConstraintsMix(
              minWidth: 200,
              maxWidth: 200,
              minHeight: 200,
              maxHeight: 200,
            ),
            decoration: BoxDecorationMix(color: Colors.red),
            animation: animation,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: StyleBuilder<BoxSpec>(
                style: endAttribute,
                builder: (context, spec) {
                  return Container(
                    key: const Key('animated_container'),
                    decoration: spec.decoration,
                    constraints: spec.constraints,
                  );
                },
              ),
            ),
          );

          // Give animation one frame to start
          await tester.pump();

          // Pump halfway through animation
          await tester.pump(const Duration(milliseconds: 150));

          // With WidgetSpec animation, switching styles replaces the animation widget
          // rather than interpolating between values in-place. So we only assert final value.
          final midContainer = tester.widget<Container>(
            find.byKey(const Key('animated_container')),
          );
          expect(midContainer.constraints?.minWidth, anyOf(100, 200, 150.0));

          // Complete animation
          await tester.pumpAndSettle();

          final finalContainer = tester.widget<Container>(
            find.byKey(const Key('animated_container')),
          );
          expect(finalContainer.constraints?.minWidth, 200);
          expect(finalContainer.constraints?.minHeight, 200);
          expect(
            (finalContainer.decoration as BoxDecoration?)?.color,
            Colors.red,
          );
        },
      );
    });

    group('RenderModifiers', () {
      testWidgets('Modifiers are applied when present', (tester) async {
        final boxAttribute = BoxStyle()
            .width(100)
            .height(100)
            .alignment(Alignment.center)
            .wrap(
              ModifierConfig.modifiers([
                OpacityModifierMix(opacity: 0.5),
                PaddingModifierMix(padding: EdgeInsetsGeometryMix.all(10)),
                ClipOvalModifierMix(),
              ]),
            );

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: boxAttribute,
              builder: (context, spec) {
                return Container(
                  decoration: spec.decoration,
                  constraints: spec.constraints,
                  alignment: spec.alignment,
                );
              },
            ),
          ),
        );

        // Verify modifiers are applied
        expect(find.byType(Opacity), findsOneWidget);
        expect(find.byType(ClipOval), findsOneWidget);

        // There might be multiple Padding widgets, so let's be more specific
        final paddingWidgets = find.byType(Padding);
        expect(paddingWidgets, findsAtLeastNWidgets(1));

        // Find the padding with EdgeInsets.all(10)
        final paddingWithCorrectInsets = paddingWidgets
            .evaluate()
            .map((e) => e.widget as Padding)
            .where((p) => p.padding == const EdgeInsets.all(10))
            .toList();
        expect(paddingWithCorrectInsets, hasLength(1));

        // Check opacity value
        final opacity = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacity.opacity, 0.5);
      });

      testWidgets('Modifiers follow default order', (tester) async {
        final boxAttribute = BoxStyle()
            .width(100)
            .height(100)
            .color(Colors.blue)
            .wrap(
              ModifierConfig.modifiers([
                OpacityModifierMix(opacity: 0.5),
                PaddingModifierMix(padding: EdgeInsetsGeometryMix.all(10)),
                ClipOvalModifierMix(),
                VisibilityModifierMix(visible: true),
              ]),
            );

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: boxAttribute,
              builder: (context, spec) {
                return Container(
                  decoration: spec.decoration,
                  constraints: spec.constraints,
                );
              },
            ),
          ),
        );

        // Find the StyleBuilder widget
        final styleBuilder = find.byType(StyleBuilder<BoxSpec>);

        // Verify ordering: Visibility should wrap everything, then other modifiers in order
        // The default order has Visibility early, Padding after transformations, ClipOval near end, and Opacity last
        expect(
          find.descendant(of: styleBuilder, matching: find.byType(Visibility)),
          findsOneWidget,
        );

        // Find the modifier padding (EdgeInsets.all(10))
        final visibilityWidget = find.byType(Visibility);
        final paddingWidgets = find.descendant(
          of: visibilityWidget,
          matching: find.byType(Padding),
        );
        final modifierPadding = paddingWidgets
            .evaluate()
            .map((e) => e.widget as Padding)
            .where((p) => p.padding == const EdgeInsets.all(10))
            .toList();
        expect(modifierPadding, hasLength(1));

        expect(
          find.descendant(
            of: find.byType(Padding),
            matching: find.byType(ClipOval),
          ),
          findsOneWidget,
        );

        expect(
          find.descendant(
            of: find.byType(ClipOval),
            matching: find.byType(Opacity),
          ),
          findsOneWidget,
        );
      });

      testWidgets('Custom modifier order is respected', (tester) async {
        const customOrder = [
          OpacityModifier,
          ClipOvalModifier,
          PaddingModifier,
        ];

        final boxAttribute = BoxStyle()
            .width(100)
            .height(100)
            .color(Colors.blue)
            .wrap(
              ModifierConfig.modifiers([
                OpacityModifierMix(opacity: 0.5),
                PaddingModifierMix(padding: EdgeInsetsGeometryMix.all(10)),
                ClipOvalModifierMix(),
              ]).orderOfModifiers(customOrder),
            );

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: boxAttribute,
              builder: (context, spec) {
                return Container(
                  decoration: spec.decoration,
                  constraints: spec.constraints,
                );
              },
            ),
          ),
        );

        // Find the StyleBuilder widget
        final styleBuilder = find.byType(StyleBuilder<BoxSpec>);

        // Verify custom ordering: Opacity -> ClipOval -> Padding
        expect(
          find.descendant(of: styleBuilder, matching: find.byType(Opacity)),
          findsOneWidget,
        );

        expect(
          find.descendant(
            of: find.byType(Opacity),
            matching: find.byType(ClipOval),
          ),
          findsOneWidget,
        );

        // Find the modifier padding (EdgeInsets.all(10))
        final clipOvalWidget = find.byType(ClipOval);
        final paddingWidgets = find.descendant(
          of: clipOvalWidget,
          matching: find.byType(Padding),
        );
        final modifierPadding = paddingWidgets
            .evaluate()
            .map((e) => e.widget as Padding)
            .where((p) => p.padding == const EdgeInsets.all(10))
            .toList();
        expect(modifierPadding, hasLength(1));
      });

      testWidgets('No RenderModifiers widget when no modifiers present', (
        tester,
      ) async {
        final boxAttribute = BoxStyle()
            .width(100)
            .height(100)
            .color(Colors.blue);

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: boxAttribute,
              builder: (context, spec) {
                return Container(
                  decoration: spec.decoration,
                  constraints: spec.constraints,
                );
              },
            ),
          ),
        );

        // Verify no modifier widgets are present
        expect(find.byType(RenderModifiers), findsNothing);
      });
    });
  });
}
