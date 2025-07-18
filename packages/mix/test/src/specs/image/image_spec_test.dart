import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ImageSpec', () {
    test('resolve returns correct recipe', () {
      final recipe = ImageSpec.from(EmptyMixData);

      expect(recipe.width, null);
      expect(recipe.height, null);
      expect(recipe.color, null);
      expect(recipe.repeat, null);
      expect(recipe.fit, null);
    });

    test('lerp returns correct ImageSpec', () {
      const spec1 = ImageSpec(
        width: 100,
        height: 200,
        color: Colors.red,
        repeat: ImageRepeat.repeat,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
        centerSlice: Rect.zero,
        filterQuality: FilterQuality.low,
        colorBlendMode: BlendMode.srcOver,
      );
      const spec2 = ImageSpec(
        width: 150,
        height: 250,
        color: Colors.blue,
        repeat: ImageRepeat.noRepeat,
        fit: BoxFit.fill,
        alignment: Alignment.bottomCenter,
        centerSlice: Rect.fromLTRB(0, 0, 0, 0),
        filterQuality: FilterQuality.high,
        colorBlendMode: BlendMode.colorBurn,
      );
      final lerpSpec = spec1.lerp(spec2, 0.5);

      expect(lerpSpec.width, MixHelpers.lerpDouble(100, 150, 0.5));
      expect(lerpSpec.height, MixHelpers.lerpDouble(200, 250, 0.5));
      expect(lerpSpec.color, Color.lerp(Colors.red, Colors.blue, 0.5));
      expect(lerpSpec.repeat, ImageRepeat.noRepeat);
      expect(lerpSpec.fit, BoxFit.fill);
      expect(lerpSpec.alignment, Alignment.bottomCenter);
      expect(lerpSpec.centerSlice, const Rect.fromLTRB(0, 0, 0, 0));
      expect(lerpSpec.filterQuality, FilterQuality.high);
      expect(lerpSpec.colorBlendMode, BlendMode.colorBurn);
    });

    test('copyWith returns correct ImageSpec', () {
      const spec = ImageSpec(
        width: 100,
        height: 200,
        color: Colors.red,
        repeat: ImageRepeat.repeat,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
        centerSlice: Rect.fromLTRB(0, 0, 0, 0),
        filterQuality: FilterQuality.low,
        colorBlendMode: BlendMode.srcOver,
      );
      final copiedSpec = spec.copyWith(
        width: 150,
        height: 250,
        color: Colors.blue,
        repeat: ImageRepeat.noRepeat,
        fit: BoxFit.fill,
        alignment: Alignment.topCenter,
        centerSlice: Rect.zero,
        filterQuality: FilterQuality.none,
        colorBlendMode: BlendMode.clear,
      );

      expect(copiedSpec.width, 150);
      expect(copiedSpec.height, 250);
      expect(copiedSpec.color, Colors.blue);
      expect(copiedSpec.repeat, ImageRepeat.noRepeat);
      expect(copiedSpec.fit, BoxFit.fill);
      expect(copiedSpec.alignment, Alignment.topCenter);
      expect(copiedSpec.centerSlice, Rect.zero);
      expect(copiedSpec.filterQuality, FilterQuality.none);
      expect(copiedSpec.colorBlendMode, BlendMode.clear);
    });

    test('props returns correct list of properties', () {
      const spec = ImageSpec(
        width: 100,
        height: 200,
        color: Colors.red,
        repeat: ImageRepeat.repeat,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
        centerSlice: Rect.zero,
        filterQuality: FilterQuality.low,
        colorBlendMode: BlendMode.srcOver,
      );

      T getValueOf<T>(T field) => (spec.props[spec.props.indexOf(field)]) as T;

      expect(getValueOf(spec.width), 100);
      expect(getValueOf(spec.height), 200);
      expect(getValueOf(spec.color), Colors.red);
      expect(getValueOf(spec.repeat), ImageRepeat.repeat);
      expect(getValueOf(spec.fit), BoxFit.cover);
      expect(getValueOf(spec.alignment), Alignment.bottomCenter);
      expect(getValueOf(spec.centerSlice), Rect.zero);
      expect(getValueOf(spec.filterQuality), FilterQuality.low);
      expect(getValueOf(spec.colorBlendMode), BlendMode.srcOver);
      expect(spec.props.length, 9);
    });
  });

  group('ImageSpecUtility fluent', () {
    test('fluent behavior', () {
      final image = ImageSpecUtility.self;

      final util = image
        ..width(100)
        ..height(200)
        ..color.red()
        ..fit.cover();

      final attr = util.attributeValue!;

      expect(util, isA<Style>());
      expect(attr.width, 100);
      expect(attr.height, 200);
      expect(attr.color, isA<Prop<Color>>());
      expect(attr.fit, BoxFit.cover);

      final style = Style(util);

      final imageAttribute = style.styles.attributeOfType<ImageSpecAttribute>();

      expect(imageAttribute?.width, 100);
      expect(imageAttribute?.height, 200);
      expect(imageAttribute?.color, isA<Prop<Color>>());
      expect(imageAttribute?.fit, BoxFit.cover);

      final mixData = style.of(MockBuildContext());
      final imageSpec = ImageSpec.from(mixData);

      expect(imageSpec.width, 100);
      expect(imageSpec.height, 200);
      expect(imageSpec.color, Colors.red);
      expect(imageSpec.fit, BoxFit.cover);
    });

    test('Immutable behavior when having multiple images', () {
      final image1 = ImageSpecUtility.self..width(100);
      final image2 = ImageSpecUtility.self..width(200);

      final attr1 = image1.attributeValue!;
      final attr2 = image2.attributeValue!;

      expect(attr1.width, 100);
      expect(attr2.width, 200);

      final style1 = Style(image1);
      final style2 = Style(image2);

      final imageAttribute1 = style1.styles
          .attributeOfType<ImageSpecAttribute>();
      final imageAttribute2 = style2.styles
          .attributeOfType<ImageSpecAttribute>();

      expect(imageAttribute1?.width, 100);
      expect(imageAttribute2?.width, 200);

      final mixData1 = style1.of(MockBuildContext());
      final mixData2 = style2.of(MockBuildContext());

      final imageSpec1 = ImageSpec.from(mixData1);
      final imageSpec2 = ImageSpec.from(mixData2);

      expect(imageSpec1.width, 100);
      expect(imageSpec2.width, 200);
    });

    test('Mutate behavior and not on same utility', () {
      final image = ImageSpecUtility.self;

      final imageValue = image;
      imageValue
        ..width(100)
        ..color.red()
        ..fit.cover();

      final imageAttribute = imageValue.attributeValue!;
      final imageAttribute2 = image.width(200);

      expect(imageAttribute.width, 100);
      expect(imageAttribute.color, isA<Prop<Color>>());
      expect(imageAttribute.fit, BoxFit.cover);

      expect(imageAttribute2.width, 200);
      expect(imageAttribute2.color, isNull);
      expect(imageAttribute2.fit, isNull);
    });
  });
}
