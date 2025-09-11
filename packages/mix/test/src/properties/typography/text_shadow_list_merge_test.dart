import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextStyleMix shadow list merge behavior', () {
    test('merges text style shadows by replacement', () {
      final textStyle1 = TextStyleMix(
        shadows: [
          ShadowMix(blurRadius: 5.0, color: Colors.black),
          ShadowMix(blurRadius: 3.0, color: Colors.grey),
        ],
      );

      final textStyle2 = TextStyleMix(
        shadows: [
          ShadowMix(blurRadius: 8.0, color: Colors.red),
        ],
      );

      final merged = textStyle1.merge(textStyle2);

      final resolvedShadows = merged.resolve(MockBuildContext()).shadows;
      expect(resolvedShadows, isNotNull);
      expect(resolvedShadows!.length, 1);
      expect(resolvedShadows[0].blurRadius, 8.0);
      expect(resolvedShadows[0].color, Colors.red);
    });

    test('preserves shadows when merging with null shadows', () {
      final textStyle1 = TextStyleMix(
        shadows: [
          ShadowMix(blurRadius: 5.0, color: Colors.black),
        ],
      );

      final textStyle2 = TextStyleMix(color: Colors.blue);

      final merged = textStyle1.merge(textStyle2);

      final resolvedShadows = merged.resolve(MockBuildContext()).shadows;
      expect(resolvedShadows, isNotNull);
      expect(resolvedShadows!.length, 1);
      expect(resolvedShadows[0].blurRadius, 5.0);
      expect(resolvedShadows[0].color, Colors.black);
    });

    test('adds shadows when original has none', () {
      final textStyle1 = TextStyleMix(color: Colors.blue);

      final textStyle2 = TextStyleMix(
        shadows: [
          ShadowMix(blurRadius: 8.0, color: Colors.red),
        ],
      );

      final merged = textStyle1.merge(textStyle2);

      final resolvedShadows = merged.resolve(MockBuildContext()).shadows;
      expect(resolvedShadows, isNotNull);
      expect(resolvedShadows!.length, 1);
      expect(resolvedShadows[0].blurRadius, 8.0);
      expect(resolvedShadows[0].color, Colors.red);
    });

    test('handles complex shadow merge scenarios', () {
      final textStyle1 = TextStyleMix(
        fontSize: 14.0,
        shadows: [
          ShadowMix(blurRadius: 2.0, color: Colors.black, offset: const Offset(1, 1)),
          ShadowMix(blurRadius: 4.0, color: Colors.grey, offset: const Offset(2, 2)),
        ],
      );

      final textStyle2 = TextStyleMix(
        fontSize: 16.0,
        shadows: [
          ShadowMix(blurRadius: 6.0, color: Colors.blue, offset: const Offset(3, 3)),
          ShadowMix(blurRadius: 8.0, color: Colors.green, offset: const Offset(4, 4)),
          ShadowMix(blurRadius: 10.0, color: Colors.red, offset: const Offset(5, 5)),
        ],
      );

      final merged = textStyle1.merge(textStyle2);

      final resolved = merged.resolve(MockBuildContext());
      expect(resolved.fontSize, 16.0); // fontSize should be overridden

      final shadows = resolved.shadows;
      expect(shadows, isNotNull);
      expect(shadows!.length, 3); // Should have 3 shadows from textStyle2
      
      expect(shadows[0].blurRadius, 6.0);
      expect(shadows[0].color, Colors.blue);
      expect(shadows[0].offset, const Offset(3, 3));
      
      expect(shadows[1].blurRadius, 8.0);
      expect(shadows[1].color, Colors.green);
      expect(shadows[1].offset, const Offset(4, 4));
      
      expect(shadows[2].blurRadius, 10.0);
      expect(shadows[2].color, Colors.red);
      expect(shadows[2].offset, const Offset(5, 5));
    });

    test('shadow list property supports resolvesTo matcher', () {
      final textStyle = TextStyleMix(
        shadows: [
          ShadowMix(blurRadius: 5.0, color: Colors.black),
          ShadowMix(blurRadius: 3.0, color: Colors.grey),
        ],
      );

      expect(textStyle.$shadows, resolvesTo(hasLength(2)));
    });

    test('can check individual shadow properties', () {
      final shadow1 = ShadowMix(blurRadius: 5.0, color: Colors.black, offset: const Offset(1, 1));
      final shadow2 = ShadowMix(blurRadius: 3.0, color: Colors.grey, offset: const Offset(2, 2));

      final textStyle = TextStyleMix(shadows: [shadow1, shadow2]);

      final resolved = textStyle.resolve(MockBuildContext());
      final shadows = resolved.shadows!;

      expect(shadows[0], const Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(1, 1)));
      expect(shadows[1], const Shadow(blurRadius: 3.0, color: Colors.grey, offset: Offset(2, 2)));
    });
  });
}