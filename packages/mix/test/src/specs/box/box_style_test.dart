import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxMix', () {
    group('Factory Constructors', () {
      test('color factory creates BoxMix with color decoration', () {
        final boxMix = BoxStyler(decoration: DecorationMix.color(Colors.red));

        expect(boxMix.$decoration, isNotNull);
        final decoration = boxMix.$decoration!.resolveProp(MockBuildContext());
        expect(decoration, isA<BoxDecoration>());
        expect((decoration as BoxDecoration).color, Colors.red);
      });

      test('gradient factory creates BoxMix with gradient decoration', () {
        final gradient = LinearGradientMix(colors: [Colors.red, Colors.blue]);
        final boxMix = BoxStyler(
          decoration: BoxDecorationMix(gradient: gradient),
        );

        expect(boxMix.$decoration, isNotNull);
      });

      test('shape factory creates BoxMix with shape decoration', () {
        final boxMix = BoxStyler(
          decoration: BoxDecorationMix(shape: BoxShape.circle),
        );

        expect(boxMix.$decoration, isNotNull);
      });

      test('height factory creates BoxMix with height constraints', () {
        final boxMix = BoxStyler().height(100.0);

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolveProp(
          MockBuildContext(),
        );
        expect(constraints.minHeight, 100.0);
        expect(constraints.maxHeight, 100.0);
      });

      test('width factory creates BoxMix with width constraints', () {
        final boxMix = BoxStyler().width(200.0);

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolveProp(
          MockBuildContext(),
        );
        expect(constraints.minWidth, 200.0);
        expect(constraints.maxWidth, 200.0);
      });

      test('constraints factory creates BoxMix with constraints', () {
        final constraintsMix = BoxConstraintsMix.minWidth(50.0);
        final boxMix = BoxStyler(constraints: constraintsMix);

        expect(boxMix.$constraints, isNotNull);
      });

      test('minWidth factory creates BoxMix with min width constraint', () {
        final boxMix = BoxStyler(
          constraints: BoxConstraintsMix.minWidth(150.0),
        );

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolveProp(
          MockBuildContext(),
        );
        expect(constraints.minWidth, 150.0);
      });

      test('maxWidth factory creates BoxMix with max width constraint', () {
        final boxMix = BoxStyler(
          constraints: BoxConstraintsMix.maxWidth(300.0),
        );

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolveProp(
          MockBuildContext(),
        );
        expect(constraints.maxWidth, 300.0);
      });

      test('animation factory creates BoxMix with animation config', () {
        final animation = AnimationConfig.linear(Duration(seconds: 1));
        final boxMix = BoxStyler(animation: animation);

        expect(boxMix.$animation, animation);
      });

      test('variant factory creates BoxMix with variant', () {
        final variant = ContextTrigger.brightness(Brightness.dark);
        final style = BoxStyler(decoration: DecorationMix.color(Colors.blue));
        final boxMix = BoxStyler(variants: [EventVariantStyle(variant, style)]);

        expect(boxMix.$variants, isNotNull);
        expect(boxMix.$variants!.length, 1);
      });

      test('alignment factory creates BoxMix with alignment', () {
        final boxMix = BoxStyler(alignment: Alignment.center);

        expect(boxMix.$alignment, isNotNull);
        expect(boxMix.$alignment, resolvesTo(Alignment.center));
      });

      test('padding factory creates BoxMix with padding', () {
        final padding = EdgeInsetsGeometryMix.all(16.0);
        final boxMix = BoxStyler(padding: padding);

        expect(boxMix.$padding, isNotNull);
      });

      test('margin factory creates BoxMix with margin', () {
        final margin = EdgeInsetsGeometryMix.all(8.0);
        final boxMix = BoxStyler(margin: margin);

        expect(boxMix.$margin, isNotNull);
      });

      test('transform factory creates BoxMix with transform', () {
        final transform = Matrix4.rotationZ(0.5);
        final boxMix = BoxStyler(transform: transform);

        expect(boxMix.$transform, isNotNull);
        expect(boxMix.$transform, resolvesTo(transform));
      });

      test('clipBehavior factory creates BoxMix with clip behavior', () {
        final boxMix = BoxStyler(clipBehavior: Clip.antiAlias);

        expect(boxMix.$clipBehavior, isNotNull);
        expect(boxMix.$clipBehavior, resolvesTo(Clip.antiAlias));
      });
    });

    group('Constructor', () {
      test('default constructor creates BoxMix with all properties', () {
        final boxMix = BoxStyler(
          alignment: Alignment.topLeft,
          padding: EdgeInsetsGeometryMix.all(10.0),
          margin: EdgeInsetsGeometryMix.all(5.0),
          constraints: BoxConstraintsMix.minHeight(100.0),
          decoration: DecorationMix.color(Colors.green),
          foregroundDecoration: DecorationMix.color(Colors.yellow),
          transform: Matrix4.identity(),
          transformAlignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
        );

        expect(boxMix.$alignment, isNotNull);
        expect(boxMix.$padding, isNotNull);
        expect(boxMix.$margin, isNotNull);
        expect(boxMix.$constraints, isNotNull);
        expect(boxMix.$decoration, isNotNull);
        expect(boxMix.$foregroundDecoration, isNotNull);
        expect(boxMix.$transform, isNotNull);
        expect(boxMix.$transformAlignment, isNotNull);
        expect(boxMix.$clipBehavior, isNotNull);
      });
    });

    group('Instance Methods', () {
      test('color method sets decoration color', () {
        final boxMix = BoxStyler().color(MixColors.purple);

        expect(boxMix.$decoration, isNotNull);
        final decoration = boxMix.$decoration!.resolveProp(MockBuildContext());
        expect((decoration as BoxDecoration).color, MixColors.purple);
      });

      test('width method sets fixed width constraints', () {
        final boxMix = BoxStyler().width(250.0);

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolveProp(
          MockBuildContext(),
        );
        expect(constraints.minWidth, 250.0);
        expect(constraints.maxWidth, 250.0);
      });

      test('height method sets fixed height constraints', () {
        final boxMix = BoxStyler().height(150.0);

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolveProp(
          MockBuildContext(),
        );
        expect(constraints.minHeight, 150.0);
        expect(constraints.maxHeight, 150.0);
      });

      test('rotate method sets rotation transform', () {
        final boxMix = BoxStyler().rotate(1.5);

        expect(boxMix.$transform, isNotNull);
        expect(boxMix.$transform, resolvesTo(isA<Matrix4>()));
      });

      test('scale method sets scale transform', () {
        final boxMix = BoxStyler().scale(2.0);

        expect(boxMix.$transform, isNotNull);
        expect(boxMix.$transform, resolvesTo(isA<Matrix4>()));
      });

      test('translate method sets translation transform', () {
        final boxMix = BoxStyler().translate(10.0, 20.0, 5.0);

        expect(boxMix.$transform, isNotNull);
        expect(boxMix.$transform, resolvesTo(isA<Matrix4>()));
      });

      test('skew method sets skew transform', () {
        final boxMix = BoxStyler().skew(0.1, 0.2);

        expect(boxMix.$transform, isNotNull);
        expect(boxMix.$transform, resolvesTo(isA<Matrix4>()));
      });

      test('transformReset method sets identity transform', () {
        final boxMix = BoxStyler().transformReset();

        expect(boxMix.$transform, isNotNull);
        expect(boxMix.$transform, resolvesTo(Matrix4.identity()));
      });

      test('size method sets both width and height', () {
        final boxMix = BoxStyler().size(100.0, 200.0);

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolveProp(
          MockBuildContext(),
        );
        expect(constraints.minWidth, 100.0);
        expect(constraints.maxWidth, 100.0);
        expect(constraints.minHeight, 200.0);
        expect(constraints.maxHeight, 200.0);
      });

      test('shadow method sets single shadow', () {
        final shadow = BoxShadowMix(color: Colors.black, blurRadius: 5.0);
        final boxMix = BoxStyler().shadow(shadow);

        expect(boxMix.$decoration, isNotNull);
      });

      test('shadows method sets multiple shadows', () {
        final shadows = [
          BoxShadowMix(color: Colors.black, blurRadius: 5.0),
          BoxShadowMix(color: Colors.grey, blurRadius: 10.0),
        ];
        final boxMix = BoxStyler().shadows(shadows);

        expect(boxMix.$decoration, isNotNull);
      });

      test('animate method sets animation config', () {
        final animation = AnimationConfig.linear(Duration(milliseconds: 500));
        final boxMix = BoxStyler().animate(animation);

        expect(boxMix.$animation, animation);
      });
    });

    group('Merge', () {
      test('merge combines properties correctly', () {
        final boxMix1 = BoxStyler(
          alignment: Alignment.topLeft,
          padding: EdgeInsetsGeometryMix.all(10.0),
        );

        final boxMix2 = BoxStyler(
          alignment: Alignment.center,
          margin: EdgeInsetsGeometryMix.all(5.0),
        );

        final merged = boxMix1.merge(boxMix2);

        expect(merged.$alignment, isNotNull);
        expect(
          merged.$alignment,
          resolvesTo(Alignment.center),
        ); // boxMix2 takes precedence
        expect(merged.$padding, isNotNull); // from boxMix1
        expect(merged.$margin, isNotNull); // from boxMix2
      });

      test('merge with null returns original', () {
        final boxMix = BoxStyler(alignment: Alignment.center);
        final merged = boxMix.merge(null);

        expect(identical(boxMix, merged), isFalse);
        expect(merged, equals(boxMix));
      });
    });

    group('Resolve', () {
      test('resolve creates BoxSpec with resolved properties', () {
        final boxMix = BoxStyler(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryMix.all(16.0),
          clipBehavior: Clip.antiAlias,
        );

        final spec = boxMix.resolve(MockBuildContext());

        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.padding, EdgeInsets.all(16.0));
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });
    });

    group('Equality and Props', () {
      test('equal BoxMix instances have same props', () {
        final boxMix1 = BoxStyler(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryMix.all(10.0),
        );

        final boxMix2 = BoxStyler(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryMix.all(10.0),
        );

        expect(boxMix1.props, equals(boxMix2.props));
      });

      test('different BoxMix instances have different props', () {
        final boxMix1 = BoxStyler(alignment: Alignment.center);
        final boxMix2 = BoxStyler(alignment: Alignment.topLeft);

        expect(boxMix1.props, isNot(equals(boxMix2.props)));
      });
    });

    group('BorderRadiusMixin', () {
      test('borderRadius method sets border radius decoration', () {
        final borderRadius = BorderRadiusGeometryMix.circular(8.0);
        final boxMix = BoxStyler().borderRadius(borderRadius);

        expect(boxMix.$decoration, isNotNull);
      });
    });

    group('Variant Methods', () {
      test('variant method adds variant to BoxMix', () {
        final variant = ContextTrigger.brightness(Brightness.dark);
        final style = BoxStyler(decoration: DecorationMix.color(Colors.white));
        final boxMix = BoxStyler().variant(EventVariantStyle(variant, style));

        expect(boxMix.$variants, isNotNull);
        expect(boxMix.$variants!.length, 1);
      });

      test('variants method sets multiple variants', () {
        final variants = [
          EventVariantStyle(
            ContextTrigger.brightness(Brightness.dark),
            BoxStyler(decoration: DecorationMix.color(Colors.white)),
          ),
          EventVariantStyle(
            ContextTrigger.brightness(Brightness.light),
            BoxStyler(decoration: DecorationMix.color(Colors.black)),
          ),
        ];
        final boxMix = BoxStyler().withVariants(variants);

        expect(boxMix.$variants, isNotNull);
        expect(boxMix.$variants!.length, 2);
      });
    });

    group('Modifier Methods', () {
      test('modifier method sets modifier config', () {
        final modifier = WidgetModifierConfig();
        final boxMix = BoxStyler().modifier(modifier);

        expect(boxMix.$modifier, modifier);
      });

      test('wrap method sets modifier config', () {
        final modifier = WidgetModifierConfig();
        final boxMix = BoxStyler().wrap(modifier);

        expect(boxMix.$modifier, modifier);
      });
    });
  });
}
