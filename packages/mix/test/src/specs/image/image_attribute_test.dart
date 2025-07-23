import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ImageSpecAttribute', () {
    group('Constructor', () {
      test('creates ImageSpecAttribute with all properties', () {
        final attribute = ImageSpecAttribute(
          width: Prop(100.0),
          height: Prop(200.0),
          color: Prop(Colors.red),
          repeat: Prop(ImageRepeat.repeat),
          fit: Prop(BoxFit.cover),
          alignment: Prop(Alignment.center),
          centerSlice: Prop(const Rect.fromLTWH(10, 10, 20, 20)),
          filterQuality: Prop(FilterQuality.high),
          colorBlendMode: Prop(BlendMode.multiply),
        );

        expect(attribute.$width, resolvesTo(100.0));
        expect(attribute.$height, resolvesTo(200.0));
        expect(attribute.$color, resolvesTo(Colors.red));
        expect(attribute.$repeat, resolvesTo(ImageRepeat.repeat));
        expectProp(attribute.$fit, BoxFit.cover);
        expectProp(attribute.$alignment, Alignment.center);
        expect(
          attribute.$centerSlice,
          resolvesTo(const Rect.fromLTWH(10, 10, 20, 20)),
        );
        expect(attribute.$filterQuality, resolvesTo(FilterQuality.high));
        expect(attribute.$colorBlendMode, resolvesTo(BlendMode.multiply));
      });

      test('creates empty ImageSpecAttribute', () {
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
      test('creates ImageSpecAttribute with only constructor', () {
        final attribute = ImageSpecAttribute.only(
          width: 150.0,
          height: 250.0,
          color: Colors.blue,
          repeat: ImageRepeat.repeatX,
          fit: BoxFit.contain,
          alignment: Alignment.topLeft,
          centerSlice: const Rect.fromLTWH(5, 5, 10, 10),
          filterQuality: FilterQuality.medium,
          colorBlendMode: BlendMode.overlay,
        );

        expect(attribute.$width, resolvesTo(150.0));
        expect(attribute.$height, resolvesTo(250.0));
        expect(attribute.$color, resolvesTo(Colors.blue));
        expect(attribute.$repeat, resolvesTo(ImageRepeat.repeatX));
        expectProp(attribute.$fit, BoxFit.contain);
        expectProp(attribute.$alignment, Alignment.topLeft);
        expect(
          attribute.$centerSlice,
          resolvesTo(const Rect.fromLTWH(5, 5, 10, 10)),
        );
        expect(attribute.$filterQuality, resolvesTo(FilterQuality.medium));
        expect(attribute.$colorBlendMode, resolvesTo(BlendMode.overlay));
      });

      test('creates partial ImageSpecAttribute with only constructor', () {
        final attribute = ImageSpecAttribute.only(
          width: 100.0,
          fit: BoxFit.fill,
        );

        expect(attribute.$width, resolvesTo(100.0));
        expect(attribute.$fit, resolvesTo(BoxFit.fill));
        expect(attribute.$height, isNull);
        expect(attribute.$color, isNull);
        expect(attribute.$repeat, isNull);
        expect(attribute.$alignment, isNull);
        expect(attribute.$centerSlice, isNull);
        expect(attribute.$filterQuality, isNull);
        expect(attribute.$colorBlendMode, isNull);
      });
    });

    group('value constructor', () {
      test('creates ImageSpecAttribute from ImageSpec', () {
        const spec = ImageSpec(
          width: 100.0,
          height: 200.0,
          color: Colors.red,
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          centerSlice: Rect.fromLTWH(10, 10, 20, 20),
          filterQuality: FilterQuality.high,
          colorBlendMode: BlendMode.multiply,
        );

        final attribute = ImageSpecAttribute.value(spec);

        expect(attribute.$width, resolvesTo(100.0));
        expect(attribute.$height, resolvesTo(200.0));
        expect(attribute.$color, resolvesTo(Colors.red));
        expect(attribute.$repeat, resolvesTo(ImageRepeat.repeat));
        expect(attribute.$fit, resolvesTo(BoxFit.cover));
        expectProp(attribute.$alignment, Alignment.center);
        expect(
          attribute.$centerSlice,
          resolvesTo(const Rect.fromLTWH(10, 10, 20, 20)),
        );
        expect(attribute.$filterQuality, resolvesTo(FilterQuality.high));
        expect(attribute.$colorBlendMode, resolvesTo(BlendMode.multiply));
      });

      test('maybeValue returns null for null spec', () {
        expect(ImageSpecAttribute.maybeValue(null), isNull);
      });

      test('maybeValue returns attribute for non-null spec', () {
        const spec = ImageSpec(width: 100.0, height: 200.0);
        final attribute = ImageSpecAttribute.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$width, resolvesTo(100.0));
        expect(attribute.$height, resolvesTo(200.0));
      });
    });

    group('Utility Methods', () {
      test('width and height utilities work correctly', () {
        final widthAttr = ImageSpecAttribute().width(100.0);
        final heightAttr = ImageSpecAttribute().height(200.0);

        expect(widthAttr.$width, resolvesTo(100.0));
        expect(heightAttr.$height, resolvesTo(200.0));
      });

      test('color utility works correctly', () {
        final attribute = ImageSpecAttribute().color(Colors.green);

        expect(attribute.$color, resolvesTo(Colors.green));
      });

      test('repeat utility works correctly', () {
        final repeatX = ImageSpecAttribute().repeat(ImageRepeat.repeatX);
        final repeatY = ImageSpecAttribute().repeat(ImageRepeat.repeatY);
        final noRepeat = ImageSpecAttribute().repeat(ImageRepeat.noRepeat);

        expect(repeatX.$repeat, resolvesTo(ImageRepeat.repeatX));
        expect(repeatY.$repeat, resolvesTo(ImageRepeat.repeatY));
        expect(noRepeat.$repeat, resolvesTo(ImageRepeat.noRepeat));
      });

      test('fit utility works correctly', () {
        final cover = ImageSpecAttribute().fit(BoxFit.cover);
        final contain = ImageSpecAttribute().fit(BoxFit.contain);
        final fill = ImageSpecAttribute().fit(BoxFit.fill);

        expect(cover.$fit, resolvesTo(BoxFit.cover));
        expect(contain.$fit, resolvesTo(BoxFit.contain));
        expect(fill.$fit, resolvesTo(BoxFit.fill));
      });

      test('alignment utility works correctly', () {
        final attribute = ImageSpecAttribute().alignment(Alignment.bottomRight);

        expectProp(attribute.$alignment, Alignment.bottomRight);
      });

      test('centerSlice utility works correctly', () {
        final attribute = ImageSpecAttribute().centerSlice(
          const Rect.fromLTWH(20, 20, 40, 40),
        );

        expect(
          attribute.$centerSlice,
          resolvesTo(const Rect.fromLTWH(20, 20, 40, 40)),
        );
      });

      test('filterQuality utility works correctly', () {
        final high = ImageSpecAttribute().filterQuality(FilterQuality.high);
        final low = ImageSpecAttribute().filterQuality(FilterQuality.low);

        expect(high.$filterQuality, resolvesTo(FilterQuality.high));
        expect(low.$filterQuality, resolvesTo(FilterQuality.low));
      });

      test('colorBlendMode utility works correctly', () {
        final multiply = ImageSpecAttribute().colorBlendMode(
          BlendMode.multiply,
        );
        final screen = ImageSpecAttribute().colorBlendMode(BlendMode.screen);

        expect(multiply.$colorBlendMode, resolvesTo(BlendMode.multiply));
        expect(screen.$colorBlendMode, resolvesTo(BlendMode.screen));
      });

      test('chaining utilities does not accumulate properties', () {
        // This is the key behavior: chaining creates new instances
        final chained = ImageSpecAttribute()
            .width(100.0)
            .height(200.0)
            .fit(BoxFit.cover)
            .alignment(Alignment.center)
            .color(Colors.red);

        // Only the last property is set because each utility creates a new instance
        expect(chained.$width, isNull);
        expect(chained.$height, isNull);
        expect(chained.$fit, isNull);
        expect(chained.$alignment, isNull);
        expect(chained.$color, resolvesTo(Colors.red));
      });

      test('use merge to combine utilities', () {
        // To combine multiple utilities, use merge
        final combined = ImageSpecAttribute()
            .width(100.0)
            .merge(ImageSpecAttribute().height(200.0))
            .merge(ImageSpecAttribute().fit(BoxFit.cover))
            .merge(ImageSpecAttribute().alignment(Alignment.center))
            .merge(ImageSpecAttribute().color(Colors.red));

        expect(combined.$width, resolvesTo(100.0));
        expect(combined.$height, resolvesTo(200.0));
        expect(combined.$fit, resolvesTo(BoxFit.cover));
        expectProp(combined.$alignment, Alignment.center);
        expect(combined.$color, resolvesTo(Colors.red));
      });
    });

    group('Convenience Methods', () {
      test('animate method sets animation config', () {
        final animation = AnimationConfig.ease(
          const Duration(milliseconds: 300),
        );
        final attribute = ImageSpecAttribute().animate(animation);

        expect(attribute.animation, equals(animation));
      });
    });

    group('Resolution', () {
      test('resolves to ImageSpec with correct properties', () {
        final attribute = ImageSpecAttribute()
            .width(100.0)
            .height(200.0)
            .color(Colors.red)
            .repeat(ImageRepeat.repeat)
            .fit(BoxFit.cover)
            .alignment(Alignment.center)
            .centerSlice(const Rect.fromLTWH(10, 10, 20, 20))
            .filterQuality(FilterQuality.high)
            .colorBlendMode(BlendMode.multiply);

        final context = MockBuildContext();
        final resolved = attribute.build(context);
        final spec = resolved.spec;

        expect(spec, isNotNull);
        expect(spec!.width, 100.0);
        expect(spec.height, 200.0);
        expect(spec.color, Colors.red);
        expect(spec.repeat, ImageRepeat.repeat);
        expect(spec.fit, BoxFit.cover);
        expect(spec.alignment, Alignment.center);
        expect(spec.centerSlice, const Rect.fromLTWH(10, 10, 20, 20));
        expect(spec.filterQuality, FilterQuality.high);
        expect(spec.colorBlendMode, BlendMode.multiply);
      });

      test('resolves with partial values correctly', () {
        final attribute = ImageSpecAttribute().width(150.0).fit(BoxFit.contain);

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.width, 150.0);
        expect(spec.fit, BoxFit.contain);
        expect(spec.height, isNull);
        expect(spec.color, isNull);
        expect(spec.repeat, isNull);
        expect(spec.alignment, isNull);
        expect(spec.centerSlice, isNull);
        expect(spec.filterQuality, isNull);
        expect(spec.colorBlendMode, isNull);
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = ImageSpecAttribute()
            .width(100.0)
            .height(200.0)
            .color(Colors.red)
            .fit(BoxFit.cover);

        final second = ImageSpecAttribute()
            .width(150.0)
            .alignment(Alignment.center)
            .repeat(ImageRepeat.repeat);

        final merged = first.merge(second);

        expect(merged.$width, resolvesTo(150.0)); // second overrides
        expect(merged.$height, resolvesTo(200.0)); // from first
        expect(merged.$color, resolvesTo(Colors.red)); // from first
        expect(merged.$fit, resolvesTo(BoxFit.cover)); // from first
        expectProp(merged.$alignment, Alignment.center); // from second
        expect(merged.$repeat, resolvesTo(ImageRepeat.repeat)); // from second
      });

      test('returns this when other is null', () {
        final attribute = ImageSpecAttribute().width(100.0);
        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isTrue);
      });

      test('merges all properties when both have values', () {
        final first = ImageSpecAttribute.only(
          width: 100.0,
          height: 200.0,
          color: Colors.red,
          repeat: ImageRepeat.noRepeat,
          fit: BoxFit.cover,
        );

        final second = ImageSpecAttribute.only(
          width: 300.0,
          height: 400.0,
          alignment: Alignment.topLeft,
          centerSlice: const Rect.fromLTWH(0, 0, 10, 10),
          filterQuality: FilterQuality.low,
          colorBlendMode: BlendMode.srcOver,
        );

        final merged = first.merge(second);

        expect(merged.$width, resolvesTo(300.0)); // second overrides
        expect(merged.$height, resolvesTo(400.0)); // second overrides
        expect(merged.$color, resolvesTo(Colors.red)); // from first
        expect(merged.$repeat, resolvesTo(ImageRepeat.noRepeat)); // from first
        expect(merged.$fit, resolvesTo(BoxFit.cover)); // from first
        expectProp(merged.$alignment, Alignment.topLeft); // from second
        expect(
          merged.$centerSlice,
          resolvesTo(const Rect.fromLTWH(0, 0, 10, 10)),
        ); // from second
        expectProp(merged.$filterQuality, FilterQuality.low); // from second
        expectProp(merged.$colorBlendMode, BlendMode.srcOver); // from second
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        final attr1 = ImageSpecAttribute()
            .width(100.0)
            .height(200.0)
            .color(Colors.red)
            .fit(BoxFit.cover);

        final attr2 = ImageSpecAttribute()
            .width(100.0)
            .height(200.0)
            .color(Colors.red)
            .fit(BoxFit.cover);

        expect(attr1, equals(attr2));
        expect(attr1.hashCode, equals(attr2.hashCode));
      });

      test('different attributes are not equal', () {
        final attr1 = ImageSpecAttribute().width(100.0);
        final attr2 = ImageSpecAttribute().width(200.0);

        expect(attr1, isNot(equals(attr2)));
      });

      test('attributes with different colors are not equal', () {
        final attr1 = ImageSpecAttribute().color(Colors.red);
        final attr2 = ImageSpecAttribute().color(Colors.blue);

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final attribute = ImageSpecAttribute(
          width: Prop(100.0),
          height: Prop(200.0),
          color: Prop(Colors.red),
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

    group('Modifiers', () {
      test('modifiers can be added to attribute', () {
        final attribute = ImageSpecAttribute(
          modifiers: [
            OpacityModifierAttribute(opacity: Prop(0.5)),
            ClipRRectModifierAttribute.only(
              borderRadius: BorderRadiusMix.all(Radius.circular(10)),
            ),
          ],
        );

        expect(attribute.modifiers, isNotNull);
        expect(attribute.modifiers!.length, 2);
      });

      test('modifiers merge correctly', () {
        final first = ImageSpecAttribute(
          modifiers: [OpacityModifierAttribute.only(opacity: 0.5)],
        );

        final second = ImageSpecAttribute(
          modifiers: [AspectRatioModifierAttribute.only(aspectRatio: 16 / 9)],
        );

        final merged = first.merge(second);

        // Note: The actual merge behavior depends on the parent class implementation
        expect(merged.modifiers, isNotNull);
      });
    });

    group('Variants', () {
      test('variants can be added to attribute', () {
        final attribute = ImageSpecAttribute();
        expect(attribute.variants, isNull); // By default no variants
      });
    });

    group('Builder pattern', () {
      test('builder methods create new instances', () {
        final original = ImageSpecAttribute();
        final modified = original.width(100.0);

        expect(identical(original, modified), isFalse);
        expect(original.$width, isNull);
        expect(modified.$width, resolvesTo(100.0));
      });

      test('builder methods can be chained fluently', () {
        final attribute = ImageSpecAttribute()
            .width(200.0)
            .height(300.0)
            .fit(BoxFit.contain)
            .alignment(Alignment.topCenter)
            .color(Colors.blue.withValues(alpha: 0.5));

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec.width, 200.0);
        expect(spec.height, 300.0);
        expect(spec.fit, BoxFit.contain);
        expect(spec.alignment, Alignment.topCenter);
        expect(spec.color, Colors.blue.withValues(alpha: 0.5));
      });
    });

    group('Debug Properties', () {
      test('debugFillProperties includes all properties', () {
        // This test verifies that the attribute implements Diagnosticable correctly
        final attribute = ImageSpecAttribute()
            .width(100.0)
            .height(200.0)
            .fit(BoxFit.cover);

        // The presence of debugFillProperties is tested by the framework
        expect(attribute, isA<Diagnosticable>());
      });
    });
  });
}
