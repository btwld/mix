import 'package:flutter/material.dart';

import '../../core/extensions.dart';
import '../../core/mix_element.dart';

/// Base class for color-specific directives
abstract class ColorDirective extends MixDirective<Color> {
  const ColorDirective();
}

/// Directive that applies opacity to a color
class OpacityDirective extends ColorDirective {
  final double opacity;

  const OpacityDirective(this.opacity);

  @override
  Color apply(Color color) => color.withValues(alpha: opacity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpacityDirective && opacity == other.opacity;

  @override
  String get debugLabel => 'opacity($opacity)';

  @override
  int get hashCode => opacity.hashCode;
}

/// Directive that applies alpha to a color
class AlphaDirective extends ColorDirective {
  final int alpha;

  const AlphaDirective(this.alpha);

  @override
  Color apply(Color color) => color.withAlpha(alpha);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AlphaDirective && alpha == other.alpha;

  @override
  String get debugLabel => 'alpha($alpha)';

  @override
  int get hashCode => alpha.hashCode;
}

/// Directive that darkens a color
class DarkenDirective extends ColorDirective {
  final int amount;

  const DarkenDirective(this.amount);

  @override
  Color apply(Color color) => color.darken(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DarkenDirective && amount == other.amount;

  @override
  String get debugLabel => 'darken($amount)';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that lightens a color
class LightenDirective extends ColorDirective {
  final int amount;

  const LightenDirective(this.amount);

  @override
  Color apply(Color color) => color.lighten(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LightenDirective && amount == other.amount;

  @override
  String get debugLabel => 'lighten($amount)';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that saturates a color
class SaturateDirective extends ColorDirective {
  final int amount;

  const SaturateDirective(this.amount);

  @override
  Color apply(Color color) => color.saturate(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaturateDirective && amount == other.amount;

  @override
  String get debugLabel => 'saturate($amount)';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that desaturates a color
class DesaturateDirective extends ColorDirective {
  final int amount;

  const DesaturateDirective(this.amount);

  @override
  Color apply(Color color) => color.desaturate(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesaturateDirective && amount == other.amount;

  @override
  String get debugLabel => 'desaturate($amount)';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that applies tint to a color
class TintDirective extends ColorDirective {
  final int amount;

  const TintDirective(this.amount);

  @override
  Color apply(Color color) => color.tint(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TintDirective && amount == other.amount;

  @override
  String get debugLabel => 'tint($amount)';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that applies shade to a color
class ShadeDirective extends ColorDirective {
  final int amount;

  const ShadeDirective(this.amount);

  @override
  Color apply(Color color) => color.shade(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShadeDirective && amount == other.amount;

  @override
  String get debugLabel => 'shade($amount)';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that brightens a color
class BrightenDirective extends ColorDirective {
  final int amount;

  const BrightenDirective(this.amount);

  @override
  Color apply(Color color) => color.brighten(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrightenDirective && amount == other.amount;

  @override
  String get debugLabel => 'brighten($amount)';

  @override
  int get hashCode => amount.hashCode;
}
