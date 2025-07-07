import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../material/material_theme.dart';
import '../tokens/mix_token.dart';
import '../tokens/value_resolver.dart';

class MixScope extends InheritedWidget {
  const MixScope({required this.data, super.key, required super.child});

  static MixScopeData of(BuildContext context) {
    final scopeData = context
        .dependOnInheritedWidgetOfExactType<MixScope>()
        ?.data;

    assert(scopeData != null, 'No MixScope found in context');

    return scopeData!;
  }

  static MixScopeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MixScope>()?.data;
  }

  final MixScopeData data;

  @override
  bool updateShouldNotify(MixScope oldWidget) => data != oldWidget.data;
}

// Deprecated typedefs moved to src/core/deprecated.dart

@immutable
class MixScopeData {
  final List<Type>? defaultOrderOfModifiers;
  final Map<MixableToken, ValueResolver>? _tokens;

  const MixScopeData.empty() : _tokens = null, defaultOrderOfModifiers = null;

  const MixScopeData._({
    required Map<MixableToken, ValueResolver>? tokens,
    required this.defaultOrderOfModifiers,
  }) : _tokens = tokens;

  factory MixScopeData({
    Map<MixableToken, ValueResolver>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    final resolverTokens = <MixableToken, ValueResolver>{};

    if (tokens != null) {
      for (final entry in tokens.entries) {
        resolverTokens[entry.key] = createResolver(entry.value);
      }
    }

    return MixScopeData._(
      tokens: resolverTokens.isEmpty ? null : resolverTokens,
      defaultOrderOfModifiers: defaultOrderOfModifiers,
    );
  }

  factory MixScopeData.withMaterial({
    Map<MixableToken, ValueResolver>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    return materialMixScope.merge(
      MixScopeData(
        tokens: tokens,
        defaultOrderOfModifiers: defaultOrderOfModifiers,
      ),
    );
  }

  /// Combine all [themes] into a single [MixScopeData] root.
  static MixScopeData combine(Iterable<MixScopeData> themes) {
    if (themes.isEmpty) return const MixScopeData.empty();

    return themes.fold(
      const MixScopeData.empty(),
      (previous, theme) => previous.merge(theme),
    );
  }

  static MixScopeData static({
    Map<MixableToken, Object>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    // Convert tokens to resolvers
    Map<MixableToken, ValueResolver>? resolverTokens;
    if (tokens != null) {
      resolverTokens = {};
      for (final entry in tokens.entries) {
        resolverTokens[entry.key] = createResolver(entry.value);
      }
    }

    return MixScopeData._(
      tokens: resolverTokens,
      defaultOrderOfModifiers: defaultOrderOfModifiers,
    );
  }

  /// Getter for tokens
  Map<MixableToken, ValueResolver>? get tokens => _tokens;

  /// Type-safe token resolution with error handling
  T getToken<T>(MixableToken<T> token, BuildContext context) {
    final resolver = _tokens?[token];
    if (resolver == null) {
      throw StateError('Token "${token.name}" not found in scope');
    }

    final resolved = resolver(context);
    if (resolved is T) {
      return resolved;
    }

    throw StateError(
      'Token "${token.name}" resolved to ${resolved.runtimeType}, expected $T',
    );
  }

  MixScopeData copyWith({
    Map<MixableToken, dynamic>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    // If tokens are provided, convert them to resolvers
    Map<MixableToken, ValueResolver>? resolverTokens;
    if (tokens != null) {
      resolverTokens = {};
      for (final entry in tokens.entries) {
        resolverTokens[entry.key] = createResolver(entry.value);
      }
    }

    return MixScopeData._(
      tokens: resolverTokens ?? _tokens,
      defaultOrderOfModifiers:
          defaultOrderOfModifiers ?? this.defaultOrderOfModifiers,
    );
  }

  MixScopeData merge(MixScopeData other) {
    final mergedTokens = _tokens != null || other._tokens != null
        ? <MixableToken, ValueResolver>{...?_tokens, ...?other._tokens}
        : null;

    return MixScopeData._(
      tokens: mergedTokens,
      defaultOrderOfModifiers:
          other.defaultOrderOfModifiers ?? defaultOrderOfModifiers,
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixScopeData &&
        mapEquals(other._tokens, _tokens) &&
        listEquals(other.defaultOrderOfModifiers, defaultOrderOfModifiers);
  }

  @override
  int get hashCode {
    return _tokens.hashCode ^ defaultOrderOfModifiers.hashCode;
  }
}
