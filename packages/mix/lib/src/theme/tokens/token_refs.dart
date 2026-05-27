// ABOUTME: Token references for types used by MixToken classes in the Mix theme.
// ABOUTME: Contains refs, extension types and utilities specifically for design tokens.
import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../core/breakpoint.dart';
import '../../core/directive.dart';
import '../../core/equatable.dart';
import '../../core/prop.dart';
import '../../core/prop_refs.dart';
import '../../core/prop_source.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/typography/text_style_mix.dart';
import 'mix_token.dart';
import 'value_tokens.dart';

mixin ValueRef<T> {
  /// Generates a detailed error message for token reference misuse.
  String _buildTokenReferenceError(Symbol memberName) {
    final typeName = T.toString();
    final memberNameStr = memberName
        .toString()
        .replaceFirst('Symbol("', '')
        .replaceFirst('")', '');

    return '''Cannot access '$memberNameStr' on a $typeName token reference.

This is a context-dependent $typeName token that needs to be resolved through BuildContext before use.
Token references can only be passed directly to Mix styling utilities (e.g., BoxStyler().color(myColorToken())).

To use as an actual $typeName value:
- Pass it to Mix utilities: BoxStyler().color(myColorToken())
- Or resolve it first: myColorToken.resolve(context)''';
  }

  @override
  Never noSuchMethod(Invocation invocation) {
    throw UnsupportedError(_buildTokenReferenceError(invocation.memberName));
  }
}

/// Token reference for [Color] values with directive support.
final class ColorRef extends Prop<Color> with ValueRef<Color> implements Color {
  ColorRef(super.prop) : super.fromProp();

  @override
  Color withValues({
    double? alpha,
    double? red,
    double? green,
    double? blue,
    ColorSpace? colorSpace,
  }) => ColorRef(
    directives([
      WithValuesColorDirective(
        alpha: alpha,
        red: red,
        green: green,
        blue: blue,
        colorSpace: colorSpace,
      ),
    ]),
  );

  @override
  Color withAlpha(int a) => ColorRef(directives([AlphaColorDirective(a)]));

  @override
  Color withRed(int r) => ColorRef(directives([WithRedColorDirective(r)]));

  @override
  Color withGreen(int g) => ColorRef(directives([WithGreenColorDirective(g)]));

  @override
  Color withBlue(int b) => ColorRef(directives([WithBlueColorDirective(b)]));

  @override
  Color withOpacity(double opacity) =>
      ColorRef(directives([OpacityColorDirective(opacity)]));
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
  String toString({DiagnosticLevel minLevel = .info}) {
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
final class BreakpointRef
    with ValueRef<Breakpoint>, Equatable
    implements Breakpoint {
  final BreakpointToken token;
  const BreakpointRef(this.token);

  @override
  List<Object?> get props => [token];
}

// =============================================================================
// MIX REF CLASSES - FOR MIX FRAMEWORK USAGE
// =============================================================================

/// Token reference for [TextStyleMix] that implements Mix interface instead of Flutter interface
final class TextStyleMixRef extends Prop<TextStyle>
    with ValueRef<TextStyle>
    implements TextStyleMix {
  TextStyleMixRef(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = .info}) {
    return super.toString();
  }
}

/// Token reference for [ShadowMix] that implements Mix interface instead of Flutter interface
final class ShadowMixRef extends Prop<Shadow>
    with ValueRef<Shadow>
    implements ShadowMix {
  ShadowMixRef(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = .info}) {
    return super.toString();
  }
}

/// Token reference for [BoxShadowMix] that implements Mix interface instead of Flutter interface
final class BoxShadowMixRef extends Prop<BoxShadow>
    with ValueRef<BoxShadow>
    implements BoxShadowMix {
  BoxShadowMixRef(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = .info}) {
    return super.toString();
  }
}

/// Token reference for [ShadowListMix] that implements Mix interface instead of Flutter interface
final class ShadowListMixRef extends Prop<List<Shadow>>
    with ValueRef<List<Shadow>>
    implements ShadowListMix {
  ShadowListMixRef(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = .info}) {
    return super.toString();
  }
}

/// Token reference for [BoxShadowListMix] that implements Mix interface instead of Flutter interface
final class BoxShadowListMixRef extends Prop<List<BoxShadow>>
    with ValueRef<List<BoxShadow>>
    implements BoxShadowListMix {
  BoxShadowListMixRef(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = .info}) {
    return super.toString();
  }
}

// =============================================================================
// EXTENSION TYPE TOKEN REFERENCES FOR PRIMITIVES
// =============================================================================

/// Maps sentinel values to their source [MixToken]. Sentinels are negative
/// nano-doubles chosen to avoid colliding with ordinary user-supplied doubles.
final Map<Object, MixToken> _doubleTokenRegistry = <Object, MixToken>{};

/// Reverse lookup: stable token → sentinel mapping. Re-issues the same
/// sentinel for the same token instead of creating a new one.
final Map<MixToken, double> _doubleSentinelByToken = <MixToken, double>{};

/// Maximum number of probe attempts when resolving a sentinel collision
/// between two distinct tokens whose hashes happen to coincide.
const int _kSentinelProbeLimit = 1000;

