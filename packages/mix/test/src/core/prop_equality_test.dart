import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Mock MixDirective for testing
class MockMixDirective<T> extends MixDirective<T> {
  final String name;
  final T Function(T) transformer;

  const MockMixDirective(this.name, this.transformer);

  @override
  String? get debugLabel => name;

  @override
  T apply(T value) => transformer(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockMixDirective<T> &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'MockMixDirective($name)';
}

void main() {
  group('Prop equality behavior', () {
    group('Basic equality', () {
      test('identical Props are equal', () {
        final prop1 = Prop(Colors.red);
        final prop2 = Prop(Colors.red);

        expect(prop1, equals(prop2));
      });

      test('different Props are not equal', () {
        final prop1 = Prop(Colors.red);
        final prop2 = Prop(Colors.blue);

        expect(prop1, isNot(equals(prop2)));
      });

      test('Props with different types are not equal', () {
        final prop1 = Prop(42);
        final prop2 = Prop("42");

        expect(prop1, isNot(equals(prop2)));
      });
    });

    group('Merge equality behavior', () {
      test('merged Prop with identical values equals original', () {
        final prop1 = Prop(Colors.red);
        final prop2 = Prop(Colors.blue);
        final merged = prop1.merge(prop2);

        // The merged prop should have the same value as prop2 (other wins)
        expect(merged.value, prop2.value);

        // But importantly, the merged prop should be equal to a new prop with the same value
        final expected = Prop(Colors.blue);

        expect(merged, expected);
      });

      test('merged Prop with empty directives equals original', () {
        final prop1 = Prop(Colors.red);
        final prop2 = Prop(Colors.blue);
        final merged = prop1.merge(prop2);

        // All should have empty directives
        expect(prop1.directives, isNull);
        expect(prop2.directives, isNull);
        expect(merged.directives, isNull);

        // The merged prop should equal a new prop with the same value
        final expected = Prop(Colors.blue);
        expect(merged, equals(expected));
      });

      test('merged Prop preserves directive list type consistency', () {
        final prop1 = Prop(Colors.red);
        final prop2 = Prop(Colors.blue);
        final merged = prop1.merge(prop2);

        // Check that directive lists have consistent types
        expect(
          prop1.directives.runtimeType,
          equals(prop2.directives.runtimeType),
        );
        expect(
          merged.directives.runtimeType,
          equals(prop2.directives.runtimeType),
        );
      });
    });

    group('Directive equality behavior', () {
      test('Props with same directives are equal', () {
        final directive1 = MockMixDirective<Color>('brighten', (c) => c);
        final directive2 = MockMixDirective<Color>('brighten', (c) => c);

        final prop1 = Prop.fromDirectives([directive1]);
        final prop2 = Prop.fromDirectives([directive2]);

        expect(prop1, equals(prop2));
      });

      test('Props with different directives are not equal', () {
        final directive1 = MockMixDirective<Color>('brighten', (c) => c);
        final directive2 = MockMixDirective<Color>('darken', (c) => c);

        final prop1 = Prop.fromDirectives([directive1]);
        final prop2 = Prop.fromDirectives([directive2]);

        expect(prop1, isNot(equals(prop2)));
      });

      test('merged Props with directives accumulate correctly', () {
        final directive1 = MockMixDirective<Color>('brighten', (c) => c);
        final directive2 = MockMixDirective<Color>('darken', (c) => c);

        final prop1 = Prop.fromDirectives([directive1]);
        final prop2 = Prop.fromDirectives([directive2]);
        final merged = prop1.merge(prop2);

        expect(merged.directives, hasLength(2));
        expect(merged.directives, contains(directive1));
        expect(merged.directives, contains(directive2));
      });

      test('merged Props with accumulated directives maintain equality', () {
        final directive1 = MockMixDirective<Color>('brighten', (c) => c);
        final directive2 = MockMixDirective<Color>('darken', (c) => c);

        final prop1 = Prop.fromDirectives([directive1]);
        final prop2 = Prop.fromDirectives([directive2]);
        final merged = prop1.merge(prop2);

        // Create expected prop with same directives - use List<MixDirective<Color>> to match merge result
        final expected = Prop.fromDirectives([directive1, directive2]);

        expect(merged, equals(expected));
      });
    });

    group('MixProp equality behavior', () {
      test('identical MixProps are equal', () {
        final shadow1 = BoxShadowMix(color: Colors.red, blurRadius: 5.0);
        final shadow2 = BoxShadowMix(color: Colors.red, blurRadius: 5.0);

        final prop1 = MixProp(shadow1);
        final prop2 = MixProp(shadow2);

        expect(prop1, equals(prop2));
      });

      test('different MixProps are not equal', () {
        final shadow1 = BoxShadowMix(color: Colors.red, blurRadius: 5.0);
        final shadow2 = BoxShadowMix(color: Colors.blue, blurRadius: 5.0);

        final prop1 = MixProp(shadow1);
        final prop2 = MixProp(shadow2);

        expect(prop1, isNot(equals(prop2)));
      });

      test('merged MixProps with identical values equals original', () {
        final shadow1 = BoxShadowMix(color: Colors.red, blurRadius: 5.0);
        final shadow2 = BoxShadowMix(color: Colors.blue, blurRadius: 10.0);

        final prop1 = MixProp(shadow1);
        final prop2 = MixProp(shadow2);
        final merged = prop1.merge(prop2);

        // The merged prop should have the merged shadow
        final expectedShadow = shadow1.merge(shadow2);
        final expected = MixProp(expectedShadow);

        expect(merged, equals(expected));
      });
    });

    group('Edge cases', () {
      test('Props with null values are equal', () {
        final prop1 = Prop<Color?>.fromValue(null);
        final prop2 = Prop<Color?>.fromValue(null);

        expect(prop1, equals(prop2));
      });

      test('empty directive lists are equal regardless of creation method', () {
        final prop1 = Prop(Colors.red);
        final prop2 = Prop.fromDirectives(const []);

        // Both should have empty directive lists
        expect(prop1.directives, isNull);
        expect(prop2.directives, isEmpty);

        // But they're not equal because one has a value and the other doesn't
        expect(prop1, isNot(equals(prop2)));
      });
    });
  });
}
