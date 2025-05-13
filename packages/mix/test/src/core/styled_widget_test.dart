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
        '''When a parent StyledWidget has a Style and inherited property is true, the SpecBuilder.builder should have access to the parent's style attributes in the MixData''',
        (tester) async {
      tester.pumpWidget(
        Box(
          style: Style($box.height(100)),
          child: SpecBuilder(
            inherit: true,
            builder: (context) {
              final mix = Mix.of(context);
              expect(mix.attributeOf<BoxSpecAttribute>()!.height, 100);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets(
      '''When a parent StyledWidget has a Style and inherited property is false, the SpecBuilder.builder should not have access to the parent's style attributes in the MixData''',
      (tester) async {
        tester.pumpWidget(
          Box(
            style: Style($box.height(100)),
            child: SpecBuilder(
              inherit: false,
              builder: (context) {
                final mix = Mix.of(context);
                expect(mix.attributeOf<BoxSpecAttribute>(), isNull);
                return const SizedBox();
              },
            ),
          ),
        );
      },
    );

    testWidgets(
      '''When a parent SpecBuilder has no Style, the MixData in SpecBuilder.builder should have no attributes''',
      (tester) async {
        tester.pumpWidget(
          SpecBuilder(
            builder: (context) {
              final mix = Mix.of(context);
              expect(mix.attributes.length, isZero);
              return const SizedBox();
            },
          ),
        );
      },
    );

    testWidgets(
      '''When a parent StyledWidget has a Style, the MixData in SpecBuilder.builder should have the same attributes''',
      (tester) async {
        final style = Style(
          $box.height(100),
          $box.width(100),
          $box.color(Colors.red),
        );

        final mixData = MixData.create(MockBuildContext(), style);

        tester.pumpWidget(
          SpecBuilder(
            inherit: true,
            style: style,
            builder: (context) {
              final mix = Mix.of(context);
              expect(mixData, mix);
              return const SizedBox();
            },
          ),
        );
      },
    );
    group('SpecBuilder', () {
      testWidgets(
        'When a SpecBuilder has a controller, it should wrap the child with Interactable',
        (tester) async {
          final controller = WidgetStatesController();
          await tester.pumpWidget(
            SpecBuilder(
              controller: controller,
              builder: (context) => const SizedBox(),
            ),
          );

          expect(find.byType(InteractiveMixStateWidget), findsOneWidget);
        },
      );

      testWidgets(
        'When a SpecBuilder has a style with MixWidgetStateVariant, it should wrap the child with Interactable',
        (tester) async {
          await tester.pumpWidget(
            SpecBuilder(
              style: Style(
                $box.color(
                  Colors.red,
                ),
                $on.press(
                  $box.color(Colors.blue),
                ),
              ),
              builder: (context) => const SizedBox(),
            ),
          );

          expect(find.byType(InteractiveMixStateWidget), findsOneWidget);
        },
      );

      testWidgets(
        'When a SpecBuilder has a style with OnHoverVariant, it should wrap the child with MouseRegionMixStateWidget',
        (tester) async {
          await tester.pumpWidget(
            SpecBuilder(
              style: Style(
                $box.color(Colors.red),
                $on.hover.event((event) {
                  return const Style.empty();
                }),
              ),
              builder: (context) => const SizedBox(),
            ),
          );

          expect(find.byType(MouseRegionMixStateWidget), findsOneWidget);
          expect(find.byType(InteractiveMixStateWidget), findsOneWidget);
        },
      );

      // Create a test that already has a Interactable and ther is only one InteractiveMixStateWidget
      testWidgets(
        'When a SpecBuilder has a controller and a style with MixWidgetStateVariant, it should wrap the child with Interactable',
        (tester) async {
          await tester.pumpWidget(
            Interactable(
              child: SpecBuilder(
                style: Style(
                  $box.color(
                    Colors.red,
                  ),
                  $on.press(
                    $box.color(Colors.blue),
                  ),
                ),
                builder: (context) => const SizedBox(),
              ),
            ),
          );

          expect(find.byType(InteractiveMixStateWidget), findsOneWidget);
        },
      );

      //  do not add interactive mix state if its not needed
      testWidgets(
        'When a SpecBuilder has a controller and a style with MixWidgetStateVariant, it should wrap the child with Interactable',
        (tester) async {
          await tester.pumpWidget(
            SpecBuilder(
              style: Style($box.color(Colors.red)),
              builder: (context) => const SizedBox(),
            ),
          );

          expect(find.byType(InteractiveMixStateWidget), findsNothing);
        },
      );

      testWidgets(
        'When a SpecBuilder has a controller it should wrap the widget',
        (tester) async {
          await tester.pumpWidget(
            SpecBuilder(
              controller: WidgetStatesController(),
              style: Style($box.color(Colors.red)),
              builder: (context) => const SizedBox(),
            ),
          );

          expect(find.byType(InteractiveMixStateWidget), findsOneWidget);
        },
      );

      testWidgets(
        'When a SpecBuilder has an animated style, it should use RenderAnimatedModifiers',
        (tester) async {
          await tester.pumpWidget(
            SpecBuilder(
              style: Style($box.color(Colors.red)).animate(),
              builder: (context) => const SizedBox(),
            ),
          );

          expect(find.byType(RenderAnimatedModifiers), findsOneWidget);
        },
      );

      testWidgets(
        'When a SpecBuilder has a non-animated style, it should use RenderModifiers',
        (tester) async {
          await tester.pumpWidget(
            SpecBuilder(
              style: Style($box.color(Colors.red)),
              builder: (context) => const SizedBox(),
            ),
          );

          expect(find.byType(RenderModifiers), findsOneWidget);
        },
      );
    });
  });
}
