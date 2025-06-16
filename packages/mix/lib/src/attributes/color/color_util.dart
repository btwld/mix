import 'package:flutter/material.dart';

import '../../core/element.dart';
import '../../core/utility.dart';
import '../../theme/tokens/color_token.dart';
import 'color_directives.dart';
import 'color_directives_impl.dart';
import 'color_dto.dart';
import 'material_colors_util.dart';

@immutable
abstract base class BaseColorUtility<T extends StyleElement>
    extends MixUtility<T, ColorDto> {
  const BaseColorUtility(super.builder);

  T _buildColor(Color color) => builder(ColorDto(color));
}

@immutable
base class FoundationColorUtility<T extends StyleElement, C extends Color>
    extends BaseColorUtility<T> with ColorDirectiveMixin<T> {
  final C color;
  const FoundationColorUtility(super.builder, this.color);

  T call() => _buildColor(color);
  @override
  T directive(ColorDirective directive) =>
      builder(ColorDto.raw(value: color, directives: [directive]));
}

/// A utility class for building [StyleElement] instances from a list of [ColorDto] objects.
///
/// This class extends [MixUtility] and provides a convenient way to create [StyleElement]
/// instances by transforming a list of [Color] objects into a list of [ColorDto] objects.
final class ColorListUtility<T extends StyleElement>
    extends MixUtility<T, List<ColorDto>> {
  const ColorListUtility(super.builder);

  /// Creates an [StyleElement] instance from a list of [Color] objects.
  ///
  /// This method maps each [Color] object to a [ColorDto] object and passes the
  /// resulting list to the [builder] function to create the [StyleElement] instance.
  T call(List<Color> colors) {
    return builder(colors.map((e) => e.toDto()).toList());
  }
}

@immutable
final class ColorUtility<T extends StyleElement> extends BaseColorUtility<T>
    with ColorDirectiveMixin<T>, MaterialColorsMixin<T>, BasicColorsMixin<T> {
  ColorUtility(super.builder);

  T ref(ColorToken ref) => _buildColor(ref());

  T call(Color color) => _buildColor(color);
}

typedef ColorModifier = Color Function(Color);

base mixin BasicColorsMixin<T extends StyleElement> on BaseColorUtility<T> {
  late final transparent = FoundationColorUtility(builder, Colors.transparent);

  late final black = FoundationColorUtility(builder, Colors.black);

  late final black87 = FoundationColorUtility(builder, Colors.black87);

  late final black54 = FoundationColorUtility(builder, Colors.black54);

  late final black45 = FoundationColorUtility(builder, Colors.black45);

  late final black38 = FoundationColorUtility(builder, Colors.black38);

  late final black26 = FoundationColorUtility(builder, Colors.black26);

  late final black12 = FoundationColorUtility(builder, Colors.black12);

  late final white = FoundationColorUtility(builder, Colors.white);

  late final white70 = FoundationColorUtility(builder, Colors.white70);

  late final white60 = FoundationColorUtility(builder, Colors.white60);

  late final white54 = FoundationColorUtility(builder, Colors.white54);

  late final white38 = FoundationColorUtility(builder, Colors.white38);

  late final white30 = FoundationColorUtility(builder, Colors.white30);

  late final white24 = FoundationColorUtility(builder, Colors.white24);

  late final white12 = FoundationColorUtility(builder, Colors.white12);

  late final white10 = FoundationColorUtility(builder, Colors.white10);
}

base mixin ColorDirectiveMixin<T extends StyleElement> on BaseColorUtility<T> {
  T directive(ColorDirective directive) =>
      builder(ColorDto.directive(directive));
  T withOpacity(double opacity) => directive(OpacityColorDirective(opacity));
  T withAlpha(int alpha) => directive(AlphaColorDirective(alpha));
  T darken(int percentage) => directive(DarkenColorDirective(percentage));
  T lighten(int percentage) => directive(LightenColorDirective(percentage));
  T saturate(int percentage) => directive(SaturateColorDirective(percentage));
  T desaturate(int percentage) =>
      directive(DesaturateColorDirective(percentage));
  T tint(int percentage) => directive(TintColorDirective(percentage));
  T shade(int percentage) => directive(ShadeColorDirective(percentage));
  T brighten(int percentage) => directive(BrightenColorDirective(percentage));
  T resetDirectives() => directive(const ResetColorDirective());

  T withSaturation(double saturation) => directive(
        SaturationColorDirective(saturation),
      );

  T withLightness(double lightness) => directive(
        LightnessColorDirective(lightness),
      );
  T withHue(double hue) => directive(HueColorDirective(hue));
  T withValue(double value) => directive(ValueColorDirective(value));
}
