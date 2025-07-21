// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/modifiers/internal/render_widget_modifier.dart';

import '../../helpers/testing_utils.dart';

void main() {
  final style = Style(
    $with.scale(2.0),
    $with.opacity(0.5),
    $with.visibility.on(),
    $with.clipOval(),
    $with.aspectRatio(2.0),
    const CustomModifierAttribute(),
  );

  final mixData = MixContext.create(MockBuildContext(), style);

  group('RenderModifiers', () {
    testWidgets('Renders modifiers in the correct order', (tester) async {
      await tester.pumpMaterialApp(
        RenderModifiers(
          modifiers: mixData.modifiers,
          orderOfModifiers: const [],
          child: const Text('child'),
        ),
      );

      expect(find.byType(RenderModifiers), findsOneWidget);

      expect(
        find.descendant(
          of: find.byType(RenderModifiers),
          matching: find.byType(Visibility),
        ),
        findsOneWidget,
      );

      // Similarly, check for AspectRatio, Scale, Clip, and Opacity
      // Ensure each widget is a descendant of the previous one in the correct order
      final aspectRatioFinder = find.descendant(
        of: find.byType(Visibility),
        matching: find.byType(AspectRatio),
      );
      expect(aspectRatioFinder, findsOneWidget);

      final scaleFinder = find.descendant(
        of: aspectRatioFinder,
        matching: find.byType(Transform), // Assuming Scale uses Transform
      );
      expect(scaleFinder, findsOneWidget);

      final clipFinder = find.descendant(
        of: scaleFinder,
        matching: find.byType(ClipOval), // Assuming Clip uses ClipOval
      );
      expect(clipFinder, findsOneWidget);

      final opacityFinder = find.descendant(
        of: clipFinder,
        matching: find.byType(Opacity),
      );
      expect(opacityFinder, findsOneWidget);

      final customWidgetFinder = find.descendant(
        of: opacityFinder,
        matching: find.byType(Padding),
      );

      expect(customWidgetFinder, findsOneWidget);

      expect(
        find.descendant(of: customWidgetFinder, matching: find.text('child')),
        findsOneWidget,
      );
    });

    testWidgets('Renders child when no modifiers are provided', (tester) async {
      final mixData = MixContext.create(MockBuildContext(), Style());

      await tester.pumpMaterialApp(
        RenderModifiers(
          modifiers: mixData.modifiers,
          orderOfModifiers: const [],
          child: const Text('child'),
        ),
      );

      expect(find.text('child'), findsOneWidget);
      expect(find.byType(RenderModifiers), findsOneWidget);
    });

    testWidgets('Renders child when orderOfModifiers is empty', (tester) async {
      final mixData = MixContext.create(MockBuildContext(), style);

      await tester.pumpMaterialApp(
        RenderModifiers(
          modifiers: mixData.modifiers,
          orderOfModifiers: const [],
          child: const Text('child'),
        ),
      );

      expect(find.text('child'), findsOneWidget);
      expect(find.byType(RenderModifiers), findsOneWidget);
    });

    testWidgets('Renders modifiers in the correct order with many overrides', (
      tester,
    ) async {
      await tester.pumpMaterialApp(
        RenderModifiers(
          modifiers: mixData.modifiers,
          orderOfModifiers: const [
            ClipOvalModifierSpecAttribute,
            AspectRatioModifierSpecAttribute,
            TransformModifierSpecAttribute,
            OpacityModifierSpecAttribute,
            VisibilityModifierSpecAttribute,
          ],
          mix: mixData,
          child: const Text('child'),
        ),
      );

      expect(find.byType(RenderModifiers), findsOneWidget);

      expect(
        find.descendant(
          of: find.byType(RenderModifiers),
          matching: find.byType(ClipOval),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byType(ClipOval),
          matching: find.byType(AspectRatio),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byType(AspectRatio),
          matching: find.byType(Transform),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byType(Transform),
          matching: find.byType(Opacity),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byType(Opacity),
          matching: find.byType(Padding),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(of: find.byType(Padding), matching: find.text('child')),
        findsOneWidget,
      );
    });

    //  Allow for only a few overrides
    testWidgets('Renders modifiers in the correct order with a few overrides', (
      tester,
    ) async {
      await tester.pumpMaterialApp(
        RenderModifiers(
          mix: mixData,
          modifiers: mixData.modifiers,
          orderOfModifiers: const [
            ClipOvalModifierSpecAttribute,
            AspectRatioModifierSpecAttribute,
          ],
          child: const Text('child'),
        ),
      );

      expect(find.byType(RenderModifiers), findsOneWidget);

      expect(
        find.descendant(
          of: find.byType(RenderModifiers),
          matching: find.byType(ClipOval),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byType(ClipOval),
          matching: find.byType(AspectRatio),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byType(AspectRatio),
          matching: find.byType(Visibility),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byType(Visibility),
          matching: find.byType(Transform),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byType(Transform),
          matching: find.byType(Opacity),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byType(Opacity),
          matching: find.byType(Padding),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(of: find.byType(Padding), matching: find.text('child')),
        findsOneWidget,
      );
    });
  });

  group('RenderAnimatedModifiers', () {
    testWidgets('Renders animated modifiers', (tester) async {
      final mixData = MixContext.create(MockBuildContext(), style);

      await tester.pumpMaterialApp(
        RenderAnimatedModifiers(
          modifiers: mixData.modifiers,
          orderOfModifiers: const [],
          duration: const Duration(milliseconds: 300),
          child: const Text('child'),
        ),
      );

      expect(find.text('child'), findsOneWidget);
      expect(find.byType(RenderAnimatedModifiers), findsOneWidget);

      // Trigger animation and pump frames
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 150));
    });

    testWidgets('Renders animated modifiers', (tester) async {
      await tester.pumpWidget(
        _TestableAnimatedModifiers(
          (isActive) => RenderAnimatedModifiers(
            duration: const Duration(milliseconds: 200),
            orderOfModifiers: const [],
            modifiers: [
              OpacityModifier(isActive ? 1.0 : 0.0),
              SizedBoxModifier(
                height: isActive ? 50.0 : 0.0,
                width: isActive ? 50.0 : 0.0,
              ),
            ],
            child: Container(),
          ),
        ),
      );

      final gestureFinder = find.byType(GestureDetector);
      expect(gestureFinder, findsOneWidget);

      final finder = find.byType(Opacity);
      expect(finder, findsOneWidget);

      final finderSizedBox = find.byType(SizedBox);
      expect(finderSizedBox, findsOneWidget);

      await tester.tap(gestureFinder);
      await tester.pump();

      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.widget<Opacity>(finder).opacity, 0.5);
      expect(tester.widget<SizedBox>(finderSizedBox).height, 25);
      expect(tester.widget<SizedBox>(finderSizedBox).width, 25);

      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.widget<Opacity>(finder).opacity, 0.0);
      expect(tester.widget<SizedBox>(finderSizedBox).height, 0);
      expect(tester.widget<SizedBox>(finderSizedBox).width, 0);
    });

    testWidgets('Transition correctly when there is conditional specs', (
      tester,
    ) async {
      gestureFinder() => find.byType(GestureDetector);

      await tester.pumpWidget(
        _TestableAnimatedModifiers(
          (isActive) => RenderAnimatedModifiers(
            duration: const Duration(milliseconds: 200),
            orderOfModifiers: const [],
            modifiers: [
              const OpacityModifier(0.0),
              if (!isActive)
                TransformModifier(transform: Matrix4.rotationZ(0.5)),
            ],
            child: Container(),
          ),
        ),
      );

      expect(find.byType(Opacity), findsOneWidget);
      expect(find.byType(Transform), findsNothing);

      await tester.tap(gestureFinder());
      await tester.pump();

      expect(find.byType(Opacity), findsOneWidget);
      expect(find.byType(Transform), findsOneWidget);
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      await tester.tap(gestureFinder());
      await tester.pump();

      expect(find.byType(Opacity), findsOneWidget);
      expect(find.byType(Transform), findsNothing);
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
    });

    testWidgets('override default orderOfModifiers using MixScope', (
      tester,
    ) async {
      await tester.pumpWithMixScope(
        Box(
          style: Style(
            $with.scale(2),
            $with.clipRect(),
            $with.sizedBox.square(100),
          ).animate(),
        ),
        theme: MixScopeData.static(
          defaultOrderOfModifiers: const [
            SizedBoxModifier,
            ClipRectModifierSpec,
            TransformModifier,
          ],
        ),
      );

      final firstFinder = find.byType(SizedBox);
      expect(firstFinder, findsOneWidget);

      final secondFinder = find.descendant(
        of: firstFinder,
        matching: find.byType(ClipRect),
      );

      expect(secondFinder, findsOneWidget);

      final thirdFinder = find.descendant(
        of: secondFinder,
        matching: find.byType(Transform),
      );

      expect(thirdFinder, findsOneWidget);
    });
  });

  group('Modifiers attributes', () {
    testWidgets(
      'should be applied to the first one. The children wont inherit even though the second one is set to inherit',
      (tester) async {
        const key = Key('box');

        await tester.pumpStyledWidget(
          Box(
            style: Style(
              $with.scale(2.0),
              $with.opacity(0.5),
              $with.visibility.on(),
              $with.clipOval(),
              $with.aspectRatio(2.0),
            ),
            child: Box(
              key: key,
              inherit: true,
              child: Builder(
                builder: (context) {
                  final inheritedMix = MixProvider.maybeOf(context)!;

                  expect(inheritedMix.attributes.length, 0);

                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(
          find.descendant(
            of: find.byKey(key),
            matching: find.byType(Transform),
          ),
          findsNothing,
        );

        expect(
          find.descendant(of: find.byKey(key), matching: find.byType(Opacity)),
          findsNothing,
        );

        expect(
          find.descendant(
            of: find.byKey(key),
            matching: find.byType(RotatedBox),
          ),
          findsNothing,
        );

        expect(
          find.descendant(
            of: find.byKey(key),
            matching: find.byType(Visibility),
          ),
          findsNothing,
        );

        expect(
          find.descendant(
            of: find.byKey(key),
            matching: find.byType(AspectRatio),
          ),
          findsNothing,
        );
      },
    );

    testWidgets(
      'If there are no modifier attributes in Style, RenderModifierAttributes shouldnt exist in the widget tree',
      (tester) async {
        const key = Key('box');

        await tester.pumpStyledWidget(
          Box(
            style: Style($box.color.red(), $box.height(100), $box.width(100)),
            key: key,
          ),
        );

        expect(
          find.ancestor(
            of: find.byKey(key),
            matching: find.byType(RenderModifiers),
          ),
          findsNothing,
        );
      },
    );
  });
}

class _TestableAnimatedModifiers extends StatefulWidget {
  const _TestableAnimatedModifiers(this.child);

  final Widget Function(bool) child;

  @override
  State<_TestableAnimatedModifiers> createState() =>
      _TestableAnimatedModifiersState();
}

class _TestableAnimatedModifiersState
    extends State<_TestableAnimatedModifiers> {
  bool _isActive = true;

  void _handleToggle() {
    setState(() {
      _isActive = !_isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Pressable(onPress: _handleToggle, child: widget.child(_isActive));
  }
}
