// Import necessary packages
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  const onPressed = OnPressVariant();
  const onFocused = OnFocusedVariant();
  const onEnabled = OnNotVariant(OnDisabledVariant());
  const onDisabled = OnDisabledVariant();
  const onHover = OnHoverVariant();
  group('Pressable Util', () {
    const attribute1 = MockBooleanScalarAttribute(true);
    const attribute2 = MockStringScalarAttribute('attribute2');
    const attribute3 = MockIntScalarAttribute(3);
    testWidgets('press state', (tester) async {
      await tester.pumpWithPressable(Container(), pressed: true, focused: true);

      final context = tester.element(find.byType(Container));

      final onPressAttr = onPressed(attribute1, attribute2, attribute3);

      expect(onPressAttr.variant.when(context), true);
      expect(onPressAttr.value, Style(attribute1, attribute2, attribute3));

      expect(onPressAttr.variant.when(context), true);
    });

    testWidgets('hover state', (tester) async {
      await tester.pumpWithPressable(Container(), hovered: true, focused: true);

      final context = tester.element(find.byType(Container));

      final onHoverAttr = onHover(attribute1, attribute2, attribute3);

      expect(onHoverAttr.value, Style(attribute1, attribute2, attribute3));

      expect(onHoverAttr.variant.when(context), true);
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpWithPressable(
        Container(),
        disabled: true,
        focused: true,
      );

      final context = tester.element(find.byType(Container));

      final onDisabledAttr = onDisabled(attribute1, attribute2, attribute3);

      expect(onDisabledAttr.value, Style(attribute1, attribute2, attribute3));

      expect(onDisabledAttr.variant.when(context), true);
    });

    // onEnabled
    testWidgets('enabled state', (tester) async {
      await tester.pumpWithPressable(
        Container(),
        disabled: false,
        focused: true,
      );

      final context = tester.element(find.byType(Container));

      final onEnabledAttr = onEnabled(attribute1, attribute2, attribute3);

      expect(onEnabledAttr.value, Style(attribute1, attribute2, attribute3));

      expect(onEnabledAttr.variant.when(context), true);
    });

    // onFocus
    testWidgets('focus state', (tester) async {
      await tester.pumpWithPressable(Container(), pressed: true, focused: true);

      final context = tester.element(find.byType(Container));

      final onFocusAttr = onFocused(attribute1, attribute2, attribute3);

      expect(onFocusAttr.value, Style(attribute1, attribute2, attribute3));

      expect(onFocusAttr.variant.when(context), true);
    });
  });
}
