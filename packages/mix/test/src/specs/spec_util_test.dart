import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Spec Utilities Global Getters', () {
    test('\$box returns BoxSpecUtility instance', () {
      expect($box, isA<BoxSpecUtility>());
      // Each call returns a new instance
      expect($box, isNot(same($box)));
    });

    test('\$flexbox returns FlexBoxSpecUtility instance', () {
      expect($flexbox, isA<FlexBoxSpecUtility>());
      expect($flexbox, isNot(same($flexbox))); // New instance each time
    });

    test('\$flex returns FlexSpecUtility instance', () {
      expect($flex, isA<FlexSpecUtility>());
      // Each call returns a new instance
      expect($flex, isNot(same($flex)));
    });

    test('\$image returns ImageSpecUtility instance', () {
      expect($image, isA<ImageSpecUtility>());
      // Each call returns a new instance
      expect($image, isNot(same($image)));
    });

    test('\$icon returns IconSpecUtility instance', () {
      expect($icon, isA<IconSpecUtility>());
      // Each call returns a new instance
      expect($icon, isNot(same($icon)));
    });

    test('\$text returns TextSpecUtility instance', () {
      expect($text, isA<TextSpecUtility>());
      // Each call returns a new instance
      expect($text, isNot(same($text)));
    });

    test('\$stack returns StackSpecUtility instance', () {
      expect($stack, isA<StackSpecUtility>());
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
      $box.width(100).height(200);
      expect($box.style, isA<BoxMix>());
    });

    test('flex getter can be used to create attributes', () {
      $flex.direction(Axis.horizontal);
      expect($flex.style, isA<FlexMix>());
    });

    test('flexbox getter provides utility methods', () {
      expect($flexbox, isA<FlexBoxSpecUtility>());
      // Verify it can be used to create attributes
      expect($flexbox.style, isA<FlexBoxMix>());
    });

    test('image getter can be used to create attributes', () {
      $image.fit(BoxFit.cover);
      expect($image.style, isA<ImageMix>());
    });

    test('icon getter can be used to create attributes', () {
      $icon.size(24);
      expect($icon.style, isA<IconMix>());
    });

    test('text getter can be used to create attributes', () {
      $text.style.fontSize(16);
      expect($text.mix, isA<TextMix>());
    });

    test('stack getter can be used to create attributes', () {
      $stack.alignment(Alignment.center);
      expect($stack.style, isA<StackMix>());
    });

    test('on getter can be used for variant utilities', () {
      expect($on, isA<OnContextVariantUtility<MultiSpec, CompoundStyle>>());
      final hoverBuilder = $on.hover;
      expect(hoverBuilder, isA<VariantAttributeBuilder<MultiSpec>>());
    });

    test('wrap getter can be used for modifier utilities', () {
      expect($wrap, isA<ModifierUtility>());
      final opacityModifier = $wrap.opacity(0.5);
      expect(opacityModifier, isA<Style>());
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
      expect($on, isNot(same($on)));
      expect($wrap, isNot(same($wrap)));
    });

    test('utility getters behave consistently', () {
      // Test that utility getters return new instances consistently
      expect($flexbox, isNot(same($flexbox)));
    });

    test('all getters return correct types', () {
      expect($box, isA<BoxSpecUtility>());
      expect($flex, isA<FlexSpecUtility>());
      expect($flexbox, isA<FlexBoxSpecUtility>());
      expect($image, isA<ImageSpecUtility>());
      expect($icon, isA<IconSpecUtility>());
      expect($text, isA<TextSpecUtility>());
      expect($stack, isA<StackSpecUtility>());
      expect($on, isA<OnContextVariantUtility>());
      expect($wrap, isA<ModifierUtility>());
    });
  });
}
