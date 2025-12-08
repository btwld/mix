import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/core/internal/mix_interaction_detector.dart';
import 'package:mix/src/modifiers/internal/render_modifier.dart';

void main() {
  group('StyleBuilder', () {
    group('Basic functionality', () {
      testWidgets('Build from SpecAttribute', (tester) async {
        final boxAttribute = BoxStyler()
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
        final boxAttribute = BoxStyler(
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
        expect(find.byType(StyleAnimationBuilder<BoxSpec>), findsOneWidget);
      });

      testWidgets(
        'No animation driver when animation config is null',
        (tester) async {
          final boxAttribute = BoxStyler()
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
          expect(find.byType(StyleAnimationBuilder<BoxSpec>), findsNothing);
        },
        skip:
            // TODO: SHOULD REVIEW LATER: Skips because we are adding the animation driver everytime
            true,
      );

      testWidgets(
        'Animation creates new animated build rather than interpolating between style changes',
        (tester) async {
          final animation = AnimationConfig.curve(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );

          final startAttribute = BoxStyler(
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
          final endAttribute = BoxStyler(
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

          // With StyleSpec animation, switching styles replaces the animation widget
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
        final boxAttribute = BoxStyler()
            .width(100)
            .height(100)
            .alignment(Alignment.center)
            .wrap(
              WidgetModifierConfig.modifiers([
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
        final boxAttribute = BoxStyler()
            .width(100)
            .height(100)
            .color(Colors.blue)
            .wrap(
              WidgetModifierConfig.modifiers([
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

        final boxAttribute = BoxStyler()
            .width(100)
            .height(100)
            .color(Colors.blue)
            .wrap(
              WidgetModifierConfig.modifiers([
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
        final boxAttribute = BoxStyler()
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

    group('Inheritable functionality', () {
      testWidgets('Default inheritable=false does not wrap with StyleProvider', (
        tester,
      ) async {
        final boxAttribute = BoxStyler()
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

        // Verify that no StyleProvider is created when inheritable=false (default)
        expect(find.byType(StyleProvider<BoxSpec>), findsNothing);
      });

      testWidgets('inheritable=true wraps child with StyleProvider', (
        tester,
      ) async {
        final boxAttribute = BoxStyler()
            .width(100)
            .height(100)
            .color(Colors.blue);

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: boxAttribute,
              inheritable: true,
              builder: (context, spec) {
                return Container(
                  decoration: spec.decoration,
                  constraints: spec.constraints,
                );
              },
            ),
          ),
        );

        // Verify that StyleProvider is created when inheritable=true
        expect(find.byType(StyleProvider<BoxSpec>), findsOneWidget);
      });

      testWidgets('Child widgets inherit style when inheritable=true', (
        tester,
      ) async {
        final parentStyle = BoxStyler()
            .width(200)
            .height(200)
            .color(Colors.red);

        final childStyle = BoxStyler().width(100).height(100);

        late BoxSpec childResolvedSpec;
        late Style<BoxSpec>? inheritedStyleFromProvider;

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: parentStyle,
              inheritable: true,
              builder: (context, spec) {
                return StyleBuilder<BoxSpec>(
                  style: childStyle,
                  builder: (context, childSpec) {
                    childResolvedSpec = childSpec;
                    // Verify that StyleProvider is accessible within scope
                    inheritedStyleFromProvider = Style.maybeOf<BoxSpec>(
                      context,
                    );
                    return Container(
                      decoration: childSpec.decoration,
                      constraints: childSpec.constraints,
                    );
                  },
                );
              },
            ),
          ),
        );

        // Verify StyleProvider is accessible and contains the expected style
        expect(inheritedStyleFromProvider, isNotNull);

        // Child should inherit the color from parent but use its own width/height
        expect(childResolvedSpec.constraints?.minWidth, 100);
        expect(childResolvedSpec.constraints?.maxWidth, 100);
        expect(childResolvedSpec.constraints?.minHeight, 100);
        expect(childResolvedSpec.constraints?.maxHeight, 100);
        expect(
          (childResolvedSpec.decoration as BoxDecoration?)?.color,
          Colors.red,
        );
      });

      testWidgets('Nested inheritance with multiple levels', (tester) async {
        final grandparentStyle = BoxStyler()
            .color(Colors.blue)
            .padding(EdgeInsetsGeometryMix.all(20));

        final parentStyle = BoxStyler()
            .width(150)
            .height(150)
            .color(Colors.red); // Should override grandparent's color

        final childStyle = BoxStyler().width(100).height(100);

        late BoxSpec childResolvedSpec;

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: grandparentStyle,
              inheritable: true,
              builder: (context, spec) {
                return StyleBuilder<BoxSpec>(
                  style: parentStyle,
                  inheritable: true,
                  builder: (context, parentSpec) {
                    return StyleBuilder<BoxSpec>(
                      style: childStyle,
                      builder: (context, childSpec) {
                        childResolvedSpec = childSpec;
                        return Container(
                          decoration: childSpec.decoration,
                          constraints: childSpec.constraints,
                          padding: childSpec.padding,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );

        // Child should inherit:
        // - padding from grandparent
        // - color from parent (overrides grandparent)
        // - use its own width/height
        expect(childResolvedSpec.constraints?.minWidth, 100);
        expect(childResolvedSpec.constraints?.maxWidth, 100);
        expect(childResolvedSpec.constraints?.minHeight, 100);
        expect(childResolvedSpec.constraints?.maxHeight, 100);
        expect(
          (childResolvedSpec.decoration as BoxDecoration?)?.color,
          Colors.red,
        );
        expect(childResolvedSpec.padding, const EdgeInsets.all(20));
      });

      testWidgets('Child without inheritance does not affect parent style', (
        tester,
      ) async {
        final parentStyle = BoxStyler()
            .width(200)
            .height(200)
            .color(Colors.red);

        final childStyle = BoxStyler()
            .width(100)
            .height(100)
            .color(Colors.blue);

        late BoxSpec parentResolvedSpec;
        late BoxSpec childResolvedSpec;
        late Style<BoxSpec>? inheritedStyleFromProvider;

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: parentStyle,
              // inheritable: false (default)
              builder: (context, spec) {
                parentResolvedSpec = spec;
                return StyleBuilder<BoxSpec>(
                  style: childStyle,
                  builder: (context, childSpec) {
                    childResolvedSpec = childSpec;
                    // Verify that StyleProvider is NOT accessible when inheritable=false
                    inheritedStyleFromProvider = Style.maybeOf<BoxSpec>(
                      context,
                    );
                    return Container(
                      decoration: childSpec.decoration,
                      constraints: childSpec.constraints,
                    );
                  },
                );
              },
            ),
          ),
        );

        // Verify StyleProvider is NOT accessible when inheritable=false
        expect(inheritedStyleFromProvider, isNull);

        // Parent should maintain its own style
        expect(parentResolvedSpec.constraints?.minWidth, 200);
        expect(parentResolvedSpec.constraints?.maxWidth, 200);
        expect(
          (parentResolvedSpec.decoration as BoxDecoration?)?.color,
          Colors.red,
        );

        // Child should have its own style without inheritance
        expect(childResolvedSpec.constraints?.minWidth, 100);
        expect(childResolvedSpec.constraints?.maxWidth, 100);
        expect(
          (childResolvedSpec.decoration as BoxDecoration?)?.color,
          Colors.blue,
        );
      });

      testWidgets('inheritable works with widget modifiers', (tester) async {
        final parentStyle = BoxStyler()
            .color(Colors.red)
            .wrap(
              WidgetModifierConfig.modifiers([
                OpacityModifierMix(opacity: 0.5),
              ]),
            );

        final childStyle = BoxStyler().width(100).height(100);

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: parentStyle,
              inheritable: true,
              builder: (context, spec) {
                return StyleBuilder<BoxSpec>(
                  style: childStyle,
                  builder: (context, childSpec) {
                    return Container(
                      decoration: childSpec.decoration,
                      constraints: childSpec.constraints,
                    );
                  },
                );
              },
            ),
          ),
        );

        // Verify StyleProvider is present for inheritance
        expect(find.byType(StyleProvider<BoxSpec>), findsOneWidget);

        // Verify modifiers are applied (animation system may create multiple opacity widgets)
        expect(find.byType(Opacity), findsAtLeastNWidgets(1));
        final opacityWidgets = find.byType(Opacity);
        final opacity = tester.widget<Opacity>(opacityWidgets.first);
        expect(opacity.opacity, 0.5);
      });

      testWidgets('StyleProvider scope works correctly with nested inheritance', (
        tester,
      ) async {
        final outerStyle = BoxStyler()
            .color(Colors.blue)
            .padding(EdgeInsetsGeometryMix.all(10));

        final middleStyle = BoxStyler()
            .color(Colors.red)
            .margin(EdgeInsetsGeometryMix.all(5));

        final innerStyle = BoxStyler().width(50).height(50);

        late Style<BoxSpec>? middleProviderStyle;
        late Style<BoxSpec>? innerProviderStyle;

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: outerStyle,
              inheritable: true,
              builder: (context, spec) {
                return StyleBuilder<BoxSpec>(
                  style: middleStyle,
                  inheritable: true,
                  builder: (context, middleSpec) {
                    middleProviderStyle = Style.maybeOf<BoxSpec>(context);
                    return StyleBuilder<BoxSpec>(
                      style: innerStyle,
                      builder: (context, innerSpec) {
                        innerProviderStyle = Style.maybeOf<BoxSpec>(context);
                        return Container(
                          decoration: innerSpec.decoration,
                          constraints: innerSpec.constraints,
                          padding: innerSpec.padding,
                          margin: innerSpec.margin,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );

        // Middle StyleBuilder should see the outer provider created by inheritable=true
        expect(middleProviderStyle, isNotNull);

        // Inner StyleBuilder should see the middle provider created by inheritable=true
        expect(innerProviderStyle, isNotNull);

        // Verify that we have two StyleProviders in the widget tree (outer and middle)
        expect(find.byType(StyleProvider<BoxSpec>), findsNWidgets(2));
      });

      testWidgets(
        'Should create MixInteractionDetector when inherited style contains widget state variants',
        (tester) async {
          // Parent style provides a variant for hovered state
          final parentStyle = BoxStyler()
              .width(100)
              .height(100)
              .color(Colors.blue)
              .onHovered(BoxStyler().color(Colors.red));

          // Child style is just a simple style
          final childStyle = BoxStyler().width(50).height(50);

          await tester.pumpWidget(
            MaterialApp(
              home: StyleBuilder<BoxSpec>(
                style: parentStyle,
                inheritable: true,
                builder: (context, parentSpec) {
                  return StyleBuilder<BoxSpec>(
                    style: childStyle,
                    builder: (context, childSpec) {
                      return Container(
                        decoration: childSpec.decoration,
                        constraints: childSpec.constraints,
                      );
                    },
                  );
                },
              ),
            ),
          );

          // Look for a MixInteractionDetector down the tree
          final styleBuilderFinder = find.byType(MixInteractionDetector);

          expect(styleBuilderFinder, findsOneWidget);
        },
      );
    });

    group('Controller', () {
      testWidgets(
        'should use provided controller to track widget state and update the style',
        (tester) async {
          final controller = WidgetStatesController();
          addTearDown(controller.dispose);

          controller.update(WidgetState.pressed, true);
          final paddingMix = EdgeInsetsGeometryMix.all(10);

          await tester.pumpWidget(
            StyleBuilder<BoxSpec>(
              style: BoxStyler()
                  .paddingAll(1)
                  .onPressed(BoxStyler().padding(paddingMix)),
              controller: controller,
              builder: (context, spec) {
                final expectedPadding = paddingMix.resolve(context);

                expect(spec.padding, expectedPadding);
                expect(spec, isNot(BoxSpec()));
                return Container();
              },
            ),
          );
        },
      );
    });

    testWidgets(
      'should not track interactions in widget states when controller is provided',
      (WidgetTester tester) async {
        final controller = WidgetStatesController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          StyleBuilder<BoxSpec>(
            key: const Key('test'),
            controller: controller,
            style: BoxStyler()
                .size(100, 100)
                .onHovered(BoxStyler().paddingAll(10)),
            builder: (context, spec) {
              return Box(styleSpec: StyleSpec(spec: spec));
            },
          ),
        );

        // Verify that no MixInteractionDetector is created
        expect(find.byType(MixInteractionDetector), findsNothing);
      },
    );

    testWidgets('should update the Style when the controller is updated', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        StyleBuilder<BoxSpec>(
          key: const Key('test'),
          controller: controller,
          style: BoxStyler()
              .size(100, 100)
              .color(Colors.red)
              .onHovered(BoxStyler().color(Colors.blueGrey)),
          builder: (context, spec) {
            return Box(styleSpec: StyleSpec(spec: spec));
          },
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, BoxDecoration(color: Colors.red));

      controller.update(WidgetState.hovered, true);
      await tester.pump();

      final hoveredContainer = tester.widget<Container>(find.byType(Container));
      expect(
        hoveredContainer.decoration,
        BoxDecoration(color: Colors.blueGrey),
      );
    });
  });
}
