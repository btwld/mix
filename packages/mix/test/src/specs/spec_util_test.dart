import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Styler Chain Getters', () {
    test('BoxStyler.chain returns BoxMutableStyler instance', () {
      expect(BoxStyler.chain, isA<BoxMutableStyler>());
      expect(BoxStyler.chain, isNot(same(BoxStyler.chain)));
    });

    test('FlexBoxStyler.chain returns FlexBoxMutableStyler instance', () {
      expect(FlexBoxStyler.chain, isA<FlexBoxMutableStyler>());
      expect(FlexBoxStyler.chain, isNot(same(FlexBoxStyler.chain)));
    });

    test('FlexStyler.chain returns FlexMutableStyler instance', () {
      expect(FlexStyler.chain, isA<FlexMutableStyler>());
      expect(FlexStyler.chain, isNot(same(FlexStyler.chain)));
    });

    test('ImageStyler.chain returns ImageMutableStyler instance', () {
      expect(ImageStyler.chain, isA<ImageMutableStyler>());
      expect(ImageStyler.chain, isNot(same(ImageStyler.chain)));
    });

    test('IconStyler.chain returns IconMutableStyler instance', () {
      expect(IconStyler.chain, isA<IconMutableStyler>());
      expect(IconStyler.chain, isNot(same(IconStyler.chain)));
    });

    test('TextStyler.chain returns TextMutableStyler instance', () {
      expect(TextStyler.chain, isA<TextMutableStyler>());
      expect(TextStyler.chain, isNot(same(TextStyler.chain)));
    });

    test('StackStyler.chain returns StackMutableStyler instance', () {
      expect(StackStyler.chain, isA<StackMutableStyler>());
      expect(StackStyler.chain, isNot(same(StackStyler.chain)));
    });

    test('StackBoxStyler.chain returns StackBoxMutableStyler instance', () {
      expect(StackBoxStyler.chain, isA<StackBoxMutableStyler>());
      expect(StackBoxStyler.chain, isNot(same(StackBoxStyler.chain)));
    });
  });

  group('Chain Functionality', () {
    test('BoxStyler.chain can be used to build styles', () {
      final box = BoxStyler.chain
        ..width(100)
        ..height(200);
      expect(box, isA<BoxMutableStyler>());
    });

    test('FlexStyler.chain can be used to build styles', () {
      final flex = FlexStyler.chain..direction(Axis.horizontal);
      expect(flex, isA<FlexMutableStyler>());
    });

    test('FlexBoxStyler.chain can be used to build styles', () {
      final flexBox = FlexBoxStyler.chain..direction(Axis.vertical);
      expect(flexBox, isA<FlexBoxMutableStyler>());
    });

    test('ImageStyler.chain can be used to build styles', () {
      final image = ImageStyler.chain..fit(BoxFit.cover);
      expect(image, isA<ImageMutableStyler>());
    });

    test('IconStyler.chain can be used to build styles', () {
      final icon = IconStyler.chain..size(24);
      expect(icon, isA<IconMutableStyler>());
    });

    test('TextStyler.chain can be used to build styles', () {
      final text = TextStyler.chain..style.fontSize(16);
      expect(text, isA<TextMutableStyler>());
    });

    test('StackStyler.chain can be used to build styles', () {
      final stack = StackStyler.chain..alignment(Alignment.center);
      expect(stack, isA<StackMutableStyler>());
    });

    test('StackBoxStyler.chain can be used to build styles', () {
      final stackBox = StackBoxStyler.chain..alignment(Alignment.center);
      expect(stackBox, isA<StackBoxMutableStyler>());
    });
  });
}
