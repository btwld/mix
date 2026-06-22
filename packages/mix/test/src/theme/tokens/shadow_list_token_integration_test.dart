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
        const BoxShadow(
          color: Colors.black,
          offset: Offset(0, 2),
          blurRadius: 4,
        ),
        const BoxShadow(
          color: Colors.grey,
          offset: Offset(0, 1),
          blurRadius: 3,
        ),
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

  group('Shadow token .mix() through styler methods (non-breaking)', () {
    test('BoxShadowToken.mix() also implements List<BoxShadowMix>', () {
      const boxShadowToken = BoxShadowToken('test.box.shadows.mix');
      final mixRef = boxShadowToken.mix();

      // The ref satisfies the raw list parameter type AND is a Mix.
      expect(mixRef, isA<List<BoxShadowMix>>());
      expect(mixRef, isA<BoxShadowListMix>());
      expect(isAnyTokenRef(mixRef), isTrue);
    });

    test('ShadowToken.mix() also implements List<ShadowMix>', () {
      const shadowToken = ShadowToken('test.shadows.mix');
      final mixRef = shadowToken.mix();

      expect(mixRef, isA<List<ShadowMix>>());
      expect(mixRef, isA<ShadowListMix>());
      expect(isAnyTokenRef(mixRef), isTrue);
    });

    test('BoxStyler.boxShadows accepts BoxShadowToken.mix()', () {
      const boxShadowToken = BoxShadowToken('test.box.shadows.boxShadows');

      // Compiles against the unchanged List<BoxShadowMix> signature.
      final styler = BoxStyler().boxShadows(boxShadowToken.mix());

      expect(styler.$decoration, isNotNull);
    });

    test('BoxStyler.shadows accepts BoxShadowToken.mix()', () {
      const boxShadowToken = BoxShadowToken('test.box.shadows.shadows');

      final styler = BoxStyler().shadows(boxShadowToken.mix());

      expect(styler.$decoration, isNotNull);
    });

    test('BoxStyler.boxShadows still accepts a literal list (non-breaking)', () {
      final styler = BoxStyler().boxShadows([
        BoxShadowMix(color: Colors.black, blurRadius: 5),
        BoxShadowMix(color: Colors.grey, blurRadius: 10),
      ]);

      expect(styler.$decoration, isNotNull);
    });

    testWidgets(
      'BoxStyler.boxShadows resolves BoxShadowToken.mix() through MixScope',
      (tester) async {
        const boxShadowToken = BoxShadowToken('box.shadows.token-mix.resolved');
        final testBoxShadows = [
          const BoxShadow(color: Colors.black, blurRadius: 4),
          const BoxShadow(color: Colors.grey, blurRadius: 2),
        ];

        await tester.pumpWidget(
          MixScope(
            tokens: {boxShadowToken: testBoxShadows},
            child: Builder(
              builder: (context) {
                final styler = BoxStyler().boxShadows(boxShadowToken.mix());
                final styleSpec = styler.resolve(context);
                final decoration = styleSpec.spec.decoration;

                expect(decoration, isA<BoxDecoration>());
                expect(
                  (decoration as BoxDecoration).boxShadow,
                  equals(testBoxShadows),
                );

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      },
    );

    test('TextStyler.shadows accepts ShadowToken.mix()', () {
      const shadowToken = ShadowToken('text.shadows.mix');

      final styler = TextStyler().shadows(shadowToken.mix());

      expect(styler.$style, isNotNull);
    });

    test('TextStyler.shadows still accepts a literal list (non-breaking)', () {
      final styler = TextStyler().shadows([
        ShadowMix(color: Colors.black, offset: const Offset(1, 1)),
      ]);

      expect(styler.$style, isNotNull);
    });

    testWidgets('TextStyler.shadows resolves ShadowToken.mix() through MixScope', (
      tester,
    ) async {
      const shadowToken = ShadowToken('text.shadows.token-mix.resolved');
      final testShadows = [
        const Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 4),
      ];

      await tester.pumpWidget(
        MixScope(
          tokens: {shadowToken: testShadows},
          child: Builder(
            builder: (context) {
              final styler = TextStyler().shadows(shadowToken.mix());
              final styleSpec = styler.resolve(context);

              expect(styleSpec.spec.style?.shadows, equals(testShadows));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });
  });
}
