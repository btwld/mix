// ABOUTME: Token references for types used by MixToken classes in the Mix theme.
// ABOUTME: Contains refs, extension types and utilities specifically for design tokens.
import 'package:flutter/widgets.dart';

import '../../core/breakpoint.dart';
import '../../core/prop.dart';
import '../../core/prop_source.dart';
import 'mix_token.dart';

mixin ValueRef<T> on Prop<T> {
  /// Generates a detailed error message for token reference misuse.
  String _buildTokenReferenceError(Symbol memberName) {
    final typeName = T.toString();
    final memberNameStr = memberName
        .toString()
        .replaceFirst('Symbol("', '')
        .replaceFirst('")', '');

    return '''Cannot access '$memberNameStr' on a $typeName token reference.

This is a context-dependent $typeName token that needs to be resolved through BuildContext before use.
Token references can only be passed directly to Mix styling utilities (e.g., \$box.color).

To use as an actual $typeName value:
- Pass it to Mix utilities: \$box.color.token(myColorToken)  
- Or resolve it first: myColorToken.resolve(context)''';
  }

  @override
  Never noSuchMethod(Invocation invocation) {
    throw UnimplementedError(_buildTokenReferenceError(invocation.memberName));
  }
}

/// Token reference for [Color] values with directive support.
final class ColorRef extends Prop<Color> with ValueRef<Color> implements Color {
  ColorRef(super.prop) : super.fromProp();
}

/// Token reference for [Radius] values
final class RadiusRef extends Prop<Radius>
    with ValueRef<Radius>
    implements Radius {
  RadiusRef(super.prop) : super.fromProp();
}

/// Token reference for [TextStyle] values
final class TextStyleRef extends Prop<TextStyle>
    with ValueRef<TextStyle>
    implements TextStyle {
  TextStyleRef(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [Shadow] values
final class ShadowRef extends Prop<Shadow>
    with ValueRef<Shadow>
    implements Shadow {
  ShadowRef(super.prop) : super.fromProp();
}

/// Token reference for [BoxShadow] values
final class BoxShadowRef extends Prop<BoxShadow>
    with ValueRef<BoxShadow>
    implements BoxShadow {
  BoxShadowRef(super.prop) : super.fromProp();
}

/// Token reference for [Breakpoint] values
final class BreakpointRef extends Prop<Breakpoint>
    with ValueRef<Breakpoint>
    implements Breakpoint {
  BreakpointRef(super.prop) : super.fromProp();
}

// =============================================================================
// EXTENSION TYPE TOKEN REFERENCES FOR PRIMITIVES
// =============================================================================
// Extension types for primitive values (double, int, string) that implement their
// respective interfaces while being trackable through a token registry.
// Each token gets a unique representation value based on token.hashCode to ensure
// reliable registry lookups without collisions.

/// Global registry to associate extension type values with their tokens
final Map<Object, MixToken> _tokenRegistry = <Object, MixToken>{};

/// Extension type for [double] values with token tracking (space values)
extension type const SpaceRef(double _value) implements double {
  /// Creates a SpaceRef using token hashCode and registers it with a token
  static SpaceRef token(MixToken<double> token) {
    // Use negative nano-values: -0.0001 to -0.000001
    // Negative values clearly indicate "this is a reference, not a real value"
    final hash = token.hashCode.abs() % 100000;
    final ref = SpaceRef(-(0.000001 + hash * 0.000001));
    _tokenRegistry[ref] = token;

    return ref;
  }
}



/// Utility to clean up token registry (for memory management)
@visibleForTesting
void clearTokenRegistry() {
  _tokenRegistry.clear();
}

/// Gets the token associated with a token reference value.
///
/// Returns the [MixToken] if the value is a registered token reference,
/// or null if it's not a token reference.
MixToken<T>? getTokenFromValue<T>(Object value) {
  return _tokenRegistry[value] as MixToken<T>?;
}

/// Checks if a value is any type of token reference.
///
/// Returns true for both class-based token references (Prop with ValueRef)
/// and extension type token references registered in the token registry.
bool isAnyTokenRef(Object value) {
  // Check if it's a class-based token reference (extends Prop with ValueRef mixin)
  // We can check if it has the ValueRef mixin by checking if it has a token source
  if (value is Prop && value.sources.any((s) => s is TokenSource)) {
    // Additional check to ensure it's actually a token reference class
    final typeName = value.runtimeType.toString();
    if (typeName.endsWith('Ref') || typeName.endsWith('Prop')) {
      return true;
    }
  }

  // Check if it's an extension type token reference by looking in the registry
  return _tokenRegistry.containsKey(value);
}

/// Creates the appropriate token reference type for the given token.
///
/// Returns a token reference that implements the target type T,
/// allowing the token to be used wherever T is expected.
T getReferenceValue<T>(MixToken<T> token) {
  final prop = Prop.token(token);
  if (T == Color) {
    return ColorRef(prop as Prop<Color>) as T;
  } else if (T == double) {
    return SpaceRef.token(token as MixToken<double>) as T;
  } else if (T == Radius) {
    return RadiusRef(prop as Prop<Radius>) as T;
  } else if (T == Shadow) {
    return ShadowRef(prop as Prop<Shadow>) as T;
  } else if (T == BoxShadow) {
    return BoxShadowRef(prop as Prop<BoxShadow>) as T;
  } else if (T == TextStyle) {
    return TextStyleRef(prop as Prop<TextStyle>) as T;
  } else if (T == Breakpoint) {
    return BreakpointRef(prop as Prop<Breakpoint>) as T;
  }

  return prop as T;
}