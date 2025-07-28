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

      test('supports null values', () {
        const source = ValuePropSource<int?>(null);
        expect(source.value, isNull);
      });

      test('toString returns correct format', () {
        const source = ValuePropSource<String>('test');
        expect(source.toString(), equals('ValuePropSource(test)'));
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

      test('toString returns correct format', () {
        final token = MixToken<Color>('primary');
        final source = TokenPropSource<Color>(token);

        expect(source.toString(), equals('TokenPropSource($token)'));
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

    group('MixPropValueSource', () {
      test('stores Mix value', () {
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final source = MixPropValueSource<int>(mixValue);

        expect(source.value, equals(mixValue));
      });

      test('toString returns correct format', () {
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final source = MixPropValueSource<int>(mixValue);

        expect(source.toString(), equals('MixPropValueSource($mixValue)'));
      });

      test('equality and hashCode', () {
        const source1 = MixPropValueSource<int>(MockMix<int>(42));
        const source2 = MixPropValueSource<int>(MockMix<int>(42));
        const source3 = MixPropValueSource<int>(MockMix<int>(24));

        expect(source1, equals(source2));
        expect(source1.hashCode, equals(source2.hashCode));
        expect(source1, isNot(equals(source3)));
      });
    });

    group('MixPropTokenSource', () {
      test('stores token and converter', () {
        final token = MixToken<int>('value');
        MockMix<int> converter(int v) => MockMix<int>(v);
        final source = MixPropTokenSource<int>(token, converter);

        expect(source.token, equals(token));
        expect(source.convertToMix, equals(converter));
      });

      test('toString returns correct format', () {
        final token = MixToken<int>('value');
        final source = MixPropTokenSource<int>(token, (v) => MockMix<int>(v));

        expect(source.toString(), equals('MixPropTokenSource($token)'));
      });

      test('equality considers token and converter', () {
        final token1 = MixToken<int>('value1');
        final token2 = MixToken<int>('value2');
        MockMix<int> converter(int v) => MockMix<int>(v);

        final source1 = MixPropTokenSource<int>(token1, converter);
        final source2 = MixPropTokenSource<int>(token1, converter);
        final source3 = MixPropTokenSource<int>(token2, converter);

        expect(source1, equals(source2));
        expect(source1.hashCode, equals(source2.hashCode));
        expect(source1, isNot(equals(source3)));
      });
    });

    group('MixPropAccumulativeSource', () {
      test('stores list of sources', () {
        const sources = [
          MixPropValueSource<int>(MockMix<int>(10)),
          MixPropValueSource<int>(MockMix<int>(20)),
        ];
        const accSource = MixPropAccumulativeSource<int>(sources);

        expect(accSource.sources, equals(sources));
      });

      test('toString shows source count', () {
        const accSource = MixPropAccumulativeSource<int>([
          MixPropValueSource<int>(MockMix<int>(10)),
          MixPropValueSource<int>(MockMix<int>(20)),
          MixPropValueSource<int>(MockMix<int>(30)),
        ]);

        expect(
          accSource.toString(),
          equals('MixPropAccumulativeSource(3 sources)'),
        );
      });

      test('equality and hashCode', () {
        const source1 = MixPropAccumulativeSource<int>([
          MixPropValueSource<int>(MockMix<int>(10)),
          MixPropValueSource<int>(MockMix<int>(20)),
        ]);
        const source2 = MixPropAccumulativeSource<int>([
          MixPropValueSource<int>(MockMix<int>(10)),
          MixPropValueSource<int>(MockMix<int>(20)),
        ]);
        const source3 = MixPropAccumulativeSource<int>([
          MixPropValueSource<int>(MockMix<int>(30)),
        ]);

        expect(source1, equals(source2));
        expect(source1.hashCode, equals(source2.hashCode));
        expect(source1, isNot(equals(source3)));
      });
    });
  });

  group('Prop', () {
    group('Construction', () {
      test('value constructor creates ValuePropSource', () {
        final prop = Prop(42);

        expect(prop.source, isA<ValuePropSource<int>>());
        expect(prop.hasValue, isTrue);
        expect(prop.hasToken, isFalse);
        expect(prop.value, equals(42));
      });

      test('token constructor creates TokenPropSource', () {
        final token = MixToken<Color>('primary');
        final prop = Prop.token(token);

        expect(prop.source, isA<TokenPropSource<Color>>());
        expect(prop.hasValue, isFalse);
        expect(prop.hasToken, isTrue);
        expect(prop.token, equals(token));
      });

      test('maybe returns null for null value', () {
        final prop = Prop.maybe<int>(null);
        expect(prop, isNull);
      });

      test('maybe returns Prop for non-null value', () {
        final prop = Prop.maybe<int>(42);
        expect(prop, isNotNull);
        expect(prop!.value, equals(42));
      });

      test('supports directives', () {
        final directive = MockDirective<int>('double', (v) => v * 2);
        final prop = Prop(42, directives: [directive]);

        expect(prop.directives, equals([directive]));
      });

      test('supports animation', () {
        final animation = AnimationConfig.withDefaults();
        final prop = Prop(42, animation: animation);

        expect(prop.animation, equals(animation));
      });

      test('directives constructor creates prop with only directives', () {
        final directive = MockDirective<int>('double', (v) => v * 2);
        final prop = Prop<int>.directives([directive]);

        expect(prop.source, isNull);
        expect(prop.directives, equals([directive]));
        expect(prop.animation, isNull);
      });

      test('animation constructor creates prop with only animation', () {
        final animation = AnimationConfig.withDefaults();
        final prop = Prop<int>.animation(animation);

        expect(prop.source, isNull);
        expect(prop.directives, isNull);
        expect(prop.animation, equals(animation));
      });
    });

    group('Getters', () {
      test('value getter throws for non-value source', () {
        final token = MixToken<Color>('primary');
        final prop = Prop.token(token);

        expect(() => prop.value, throwsA(isA<FlutterError>()));
      });

      test('token getter throws for non-token source', () {
        final prop = Prop(42);

        expect(() => prop.token, throwsA(isA<FlutterError>()));
      });
    });

    group('Resolution', () {
      test('resolves direct value', () {
        final prop = Prop(42);

        expect(prop, resolvesTo(42));
      });

      test('resolves token from context', () {
        final token = MixToken<Color>('primary');
        final prop = Prop.token(token);
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(tokens: {token: Colors.blue}),
        );

        expect(prop, resolvesTo(Colors.blue, context: context));
      });

      test('throws when token not found', () {
        final token = MixToken<Color>('primary');
        final prop = Prop.token(token);
        final context = MockBuildContext();

        expect(() => prop.resolve(context), throwsA(isA<StateError>()));
      });

      test('throws when source is null', () {
        const prop = Prop<int>.directives([]);
        final context = MockBuildContext();

        expect(() => prop.resolve(context), throwsA(isA<FlutterError>()));
      });

      test('applies directives in order', () {
        final prop = Prop(
          10,
          directives: [
            MockDirective<int>('multiply', (v) => v * 2), // 20
            MockDirective<int>('add', (v) => v + 5), // 25
          ],
        );

        expect(prop, resolvesTo(25));
      });
    });

    group('Merge behavior - replacement', () {
      test('returns self when merging with null', () {
        final prop = Prop(42);
        expect(prop.merge(null), same(prop));
      });

      test('other source replaces this source', () {
        final prop1 = Prop(42);
        final prop2 = Prop(24);
        final merged = prop1.merge(prop2);

        expect(merged.value, equals(24));
      });

      test('preserves source when other has null source', () {
        final prop1 = Prop(42);
        const prop2 = Prop<int>.directives([]);
        final merged = prop1.merge(prop2);

        expect(merged.value, equals(42));
      });

      test('merges directives - concatenates', () {
        final directive1 = MockDirective<int>('multiply', (v) => v * 2);
        final directive2 = MockDirective<int>('add', (v) => v + 10);

        final prop1 = Prop(10, directives: [directive1]);
        final prop2 = Prop(20, directives: [directive2]);
        final merged = prop1.merge(prop2);

        expect(merged.directives, equals([directive1, directive2]));
        expect(merged.resolve(MockBuildContext()), equals(50)); // (20 * 2) + 10
      });

      test('animation - other wins', () {
        final animation1 = AnimationConfig.curve(
          duration: Duration(seconds: 1),
          curve: Curves.linear,
        );
        final animation2 = AnimationConfig.curve(
          duration: Duration(seconds: 2),
          curve: Curves.ease,
        );

        final prop1 = Prop(42, animation: animation1);
        final prop2 = Prop(24, animation: animation2);
        final merged = prop1.merge(prop2);

        expect(merged.animation, equals(animation2));
      });

      test('preserves animation when other has none', () {
        final animation = AnimationConfig.curve(
          duration: Duration(seconds: 1),
          curve: Curves.linear,
        );

        final prop1 = Prop(42, animation: animation);
        final prop2 = Prop(24);
        final merged = prop1.merge(prop2);

        expect(merged.animation, equals(animation));
      });
    });

    group('toString', () {
      test('shows source', () {
        final prop = Prop(42);
        expect(prop.toString(), contains('source: ValuePropSource(42)'));
      });

      test('shows null source', () {
        const prop = Prop<int>.directives([]);
        expect(prop.toString(), contains('source: null'));
      });

      test('shows directive count', () {
        final prop = Prop(
          42,
          directives: [
            MockDirective<int>('identity1', (v) => v),
            MockDirective<int>('identity2', (v) => v),
          ],
        );
        expect(prop.toString(), contains('directives: 2'));
      });

      test('shows animation', () {
        final prop = Prop(42, animation: AnimationConfig.withDefaults());
        expect(prop.toString(), contains('animated'));
      });
    });

    group('Equality', () {
      test('equal props are equal', () {
        final prop1 = Prop(42);
        final prop2 = Prop(42);

        expect(prop1, equals(prop2));
        expect(prop1.hashCode, equals(prop2.hashCode));
      });

      test('different values are not equal', () {
        final prop1 = Prop(42);
        final prop2 = Prop(24);

        expect(prop1, isNot(equals(prop2)));
      });

      test('considers directives', () {
        final directive = MockDirective<int>('double', (v) => v * 2);
        final prop1 = Prop(42);
        final prop2 = Prop(42, directives: [directive]);

        expect(prop1, isNot(equals(prop2)));
      });

      test('considers animation', () {
        final animation = AnimationConfig.withDefaults();
        final prop1 = Prop(42);
        final prop2 = Prop(42, animation: animation);

        expect(prop1, isNot(equals(prop2)));
      });
    });
  });

  group('MixProp', () {
    group('Construction', () {
      test('value constructor creates MixPropValueSource', () {
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop = MixProp(mixValue);

        expect(prop.source, isA<MixPropValueSource<int>>());
        expect(prop.hasValue, isTrue);
        expect(prop.hasToken, isFalse);
        expect(prop.value, equals(mixValue));
      });

      test('token constructor creates MixPropTokenSource', () {
        final token = MixToken<int>('value');
        final prop = MixProp.token(token, (v) => MockMix<int>(v));

        expect(prop.source, isA<MixPropTokenSource<int>>());
        expect(prop.hasValue, isFalse);
        expect(prop.hasToken, isTrue);
        expect(prop.token, equals(token));
      });

      test('maybe returns null for null value', () {
        final prop = MixProp.maybe<int>(null);
        expect(prop, isNull);
      });

      test('maybe returns MixProp for non-null value', () {
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop = MixProp.maybe<int>(mixValue);
        expect(prop, isNotNull);
        expect(prop!.value, equals(mixValue));
      });

      test('supports directives', () {
        final directive = MockDirective<int>('double', (v) => v * 2);
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop = MixProp(mixValue, directives: [directive]);

        expect(prop.directives, equals([directive]));
      });

      test('supports animation', () {
        final animation = AnimationConfig.withDefaults();
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop = MixProp(mixValue, animation: animation);

        expect(prop.animation, equals(animation));
      });

      test('directives constructor creates prop with only directives', () {
        final directive = MockDirective<int>('double', (v) => v * 2);
        final prop = MixProp<int>.directives([directive]);

        expect(prop.source, isNull);
        expect(prop.directives, equals([directive]));
        expect(prop.animation, isNull);
      });

      test('animation constructor creates prop with only animation', () {
        final animation = AnimationConfig.withDefaults();
        final prop = MixProp<int>.animation(animation);

        expect(prop.source, isNull);
        expect(prop.directives, isNull);
        expect(prop.animation, equals(animation));
      });
    });

    group('Getters', () {
      test('value getter throws for non-value source', () {
        final token = MixToken<int>('value');
        final prop = MixProp.token(token, (v) => MockMix<int>(v));

        expect(() => prop.value, throwsA(isA<FlutterError>()));
      });

      test('token getter throws for non-token source', () {
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop = MixProp(mixValue);

        expect(() => prop.token, throwsA(isA<FlutterError>()));
      });
    });

    group('Resolution', () {
      test('resolves direct Mix value', () {
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop = MixProp(mixValue);
        final context = MockBuildContext();

        expect(prop.resolve(context), equals(42)); // Mix resolves to int
      });

      test('resolves token and converts to Mix', () {
        final token = MixToken<int>('value');
        final prop = MixProp.token(token, (v) => MockMix<int>(v * 2));
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(tokens: {token: 10}),
        );

        expect(
          prop.resolve(context),
          equals(10),
        ); // MixScope.tokenOf returns 10
      });

      test('resolves accumulative source', () {
        // Test accumulative source through actual merge operations
        final prop1 = MixProp(MockMix<int>(10));
        final prop2 = MixProp(MockMix<int>(20));
        final prop3 = MixProp(MockMix<int>(30));
        final merged = prop1.merge(prop2).merge(prop3);
        final context = MockBuildContext();

        // When value sources are merged multiple times, they get optimized into a single value source
        expect(merged.source, isA<MixPropValueSource<int>>());
        expect(
          merged.resolve(context),
          equals(30),
        ); // Default merger: last wins
      });

      test('resolves accumulative with mixed sources', () {
        final token = MixToken<int>('value');
        // Test accumulative source through actual merge operations
        final prop1 = MixProp(MockMix<int>(10));
        final prop2 = MixProp.token(token, (v) => MockMix<int>(v));
        final prop3 = MixProp(MockMix<int>(30));
        final merged = prop1.merge(prop2).merge(prop3);

        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(tokens: {token: 20}),
        );

        expect(
          merged.resolve(context),
          equals(30),
        ); // Default merger: last wins
      });

      test('throws when source is null', () {
        const prop = MixProp<int>.directives([]);
        final context = MockBuildContext();

        expect(() => prop.resolve(context), throwsA(isA<FlutterError>()));
      });

      test('applies directives in order', () {
        const mixValue = MockMix<int>(10);
        final prop = MixProp(
          mixValue,
          directives: [
            MockDirective<int>('multiply', (v) => v * 2), // 20
            MockDirective<int>('add', (v) => v + 5), // 25
          ],
        );
        final context = MockBuildContext();

        expect(prop.resolve(context), equals(25));
      });
    });

    group('Merge behavior - accumulation', () {
      test('returns self when merging with null', () {
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop = MixProp(mixValue);
        expect(prop.merge(null), same(prop));
      });

      test('optimizes two value sources by merging directly', () {
        final prop1 = MixProp(MockMix<int>(10));
        final prop2 = MixProp(MockMix<int>(20));
        final merged = prop1.merge(prop2);

        expect(merged.source, isA<MixPropValueSource<int>>());
        // Check the resolved value from the merged Mix
        final resolvedMix = merged.value;
        expect(
          resolvedMix.resolve(MockBuildContext()),
          equals(20),
        ); // Default merger: other wins
      });

      test('creates accumulative source for different types', () {
        final token = MixToken<int>('value');
        final prop1 = MixProp(MockMix<int>(10, merger: (a, b) => a + b));
        final prop2 = MixProp.token(
          token,
          (v) => MockMix<int>(v, merger: (a, b) => a + b),
        );
        final merged = prop1.merge(prop2);

        expect(merged.source, isA<MixPropAccumulativeSource<int>>());
        final accSource = merged.source as MixPropAccumulativeSource<int>;
        expect(accSource.sources.length, equals(2));
      });

      test('flattens nested accumulative sources', () {
        final prop1 = MixProp(MockMix<int>(10));
        final prop2 = MixProp(MockMix<int>(20));
        final prop3 = MixProp(MockMix<int>(30));
        final prop4 = MixProp(MockMix<int>(40));

        final merged1 = prop1.merge(prop2); // Creates optimized value source
        final merged2 = prop3.merge(prop4); // Creates optimized value source
        final finalMerged = merged1.merge(merged2);

        expect(finalMerged.source, isA<MixPropValueSource<int>>());

        final context = MockBuildContext();
        expect(
          finalMerged.resolve(context),
          equals(40),
        ); // Default merger: last wins
      });

      test('merges directives - concatenates', () {
        final directive1 = MockDirective<int>('multiply', (v) => v * 2);
        final directive2 = MockDirective<int>('add', (v) => v + 10);

        final prop1 = MixProp(MockMix<int>(5), directives: [directive1]);
        final prop2 = MixProp(MockMix<int>(10), directives: [directive2]);
        final merged = prop1.merge(prop2);

        expect(merged.directives, equals([directive1, directive2]));

        final result = merged.resolve(MockBuildContext());
        expect(
          result,
          equals(30),
        ); // ((10) * 2) + 10 - default merger: other wins
      });

      test('animation - other wins', () {
        final animation1 = AnimationConfig.curve(
          duration: Duration(seconds: 1),
          curve: Curves.linear,
        );
        final animation2 = AnimationConfig.curve(
          duration: Duration(seconds: 2),
          curve: Curves.ease,
        );

        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop1 = MixProp(mixValue, animation: animation1);
        final prop2 = MixProp(mixValue, animation: animation2);
        final merged = prop1.merge(prop2);

        expect(merged.animation, equals(animation2));
      });
    });

    group('toString', () {
      test('shows source', () {
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop = MixProp(mixValue);
        expect(prop.toString(), contains('source: MixPropValueSource'));
      });

      test('shows null source', () {
        const prop = MixProp<int>.directives([]);
        expect(prop.toString(), equals('MixProp()'));
      });

      test('shows directive count', () {
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop = MixProp(
          mixValue,
          directives: [
            MockDirective<int>('identity1', (v) => v),
            MockDirective<int>('identity2', (v) => v),
          ],
        );
        expect(prop.toString(), contains('directives: 2'));
      });

      test('shows animation', () {
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop = MixProp(
          mixValue,
          animation: AnimationConfig.withDefaults(),
        );
        expect(prop.toString(), contains('animated'));
      });
    });

    group('Equality', () {
      test('equal props are equal', () {
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop1 = MixProp(mixValue);
        final prop2 = MixProp(mixValue);

        expect(prop1, equals(prop2));
        expect(prop1.hashCode, equals(prop2.hashCode));
      });

      test('different values are not equal', () {
        final prop1 = MixProp(MockMix<int>(42, merger: (a, b) => a + b));
        final prop2 = MixProp(MockMix<int>(24, merger: (a, b) => a + b));

        expect(prop1, isNot(equals(prop2)));
      });

      test('considers directives', () {
        final directive = MockDirective<int>('double', (v) => v * 2);
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop1 = MixProp(mixValue);
        final prop2 = MixProp(mixValue, directives: [directive]);

        expect(prop1, isNot(equals(prop2)));
      });

      test('considers animation', () {
        final animation = AnimationConfig.withDefaults();
        final mixValue = MockMix<int>(42, merger: (a, b) => a + b);
        final prop1 = MixProp(mixValue);
        final prop2 = MixProp(mixValue, animation: animation);

        expect(prop1, isNot(equals(prop2)));
      });
    });
  });

  group('Additional Prop Equality Tests', () {
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
        expect(merged.resolve(MockBuildContext()), equals(Colors.blue));

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
        // Use the same directive instance to ensure equality
        final directive = MockDirective<Color>('brighten', (c) => c);

        final prop1 = Prop.directives([directive]);
        final prop2 = Prop.directives([directive]);

        expect(prop1, equals(prop2));
      });

      test('Props with different directives are not equal', () {
        final directive1 = MockDirective<Color>('brighten', (c) => c);
        final directive2 = MockDirective<Color>('darken', (c) => c);

        final prop1 = Prop.directives([directive1]);
        final prop2 = Prop.directives([directive2]);

        expect(prop1, isNot(equals(prop2)));
      });

      test('merged Props with directives accumulate correctly', () {
        final directive1 = MockDirective<Color>('brighten', (c) => c);
        final directive2 = MockDirective<Color>('darken', (c) => c);

        final prop1 = Prop.directives([directive1]);
        final prop2 = Prop.directives([directive2]);
        final merged = prop1.merge(prop2);

        expect(merged.directives, hasLength(2));
        expect(merged.directives, contains(directive1));
        expect(merged.directives, contains(directive2));
      });

      test('merged Props with accumulated directives maintain equality', () {
        final directive1 = MockDirective<Color>('brighten', (c) => c);
        final directive2 = MockDirective<Color>('darken', (c) => c);

        final prop1 = Prop.directives([directive1]);
        final prop2 = Prop.directives([directive2]);
        final merged = prop1.merge(prop2);

        // Create expected prop with same directives - use List<MixDirective<Color>> to match merge result
        final expected = Prop.directives([directive1, directive2]);

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

      test('merged MixProps with identical values equals expected', () {
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
        final prop1 = Prop<Color?>(null);
        final prop2 = Prop<Color?>(null);

        expect(prop1, equals(prop2));
      });

      test('empty directive lists are equal regardless of creation method', () {
        final prop1 = Prop(Colors.red);
        final prop2 = Prop.directives(const []);

        // Both should have empty directive lists
        expect(prop1.directives, isNull);
        expect(prop2.directives, isEmpty);

        // But they're not equal because one has a value and the other doesn't
        expect(prop1, isNot(equals(prop2)));
      });
    });
  });

  group('Integration Tests', () {
    test('complex merge scenario with directives and animations', () {
      final animation1 = AnimationConfig.curve(
        duration: Duration(seconds: 1),
        curve: Curves.linear,
      );
      final animation2 = AnimationConfig.curve(
        duration: Duration(seconds: 2),
        curve: Curves.ease,
      );

      final prop1 = Prop(
        10,
        directives: [MockDirective<int>('multiply', (v) => v * 2)],
        animation: animation1,
      );
      final prop2 = Prop(
        20,
        directives: [MockDirective<int>('add5', (v) => v + 5)],
      );
      final prop3 = Prop(
        30,
        directives: [MockDirective<int>('subtract10', (v) => v - 10)],
        animation: animation2,
      );

      final merged = prop1.merge(prop2).merge(prop3);

      expect(merged.value, equals(30)); // Last value wins
      expect(
        merged.directives!.length,
        equals(3),
      ); // All directives accumulated
      expect(merged.animation, equals(animation2)); // Last animation wins

      final result = merged.resolve(MockBuildContext());
      expect(result, equals(55)); // ((30 * 2) + 5) - 10
    });

    test('deep MixProp accumulation with tokens', () {
      final token1 = MixToken<int>('value1');
      final token2 = MixToken<int>('value2');

      final prop1 = MixProp(MockMix<int>(10, merger: (a, b) => a + b));
      final prop2 = MixProp.token(
        token1,
        (v) => MockMix<int>(v, merger: (a, b) => a + b),
      );
      final prop3 = MixProp(MockMix<int>(30, merger: (a, b) => a + b));
      final prop4 = MixProp.token(
        token2,
        (v) => MockMix<int>(v, merger: (a, b) => a + b),
      );
      final prop5 = MixProp(MockMix<int>(50, merger: (a, b) => a + b));

      final merged = prop1.merge(prop2).merge(prop3).merge(prop4).merge(prop5);

      final context = MockBuildContext(
        mixScopeData: MixScopeData.static(tokens: {token1: 20, token2: 40}),
      );

      final result = merged.resolve(context);
      expect(result, equals(150)); // 10 + 20 + 30 + 40 + 50
    });

    test('error propagation', () {
      final token = MixToken<Color>('missing');
      final prop = Prop.token(token);
      final context = MockBuildContext();

      expect(() => prop.resolve(context), throwsA(isA<StateError>()));
    });

    test('directive error handling', () {
      final errorDirective = MockDirective<int>('error', (value) {
        throw Exception('Directive error');
      });

      final prop = Prop(42, directives: [errorDirective]);
      final context = MockBuildContext();

      expect(() => prop.resolve(context), throwsException);
    });
  });
}
