import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ShadowListToken Integration Tests', () {
    test('ShadowListToken can be created and called', () {
      const token = ShadowListToken('shadows.elevated');
      
      // Calling the token should return a ShadowListRef
      final ref = token();
      
      expect(ref, isA<List<Shadow>>());
      expect(ref, isA<ShadowListRef>());
      // ShadowListRef should be detectable as a token reference
      expect(isAnyTokenRef(ref), isTrue);
    });

    testWidgets('ShadowListToken resolves through MixScope', (tester) async {
      const shadowListToken = ShadowListToken('shadows.test');
      final testShadows = [
        const Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 4),
        const Shadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 2),
      ];

      await tester.pumpWidget(
        MixScope(
          tokens: {shadowListToken: testShadows},
          child: Builder(
            builder: (context) {
              final resolvedShadows = shadowListToken.resolve(context);
              
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

    test('ShadowListToken integrates with getReferenceValue', () {
      const shadowListToken = ShadowListToken('test.shadows');
      
      final ref = getReferenceValue(shadowListToken);
      
      expect(ref, isA<List<Shadow>>());
      expect(ref, isA<ShadowListRef>());
      expect(isAnyTokenRef(ref), isTrue);
    });

    test('ShadowListRef implements List<Shadow> interface', () {
      const shadowListToken = ShadowListToken('test.shadows');
      final shadowListRef = shadowListToken();
      
      // Should work as a List<Shadow>
      expect(shadowListRef, isA<List<Shadow>>());
      expect(shadowListRef.runtimeType, equals(ShadowListRef));
    });
  });

  group('BoxShadowListToken Integration Tests', () {
    test('BoxShadowListToken can be created and called', () {
      const token = BoxShadowListToken('box.shadows.card');
      
      // Calling the token should return a BoxShadowListRef
      final ref = token();
      
      expect(ref, isA<List<BoxShadow>>());
      expect(ref, isA<BoxShadowListRef>());
      // BoxShadowListRef should be detectable as a token reference
      expect(isAnyTokenRef(ref), isTrue);
    });

    testWidgets('BoxShadowListToken resolves through MixScope', (tester) async {
      const boxShadowListToken = BoxShadowListToken('box.shadows.test');
      final testBoxShadows = [
        const BoxShadow(color: Colors.black, offset: Offset(0, 2), blurRadius: 4),
        const BoxShadow(color: Colors.grey, offset: Offset(0, 1), blurRadius: 3),
      ];

      await tester.pumpWidget(
        MixScope(
          tokens: {boxShadowListToken: testBoxShadows},
          child: Builder(
            builder: (context) {
              final resolvedBoxShadows = boxShadowListToken.resolve(context);
              
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

    test('BoxShadowListToken integrates with getReferenceValue', () {
      const boxShadowListToken = BoxShadowListToken('test.box.shadows');
      
      final ref = getReferenceValue(boxShadowListToken);
      
      expect(ref, isA<List<BoxShadow>>());
      expect(ref, isA<BoxShadowListRef>());
      expect(isAnyTokenRef(ref), isTrue);
    });

    test('BoxShadowListRef implements List<BoxShadow> interface', () {
      const boxShadowListToken = BoxShadowListToken('test.box.shadows');
      final boxShadowListRef = boxShadowListToken();
      
      // Should work as a List<BoxShadow>
      expect(boxShadowListRef, isA<List<BoxShadow>>());
      expect(boxShadowListRef.runtimeType, equals(BoxShadowListRef));
    });
  });
}