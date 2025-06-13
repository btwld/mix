import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('MaterialColorsMixin', () {
    test('should provide access to material colors through utilities', () {
      // Test that we can access material colors through $box.color
      final redBox = $box.color.red();
      final blueBox = $box.color.blue();
      final greenBox = $box.color.green();
      
      expect(redBox, isA<BoxSpecAttribute>());
      expect(blueBox, isA<BoxSpecAttribute>());
      expect(greenBox, isA<BoxSpecAttribute>());
    });

    test('should provide access to material color shades', () {
      // Test that we can access shades
      final blueShade50 = $box.color.blue.shade50();
      final blueShade500 = $box.color.blue.shade500();
      final blueShade900 = $box.color.blue.shade900();
      
      expect(blueShade50, isA<BoxSpecAttribute>());
      expect(blueShade500, isA<BoxSpecAttribute>());
      expect(blueShade900, isA<BoxSpecAttribute>());
    });

    test('should provide access to material accent colors', () {
      // Test accent colors
      final redAccent = $box.color.redAccent();
      final blueAccent = $box.color.blueAccent();
      final greenAccent = $box.color.greenAccent();
      
      expect(redAccent, isA<BoxSpecAttribute>());
      expect(blueAccent, isA<BoxSpecAttribute>());
      expect(greenAccent, isA<BoxSpecAttribute>());
    });

    test('should provide access to accent color shades', () {
      // Test accent shades
      final blueAccentShade100 = $box.color.blueAccent.shade100();
      final blueAccentShade400 = $box.color.blueAccent.shade400();
      final blueAccentShade700 = $box.color.blueAccent.shade700();
      
      expect(blueAccentShade100, isA<BoxSpecAttribute>());
      expect(blueAccentShade400, isA<BoxSpecAttribute>());
      expect(blueAccentShade700, isA<BoxSpecAttribute>());
    });

    test('should work with text color utility', () {
      // Test with text utility
      final redText = $text.style.color.red();
      final blueText = $text.style.color.blue();
      
      expect(redText, isA<TextSpecAttribute>());
      expect(blueText, isA<TextSpecAttribute>());
    });

    test('should work with icon color utility', () {
      // Test with icon utility
      final redIcon = $icon.color.red();
      final blueIcon = $icon.color.blue();
      
      expect(redIcon, isA<IconSpecAttribute>());
      expect(blueIcon, isA<IconSpecAttribute>());
    });
  });
}