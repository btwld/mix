import 'package:flutter/material.dart';

import '../../core/element.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import 'color_extensions.dart';
import 'material_colors_util.dart';

/// Base utility for color operations
@immutable
abstract base class BaseColorUtility<T extends StyleElement>
    extends DtoUtility<T, Mix<Color>, Color> {
  const BaseColorUtility(super.builder) : super(valueToDto: Mix.value);

  T _buildColor(Color color) => builder(Mix.value(color));
}

/// Mixin that provides color directive methods
base mixin ColorDirectiveMixin<T extends StyleElement> on BaseColorUtility<T> {
  /// Helper method to create a directive-only Mixable
  T _directive(MixDirective<Color> directive) {
    // Create a composite with no items, only directives
    return builder(Mix.composite([], directives: [directive]));
  }

  // All directive methods use the same pattern
  T withOpacity(double opacity) => _directive(
    MixDirective(
      (color) => color.withValues(alpha: opacity),
      debugLabel: 'opacity($opacity)',
    ),
  );

  T withAlpha(int alpha) => _directive(
    MixDirective(
      (color) => color.withAlpha(alpha),
      debugLabel: 'alpha($alpha)',
    ),
  );

  T darken(int amount) => _directive(
    MixDirective(
      (color) => color.darken(amount),
      debugLabel: 'darken($amount)',
    ),
  );

  T lighten(int amount) => _directive(
    MixDirective(
      (color) => color.lighten(amount),
      debugLabel: 'lighten($amount)',
    ),
  );

  T saturate(int amount) => _directive(
    MixDirective(
      (color) => color.saturate(amount),
      debugLabel: 'saturate($amount)',
    ),
  );

  T desaturate(int amount) => _directive(
    MixDirective(
      (color) => color.desaturate(amount),
      debugLabel: 'desaturate($amount)',
    ),
  );

  T tint(int amount) => _directive(
    MixDirective((color) => color.tint(amount), debugLabel: 'tint($amount)'),
  );

  T shade(int amount) => _directive(
    MixDirective((color) => color.shade(amount), debugLabel: 'shade($amount)'),
  );

  T brighten(int amount) => _directive(
    MixDirective(
      (color) => color.brighten(amount),
      debugLabel: 'brighten($amount)',
    ),
  );
}

/// Utility for predefined colors (e.g., Colors.red)
@immutable
base class FoundationColorUtility<T extends StyleElement, C extends Color>
    extends BaseColorUtility<T>
    with ColorDirectiveMixin<T> {
  final C color;
  const FoundationColorUtility(super.builder, this.color);

  T call([Color? value]) => _buildColor(value ?? color);

  @override
  T only() => _buildColor(color);
}

@immutable
final class ColorUtility<T extends StyleElement> extends BaseColorUtility<T>
    with ColorDirectiveMixin<T>, MaterialColorsMixin<T>, BasicColorsMixin<T> {
  ColorUtility(super.builder);

  /// @deprecated Use [token] instead
  @Deprecated('Use token() instead. Will be removed in a future version.')
  T ref(MixableToken<Color> ref) => token(ref);

  T token(MixableToken<Color> token) => builder(Mix.token(token));

  T call(Color value) => _buildColor(value);

  @override
  T only() => throw UnsupportedError(
    'ColorUtility requires a color value. Use call() or a predefined color.',
  );
}

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
