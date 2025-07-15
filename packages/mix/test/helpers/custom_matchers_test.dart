import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'custom_matchers.dart';
import 'testing_utils.dart';

void main() {
  group('Custom Matchers', () {
    group('resolvesTo', () {
      test('works with simple Mix values', () {
        final colorMix = Prop.value(Colors.red);
        final doubleMix = Prop.value(42.0);
        final stringMix = Prop.value('test');

        // Clean, readable assertions
        expect(colorMix, resolvesTo(Colors.red));
        expect(doubleMix, resolvesTo(42.0));
        expect(stringMix, resolvesTo('test'));
      });

      test('works with Prop values', () {
        final colorProp = Prop.value(Colors.blue);
        final doubleProp = Prop.value(3.14);
        final stringProp = Prop.value('hello');

        expect(colorProp, resolvesTo(Colors.blue));
        expect(doubleProp, resolvesTo(3.14));
        expect(stringProp, resolvesTo('hello'));
      });

      test('works with SpecAttribute implementations', () {
        final mockAttr = MockDoubleScalarAttribute(42.0);
        expect(mockAttr, resolvesTo(42.0));
      });

      test('provides clear error messages on mismatch', () {
        final colorMix = Prop.value(Colors.red);

        expect(
          () => expect(colorMix, resolvesTo(Colors.blue)),
          throwsA(
            isA<TestFailure>().having(
              (e) => e.toString(),
              'message',
              allOf(
                contains('Expected: resolves to MaterialColor:'),
                contains('Actual: Prop<MaterialColor>:'),
                contains('Which: resolved to MaterialColor:'),
              ),
            ),
          ),
        );
      });

      test('handles null values correctly', () {
        final nullableProp = Prop<Color?>.value(null);
        expect(nullableProp, resolvesTo(null));
      });
    });

    group('equivalentTo', () {
      test('works with equivalent Mix values', () {
        final mix1 = Prop.value(Colors.red);
        final mix2 = Prop.value(Colors.red);

        expect(mix1, mix2);
      });

      test('fails with different Mix values', () {
        final mix1 = Prop.value(Colors.red);
        final mix2 = Prop.value(Colors.blue);

        expect(() => expect(mix1, equals(mix2)), throwsA(isA<TestFailure>()));
      });

      test('works with Prop values', () {
        final prop1 = Prop.value('test');
        final prop2 = Prop.value('test');

        expect(prop1, prop2);
      });

      test('works with custom attributes', () {
        final attr1 = MockStringScalarAttribute('value');
        final attr2 = MockStringScalarAttribute('value');

        expect(attr1, attr2);
      });
    });

    group('Real-world usage examples', () {
      test('BorderSideDto testing becomes much cleaner', () {
        final borderSide = BorderSideDto(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
        );

        // Clean, readable assertions instead of manual .resolve() calls
        expect(borderSide.color, resolvesTo(Colors.red));
        expect(borderSide.width, resolvesTo(2.0));
        expect(borderSide.style, resolvesTo(BorderStyle.solid));
      });

      test('BoxShadowDto testing becomes much cleaner', () {
        final boxShadow = BoxShadowDto(
          color: Colors.black,
          blurRadius: 10.0,
          offset: const Offset(2, 2),
          spreadRadius: 5.0,
        );

        // Clean assertions
        expect(boxShadow.color, resolvesTo(Colors.black));
        expect(boxShadow.blurRadius, resolvesTo(10.0));
        expect(boxShadow.offset, resolvesTo(const Offset(2, 2)));
        expect(boxShadow.spreadRadius, resolvesTo(5.0));
      });

      test('DTO resolution testing', () {
        final borderRadius = BorderRadiusDto(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(20),
        );

        // Test individual properties
        expect(borderRadius.topLeft, resolvesTo(const Radius.circular(10)));
        expect(borderRadius.topRight, resolvesTo(const Radius.circular(20)));
        expect(borderRadius.bottomLeft, isNull);
        expect(borderRadius.bottomRight, isNull);

        // Test whole DTO resolution
        expect(
          borderRadius,
          resolvesTo(
            const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(20),
            ),
          ),
        );
      });

      test('Merge testing becomes more readable', () {
        final mix1 = Prop.value('first');
        final mix2 = Prop.value('second');

        final merged = mix1.merge(mix2);

        // Clean assertion for merged result
        expect(merged, resolvesTo('second'));
        // Both should resolve to the same value
        expect(mix2, resolvesTo('second'));
      });
    });

    group('Error handling', () {
      test('provides helpful error messages for type mismatches', () {
        expect(
          () => expect('not a mix', resolvesTo('anything')),
          throwsA(
            isA<TestFailure>().having(
              (e) => e.toString(),
              'message',
              contains('Expected ResolvableMixin implementation, got String'),
            ),
          ),
        );
      });

      test('handles resolution errors gracefully', () {
        // This would be a Mix that throws during resolution
        final problematicMix = _ProblematicMix<String>();

        expect(
          () => expect(problematicMix, resolvesTo('anything')),
          throwsA(
            isA<TestFailure>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to resolve'),
            ),
          ),
        );
      });
    });
  });
}

// Helper class for testing error handling
class _ProblematicMix<T> with ResolvableMixin<T> {
  @override
  T resolve(MixContext mix) {
    throw Exception('Intentional test error');
  }

  ResolvableMixin<T> merge(covariant ResolvableMixin<T>? other) {
    return this;
  }

  List<Object?> get props => [];
}
