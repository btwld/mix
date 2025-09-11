import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FontWeightToken Integration Tests', () {
    test('FontWeightToken can be created and called', () {
      const token = FontWeightToken('text.weight.bold');
      
      // Calling the token should return a FontWeightRef
      final ref = token();
      
      expect(ref, isA<FontWeightRef>());
      expect(ref, PropMatcher.hasTokens);
      expect(ref, PropMatcher.isToken(token));
    });

    testWidgets('FontWeightToken resolves through MixScope', (tester) async {
      const fontWeightToken = FontWeightToken('test.fontWeight');
      const testFontWeight = FontWeight.w700;

      await tester.pumpWidget(
        MixScope(
          tokens: {fontWeightToken: testFontWeight},
          child: Builder(
            builder: (context) {
              final resolvedFontWeight = fontWeightToken.resolve(context);
              
              expect(resolvedFontWeight, equals(testFontWeight));
              expect(resolvedFontWeight, equals(FontWeight.w700));
              expect(resolvedFontWeight.value, equals(700));
              
              return Container();
            },
          ),
        ),
      );
    });

    test('FontWeightToken correctly prevents direct property access', () {
      const fontWeightToken = FontWeightToken('test.fontWeight');
      final fontWeightRef = fontWeightToken();
      
      // FontWeightRef should throw error when trying to access properties directly
      expect(
        () => fontWeightRef.value,
        throwsA(isA<UnimplementedError>()),
        reason: 'FontWeightRef should prevent direct property access',
      );
      
      expect(
        () => fontWeightRef.index,
        throwsA(isA<UnimplementedError>()),
        reason: 'FontWeightRef should prevent direct property access',
      );
    });

    test('FontWeightToken integrates with getReferenceValue', () {
      const fontWeightToken = FontWeightToken('test.fontWeight');
      
      final ref = getReferenceValue(fontWeightToken);
      
      expect(ref, isA<FontWeight>());
      expect(ref, isA<FontWeightRef>());
      expect(ref, PropMatcher.hasTokens);
      expect(ref, PropMatcher.isToken(fontWeightToken));
    });

    test('FontWeightRef implements FontWeight interface', () {
      const fontWeightToken = FontWeightToken('test.weight');
      final fontWeightRef = fontWeightToken();
      
      // Should be detectable as a token reference
      expect(isAnyTokenRef(fontWeightRef), isTrue);
      
      // Should implement FontWeight
      expect(fontWeightRef, isA<FontWeight>());
    });

    test('FontWeightToken works with common font weights', () {
      const normalToken = FontWeightToken('weight.normal');
      const boldToken = FontWeightToken('weight.bold');
      
      final normalRef = normalToken();
      final boldRef = boldToken();
      
      expect(normalRef, isA<FontWeightRef>());
      expect(boldRef, isA<FontWeightRef>());
      expect(isAnyTokenRef(normalRef), isTrue);
      expect(isAnyTokenRef(boldRef), isTrue);
    });
  });
}