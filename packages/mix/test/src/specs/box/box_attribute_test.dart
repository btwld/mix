import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/core/internal/color_values.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxMix', () {
    group('Factory Constructors', () {
      test('color factory creates BoxMix with color decoration', () {
        final boxMix = BoxMix.color(Colors.red);

        expect(boxMix.$decoration, isNotNull);
        final decoration = boxMix.$decoration!.resolve(MockBuildContext());
        expect(decoration, isA<BoxDecoration>());
        expect((decoration as BoxDecoration).color, Colors.red);
      });

      test('gradient factory creates BoxMix with gradient decoration', () {
        final gradient = LinearGradientMix(colors: [Colors.red, Colors.blue]);
        final boxMix = BoxMix.gradient(gradient);

        expect(boxMix.$decoration, isNotNull);
      });

      test('shape factory creates BoxMix with shape decoration', () {
        final boxMix = BoxMix.shape(BoxShape.circle);

        expect(boxMix.$decoration, isNotNull);
      });

      test('height factory creates BoxMix with height constraints', () {
        final boxMix = BoxMix.height(100.0);

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolve(MockBuildContext());
        expect(constraints.minHeight, 100.0);
        expect(constraints.maxHeight, 100.0);
      });

      test('width factory creates BoxMix with width constraints', () {
        final boxMix = BoxMix.width(200.0);

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolve(MockBuildContext());
        expect(constraints.minWidth, 200.0);
        expect(constraints.maxWidth, 200.0);
      });

      test('constraints factory creates BoxMix with constraints', () {
        final constraintsMix = BoxConstraintsMix.minWidth(50.0);
        final boxMix = BoxMix.constraints(constraintsMix);

        expect(boxMix.$constraints, isNotNull);
      });

      test('minWidth factory creates BoxMix with min width constraint', () {
        final boxMix = BoxMix.minWidth(150.0);

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolve(MockBuildContext());
        expect(constraints.minWidth, 150.0);
      });

      test('maxWidth factory creates BoxMix with max width constraint', () {
        final boxMix = BoxMix.maxWidth(300.0);

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolve(MockBuildContext());
        expect(constraints.maxWidth, 300.0);
      });

      test('animation factory creates BoxMix with animation config', () {
        final animation = AnimationConfig.linear(Duration(seconds: 1));
        final boxMix = BoxMix.animation(animation);

        expect(boxMix.$animation, animation);
      });

      test('variant factory creates BoxMix with variant', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = BoxMix.color(Colors.blue);
        final boxMix = BoxMix.variant(variant, style);

        expect(boxMix.$variants, isNotNull);
        expect(boxMix.$variants!.length, 1);
      });

      test('alignment factory creates BoxMix with alignment', () {
        final boxMix = BoxMix.alignment(Alignment.center);

        expect(boxMix.$alignment, isNotNull);
        expectProp(boxMix.$alignment, Alignment.center);
      });

      test('padding factory creates BoxMix with padding', () {
        final padding = EdgeInsetsGeometryMix.all(16.0);
        final boxMix = BoxMix.padding(padding);

        expect(boxMix.$padding, isNotNull);
      });

      test('margin factory creates BoxMix with margin', () {
        final margin = EdgeInsetsGeometryMix.all(8.0);
        final boxMix = BoxMix.margin(margin);

        expect(boxMix.$margin, isNotNull);
      });

      test('transform factory creates BoxMix with transform', () {
        final transform = Matrix4.rotationZ(0.5);
        final boxMix = BoxMix.transform(transform);

        expect(boxMix.$transform, isNotNull);
        expectProp(boxMix.$transform, transform);
      });

      test('clipBehavior factory creates BoxMix with clip behavior', () {
        final boxMix = BoxMix.clipBehavior(Clip.antiAlias);

        expect(boxMix.$clipBehavior, isNotNull);
        expectProp(boxMix.$clipBehavior, Clip.antiAlias);
      });
    });

    group('Constructor', () {
      test('default constructor creates BoxMix with all properties', () {
        final boxMix = BoxMix(
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

      test('value constructor creates BoxMix from BoxSpec', () {
        final spec = BoxSpec(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(12.0),
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          clipBehavior: Clip.antiAliasWithSaveLayer,
        );

        final boxMix = BoxMix.value(spec);

        expect(boxMix.$alignment, isNotNull);
        expectProp(boxMix.$alignment, Alignment.bottomRight);
        expect(boxMix.$padding, isNotNull);
        expect(boxMix.$margin, isNotNull);
        expect(boxMix.$clipBehavior, isNotNull);
        expectProp(boxMix.$clipBehavior, Clip.antiAliasWithSaveLayer);
      });

      test('maybeValue returns null for null input', () {
        final result = BoxMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns BoxMix for non-null input', () {
        final spec = BoxSpec(alignment: Alignment.center);
        final result = BoxMix.maybeValue(spec);

        expect(result, isNotNull);
        expect(result!.$alignment, isNotNull);
      });
    });

    group('Instance Methods', () {
      test('color method sets decoration color', () {
        final boxMix = BoxMix().color(ColorValues.purple);

        expect(boxMix.$decoration, isNotNull);
        final decoration = boxMix.$decoration!.resolve(MockBuildContext());
        expect((decoration as BoxDecoration).color, ColorValues.purple);
      });

      test('width method sets fixed width constraints', () {
        final boxMix = BoxMix().width(250.0);

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolve(MockBuildContext());
        expect(constraints.minWidth, 250.0);
        expect(constraints.maxWidth, 250.0);
      });

      test('height method sets fixed height constraints', () {
        final boxMix = BoxMix().height(150.0);

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolve(MockBuildContext());
        expect(constraints.minHeight, 150.0);
        expect(constraints.maxHeight, 150.0);
      });

      test('rotate method sets rotation transform', () {
        final boxMix = BoxMix().rotate(1.5);

        expect(boxMix.$transform, isNotNull);
        final transform = boxMix.$transform!.value;
        expect(transform, isA<Matrix4>());
      });

      test('scale method sets scale transform', () {
        final boxMix = BoxMix().scale(2.0);

        expect(boxMix.$transform, isNotNull);
        final transform = boxMix.$transform!.value;
        expect(transform, isA<Matrix4>());
      });

      test('translate method sets translation transform', () {
        final boxMix = BoxMix().translate(10.0, 20.0, 5.0);

        expect(boxMix.$transform, isNotNull);
        final transform = boxMix.$transform!.value;
        expect(transform, isA<Matrix4>());
      });

      test('skew method sets skew transform', () {
        final boxMix = BoxMix().skew(0.1, 0.2);

        expect(boxMix.$transform, isNotNull);
        final transform = boxMix.$transform!.value;
        expect(transform, isA<Matrix4>());
      });

      test('transformReset method sets identity transform', () {
        final boxMix = BoxMix().transformReset();

        expect(boxMix.$transform, isNotNull);
        final transform = boxMix.$transform!.value;
        expect(transform, Matrix4.identity());
      });

      test('size method sets both width and height', () {
        final boxMix = BoxMix().size(100.0, 200.0);

        expect(boxMix.$constraints, isNotNull);
        final constraints = boxMix.$constraints!.resolve(MockBuildContext());
        expect(constraints.minWidth, 100.0);
        expect(constraints.maxWidth, 100.0);
        expect(constraints.minHeight, 200.0);
        expect(constraints.maxHeight, 200.0);
      });

      test('shadow method sets single shadow', () {
        final shadow = BoxShadowMix(color: Colors.black, blurRadius: 5.0);
        final boxMix = BoxMix().shadow(shadow);

        expect(boxMix.$decoration, isNotNull);
      });

      test('shadows method sets multiple shadows', () {
        final shadows = [
          BoxShadowMix(color: Colors.black, blurRadius: 5.0),
          BoxShadowMix(color: Colors.grey, blurRadius: 10.0),
        ];
        final boxMix = BoxMix().shadows(shadows);

        expect(boxMix.$decoration, isNotNull);
      });

      test('animate method sets animation config', () {
        final animation = AnimationConfig.linear(Duration(milliseconds: 500));
        final boxMix = BoxMix().animate(animation);

        expect(boxMix.$animation, animation);
      });
    });

    group('Merge', () {
      test('merge combines properties correctly', () {
        final boxMix1 = BoxMix(
          alignment: Alignment.topLeft,
          padding: EdgeInsetsGeometryMix.all(10.0),
        );

        final boxMix2 = BoxMix(
          alignment: Alignment.center,
          margin: EdgeInsetsGeometryMix.all(5.0),
        );

        final merged = boxMix1.merge(boxMix2);

        expect(merged.$alignment, isNotNull);
        expectProp(
          merged.$alignment,
          Alignment.center,
        ); // boxMix2 takes precedence
        expect(merged.$padding, isNotNull); // from boxMix1
        expect(merged.$margin, isNotNull); // from boxMix2
      });

      test('merge with null returns original', () {
        final boxMix = BoxMix(alignment: Alignment.center);
        final merged = boxMix.merge(null);

        expect(identical(boxMix, merged), isTrue);
      });
    });

    group('Resolve', () {
      test('resolve creates BoxSpec with resolved properties', () {
        final boxMix = BoxMix(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryMix.all(16.0),
          clipBehavior: Clip.antiAlias,
        );

        final spec = boxMix.resolve(MockBuildContext());

        expect(spec.alignment, Alignment.center);
        expect(spec.padding, EdgeInsets.all(16.0));
        expect(spec.clipBehavior, Clip.antiAlias);
      });
    });

    group('Equality and Props', () {
      test('equal BoxMix instances have same props', () {
        final boxMix1 = BoxMix(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryMix.all(10.0),
        );

        final boxMix2 = BoxMix(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryMix.all(10.0),
        );

        expect(boxMix1.props, equals(boxMix2.props));
      });

      test('different BoxMix instances have different props', () {
        final boxMix1 = BoxMix(alignment: Alignment.center);
        final boxMix2 = BoxMix(alignment: Alignment.topLeft);

        expect(boxMix1.props, isNot(equals(boxMix2.props)));
      });
    });

    group('BorderRadiusMixin', () {
      test('borderRadius method sets border radius decoration', () {
        final borderRadius = BorderRadiusGeometryMix.circular(8.0);
        final boxMix = BoxMix().borderRadius(borderRadius);

        expect(boxMix.$decoration, isNotNull);
      });
    });

    group('Variant Methods', () {
      test('variant method adds variant to BoxMix', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = BoxMix.color(Colors.white);
        final boxMix = BoxMix().variant(variant, style);

        expect(boxMix.$variants, isNotNull);
        expect(boxMix.$variants!.length, 1);
      });

      test('variants method sets multiple variants', () {
        final variants = [
          VariantStyleAttribute(
            ContextVariant.brightness(Brightness.dark),
            BoxMix.color(Colors.white),
          ),
          VariantStyleAttribute(
            ContextVariant.brightness(Brightness.light),
            BoxMix.color(Colors.black),
          ),
        ];
        final boxMix = BoxMix().variants(variants);

        expect(boxMix.$variants, isNotNull);
        expect(boxMix.$variants!.length, 2);
      });
    });

    group('Modifier Methods', () {
      test('modifier method sets modifier config', () {
        final modifier = ModifierConfig();
        final boxMix = BoxMix().modifier(modifier);

        expect(boxMix.$modifierConfig, modifier);
      });

      test('wrap method sets modifier config', () {
        final modifier = ModifierConfig();
        final boxMix = BoxMix().wrap(modifier);

        expect(boxMix.$modifierConfig, modifier);
      });
    });
  });
}
