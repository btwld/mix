import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Mix Utility Globals', () {
    test('\$box returns BoxSpecUtility instance', () {
      expect($box, isA<BoxSpecUtility>());
      // They're getter properties, so always return the same instance
      expect($box, equals($box));
    });

    test('\$flexbox returns FlexBoxSpecUtility instance', () {
      expect($flexbox, isA<FlexBoxSpecUtility>());
      expect($flexbox, equals($flexbox));
    });

    test('\$flex returns FlexSpecUtility instance', () {
      expect($flex, isA<FlexSpecUtility>());
      expect($flex, equals($flex));
    });

    test('\$image returns ImageSpecUtility instance', () {
      expect($image, isA<ImageSpecUtility>());
      expect($image, equals($image));
    });

    test('\$icon returns IconSpecUtility instance', () {
      expect($icon, isA<IconSpecUtility>());
      expect($icon, equals($icon));
    });

    test('\$text returns TextSpecUtility instance', () {
      expect($text, isA<TextSpecUtility>());
      expect($text, equals($text));
    });

    test('\$stack returns StackSpecUtility instance', () {
      expect($stack, isA<StackSpecUtility>());
      expect($stack, equals($stack));
    });

    test('\$on returns OnContextVariantUtility instance', () {
      expect($on, isA<OnContextVariantUtility>());
      expect($on, equals($on));
    });

    test('\$with returns WithModifierUtility instance', () {
      expect($with, isA<WithModifierUtility>());
      expect($with, equals($with));
    });
  });

  group('MixUtilities', () {
    const utilities = MixUtilities();

    test('box returns BoxSpecUtility.self', () {
      expect(utilities.box, BoxSpecUtility.self);
      expect(utilities.box, isA<BoxSpecUtility>());
    });

    test('flexbox returns FlexBoxSpecUtility.self', () {
      expect(utilities.flexbox, FlexBoxSpecUtility.self);
      expect(utilities.flexbox, isA<FlexBoxSpecUtility>());
    });

    test('flex returns FlexSpecUtility.self', () {
      expect(utilities.flex, FlexSpecUtility.self);
      expect(utilities.flex, isA<FlexSpecUtility>());
    });

    test('image returns ImageSpecUtility.self', () {
      expect(utilities.image, ImageSpecUtility.self);
      expect(utilities.image, isA<ImageSpecUtility>());
    });

    test('icon returns IconSpecUtility.self', () {
      expect(utilities.icon, IconSpecUtility.self);
      expect(utilities.icon, isA<IconSpecUtility>());
    });

    test('text returns TextSpecUtility.self', () {
      expect(utilities.text, TextSpecUtility.self);
      expect(utilities.text, isA<TextSpecUtility>());
    });

    test('stack returns StackSpecUtility.self', () {
      expect(utilities.stack, StackSpecUtility.self);
      expect(utilities.stack, isA<StackSpecUtility>());
    });

    test('on returns OnContextVariantUtility.self', () {
      expect(utilities.on, OnContextVariantUtility.self);
      expect(utilities.on, isA<OnContextVariantUtility>());
    });

    test('mod returns WithModifierUtility.self', () {
      expect(utilities.mod, WithModifierUtility.self);
      expect(utilities.mod, isA<WithModifierUtility>());
    });
  });

  group('Utility usage', () {
    test('utilities can create attributes', () {
      // Test that utilities work correctly
      final boxPadding = $box.padding(16);
      expect(boxPadding, isA<BoxSpecAttribute>());

      final textStyle = $text.style.fontSize(14);
      expect(textStyle, isA<TextSpecAttribute>());

      final iconSize = $icon.size(24);
      expect(iconSize, isA<IconSpecAttribute>());

      final flexDirection = $flex.direction.horizontal();
      expect(flexDirection, isA<FlexSpecAttribute>());

      final stackAlignment = $stack.alignment.center();
      expect(stackAlignment, isA<StackSpecAttribute>());

      final imagefit = $image.fit.cover();
      expect(imagefit, isA<ImageSpecAttribute>());

      final onDark = $on.dark($box.color.black());
      expect(onDark, isA<VariantAttribute>());

      final withOpacity = $with.opacity(0.5);
      expect(withOpacity, isA<WidgetModifierSpecAttribute>());
    });
  });
}