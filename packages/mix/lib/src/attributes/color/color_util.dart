import 'package:flutter/material.dart';

import '../../core/attribute.dart';
import '../../core/prop.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import 'color_directive.dart';
import 'material_colors_util.dart';

/// Mixin that provides color directive methods
base mixin ColorDirectiveMixin<T extends SpecAttribute<Object?>>
    on PropUtility<T, Color> {
  // All directive methods use the directive() method from PropUtility
  T withOpacity(double opacity) => directive(OpacityDirective(opacity));

  T withAlpha(int alpha) => directive(AlphaDirective(alpha));

  T darken(int amount) => directive(DarkenDirective(amount));

  T lighten(int amount) => directive(LightenDirective(amount));

  T saturate(int amount) => directive(SaturateDirective(amount));

  T desaturate(int amount) => directive(DesaturateDirective(amount));

  T tint(int amount) => directive(TintDirective(amount));

  T shade(int amount) => directive(ShadeDirective(amount));

  T brighten(int amount) => directive(BrightenDirective(amount));
}

/// Utility for predefined colors (e.g., Colors.red)
@immutable
base class FoundationColorUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Color>
    with ColorDirectiveMixin<T> {
  final Color color;
  const FoundationColorUtility(super.builder, this.color);
}

/// Callable color utility that supports both function call and property access
/// This utility can be called as a function to return a StyleElement,
/// or accessed as a property to get the Color value.
@immutable
final class CallableColorUtility<T extends SpecAttribute<Object?>> {
  final T Function(Prop<Color>) builder;
  final Color color;

  const CallableColorUtility(this.builder, this.color);

  /// Call operator to make this utility callable as a function
  /// Usage: colorUtil.black() returns T that resolves to Colors.black
  T call() => builder(Prop(color));

  /// Directive methods for color transformations
  T withOpacity(double opacity) =>
      builder(Prop.directives([OpacityDirective(opacity)]));

  T withAlpha(int alpha) => builder(Prop.directives([AlphaDirective(alpha)]));

  T darken(int amount) => builder(Prop.directives([DarkenDirective(amount)]));

  T lighten(int amount) => builder(Prop.directives([LightenDirective(amount)]));

  T saturate(int amount) =>
      builder(Prop.directives([SaturateDirective(amount)]));

  T desaturate(int amount) =>
      builder(Prop.directives([DesaturateDirective(amount)]));

  T tint(int amount) => builder(Prop.directives([TintDirective(amount)]));

  T shade(int amount) => builder(Prop.directives([ShadeDirective(amount)]));

  T brighten(int amount) =>
      builder(Prop.directives([BrightenDirective(amount)]));
}

/// Simplified ColorUtility using the PropUtility pattern
@immutable
final class ColorUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Color>
    with ColorDirectiveMixin<T>, MaterialColorsMixin<T>, BasicColorsMixin<T> {
  ColorUtility(super.builder);

  /// @deprecated Use [token] instead
  @Deprecated('Use token() instead. Will be removed in a future version.')
  T ref(MixToken<Color> ref) => token(ref);
}

base mixin BasicColorsMixin<T extends SpecAttribute<Object?>>
    on PropUtility<T, Color> {
  late final transparent = CallableColorUtility(builder, Colors.transparent);

  late final black = CallableColorUtility(builder, Colors.black);

  late final black87 = CallableColorUtility(builder, Colors.black87);

  late final black54 = CallableColorUtility(builder, Colors.black54);

  late final black45 = CallableColorUtility(builder, Colors.black45);

  late final black38 = CallableColorUtility(builder, Colors.black38);

  late final black26 = CallableColorUtility(builder, Colors.black26);

  late final black12 = CallableColorUtility(builder, Colors.black12);

  late final white = CallableColorUtility(builder, Colors.white);

  late final white70 = CallableColorUtility(builder, Colors.white70);

  late final white60 = CallableColorUtility(builder, Colors.white60);

  late final white54 = CallableColorUtility(builder, Colors.white54);

  late final white38 = CallableColorUtility(builder, Colors.white38);

  late final white30 = CallableColorUtility(builder, Colors.white30);

  late final white24 = CallableColorUtility(builder, Colors.white24);

  late final white12 = CallableColorUtility(builder, Colors.white12);

  late final white10 = CallableColorUtility(builder, Colors.white10);
}
