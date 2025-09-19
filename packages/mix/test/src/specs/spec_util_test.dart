import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Spec Utilities Global Getters', () {
    test('\$box returns BoxMutableStyler instance', () {
      expect($box, isA<BoxMutableStyler>());
      // Each call returns a new instance
      expect($box, isNot(same($box)));
    });

    test('\$flexbox returns FlexBoxMutableStyler instance', () {
      expect($flexbox, isA<FlexBoxMutableStyler>());
      expect($flexbox, isNot(same($flexbox))); // New instance each time
    });

    test('\$flex returns FlexMutableStyler instance', () {
      expect($flex, isA<FlexMutableStyler>());
      // Each call returns a new instance
      expect($flex, isNot(same($flex)));
    });

    test('\$image returns ImageMutableStyler instance', () {
      expect($image, isA<ImageMutableStyler>());
      // Each call returns a new instance
      expect($image, isNot(same($image)));
    });

    test('\$icon returns IconMutableStyler instance', () {
      expect($icon, isA<IconMutableStyler>());
      // Each call returns a new instance
      expect($icon, isNot(same($icon)));
    });

    test('\$text returns TextMutableStyler instance', () {
      expect($text, isA<TextMutableStyler>());
      // Each call returns a new instance
      expect($text, isNot(same($text)));
    });

    test('\$stack returns StackMutableStyler instance', () {
      expect($stack, isA<StackMutableStyler>());
      // Each call returns a new instance
      expect($stack, isNot(same($stack)));
    });
  });

  group('Utility Functionality', () {
    test('box getter can be used to create attributes', () {
      final box = $box
        ..width(100)
        ..height(200);
      expect(box, isA<BoxMutableStyler>());
    });

    test('flex getter can be used to create attributes', () {
      final flex = $flex..direction(Axis.horizontal);
      expect(flex, isA<FlexMutableStyler>());
    });

    test('flexbox getter provides utility methods', () {
      expect($flexbox, isA<FlexBoxMutableStyler>());
      // Verify it can be used to create attributes
      final flexbox = $flexbox..direction(Axis.vertical);
      expect(flexbox, isA<FlexBoxMutableStyler>());
    });

    test('image getter can be used to create attributes', () {
      final image = $image..fit(BoxFit.cover);
      expect(image, isA<ImageMutableStyler>());
    });

    test('icon getter can be used to create attributes', () {
      final icon = $icon..size(24);
      expect(icon, isA<IconMutableStyler>());
    });

    test('text getter can be used to create attributes', () {
      final text = $text..style.fontSize(16);
      expect(text, isA<TextMutableStyler>());
    });

    test('stack getter can be used to create attributes', () {
      final stack = $stack..alignment(Alignment.center);
      expect(stack, isA<StackMutableStyler>());
    });
  });

  group('Global getters behavior', () {
    test('utility getters return new instances each time', () {
      // Test that utility getters return new instances (not cached)
      expect($box, isNot(same($box)));
      expect($flex, isNot(same($flex)));
      expect($image, isNot(same($image)));
      expect($icon, isNot(same($icon)));
      expect($text, isNot(same($text)));
      expect($stack, isNot(same($stack)));
    });

    test('utility getters behave consistently', () {
      // Test that utility getters return new instances consistently
      expect($flexbox, isNot(same($flexbox)));
    });

    test('all getters return correct types', () {
      expect($box, isA<BoxMutableStyler>());
      expect($flex, isA<FlexMutableStyler>());
      expect($flexbox, isA<FlexBoxMutableStyler>());
      expect($image, isA<ImageMutableStyler>());
      expect($icon, isA<IconMutableStyler>());
      expect($text, isA<TextMutableStyler>());
      expect($stack, isA<StackMutableStyler>());
    });
  });
}
