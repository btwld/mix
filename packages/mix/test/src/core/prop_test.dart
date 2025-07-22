import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Test helpers and mock classes
class TestMix<T> extends Mix<T> {
  final String id;
  final T value;

  TestMix(this.id, this.value);

  @override
  T resolve(BuildContext context) => value;

  @override
  Mix<T> merge(Mix<T> other) {
    if (other is TestMix<T>) {
      // Concatenate IDs to track merge order
      return TestMix<T>('$id+${other.id}', value);
    }
    return this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestMix<T> && other.id == id && other.value == value;

  @override
  int get hashCode => Object.hash(id, value);
}

class TestDirective<T> extends MixDirective<T> {
  final String name;
  final T Function(T) transform;

  const TestDirective(this.name, this.transform);

  @override
  String get key => name;

  @override
  T apply(T value) => transform(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TestDirective<T> && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

// Mock MixScope for token resolution
class TestMixScope extends StatelessWidget {
  final Map<MixToken, dynamic Function(BuildContext)> tokens;
  final Widget child;

  const TestMixScope({required this.tokens, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return MixScope(
      data: MixScopeData(tokens: tokens),
      child: child,
    );
  }
}

void main() {
  group('Prop Construction', () {
    test('creates ValueSource for regular values', () {
      final prop = Prop<int>(42);

      expect(prop.source, isA<ValueSource<int>>());
      expect((prop.source as ValueSource<int>).value, equals(42));
    });

    test('creates AccumulativePropSource for Mix values', () {
      final mixValue = TestMix<String>('mix1', 'value1');
      final prop = Prop<TestMix<String>>(mixValue);

      expect(prop.source, isA<AccumulativePropSource<TestMix<String>>>());
      final accumulative =
          prop.source as AccumulativePropSource<TestMix<String>>;
      expect(accumulative.sources.length, equals(1));
      expect(accumulative.sources.first, isA<ValueSource<TestMix<String>>>());
    });

    test('creates TokenSource for tokens', () {
      final token = MixToken<Color>('primary.color');
      final prop = Prop<Color>.token(token);

      expect(prop.source, isA<TokenSource<Color>>());
      expect((prop.source as TokenSource<Color>).token, equals(token));
    });

    test('creates Prop with directives only', () {
      final directive = TestDirective<int>('double', (v) => v * 2);
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
      expect((prop.source as ValueSource<int>).value, equals(42));
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
    test('Mix values merge into single AccumulativePropSource', () {
      final mix1 = TestMix<String>('mix1', 'value1');
      final mix2 = TestMix<String>('mix2', 'value2');
      final prop1 = Prop<TestMix<String>>(mix1);
      final prop2 = Prop<TestMix<String>>(mix2);
      final merged = prop1.merge(prop2);

      expect(merged.source, isA<AccumulativePropSource<TestMix<String>>>());
      final accumulative =
          merged.source as AccumulativePropSource<TestMix<String>>;
      // Should have 2 ValueSource items from the two AccumulativePropSource merging
      expect(accumulative.sources.length, equals(2));
    });

    test('Mix token + Mix value creates AccumulativePropSource', () {
      final mixValue = TestMix<String>('mix1', 'value1');
      final mixToken = MixToken<TestMix<String>>('theme.mix');
      final prop1 = Prop<TestMix<String>>(mixValue);
      final prop2 = Prop<TestMix<String>>.token(mixToken);
      final merged = prop1.merge(prop2);

      expect(merged.source, isA<AccumulativePropSource<TestMix<String>>>());
      final accumulative =
          merged.source as AccumulativePropSource<TestMix<String>>;
      expect(accumulative.sources.length, equals(2));
      expect(accumulative.sources[0], isA<ValueSource<TestMix<String>>>());
      expect(accumulative.sources[1], isA<TokenSource<TestMix<String>>>());
    });
  });

  group('Prop Merge - Directives and Animation', () {
    test('merges directives from both props', () {
      final directive1 = TestDirective<int>('add10', (v) => v + 10);
      final directive2 = TestDirective<int>('double', (v) => v * 2);

      final prop1 = Prop<int>(5).merge(Prop.directives([directive1]));
      final prop2 = Prop<int>(10).merge(Prop.directives([directive2]));
      final merged = prop1.merge(prop2);

      expect(merged.directives, equals([directive1, directive2]));
    });

    test('animation from other prop wins in merge', () {
      final animation1 = TestAnimationConfig('fadeIn');
      final animation2 = TestAnimationConfig('slideIn');

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
      final animation = TestAnimationConfig('fadeIn');
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
        TestMixScope(
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
      final mix1 = TestMix<String>('A', 'value');
      final mix2 = TestMix<String>('B', 'value');
      final mix3 = TestMix<String>('C', 'value');

      final prop1 = Prop<TestMix<String>>(mix1);
      final prop2 = Prop<TestMix<String>>(mix2);
      final prop3 = Prop<TestMix<String>>(mix3);
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
      final mix1 = TestMix<String>('A', 'value1');
      final mix2 = TestMix<String>('B', 'value2');
      final token1 = MixToken<TestMix<String>>('mix1');
      final token2 = MixToken<TestMix<String>>('mix2');

      final prop1 = Prop<TestMix<String>>.token(token1);
      final prop2 = Prop<TestMix<String>>.token(token2);
      final merged = prop1.merge(prop2);

      await tester.pumpWidget(
        TestMixScope(
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
  });

  group('Prop Resolution - Directives', () {
    testWidgets('applies single directive', (tester) async {
      final directive = TestDirective<int>('double', (v) => v * 2);
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
      final directive1 = TestDirective<int>('add5', (v) => v + 5);
      final directive2 = TestDirective<int>('double', (v) => v * 2);
      final directive3 = TestDirective<int>('subtract3', (v) => v - 3);

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
      final directive = TestDirective<int>('triple', (v) => v * 3);

      final prop = Prop<int>.token(token).merge(Prop.directives([directive]));

      await tester.pumpWidget(
        TestMixScope(
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
        () => accumulative.resolve(FakeContext()),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('no sources to resolve'),
          ),
        ),
      );
    });

    testWidgets('throws on mixed Mix and non-Mix values', (tester) async {
      // This is a contrived example - in practice, this shouldn't happen
      // because the type system prevents it, but we test the runtime check
      final accumulative = AccumulativePropSource<dynamic>([
        ValueSource(TestMix<String>('A', 'value')),
        ValueSource('not a mix'),
      ]);

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(
              () => accumulative.resolve(context),
              throwsA(
                isA<StateError>().having(
                  (e) => e.message,
                  'message',
                  contains('mixed Mix and non-Mix values'),
                ),
              ),
            );
            return Container();
          },
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
      final directive = TestDirective<int>('double', (v) => v * 2);
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
          TestDirective<int>('d1', (v) => v),
          TestDirective<int>('d2', (v) => v),
        ]),
      );
      expect(prop.toString(), contains('directives: 2'));
    });

    test('shows animated', () {
      final prop = Prop<int>(
        42,
      ).merge(Prop.animation(TestAnimationConfig('fade')));
      expect(prop.toString(), contains('animated'));
    });
  });
}

// Helper fake context for testing
class FakeContext extends BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
