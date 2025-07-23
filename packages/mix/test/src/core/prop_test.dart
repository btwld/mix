import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

// Test directive that modifies values
class _TestDirective<T> extends MixDirective<T> {
  final T Function(T) transformer;
  final String name;
  
  const _TestDirective(this.transformer, [this.name = 'test']);
  
  @override
  T apply(T value) => transformer(value);
  
  @override
  String get key => name;
}

// Test Mix type for testing MixProp
class _TestMix extends Mix<int> {
  final int value;
  
  const _TestMix(this.value);
  
  @override
  _TestMix merge(covariant _TestMix? other) {
    if (other == null) return this;
    return _TestMix(value + other.value);
  }
  
  @override
  int resolve(BuildContext context) => value;
  
  @override
  List<Object?> get props => [value];
}

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
        const mixValue = _TestMix(42);
        const source = MixPropValueSource<int>(mixValue);
        
        expect(source.value, equals(mixValue));
      });
      
      test('toString returns correct format', () {
        const mixValue = _TestMix(42);
        const source = MixPropValueSource<int>(mixValue);
        
        expect(source.toString(), equals('MixPropValueSource($mixValue)'));
      });
      
      test('equality and hashCode', () {
        const source1 = MixPropValueSource<int>(_TestMix(42));
        const source2 = MixPropValueSource<int>(_TestMix(42));
        const source3 = MixPropValueSource<int>(_TestMix(24));
        
        expect(source1, equals(source2));
        expect(source1.hashCode, equals(source2.hashCode));
        expect(source1, isNot(equals(source3)));
      });
    });
    
    group('MixPropTokenSource', () {
      test('stores token and converter', () {
        final token = MixToken<int>('value');
        _TestMix converter(int v) => _TestMix(v);
        final source = MixPropTokenSource<int>(token, converter);
        
        expect(source.token, equals(token));
        expect(source.convertToMix, equals(converter));
      });
      
      test('toString returns correct format', () {
        final token = MixToken<int>('value');
        final source = MixPropTokenSource<int>(
          token,
          (v) => _TestMix(v),
        );
        
        expect(source.toString(), equals('MixPropTokenSource($token)'));
      });
      
      test('equality considers token and converter', () {
        final token1 = MixToken<int>('value1');
        final token2 = MixToken<int>('value2');
        _TestMix converter(int v) => _TestMix(v);
        
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
          MixPropValueSource<int>(_TestMix(10)),
          MixPropValueSource<int>(_TestMix(20)),
        ];
        const accSource = MixPropAccumulativeSource<int>(sources);
        
        expect(accSource.sources, equals(sources));
      });
      
      test('toString shows source count', () {
        const accSource = MixPropAccumulativeSource<int>([
          MixPropValueSource<int>(_TestMix(10)),
          MixPropValueSource<int>(_TestMix(20)),
          MixPropValueSource<int>(_TestMix(30)),
        ]);
        
        expect(accSource.toString(), equals('MixPropAccumulativeSource(3 sources)'));
      });
      
      test('equality and hashCode', () {
        const source1 = MixPropAccumulativeSource<int>([
          MixPropValueSource<int>(_TestMix(10)),
          MixPropValueSource<int>(_TestMix(20)),
        ]);
        const source2 = MixPropAccumulativeSource<int>([
          MixPropValueSource<int>(_TestMix(10)),
          MixPropValueSource<int>(_TestMix(20)),
        ]);
        const source3 = MixPropAccumulativeSource<int>([
          MixPropValueSource<int>(_TestMix(30)),
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
        final directive = _TestDirective<int>((v) => v * 2);
        final prop = Prop(42, directives: [directive]);
        
        expect(prop.directives, equals([directive]));
      });
      
      test('supports animation', () {
        final animation = AnimationConfig.withDefaults();
        final prop = Prop(42, animation: animation);
        
        expect(prop.animation, equals(animation));
      });
      
      test('directives constructor creates prop with only directives', () {
        final directive = _TestDirective<int>((v) => v * 2);
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
        
        expect(
          () => prop.value,
          throwsA(isA<FlutterError>()),
        );
      });
      
      test('token getter throws for non-token source', () {
        final prop = Prop(42);
        
        expect(
          () => prop.token,
          throwsA(isA<FlutterError>()),
        );
      });
    });
    
    group('Resolution', () {
      test('resolves direct value', () {
        final prop = Prop(42);
        final context = MockBuildContext();
        
        expect(prop.resolve(context), equals(42));
      });
      
      test('resolves token from context', () {
        final token = MixToken<Color>('primary');
        final prop = Prop.token(token);
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(
            tokens: {token: Colors.blue},
          ),
        );
        
        expect(prop.resolve(context), equals(Colors.blue));
      });
      
      test('throws when token not found', () {
        final token = MixToken<Color>('primary');
        final prop = Prop.token(token);
        final context = MockBuildContext();
        
        expect(
          () => prop.resolve(context),
          throwsA(isA<FlutterError>()),
        );
      });
      
      test('throws when source is null', () {
        const prop = Prop<int>.directives([]);
        final context = MockBuildContext();
        
        expect(
          () => prop.resolve(context),
          throwsA(isA<FlutterError>()),
        );
      });
      
      test('applies directives in order', () {
        final prop = Prop(
          10,
          directives: [
            _TestDirective<int>((v) => v * 2),  // 20
            _TestDirective<int>((v) => v + 5),  // 25
          ],
        );
        final context = MockBuildContext();
        
        expect(prop.resolve(context), equals(25));
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
        final directive1 = _TestDirective<int>((v) => v * 2);
        final directive2 = _TestDirective<int>((v) => v + 10);
        
        final prop1 = Prop(10, directives: [directive1]);
        final prop2 = Prop(20, directives: [directive2]);
        final merged = prop1.merge(prop2);
        
        expect(merged.directives, equals([directive1, directive2]));
        expect(merged.resolve(MockBuildContext()), equals(50)); // (20 * 2) + 10
      });
      
      test('animation - other wins', () {
        final animation1 = AnimationConfig.linear(Duration(seconds: 1));
        final animation2 = AnimationConfig.ease(Duration(seconds: 2));
        
        final prop1 = Prop(42, animation: animation1);
        final prop2 = Prop(24, animation: animation2);
        final merged = prop1.merge(prop2);
        
        expect(merged.animation, equals(animation2));
      });
      
      test('preserves animation when other has none', () {
        final animation = AnimationConfig.linear(Duration(seconds: 1));
        
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
        final prop = Prop(42, directives: [
          _TestDirective<int>((v) => v),
          _TestDirective<int>((v) => v),
        ]);
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
        final directive = _TestDirective<int>((v) => v * 2);
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
        const mixValue = _TestMix(42);
        final prop = MixProp(mixValue);
        
        expect(prop.source, isA<MixPropValueSource<int>>());
        expect(prop.hasValue, isTrue);
        expect(prop.hasToken, isFalse);
        expect(prop.value, equals(mixValue));
      });
      
      test('token constructor creates MixPropTokenSource', () {
        final token = MixToken<int>('value');
        final prop = MixProp.token(token, (v) => _TestMix(v));
        
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
        const mixValue = _TestMix(42);
        final prop = MixProp.maybe<int>(mixValue);
        expect(prop, isNotNull);
        expect(prop!.value, equals(mixValue));
      });
      
      test('supports directives', () {
        final directive = _TestDirective<int>((v) => v * 2);
        const mixValue = _TestMix(42);
        final prop = MixProp(mixValue, directives: [directive]);
        
        expect(prop.directives, equals([directive]));
      });
      
      test('supports animation', () {
        final animation = AnimationConfig.withDefaults();
        const mixValue = _TestMix(42);
        final prop = MixProp(mixValue, animation: animation);
        
        expect(prop.animation, equals(animation));
      });
      
      test('directives constructor creates prop with only directives', () {
        final directive = _TestDirective<int>((v) => v * 2);
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
        final prop = MixProp.token(token, (v) => _TestMix(v));
        
        expect(
          () => prop.value,
          throwsA(isA<FlutterError>()),
        );
      });
      
      test('token getter throws for non-token source', () {
        const mixValue = _TestMix(42);
        final prop = MixProp(mixValue);
        
        expect(
          () => prop.token,
          throwsA(isA<FlutterError>()),
        );
      });
    });
    
    group('Resolution', () {
      test('resolves direct Mix value', () {
        const mixValue = _TestMix(42);
        final prop = MixProp(mixValue);
        final context = MockBuildContext();
        
        expect(prop.resolve(context), equals(42)); // Mix resolves to int
      });
      
      test('resolves token and converts to Mix', () {
        final token = MixToken<int>('value');
        final prop = MixProp.token(token, (v) => _TestMix(v * 2));
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(
            tokens: {token: 10},
          ),
        );
        
        expect(prop.resolve(context), equals(20)); // Token 10 * 2 = 20
      });
      
      test('resolves accumulative source', () {
        // Test accumulative source through actual merge operations
        final prop1 = MixProp(_TestMix(10));
        final prop2 = MixProp(_TestMix(20));
        final prop3 = MixProp(_TestMix(30));
        final merged = prop1.merge(prop2).merge(prop3);
        final context = MockBuildContext();
        
        // Verify it creates an accumulative source internally
        expect(merged.source, isA<MixPropAccumulativeSource<int>>());
        expect(merged.resolve(context), equals(60)); // 10 + 20 + 30
      });
      
      test('resolves accumulative with mixed sources', () {
        final token = MixToken<int>('value');
        // Test accumulative source through actual merge operations
        final prop1 = MixProp(_TestMix(10));
        final prop2 = MixProp.token(token, (v) => _TestMix(v));
        final prop3 = MixProp(_TestMix(30));
        final merged = prop1.merge(prop2).merge(prop3);
        
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(
            tokens: {token: 20},
          ),
        );
        
        expect(merged.resolve(context), equals(60)); // 10 + 20 + 30
      });
      
      test('throws when source is null', () {
        final prop = MixProp<int>._(source: null);
        final context = MockBuildContext();
        
        expect(
          () => prop.resolve(context),
          throwsA(isA<FlutterError>()),
        );
      });
      
      test('applies directives in order', () {
        const mixValue = _TestMix(10);
        final prop = MixProp(
          mixValue,
          directives: [
            _TestDirective<int>((v) => v * 2),  // 20
            _TestDirective<int>((v) => v + 5),  // 25
          ],
        );
        final context = MockBuildContext();
        
        expect(prop.resolve(context), equals(25));
      });
    });
    
    group('Merge behavior - accumulation', () {
      test('returns self when merging with null', () {
        const mixValue = _TestMix(42);
        final prop = MixProp(mixValue);
        expect(prop.merge(null), same(prop));
      });
      
      test('optimizes two value sources by merging directly', () {
        final prop1 = MixProp(_TestMix(10));
        final prop2 = MixProp(_TestMix(20));
        final merged = prop1.merge(prop2);
        
        expect(merged.source, isA<MixPropValueSource<int>>());
        expect(merged.value, equals(_TestMix(30))); // 10 + 20
      });
      
      test('creates accumulative source for different types', () {
        final token = MixToken<int>('value');
        final prop1 = MixProp(_TestMix(10));
        final prop2 = MixProp.token(token, (v) => _TestMix(v));
        final merged = prop1.merge(prop2);
        
        expect(merged.source, isA<MixPropAccumulativeSource<int>>());
        final accSource = merged.source as MixPropAccumulativeSource<int>;
        expect(accSource.sources.length, equals(2));
      });
      
      test('flattens nested accumulative sources', () {
        final prop1 = MixProp(_TestMix(10));
        final prop2 = MixProp(_TestMix(20));
        final prop3 = MixProp(_TestMix(30));
        final prop4 = MixProp(_TestMix(40));
        
        final merged1 = prop1.merge(prop2); // Creates accumulative
        final merged2 = prop3.merge(prop4); // Creates accumulative
        final finalMerged = merged1.merge(merged2);
        
        expect(finalMerged.source, isA<MixPropAccumulativeSource<int>>());
        
        // Should flatten to 2 sources (each merged pair is optimized)
        final accSource = finalMerged.source as MixPropAccumulativeSource<int>;
        expect(accSource.sources.length, equals(2));
        
        final context = MockBuildContext();
        expect(finalMerged.resolve(context), equals(100)); // 10+20+30+40
      });
      
      test('merges directives - concatenates', () {
        final directive1 = _TestDirective<int>((v) => v * 2);
        final directive2 = _TestDirective<int>((v) => v + 10);
        
        final prop1 = MixProp(_TestMix(5), directives: [directive1]);
        final prop2 = MixProp(_TestMix(10), directives: [directive2]);
        final merged = prop1.merge(prop2);
        
        expect(merged.directives, equals([directive1, directive2]));
        
        final result = merged.resolve(MockBuildContext());
        expect(result, equals(40)); // ((5 + 10) * 2) + 10
      });
      
      test('animation - other wins', () {
        final animation1 = AnimationConfig.linear(Duration(seconds: 1));
        final animation2 = AnimationConfig.ease(Duration(seconds: 2));
        
        const mixValue = _TestMix(42);
        final prop1 = MixProp(mixValue, animation: animation1);
        final prop2 = MixProp(mixValue, animation: animation2);
        final merged = prop1.merge(prop2);
        
        expect(merged.animation, equals(animation2));
      });
    });
    
    group('toString', () {
      test('shows source', () {
        const mixValue = _TestMix(42);
        final prop = MixProp(mixValue);
        expect(prop.toString(), contains('source: MixPropValueSource'));
      });
      
      test('shows null source', () {
        final prop = MixProp<int>._(source: null);
        expect(prop.toString(), equals('MixProp()'));
      });
      
      test('shows directive count', () {
        const mixValue = _TestMix(42);
        final prop = MixProp(mixValue, directives: [
          _TestDirective<int>((v) => v),
          _TestDirective<int>((v) => v),
        ]);
        expect(prop.toString(), contains('directives: 2'));
      });
      
      test('shows animation', () {
        const mixValue = _TestMix(42);
        final prop = MixProp(mixValue, animation: AnimationConfig.withDefaults());
        expect(prop.toString(), contains('animated'));
      });
    });
    
    group('Equality', () {
      test('equal props are equal', () {
        const mixValue = _TestMix(42);
        final prop1 = MixProp(mixValue);
        final prop2 = MixProp(mixValue);
        
        expect(prop1, equals(prop2));
        expect(prop1.hashCode, equals(prop2.hashCode));
      });
      
      test('different values are not equal', () {
        final prop1 = MixProp(_TestMix(42));
        final prop2 = MixProp(_TestMix(24));
        
        expect(prop1, isNot(equals(prop2)));
      });
      
      test('considers directives', () {
        final directive = _TestDirective<int>((v) => v * 2);
        const mixValue = _TestMix(42);
        final prop1 = MixProp(mixValue);
        final prop2 = MixProp(mixValue, directives: [directive]);
        
        expect(prop1, isNot(equals(prop2)));
      });
      
      test('considers animation', () {
        final animation = AnimationConfig.withDefaults();
        const mixValue = _TestMix(42);
        final prop1 = MixProp(mixValue);
        final prop2 = MixProp(mixValue, animation: animation);
        
        expect(prop1, isNot(equals(prop2)));
      });
    });
  });
  
  group('Integration Tests', () {
    test('complex merge scenario with directives and animations', () {
      final animation1 = AnimationConfig.linear(Duration(seconds: 1));
      final animation2 = AnimationConfig.ease(Duration(seconds: 2));
      
      final prop1 = Prop(
        10,
        directives: [_TestDirective<int>((v) => v * 2)],
        animation: animation1,
      );
      final prop2 = Prop(
        20,
        directives: [_TestDirective<int>((v) => v + 5)],
      );
      final prop3 = Prop(
        30,
        directives: [_TestDirective<int>((v) => v - 10)],
        animation: animation2,
      );
      
      final merged = prop1.merge(prop2).merge(prop3);
      
      expect(merged.value, equals(30)); // Last value wins
      expect(merged.directives!.length, equals(3)); // All directives accumulated
      expect(merged.animation, equals(animation2)); // Last animation wins
      
      final result = merged.resolve(MockBuildContext());
      expect(result, equals(55)); // ((30 * 2) + 5) - 10
    });
    
    test('deep MixProp accumulation with tokens', () {
      final token1 = MixToken<int>('value1');
      final token2 = MixToken<int>('value2');
      
      final prop1 = MixProp(_TestMix(10));
      final prop2 = MixProp.token(token1, (v) => _TestMix(v));
      final prop3 = MixProp(_TestMix(30));
      final prop4 = MixProp.token(token2, (v) => _TestMix(v));
      final prop5 = MixProp(_TestMix(50));
      
      final merged = prop1.merge(prop2).merge(prop3).merge(prop4).merge(prop5);
      
      final context = MockBuildContext(
        mixScopeData: MixScopeData.static(
          tokens: {
            token1: 20,
            token2: 40,
          },
        ),
      );
      
      final result = merged.resolve(context);
      expect(result, equals(150)); // 10 + 20 + 30 + 40 + 50
    });
    
    test('error propagation', () {
      final token = MixToken<Color>('missing');
      final prop = Prop.token(token);
      final context = MockBuildContext();
      
      expect(
        () => prop.resolve(context),
        throwsA(isA<FlutterError>()),
      );
    });
    
    test('directive error handling', () {
      final errorDirective = _TestDirective<int>((value) {
        throw Exception('Directive error');
      });
      
      final prop = Prop(42, directives: [errorDirective]);
      final context = MockBuildContext();
      
      expect(
        () => prop.resolve(context),
        throwsException,
      );
    });
  });
}