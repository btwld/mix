import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/core/widget_state/internal/interactive_mix_state.dart';
import 'package:mix/src/core/widget_state/internal/mouse_region_mix_state.dart';
import 'package:mix/src/modifiers/internal/render_widget_modifier.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('SpecBuilder', () {
    testWidgets(
      r'should access parent style attributes if inherit is true, otherwise should not',
      (tester) async {
        for (var inherit in [true, false]) {
          double? inheritedValue;

          await tester.pumpWidget(
            Box(
              style: Style($box.height(100)),
              child: SpecBuilder(
                inherit: inherit,
                builder: (context) {
                  final mix = MixProvider.of(context);
                  inheritedValue = mix.attributeOf<BoxSpecAttribute>()?.height;

                  return const SizedBox();
                },
              ),
            ),
          );

          expect(inheritedValue, inherit ? 100 : null);
        }
      },
    );

    testWidgets(
      'should have no attributes in MixData when a parent SpecBuilder has no Style',
      (tester) async {
        tester.pumpWidget(
          SpecBuilder(
            builder: (context) {
              final mix = MixProvider.of(context);
              expect(mix.attributes.length, isZero);
              return const SizedBox();
            },
          ),
        );
      },
    );

    testWidgets(
      'should have the same attributes in MixData as the parent StyledWidget when inherit is true',
      (tester) async {
        final style = Style(
          $box.height(100),
          $box.width(100),
          $box.color(Colors.red),
        );

        final mixData = MixContext.create(MockBuildContext(), style);

        tester.pumpWidget(
          SpecBuilder(
            inherit: true,
            style: style,
            builder: (context) {
              final mix = MixProvider.of(context);
              expect(mixData, mix);
              return const SizedBox();
            },
          ),
        );
      },
    );

    testWidgets(
      'should wrap the child with Interactable when a controller is provided',
      (tester) async {
        final controller = WidgetStatesController();
        await tester.pumpWidget(
          SpecBuilder(
            controller: controller,
            builder: (context) => const SizedBox(),
          ),
        );

        expect(find.byType(Interactable), findsOneWidget);
      },
    );

    testWidgets(
      'should wrap the child with Interactable when a style with MixWidgetStateVariant is provided',
      (tester) async {
        await tester.pumpWidget(
          SpecBuilder(
            style: Style(
              $box.color(Colors.red),
              $on.press($box.color(Colors.blue)),
            ),
            builder: (context) => const SizedBox(),
          ),
        );

        expect(find.byType(InteractiveMixStateWidget), findsOneWidget);
      },
    );

    // Create a test that already has a Interactable and ther is only one InteractiveMixStateWidget
    testWidgets(
      'should not wrap the child with Interactable when a controller and a style with MixWidgetStateVariant are provided',
      (tester) async {
        final key = GlobalKey();
        await tester.pumpWidget(
          Interactable(
            key: key,
            child: SpecBuilder(
              style: Style(
                $box.color(Colors.red),
                $on.press($box.color(Colors.blue)),
              ),
              builder: (context) => const SizedBox(),
            ),
          ),
        );

        final interactableFinder = find.descendant(
          of: find.byKey(key),
          matching: find.byType(Interactable),
        );

        expect(interactableFinder, findsNothing);
      },
    );

    testWidgets(
      'should wrap the child with MouseRegionMixStateWidget when a style with OnHoverVariant is provided',
      (tester) async {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;

        await tester.pumpWidget(
          Center(
            child: SpecBuilder(
              style: Style(
                $box.color(Colors.red),
                $box.width(100),
                $box.height(100),
                $on.hover(
                  $box.color(Colors.blue),
                  $box.width(200),
                  $box.height(200),
                ),
              ),
              builder: (context) => const Box(inherit: true),
            ),
          ),
        );

        final boxFinder = find.byType(Box);

        // Simulate a hover event
        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: tester.getCenter(boxFinder));
        await tester.pumpAndSettle();

        // Check if the color of the Box is blue
        final boxSpec = BoxSpec.of(tester.element(boxFinder));
        expect((boxSpec.decoration as BoxDecoration).color, Colors.blue);
        expect(boxSpec.width, 200);
        expect(boxSpec.height, 200);

        await gesture.removePointer();

        expect(find.byType(MouseRegionMixStateWidget), findsOneWidget);
        expect(find.byType(Interactable), findsOneWidget);
      },
    );

    //  do not add interactive mix state if its not needed
    testWidgets(
      'should not wrap the child with Interactable when a controller and a style with MixWidgetStateVariant are provided',
      (tester) async {
        await tester.pumpWidget(
          SpecBuilder(
            style: Style($box.color(Colors.red)),
            builder: (context) => const SizedBox(),
          ),
        );

        expect(find.byType(Interactable), findsNothing);
      },
    );

    testWidgets(
      'should wrap the child with Interactable when a controller and no MixWidgetState InheritedModel are provided',
      (tester) async {
        await tester.pumpWidget(
          SpecBuilder(
            controller: WidgetStatesController(),
            style: Style($box.color(Colors.red)),
            builder: (context) => const SizedBox(),
          ),
        );

        expect(find.byType(Interactable), findsOneWidget);
      },
    );

    testWidgets(
      'should use RenderAnimatedModifiers when a style with modifiers is animated',
      (tester) async {
        await tester.pumpWidget(
          SpecBuilder(
            style: Style($with.scale(2.0)).animate(),
            builder: (context) => const SizedBox(),
          ),
        );

        expect(find.byType(RenderAnimatedModifiers), findsOneWidget);
      },
    );

    testWidgets(
      'should use RenderModifiers when a style with modifiers is not animated',
      (tester) async {
        await tester.pumpWidget(
          SpecBuilder(
            style: Style($with.scale(2.0)),
            builder: (context) => const SizedBox(),
          ),
        );

        expect(find.byType(RenderModifiers), findsOneWidget);
      },
    );

    testWidgets(
      'should have attributes in MixData matching the SpecUtility that was passed to the SpecBuilder',
      (tester) async {
        tester.pumpWidget(
          SpecBuilder(
            style: $box
              ..height(100)
              ..width(100),
            builder: (context) {
              final mix = MixProvider.of(context);
              expect(mix.attributes.length, 1);
              expect(
                mix.attributes.values.first,
                isA<BoxSpecAttribute>()
                    .having((attribute) => attribute.height, 'height', 100)
                    .having((attribute) => attribute.width, 'width', 100),
              );
              return const SizedBox();
            },
          ),
        );
      },
    );
  });
}
