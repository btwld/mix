import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Prop', () {
    test('value constructor stores direct value', () {
      final prop = Prop.value(42);

      expect(prop.hasValue, isTrue);
      expect(prop.hasToken, isFalse);
      expect(prop.$value, equals(42));
    });

    test('token constructor stores token reference', () {
      final token = MixToken<Color>('primary');
      final prop = Prop.token(token);

      expect(prop.hasValue, isFalse);
      expect(prop.hasToken, isTrue);
      expect(prop.$token, equals(token));
    });

    test('merge replaces source with other source', () {
      final prop1 = Prop.value(10);
      final prop2 = Prop.value(20);

      final merged = prop1.mergeProp(prop2);

      expect(merged.hasValue, isTrue);
      expect(merged.$value, equals(20));
    });

    test('resolves direct values', () {
      final prop = Prop.value(42);
      final context = MockBuildContext();

      final resolved = prop.resolveProp(context);

      expect(resolved, equals(42));
    });

    test('token overrides direct value on merge (replacement)', () {
      final token = MixToken<int>('n');
      final p1 = Prop.value(1);
      final p2 = Prop.token(token);

      final merged = p1.mergeProp(p2);

      expect(merged.hasToken, isTrue);
      expect(merged.$token, token);
      expect(merged.hasValue, isFalse);
    });

    test('merges directives and animation', () {
      // Intentionally pass an empty directives list to 'a' and verify it is preserved
      final a = Prop.value(1).directives(<Directive<int>>[]);
      final anim = AnimationConfig.linear(const Duration(milliseconds: 100));
      final b = Prop.value(2).animation(anim);

      final merged = a.mergeProp(b);

      expect(merged.$animation, anim);
      expect(merged.$directives, a.$directives); // preserved from a
    });

    test('throws when resolving without value or token', () {
      final p = const Prop<int>.directives([]);
      expect(
        () => p.resolveProp(MockBuildContext()),
        throwsA(isA<FlutterError>()),
      );
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

      final merged = prop1.mergeProp(prop2);

      expect(merged.value?.resolve(MockBuildContext()), equals(30));
    });

    test('resolves Mix values', () {
      final mixValue = MockMix<int>(42);
      final prop = MixProp<int>(mixValue);
      final context = MockBuildContext();

      final resolved = prop.resolveProp(context);

      expect(resolved, equals(42));
    });
  });
}