/// Clears the token registry.
@visibleForTesting
void clearTokenRegistry() {
  _doubleTokenRegistry.clear();
  _doubleSentinelByToken.clear();
}

/// Returns the token associated with a token reference value.
///
/// Returns null if the value is not a registered token reference.
MixToken<T>? getTokenFromValue<T>(Object value) {
  return _doubleTokenRegistry[value] as MixToken<T>?;
}

/// Token reference for [double] values that implements the double interface.
///
/// `DoubleRef` is a sentinel-backed ergonomic shim: it lets a [MixToken<double>]
/// flow through APIs that accept a plain `double` and still be detected as a
/// token during [Prop.value] construction. Because extension types are erased
/// at runtime, the only durable identity is the entry in
/// [_doubleTokenRegistry] — direct construction (`DoubleRef(42.0)`) never
/// registers and will not be recognised as a token. For guaranteed safety,
/// prefer `Prop.token(token)`.
extension type const DoubleRef(double _value) implements double {
  /// Creates a token reference and registers it in the global registry.
  ///
  /// Re-issues the same sentinel for the same token. If two distinct tokens
  /// produce the same hash bucket, probes nearby sentinels to avoid aliasing.
  static DoubleRef token(MixToken<double> token) {
    final existing = _doubleSentinelByToken[token];
    if (existing != null) return DoubleRef(existing);

    final base = token.hashCode.abs() % 100000;
    for (var probe = 0; probe < _kSentinelProbeLimit; probe++) {
      final candidate = -(0.000001 + (base + probe) * 0.000001);
      final occupant = _doubleTokenRegistry[candidate];
      if (occupant == null) {
        _doubleTokenRegistry[candidate] = token;
        _doubleSentinelByToken[token] = candidate;

        return DoubleRef(candidate);
      }
      if (occupant == token) {
        _doubleSentinelByToken[token] = candidate;

        return DoubleRef(candidate);
      }
    }

    throw StateError(
      'DoubleRef registry exhausted while assigning a sentinel for '
      'token "${token.name}". This indicates an unusually dense hash '
      'collision; consider renaming one of the colliding tokens.',
    );
  }
}

/// Token reference for [List<Shadow>] values
final class ShadowListRef extends Prop<List<Shadow>>
    with ValueRef<List<Shadow>>
    implements List<Shadow> {
  ShadowListRef(super.prop) : super.fromProp();
}

/// Token reference for [List<BoxShadow>] values
final class BoxShadowListRef extends Prop<List<BoxShadow>>
    with ValueRef<List<BoxShadow>>
    implements List<BoxShadow> {
  BoxShadowListRef(super.prop) : super.fromProp();
}

/// Returns true if the value is a token reference.
///
/// Detects both class-based token references (any [Prop] carrying a
/// [TokenSource]) and extension type token references registered via
/// [DoubleRef.token].
bool isAnyTokenRef(Object? value) {
  if (value == null) return false;
  if (value is Prop) return value.hasToken;

  return _doubleTokenRegistry.containsKey(value);
}

/// Creates the appropriate token reference for the given token.
///
/// Returns a reference that implements the target type, allowing the token
/// to be used wherever the type is expected.
///
/// Throws [UnsupportedError] if [T] is not in the supported reference set.
/// Concrete [MixToken] subclasses (`ColorToken`, `SpaceToken`, etc.) override
/// `call()` directly and never hit this fallback; custom token authors must
/// either pick one of the supported types or override `call()` themselves.
T getReferenceValue<T>(MixToken<T> token) {
  final prop = Prop.token(token);
  if (T == Color) {
    return ColorRef(prop as Prop<Color>) as T;
  } else if (T == double) {
    return DoubleRef.token(token as MixToken<double>) as T;
  } else if (T == Radius) {
    return RadiusRef(prop as Prop<Radius>) as T;
  } else if (T == Shadow) {
    return ShadowRef(prop as Prop<Shadow>) as T;
  } else if (T == BoxShadow) {
    return BoxShadowRef(prop as Prop<BoxShadow>) as T;
  } else if (T == TextStyle) {
    return TextStyleRef(prop as Prop<TextStyle>) as T;
  } else if (T == Breakpoint) {
    return BreakpointRef(token as BreakpointToken) as T;
  } else if (T == BorderSide) {
    return BorderSideRef(prop as Prop<BorderSide>) as T;
  } else if (T == FontWeight) {
    return FontWeightRef(prop as Prop<FontWeight>) as T;
  } else if (T == Duration) {
    return DurationRef(prop as Prop<Duration>) as T;
  } else if (T == List<Shadow>) {
    return ShadowListRef(prop as Prop<List<Shadow>>) as T;
  } else if (T == List<BoxShadow>) {
    return BoxShadowListRef(prop as Prop<List<BoxShadow>>) as T;
  }

  throw UnsupportedError(
    'No token reference is registered for MixToken<$T> "${token.name}". '
    'Either pick one of the supported token value types (Color, double, '
    'Radius, Shadow, BoxShadow, TextStyle, Breakpoint, BorderSide, '
    'FontWeight, Duration, List<Shadow>, List<BoxShadow>) or override '
    'MixToken<$T>.call() in your subclass to return a custom reference.',
  );
}
