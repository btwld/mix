import 'package:flutter/widgets.dart';

import 'mix_token.dart';

abstract class TokenRef<T extends Object> {
  final MixToken<T> token;
  const TokenRef(this.token);
  @override
  Never noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      'This is a Token reference for $T, so it does not implement ${invocation.memberName}.',
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokenRef && other.token == token;
  }

  @override
  int get hashCode => token.hashCode;
}

final class ColorRef extends TokenRef<Color> implements Color {
  const ColorRef(super.token);
}
