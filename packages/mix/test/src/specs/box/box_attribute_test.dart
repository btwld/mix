import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/specs/box/box_attribute.dart';

import '../../../helpers/mock_utils.dart';

void main() {
  group('BoxSpecAttribute', () {
    group('Constructor', () {
      test('creates BoxSpecAttribute with all properties', () {
        final attribute = BoxSpecAttribute(
          alignment: Prop(Alignment.center),
          padding: MixProp(EdgeInsetsGeometryMix.only(top: 8.0)),
          margin: MixProp(EdgeInsetsGeometryMix.only(left: 16.0)),
          constraints: MixProp(BoxConstraintsMix(maxWidth: Prop(200.0))),
          decoration: MixProp(BoxDecorationMix(color: Prop(Colors.red))),
          foregroundDecoration: MixProp(
            BoxDecorationMix(color: Prop(Colors.blue)),
          ),
          transform: Prop(Matrix4.identity()),
          transformAlignment: Prop(Alignment.topLeft),
          clipBehavior: Prop(Clip.antiAlias),
          width: Prop(100.0),
          height: Prop(200.0),
        );

        expect(attribute.$alignment?.getValue(), Alignment.center);
        expect(attribute.$width?.getValue(), 100.0);
        expect(attribute.$height?.getValue(), 200.0);
        expect(attribute.$clipBehavior?.getValue(), Clip.antiAlias);
        expect(attribute.$transformAlignment?.getValue(), Alignment.topLeft);
      });

      test('creates BoxSpecAttribute with default values', () {
        final attribute = BoxSpecAttribute();

        expect(attribute.$alignment, isNull);
        expect(attribute.$padding, isNull);
        expect(attribute.$margin, isNull);
        expect(attribute.$constraints, isNull);
        expect(attribute.$decoration, isNull);
        expect(attribute.$foregroundDecoration, isNull);
        expect(attribute.$transform, isNull);
        expect(attribute.$transformAlignment, isNull);
        expect(attribute.$clipBehavior, isNull);
        expect(attribute.$width, isNull);
        expect(attribute.$height, isNull);
      });
    });

    group('only constructor', () {
      test('creates BoxSpecAttribute with only specified properties', () {
        final attribute = BoxSpecAttribute.only(
          alignment: Alignment.center,
          width: 100.0,
          height: 200.0,
          padding: EdgeInsetsGeometryMix.only(top: 8.0),
        );

        expect(attribute.$alignment?.getValue(), Alignment.center);
        expect(attribute.$width?.getValue(), 100.0);
        expect(attribute.$height?.getValue(), 200.0);
        expect(attribute.$padding, isNotNull);
        expect(attribute.$margin, isNull);
        expect(attribute.$constraints, isNull);
      });

      test('handles null values correctly', () {
        final attribute = BoxSpecAttribute.only();

        expect(attribute.$alignment, isNull);
        expect(attribute.$padding, isNull);
        expect(attribute.$margin, isNull);
        expect(attribute.$constraints, isNull);
        expect(attribute.$decoration, isNull);
        expect(attribute.$foregroundDecoration, isNull);
        expect(attribute.$transform, isNull);
        expect(attribute.$transformAlignment, isNull);
        expect(attribute.$clipBehavior, isNull);
        expect(attribute.$width, isNull);
        expect(attribute.$height, isNull);
      });
    });

    group('value constructor', () {
      test('creates BoxSpecAttribute from BoxSpec', () {
        final transform = Matrix4.identity();
        final spec = BoxSpec(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(16.0),
          constraints: BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(color: Colors.red),
          foregroundDecoration: BoxDecoration(color: Colors.blue),
          transform: transform,
          transformAlignment: Alignment.topLeft,
          clipBehavior: Clip.antiAlias,
          width: 100.0,
          height: 200.0,
        );

        final attribute = BoxSpecAttribute.value(spec);

        expect(attribute.$alignment?.getValue(), Alignment.center);
        expect(attribute.$width?.getValue(), 100.0);
        expect(attribute.$height?.getValue(), 200.0);
        expect(attribute.$clipBehavior?.getValue(), Clip.antiAlias);
        expect(attribute.$transformAlignment?.getValue(), Alignment.topLeft);
      });

      test('handles null properties in spec', () {
        const spec = BoxSpec(width: 100.0);
        final attribute = BoxSpecAttribute.value(spec);

        expect(attribute.$width?.getValue(), 100.0);
        expect(attribute.$height, isNull);
        expect(attribute.$alignment, isNull);
      });
    });

    group('maybeValue static method', () {
      test('returns BoxSpecAttribute when spec is not null', () {
        const spec = BoxSpec(width: 100.0, height: 200.0);
        final attribute = BoxSpecAttribute.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$width?.getValue(), 100.0);
        expect(attribute.$height?.getValue(), 200.0);
      });

      test('returns null when spec is null', () {
        final attribute = BoxSpecAttribute.maybeValue(null);
        expect(attribute, isNull);
      });
    });

    group('resolveSpec', () {
      test('resolves to BoxSpec with correct properties', () {
        final attribute = BoxSpecAttribute.only(
          alignment: Alignment.center,
          width: 100.0,
          height: 200.0,
          padding: EdgeInsetsGeometryMix.only(top: 8.0),
          margin: EdgeInsetsGeometryMix.only(left: 16.0),
          clipBehavior: Clip.antiAlias,
        );

        final context = SpecTestHelper.createMockContext();
        final spec = attribute.resolveSpec(context);

        expect(spec.alignment, Alignment.center);
        expect(spec.width, 100.0);
        expect(spec.height, 200.0);
        expect(spec.padding, isA<EdgeInsetsGeometry>());
        expect(spec.margin, isA<EdgeInsetsGeometry>());
        expect(spec.clipBehavior, Clip.antiAlias);
      });

      test('resolves to BoxSpec with null properties when not set', () {
        final attribute = BoxSpecAttribute.only(width: 100.0);
        final context = SpecTestHelper.createMockContext();
        final spec = attribute.resolveSpec(context);

        expect(spec.width, 100.0);
        expect(spec.height, isNull);
        expect(spec.alignment, isNull);
        expect(spec.padding, isNull);
        expect(spec.margin, isNull);
        expect(spec.constraints, isNull);
        expect(spec.decoration, isNull);
        expect(spec.foregroundDecoration, isNull);
        expect(spec.transform, isNull);
        expect(spec.transformAlignment, isNull);
        expect(spec.clipBehavior, isNull);
      });
    });

    group('merge', () {
      test('merges two BoxSpecAttributes correctly', () {
        final attr1 = BoxSpecAttribute.only(
          width: 100.0,
          height: 200.0,
          alignment: Alignment.topLeft,
        );

        final attr2 = BoxSpecAttribute.only(
          width: 150.0,
          padding: EdgeInsetsGeometryMix.only(top: 8.0),
          clipBehavior: Clip.antiAlias,
        );

        final merged = attr1.merge(attr2);

        expect(merged.$width?.getValue(), 150.0); // from attr2
        expect(merged.$height?.getValue(), 200.0); // from attr1
        expect(merged.$alignment?.getValue(), Alignment.topLeft); // from attr1
        expect(merged.$padding, isNotNull); // from attr2
        expect(merged.$clipBehavior?.getValue(), Clip.antiAlias); // from attr2
      });

      test('returns original when merging with null', () {
        final original = BoxSpecAttribute.only(width: 100.0, height: 200.0);
        final merged = original.merge(null);

        expect(merged, original);
      });

      test('handles complex merge scenarios', () {
        final attr1 = BoxSpecAttribute.only(
          decoration: BoxDecorationMix(color: Prop(Colors.red)),
          constraints: BoxConstraintsMix(maxWidth: Prop(200.0)),
        );

        final attr2 = BoxSpecAttribute.only(
          decoration: BoxDecorationMix(color: Prop(Colors.blue)),
          foregroundDecoration: BoxDecorationMix(color: Prop(Colors.green)),
        );

        final merged = attr1.merge(attr2);

        // Decoration should be merged (attr2 takes precedence)
        expect(merged.$decoration, isNotNull);
        expect(merged.$foregroundDecoration, isNotNull);
        expect(merged.$constraints, isNotNull);
      });
    });

    group('Utility Properties', () {
      test('has all expected utility properties', () {
        final attribute = BoxSpecAttribute();

        // Basic properties - just check they exist
        expect(attribute.padding, isNotNull);
        expect(attribute.margin, isNotNull);
        expect(attribute.constraints, isNotNull);
        expect(attribute.decoration, isNotNull);
        expect(attribute.foregroundDecoration, isNotNull);
        expect(attribute.transform, isNotNull);
        expect(attribute.transformAlignment, isNotNull);
        expect(attribute.clipBehavior, isNotNull);
        expect(attribute.width, isNotNull);
        expect(attribute.height, isNotNull);
        expect(attribute.alignment, isNotNull);

        // Constraint utilities
        expect(attribute.minWidth, isNotNull);
        expect(attribute.maxWidth, isNotNull);
        expect(attribute.minHeight, isNotNull);
        expect(attribute.maxHeight, isNotNull);

        // Decoration utilities
        expect(attribute.border, isNotNull);
        expect(attribute.borderDirectional, isNotNull);
        expect(attribute.borderRadius, isNotNull);
        expect(attribute.borderRadiusDirectional, isNotNull);
        expect(attribute.color, isNotNull);
        expect(attribute.gradient, isNotNull);
        expect(attribute.linearGradient, isNotNull);
        expect(attribute.radialGradient, isNotNull);
        expect(attribute.sweepGradient, isNotNull);
        expect(attribute.shapeDecoration, isNotNull);
        expect(attribute.shape, isNotNull);
      });
    });

    group('Helper Methods', () {
      test('animate method creates attribute with animation', () {
        final attribute = BoxSpecAttribute();
        final animationConfig = AnimationConfig.withDefaults();
        final animatedAttribute = attribute.animate(animationConfig);

        expect(animatedAttribute, isA<BoxSpecAttribute>());
        // Animation is handled at the SpecAttribute level
      });

      test('shadows method creates attribute with box shadows', () {
        final attribute = BoxSpecAttribute();
        final shadows = [
          BoxShadowMix(
            color: Prop(Colors.black26),
            blurRadius: Prop(4.0),
            offset: Prop(Offset(0, 2)),
          ),
        ];
        final shadowAttribute = attribute.shadows(shadows);

        expect(shadowAttribute, isA<BoxSpecAttribute>());
        expect(shadowAttribute.$decoration, isNotNull);
      });

      test('shadow method creates attribute with single box shadow', () {
        final attribute = BoxSpecAttribute();
        final shadow = BoxShadowMix(
          color: Prop(Colors.black26),
          blurRadius: Prop(4.0),
          offset: Prop(Offset(0, 2)),
        );
        final shadowAttribute = attribute.shadow(shadow);

        expect(shadowAttribute, isA<BoxSpecAttribute>());
        expect(shadowAttribute.$decoration, isNotNull);
      });

      test('elevation method creates attribute with elevation shadow', () {
        final attribute = BoxSpecAttribute();
        const elevation = ElevationShadow.four;
        final elevationAttribute = attribute.elevation(elevation);

        expect(elevationAttribute, isA<BoxSpecAttribute>());
        expect(elevationAttribute.$decoration, isNotNull);
      });
    });

    group('equality', () {
      test('attributes with same properties are equal', () {
        final attr1 = BoxSpecAttribute.only(
          width: 100.0,
          height: 200.0,
          alignment: Alignment.center,
        );
        final attr2 = BoxSpecAttribute.only(
          width: 100.0,
          height: 200.0,
          alignment: Alignment.center,
        );

        expect(attr1, attr2);
        expect(attr1.hashCode, attr2.hashCode);
      });

      test('attributes with different properties are not equal', () {
        final attr1 = BoxSpecAttribute.only(width: 100.0, height: 200.0);
        final attr2 = BoxSpecAttribute.only(width: 150.0, height: 200.0);

        expect(attr1, isNot(attr2));
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        final attribute = BoxSpecAttribute.only(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryMix.only(top: 8.0),
          margin: EdgeInsetsGeometryMix.only(left: 16.0),
          constraints: BoxConstraintsMix(maxWidth: Prop(200.0)),
          decoration: BoxDecorationMix(color: Prop(Colors.red)),
          foregroundDecoration: BoxDecorationMix(color: Prop(Colors.blue)),
          transform: Matrix4.identity(),
          transformAlignment: Alignment.topLeft,
          clipBehavior: Clip.antiAlias,
          width: 100.0,
          height: 200.0,
        );

        final diagnostics = DiagnosticPropertiesBuilder();
        attribute.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'alignment'), isTrue);
        expect(properties.any((p) => p.name == 'padding'), isTrue);
        expect(properties.any((p) => p.name == 'margin'), isTrue);
        expect(properties.any((p) => p.name == 'constraints'), isTrue);
        expect(properties.any((p) => p.name == 'decoration'), isTrue);
        expect(properties.any((p) => p.name == 'foregroundDecoration'), isTrue);
        expect(properties.any((p) => p.name == 'transform'), isTrue);
        expect(properties.any((p) => p.name == 'transformAlignment'), isTrue);
        expect(properties.any((p) => p.name == 'clipBehavior'), isTrue);
        expect(properties.any((p) => p.name == 'width'), isTrue);
        expect(properties.any((p) => p.name == 'height'), isTrue);
      });
    });
  });
}
