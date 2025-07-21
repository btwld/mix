import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';

const $testvariant = NamedVariant('test');
void main() {
  group('FlexBoxUtility', () {
    final flexBoxUtility = FlexBoxSpecUtility.self;

    test('call() returns correct instance', () {
      final flexBox = flexBoxUtility
        ..box.alignment.center()
        ..box.padding(10)
        ..box.margin(10)
        ..box.constraints.maxWidth(200)
        ..box.width(10)
        ..box.height(10)
        ..box.transform(Matrix4.identity())
        ..box.clipBehavior.antiAlias()
        ..flex.mainAxisAlignment.center()
        ..flex.crossAxisAlignment.center();

      final attr = flexBox.attribute;

      expect(attr.box!.alignment, resolvesTo(Alignment.center));
      expect(attr.box!.clipBehavior, resolvesTo(Clip.antiAlias));
      expect(attr.box!.constraints!.mixValue!.maxWidth, resolvesTo(200));
      expect(attr.box!.height, resolvesTo(10));
      expect(attr.box!.margin, resolvesTo(const EdgeInsets.all(10)));
      expect(attr.box!.padding, resolvesTo(const EdgeInsets.all(10)));
      expect(attr.box!.transform, resolvesTo(Matrix4.identity()));
      expect(attr.box!.width, resolvesTo(10));
      expect(attr.flex!.mainAxisAlignment, MainAxisAlignment.center);
      expect(attr.flex!.crossAxisAlignment, CrossAxisAlignment.center);
    });

    test('box alignment returns correct instance', () {
      final flexBox = flexBoxUtility..box.alignment.center();
      expect(flexBox.attribute.box!.alignment, resolvesTo(Alignment.center));
    });

    test('box clipBehavior returns correct instance', () {
      final flexBox = flexBoxUtility..box.clipBehavior.antiAlias();
      expect(flexBox.attribute.box!.clipBehavior, resolvesTo(Clip.antiAlias));
    });

    test('box color returns correct instance', () {
      final flexBox = flexBoxUtility..box.color.blue();
      expect(
        (flexBox.attribute.box!.decoration?.mixValue as BoxDecorationMix).color,
        isA<Prop<Color>>(),
      );
    });

    test('box constraints returns correct instance', () {
      expect(flexBoxUtility.box.constraints, isA<BoxConstraintsUtility>());
    });

    test('box shape returns correct instance', () {
      expect(flexBoxUtility.box.shapeDecoration, isA<ShapeDecorationUtility>());
    });

    test('box height returns correct instance', () {
      final flexBox = flexBoxUtility..box.height(10);
      expect(flexBox.attribute.box!.height, resolvesTo(10));
    });

    test('box margin returns correct instance', () {
      expect(flexBoxUtility.box.margin, isA<EdgeInsetsGeometryUtility>());
    });

    test('box padding returns correct instance', () {
      expect(flexBoxUtility.box.padding, isA<EdgeInsetsGeometryUtility>());
    });

    test('box transform returns correct instance', () {
      final flexBox = flexBoxUtility..box.transform(Matrix4.identity());
      expect(flexBox.attribute.box!.transform, resolvesTo(Matrix4.identity()));
    });

    test('box width returns correct instance', () {
      final flexBox = flexBoxUtility..box.width(10);
      expect(flexBox.attribute.box!.width, resolvesTo(10));
    });

    test('box decoration returns correct instance', () {
      final flexBox = flexBoxUtility
        ..box.decoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber,
        );

      final decoration =
          flexBox.attribute.box!.decoration?.mixValue as BoxDecorationMix;
      expect(decoration.color, isA<Prop<Color>>());
      expect(
        decoration.borderRadius?.mixValue,
        BorderRadiusMix.value(BorderRadius.circular(10)),
      );
    });

    test('box foregroundDecoration returns correct instance', () {
      final flexBox = flexBoxUtility
        ..box.foregroundDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber,
        );

      final foregroundDecoration =
          flexBox.attribute.box!.foregroundDecoration?.mixValue
              as BoxDecorationMix;
      expect(
        foregroundDecoration.color,
        isA<Prop<Color>>(),
        reason: 'The color is not correct',
      );
      expect(
        foregroundDecoration.borderRadius?.mixValue,
        BorderRadiusMix.value(BorderRadius.circular(10)),
        reason: 'The BorderRadius is not correct',
      );
    });

    test('flex properties return correct instances', () {
      final flexBox = flexBoxUtility
        ..flex.mainAxisAlignment.center()
        ..flex.crossAxisAlignment.center()
        ..flex.mainAxisSize.min()
        ..flex.direction.horizontal()
        ..flex.verticalDirection.down()
        ..flex.textDirection.ltr()
        ..flex.textBaseline.alphabetic()
        ..flex.clipBehavior.antiAlias()
        ..flex.gap(10);

      final attr = flexBox.attribute.flex!;
      expect(attr.mainAxisAlignment, MainAxisAlignment.center);
      expect(attr.crossAxisAlignment, CrossAxisAlignment.center);
      expect(attr.mainAxisSize, MainAxisSize.min);
      expect(attr.direction, Axis.horizontal);
      expect(attr.verticalDirection, VerticalDirection.down);
      expect(attr.textDirection, TextDirection.ltr);
      expect(attr.textBaseline, TextBaseline.alphabetic);
      expect(attr.clipBehavior, Clip.antiAlias);
      expect(attr.gap, const SpaceDto.value(10));
    });
  });
}
