import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Spec Utilities Global Getters', () {
    test('\$box returns BoxSpecAttribute instance', () {
      expect($box, isA<BoxSpecAttribute>());
      expect($box, same($box)); // Same cached instance
    });

    test('\$flexbox returns FlexBoxSpecUtility instance', () {
      expect($flexbox, isA<FlexBoxSpecUtility>());
      expect($flexbox, same($flexbox));
    });

    test('\$flex returns FlexSpecAttribute instance', () {
      expect($flex, isA<FlexSpecAttribute>());
      expect($flex, same($flex)); // Same cached instance
    });

    test('\$image returns ImageSpecAttribute instance', () {
      expect($image, isA<ImageSpecAttribute>());
      expect($image, same($image)); // Same cached instance
    });

    test('\$icon returns IconSpecAttribute instance', () {
      expect($icon, isA<IconSpecAttribute>());
      expect($icon, same($icon)); // Same cached instance
    });

    test('\$text returns TextSpecAttribute instance', () {
      expect($text, isA<TextSpecAttribute>());
      expect($text, same($text)); // Same cached instance
    });

    test('\$stack returns StackSpecAttribute instance', () {
      expect($stack, isA<StackSpecAttribute>());
      expect($stack, same($stack)); // Same cached instance
    });

    test('\$on returns OnContextVariantUtility instance', () {
      expect($on, isA<OnContextVariantUtility>());
      expect($on, same($on));
    });
  });

  group('MixUtilities', () {
    test('box getter returns BoxSpecAttribute instance', () {
      expect($box, isA<BoxSpecAttribute>());
    });

    test('flex getter returns FlexSpecAttribute instance', () {
      expect($flex, isA<FlexSpecAttribute>());
    });

    test('flexbox getter returns FlexBoxSpecUtility singleton', () {
      expect($flexbox, isA<FlexBoxSpecUtility>());
      expect($flexbox, same(FlexBoxSpecUtility.self));
    });

    test('image getter returns ImageSpecAttribute instance', () {
      expect($image, isA<ImageSpecAttribute>());
    });

    test('icon getter returns IconSpecAttribute instance', () {
      expect($icon, isA<IconSpecAttribute>());
    });

    test('text getter returns TextSpecAttribute instance', () {
      expect($text, isA<TextSpecAttribute>());
    });

    test('stack getter returns StackSpecAttribute instance', () {
      expect($stack, isA<StackSpecAttribute>());
    });

    test('on getter returns OnContextVariantUtility singleton', () {
      expect($on, isA<OnContextVariantUtility>());
      expect(
        $on,
        same(OnContextVariantUtility<MultiSpec, Style>((v) => Style(v))),
      );
    });
  });

  group('Global getters consistency', () {
    test('global getters use the same MixUtilities instance', () {
      // Test that global getters always return the same instance
      expect($box, same($box));
      expect($flexbox, same($flexbox));
      expect($flex, same($flex));
      expect($image, same($image));
      expect($icon, same($icon));
      expect($text, same($text));
      expect($stack, same($stack));
      expect($on, same($on));
    });
  });
}
