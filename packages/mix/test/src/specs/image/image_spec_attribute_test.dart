import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/mock_utils.dart';

void main() {
  group('ImageSpecAttribute', () {
    group('Constructor', () {
      test('creates ImageSpecAttribute with all properties', () {
        final attribute = ImageSpecAttribute(
          width: Prop(200.0),
          height: Prop(150.0),
          color: Prop(Colors.blue),
          repeat: Prop(ImageRepeat.repeat),
          fit: Prop(BoxFit.cover),
          alignment: Prop(Alignment.center),
          centerSlice: Prop(Rect.fromLTWH(10, 10, 20, 20)),
          filterQuality: Prop(FilterQuality.high),
          colorBlendMode: Prop(BlendMode.multiply),
        );

        expect(attribute.$width?.getValue(), 200.0);
        expect(attribute.$height?.getValue(), 150.0);
        expect(attribute.$color?.getValue(), Colors.blue);
        expect(attribute.$repeat?.getValue(), ImageRepeat.repeat);
        expect(attribute.$fit?.getValue(), BoxFit.cover);
        expect(attribute.$alignment?.getValue(), Alignment.center);
        expect(attribute.$centerSlice?.getValue(), const Rect.fromLTWH(10, 10, 20, 20));
        expect(attribute.$filterQuality?.getValue(), FilterQuality.high);
        expect(attribute.$colorBlendMode?.getValue(), BlendMode.multiply);
      });

      test('creates ImageSpecAttribute with default values', () {
        final attribute = ImageSpecAttribute();

        expect(attribute.$width, isNull);
        expect(attribute.$height, isNull);
        expect(attribute.$color, isNull);
        expect(attribute.$repeat, isNull);
        expect(attribute.$fit, isNull);
        expect(attribute.$alignment, isNull);
        expect(attribute.$centerSlice, isNull);
        expect(attribute.$filterQuality, isNull);
        expect(attribute.$colorBlendMode, isNull);
      });
    });

    group('only constructor', () {
      test('creates ImageSpecAttribute with only specified properties', () {
        final attribute = ImageSpecAttribute.only(
          width: 200.0,
          height: 150.0,
          fit: BoxFit.cover,
          color: Colors.blue,
        );

        expect(attribute.$width?.getValue(), 200.0);
        expect(attribute.$height?.getValue(), 150.0);
        expect(attribute.$fit?.getValue(), BoxFit.cover);
        expect(attribute.$color?.getValue(), Colors.blue);
        expect(attribute.$repeat, isNull);
        expect(attribute.$alignment, isNull);
      });

      test('handles null values correctly', () {
        final attribute = ImageSpecAttribute.only();

        expect(attribute.$width, isNull);
        expect(attribute.$height, isNull);
        expect(attribute.$color, isNull);
        expect(attribute.$repeat, isNull);
        expect(attribute.$fit, isNull);
        expect(attribute.$alignment, isNull);
        expect(attribute.$centerSlice, isNull);
        expect(attribute.$filterQuality, isNull);
        expect(attribute.$colorBlendMode, isNull);
      });
    });

    group('value constructor', () {
      test('creates ImageSpecAttribute from ImageSpec', () {
        const spec = ImageSpec(
          width: 200.0,
          height: 150.0,
          color: Colors.blue,
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          centerSlice: Rect.fromLTWH(10, 10, 20, 20),
          filterQuality: FilterQuality.high,
          colorBlendMode: BlendMode.multiply,
        );

        final attribute = ImageSpecAttribute.value(spec);

        expect(attribute.$width?.getValue(), 200.0);
        expect(attribute.$height?.getValue(), 150.0);
        expect(attribute.$color?.getValue(), Colors.blue);
        expect(attribute.$repeat?.getValue(), ImageRepeat.repeat);
        expect(attribute.$fit?.getValue(), BoxFit.cover);
        expect(attribute.$alignment?.getValue(), Alignment.center);
        expect(attribute.$centerSlice?.getValue(), const Rect.fromLTWH(10, 10, 20, 20));
        expect(attribute.$filterQuality?.getValue(), FilterQuality.high);
        expect(attribute.$colorBlendMode?.getValue(), BlendMode.multiply);
      });

      test('handles null properties in spec', () {
        const spec = ImageSpec(width: 200.0);
        final attribute = ImageSpecAttribute.value(spec);

        expect(attribute.$width?.getValue(), 200.0);
        expect(attribute.$height, isNull);
        expect(attribute.$color, isNull);
      });
    });

    group('maybeValue static method', () {
      test('returns ImageSpecAttribute when spec is not null', () {
        const spec = ImageSpec(width: 200.0, height: 150.0);
        final attribute = ImageSpecAttribute.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$width?.getValue(), 200.0);
        expect(attribute.$height?.getValue(), 150.0);
      });

      test('returns null when spec is null', () {
        final attribute = ImageSpecAttribute.maybeValue(null);
        expect(attribute, isNull);
      });
    });

    group('Resolution', () {
      test('resolves to ImageSpec with correct properties', () {
        final attribute = ImageSpecAttribute.only(
          width: 200.0,
          height: 150.0,
          color: Colors.blue,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
        );

        final context = SpecTestHelper.createMockContext();
        final resolved = attribute.resolve(context);
        final spec = resolved.spec;

        expect(spec, isNotNull);
        expect(spec!.width, 200.0);
        expect(spec.height, 150.0);
        expect(spec.color, Colors.blue);
        expect(spec.fit, BoxFit.cover);
        expect(spec.alignment, Alignment.center);
        expect(spec.filterQuality, FilterQuality.high);
      });

      test('resolves to ImageSpec with null properties when not set', () {
        final attribute = ImageSpecAttribute.only(width: 200.0);
        final context = SpecTestHelper.createMockContext();
        final resolved = attribute.resolve(context);
        final spec = resolved.spec;

        expect(spec, isNotNull);
        expect(spec!.width, 200.0);
        expect(spec.height, isNull);
        expect(spec.color, isNull);
        expect(spec.repeat, isNull);
        expect(spec.fit, isNull);
        expect(spec.alignment, isNull);
        expect(spec.centerSlice, isNull);
        expect(spec.filterQuality, isNull);
        expect(spec.colorBlendMode, isNull);
      });
    });

    group('merge', () {
      test('merges two ImageSpecAttributes correctly', () {
        final attr1 = ImageSpecAttribute.only(
          width: 200.0,
          height: 150.0,
          fit: BoxFit.contain,
        );

        final attr2 = ImageSpecAttribute.only(
          width: 300.0,
          color: Colors.blue,
          alignment: Alignment.center,
        );

        final merged = attr1.merge(attr2);

        expect(merged.$width?.getValue(), 300.0); // from attr2
        expect(merged.$height?.getValue(), 150.0); // from attr1
        expect(merged.$fit?.getValue(), BoxFit.contain); // from attr1
        expect(merged.$color?.getValue(), Colors.blue); // from attr2
        expect(merged.$alignment?.getValue(), Alignment.center); // from attr2
      });

      test('returns original when merging with null', () {
        final original = ImageSpecAttribute.only(width: 200.0, height: 150.0);
        final merged = original.merge(null);

        expect(merged, original);
      });

      test('handles complex merge scenarios', () {
        final attr1 = ImageSpecAttribute.only(
          color: Colors.red,
          repeat: ImageRepeat.repeatX,
        );

        final attr2 = ImageSpecAttribute.only(
          color: Colors.blue,
          filterQuality: FilterQuality.high,
        );

        final merged = attr1.merge(attr2);

        // Color should be merged (attr2 takes precedence)
        expect(merged.$color?.getValue(), Colors.blue);
        expect(merged.$filterQuality?.getValue(), FilterQuality.high);
        expect(merged.$repeat?.getValue(), ImageRepeat.repeatX);
      });
    });

    group('Utility Properties', () {
      test('has all expected utility properties', () {
        final attribute = ImageSpecAttribute();

        // Basic properties - just check they exist
        expect(attribute.width, isNotNull);
        expect(attribute.height, isNotNull);
        expect(attribute.color, isNotNull);
        expect(attribute.repeat, isNotNull);
        expect(attribute.fit, isNotNull);
        expect(attribute.alignment, isNotNull);
        expect(attribute.centerSlice, isNotNull);
        expect(attribute.filterQuality, isNotNull);
        expect(attribute.colorBlendMode, isNotNull);
      });
    });

    group('Helper Methods', () {
      test('utility methods create proper attributes', () {
        final attribute = ImageSpecAttribute();

        // Test that utility methods exist and return proper types
        final widthAttr = attribute.width(200.0);
        expect(widthAttr, isA<ImageSpecAttribute>());

        final heightAttr = attribute.height(150.0);
        expect(heightAttr, isA<ImageSpecAttribute>());

        final colorAttr = attribute.color(Colors.blue);
        expect(colorAttr, isA<ImageSpecAttribute>());

        final fitAttr = attribute.fit(BoxFit.cover);
        expect(fitAttr, isA<ImageSpecAttribute>());

        final alignmentAttr = attribute.alignment(Alignment.center);
        expect(alignmentAttr, isA<ImageSpecAttribute>());
      });
    });

    group('Builder pattern', () {
      test('builder methods create new instances', () {
        final original = ImageSpecAttribute();
        final modified = original.width(100.0);

        expect(identical(original, modified), isFalse);
        expect(original.$width, isNull);
        expect(modified.$width?.getValue(), 100.0);
      });

      test('builder methods can be chained fluently with merge', () {
        final attribute = ImageSpecAttribute()
          .width(200.0)
          .merge(ImageSpecAttribute().height(150.0))
          .merge(ImageSpecAttribute().fit(BoxFit.cover))
          .merge(ImageSpecAttribute().color(Colors.blue));

        final context = SpecTestHelper.createMockContext();
        final resolved = attribute.resolve(context);
        final spec = resolved.spec;

        expect(spec!.width, 200.0);
        expect(spec.height, 150.0);
        expect(spec.fit, BoxFit.cover);
        expect(spec.color, Colors.blue);
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final attribute = ImageSpecAttribute(
          width: Prop(200.0),
          height: Prop(150.0),
          color: Prop(Colors.blue),
          repeat: Prop(ImageRepeat.repeat),
          fit: Prop(BoxFit.cover),
          alignment: Prop(Alignment.center),
          centerSlice: Prop(const Rect.fromLTWH(10, 10, 20, 20)),
          filterQuality: Prop(FilterQuality.high),
          colorBlendMode: Prop(BlendMode.multiply),
        );

        expect(attribute.props.length, 9);
        expect(attribute.props, contains(attribute.$width));
        expect(attribute.props, contains(attribute.$height));
        expect(attribute.props, contains(attribute.$color));
        expect(attribute.props, contains(attribute.$repeat));
        expect(attribute.props, contains(attribute.$fit));
        expect(attribute.props, contains(attribute.$alignment));
        expect(attribute.props, contains(attribute.$centerSlice));
        expect(attribute.props, contains(attribute.$filterQuality));
        expect(attribute.props, contains(attribute.$colorBlendMode));
      });
    });

    group('equality', () {
      test('attributes with same properties are equal', () {
        final attr1 = ImageSpecAttribute.only(
          width: 200.0,
          height: 150.0,
          fit: BoxFit.cover,
        );
        final attr2 = ImageSpecAttribute.only(
          width: 200.0,
          height: 150.0,
          fit: BoxFit.cover,
        );

        expect(attr1, attr2);
        expect(attr1.hashCode, attr2.hashCode);
      });

      test('attributes with different properties are not equal', () {
        final attr1 = ImageSpecAttribute.only(width: 200.0, height: 150.0);
        final attr2 = ImageSpecAttribute.only(width: 300.0, height: 150.0);

        expect(attr1, isNot(attr2));
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        final attribute = ImageSpecAttribute.only(
          width: 200.0,
          height: 150.0,
          color: Colors.blue,
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          centerSlice: Rect.fromLTWH(10, 10, 20, 20),
          filterQuality: FilterQuality.high,
          colorBlendMode: BlendMode.multiply,
        );

        final diagnostics = DiagnosticPropertiesBuilder();
        attribute.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'width'), isTrue);
        expect(properties.any((p) => p.name == 'height'), isTrue);
        expect(properties.any((p) => p.name == 'color'), isTrue);
        expect(properties.any((p) => p.name == 'repeat'), isTrue);
        expect(properties.any((p) => p.name == 'fit'), isTrue);
        expect(properties.any((p) => p.name == 'alignment'), isTrue);
        expect(properties.any((p) => p.name == 'centerSlice'), isTrue);
        expect(properties.any((p) => p.name == 'filterQuality'), isTrue);
        expect(properties.any((p) => p.name == 'colorBlendMode'), isTrue);
      });
    });
  });
}
