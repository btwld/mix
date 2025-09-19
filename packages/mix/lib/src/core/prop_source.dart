import 'package:flutter/foundation.dart';

import '../theme/tokens/mix_token.dart';
import 'internal/compare_mixin.dart';
import 'mix_element.dart';

/// Represents the origin of a property value.
///
/// A [PropSource] is a sealed class with three concrete implementations:
/// - [ValueSource]: Holds a direct value
/// - [TokenSource]: References a token to be resolved from context
/// - [MixSource]: Contains a Mix value for accumulation merging
@immutable
sealed class PropSource<V> {
  const PropSource();
}

/// A source that holds a direct value.
///
/// Created when a property is initialized with a concrete value
/// that doesn't require context resolution or conversion.
@immutable
class ValueSource<V> extends PropSource<V> with Equatable {
  final V value;

  const ValueSource(this.value);

  @override
  String toString() => 'ValueSource($value)';

  @override
  List<Object?> get props => [value];
}

/// A source that references a token.
///
/// The token will be resolved from [MixScope] during property resolution,
/// allowing theme-aware and context-dependent values.
@immutable
class TokenSource<V> extends PropSource<V> with Equatable {
  final MixToken<V> token;

  const TokenSource(this.token);

  @override
  String toString() => 'TokenSource($token)';

  @override
  List<Object?> get props => [token];
}

/// A source that contains a [Mix] value.
///
/// Mix values support accumulation merging, where multiple Mix values
/// are combined rather than replaced during merge operations.
@immutable
class MixSource<V> extends PropSource<V> with Equatable {
  final Mix<V> mix;

  const MixSource(this.mix);

  @override
  String toString() => 'MixSource($mix)';

  @override
  List<Object?> get props => [mix];
}
