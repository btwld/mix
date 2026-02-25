import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxStyler factory constructors', () {
    group('dot-shorthand resolution', () {
      test('factory resolves via dot-shorthand typed assignment', () {
        BoxStyler styler = BoxStyler.color(Colors.red);
        expect(styler.$decoration, isNotNull);
      });

      test('chaining after factory constructor works', () {
        final styler =
            BoxStyler.color(Colors.red).paddingAll(16).borderRounded(8);
        expect(styler.$decoration, isNotNull);
        expect(styler.$padding, isNotNull);
      });
    });

    group('factory matches instance method', () {
      // Direct constructor param factories
      test('alignment', () {
        expect(
          BoxStyler.alignment(Alignment.center),
          equals(BoxStyler().alignment(Alignment.center)),
        );
      });

      test('padding', () {
        final mix = EdgeInsetsGeometryMix.all(16);
        expect(BoxStyler.padding(mix), equals(BoxStyler().padding(mix)));
      });

      test('margin', () {
        final mix = EdgeInsetsGeometryMix.all(8);
        expect(BoxStyler.margin(mix), equals(BoxStyler().margin(mix)));
      });

      test('constraints', () {
        final mix = BoxConstraintsMix(minWidth: 100, maxWidth: 200);
        expect(
          BoxStyler.constraints(mix),
          equals(BoxStyler().constraints(mix)),
        );
      });

      test('decoration', () {
        final mix = DecorationMix.color(Colors.red);
        expect(
          BoxStyler.decoration(mix),
          equals(BoxStyler().decoration(mix)),
        );
      });

      test('foregroundDecoration', () {
        final mix = DecorationMix.color(Colors.blue);
        expect(
          BoxStyler.foregroundDecoration(mix),
          equals(BoxStyler().foregroundDecoration(mix)),
        );
      });

      test('clipBehavior', () {
        expect(
          BoxStyler.clipBehavior(Clip.hardEdge),
          equals(BoxStyler().clipBehavior(Clip.hardEdge)),
        );
      });

      // Decoration convenience factories
      test('color', () {
        expect(
          BoxStyler.color(Colors.blue),
          equals(BoxStyler().color(Colors.blue)),
        );
      });

      test('gradient', () {
        final grad = LinearGradientMix(colors: [Colors.red, Colors.blue]);
        expect(BoxStyler.gradient(grad), equals(BoxStyler().gradient(grad)));
      });

      test('border', () {
        final b = BoxBorderMix.all(BorderSideMix(color: Colors.red));
        expect(BoxStyler.border(b), equals(BoxStyler().border(b)));
      });

      test('borderRadius', () {
        final br = BorderRadiusMix.all(Radius.circular(8));
        expect(
          BoxStyler.borderRadius(br),
          equals(BoxStyler().borderRadius(br)),
        );
      });

      test('elevation', () {
        expect(
          BoxStyler.elevation(ElevationShadow.one),
          equals(BoxStyler().elevation(ElevationShadow.one)),
        );
      });

      // Spacing convenience factories
      test('paddingAll', () {
        expect(
          BoxStyler.paddingAll(16),
          equals(BoxStyler().paddingAll(16)),
        );
      });

      test('paddingX', () {
        expect(BoxStyler.paddingX(8), equals(BoxStyler().paddingX(8)));
      });

      test('paddingY', () {
        expect(BoxStyler.paddingY(8), equals(BoxStyler().paddingY(8)));
      });

      test('marginAll', () {
        expect(BoxStyler.marginAll(12), equals(BoxStyler().marginAll(12)));
      });

      test('marginX', () {
        expect(BoxStyler.marginX(6), equals(BoxStyler().marginX(6)));
      });

      test('marginY', () {
        expect(BoxStyler.marginY(6), equals(BoxStyler().marginY(6)));
      });

      // Border radius convenience
      test('borderRounded', () {
        expect(
          BoxStyler.borderRounded(12),
          equals(BoxStyler().borderRounded(12)),
        );
      });

      // Constraints convenience factories
      test('width', () {
        expect(BoxStyler.width(200), equals(BoxStyler().width(200)));
      });

      test('height', () {
        expect(BoxStyler.height(100), equals(BoxStyler().height(100)));
      });

      test('size', () {
        expect(
          BoxStyler.size(200, 100),
          equals(BoxStyler().size(200, 100)),
        );
      });

      // Transform convenience factories
      test('scale', () {
        expect(BoxStyler.scale(0.5), equals(BoxStyler().scale(0.5)));
      });

      test('scale with alignment', () {
        expect(
          BoxStyler.scale(0.5, alignment: Alignment.topLeft),
          equals(BoxStyler().scale(0.5, alignment: Alignment.topLeft)),
        );
      });

      test('rotate', () {
        expect(BoxStyler.rotate(0.5), equals(BoxStyler().rotate(0.5)));
      });

      test('rotate with alignment', () {
        expect(
          BoxStyler.rotate(0.5, alignment: Alignment.bottomRight),
          equals(BoxStyler().rotate(0.5, alignment: Alignment.bottomRight)),
        );
      });
    });

    group('resolved values', () {
      test('color resolves correctly', () {
        final decoration =
            BoxStyler.color(Colors.blue).$decoration!.resolveProp(
              MockBuildContext(),
            );
        expect(decoration, isA<BoxDecoration>());
        expect((decoration as BoxDecoration).color, Colors.blue);
      });

      test('paddingAll resolves correctly', () {
        final padding =
            BoxStyler.paddingAll(16).$padding!.resolveProp(MockBuildContext());
        expect(padding, const EdgeInsets.all(16));
      });

      test('width resolves correctly', () {
        final constraints =
            BoxStyler.width(200).$constraints!.resolveProp(MockBuildContext());
        expect(constraints.minWidth, 200);
        expect(constraints.maxWidth, 200);
      });

      test('size resolves correctly', () {
        final constraints =
            BoxStyler.size(200, 100).$constraints!.resolveProp(
              MockBuildContext(),
            );
        expect(constraints.minWidth, 200);
        expect(constraints.maxWidth, 200);
        expect(constraints.minHeight, 100);
        expect(constraints.maxHeight, 100);
      });
    });
  });
}
