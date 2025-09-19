import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Reset behavior (merge + resolve filtering)', () {
    test(
      'merge clears when reset is encountered in other and reset is not included',
      () {
        final current = WidgetModifierConfig.modifiers([
          OpacityModifierMix(opacity: 0.2),
          AlignModifierMix(alignment: Alignment.center),
        ]);

        final other = WidgetModifierConfig.modifiers([
          const ResetModifierMix(),
          PaddingModifierMix(padding: EdgeInsetsDirectionalMix(top: 8.0)),
          OpacityModifierMix(opacity: 0.8),
        ]);

        final merged = current.merge(other);
        final resolved = merged.resolve(MockBuildContext());

        // Ensure no reset present in resolved modifiers
        final hasReset = resolved.any((m) => m is ResetModifier);
        expect(hasReset, isFalse);

        // Ensure previous modifiers are cleared and only post-reset ones remain
        // Expect to find Padding and Opacity (0.8), not the initial Align or Opacity (0.2)
        final types = resolved.map((m) => m.runtimeType).toList();

        expect(types.contains(PaddingModifier), isTrue);
        expect(types.contains(OpacityModifier), isTrue);
        expect(types.contains(AlignModifier), isFalse);
      },
    );

    test(
      'merge clears when reset is encountered in current list and continues',
      () {
        final current = WidgetModifierConfig.modifiers([
          OpacityModifierMix(opacity: 0.2),
          const ResetModifierMix(),
          AlignModifierMix(alignment: Alignment.centerRight),
        ]);

        final other = WidgetModifierConfig.modifiers([
          PaddingModifierMix(padding: EdgeInsetsDirectionalMix(bottom: 4.0)),
        ]);

        final merged = current.merge(other);
        final resolved = merged.resolve(MockBuildContext());

        // Ensure no reset present
        final hasReset = resolved.any((m) => m is ResetModifier);
        expect(hasReset, isFalse);

        // After reset in current, Opacity (0.2) is cleared; Align (after reset) remains,
        // and Padding from other is merged in.
        final types = resolved.map((m) => m.runtimeType).toList();

        expect(types.contains(OpacityModifier), isFalse);
        expect(types.contains(AlignModifier), isTrue);
        expect(types.contains(PaddingModifier), isTrue);
      },
    );

    test('resolve filters out reset when present alone', () {
      final cfg = WidgetModifierConfig.modifiers([const ResetModifierMix()]);

      final resolved = cfg.resolve(MockBuildContext());
      expect(resolved, isEmpty);
    });
  });
}
