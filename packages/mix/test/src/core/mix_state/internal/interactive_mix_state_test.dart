import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/widget_state/internal/mix_widget_state_builder.dart';
import 'package:mix/src/core/widget_state/widget_state_controller.dart';

void main() {
  group('InteractiveMixState', () {
    testWidgets('should update enabled state', (WidgetTester tester) async {
      final controller = WidgetStatesController();

      controller.disabled = true;
      await tester.pumpWidget(
        MixWidgetStateBuilder(
            controller: controller, builder: (_) => Container()),
      );

      var context = tester.element(find.byType(Container));

      expect(
        MixWidgetState.hasStateOf(context, WidgetState.disabled),
        isTrue,
      );

      controller.disabled = false;

      await tester.pump();

      context = tester.element(find.byType(Container));

      expect(MixWidgetState.hasStateOf(context, WidgetState.disabled), isFalse);
    });

    testWidgets('should update focused state', (WidgetTester tester) async {
      final controller = WidgetStatesController();
      controller.focused = true;
      await tester.pumpWidget(
        MixWidgetStateBuilder(
            controller: controller, builder: (_) => Container()),
      );

      var context = tester.element(find.byType(Container));
      expect(
        MixWidgetState.hasStateOf(context, WidgetState.focused),
        isTrue,
      );

      controller.focused = false;

      await tester.pump();

      context = tester.element(find.byType(Container));

      expect(MixWidgetState.hasStateOf(context, WidgetState.focused), isFalse);
    });

    testWidgets('should update hovered state', (WidgetTester tester) async {
      final controller = WidgetStatesController();

      controller.hovered = true;

      await tester.pumpWidget(
        MixWidgetStateBuilder(
            controller: controller, builder: (_) => Container()),
      );

      var context = tester.element(find.byType(Container));
      expect(MixWidgetState.hasStateOf(context, WidgetState.hovered), isTrue);

      controller.hovered = false;

      await tester.pump();

      context = tester.element(find.byType(Container));

      expect(MixWidgetState.hasStateOf(context, WidgetState.hovered), isFalse);
    });
  });
}
