import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Spec Utilities Global Getters', () {
    test('\$box returns BoxSpecAttribute instance', () {
      expect($box, isA<BoxSpecAttribute>());
      // Each call returns a new instance
      expect($box, isNot(same($box)));
    });

    test('\$flexbox returns FlexBoxSpecUtility singleton', () {
      expect($flexbox, isA<FlexBoxSpecUtility>());
      expect($flexbox, same($flexbox)); // Singleton instance
    });

    test('\$flex returns FlexSpecAttribute instance', () {
      expect($flex, isA<FlexSpecAttribute>());
      // Each call returns a new instance
      expect($flex, isNot(same($flex)));
    });

    test('\$image returns ImageSpecAttribute instance', () {
      expect($image, isA<ImageSpecAttribute>());
      // Each call returns a new instance
      expect($image, isNot(same($image)));
    });

    test('\$icon returns IconSpecAttribute instance', () {
      expect($icon, isA<IconSpecAttribute>());
      // Each call returns a new instance
      expect($icon, isNot(same($icon)));
    });

    test('\$text returns TextSpecAttribute instance', () {
      expect($text, isA<TextSpecAttribute>());
      // Each call returns a new instance
      expect($text, isNot(same($text)));
    });

    test('\$stack returns StackSpecAttribute instance', () {
      expect($stack, isA<StackSpecAttribute>());
      // Each call returns a new instance
      expect($stack, isNot(same($stack)));
    });

    test('\$on returns OnContextVariantUtility instance', () {
      expect($on, isA<OnContextVariantUtility>());
      // Each call returns a new instance
      expect($on, isNot(same($on)));
    });

    test('\$wrap returns ModifierUtility instance', () {
      expect($wrap, isA<ModifierUtility>());
      // Each call returns a new instance
      expect($wrap, isNot(same($wrap)));
    });
  });

  group('Utility Functionality', () {
    test('box getter can be used to create attributes', () {
      final attr = $box.width(100).height(200);
      expect(attr, isA<BoxSpecAttribute>());
    });

    test('flex getter can be used to create attributes', () {
      final attr = $flex.direction(Axis.horizontal);
      expect(attr, isA<FlexSpecAttribute>());
    });

    test('flexbox getter provides utility methods', () {
      expect($flexbox, isA<FlexBoxSpecUtility>());
      expect($flexbox, same(FlexBoxSpecUtility.self));
    });

    test('image getter can be used to create attributes', () {
      final attr = $image.fit(BoxFit.cover);
      expect(attr, isA<ImageSpecAttribute>());
    });

    test('icon getter can be used to create attributes', () {
      final attr = $icon.size(24);
      expect(attr, isA<IconSpecAttribute>());
    });

    test('text getter can be used to create attributes', () {
      final attr = $text.style.fontSize(16);
      expect(attr, isA<TextSpecAttribute>());
    });

    test('stack getter can be used to create attributes', () {
      final attr = $stack.alignment(Alignment.center);
      expect(attr, isA<StackSpecAttribute>());
    });

    test('on getter can be used for variant utilities', () {
      expect($on, isA<OnContextVariantUtility<MultiSpec, Style>>());
      final hoverBuilder = $on.hover;
      expect(hoverBuilder, isA<VariantAttributeBuilder<MultiSpec>>());
    });

    test('wrap getter can be used for modifier utilities', () {
      expect($wrap, isA<ModifierUtility>());
      final opacityModifier = $wrap.opacity(0.5);
      expect(opacityModifier, isA<StyleAttribute>());
    });
  });

  group('Global getters behavior', () {
    test('attribute getters return new instances each time', () {
      // Test that attribute getters return new instances (not cached)
      expect($box, isNot(same($box)));
      expect($flex, isNot(same($flex)));
      expect($image, isNot(same($image)));
      expect($icon, isNot(same($icon)));
      expect($text, isNot(same($text)));
      expect($stack, isNot(same($stack)));
      expect($on, isNot(same($on)));
      expect($wrap, isNot(same($wrap)));
    });

    test('singleton getters return same instance', () {
      // Test that singleton getters return the same instance
      expect($flexbox, same($flexbox));
    });

    test('all getters return correct types', () {
      expect($box, isA<BoxSpecAttribute>());
      expect($flex, isA<FlexSpecAttribute>());
      expect($flexbox, isA<FlexBoxSpecUtility>());
      expect($image, isA<ImageSpecAttribute>());
      expect($icon, isA<IconSpecAttribute>());
      expect($text, isA<TextSpecAttribute>());
      expect($stack, isA<StackSpecAttribute>());
      expect($on, isA<OnContextVariantUtility>());
      expect($wrap, isA<ModifierUtility>());
    });
  });
}
