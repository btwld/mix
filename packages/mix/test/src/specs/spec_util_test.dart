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
    final utilities = MixUtilities();

    test('box getter returns BoxSpecAttribute instance', () {
      expect(utilities.box, isA<BoxSpecAttribute>());
    });

    test('flex getter returns FlexSpecAttribute instance', () {
      expect(utilities.flex, isA<FlexSpecAttribute>());
    });

    test('flexbox getter returns FlexBoxSpecUtility singleton', () {
      expect(utilities.flexbox, isA<FlexBoxSpecUtility>());
      expect(utilities.flexbox, same(FlexBoxSpecUtility.self));
    });

    test('image getter returns ImageSpecAttribute instance', () {
      expect(utilities.image, isA<ImageSpecAttribute>());
    });

    test('icon getter returns IconSpecAttribute instance', () {
      expect(utilities.icon, isA<IconSpecAttribute>());
    });

    test('text getter returns TextSpecAttribute instance', () {
      expect(utilities.text, isA<TextSpecAttribute>());
    });

    test('stack getter returns StackSpecAttribute instance', () {
      expect(utilities.stack, isA<StackSpecAttribute>());
    });

    test('on getter returns OnContextVariantUtility singleton', () {
      expect(utilities.on, isA<OnContextVariantUtility>());
      expect(utilities.on, same(OnContextVariantUtility.self));
    });

    test('constructor works', () {
      final instance1 = MixUtilities();
      final instance2 = MixUtilities();
      // Different instances should not be the same
      expect(instance1, isNot(same(instance2)));
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

    test('global getters return new instances except for singletons', () {
      final utilities1 = MixUtilities();
      final utilities2 = MixUtilities();

      // Non-singleton getters return new instances
      expect(identical(utilities1.box, utilities2.box), isFalse);
      expect(identical(utilities1.flex, utilities2.flex), isFalse);
      expect(identical(utilities1.image, utilities2.image), isFalse);
      expect(identical(utilities1.icon, utilities2.icon), isFalse);
      expect(identical(utilities1.text, utilities2.text), isFalse);
      expect(identical(utilities1.stack, utilities2.stack), isFalse);

      // Singleton getters return the same instance
      expect(identical(utilities1.flexbox, utilities2.flexbox), isTrue);
      expect(identical(utilities1.on, utilities2.on), isTrue);
    });
  });
}
