import 'package:flutter/foundation.dart';

import '../theme/tokens/mix_token.dart';
import 'mix_element.dart';

/// Base class for MixProp value sources.
///
/// Defines the source of a MixProp value, which can be a direct Mixable value
/// or a token reference that needs conversion.
@immutable
sealed class MixSource<V> {
  const MixSource();
}

/// Source for direct Mix values.
///
/// Used when MixProp is created with a direct `Mix<V> `value.
@immutable
class MixValueSource<V> extends MixSource<V> {
  final Mix<V> value;

  const MixValueSource(this.value);

  @override
  String toString() => 'MixValueSource($value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixValueSource<V> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// Source for token references with converter.
///
/// Used when MixProp is created with a token that needs to be resolved
/// and converted to a `Mix<V>` value.
@immutable
class MixTokenSource<V> extends MixSource<V> {
  final MixToken<V> token;
  final Mix<V> Function(V) converter;

  const MixTokenSource(this.token, this.converter);

  @override
  String toString() => 'MixTokenSource($token)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixTokenSource<V> &&
        other.token == token &&
        other.converter == converter;
  }

  @override
  int get hashCode => Object.hash(token, converter);
}
