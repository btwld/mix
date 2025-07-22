import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'testing_utils.dart';

void main() {
  group('Custom Matchers', () {
    group('resolvesTo', () {
      test('works with simple Prop values', () {
        final colorProp = Prop(Colors.red);
        final doubleProp = Prop(42.0);
        final stringProp = Prop('test');

        expect(colorProp, resolvesTo(Colors.red));
        expect(doubleProp, resolvesTo(42.0));
        expect(stringProp, resolvesTo('test'));
      });

      test('works with Mix values', () {
        final borderSideMix = BorderSideMix.only(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
        );

        expect(borderSideMix, resolvesTo(const BorderSide(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
        )));
      });

      test('works with BorderRadiusMix', () {
        final borderRadius = BorderRadiusMix.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(20),
        );

        expect(borderRadius, resolvesTo(
          const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(20),
          ),
        ));
      });

      test('provides clear error messages on mismatch', () {
        final colorProp = Prop(Colors.red);

        expect(
          () => expect(colorProp, resolvesTo(Colors.blue)),
          throwsA(
            isA<TestFailure>().having(
              (e) => e.toString(),
              'message',
              contains('resolved to'),
            ),
          ),
        );
      });

      test('handles null values correctly', () {
        final nullableProp = Prop<Color?>(null);
        expect(nullableProp, resolvesTo(null));
      });
    });

    group('isProp', () {
      test('matches Prop with value', () {
        final prop = Prop(Colors.red);
        expect(prop, isProp(Colors.red));
      });

      test('fails when value doesn\'t match', () {
        final prop = Prop(Colors.red);
        expect(
          () => expect(prop, isProp(Colors.blue)),
          throwsA(isA<TestFailure>()),
        );
      });

      test('fails when not a Prop', () {
        expect(
          () => expect('not a prop', isProp('anything')),
          throwsA(isA<TestFailure>()),
        );
      });
    });

    group('isPropWithToken', () {
      test('matches Prop with token', () {
        const token = MixToken<Color>('color.primary');
        final prop = Prop.token(token);
        expect(prop, isPropWithToken<Color>());
      });

      test('fails when Prop has value instead of token', () {
        final prop = Prop(Colors.red);
        expect(
          () => expect(prop, isPropWithToken<Color>()),
          throwsA(isA<TestFailure>()),
        );
      });
    });

    group('hasValue', () {
      test('matches Prop with specific value', () {
        final prop = Prop(42.0);
        expect(prop, hasValue(42.0));
      });

      test('fails when value doesn\'t match', () {
        final prop = Prop(42.0);
        expect(
          () => expect(prop, hasValue(43.0)),
          throwsA(isA<TestFailure>()),
        );
      });
    });

    group('hasToken', () {
      test('matches Prop with token', () {
        const token = MixToken<double>('spacing.small');
        final prop = Prop.token(token);
        expect(prop, hasToken<double>());
      });

      test('fails when Prop has value instead of token', () {
        final prop = Prop(8.0);
        expect(
          () => expect(prop, hasToken<double>()),
          throwsA(isA<TestFailure>()),
        );
      });
    });

    group('Real-world usage examples', () {
      test('BorderSideMix testing', () {
        final borderSide = BorderSideMix.only(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
        );

        // Test individual properties
        expect(borderSide.color, resolvesTo(Colors.red));
        expect(borderSide.width, resolvesTo(2.0));
        expect(borderSide.style, resolvesTo(BorderStyle.solid));
      });

      test('BoxShadowMix testing', () {
        final boxShadow = BoxShadowMix.only(
          color: Colors.black,
          blurRadius: 10.0,
          offset: const Offset(2, 2),
          spreadRadius: 5.0,
        );

        // Test individual properties
        expect(boxShadow.color, resolvesTo(Colors.black));
        expect(boxShadow.blurRadius, resolvesTo(10.0));
        expect(boxShadow.offset, resolvesTo(const Offset(2, 2)));
        expect(boxShadow.spreadRadius, resolvesTo(5.0));
      });

      test('Complex Mix resolution', () {
        final edgeInsets = EdgeInsetsMix.only(
          top: 8.0,
          bottom: 16.0,
          left: 4.0,
          right: 4.0,
        );

        expect(edgeInsets, resolvesTo(
          const EdgeInsets.only(
            top: 8.0,
            bottom: 16.0,
            left: 4.0,
            right: 4.0,
          ),
        ));
      });

      test('Token resolution with context', () {
        const colorToken = MixToken<Color>('brand.primary');
        final colorProp = Prop.token(colorToken);
        
        // Create context with token values
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(
            tokens: {
              colorToken: Colors.purple,
            },
          ),
        );

        expect(colorProp, resolvesTo(Colors.purple, context: context));
      });
    });
  });
}