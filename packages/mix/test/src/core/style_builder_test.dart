import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('StyleBuilder', () {
    group('Basic functionality', () {
      testWidgets('Build from SpecAttribute', (tester) async {
        final boxAttribute = BoxSpecAttribute()
            .width(100)
            .height(200)
            .color(Colors.blue);

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder(
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
        final animation = AnimationConfig.linear(
          const Duration(milliseconds: 300),
        );
        final boxAttribute = BoxSpecAttribute.only(
          constraints: BoxConstraintsMix.only(
            minWidth: 100,
            maxWidth: 100,
            minHeight: 200,
            maxHeight: 200,
          ),
          decoration: BoxDecorationMix.only(color: Colors.blue),
          animation: animation,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder(
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
        expect(find.byType(ImplicitlyAnimatedWidget), findsOneWidget);
      });

      testWidgets('No animation driver when animation config is null', (
        tester,
      ) async {
        final boxAttribute = BoxSpecAttribute()
            .width(100)
            .height(200)
            .color(Colors.blue);

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder(
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
        expect(find.byType(ImplicitlyAnimatedWidget), findsNothing);
      });

      testWidgets('Animation interpolates between style changes', (
        tester,
      ) async {
        final animation = AnimationConfig.linear(
          const Duration(milliseconds: 300),
        );

        final startAttribute = BoxSpecAttribute.only(
          constraints: BoxConstraintsMix.only(
            minWidth: 100,
            maxWidth: 100,
            minHeight: 100,
            maxHeight: 100,
          ),
          decoration: BoxDecorationMix.only(color: Colors.blue),
          animation: animation,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder(
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
        final endAttribute = BoxSpecAttribute.only(
          constraints: BoxConstraintsMix.only(
            minWidth: 200,
            maxWidth: 200,
            minHeight: 200,
            maxHeight: 200,
          ),
          decoration: BoxDecorationMix.only(color: Colors.red),
          animation: animation,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder(
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

        // Pump halfway through animation
        await tester.pump(const Duration(milliseconds: 150));

        // The container should be somewhere between start and end values
        final container = tester.widget<Container>(
          find.byKey(const Key('animated_container')),
        );
        expect(container.constraints?.minWidth, isNot(100));
        expect(container.constraints?.minWidth, isNot(200));

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
      });
    });

    group('RenderModifiers', () {
      testWidgets('Modifiers are applied when present', (tester) async {
        final boxAttribute = BoxSpecAttribute.width(100)
            .height(100)
            .merge(
              BoxSpecAttribute.only(
                alignment: Alignment.center,
                decoration: BoxDecorationMix.only(
                  borderRadius: BorderRadiusGeometryMix.circular(10),
                ),
                modifiers: [
                  OpacityModifierAttribute(opacity: Prop(0.5)),
                  PaddingModifierAttribute.only(padding: EdgeInsetsMix.all(10)),
                ],
              ),
            );

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder(
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
        expect(find.byType(Padding), findsOneWidget);
        expect(find.byType(ClipOval), findsOneWidget);

        // Check opacity value
        final opacity = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacity.opacity, 0.5);

        // Check padding value
        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.all(10));
      });

      testWidgets('Modifiers follow default order', (tester) async {
        final boxAttribute = BoxSpecAttribute.width(100)
            .height(100)
            .merge(
              BoxSpecAttribute.only(
                decoration: BoxDecorationMix.only(color: Colors.blue),
              ),
            )
            .wrap
            .opacity(0.5)
            .wrap
            .padding(padding: EdgeInsetsMix.all(10))
            .wrap
            .visibility(true);

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder(
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
        final styleBuilder = find.byType(StyleBuilder);

        // Verify ordering: Visibility should wrap everything, then other modifiers in order
        // The default order has Visibility early, Padding after transformations, ClipOval near end, and Opacity last
        expect(
          find.descendant(of: styleBuilder, matching: find.byType(Visibility)),
          findsOneWidget,
        );

        expect(
          find.descendant(
            of: find.byType(Visibility),
            matching: find.byType(Padding),
          ),
          findsOneWidget,
        );

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
        final boxAttribute = BoxSpecAttribute.width(100)
            .height(100)
            .merge(
              BoxSpecAttribute.only(
                decoration: BoxDecorationMix.only(color: Colors.blue),
              ),
            )
            .wrap
            .opacity(0.5)
            .wrap
            .padding(padding: EdgeInsetsMix.all(10))
            .wrap
            .clipOval();

        const customOrder = [
          OpacityModifier,
          ClipOvalModifier,
          PaddingModifier,
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder(
              style: boxAttribute,
              orderOfModifiers: customOrder,
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
        final styleBuilder = find.byType(StyleBuilder);

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

        expect(
          find.descendant(
            of: find.byType(ClipOval),
            matching: find.byType(Padding),
          ),
          findsOneWidget,
        );
      });

      testWidgets('No RenderModifiers widget when no modifiers present', (
        tester,
      ) async {
        final boxAttribute = BoxSpecAttribute()
            .width(100)
            .height(100)
            .color(Colors.blue);

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder(
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
        expect(find.byType(Opacity), findsNothing);
        expect(find.byType(Padding), findsNothing);
        expect(find.byType(ClipOval), findsNothing);
        expect(find.byType(Visibility), findsNothing);
      });
    });
  });
}
