import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Decoration Utilities', () {
    group('DecorationUtility', () {
      final utility = DecorationUtility(UtilityTestAttribute.new);

      test('call() creates DecorationMix', () {
        final decorationMix = BoxDecorationMix(
          color: Colors.red,
          borderRadius: BorderRadiusMix(
            topLeft: const Radius.circular(8.0),
            topRight: const Radius.circular(8.0),
          ),
        );
        final attr = utility(decorationMix);
        expect(attr.value, isA<MixProp<Decoration>>());
      });

      test('as() creates DecorationMix from BoxDecoration', () {
        const decoration = BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        );
        final attr = utility.as(decoration);
        expect(attr.value, isA<MixProp<Decoration>>());
      });

      test('as() creates DecorationMix from ShapeDecoration', () {
        const decoration = ShapeDecoration(
          color: Colors.green,
          shape: CircleBorder(),
        );
        final attr = utility.as(decoration);
        expect(attr.value, isA<MixProp<Decoration>>());
      });

      group('Nested Utilities', () {
        test('box() provides access to BoxDecorationUtility', () {
          final attr = utility.box.color(Colors.red);
          expect(attr.value, isA<MixProp<Decoration>>());
        });

        test('shape() provides access to ShapeDecorationUtility', () {
          final attr = utility.shape.color(Colors.blue);
          expect(attr.value, isA<MixProp<Decoration>>());
        });
      });

      test('token() creates decoration from token', () {
        const token = MixToken<Decoration>('test.decoration');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<Decoration>>());
      });
    });

    group('BoxDecorationUtility', () {
      final utility = BoxDecorationUtility(UtilityTestAttribute.new);

      test('call() creates BoxDecorationMix', () {
        final decorationMix = BoxDecorationMix(
          color: Colors.red,
          borderRadius: BorderRadiusMix(
            topLeft: const Radius.circular(8.0),
            topRight: const Radius.circular(8.0),
          ),
          border: BorderMix(
            top: BorderSideMix(color: Colors.black, width: 2.0),
          ),
        );
        final attr = utility(decorationMix);
        expect(attr.value, isA<MixProp<BoxDecoration>>());
      });

      test('as() creates BoxDecorationMix from BoxDecoration', () {
        const decoration = BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          border: Border.fromBorderSide(
            BorderSide(color: Colors.grey, width: 1.0),
          ),
        );
        final attr = utility.as(decoration);
        expect(attr.value, isA<MixProp<BoxDecoration>>());
      });

      group('Property Utilities', () {
        test('color() creates box decoration with color', () {
          final attr = utility.color(Colors.purple);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test('color.red() creates box decoration with red color', () {
          final attr = utility.color.red();
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test('border() creates box decoration with border', () {
          final borderMix = BorderMix(
            top: BorderSideMix(color: Colors.black, width: 2.0),
          );
          final attr = utility.border(borderMix);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test('border.all() creates box decoration with all borders', () {
          final borderSideMix = BorderSideMix(color: Colors.red, width: 1.0);
          final attr = utility.border.all(borderSideMix);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test('border.top() creates box decoration with top border', () {
          final borderSideMix = BorderSideMix(color: Colors.blue, width: 3.0);
          final attr = utility.border.top(borderSideMix);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test('borderRadius() creates box decoration with border radius', () {
          final borderRadiusMix = BorderRadiusMix(
            topLeft: const Radius.circular(8.0),
            topRight: const Radius.circular(8.0),
          );
          final attr = utility.borderRadius(borderRadiusMix);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test(
          'borderRadius.circular() creates box decoration with circular border radius',
          () {
            final attr = utility.borderRadius.circular(12.0);
            expect(attr.value, isA<MixProp<BoxDecoration>>());
          },
        );

        test(
          'borderRadius.topLeft() creates box decoration with top left border radius',
          () {
            final attr = utility.borderRadius.topLeft.circular(8.0);
            expect(attr.value, isA<MixProp<BoxDecoration>>());
          },
        );

        test('shape() creates box decoration with shape', () {
          final attr = utility.shape(BoxShape.circle);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test('shape.circle() creates box decoration with circle shape', () {
          final attr = utility.shape.circle();
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test(
          'shape.rectangle() creates box decoration with rectangle shape',
          () {
            final attr = utility.shape.rectangle();
            expect(attr.value, isA<MixProp<BoxDecoration>>());
          },
        );

        test(
          'backgroundBlendMode() creates box decoration with blend mode',
          () {
            final attr = utility.backgroundBlendMode(BlendMode.multiply);
            expect(attr.value, isA<MixProp<BoxDecoration>>());
          },
        );

        test(
          'backgroundBlendMode.multiply() creates box decoration with multiply blend mode',
          () {
            final attr = utility.backgroundBlendMode.multiply();
            expect(attr.value, isA<MixProp<BoxDecoration>>());
          },
        );

        test('gradient() creates box decoration with gradient', () {
          final gradientMix = LinearGradientMix(
            colors: const [Colors.red, Colors.blue],
          );
          final attr = utility.gradient(gradientMix);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test(
          'gradient.linear() creates box decoration with linear gradient',
          () {
            final linearGradientMix = LinearGradientMix(
              colors: const [Colors.red, Colors.blue],
            );
            final attr = utility.gradient.linear(linearGradientMix);
            expect(attr.value, isA<MixProp<BoxDecoration>>());
          },
        );

        test(
          'gradient.linear.colors() creates box decoration with linear gradient colors',
          () {
            final attr = utility.gradient.linear.colors([
              Colors.red,
              Colors.blue,
            ]);
            expect(attr.value, isA<MixProp<BoxDecoration>>());
          },
        );

        test(
          'gradient.radial() creates box decoration with radial gradient',
          () {
            final radialGradientMix = RadialGradientMix(
              colors: const [Colors.green, Colors.yellow],
            );
            final attr = utility.gradient.radial(radialGradientMix);
            expect(attr.value, isA<MixProp<BoxDecoration>>());
          },
        );

        test(
          'gradient.radial.colors() creates box decoration with radial gradient colors',
          () {
            final attr = utility.gradient.radial.colors([
              Colors.green,
              Colors.yellow,
            ]);
            expect(attr.value, isA<MixProp<BoxDecoration>>());
          },
        );

        test('gradient.sweep() creates box decoration with sweep gradient', () {
          final sweepGradientMix = SweepGradientMix(
            colors: const [Colors.purple, Colors.orange],
          );
          final attr = utility.gradient.sweep(sweepGradientMix);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test(
          'gradient.sweep.colors() creates box decoration with sweep gradient colors',
          () {
            final attr = utility.gradient.sweep.colors([
              Colors.purple,
              Colors.orange,
            ]);
            expect(attr.value, isA<MixProp<BoxDecoration>>());
          },
        );

        test('image() creates box decoration with decoration image', () {
          final imageMix = DecorationImageMix(
            image: const NetworkImage('https://example.com/image.png'),
            fit: BoxFit.cover,
          );
          final attr = utility.image(imageMix);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test('image.provider() creates box decoration with image provider', () {
          final attr = utility.image.provider(
            const NetworkImage('https://example.com/image.png'),
          );
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test('image.fit() creates box decoration with image fit', () {
          final attr = utility.image.fit(BoxFit.contain);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test('boxShadow() creates box decoration with single box shadow', () {
          final shadowMix = BoxShadowMix(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          );
          final attr = utility.boxShadow(shadowMix);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test('boxShadow.color() creates box decoration with shadow color', () {
          final attr = utility.boxShadow.color(Colors.red);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test(
          'boxShadow.blurRadius() creates box decoration with shadow blur radius',
          () {
            final attr = utility.boxShadow.blurRadius(8.0);
            expect(attr.value, isA<MixProp<BoxDecoration>>());
          },
        );

        test(
          'boxShadows() creates box decoration with multiple box shadows',
          () {
            final shadowMixes = [
              BoxShadowMix(color: Colors.black26, blurRadius: 4.0),
              BoxShadowMix(color: Colors.black12, blurRadius: 8.0),
            ];
            final attr = utility.boxShadows(shadowMixes);
            expect(attr.value, isA<MixProp<BoxDecoration>>());
          },
        );

        test('boxShadows.as() creates box decoration from BoxShadow list', () {
          const shadows = [
            BoxShadow(color: Colors.black26, blurRadius: 4.0),
            BoxShadow(color: Colors.black12, blurRadius: 8.0),
          ];
          final attr = utility.boxShadows.as(shadows);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test('elevation() creates box decoration with elevation shadows', () {
          final attr = utility.elevation(4);
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test('elevation.e2() creates box decoration with elevation 2', () {
          final attr = utility.elevation.e2;
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });

        test('elevation.e8() creates box decoration with elevation 8', () {
          final attr = utility.elevation.e8;
          expect(attr.value, isA<MixProp<BoxDecoration>>());
        });
      });

      test('token() creates box decoration from token', () {
        const token = MixToken<BoxDecoration>('test.boxDecoration');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<BoxDecoration>>());
      });
    });

    group('ShapeDecorationUtility', () {
      final utility = ShapeDecorationUtility(UtilityTestAttribute.new);

      test('call() creates ShapeDecorationMix', () {
        final decorationMix = ShapeDecorationMix(
          color: Colors.red,
          shape: CircleBorderMix(),
        );
        final attr = utility(decorationMix);
        expect(attr.value, isA<MixProp<ShapeDecoration>>());
      });

      test('as() creates ShapeDecorationMix from ShapeDecoration', () {
        const decoration = ShapeDecoration(
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
        );
        final attr = utility.as(decoration);
        expect(attr.value, isA<MixProp<ShapeDecoration>>());
      });

      group('Property Utilities', () {
        test('color() creates shape decoration with color', () {
          final attr = utility.color(Colors.green);
          expect(attr.value, isA<MixProp<ShapeDecoration>>());
        });

        test('color.blue() creates shape decoration with blue color', () {
          final attr = utility.color.blue();
          expect(attr.value, isA<MixProp<ShapeDecoration>>());
        });

        test('shape() creates shape decoration with shape border', () {
          final shapeMix = RoundedRectangleBorderMix(
            borderRadius: BorderRadiusMix(
              topLeft: const Radius.circular(8.0),
              topRight: const Radius.circular(8.0),
            ),
          );
          final attr = utility.shape(shapeMix);
          expect(attr.value, isA<MixProp<ShapeDecoration>>());
        });

        test(
          'shape.roundedRectangle() creates shape decoration with rounded rectangle',
          () {
            final attr = utility
                .shape
                .roundedRectangle
                .borderRadius
                .borderRadius
                .circular(12.0);
            expect(attr.value, isA<MixProp<ShapeDecoration>>());
          },
        );

        test('shape.circle() creates shape decoration with circle', () {
          final attr = utility.shape.circle(CircleBorderMix());
          expect(attr.value, isA<MixProp<ShapeDecoration>>());
        });

        test('shape.stadium() creates shape decoration with stadium', () {
          final attr = utility.shape.stadium(StadiumBorderMix());
          expect(attr.value, isA<MixProp<ShapeDecoration>>());
        });

        test('image() creates shape decoration with decoration image', () {
          final imageMix = DecorationImageMix(
            image: const AssetImage('assets/image.png'),
            fit: BoxFit.cover,
          );
          final attr = utility.image(imageMix);
          expect(attr.value, isA<MixProp<ShapeDecoration>>());
        });

        test(
          'image.provider() creates shape decoration with image provider',
          () {
            final attr = utility.image.provider(
              const AssetImage('assets/image.png'),
            );
            expect(attr.value, isA<MixProp<ShapeDecoration>>());
          },
        );

        test('gradient() creates shape decoration with gradient', () {
          final gradientMix = RadialGradientMix(
            colors: const [Colors.red, Colors.blue],
          );
          final attr = utility.gradient(gradientMix);
          expect(attr.value, isA<MixProp<ShapeDecoration>>());
        });

        test(
          'gradient.radial() creates shape decoration with radial gradient',
          () {
            final radialGradientMix = RadialGradientMix(
              colors: const [Colors.purple, Colors.pink],
            );
            final attr = utility.gradient.radial(radialGradientMix);
            expect(attr.value, isA<MixProp<ShapeDecoration>>());
          },
        );

        test(
          'gradient.radial.colors() creates shape decoration with radial gradient colors',
          () {
            final attr = utility.gradient.radial.colors([
              Colors.purple,
              Colors.pink,
            ]);
            expect(attr.value, isA<MixProp<ShapeDecoration>>());
          },
        );

        test('shadows() creates shape decoration with shadows', () {
          final shadowMixes = [
            BoxShadowMix(color: Colors.black26, blurRadius: 4.0),
            BoxShadowMix(color: Colors.black12, blurRadius: 8.0),
          ];
          final attr = utility.shadows(shadowMixes);
          expect(attr.value, isA<MixProp<ShapeDecoration>>());
        });

        test('shadows.as() creates shape decoration from BoxShadow list', () {
          const shadows = [
            BoxShadow(color: Colors.black26, blurRadius: 4.0),
            BoxShadow(color: Colors.black12, blurRadius: 8.0),
          ];
          final attr = utility.shadows.as(shadows);
          expect(attr.value, isA<MixProp<ShapeDecoration>>());
        });
      });

      test('token() creates shape decoration from token', () {
        const token = MixToken<ShapeDecoration>('test.shapeDecoration');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<ShapeDecoration>>());
      });
    });
  });
}
