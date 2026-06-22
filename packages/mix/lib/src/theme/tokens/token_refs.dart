// ABOUTME: Token references for types used by MixToken classes in the Mix theme.
// ABOUTME: Contains refs, extension types and utilities specifically for design tokens.
import 'dart:ui';

import 'package:flutter/foundation.dart';
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

/// Token reference for [ShadowListMix] that implements Mix interface instead of Flutter interface.
///
/// Also implements `List<ShadowMix>` so that `shadowToken.mix()` can be passed
/// directly to styler methods that accept a raw `List<ShadowMix>` (e.g.
/// `TextStyler.shadows`) without changing their signatures. The list members
/// are never invoked — the ref is detected as a token and routed as a Mix.
final class ShadowListMixRef extends Prop<List<Shadow>>
    with ValueRef<List<Shadow>>
    implements ShadowListMix, List<ShadowMix> {
  ShadowListMixRef(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = .info}) {
    return super.toString();
  }
}

/// Token reference for [BoxShadowListMix] that implements Mix interface instead of Flutter interface.
///
/// Also implements `List<BoxShadowMix>` so that `boxShadowToken.mix()` can be
/// passed directly to styler methods that accept a raw `List<BoxShadowMix>`
/// (e.g. `BoxStyler.boxShadows`, `BoxStyler.shadows`) without changing their
/// signatures. The list members are never invoked — the ref is detected as a
/// token and routed as a Mix.
final class BoxShadowListMixRef extends Prop<List<BoxShadow>>
    with ValueRef<List<BoxShadow>>
    implements BoxShadowListMix, List<BoxShadowMix> {
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
/// nano-doubles handed out monotonically by [DoubleRef.token].
///
/// The sentinel range is reserved because extension-type values are represented
/// as `double` at runtime: a plain double equal to a registered sentinel is
/// indistinguishable from a [DoubleRef].
final Map<double, MixToken> _doubleTokenRegistry = <double, MixToken>{};

/// Reverse lookup: re-issues the same sentinel for the same token.
final Map<MixToken, double> _doubleSentinelByToken = <MixToken, double>{};

/// Number of sentinels handed out; the n-th sentinel is `-(n * 1e-6)`.
int _sentinelCount = 0;

/// Clears the [DoubleRef] sentinel registry. Internal test helper.
@internal
@visibleForTesting
void clearTokenRegistry() {
  _doubleTokenRegistry.clear();
  _doubleSentinelByToken.clear();
  _sentinelCount = 0;
}

/// Returns the token associated with a registered [DoubleRef] sentinel, or
/// `null` if [value] is not a registered sentinel.
///
/// Internal — used by [Prop.value] to detect token refs. External callers
/// should use [Prop.token] to construct an explicit token-backed prop.
@internal
MixToken<T>? getTokenFromValue<T>(Object value) {
  if (value is! double) return null;

  return _doubleTokenRegistry[value] as MixToken<T>?;
}

/// Token reference for [double] values that implements the double interface.
///
/// `DoubleRef` is a sentinel-backed ergonomic shim: it lets a [MixToken<double>]
/// flow through APIs that accept a plain `double` and still be detected as a
/// token during [Prop.value] construction. Because extension types are erased
/// at runtime, the only durable identity is the entry in the sentinel
/// registry, so the representation constructor is private — instances are
/// only ever obtained through [DoubleRef.token]. For an explicit, type-safe
/// token handle, use `Prop.token(token)` instead.
extension type const DoubleRef._(double _value) implements double {
  /// Returns a registered sentinel for [token], re-issuing the same one on
  /// repeated calls. Sentinels are unique among registered tokens.
  static DoubleRef token(MixToken<double> token) {
    final existing = _doubleSentinelByToken[token];
    if (existing != null) return DoubleRef._(existing);

    final sentinel = -(++_sentinelCount) * 0.000001;
    _doubleTokenRegistry[sentinel] = token;
    _doubleSentinelByToken[token] = sentinel;

    return DoubleRef._(sentinel);
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

  final Object ref = switch (T) {
    const (Color) => ColorRef(prop as Prop<Color>),
    const (double) => DoubleRef.token(token as MixToken<double>),
    const (Radius) => RadiusRef(prop as Prop<Radius>),
    const (Shadow) => ShadowRef(prop as Prop<Shadow>),
    const (BoxShadow) => BoxShadowRef(prop as Prop<BoxShadow>),
    const (TextStyle) => TextStyleRef(prop as Prop<TextStyle>),
    const (Breakpoint) => BreakpointRef(token as BreakpointToken),
    const (BorderSide) => BorderSideRef(prop as Prop<BorderSide>),
    const (FontWeight) => FontWeightRef(prop as Prop<FontWeight>),
    const (Duration) => DurationRef(prop as Prop<Duration>),
    const (List<Shadow>) => ShadowListRef(prop as Prop<List<Shadow>>),
    const (List<BoxShadow>) => BoxShadowListRef(prop as Prop<List<BoxShadow>>),
    _ => throw UnsupportedError(
      'No token reference is registered for MixToken<$T> "${token.name}". '
      'Either pick one of the supported token value types (Color, double, '
      'Radius, Shadow, BoxShadow, TextStyle, Breakpoint, BorderSide, '
      'FontWeight, Duration, List<Shadow>, List<BoxShadow>) or override '
      'MixToken<$T>.call() in your subclass to return a custom reference.',
    ),
  };

  return ref as T;
}
