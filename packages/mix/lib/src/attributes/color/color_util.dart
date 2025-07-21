import 'package:flutter/material.dart';

import '../../core/directive.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import 'material_colors_util.dart';

/// Mixin that provides color directive methods
mixin ColorDirectiveMixin<T extends SpecAttribute<Object?>>
    on PropUtility<T, Color> {
  // All directive methods use the directive() method from PropUtility
  T withOpacity(double opacity) => directive(OpacityColorDirective(opacity));

  T withAlpha(int alpha) => directive(AlphaColorDirective(alpha));

  T darken(int amount) => directive(DarkenColorDirective(amount));

  T lighten(int amount) => directive(LightenColorDirective(amount));

  T saturate(int amount) => directive(SaturateColorDirective(amount));

  T desaturate(int amount) => directive(DesaturateColorDirective(amount));

  T tint(int amount) => directive(TintColorDirective(amount));

  T shade(int amount) => directive(ShadeColorDirective(amount));

  T brighten(int amount) => directive(BrightenColorDirective(amount));
}

/// Utility for predefined colors (e.g., Colors.red)
@immutable
class FoundationColorUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Color>
    with ColorDirectiveMixin<T> {
  final Color color;
  const FoundationColorUtility(super.builder, this.color);
}

/// Callable color utility that supports both function call and property access
/// This utility can be called as a function to return a StyleElement,
/// or accessed as a property to get the Color value.
@immutable
class CallableColorUtility<T extends SpecAttribute<Object?>> {
  final T Function(Prop<Color>) builder;
  final Color color;

  const CallableColorUtility(this.builder, this.color);

  /// Call operator to make this utility callable as a function
  /// Usage: colorUtil.black() returns T that resolves to Colors.black
  T call() => builder(Prop(color));

  /// Directive methods for color transformations
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
final class ColorUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Color>
    with ColorDirectiveMixin<T>, ColorsUtilityMixin<T>, BasicColorsMixin<T> {
  ColorUtility(super.builder);

  /// @deprecated Use [token] instead
  @Deprecated('Use token() instead. Will be removed in a future version.')
  T ref(MixToken<Color> ref) => token(ref);
}

mixin BasicColorsMixin<T extends SpecAttribute<Object?>>
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
