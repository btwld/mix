import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

const $testvariant = Variant('test');
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

      final attr = flexBox.attributeValue!;

      expect(attr.box!.alignment, Alignment.center);
      expect(attr.box!.clipBehavior, Clip.antiAlias);
      expect(attr.box!.constraints!.maxWidth, 200);
      expect(attr.box!.height, 10);
      expect(attr.box!.margin, const EdgeInsets.all(10).toDto());
      expect(attr.box!.padding, const EdgeInsets.all(10).toDto());
      expect(attr.box!.transform, Matrix4.identity());
      expect(attr.box!.width, 10);
      expect(attr.flex!.mainAxisAlignment, MainAxisAlignment.center);
      expect(attr.flex!.crossAxisAlignment, CrossAxisAlignment.center);
    });

    test('box alignment returns correct instance', () {
      final flexBox = flexBoxUtility..box.alignment.center();
      expect(flexBox.attributeValue!.box!.alignment, Alignment.center);
    });

    test('box clipBehavior returns correct instance', () {
      final flexBox = flexBoxUtility..box.clipBehavior.antiAlias();
      expect(flexBox.attributeValue!.box!.clipBehavior, Clip.antiAlias);
    });

    test('box color returns correct instance', () {
      final flexBox = flexBoxUtility..box.color.blue();
      expect(
        (flexBox.attributeValue!.box!.decoration as BoxDecorationDto).color,
        const ColorDto(Colors.blue),
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
      expect(flexBox.attributeValue!.box!.height, 10);
    });

    test('box margin returns correct instance', () {
      expect(flexBoxUtility.box.margin, isA<EdgeInsetsGeometryUtility>());
    });

    test('box padding returns correct instance', () {
      expect(flexBoxUtility.box.padding, isA<EdgeInsetsGeometryUtility>());
    });

    test('box transform returns correct instance', () {
      final flexBox = flexBoxUtility..box.transform(Matrix4.identity());
      expect(flexBox.attributeValue!.box!.transform, Matrix4.identity());
    });

    test('box width returns correct instance', () {
      final flexBox = flexBoxUtility..box.width(10);
      expect(flexBox.attributeValue!.box!.width, 10);
    });

    test('box decoration returns correct instance', () {
      final flexBox = flexBoxUtility
        ..box.decoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber,
        );

      final decoration =
          flexBox.attributeValue!.box!.decoration as BoxDecorationDto;
      expect(decoration.color, const ColorDto(Colors.amber));
      expect(
        decoration.borderRadius,
        BorderRadius.circular(10).toDto(),
      );
    });

    test('box foregroundDecoration returns correct instance', () {
      final flexBox = flexBoxUtility
        ..box.foregroundDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber,
        );

      final foregroundDecoration =
          flexBox.attributeValue!.box!.foregroundDecoration as BoxDecorationDto;
      expect(
        foregroundDecoration.color,
        const ColorDto(Colors.amber),
        reason: 'The color is not correct',
      );
      expect(
        foregroundDecoration.borderRadius,
        BorderRadius.circular(10).toDto(),
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

      final attr = flexBox.attributeValue!.flex!;
      expect(attr.mainAxisAlignment, MainAxisAlignment.center);
      expect(attr.crossAxisAlignment, CrossAxisAlignment.center);
      expect(attr.mainAxisSize, MainAxisSize.min);
      expect(attr.direction, Axis.horizontal);
      expect(attr.verticalDirection, VerticalDirection.down);
      expect(attr.textDirection, TextDirection.ltr);
      expect(attr.textBaseline, TextBaseline.alphabetic);
      expect(attr.clipBehavior, Clip.antiAlias);
      expect(attr.gap!.value, 10);
    });
  });
}
