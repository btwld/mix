import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('PropSource Types', () {
    group('ValuePropSource', () {
      test('stores and returns value', () {
        const source = ValuePropSource<int>(42);
        expect(source.value, equals(42));
      });

      test('equality and hashCode', () {
        const source1 = ValuePropSource<int>(42);
        const source2 = ValuePropSource<int>(42);
        const source3 = ValuePropSource<int>(24);

        expect(source1, equals(source2));
        expect(source1.hashCode, equals(source2.hashCode));
        expect(source1, isNot(equals(source3)));
      });
    });

    group('TokenPropSource', () {
      test('stores token reference', () {
        final token = MixToken<Color>('primary');
        final source = TokenPropSource<Color>(token);

        expect(source.token, equals(token));
      });

      test('equality and hashCode', () {
        final token1 = MixToken<Color>('primary');
        final token2 = MixToken<Color>('secondary');

        final source1 = TokenPropSource<Color>(token1);
        final source2 = TokenPropSource<Color>(token1);
        final source3 = TokenPropSource<Color>(token2);

        expect(source1, equals(source2));
        expect(source1.hashCode, equals(source2.hashCode));
        expect(source1, isNot(equals(source3)));
      });
    });
  });

  group('Prop', () {
    test('value constructor stores direct value', () {
      final prop = Prop<int>(42);

      expect(prop.hasValue, isTrue);
      expect(prop.hasToken, isFalse);
      expect(prop.value, equals(42));
    });

    test('token constructor stores token reference', () {
      final token = MixToken<Color>('primary');
      final prop = Prop.token(token);

      expect(prop.hasValue, isFalse);
      expect(prop.hasToken, isTrue);
      expect(prop.token, equals(token));
    });

    test('merge replaces source with other source', () {
      final prop1 = Prop<int>(10);
      final prop2 = Prop<int>(20);

      final merged = prop1.merge(prop2);

      expect(merged.hasValue, isTrue);
      expect(merged.value, equals(20));
    });

    test('resolves direct values', () {
      final prop = Prop<int>(42);
      final context = MockBuildContext();

      final resolved = prop.resolve(context);

      expect(resolved, equals(42));
    });
  });

  group('MixProp', () {
    test('value constructor stores Mix value', () {
      final mixValue = MockMix<int>(42);
      final prop = MixProp<int>(mixValue);

      expect(prop.value, equals(mixValue));
    });

    test('merge combines Mix values', () {
      final mix1 = MockMix<int>(10, merger: (a, b) => a + b);
      final mix2 = MockMix<int>(20, merger: (a, b) => a + b);

      final prop1 = MixProp<int>(mix1);
      final prop2 = MixProp<int>(mix2);

      final merged = prop1.merge(prop2);

      expect(merged.value?.resolve(MockBuildContext()), equals(30));
    });

    test('resolves Mix values', () {
      final mixValue = MockMix<int>(42);
      final prop = MixProp<int>(mixValue);
      final context = MockBuildContext();

      final resolved = prop.resolve(context);

      expect(resolved, equals(42));
    });
  });
}