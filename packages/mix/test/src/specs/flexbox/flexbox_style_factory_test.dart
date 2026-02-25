import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('FlexBoxStyler factory constructors', () {
    group('dot-shorthand resolution', () {
      test('factory resolves via dot-shorthand typed assignment', () {
        FlexBoxStyler styler = FlexBoxStyler.color(Colors.red);
        expect(styler.$box, isNotNull);
      });

      test('chaining after factory constructor works', () {
        final styler = FlexBoxStyler.color(
          Colors.red,
        ).paddingAll(16).borderRounded(8);
        expect(styler.$box, isNotNull);
      });
    });

    group('factory matches instance method', () {
      // Direct constructor param factories
      test('alignment', () {
        expect(
          FlexBoxStyler.alignment(Alignment.center),
          equals(FlexBoxStyler(alignment: Alignment.center)),
        );
      });

      test('padding', () {
        final mix = EdgeInsetsGeometryMix.all(16);
        expect(FlexBoxStyler.padding(mix), equals(FlexBoxStyler(padding: mix)));
      });

      test('margin', () {
        final mix = EdgeInsetsGeometryMix.all(8);
        expect(FlexBoxStyler.margin(mix), equals(FlexBoxStyler(margin: mix)));
      });

      test('constraints', () {
        final mix = BoxConstraintsMix(minWidth: 100, maxWidth: 200);
        expect(
          FlexBoxStyler.constraints(mix),
          equals(FlexBoxStyler(constraints: mix)),
        );
      });

      test('decoration', () {
        final mix = DecorationMix.color(Colors.red);
        expect(
          FlexBoxStyler.decoration(mix),
          equals(FlexBoxStyler(decoration: mix)),
        );
      });

      test('foregroundDecoration', () {
        final mix = DecorationMix.color(Colors.blue);
        expect(
          FlexBoxStyler.foregroundDecoration(mix),
          equals(FlexBoxStyler(foregroundDecoration: mix)),
        );
      });

      test('clipBehavior', () {
        expect(
          FlexBoxStyler.clipBehavior(Clip.hardEdge),
          equals(FlexBoxStyler(clipBehavior: Clip.hardEdge)),
        );
      });

      test('direction', () {
        expect(
          FlexBoxStyler.direction(Axis.horizontal),
          equals(FlexBoxStyler(direction: Axis.horizontal)),
        );
      });

      test('mainAxisAlignment', () {
        expect(
          FlexBoxStyler.mainAxisAlignment(.center),
          equals(FlexBoxStyler(mainAxisAlignment: MainAxisAlignment.center)),
        );
      });

      test('crossAxisAlignment', () {
        expect(
          FlexBoxStyler.crossAxisAlignment(CrossAxisAlignment.stretch),
          equals(FlexBoxStyler(crossAxisAlignment: CrossAxisAlignment.stretch)),
        );
      });

      test('mainAxisSize', () {
        expect(
          FlexBoxStyler.mainAxisSize(MainAxisSize.min),
          equals(FlexBoxStyler(mainAxisSize: MainAxisSize.min)),
        );
      });

      test('spacing', () {
        expect(FlexBoxStyler.spacing(8), equals(FlexBoxStyler(spacing: 8)));
      });

      // Decoration convenience factories
      test('color', () {
        expect(
          FlexBoxStyler.color(Colors.blue),
          equals(FlexBoxStyler().color(Colors.blue)),
        );
      });

      test('gradient', () {
        final grad = LinearGradientMix(colors: [Colors.red, Colors.blue]);
        expect(
          FlexBoxStyler.gradient(grad),
          equals(FlexBoxStyler().gradient(grad)),
        );
      });

      test('border', () {
        final b = BoxBorderMix.all(BorderSideMix(color: Colors.red));
        expect(FlexBoxStyler.border(b), equals(FlexBoxStyler().border(b)));
      });

      test('borderRadius', () {
        final br = BorderRadiusMix.all(Radius.circular(8));
        expect(
          FlexBoxStyler.borderRadius(br),
          equals(FlexBoxStyler().borderRadius(br)),
        );
      });

      test('elevation', () {
        expect(
          FlexBoxStyler.elevation(ElevationShadow.one),
          equals(FlexBoxStyler().elevation(ElevationShadow.one)),
        );
      });

      // Spacing convenience factories
      test('paddingAll', () {
        expect(
          FlexBoxStyler.paddingAll(16),
          equals(FlexBoxStyler().paddingAll(16)),
        );
      });

      test('paddingX', () {
        expect(FlexBoxStyler.paddingX(8), equals(FlexBoxStyler().paddingX(8)));
      });

      test('paddingY', () {
        expect(FlexBoxStyler.paddingY(8), equals(FlexBoxStyler().paddingY(8)));
      });

      test('marginAll', () {
        expect(
          FlexBoxStyler.marginAll(12),
          equals(FlexBoxStyler().marginAll(12)),
        );
      });

      test('marginX', () {
        expect(FlexBoxStyler.marginX(6), equals(FlexBoxStyler().marginX(6)));
      });

      test('marginY', () {
        expect(FlexBoxStyler.marginY(6), equals(FlexBoxStyler().marginY(6)));
      });

      // Border radius convenience
      test('borderRounded', () {
        expect(
          FlexBoxStyler.borderRounded(12),
          equals(FlexBoxStyler().borderRounded(12)),
        );
      });

      // Constraints convenience factories
      test('width', () {
        expect(FlexBoxStyler.width(200), equals(FlexBoxStyler().width(200)));
      });

      test('height', () {
        expect(FlexBoxStyler.height(100), equals(FlexBoxStyler().height(100)));
      });

      test('size', () {
        expect(
          FlexBoxStyler.size(200, 100),
          equals(FlexBoxStyler().size(200, 100)),
        );
      });

      // Transform convenience factories
      test('scale', () {
        expect(FlexBoxStyler.scale(0.5), equals(FlexBoxStyler().scale(0.5)));
      });

      test('scale with alignment', () {
        expect(
          FlexBoxStyler.scale(0.5, alignment: Alignment.topLeft),
          equals(FlexBoxStyler().scale(0.5, alignment: Alignment.topLeft)),
        );
      });

      test('rotate', () {
        expect(FlexBoxStyler.rotate(0.5), equals(FlexBoxStyler().rotate(0.5)));
      });

      test('rotate with alignment', () {
        expect(
          FlexBoxStyler.rotate(0.5, alignment: Alignment.bottomRight),
          equals(FlexBoxStyler().rotate(0.5, alignment: Alignment.bottomRight)),
        );
      });

      // Preset factories
      test('row', () {
        expect(
          FlexBoxStyler.row(),
          equals(FlexBoxStyler(direction: Axis.horizontal)),
        );
      });

      test('column', () {
        expect(
          FlexBoxStyler.column(),
          equals(FlexBoxStyler(direction: Axis.vertical)),
        );
      });
    });

    group('resolved values', () {
      test('color resolves correctly', () {
        final styler = FlexBoxStyler.color(Colors.blue);
        expect(styler.$box, isNotNull);
      });

      test('paddingAll resolves correctly', () {
        final styler = FlexBoxStyler.paddingAll(16);
        expect(styler.$box, isNotNull);
      });
    });
  });
}
