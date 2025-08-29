import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'material/material_theme.dart';
import 'tokens/mix_token.dart';

/// Inherited widget that provides Mix theme data and token resolution to its descendants.
///
/// The [MixScope] is the root of the Mix theming system, providing access to design tokens,
/// default widget modifier ordering, and other theme-related configuration.
///
/// Uses InheritedModel to enable aspect-based dependencies for efficient rebuilds.
/// Supported aspects:
/// - 'tokens': Rebuilds when token values change
/// - 'modifierOrder': Rebuilds when modifier ordering changes
class MixScope extends InheritedModel<String> {
  /// Creates a MixScope with the provided tokens and modifier ordering
  factory MixScope({
    Set<TokenDefinition>? tokens,
    List<Type>? orderOfModifiers,
    required Widget child,
    Key? key,
  }) {
    return MixScope._(
      key: key,
      tokens: tokens != null
          ? {for (final token in tokens) token.token: token.resolver}
          : null,
      orderOfModifiers: orderOfModifiers,
      child: child,
    );
  }

  const MixScope._({
    required Map<MixToken, ValueBuilder>? tokens,
    required this.orderOfModifiers,
    required super.child,
    super.key,
  }) : _tokens = tokens;

  /// Creates an empty MixScope with no tokens or modifier ordering
  const MixScope.empty({required super.child, super.key})
    : _tokens = null,
      orderOfModifiers = null;

  /// Creates a MixScope with Material design tokens pre-configured
  factory MixScope.withMaterial({
    Set<TokenDefinition>? tokens,
    List<Type>? orderOfModifiers,
    required Widget child,
    Key? key,
  }) {
    // Merge material tokens with custom tokens
    final mergedTokens = {...materialTokens, ...?tokens};

    return MixScope(
      key: key,
      tokens: mergedTokens,
      orderOfModifiers: orderOfModifiers,
      child: child,
    );
  }

  /// Gets the MixScope from the widget tree.
  ///
  /// Optionally specify an [aspect] to create a dependency only on that aspect.
  /// Supported aspects: 'tokens', 'modifierOrder'
  static MixScope of(BuildContext context, [String? aspect]) {
    final MixScope? scope = maybeOf(context, aspect);
    if (scope != null) {
      return scope;
    }
    throw FlutterError.fromParts([
      ErrorSummary('No MixScope found.'),
      ErrorDescription(
        '${context.widget.runtimeType} tried to access Mix scope, but no MixScope widget was found in the widget tree.',
      ),
      context.describeElement('The context used was'),
      ...context.describeMissingAncestor(expectedAncestorType: MixScope),
      ErrorHint(
        'To fix this, ensure that a MixScope widget is present above ${context.widget.runtimeType} in the widget tree. '
        'This is typically done by wrapping your app with MixScope:\n'
        '  MixScope(\n'
        '    tokens: {...}, // your tokens\n'
        '    child: MaterialApp(...),\n'
        '  )',
      ),
    ]);
  }

  /// Resolves a token value from the nearest MixScope.
  ///
  /// This method creates a dependency on the 'tokens' aspect.
  static T tokenOf<T>(MixToken<T> token, BuildContext context) {
    final scope = MixScope.of(context, 'tokens');

    return scope.getToken(token, context);
  }

  /// Gets the MixScope from the widget tree, or null if not found.
  ///
  /// Optionally specify an [aspect] to create a dependency only on that aspect.
  static MixScope? maybeOf(BuildContext context, [String? aspect]) {
    if (aspect != null) {
      return InheritedModel.inheritFrom<MixScope>(context, aspect: aspect);
    }

    return context.dependOnInheritedWidgetOfExactType();
  }

  /// Combines multiple MixScopes into a single scope
  static MixScope combine({
    required Iterable<MixScope> scopes,
    required Widget child,
    Key? key,
  }) {
    if (scopes.isEmpty) return MixScope.empty(key: key, child: child);

    final combined = scopes.fold<MixScope>(
      MixScope.empty(child: child),
      (previous, scope) => previous.merge(scope),
    );

    return MixScope._(
      key: key,
      tokens: combined._tokens,
      orderOfModifiers: combined.orderOfModifiers,
      child: child,
    );
  }

  final Map<MixToken, ValueBuilder>? _tokens;

  final List<Type>? orderOfModifiers;

  /// Getter for tokens map
  Map<MixToken, ValueBuilder>? get tokens => _tokens;

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

  /// Creates a new MixScope by merging this scope with another
  MixScope merge(MixScope other) {
    final mergedTokens = _tokens != null || other._tokens != null
        ? <MixToken, ValueBuilder>{...?_tokens, ...?other._tokens}
        : null;

    return MixScope._(
      key: other.key,
      tokens: mergedTokens,
      orderOfModifiers: other.orderOfModifiers ?? orderOfModifiers,
      child: other.child,
    );
  }

  @override
  bool updateShouldNotify(MixScope oldWidget) {
    return !mapEquals(_tokens, oldWidget._tokens) ||
        !listEquals(orderOfModifiers, oldWidget.orderOfModifiers);
  }

  @override
  bool updateShouldNotifyDependent(
    MixScope oldWidget,
    Set<String> dependencies,
  ) {
    // Check if tokens changed and widget depends on tokens
    if (dependencies.contains('tokens') &&
        !mapEquals(_tokens, oldWidget._tokens)) {
      return true;
    }

    // Check if modifier order changed and widget depends on it
    if (dependencies.contains('modifierOrder') &&
        !listEquals(orderOfModifiers, oldWidget.orderOfModifiers)) {
      return true;
    }

    return false;
  }
}

// Deprecated typedefs moved to src/core/deprecated.dart
