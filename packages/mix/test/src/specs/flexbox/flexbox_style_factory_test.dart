import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('FlexBoxStyler factory constructors', () {
    group('dot-shorthand resolution', () {
      test('factory resolves via dot-shorthand typed assignment', () {
        FlexBoxStyler styler = FlexBoxStyler.alignment(.center);
        expect(styler.$box, isNotNull);
      });

      test('chaining after factory constructor works', () {
        final styler = FlexBoxStyler.color(
          Colors.red,
        ).padding(.all(16)).borderRadius(BorderRadiusMix.circular(8));
        expect(styler.$box, isNotNull);
      });
    });

    group('factory matches instance method', () {
      // Direct constructor param factories
      test('alignment', () {
        expect(
          FlexBoxStyler.alignment(Alignment.center),
          equals(FlexBoxStyler().alignment(Alignment.center)),
        );
      });

      test('padding', () {
        final mix = EdgeInsetsGeometryMix.all(16);
        expect(
          FlexBoxStyler.padding(mix),
          equals(FlexBoxStyler().padding(mix)),
        );
      });

      test('margin', () {
        final mix = EdgeInsetsGeometryMix.all(8);
        expect(FlexBoxStyler.margin(mix), equals(FlexBoxStyler().margin(mix)));
      });

      test('constraints', () {
        final mix = BoxConstraintsMix(minWidth: 100, maxWidth: 200);
        expect(
          FlexBoxStyler.constraints(mix),
          equals(FlexBoxStyler().constraints(mix)),
        );
      });

      test('decoration', () {
        final mix = DecorationMix.color(Colors.red);
        expect(
          FlexBoxStyler.decoration(mix),
          equals(FlexBoxStyler().decoration(mix)),
        );
      });

      test('foregroundDecoration', () {
        final mix = DecorationMix.color(Colors.blue);
        expect(
          FlexBoxStyler.foregroundDecoration(mix),
          equals(FlexBoxStyler().foregroundDecoration(mix)),
        );
      });

      test('clipBehavior', () {
        expect(
          FlexBoxStyler.clipBehavior(Clip.hardEdge),
          equals(FlexBoxStyler().clipBehavior(Clip.hardEdge)),
        );
      });

      test('direction', () {
        expect(
          FlexBoxStyler.direction(Axis.horizontal),
          equals(FlexBoxStyler().direction(Axis.horizontal)),
        );
      });

      test('mainAxisAlignment', () {
        expect(
          FlexBoxStyler.mainAxisAlignment(.center),
          equals(FlexBoxStyler().mainAxisAlignment(MainAxisAlignment.center)),
        );
      });

      test('crossAxisAlignment', () {
        expect(
          FlexBoxStyler.crossAxisAlignment(CrossAxisAlignment.stretch),
          equals(
            FlexBoxStyler().crossAxisAlignment(CrossAxisAlignment.stretch),
          ),
        );
      });

      test('mainAxisSize', () {
        expect(
          FlexBoxStyler.mainAxisSize(MainAxisSize.min),
          equals(FlexBoxStyler().mainAxisSize(MainAxisSize.min)),
        );
      });

      test('spacing', () {
        expect(FlexBoxStyler.spacing(8), equals(FlexBoxStyler().spacing(8)));
      });

      test('verticalDirection', () {
        expect(
          FlexBoxStyler.verticalDirection(VerticalDirection.up),
          equals(FlexBoxStyler().verticalDirection(VerticalDirection.up)),
        );
      });

      test('textDirection', () {
        expect(
          FlexBoxStyler.textDirection(TextDirection.rtl),
          equals(FlexBoxStyler().textDirection(TextDirection.rtl)),
        );
      });

      test('textBaseline', () {
        expect(
          FlexBoxStyler.textBaseline(TextBaseline.alphabetic),
          equals(FlexBoxStyler().textBaseline(TextBaseline.alphabetic)),
        );
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

      test('shadow', () {
        final s = BoxShadowMix(color: Colors.black, blurRadius: 10);
        expect(FlexBoxStyler.shadow(s), equals(FlexBoxStyler().shadow(s)));
      });

      test('shadows', () {
        final s = [
          BoxShadowMix(color: Colors.black, blurRadius: 10),
          BoxShadowMix(color: Colors.grey, blurRadius: 5),
        ];
        expect(FlexBoxStyler.shadows(s), equals(FlexBoxStyler().shadows(s)));
      });

      // Extended decoration convenience factories
      test('image', () {
        final img = DecorationImageMix(image: const AssetImage('test.png'));
        expect(FlexBoxStyler.image(img), equals(FlexBoxStyler().image(img)));
      });

      test('shape', () {
        final s = ShapeBorderMix.roundedRectangle();
        expect(FlexBoxStyler.shape(s), equals(FlexBoxStyler().shape(s)));
      });

      test('linearGradient', () {
        expect(
          FlexBoxStyler.linearGradient(colors: [Colors.red, Colors.blue]),
          equals(
            FlexBoxStyler().linearGradient(colors: [Colors.red, Colors.blue]),
          ),
        );
      });

      test('radialGradient', () {
        expect(
          FlexBoxStyler.radialGradient(colors: [Colors.red, Colors.blue]),
          equals(
            FlexBoxStyler().radialGradient(colors: [Colors.red, Colors.blue]),
          ),
        );
      });

      test('sweepGradient', () {
        expect(
          FlexBoxStyler.sweepGradient(colors: [Colors.red, Colors.blue]),
          equals(
            FlexBoxStyler().sweepGradient(colors: [Colors.red, Colors.blue]),
          ),
        );
      });

      test('foregroundLinearGradient', () {
        expect(
          FlexBoxStyler.foregroundLinearGradient(
            colors: [Colors.red, Colors.blue],
          ),
          equals(
            FlexBoxStyler().foregroundLinearGradient(
              colors: [Colors.red, Colors.blue],
            ),
          ),
        );
      });

      test('foregroundRadialGradient', () {
        expect(
          FlexBoxStyler.foregroundRadialGradient(
            colors: [Colors.red, Colors.blue],
          ),
          equals(
            FlexBoxStyler().foregroundRadialGradient(
              colors: [Colors.red, Colors.blue],
            ),
          ),
        );
      });

      test('foregroundSweepGradient', () {
        expect(
          FlexBoxStyler.foregroundSweepGradient(
            colors: [Colors.red, Colors.blue],
          ),
          equals(
            FlexBoxStyler().foregroundSweepGradient(
              colors: [Colors.red, Colors.blue],
            ),
          ),
        );
      });

      // Extended transform convenience factories
      test('transform', () {
        expect(
          FlexBoxStyler.transform(Matrix4.identity()),
          equals(FlexBoxStyler().transform(Matrix4.identity())),
        );
      });

      test('translate', () {
        expect(
          FlexBoxStyler.translate(1.0, 2.0),
          equals(FlexBoxStyler().translate(1.0, 2.0)),
        );
      });

      test('skew', () {
        expect(
          FlexBoxStyler.skew(0.1, 0.2),
          equals(FlexBoxStyler().skew(0.1, 0.2)),
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

      test('minWidth', () {
        expect(
          FlexBoxStyler.minWidth(100),
          equals(FlexBoxStyler().minWidth(100)),
        );
      });

      test('maxWidth', () {
        expect(
          FlexBoxStyler.maxWidth(300),
          equals(FlexBoxStyler().maxWidth(300)),
        );
      });

      test('minHeight', () {
        expect(
          FlexBoxStyler.minHeight(50),
          equals(FlexBoxStyler().minHeight(50)),
        );
      });

      test('maxHeight', () {
        expect(
          FlexBoxStyler.maxHeight(400),
          equals(FlexBoxStyler().maxHeight(400)),
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

      test('animate', () {
        final animation = AnimationConfig.ease(
          const Duration(milliseconds: 300),
        );
        expect(
          FlexBoxStyler.animate(animation),
          equals(FlexBoxStyler().animate(animation)),
        );
      });

      // Preset factories
      test('row', () {
        expect(FlexBoxStyler.row(), equals(FlexBoxStyler().row()));
      });

      test('column', () {
        expect(FlexBoxStyler.column(), equals(FlexBoxStyler().column()));
      });
    });

    group('resolved values', () {
      test('color resolves correctly', () {
        final styler = FlexBoxStyler.color(Colors.blue);
        expect(styler.$box, isNotNull);
      });

      test('padding resolves correctly', () {
        final styler = FlexBoxStyler.padding(.all(16));
        expect(styler.$box, isNotNull);
      });

      test('animate sets animation config', () {
        final animation = AnimationConfig.ease(
          const Duration(milliseconds: 300),
        );
        final styler = FlexBoxStyler.animate(animation);

        expect(styler.$animation, equals(animation));
        expect(styler.$box, isNotNull);
      });
    });
  });
}
