import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../core/breakpoint.dart';
import 'material/material_theme.dart';
import 'tokens/mix_token.dart';
import 'tokens/value_tokens.dart';

/// Provides Mix design tokens and configuration to descendant widgets.
///
/// Exposes type-safe design tokens, modifier ordering, and token resolution.
/// Uses [InheritedModel] with aspects: `tokens` and `modifierOrder`.
class MixScope extends InheritedModel<String> {
  /// Creates a [MixScope] with the provided tokens and modifier ordering.
  factory MixScope({
    Map<MixToken, Object>? tokens,
    Map<ColorToken, Color>? colors,
    Map<TextStyleToken, TextStyle>? textStyles,
    Map<SpaceToken, double>? spaces,
    Map<DoubleToken, double>? doubles,
    Map<RadiusToken, Radius>? radii,
    Map<BreakpointToken, Breakpoint>? breakpoints,
    Map<ShadowToken, List<Shadow>>? shadows,
    Map<BoxShadowToken, List<BoxShadow>>? boxShadows,
    Map<BorderSideToken, BorderSide>? borders,
    Map<FontWeightToken, FontWeight>? fontWeights,
    List<Type>? orderOfModifiers,
    required Widget child,
    Key? key,
  }) {
    final allTokens = <MixToken, Object>{
      ...?tokens,
      ...?colors?.cast<MixToken, Object>(),
      ...?textStyles?.cast<MixToken, Object>(),
      ...?spaces?.cast<MixToken, Object>(),
      ...?doubles?.cast<MixToken, Object>(),
      ...?radii?.cast<MixToken, Object>(),
      ...?breakpoints?.cast<MixToken, Object>(),
      ...?shadows?.cast<MixToken, Object>(),
      ...?boxShadows?.cast<MixToken, Object>(),
      ...?borders?.cast<MixToken, Object>(),
      ...?fontWeights?.cast<MixToken, Object>(),
    };

    return MixScope._(
      key: key,
      tokens: allTokens.isEmpty ? null : allTokens,
      orderOfModifiers: orderOfModifiers,
      child: child,
    );
  }

  const MixScope._({
    required Map<MixToken, Object>? tokens,
    required this.orderOfModifiers,
    required super.child,
    super.key,
  }) : _tokens = tokens;

  /// Creates an empty [MixScope] with no tokens or modifier ordering.
  const MixScope.empty({required super.child, super.key})
    : _tokens = null,
      orderOfModifiers = null;

  /// Creates a widget with Material Design tokens pre-configured.
  static Widget withMaterial({
    Map<MixToken, Object>? tokens,
    Map<ColorToken, Color>? colors,
    Map<TextStyleToken, TextStyle>? textStyles,
    Map<SpaceToken, double>? spaces,
    Map<DoubleToken, double>? doubles,
    Map<RadiusToken, Radius>? radii,
    Map<BreakpointToken, Breakpoint>? breakpoints,
    // Additional token maps (list-based)
    Map<ShadowToken, List<Shadow>>? shadows,
    Map<BoxShadowToken, List<BoxShadow>>? boxShadows,
    Map<BorderSideToken, BorderSide>? borders,
    Map<FontWeightToken, FontWeight>? fontWeights,
    List<Type>? orderOfModifiers,
    required Widget child,
    Key? key,
  }) {
    final allCustomTokens = <MixToken, Object>{
      ...?tokens,
      ...?colors?.cast<MixToken, Object>(),
      ...?textStyles?.cast<MixToken, Object>(),
      ...?spaces?.cast<MixToken, Object>(),
      ...?doubles?.cast<MixToken, Object>(),
      ...?radii?.cast<MixToken, Object>(),
      ...?breakpoints?.cast<MixToken, Object>(),
      ...?shadows?.cast<MixToken, Object>(),
      ...?boxShadows?.cast<MixToken, Object>(),
      ...?borders?.cast<MixToken, Object>(),
      ...?fontWeights?.cast<MixToken, Object>(),
    };

    return createMaterialMixScope(
      key: key,
      additionalTokens: allCustomTokens.isEmpty ? null : allCustomTokens,
      orderOfModifiers: orderOfModifiers,
      child: child,
    );
  }

  /// Returns the current [MixScope] from the widget tree.
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
  static T tokenOf<T>(MixToken<T> token, BuildContext context) {
    final scope = MixScope.of(context, 'tokens');

    return scope.getToken(token, context);
  }

