import 'package:flutter/material.dart';

import '../core/directive.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';
import 'material_colors_util.dart';

/// Provides color transformation methods for applying opacity, brightness, and saturation changes.
///
/// All directive methods modify the color value through transformation directives
/// that are applied during resolution.
mixin ColorDirectiveMixin<T extends SpecStyle<Object?>>
    on PropUtility<T, Color> {
  /// Applies the specified opacity to the color (0.0 to 1.0).
  T withOpacity(double opacity) => directive(OpacityColorDirective(opacity));

  /// Sets the alpha channel of the color (0 to 255).
  T withAlpha(int alpha) => directive(AlphaColorDirective(alpha));

  /// Darkens the color by the specified percentage (0 to 100).
  T darken(int amount) => directive(DarkenColorDirective(amount));

  /// Lightens the color by the specified percentage (0 to 100).
  T lighten(int amount) => directive(LightenColorDirective(amount));

  /// Increases the color saturation by the specified percentage (0 to 100).
  T saturate(int amount) => directive(SaturateColorDirective(amount));

  /// Decreases the color saturation by the specified percentage (0 to 100).
  T desaturate(int amount) => directive(DesaturateColorDirective(amount));

  /// Mixes the color with white by the specified percentage (0 to 100).
  T tint(int amount) => directive(TintColorDirective(amount));

  /// Mixes the color with black by the specified percentage (0 to 100).
  T shade(int amount) => directive(ShadeColorDirective(amount));

  /// Increases the color brightness by the specified percentage (0 to 100).
  T brighten(int amount) => directive(BrightenColorDirective(amount));
}

/// Utility for predefined colors (e.g., Colors.red)
@immutable
class FoundationColorUtility<T extends SpecStyle<Object?>>
    extends PropUtility<T, Color>
    with ColorDirectiveMixin<T> {
  final Color color;
  const FoundationColorUtility(super.builder, this.color);
}

/// Color utility that can be called as a function or used with directive methods.
///
/// Supports both direct function calls to apply the color and method chaining
/// for color transformations like opacity, darkening, or saturation changes.
@immutable
class CallableColorUtility<T extends SpecStyle<Object?>> {
  final T Function(Prop<Color>) builder;
  final Color color;

  const CallableColorUtility(this.builder, this.color);

  /// Call operator to make this utility callable as a function
  /// Usage: colorUtil.black() returns T that resolves to Colors.black
  T call() => builder(Prop(color));

  /// Applies the specified opacity to the color (0.0 to 1.0).
  T withOpacity(double opacity) =>
      builder(Prop.directives([OpacityColorDirective(opacity)]));

  T withAlpha(int alpha) =>
      builder(Prop.directives([AlphaColorDirective(alpha)]));

  T darken(int amount) =>
      builder(Prop.directives([DarkenColorDirective(amount)]));

  T lighten(int amount) =>
      builder(Prop.directives([LightenColorDirective(amount)]));

  T saturate(int amount) =>
      builder(Prop.directives([SaturateColorDirective(amount)]));

  T desaturate(int amount) =>
      builder(Prop.directives([DesaturateColorDirective(amount)]));

  T tint(int amount) => builder(Prop.directives([TintColorDirective(amount)]));

  T shade(int amount) =>
      builder(Prop.directives([ShadeColorDirective(amount)]));

  T brighten(int amount) =>
      builder(Prop.directives([BrightenColorDirective(amount)]));
}

/// Simplified ColorUtility using the PropUtility pattern
@immutable
final class ColorUtility<T extends SpecStyle<Object?>>
    extends PropUtility<T, Color>
    with ColorDirectiveMixin<T>, ColorsUtilityMixin<T>, BasicColorsMixin<T> {
  ColorUtility(super.builder);

  /// @deprecated Use [token] instead
  @Deprecated('Use token() instead. Will be removed in a future version.')
  T ref(MixToken<Color> ref) => token(ref);
}

mixin BasicColorsMixin<T extends SpecStyle<Object?>> on PropUtility<T, Color> {
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
