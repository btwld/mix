// ABOUTME: Token references for types used by MixToken classes in the Mix theme.
// ABOUTME: Contains refs, extension types and utilities specifically for design tokens.
import 'package:flutter/widgets.dart';

import '../../core/breakpoint.dart';
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
final class BreakpointRef with ValueRef<Breakpoint> implements Breakpoint {
  final BreakpointToken token;
  const BreakpointRef(this.token);
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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [ShadowMix] that implements Mix interface instead of Flutter interface
final class ShadowMixRef extends Prop<Shadow>
    with ValueRef<Shadow>
    implements ShadowMix {
  ShadowMixRef(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [BoxShadowMix] that implements Mix interface instead of Flutter interface
final class BoxShadowMixRef extends Prop<BoxShadow>
    with ValueRef<BoxShadow>
    implements BoxShadowMix {
  BoxShadowMixRef(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [ShadowListMix] that implements Mix interface instead of Flutter interface
final class ShadowListMixRef extends Prop<List<Shadow>>
    with ValueRef<List<Shadow>>
    implements ShadowListMix {
  ShadowListMixRef(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [BoxShadowListMix] that implements Mix interface instead of Flutter interface
final class BoxShadowListMixRef extends Prop<List<BoxShadow>>
    with ValueRef<List<BoxShadow>>
    implements BoxShadowListMix {
  BoxShadowListMixRef(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

// =============================================================================
// EXTENSION TYPE TOKEN REFERENCES FOR PRIMITIVES
// =============================================================================

/// Global registry that maps extension type values to their source tokens.
final Map<Object, MixToken> _tokenRegistry = <Object, MixToken>{};

/// Clears the token registry.
@visibleForTesting
void clearTokenRegistry() {
  _tokenRegistry.clear();
}

/// Returns the token associated with a token reference value.
///
/// Returns null if the value is not a registered token reference.
MixToken<T>? getTokenFromValue<T>(Object value) {
  return _tokenRegistry[value] as MixToken<T>?;
}

/// Token reference for [double] values that implements the double interface.
extension type const DoubleRef(double _value) implements double {
  /// Creates a token reference and registers it in the global registry.
  static DoubleRef token(MixToken<double> token) {
    // Generate unique negative nano-value to avoid collisions with real values
    final hash = token.hashCode.abs() % 100000;
    final ref = DoubleRef(-(0.000001 + hash * 0.000001));
    _tokenRegistry[ref] = token;

    return ref;
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
/// Detects both class-based token references (Prop with ValueRef)
/// and extension type token references.
bool isAnyTokenRef(Object value) {
  // Check for class-based token references
  if (value is Prop && value.sources.any((s) => s is TokenSource)) {
    final typeName = value.runtimeType.toString();
    if (typeName.endsWith('Ref') || typeName.endsWith('Prop')) {
      return true;
    }
  }

  // Check for extension type token references
  return _tokenRegistry.containsKey(value);
}

/// Creates the appropriate token reference for the given token.
///
/// Returns a reference that implements the target type, allowing the token
/// to be used wherever the type is expected.
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

  return prop as T;
}