  /// Returns the current [MixScope], or null if not found.
  static MixScope? maybeOf(BuildContext context, [String? aspect]) {
    if (aspect != null) {
      return InheritedModel.inheritFrom<MixScope>(context, aspect: aspect);
    }

    return context.dependOnInheritedWidgetOfExactType();
  }

  /// Combines multiple [MixScope] instances into a single scope.
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

  /// Creates a [MixScope] that inherits from the nearest ancestor [MixScope]
  /// and merges the provided values on top of it.
  ///
  /// Mirrors the [DefaultTextStyle.merge] pattern: values passed here take
  /// precedence, and anything omitted falls back to the ancestor scope.
  ///
  /// Use this for feature- or screen-level overrides. Unlike nesting a plain
  /// [MixScope] — which fully shadows the ancestor, leaving non-overridden
  /// tokens unresolvable — this keeps the inherited tokens intact.
  ///
  /// ```dart
  /// MixScope.inherit(
  ///   colors: {ColorToken('brand.primary'): Colors.green},
  ///   child: FeatureWidget(),
  /// )
  /// ```
  ///
  /// Returns a [Widget] rather than a [MixScope] because it wraps a [Builder]
  /// to obtain a [BuildContext] below the ancestor scope. For that reason it
  /// is a static method, not a factory constructor.
  ///
  /// If no ancestor [MixScope] exists, this behaves like a plain [MixScope].
  static Widget inherit({
    Map<MixToken, Object>? tokens,
    Map<ColorToken, Color>? colors,
    Map<TextStyleToken, TextStyle>? textStyles,
    Map<SpaceToken, double>? spaces,
    Map<DoubleToken, double>? doubles,
    Map<RadiusToken, Radius>? radii,
    Map<BreakpointToken, Breakpoint>? breakpoints,
    Map<ShadowToken, List<Shadow>>? shadows,
    Map<BoxShadowToken, List<BoxShadow>>? boxShadows,
    Map<BorderSideToken, BorderSide>? borders,
    Map<FontWeightToken, FontWeight>? fontWeights,
    List<Type>? orderOfModifiers,
    required Widget child,
    Key? key,
  }) {
    return Builder(
      builder: (BuildContext context) {
        final MixScope? parent = MixScope.maybeOf(context);
        final MixScope scope = MixScope(
          key: key,
          tokens: tokens,
          colors: colors,
          textStyles: textStyles,
          spaces: spaces,
          doubles: doubles,
          radii: radii,
          breakpoints: breakpoints,
          shadows: shadows,
          boxShadows: boxShadows,
          borders: borders,
          fontWeights: fontWeights,
          orderOfModifiers: orderOfModifiers,
          child: child,
        );

        return parent == null ? scope : parent.merge(scope);
      },
    );
  }

  final List<Type>? orderOfModifiers;

  final Map<MixToken, Object>? _tokens;

  /// Returns the raw token map provided to this scope.
  Map<MixToken, Object>? get tokens => _tokens;

  /// Resolves [token] to its concrete value.
  ///
  /// A scope entry may hold the value itself or a `T Function(BuildContext)`
  /// resolver, which is invoked with [context] at resolution time:
  ///
  /// ```dart
  /// MixScope(
  ///   tokens: {
  ///     $primary: (BuildContext context) =>
  ///         Theme.of(context).colorScheme.primary,
  ///   },
  ///   child: app,
  /// )
  /// ```
  ///
  /// Resolver entries affect token resolution. Token calls, such as
  /// `$primary()`, still use Mix's existing token-reference support and are
  /// limited to the same supported value types.
  T getToken<T>(MixToken<T> token, BuildContext context) {
    final value = _tokens?[token];
    if (value == null) {
      throw StateError('Token "${token.name}" not found in scope');
    }

    if (value is T Function(BuildContext)) {
      return value(context);
    }

    if (value is T) {
      return value as T;
    }

    throw StateError(
      'Token "${token.name}" resolved to ${value.runtimeType}, expected $T',
    );
  }

  /// Returns a new [MixScope] by merging this scope with [other].
  ///
  /// Token maps are combined with [other] taking precedence; [other]'s
  /// [orderOfModifiers], [key], and [child] win when provided.
  MixScope merge(MixScope other) {
    final mergedTokens = _tokens != null || other._tokens != null
        ? <MixToken, Object>{...?_tokens, ...?other._tokens}
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
