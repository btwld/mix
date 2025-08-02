import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'material/material_theme.dart';
import 'tokens/mix_token.dart';
import 'tokens/value_resolver.dart';

/// Inherited widget that provides Mix theme data and token resolution to its descendants.
///
/// The [MixScope] is the root of the Mix theming system, providing access to design tokens,
/// default modifier ordering, and other theme-related configuration.
class MixScope extends InheritedWidget {
  const MixScope({required this.data, super.key, required super.child});

  static MixScopeData of(BuildContext context) {
    final MixScopeData? scopeData = maybeOf(context);
    if (scopeData != null) {
      return scopeData;
    }
    throw FlutterError.fromParts([
      ErrorSummary('No MixScope found.'),
      ErrorDescription(
        '${context.widget.runtimeType} tried to access Mix theme data, but no MixScope widget was found in the widget tree.',
      ),
      context.describeElement('The context used was'),
      ...context.describeMissingAncestor(expectedAncestorType: MixScope),
      ErrorHint(
        'To fix this, ensure that a MixScope widget is present above ${context.widget.runtimeType} in the widget tree. '
        'This is typically done by wrapping your app with MixScope:\n'
        '  MixScope(\n'
        '    data: MixScopeData.withMaterial(), // or your custom theme\n'
        '    child: MaterialApp(...),\n'
        '  )',
      ),
    ]);
  }

  static T tokenOf<T>(MixToken<T> token, BuildContext context) {
    final scope = MixScope.of(context);

    return scope.getToken(token, context);
  }

  static MixScopeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MixScope>()?.data;
  }

  final MixScopeData data;

  @override
  bool updateShouldNotify(MixScope oldWidget) => data != oldWidget.data;
}

// Deprecated typedefs moved to src/core/deprecated.dart

/// Data container for Mix theme configuration.
///
/// Contains design tokens, default modifier ordering, and other theme-related settings
/// that are provided throughout the widget tree via [MixScope].
@immutable
class MixScopeData {
  final List<Type>? defaultOrderOfModifiers;
  final Map<MixToken, ValueResolver>? _tokens;

  const MixScopeData.empty() : _tokens = null, defaultOrderOfModifiers = null;

  const MixScopeData._({
    required Map<MixToken, ValueResolver>? tokens,
    required this.defaultOrderOfModifiers,
  }) : _tokens = tokens;

  factory MixScopeData({
    Map<MixToken, ValueResolver>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    return MixScopeData._(
      tokens: tokens,
      defaultOrderOfModifiers: defaultOrderOfModifiers,
    );
  }

  factory MixScopeData.withMaterial({
    Map<MixToken, ValueResolver>? tokens,
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
    Map<MixToken, Object>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    // Convert tokens to resolvers
    Map<MixToken, ValueResolver>? resolverTokens;
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

  /// Creates a MixScopeData with pre-defined resolvers.
  /// Unlike the regular constructor, this doesn't wrap the resolvers again.
  static MixScopeData fromResolvers({
    Map<MixToken, ValueResolver>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    return MixScopeData._(
      tokens: tokens,
      defaultOrderOfModifiers: defaultOrderOfModifiers,
    );
  }

  /// Getter for tokens
  Map<MixToken, ValueResolver>? get tokens => _tokens;

  /// Type-safe token resolution with error handling
  T getToken<T>(MixToken<T> token, BuildContext context) {
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
    Map<MixToken, dynamic>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    // If tokens are provided, convert them to resolvers
    Map<MixToken, ValueResolver>? resolverTokens;
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
        ? <MixToken, ValueResolver>{...?_tokens, ...?other._tokens}
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
    return Object.hash(_tokens, defaultOrderOfModifiers);
  }
}
