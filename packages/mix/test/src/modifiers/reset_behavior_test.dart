import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Reset behavior (merge + resolve filtering)', () {
    test(
      'merge clears when reset is encountered in other and reset is not included',
      () {
        final current = ModifierConfig.modifiers([
          OpacityWidgetModifierMix(opacity: 0.2),
          AlignWidgetModifierMix(alignment: Alignment.center),
        ]);

        final other = ModifierConfig.modifiers([
          const ResetWidgetModifierMix(),
          PaddingWidgetModifierMix(padding: EdgeInsetsDirectionalMix(top: 8.0)),
          OpacityWidgetModifierMix(opacity: 0.8),
        ]);

        final merged = current.merge(other);
        final resolved = merged.resolve(MockBuildContext());

        // Ensure no reset present in resolved modifiers
        final hasReset = resolved.any(
          (m) =>
              m is LegacyModifierAdapter &&
              m.props.first is ResetWidgetModifier,
        );
        expect(hasReset, isFalse);

        // Ensure previous modifiers are cleared and only post-reset ones remain
        // Expect to find Padding and Opacity (0.8), not the initial Align or Opacity (0.2)
        final types = resolved
            .map(
              (m) => m is LegacyModifierAdapter
                  ? m.props.first.runtimeType
                  : m.runtimeType,
            )
            .toList();

        expect(types.contains(PaddingWidgetModifier), isTrue);
        expect(types.contains(OpacityWidgetModifier), isTrue);
        expect(types.contains(AlignWidgetModifier), isFalse);
      },
    );

    test(
      'merge clears when reset is encountered in current list and continues',
      () {
        final current = ModifierConfig.modifiers([
          OpacityWidgetModifierMix(opacity: 0.2),
          const ResetWidgetModifierMix(),
          AlignWidgetModifierMix(alignment: Alignment.centerRight),
        ]);

        final other = ModifierConfig.modifiers([
          PaddingWidgetModifierMix(
            padding: EdgeInsetsDirectionalMix(bottom: 4.0),
          ),
        ]);

        final merged = current.merge(other);
        final resolved = merged.resolve(MockBuildContext());

        // Ensure no reset present
        final hasReset = resolved.any(
          (m) =>
              m is LegacyModifierAdapter &&
              m.props.first is ResetWidgetModifier,
        );
        expect(hasReset, isFalse);

        // After reset in current, Opacity (0.2) is cleared; Align (after reset) remains,
        // and Padding from other is merged in.
        final types = resolved
            .map(
              (m) => m is LegacyModifierAdapter
                  ? m.props.first.runtimeType
                  : m.runtimeType,
            )
            .toList();

        expect(types.contains(OpacityWidgetModifier), isFalse);
        expect(types.contains(AlignWidgetModifier), isTrue);
        expect(types.contains(PaddingWidgetModifier), isTrue);
      },
    );

    test('resolve filters out reset when present alone', () {
      final cfg = ModifierConfig.modifiers([const ResetWidgetModifierMix()]);

      final resolved = cfg.resolve(MockBuildContext());
      expect(resolved, isEmpty);
    });
  });
}
