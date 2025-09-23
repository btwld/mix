import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('DurationToken Integration Tests', () {
    test('DurationToken can be created and called', () {
      const token = DurationToken('animation.duration.fast');

      // Calling the token should return a DurationRef
      final ref = token();

      expect(ref, isA<DurationRef>());
      expect(ref, PropMatcher.hasTokens);
      expect(ref, PropMatcher.isToken(token));
    });

    testWidgets('DurationToken resolves through MixScope', (tester) async {
      const durationToken = DurationToken('test.duration');
      const testDuration = Duration(milliseconds: 300);

      await tester.pumpWidget(
        MixScope(
          tokens: {durationToken: testDuration},
          child: Builder(
            builder: (context) {
              final resolvedDuration = durationToken.resolve(context);

              expect(resolvedDuration, equals(testDuration));
              expect(resolvedDuration, equals(Duration(milliseconds: 300)));
              expect(resolvedDuration.inMilliseconds, equals(300));

              return Container();
            },
          ),
        ),
      );
    });

    test('DurationToken correctly prevents direct property access', () {
      const durationToken = DurationToken('test.duration');
      final durationRef = durationToken();

      // DurationRef should throw error when trying to access properties directly
      expect(
        () => durationRef.inMilliseconds,
        throwsA(isA<UnimplementedError>()),
        reason: 'DurationRef should prevent direct property access',
      );

      expect(
        () => durationRef.inSeconds,
        throwsA(isA<UnimplementedError>()),
        reason: 'DurationRef should prevent direct property access',
      );
    });

    test('DurationToken integrates with getReferenceValue', () {
      const durationToken = DurationToken('test.duration');

      final ref = getReferenceValue(durationToken);

      expect(ref, isA<Duration>());
      expect(ref, isA<DurationRef>());
      expect(ref, PropMatcher.hasTokens);
      expect(ref, PropMatcher.isToken(durationToken));
    });

    test('DurationRef implements Duration interface', () {
      const durationToken = DurationToken('test.duration');
      final durationRef = durationToken();

      // Should be detectable as a token reference
      expect(isAnyTokenRef(durationRef), isTrue);

      // Should implement Duration
      expect(durationRef, isA<Duration>());
    });

    test('DurationToken works with common duration values', () {
      const shortToken = DurationToken('duration.short');
      const longToken = DurationToken('duration.long');

      final shortRef = shortToken();
      final longRef = longToken();

      expect(shortRef, isA<DurationRef>());
      expect(longRef, isA<DurationRef>());
      expect(isAnyTokenRef(shortRef), isTrue);
      expect(isAnyTokenRef(longRef), isTrue);
    });
  });
}
