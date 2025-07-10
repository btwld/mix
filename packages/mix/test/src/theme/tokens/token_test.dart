import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('MixToken<T>', () {
    test('creates token with correct name and type', () {
      const colorToken = MixableToken<Color>('primary');
      const spaceToken = MixableToken<double>('large');
      const textToken = MixableToken<TextStyle>('heading');

      expect(colorToken.name, 'primary');
      expect(spaceToken.name, 'large');
      expect(textToken.name, 'heading');

      expect(colorToken.toString(), 'MixableToken<Color>(primary)');
      expect(spaceToken.toString(), 'MixableToken<double>(large)');
      expect(textToken.toString(), 'MixableToken<TextStyle>(heading)');
    });

    test('equality works correctly', () {
      const token1 = MixableToken<Color>('primary');
      const token2 = MixableToken<Color>('primary');
      const token3 = MixableToken<Color>('secondary');
      const token4 = MixableToken<double>('primary'); // Different type

      expect(token1, equals(token2));
      expect(token1, isNot(equals(token3)));
      expect(token1, isNot(equals(token4)));
      expect(token1 == token2, isTrue);
      expect(identical(token1, token2), isTrue); // const constructors
    });

    test('hashCode is consistent', () {
      const token1 = MixableToken<Color>('primary');
      const token2 = MixableToken<Color>('primary');

      expect(token1.hashCode, equals(token2.hashCode));

      // Different types should have different hashCodes
      const token3 = MixableToken<double>('primary');
      expect(token1.hashCode, isNot(equals(token3.hashCode)));
    });

    test('token is simple data container (no call method)', () {
      const colorToken = MixableToken<Color>('primary');
      const spaceToken = MixableToken<double>('large');

      expect(colorToken.name, 'primary');
      expect(spaceToken.name, 'large');
      expect(colorToken.runtimeType.toString(), 'MixableToken<Color>');
      expect(spaceToken.runtimeType.toString(), 'MixableToken<double>');
    });

    testWidgets('resolve() works with theme storage', (tester) async {
      const token = MixableToken<Color>('primary');
      final theme = MixScopeData.static(tokens: {token: Colors.blue});

      await tester.pumpWidget(MixScope(data: theme, child: Container()));

      final context = tester.element(find.byType(Container));
      final mixData = MixContext.create(context, Style());

      // Use Mixable<Color> to resolve the token
      const colorDto = Prop<Color>.token(token);
      final resolved = colorDto.resolve(mixData);

      expect(resolved, equals(Colors.blue));
    });

    testWidgets('resolve() throws for undefined tokens', (tester) async {
      const token = MixableToken<Color>('undefined');
      const theme = MixScopeData.empty();

      await tester.pumpWidget(createWithMixScope(theme));
      final context = tester.element(find.byType(Container));

      expect(() {
        final mixData = MixContext.create(context, Style());
        const colorDto = Prop<Color>.token(token);
        return colorDto.resolve(mixData);
      }, throwsStateError);
    });

    testWidgets('resolver works with any type', (tester) async {
      const token = MixableToken<String>('message');
      final theme = MixScopeData.static(tokens: {token: 'Hello World'});

      await tester.pumpWidget(createWithMixScope(theme));
      final context = tester.element(find.byType(Container));

      final mixData = MixContext.create(context, Style());

      // Create a custom Mixable to resolve string tokens
      const stringMixable = _StringMixable(token: token);
      final resolved = stringMixable.resolve(mixData);

      expect(resolved, equals('Hello World'));
    });
  });
}

// Helper class for testing string token resolution
class _StringMixable extends Mix<String> {
  final MixableToken<String> token;

  const _StringMixable({required this.token});

  @override
  String resolve(MixContext mix) {
    return mix.scope.getToken(token, mix.context);
  }

  @override
  _StringMixable merge(_StringMixable? other) {
    return other ?? this;
  }

  @override
  List<Object?> get props => [token];
}
