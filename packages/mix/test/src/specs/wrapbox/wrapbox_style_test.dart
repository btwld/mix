import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('WrapBoxStyler', () {
    test('flattened constructor keeps Box and Wrap collisions distinct', () {
      final style = WrapBoxStyler(
        padding: EdgeInsetsMix.all(8),
        alignment: .bottomRight,
        clipBehavior: .antiAlias,
        direction: .vertical,
        wrapAlignment: .spaceBetween,
        spacing: 6,
        runAlignment: .center,
        runSpacing: 10,
        crossAxisAlignment: .end,
        textDirection: .rtl,
        verticalDirection: .up,
        wrapClipBehavior: .hardEdge,
      );

      final spec = style.resolve(MockBuildContext()).spec;

      expect(spec.box?.spec.padding, const EdgeInsets.all(8));
      expect(spec.box?.spec.alignment, Alignment.bottomRight);
      expect(spec.box?.spec.clipBehavior, Clip.antiAlias);
      expect(spec.flow?.spec.direction, Axis.vertical);
      expect(spec.flow?.spec.alignment, WrapAlignment.spaceBetween);
      expect(spec.flow?.spec.spacing, 6);
      expect(spec.flow?.spec.runAlignment, WrapAlignment.center);
      expect(spec.flow?.spec.runSpacing, 10);
      expect(spec.flow?.spec.crossAxisAlignment, WrapCrossAlignment.end);
      expect(spec.flow?.spec.textDirection, TextDirection.rtl);
      expect(spec.flow?.spec.verticalDirection, VerticalDirection.up);
      expect(spec.flow?.spec.clipBehavior, Clip.hardEdge);
    });

    test('fluent API and flow escape hatch merge into one Wrap spec', () {
      final style = WrapBoxStyler()
          .alignment(.centerLeft)
          .clipBehavior(.antiAlias)
          .direction(.horizontal)
          .spacing(8)
          .runSpacing(12)
          .wrapAlignment(.end)
          .wrapClipBehavior(.hardEdge)
          .flow(
            WrapStyler(runAlignment: .spaceAround, crossAxisAlignment: .center),
          );

      final spec = style.resolve(MockBuildContext()).spec;

      expect(spec.box?.spec.alignment, Alignment.centerLeft);
      expect(spec.box?.spec.clipBehavior, Clip.antiAlias);
      expect(spec.flow?.spec.direction, Axis.horizontal);
      expect(spec.flow?.spec.spacing, 8);
      expect(spec.flow?.spec.runSpacing, 12);
      expect(spec.flow?.spec.alignment, WrapAlignment.end);
      expect(spec.flow?.spec.runAlignment, WrapAlignment.spaceAround);
      expect(spec.flow?.spec.crossAxisAlignment, WrapCrossAlignment.center);
      expect(spec.flow?.spec.clipBehavior, Clip.hardEdge);
    });

    test('named factories match collision-aware fluent methods', () {
      expect(
        WrapBoxStyler.alignment(.center),
        WrapBoxStyler().alignment(.center),
      );
      expect(
        WrapBoxStyler.clipBehavior(.antiAlias),
        WrapBoxStyler().clipBehavior(.antiAlias),
      );
      expect(
        WrapBoxStyler.wrapAlignment(.center),
        WrapBoxStyler().wrapAlignment(.center),
      );
      expect(
        WrapBoxStyler.wrapClipBehavior(.hardEdge),
        WrapBoxStyler().wrapClipBehavior(.hardEdge),
      );
      expect(WrapBoxStyler.spacing(8), WrapBoxStyler().spacing(8));
    });

    test('merge preserves variants, modifiers, and animations', () {
      final animation = AnimationConfig.linear(
        const Duration(milliseconds: 250),
      );
      final modifier = WidgetModifierConfig(
        modifiers: [OpacityModifierMix(opacity: 0.75)],
      );
      final variant = ContextVariant.brightness(.dark);

      final merged = WrapBoxStyler(
        padding: EdgeInsetsMix.all(4),
        modifier: modifier,
        variants: [VariantStyle(variant, WrapBoxStyler(spacing: 2))],
      ).merge(WrapBoxStyler(runSpacing: 6, animation: animation));

      expect(merged.$box, isNotNull);
      expect(merged.$flow, isNotNull);
      expect(merged.$variants, hasLength(1));
      expect(merged.$modifier, modifier);
      expect(merged.$animation, animation);
      expect(merged.props, hasLength(5));
    });

    test('call creates a WrapBox with the styler and children', () {
      final style = WrapBoxStyler.spacing(8);
      final widget = style(children: const [SizedBox(key: Key('child'))]);

      expect(widget, isA<WrapBox>());
      expect(widget.style, same(style));
      expect(widget.children, hasLength(1));
    });
  });
}
