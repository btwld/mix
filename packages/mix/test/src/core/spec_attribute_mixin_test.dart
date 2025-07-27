import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('SpecAttributeMixin wrap convenience methods', () {
    test('wrapOpacity creates OpacityModifierAttribute', () {
      final boxAttr = BoxSpecAttribute();
      final wrappedAttr = boxAttr.wrapOpacity(0.5);

      expect(wrappedAttr.$modifiers, isNotNull);
      expect(wrappedAttr.$modifiers!.length, 1);
      expect(wrappedAttr.$modifiers![0], isA<OpacityModifierAttribute>());

      final opacity = wrappedAttr.$modifiers![0] as OpacityModifierAttribute;
      expect(opacity.opacity?.value, 0.5);
    });

    test('wrapPadding creates PaddingModifierAttribute', () {
      final boxAttr = BoxSpecAttribute();
      final wrappedAttr = boxAttr.wrapPadding(const EdgeInsets.all(16));

      expect(wrappedAttr.$modifiers, isNotNull);
      expect(wrappedAttr.$modifiers!.length, 1);
      expect(wrappedAttr.$modifiers![0], isA<PaddingModifierAttribute>());
    });

    test('wrapPadding accepts different EdgeInsets constructors', () {
      final boxAttr = BoxSpecAttribute();
      
      // Test with EdgeInsets.symmetric
      final symmetric = boxAttr.wrapPadding(
        const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      );
      expect(symmetric.$modifiers![0], isA<PaddingModifierAttribute>());
      
      // Test with EdgeInsets.only
      final only = boxAttr.wrapPadding(
        const EdgeInsets.only(left: 5, top: 10, right: 15, bottom: 20),
      );
      expect(only.$modifiers![0], isA<PaddingModifierAttribute>());
      
      // Test with EdgeInsets.fromLTRB
      final fromLTRB = boxAttr.wrapPadding(
        const EdgeInsets.fromLTRB(1, 2, 3, 4),
      );
      expect(fromLTRB.$modifiers![0], isA<PaddingModifierAttribute>());
    });

    test('wrapClipOval creates ClipOvalModifierAttribute', () {
      final boxAttr = BoxSpecAttribute();
      final wrappedAttr = boxAttr.wrapClipOval();

      expect(wrappedAttr.$modifiers, isNotNull);
      expect(wrappedAttr.$modifiers!.length, 1);
      expect(wrappedAttr.$modifiers![0], isA<ClipOvalModifierAttribute>());
    });

    test('wrapVisibility creates VisibilityModifierAttribute', () {
      final boxAttr = BoxSpecAttribute();
      final wrappedAttr = boxAttr.wrapVisibility(false);

      expect(wrappedAttr.$modifiers, isNotNull);
      expect(wrappedAttr.$modifiers!.length, 1);
      expect(wrappedAttr.$modifiers![0], isA<VisibilityModifierAttribute>());

      final visibility =
          wrappedAttr.$modifiers![0] as VisibilityModifierAttribute;
      expect(visibility.visible?.value, false);
    });

    test('wrapScale creates TransformModifierAttribute with scale', () {
      final boxAttr = BoxSpecAttribute();
      final wrappedAttr = boxAttr.wrapScale(1.5);

      expect(wrappedAttr.$modifiers, isNotNull);
      expect(wrappedAttr.$modifiers!.length, 1);
      expect(wrappedAttr.$modifiers![0], isA<TransformModifierAttribute>());
    });

    test('wrapRotate creates TransformModifierAttribute with rotation', () {
      final boxAttr = BoxSpecAttribute();
      final wrappedAttr = boxAttr.wrapRotate(1.57); // ~90 degrees

      expect(wrappedAttr.$modifiers, isNotNull);
      expect(wrappedAttr.$modifiers!.length, 1);
      expect(wrappedAttr.$modifiers![0], isA<TransformModifierAttribute>());
    });

    test('wrapCenter creates AlignModifierAttribute with center alignment', () {
      final boxAttr = BoxSpecAttribute();
      final wrappedAttr = boxAttr.wrapCenter();

      expect(wrappedAttr.$modifiers, isNotNull);
      expect(wrappedAttr.$modifiers!.length, 1);
      expect(wrappedAttr.$modifiers![0], isA<AlignModifierAttribute>());
    });

    test('wrapClipRRect accepts BorderRadius directly', () {
      final boxAttr = BoxSpecAttribute();
      final wrappedAttr = boxAttr.wrapClipRRect(
        borderRadius: BorderRadius.circular(12),
      );

      expect(wrappedAttr.$modifiers, isNotNull);
      expect(wrappedAttr.$modifiers!.length, 1);
      expect(wrappedAttr.$modifiers![0], isA<ClipRRectModifierAttribute>());
    });

    test('wrapConstrainedBox accepts BoxConstraints directly', () {
      final boxAttr = BoxSpecAttribute();
      
      // Test with BoxConstraints.tight
      final tight = boxAttr.wrapConstrainedBox(
        const BoxConstraints.tightFor(width: 100, height: 50),
      );
      expect(tight.$modifiers![0], isA<SizedBoxModifierAttribute>());
      
      // Test with BoxConstraints.expand
      final expand = boxAttr.wrapConstrainedBox(
        const BoxConstraints.expand(width: 200, height: 100),
      );
      expect(expand.$modifiers![0], isA<SizedBoxModifierAttribute>());
    });

    test('multiple wrap methods can be applied separately', () {
      final boxAttr = BoxSpecAttribute();

      // Apply each wrap separately since chaining changes the type
      final withOpacity = boxAttr.wrapOpacity(0.8);
      expect(withOpacity.$modifiers, isNotNull);
      expect(withOpacity.$modifiers!.length, 1);
      expect(withOpacity.$modifiers![0], isA<OpacityModifierAttribute>());

      final withPadding = boxAttr.wrapPadding(const EdgeInsets.all(8));
      expect(withPadding.$modifiers, isNotNull);
      expect(withPadding.$modifiers!.length, 1);
      expect(withPadding.$modifiers![0], isA<PaddingModifierAttribute>());

      final withClip = boxAttr.wrapClipOval();
      expect(withClip.$modifiers, isNotNull);
      expect(withClip.$modifiers!.length, 1);
      expect(withClip.$modifiers![0], isA<ClipOvalModifierAttribute>());
    });

    test('wrap methods work on different spec attributes', () {
      final textAttr = TextSpecAttribute();
      final wrappedTextAttr = textAttr.wrapOpacity(0.7);

      expect(wrappedTextAttr.$modifiers, isNotNull);
      expect(wrappedTextAttr.$modifiers!.length, 1);
      expect(wrappedTextAttr.$modifiers![0], isA<OpacityModifierAttribute>());

      final flexAttr = FlexSpecAttribute();
      final wrappedFlexAttr = flexAttr.wrapPadding(const EdgeInsets.all(20));

      expect(wrappedFlexAttr.$modifiers, isNotNull);
      expect(wrappedFlexAttr.$modifiers!.length, 1);
      expect(wrappedFlexAttr.$modifiers![0], isA<PaddingModifierAttribute>());
    });
  });
}
