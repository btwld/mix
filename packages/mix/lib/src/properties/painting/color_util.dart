import 'package:flutter/material.dart';

import '../../core/directive.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import 'material_colors_util.dart';

/// Provides color transformation methods for applying opacity, brightness, and saturation changes.
///
/// All directive methods modify the color value through transformation directives
/// that are applied during resolution.
mixin ColorDirectiveMixin<T extends StyleAttribute<Object?>>
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
class FoundationColorUtility<T extends StyleAttribute<Object?>>
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
class CallableColorUtility<T extends StyleAttribute<Object?>> {
  final T Function(Prop<Color>) builder;
  final Color color;

  const CallableColorUtility(this.builder, this.color);

  /// Call operator to make this utility callable as a function
  /// Usage: colorUtil.black() returns T that resolves to Colors.black
  T call() => builder(Prop(color));

  /// Applies the specified opacity to the color (0.0 to 1.0).
  T withOpacity(double opacity) =>
      builder(Prop.directives([OpacityColorDirective(opacity)]));

  /// Sets the alpha channel of the color (0 to 255).
  T withAlpha(int alpha) =>
      builder(Prop.directives([AlphaColorDirective(alpha)]));

  /// Darkens the color by the specified percentage (0 to 100).
  T darken(int amount) =>
      builder(Prop.directives([DarkenColorDirective(amount)]));

  /// Lightens the color by the specified percentage (0 to 100).
  T lighten(int amount) =>
      builder(Prop.directives([LightenColorDirective(amount)]));

  /// Increases the color saturation by the specified percentage (0 to 100).
  T saturate(int amount) =>
      builder(Prop.directives([SaturateColorDirective(amount)]));

  /// Decreases the color saturation by the specified percentage (0 to 100).
  T desaturate(int amount) =>
      builder(Prop.directives([DesaturateColorDirective(amount)]));

  /// Mixes the color with white by the specified percentage (0 to 100).
  T tint(int amount) => builder(Prop.directives([TintColorDirective(amount)]));

  /// Mixes the color with black by the specified percentage (0 to 100).
  T shade(int amount) =>
      builder(Prop.directives([ShadeColorDirective(amount)]));

  /// Increases the color brightness by the specified percentage (0 to 100).
  T brighten(int amount) =>
      builder(Prop.directives([BrightenColorDirective(amount)]));
}

/// Simplified ColorUtility using the PropUtility pattern
@immutable
final class ColorUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, Color>
    with ColorDirectiveMixin<T>, ColorsUtilityMixin<T>, BasicColorsMixin<T> {
  ColorUtility(super.builder);

  /// @deprecated Use [token] instead
  /// 
  /// Migration example:
  /// ```dart
  /// // Before
  /// $box.color.ref(colorToken)
  /// 
  /// // After  
  /// $box.color.token(colorToken)
  /// ```
  @Deprecated('Use token() instead. Will be removed in a future version.')
  T ref(MixToken<Color> ref) => token(ref);
}

/// Provides access to basic black, white, and transparent colors with opacity variants.
///
/// All colors are available as callable utilities that support both direct application
/// and color transformation methods.
mixin BasicColorsMixin<T extends StyleAttribute<Object?>>
    on PropUtility<T, Color> {
  /// Fully transparent color utility.
  late final transparent = CallableColorUtility(builder, Colors.transparent);

  /// Pure black color utility.
  late final black = CallableColorUtility(builder, Colors.black);

  /// Black with 87% opacity for primary text.
  late final black87 = CallableColorUtility(builder, Colors.black87);

  /// Black with 54% opacity for secondary text.
  late final black54 = CallableColorUtility(builder, Colors.black54);

  late final black45 = CallableColorUtility(builder, Colors.black45);

  /// Black with 38% opacity for disabled text.
  late final black38 = CallableColorUtility(builder, Colors.black38);

  late final black26 = CallableColorUtility(builder, Colors.black26);

  late final black12 = CallableColorUtility(builder, Colors.black12);

  /// Pure white color utility.
  late final white = CallableColorUtility(builder, Colors.white);

  /// White with 70% opacity for text on dark backgrounds.
  late final white70 = CallableColorUtility(builder, Colors.white70);

  late final white60 = CallableColorUtility(builder, Colors.white60);

  /// White with 54% opacity for secondary text on dark backgrounds.
  late final white54 = CallableColorUtility(builder, Colors.white54);

  /// White with 38% opacity for disabled text on dark backgrounds.
  late final white38 = CallableColorUtility(builder, Colors.white38);

  late final white30 = CallableColorUtility(builder, Colors.white30);

  late final white24 = CallableColorUtility(builder, Colors.white24);

  late final white12 = CallableColorUtility(builder, Colors.white12);

  late final white10 = CallableColorUtility(builder, Colors.white10);
}
