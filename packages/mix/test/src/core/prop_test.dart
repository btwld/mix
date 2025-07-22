import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Prop Construction', () {
    test('creates ValueSource for regular values', () {
      final prop = Prop<int>(42);

      expect(prop.source, isA<ValueSource<int>>());
      expect((prop.source as ValueSource<int>).value, equals(42));
    });

    test('creates ValueSource for Mix values', () {
      final mixValue = MockMix<String>('mix1', 'value1');
      final prop = Prop<MockMix<String>>(mixValue);

      expect(prop.source, isA<ValueSource<MockMix<String>>>());
      expect(
        (prop.source as ValueSource<MockMix<String>>).value,
        equals(mixValue),
      );
    });

    test('creates TokenSource for tokens', () {
      final token = MixToken<Color>('primary.color');
      final prop = Prop<Color>.token(token);

      expect(prop.source, isA<TokenSource<Color>>());
      expect((prop.source as TokenSource<Color>).token, equals(token));
    });

    test('creates Prop with directives only', () {
      final directive = MockMixDirective<int>('double', (v) => v * 2);
      final prop = Prop<int>.directives([directive]);

      expect(prop.source, isNull);
      expect(prop.directives, equals([directive]));
    });

    test('creates Prop with animation only', () {
      final animation = AnimationConfig.easeIn(200.ms);
      final prop = Prop<Color>.animation(animation);

      expect(prop.source, isNull);
      expect(prop.animation, equals(animation));
    });

    test('maybe factory returns null for null value', () {
      final prop = Prop.maybe(null);
      expect(prop, isNull);
    });

    test('maybe factory returns Prop for non-null value', () {
      final prop = Prop.maybe(42);
      expect(prop, isNotNull);
      expect((prop!.source as ValueSource<int>).value, equals(42));
    });
  });

  group('Prop Merge - Regular Types', () {
    test('ValueSource + ValueSource creates AccumulativePropSource', () {
      final prop1 = Prop<int>(10);
      final prop2 = Prop<int>(20);
      final merged = prop1.merge(prop2);

      expect(merged.source, isA<AccumulativePropSource<int>>());
      final accumulative = merged.source as AccumulativePropSource<int>;
      expect(accumulative.sources.length, equals(2));
      expect(accumulative.sources[0], isA<ValueSource<int>>());
      expect(accumulative.sources[1], isA<ValueSource<int>>());
    });

    test('TokenSource + TokenSource creates AccumulativePropSource', () {
      final token1 = MixToken<Color>('primary');
      final token2 = MixToken<Color>('secondary');
      final prop1 = Prop<Color>.token(token1);
      final prop2 = Prop<Color>.token(token2);
      final merged = prop1.merge(prop2);

      expect(merged.source, isA<AccumulativePropSource<Color>>());
      final accumulative = merged.source as AccumulativePropSource<Color>;
      expect(accumulative.sources.length, equals(2));
      expect(
        (accumulative.sources[0] as TokenSource<Color>).token,
        equals(token1),
      );
      expect(
        (accumulative.sources[1] as TokenSource<Color>).token,
        equals(token2),
      );
    });

    test('ValueSource + TokenSource creates AccumulativePropSource', () {
      final prop1 = Prop<Color>(Color(0xFF0000FF));
      final prop2 = Prop<Color>.token(MixToken<Color>('primary'));
      final merged = prop1.merge(prop2);

      expect(merged.source, isA<AccumulativePropSource<Color>>());
      final accumulative = merged.source as AccumulativePropSource<Color>;
      expect(accumulative.sources.length, equals(2));
      expect(accumulative.sources[0], isA<ValueSource<Color>>());
      expect(accumulative.sources[1], isA<TokenSource<Color>>());
    });
  });

  group('Prop Merge - Mix Types', () {
    test('Mix values merge into AccumulativePropSource', () {
      final mix1 = MockMix<String>('mix1', 'value1');
      final mix2 = MockMix<String>('mix2', 'value2');
      final prop1 = Prop<MockMix<String>>(mix1);
      final prop2 = Prop<MockMix<String>>(mix2);
      final merged = prop1.merge(prop2);

      expect(merged.source, isA<AccumulativePropSource<MockMix<String>>>());
      final accumulative =
          merged.source as AccumulativePropSource<MockMix<String>>;
      expect(accumulative.sources.length, equals(2));
      expect(accumulative.sources[0], isA<ValueSource<MockMix<String>>>());
      expect(accumulative.sources[1], isA<ValueSource<MockMix<String>>>());
    });

    test('Mix token + Mix value creates AccumulativePropSource', () {
      final mixValue = MockMix<String>('mix1', 'value1');
      final mixToken = MixToken<MockMix<String>>('theme.mix');
      final prop1 = Prop<MockMix<String>>(mixValue);
      final prop2 = Prop<MockMix<String>>.token(mixToken);
      final merged = prop1.merge(prop2);

      expect(merged.source, isA<AccumulativePropSource<MockMix<String>>>());
      final accumulative =
          merged.source as AccumulativePropSource<MockMix<String>>;
      expect(accumulative.sources.length, equals(2));
      expect(accumulative.sources[0], isA<ValueSource<MockMix<String>>>());
      expect(accumulative.sources[1], isA<TokenSource<MockMix<String>>>());
    });

    test('Mix values merge correctly when one is already merged', () {
      final mix1 = MockMix<String>('A', 'value1');
      final mix2 = MockMix<String>('B', 'value2');
      final mix3 = MockMix<String>('C', 'value3');

      final prop1 = Prop<MockMix<String>>(mix1);
      final prop2 = Prop<MockMix<String>>(mix2);
      final prop3 = Prop<MockMix<String>>(mix3);

      final merged12 = prop1.merge(prop2);
      final merged123 = merged12.merge(prop3);

      expect(merged123.source, isA<AccumulativePropSource<MockMix<String>>>());
      final accumulative =
          merged123.source as AccumulativePropSource<MockMix<String>>;
      expect(accumulative.sources.length, equals(3));
    });

    test('special Mix merge behavior in _mergePropSource', () {
      final mix1 = MockMix<String>('A', 'value1');
      final mix2 = MockMix<String>('B', 'value2');

      final prop1 = Prop<MockMix<String>>(mix1);
      final prop2 = Prop<MockMix<String>>(mix2);
      final merged = prop1.merge(prop2);

      // When both sources are ValueSource with Mix values,
      // they should be merged directly in the source
      expect(merged.source, isA<ValueSource<MockMix<String>>>());
      final valueSource = merged.source as ValueSource<MockMix<String>>;
      expect(valueSource.value.id, equals('A+B'));
    });
  });

  group('Prop Merge - Directives and Animation', () {
    test('merges directives from both props', () {
      final directive1 = MockMixDirective<int>('add10', (v) => v + 10);
      final directive2 = MockMixDirective<int>('double', (v) => v * 2);

      final prop1 = Prop<int>(5).merge(Prop.directives([directive1]));
      final prop2 = Prop<int>(10).merge(Prop.directives([directive2]));
      final merged = prop1.merge(prop2);

      expect(merged.directives, equals([directive1, directive2]));
    });

    test('animation from other prop wins in merge', () {
      final animation1 = createMockAnimation('fadeIn');
      final animation2 = createMockAnimation('slideIn');

      final prop1 = Prop<Color>(
        Color(0xFF0000FF),
      ).merge(Prop.animation(animation1));
      final prop2 = Prop<Color>(
        Color(0xFFFF0000),
      ).merge(Prop.animation(animation2));
      final merged = prop1.merge(prop2);

      expect(merged.animation, equals(animation2));
    });

    test('preserves animation when other has none', () {
      final animation = createMockAnimation('fadeIn');
      final prop1 = Prop<Color>(
        Color(0xFF0000FF),
      ).merge(Prop.animation(animation));
      final prop2 = Prop<Color>(Color(0xFFFF0000));
      final merged = prop1.merge(prop2);

      expect(merged.animation, equals(animation));
    });
  });

  group('Prop Resolution - Regular Types', () {
    testWidgets('resolves single ValueSource', (tester) async {
      final prop = Prop<int>(42);

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = prop.resolve(context);
            expect(resolved, equals(42));
            return Container();
          },
        ),
      );
    });

    testWidgets('resolves with replacement strategy for non-Mix types', (
      tester,
    ) async {
      final prop1 = Prop<int>(10);
      final prop2 = Prop<int>(20);
      final prop3 = Prop<int>(30);
      final merged = prop1.merge(prop2).merge(prop3);

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = merged.resolve(context);
            expect(resolved, equals(30)); // Last value wins
            return Container();
          },
        ),
      );
    });

    testWidgets('resolves TokenSource with context', (tester) async {
      final token = MixToken<Color>('primary.color');
      final prop = Prop<Color>.token(token);

      await tester.pumpWidget(
        MockMixScope(
          tokens: {token: Color(0xFF0000FF)},
          child: Builder(
            builder: (context) {
              final resolved = prop.resolve(context);
              expect(resolved, equals(Color(0xFF0000FF)));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('throws when token not found in context', (tester) async {
      final token = MixToken<Color>('missing.color');
      final prop = Prop<Color>.token(token);

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(
              () => prop.resolve(context),
              throwsA(
                isA<FlutterError>().having(
                  (e) => e.message,
                  'message',
                  contains('Could not resolve token'),
                ),
              ),
            );
            return Container();
          },
        ),
      );
    });
  });

  group('Prop Resolution - Mix Types', () {
    testWidgets('resolves with accumulation strategy for Mix types', (
      tester,
    ) async {
      final mix1 = MockMix<String>('A', 'value');
      final mix2 = MockMix<String>('B', 'value');
      final mix3 = MockMix<String>('C', 'value');

      final prop1 = Prop<MockMix<String>>(mix1);
      final prop2 = Prop<MockMix<String>>(mix2);
      final prop3 = Prop<MockMix<String>>(mix3);
      final merged = prop1.merge(prop2).merge(prop3);

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = merged.resolve(context);
            expect(resolved.id, equals('A+B+C')); // Accumulated
            return Container();
          },
        ),
      );
    });

    testWidgets('resolves Mix tokens with accumulation', (tester) async {
      final mix1 = MockMix<String>('A', 'value1');
      final mix2 = MockMix<String>('B', 'value2');
      final token1 = MixToken<MockMix<String>>('mix1');
      final token2 = MixToken<MockMix<String>>('mix2');

      final prop1 = Prop<MockMix<String>>.token(token1);
      final prop2 = Prop<MockMix<String>>.token(token2);
      final merged = prop1.merge(prop2);

      await tester.pumpWidget(
        MockMixScope(
          tokens: {token1: mix1, token2: mix2},
          child: Builder(
            builder: (context) {
              final resolved = merged.resolve(context);
              expect(resolved.id, equals('A+B'));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('resolves single Mix value correctly', (tester) async {
      final mix = MockMix<String>('single', 'value');
      final prop = Prop<MockMix<String>>(mix);

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = prop.resolve(context);
            expect(resolved.id, equals('single'));
            expect(resolved.value, equals('value'));
            return Container();
          },
        ),
      );
    });

    testWidgets('resolves Mix value + token correctly', (tester) async {
      final mixValue = MockMix<String>('value', 'data');
      final mixToken = MockMix<String>('token', 'data');
      final token = MixToken<MockMix<String>>('test.mix');

      final prop1 = Prop<MockMix<String>>(mixValue);
      final prop2 = Prop<MockMix<String>>.token(token);
      final merged = prop1.merge(prop2);

      await tester.pumpWidget(
        MockMixScope(
          tokens: {token: mixToken},
          child: Builder(
            builder: (context) {
              final resolved = merged.resolve(context);
              expect(resolved.id, equals('value+token'));
              return Container();
            },
          ),
        ),
      );
    });
  });

  group('Prop Resolution - Directives', () {
    testWidgets('applies single directive', (tester) async {
      final directive = MockMixDirective<int>('double', (v) => v * 2);
      final prop = Prop<int>(10).merge(Prop.directives([directive]));

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = prop.resolve(context);
            expect(resolved, equals(20));
            return Container();
          },
        ),
      );
    });

    testWidgets('applies multiple directives in order', (tester) async {
      final directive1 = MockMixDirective<int>('add5', (v) => v + 5);
      final directive2 = MockMixDirective<int>('double', (v) => v * 2);
      final directive3 = MockMixDirective<int>('subtract3', (v) => v - 3);

      final prop = Prop<int>(
        10,
      ).merge(Prop.directives([directive1, directive2, directive3]));

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = prop.resolve(context);
            // 10 + 5 = 15, 15 * 2 = 30, 30 - 3 = 27
            expect(resolved, equals(27));
            return Container();
          },
        ),
      );
    });

    testWidgets('applies directives after resolution', (tester) async {
      final token = MixToken<int>('value');
      final directive = MockMixDirective<int>('triple', (v) => v * 3);

      final prop = Prop<int>.token(token).merge(Prop.directives([directive]));

      await tester.pumpWidget(
        MockMixScope(
          tokens: {token: 7},
          child: Builder(
            builder: (context) {
              final resolved = prop.resolve(context);
              expect(resolved, equals(21)); // 7 * 3
              return Container();
            },
          ),
        ),
      );
    });
  });

  group('Prop getValue and getToken Methods', () {
    test('getValue returns value from ValueSource', () {
      final prop = Prop<int>(42);
      expect(prop.getValue(), equals(42));
    });

    test('getValue throws when no source exists', () {
      final prop = Prop<int>.directives(const []);
      expect(
        () => prop.getValue(),
        throwsA(
          isA<FlutterError>().having(
            (e) => e.message,
            'message',
            contains('No source exists to resolve'),
          ),
        ),
      );
    });

    test('getValue throws for TokenSource', () {
      final token = MixToken<int>('test.value');
      final prop = Prop<int>.token(token);
      expect(
        () => prop.getValue(),
        throwsA(
          isA<FlutterError>().having(
            (e) => e.message,
            'message',
            contains('No valid source found'),
          ),
        ),
      );
    });

    test('getToken returns token from TokenSource', () {
      final token = MixToken<Color>('primary.color');
      final prop = Prop<Color>.token(token);
      expect(prop.getToken(), equals(token));
    });

    test('getToken throws when no source exists', () {
      final prop = Prop<Color>.directives(const []);
      expect(
        () => prop.getToken(),
        throwsA(
          isA<FlutterError>().having(
            (e) => e.message,
            'message',
            contains('No source exists to resolve'),
          ),
        ),
      );
    });

    test('getToken throws for ValueSource', () {
      final prop = Prop<Color>(Colors.red);
      expect(
        () => prop.getToken(),
        throwsA(
          isA<FlutterError>().having(
            (e) => e.message,
            'message',
            contains('is not a token source'),
          ),
        ),
      );
    });
  });

  group('Prop Error Cases', () {
    testWidgets('throws when resolving without source', (tester) async {
      final prop = Prop<int>.directives(const []);

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(
              () => prop.resolve(context),
              throwsA(
                isA<FlutterError>().having(
                  (e) => e.message,
                  'message',
                  contains('No source exists to resolve'),
                ),
              ),
            );
            return Container();
          },
        ),
      );
    });

    test('AccumulativePropSource throws with empty sources', () {
      final accumulative = AccumulativePropSource<int>(const []);

      expect(
        () => accumulative.resolve(FakeBuildContext()),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('no sources to resolve'),
          ),
        ),
      );
    });
  });

  group('AccumulativePropSource Behavior', () {
    test('flattens nested AccumulativePropSource during construction', () {
      final source1 = ValueSource<int>(1);
      final source2 = ValueSource<int>(2);
      final source3 = ValueSource<int>(3);

      final nested = AccumulativePropSource<int>([source1, source2]);
      final flattened = AccumulativePropSource<int>([nested, source3]);

      expect(flattened.sources.length, equals(3));
      expect(flattened.sources[0], equals(source1));
      expect(flattened.sources[1], equals(source2));
      expect(flattened.sources[2], equals(source3));
    });

    test('merge combines sources correctly', () {
      final source1 = ValueSource<int>(1);
      final source2 = ValueSource<int>(2);
      final source3 = ValueSource<int>(3);
      final source4 = ValueSource<int>(4);

      final acc1 = AccumulativePropSource<int>([source1, source2]);
      final acc2 = AccumulativePropSource<int>([source3, source4]);
      final merged = acc1.merge(acc2);

      expect(merged.sources.length, equals(4));
      expect(merged.sources, equals([source1, source2, source3, source4]));
    });

    testWidgets('resolves single source directly', (tester) async {
      final source = ValueSource<int>(42);
      final accumulative = AccumulativePropSource<int>([source]);

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = accumulative.resolve(context);
            expect(resolved, equals(42));
            return Container();
          },
        ),
      );
    });

    testWidgets('resolves non-Mix types with replacement strategy', (
      tester,
    ) async {
      final source1 = ValueSource<int>(10);
      final source2 = ValueSource<int>(20);
      final source3 = ValueSource<int>(30);
      final accumulative = AccumulativePropSource<int>([
        source1,
        source2,
        source3,
      ]);

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = accumulative.resolve(context);
            expect(resolved, equals(30)); // Last value wins
            return Container();
          },
        ),
      );
    });

    testWidgets('resolves Mix types with accumulation strategy', (
      tester,
    ) async {
      final mix1 = MockMix<String>('A', 'value1');
      final mix2 = MockMix<String>('B', 'value2');
      final mix3 = MockMix<String>('C', 'value3');

      final source1 = ValueSource<MockMix<String>>(mix1);
      final source2 = ValueSource<MockMix<String>>(mix2);
      final source3 = ValueSource<MockMix<String>>(mix3);
      final accumulative = AccumulativePropSource<MockMix<String>>([
        source1,
        source2,
        source3,
      ]);

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = accumulative.resolve(context);
            expect(resolved.id, equals('A+B+C')); // Accumulated
            return Container();
          },
        ),
      );
    });

    testWidgets('resolves mixed ValueSource and TokenSource', (tester) async {
      final mix1 = MockMix<String>('A', 'value1');
      final mix2 = MockMix<String>('B', 'value2');
      final token = MixToken<MockMix<String>>('test.mix');

      final valueSource = ValueSource<MockMix<String>>(mix1);
      final tokenSource = TokenSource<MockMix<String>>(token);
      final accumulative = AccumulativePropSource<MockMix<String>>([
        valueSource,
        tokenSource,
      ]);

      await tester.pumpWidget(
        MockMixScope(
          tokens: {token: mix2},
          child: Builder(
            builder: (context) {
              final resolved = accumulative.resolve(context);
              expect(resolved.id, equals('A+B'));
              return Container();
            },
          ),
        ),
      );
    });
  });

  group('Prop Equality and HashCode', () {
    test('Props with same values are equal', () {
      final prop1 = Prop<int>(42);
      final prop2 = Prop<int>(42);

      expect(prop1, equals(prop2));
      expect(prop1.hashCode, equals(prop2.hashCode));
    });

    test('Props with different values are not equal', () {
      final prop1 = Prop<int>(42);
      final prop2 = Prop<int>(43);

      expect(prop1, isNot(equals(prop2)));
    });

    test('Props with same tokens are equal', () {
      final token = MixToken<Color>('primary');
      final prop1 = Prop<Color>.token(token);
      final prop2 = Prop<Color>.token(token);

      expect(prop1, equals(prop2));
      expect(prop1.hashCode, equals(prop2.hashCode));
    });

    test('Props with same directives are equal', () {
      final directive = MockMixDirective<int>('double', (v) => v * 2);
      final prop1 = Prop<int>(10).merge(Prop.directives([directive]));
      final prop2 = Prop<int>(10).merge(Prop.directives([directive]));

      expect(prop1, equals(prop2));
      expect(prop1.hashCode, equals(prop2.hashCode));
    });

    test('ValueSource equality', () {
      final source1 = ValueSource<int>(42);
      final source2 = ValueSource<int>(42);
      final source3 = ValueSource<int>(43);

      expect(source1, equals(source2));
      expect(source1.hashCode, equals(source2.hashCode));
      expect(source1, isNot(equals(source3)));
    });

    test('TokenSource equality', () {
      final token1 = MixToken<Color>('primary');
      final token2 = MixToken<Color>('primary');
      final token3 = MixToken<Color>('secondary');

      final source1 = TokenSource<Color>(token1);
      final source2 = TokenSource<Color>(token2);
      final source3 = TokenSource<Color>(token3);

      expect(source1, equals(source2));
      expect(source1.hashCode, equals(source2.hashCode));
      expect(source1, isNot(equals(source3)));
    });

    test('AccumulativePropSource equality', () {
      final value1 = ValueSource<int>(42);
      final value2 = ValueSource<int>(42);
      final token = TokenSource<int>(MixToken<int>('value'));

      final acc1 = AccumulativePropSource<int>([value1, token]);
      final acc2 = AccumulativePropSource<int>([value2, token]);
      final acc3 = AccumulativePropSource<int>([token, value1]);

      expect(acc1, equals(acc2));
      expect(acc1.hashCode, equals(acc2.hashCode));
      expect(acc1, isNot(equals(acc3))); // Order matters
    });
  });

  group('Prop toString', () {
    test('shows ValueSource', () {
      final prop = Prop<int>(42);
      expect(prop.toString(), contains('ValueSource(42)'));
    });

    test('shows TokenSource', () {
      final token = MixToken<Color>('primary');
      final prop = Prop<Color>.token(token);
      expect(prop.toString(), contains('TokenSource'));
    });

    test('shows AccumulativePropSource with count', () {
      final prop = Prop<int>(1).merge(Prop<int>(2)).merge(Prop<int>(3));
      expect(prop.toString(), contains('AccumulativePropSource(3 sources)'));
    });

    test('shows directives count', () {
      final prop = Prop<int>(42).merge(
        Prop.directives([
          MockMixDirective<int>('d1', (v) => v),
          MockMixDirective<int>('d2', (v) => v),
        ]),
      );
      expect(prop.toString(), contains('directives: 2'));
    });

    test('shows animated', () {
      final prop = Prop<int>(
        42,
      ).merge(Prop.animation(createMockAnimation('fade')));
      expect(prop.toString(), contains('animated'));
    });
  });
}
