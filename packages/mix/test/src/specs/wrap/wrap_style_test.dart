import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('WrapStyler', () {
    test('constructor resolves every Wrap field', () {
      final style = WrapStyler(
        direction: .vertical,
        alignment: .center,
        spacing: 6,
        runAlignment: .spaceBetween,
        runSpacing: 10,
        crossAxisAlignment: .end,
        textDirection: .rtl,
        verticalDirection: .up,
        clipBehavior: .antiAlias,
      );

      final spec = style.resolve(MockBuildContext()).spec;

      expect(spec.direction, Axis.vertical);
      expect(spec.alignment, WrapAlignment.center);
      expect(spec.spacing, 6);
      expect(spec.runAlignment, WrapAlignment.spaceBetween);
      expect(spec.runSpacing, 10);
      expect(spec.crossAxisAlignment, WrapCrossAlignment.end);
      expect(spec.textDirection, TextDirection.rtl);
      expect(spec.verticalDirection, VerticalDirection.up);
      expect(spec.clipBehavior, Clip.antiAlias);
    });

    test('mixin aliases and flow merge without losing prior fields', () {
      final style = WrapStyler(direction: .horizontal)
          .wrapAlignment(.end)
          .wrapClipBehavior(.hardEdge)
          .flow(
            WrapStyler(spacing: 8, runSpacing: 12, crossAxisAlignment: .center),
          );

      final spec = style.resolve(MockBuildContext()).spec;

      expect(spec.direction, Axis.horizontal);
      expect(spec.alignment, WrapAlignment.end);
      expect(spec.spacing, 8);
      expect(spec.runSpacing, 12);
      expect(spec.crossAxisAlignment, WrapCrossAlignment.center);
      expect(spec.clipBehavior, Clip.hardEdge);
    });

    test('named factories match their fluent methods', () {
      expect(
        WrapStyler.wrapAlignment(.center),
        WrapStyler().wrapAlignment(.center),
      );
      expect(
        WrapStyler.wrapClipBehavior(.antiAlias),
        WrapStyler().wrapClipBehavior(.antiAlias),
      );
      expect(WrapStyler.spacing(8), WrapStyler().spacing(8));
      expect(
        WrapStyler.runAlignment(.spaceAround),
        WrapStyler().runAlignment(.spaceAround),
      );
    });

    test('merge preserves variants, modifiers, and animation', () {
      final animation = AnimationConfig.linear(
        const Duration(milliseconds: 200),
      );
      final modifier = WidgetModifierConfig(
        modifiers: [OpacityModifierMix(opacity: 0.5)],
      );
      final variant = ContextVariant.brightness(.dark);

      final merged = WrapStyler(
        direction: .horizontal,
        modifier: modifier,
        variants: [VariantStyle(variant, WrapStyler(spacing: 4))],
      ).merge(WrapStyler(runSpacing: 8, animation: animation));

      expect(merged.$direction, isNotNull);
      expect(merged.$runSpacing, isNotNull);
      expect(merged.$variants, hasLength(1));
      expect(merged.$modifier, modifier);
      expect(merged.$animation, animation);
      expect(merged.props, hasLength(12));
    });
  });
}
