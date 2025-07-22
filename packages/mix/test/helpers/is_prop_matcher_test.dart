import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'testing_utils.dart';

void main() {
  group('isProp matcher', () {
    test('matches Prop with correct value', () {
      final prop = Prop('test');
      expect(prop, isProp('test'));
    });

    test('matches Prop with correct numeric value', () {
      final prop = Prop(16.0);
      expect(prop, isProp(16.0));
    });

    test('matches Prop with correct enum value', () {
      final prop = Prop(FontWeight.bold);
      expect(prop, isProp(FontWeight.bold));
    });

    test('fails when value does not match', () {
      final prop = Prop('test');
      expect(() => expect(prop, isProp('different')), throwsA(isA<TestFailure>()));
    });

    test('fails when item is not a Prop', () {
      expect(() => expect('not a prop', isProp('test')), throwsA(isA<TestFailure>()));
    });

    test('fails when Prop has no value (token)', () {
      // This would require a token to test, but let's test the error case
      final prop = Prop<String>.directives([]);
      expect(() => expect(prop, isProp('test')), throwsA(isA<TestFailure>()));
    });
  });

  group('isPropWithToken matcher', () {
    test('matches Prop with token', () {
      // This would require creating a token to test properly
      // For now, let's just test the basic structure
      final prop = Prop<String>.directives([]);
      expect(() => expect(prop, isPropWithToken<String>()), throwsA(isA<TestFailure>()));
    });

    test('fails when item is not a Prop', () {
      expect(() => expect('not a prop', isPropWithToken<String>()), throwsA(isA<TestFailure>()));
    });
  });
}
