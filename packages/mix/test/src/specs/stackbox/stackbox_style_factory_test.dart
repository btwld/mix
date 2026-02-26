import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('StackBoxStyler factory constructors', () {
    group('dot-shorthand resolution', () {
      test('factory resolves via dot-shorthand typed assignment', () {
        StackBoxStyler styler = StackBoxStyler.alignment(.center);
        expect(styler.$box, isNotNull);
      });

      test('chaining after factory constructor works', () {
        final styler = StackBoxStyler.color(
          Colors.red,
        ).padding(.all(16)).borderRadius(BorderRadiusMix.circular(8));
        expect(styler.$box, isNotNull);
      });
    });

    group('factory matches instance method', () {
      // Direct constructor param factories
      test('alignment', () {
        expect(
          StackBoxStyler.alignment(Alignment.center),
          equals(StackBoxStyler(alignment: Alignment.center)),
        );
      });

      test('padding', () {
        final mix = EdgeInsetsGeometryMix.all(16);
        expect(
          StackBoxStyler.padding(mix),
          equals(StackBoxStyler(padding: mix)),
        );
      });

      test('margin', () {
        final mix = EdgeInsetsGeometryMix.all(8);
        expect(StackBoxStyler.margin(mix), equals(StackBoxStyler(margin: mix)));
      });

      test('constraints', () {
        final mix = BoxConstraintsMix(minWidth: 100, maxWidth: 200);
        expect(
          StackBoxStyler.constraints(mix),
          equals(StackBoxStyler(constraints: mix)),
        );
      });

      test('decoration', () {
        final mix = DecorationMix.color(Colors.red);
        expect(
          StackBoxStyler.decoration(mix),
          equals(StackBoxStyler(decoration: mix)),
        );
      });

      test('foregroundDecoration', () {
        final mix = DecorationMix.color(Colors.blue);
        expect(
          StackBoxStyler.foregroundDecoration(mix),
          equals(StackBoxStyler(foregroundDecoration: mix)),
        );
      });

      test('clipBehavior', () {
        expect(
          StackBoxStyler.clipBehavior(Clip.hardEdge),
          equals(StackBoxStyler(clipBehavior: Clip.hardEdge)),
        );
      });

      test('stackAlignment', () {
        expect(
          StackBoxStyler.stackAlignment(Alignment.center),
          equals(StackBoxStyler(stackAlignment: Alignment.center)),
        );
      });

      test('fit', () {
        expect(
          StackBoxStyler.fit(StackFit.expand),
          equals(StackBoxStyler(fit: StackFit.expand)),
        );
      });

      // Decoration convenience factories
      test('color', () {
        expect(
          StackBoxStyler.color(Colors.blue),
          equals(StackBoxStyler().color(Colors.blue)),
        );
      });

      test('gradient', () {
        final grad = LinearGradientMix(colors: [Colors.red, Colors.blue]);
        expect(
          StackBoxStyler.gradient(grad),
          equals(StackBoxStyler().gradient(grad)),
        );
      });

      test('border', () {
        final b = BoxBorderMix.all(BorderSideMix(color: Colors.red));
        expect(StackBoxStyler.border(b), equals(StackBoxStyler().border(b)));
      });

      test('borderRadius', () {
        final br = BorderRadiusMix.all(Radius.circular(8));
        expect(
          StackBoxStyler.borderRadius(br),
          equals(StackBoxStyler().borderRadius(br)),
        );
      });

      test('elevation', () {
        expect(
          StackBoxStyler.elevation(ElevationShadow.one),
          equals(StackBoxStyler().elevation(ElevationShadow.one)),
        );
      });

      test('shadow', () {
        final s = BoxShadowMix(color: Colors.black, blurRadius: 10);
        expect(StackBoxStyler.shadow(s), equals(StackBoxStyler().shadow(s)));
      });

      test('shadows', () {
        final s = [
          BoxShadowMix(color: Colors.black, blurRadius: 10),
          BoxShadowMix(color: Colors.grey, blurRadius: 5),
        ];
        expect(StackBoxStyler.shadows(s), equals(StackBoxStyler().shadows(s)));
      });

      // Constraints convenience factories
      test('width', () {
        expect(StackBoxStyler.width(200), equals(StackBoxStyler().width(200)));
      });

      test('height', () {
        expect(
          StackBoxStyler.height(100),
          equals(StackBoxStyler().height(100)),
        );
      });

      test('size', () {
        expect(
          StackBoxStyler.size(200, 100),
          equals(StackBoxStyler().size(200, 100)),
        );
      });

      test('minWidth', () {
        expect(
          StackBoxStyler.minWidth(100),
          equals(StackBoxStyler().minWidth(100)),
        );
      });

      test('maxWidth', () {
        expect(
          StackBoxStyler.maxWidth(300),
          equals(StackBoxStyler().maxWidth(300)),
        );
      });

      test('minHeight', () {
        expect(
          StackBoxStyler.minHeight(50),
          equals(StackBoxStyler().minHeight(50)),
        );
      });

      test('maxHeight', () {
        expect(
          StackBoxStyler.maxHeight(400),
          equals(StackBoxStyler().maxHeight(400)),
        );
      });

      // Transform convenience factories
      test('scale', () {
        expect(StackBoxStyler.scale(0.5), equals(StackBoxStyler().scale(0.5)));
      });

      test('scale with alignment', () {
        expect(
          StackBoxStyler.scale(0.5, alignment: Alignment.topLeft),
          equals(StackBoxStyler().scale(0.5, alignment: Alignment.topLeft)),
        );
      });

      test('rotate', () {
        expect(
          StackBoxStyler.rotate(0.5),
          equals(StackBoxStyler().rotate(0.5)),
        );
      });

      test('rotate with alignment', () {
        expect(
          StackBoxStyler.rotate(0.5, alignment: Alignment.bottomRight),
          equals(
            StackBoxStyler().rotate(0.5, alignment: Alignment.bottomRight),
          ),
        );
      });

      test('animate', () {
        final animation = AnimationConfig.ease(
          const Duration(milliseconds: 300),
        );
        expect(
          StackBoxStyler.animate(animation),
          equals(StackBoxStyler().animate(animation)),
        );
      });
    });

    group('resolved values', () {
      test('color resolves correctly', () {
        final styler = StackBoxStyler.color(Colors.blue);
        expect(styler.$box, isNotNull);
      });

      test('padding resolves correctly', () {
        final styler = StackBoxStyler.padding(.all(16));
        expect(styler.$box, isNotNull);
      });

      test('animate sets animation config', () {
        final animation = AnimationConfig.ease(
          const Duration(milliseconds: 300),
        );
        final styler = StackBoxStyler.animate(animation);

        expect(styler.$animation, equals(animation));
        expect(styler.$box, isNotNull);
      });
    });
  });
}
