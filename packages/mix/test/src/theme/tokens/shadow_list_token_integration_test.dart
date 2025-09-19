import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';


void main() {
  group('ShadowToken Integration Tests', () {
    test('ShadowToken can be created and called', () {
      const token = ShadowToken('shadows.elevated');
      
      // Calling the token should return a ShadowListRef
      final ref = token();
      
      expect(ref, isA<List<Shadow>>());
      expect(ref, isA<ShadowListRef>());
      // ShadowListRef should be detectable as a token reference
      expect(isAnyTokenRef(ref), isTrue);
    });

    testWidgets('ShadowToken resolves through MixScope', (tester) async {
      const shadowToken = ShadowToken('shadows.test');
      final testShadows = [
        const Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 4),
        const Shadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 2),
      ];

      await tester.pumpWidget(
        MixScope(
          tokens: {shadowToken: testShadows},
          child: Builder(
            builder: (context) {
              final resolvedShadows = shadowToken.resolve(context);
              
              expect(resolvedShadows, equals(testShadows));
              expect(resolvedShadows.length, equals(2));
              expect(resolvedShadows[0].color, equals(Colors.black));
              expect(resolvedShadows[1].color, equals(Colors.grey));
              
              return Container();
            },
          ),
        ),
      );
    });

    test('ShadowToken integrates with getReferenceValue', () {
      const shadowToken = ShadowToken('test.shadows');

      final ref = getReferenceValue(shadowToken);
      
      expect(ref, isA<List<Shadow>>());
      expect(ref, isA<ShadowListRef>());
      expect(isAnyTokenRef(ref), isTrue);
    });

    test('ShadowListRef implements List<Shadow> interface', () {
      const shadowToken = ShadowToken('test.shadows');
      final shadowRef = shadowToken();
      
      // Should work as a List<Shadow>
      expect(shadowRef, isA<List<Shadow>>());
      expect(shadowRef.runtimeType, equals(ShadowListRef));
    });
  });

  group('BoxShadowToken Integration Tests', () {
    test('BoxShadowToken can be created and called', () {
      const token = BoxShadowToken('box.shadows.card');
      
      // Calling the token should return a BoxShadowListRef
      final ref = token();
      
      expect(ref, isA<List<BoxShadow>>());
      expect(ref, isA<BoxShadowListRef>());
      // BoxShadowListRef should be detectable as a token reference
      expect(isAnyTokenRef(ref), isTrue);
    });

    testWidgets('BoxShadowToken resolves through MixScope', (tester) async {
      const boxShadowToken = BoxShadowToken('box.shadows.test');
      final testBoxShadows = [
        const BoxShadow(color: Colors.black, offset: Offset(0, 2), blurRadius: 4),
        const BoxShadow(color: Colors.grey, offset: Offset(0, 1), blurRadius: 3),
      ];

      await tester.pumpWidget(
        MixScope(
          tokens: {boxShadowToken: testBoxShadows},
          child: Builder(
            builder: (context) {
              final resolvedBoxShadows = boxShadowToken.resolve(context);
              
              expect(resolvedBoxShadows, equals(testBoxShadows));
              expect(resolvedBoxShadows.length, equals(2));
              expect(resolvedBoxShadows[0].color, equals(Colors.black));
              expect(resolvedBoxShadows[1].color, equals(Colors.grey));
              
              return Container();
            },
          ),
        ),
      );
    });

    test('BoxShadowToken integrates with getReferenceValue', () {
      const boxShadowToken = BoxShadowToken('test.box.shadows');

      final ref = getReferenceValue(boxShadowToken);
      
      expect(ref, isA<List<BoxShadow>>());
      expect(ref, isA<BoxShadowListRef>());
      expect(isAnyTokenRef(ref), isTrue);
    });

    test('BoxShadowListRef implements List<BoxShadow> interface', () {
      const boxShadowToken = BoxShadowToken('test.box.shadows');
      final boxShadowRef = boxShadowToken();
      
      // Should work as a List<BoxShadow>
      expect(boxShadowRef, isA<List<BoxShadow>>());
      expect(boxShadowRef.runtimeType, equals(BoxShadowListRef));
    });
  });
}