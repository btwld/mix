import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BorderSideToken Integration Tests', () {
    test('BorderSideToken can be created and called', () {
      const token = BorderSideToken('primary.border');

      // Calling the token should return a BorderSideRef
      final ref = token();

      expect(ref, isA<BorderSideRef>());
      expect(ref, PropMatcher.hasTokens);
      expect(ref, PropMatcher.isToken(token));
    });

    testWidgets('BorderSideToken resolves through MixScope', (tester) async {
      const borderSideToken = BorderSideToken('test.border');
      const testBorderSide = BorderSide(color: Colors.blue, width: 3.0);

      await tester.pumpWidget(
        MixScope(
          tokens: {borderSideToken: testBorderSide},
          child: Builder(
            builder: (context) {
              final resolvedBorderSide = borderSideToken.resolve(context);

              expect(resolvedBorderSide, equals(testBorderSide));
              expect(resolvedBorderSide.color, equals(Colors.blue));
              expect(resolvedBorderSide.width, equals(3.0));

              return Container();
            },
          ),
        ),
      );
    });

    test('BorderSideToken correctly prevents direct property access', () {
      const borderSideToken = BorderSideToken('test.border');
      final borderSideRef = borderSideToken();

      // BorderSideRef should throw error when trying to access properties directly
      expect(
        () => borderSideRef.color,
        throwsA(isA<UnimplementedError>()),
        reason: 'BorderSideRef should prevent direct property access',
      );

      expect(
        () => borderSideRef.width,
        throwsA(isA<UnimplementedError>()),
        reason: 'BorderSideRef should prevent direct property access',
      );
    });

    test('BorderSideToken integrates with getReferenceValue', () {
      const borderSideToken = BorderSideToken('test.border');

      final ref = getReferenceValue(borderSideToken);

      expect(ref, isA<BorderSideRef>());
      expect(ref, PropMatcher.hasTokens);
      expect(ref, PropMatcher.isToken(borderSideToken));
    });
  });
}
