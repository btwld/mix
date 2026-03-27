import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxStyler factory constructors', () {
    group('dot-shorthand resolution', () {
      test('factory resolves via dot-shorthand typed assignment', () {
        BoxStyler styler = BoxStyler.alignment(.center);
        expect(styler.$alignment, isNotNull);
      });

      test('chaining after factory constructor works', () {
        final styler = BoxStyler.color(
          Colors.red,
        ).padding(.all(16)).borderRadius(BorderRadiusMix.circular(8));

        expect(styler.$padding, isNotNull);
        expect(styler.$decoration, isNotNull);
      });
    });

    group('factory matches instance method', () {
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
        expect(BoxStyler.decoration(mix), equals(BoxStyler().decoration(mix)));
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

      test('shadow', () {
        final s = BoxShadowMix(color: Colors.black, blurRadius: 10);
        expect(BoxStyler.shadow(s), equals(BoxStyler().shadow(s)));
      });

      test('shadows', () {
        final s = [
          BoxShadowMix(color: Colors.black, blurRadius: 10),
          BoxShadowMix(color: Colors.grey, blurRadius: 5),
        ];
        expect(BoxStyler.shadows(s), equals(BoxStyler().shadows(s)));
      });

      test('width', () {
        expect(BoxStyler.width(200), equals(BoxStyler().width(200)));
      });

      test('height', () {
        expect(BoxStyler.height(100), equals(BoxStyler().height(100)));
      });

      test('size', () {
        expect(BoxStyler.size(200, 100), equals(BoxStyler().size(200, 100)));
      });

      test('minWidth', () {
        expect(BoxStyler.minWidth(100), equals(BoxStyler().minWidth(100)));
      });

      test('maxWidth', () {
        expect(BoxStyler.maxWidth(300), equals(BoxStyler().maxWidth(300)));
      });

      test('minHeight', () {
        expect(BoxStyler.minHeight(50), equals(BoxStyler().minHeight(50)));
      });

      test('maxHeight', () {
        expect(BoxStyler.maxHeight(400), equals(BoxStyler().maxHeight(400)));
      });

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

      test('animate', () {
        final animation = AnimationConfig.ease(
          const Duration(milliseconds: 300),
        );
        expect(
          BoxStyler.animate(animation),
          equals(BoxStyler().animate(animation)),
        );
      });

      test('image', () {
        final img = DecorationImageMix(image: const AssetImage('test.png'));
        expect(BoxStyler.image(img), equals(BoxStyler().image(img)));
      });

      test('shape', () {
        final s = ShapeBorderMix.roundedRectangle();
        expect(BoxStyler.shape(s), equals(BoxStyler().shape(s)));
      });

      test('backgroundImage', () {
        expect(
          BoxStyler.backgroundImage(const AssetImage('test.png')),
          equals(BoxStyler().backgroundImage(const AssetImage('test.png'))),
        );
      });

      test('backgroundImageUrl', () {
        expect(
          BoxStyler.backgroundImageUrl('https://example.com/img.png'),
          equals(BoxStyler().backgroundImageUrl('https://example.com/img.png')),
        );
      });

      test('backgroundImageAsset', () {
        expect(
          BoxStyler.backgroundImageAsset('assets/img.png'),
          equals(BoxStyler().backgroundImageAsset('assets/img.png')),
        );
      });

      test('linearGradient', () {
        expect(
          BoxStyler.linearGradient(colors: [Colors.red, Colors.blue]),
          equals(BoxStyler().linearGradient(colors: [Colors.red, Colors.blue])),
        );
      });

      test('radialGradient', () {
        expect(
          BoxStyler.radialGradient(colors: [Colors.red, Colors.blue]),
          equals(BoxStyler().radialGradient(colors: [Colors.red, Colors.blue])),
        );
      });

      test('sweepGradient', () {
        expect(
          BoxStyler.sweepGradient(colors: [Colors.red, Colors.blue]),
          equals(BoxStyler().sweepGradient(colors: [Colors.red, Colors.blue])),
        );
      });

      test('foregroundLinearGradient', () {
        expect(
          BoxStyler.foregroundLinearGradient(colors: [Colors.red, Colors.blue]),
          equals(
            BoxStyler().foregroundLinearGradient(
              colors: [Colors.red, Colors.blue],
            ),
          ),
        );
      });

      test('foregroundRadialGradient', () {
        expect(
          BoxStyler.foregroundRadialGradient(colors: [Colors.red, Colors.blue]),
          equals(
            BoxStyler().foregroundRadialGradient(
              colors: [Colors.red, Colors.blue],
            ),
          ),
        );
      });

      test('foregroundSweepGradient', () {
        expect(
          BoxStyler.foregroundSweepGradient(colors: [Colors.red, Colors.blue]),
          equals(
            BoxStyler().foregroundSweepGradient(
              colors: [Colors.red, Colors.blue],
            ),
          ),
        );
      });

      test('transform', () {
        expect(
          BoxStyler.transform(Matrix4.identity()),
          equals(BoxStyler().transform(Matrix4.identity())),
        );
      });

      test('translate', () {
        expect(
          BoxStyler.translate(1.0, 2.0),
          equals(BoxStyler().translate(1.0, 2.0)),
        );
      });

      test('skew', () {
        expect(BoxStyler.skew(0.1, 0.2), equals(BoxStyler().skew(0.1, 0.2)));
      });
    });

    group('resolved values', () {
      test('color resolves correctly', () {
        final decoration = BoxStyler.color(
          Colors.blue,
        ).$decoration!.resolveProp(MockBuildContext());

        expect(decoration, isA<BoxDecoration>());
        expect((decoration as BoxDecoration).color, Colors.blue);
      });

      test('padding resolves correctly', () {
        final padding = BoxStyler.padding(
          .all(16),
        ).$padding!.resolveProp(MockBuildContext());
        expect(padding, const EdgeInsets.all(16));
      });

      test('width resolves correctly', () {
        final constraints = BoxStyler.width(
          200,
        ).$constraints!.resolveProp(MockBuildContext());
        expect(constraints.minWidth, 200);
        expect(constraints.maxWidth, 200);
      });

      test('size resolves correctly', () {
        final constraints = BoxStyler.size(
          200,
          100,
        ).$constraints!.resolveProp(MockBuildContext());

        expect(constraints.minWidth, 200);
        expect(constraints.maxWidth, 200);
        expect(constraints.minHeight, 100);
        expect(constraints.maxHeight, 100);
      });

      test('animate sets animation config', () {
        final animation = AnimationConfig.ease(
          const Duration(milliseconds: 300),
        );
        final styler = BoxStyler.animate(animation);

        expect(styler.$animation, equals(animation));
      });
    });
  });
}
