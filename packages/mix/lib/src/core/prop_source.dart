import 'package:flutter/foundation.dart';

import '../theme/tokens/mix_token.dart';
import 'mix_element.dart';

/// Represents the origin of a property value.
///
/// A [PropSource] is a sealed class with four concrete implementations:
/// - [ValueSource]: Holds a direct value
/// - [TokenSource]: References a token to be resolved from context
/// - [MixSource]: Contains a Mix value for accumulation merging
/// - [MixTokenSource]: References a token with a converter function
@immutable
sealed class PropSource<V> {
  const PropSource();
}

/// A source that holds a direct value.
///
/// Created when a property is initialized with a concrete value
/// that doesn't require context resolution or conversion.
@immutable
class ValueSource<V> extends PropSource<V> {
  final V value;
  
  const ValueSource(this.value);
  
  @override
  String toString() => 'ValueSource($value)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ValueSource<V> && other.value == value;
  }
  
  @override
  int get hashCode => value.hashCode;
}

/// A source that references a token.
///
/// The token will be resolved from [MixScope] during property resolution,
/// allowing theme-aware and context-dependent values.
@immutable
class TokenSource<V> extends PropSource<V> {
  final MixToken<V> token;
  
  const TokenSource(this.token);
  
  @override
  String toString() => 'TokenSource($token)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is TokenSource<V> && other.token == token;
  }
  
  @override
  int get hashCode => token.hashCode;
}

/// A source that contains a [Mix] value.
///
/// Mix values support accumulation merging, where multiple Mix values
/// are combined rather than replaced during merge operations.
@immutable
class MixSource<V> extends PropSource<V> {
  final Mix<V> mix;
  
  const MixSource(this.mix);
  
  @override
  String toString() => 'MixSource($mix)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is MixSource<V> && other.mix == mix;
  }
  
  @override
  int get hashCode => mix.hashCode;
}

/// A source that references a token with a converter function.
///
/// The token is resolved from context and then transformed using
/// the [converter] function. This maintains backward compatibility
/// with the legacy [MixProp.token] constructor.
@immutable
class MixTokenSource<V> extends PropSource<V> {
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

// Type aliases

/// Alias maintained for backward compatibility.
@Deprecated('Use MixSource instead. MixValueSource has been renamed.')
typedef MixValueSource<V> = MixSource<V>;