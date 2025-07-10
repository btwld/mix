import 'package:flutter/material.dart';

import '../../core/mix_element.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import 'color_extensions.dart';
import 'material_colors_util.dart';

/// Base utility for color operations
@immutable
abstract base class BaseColorUtility<T extends StyleElement>
    extends MixUtility<T, Color> {
  const BaseColorUtility(super.builder);

  T _buildColor(Color color) => builder(color);
}

/// Mixin that provides color directive methods
base mixin ColorDirectiveMixin<T extends StyleElement> on BaseColorUtility<T> {
  /// Abstract method that subclasses must implement to handle directives and tokens
  T only({
    Color? color,
    MixableToken<Color>? token,
    List<MixDirective<Color>>? directives,
  });

  // All directive methods use the same pattern
  T withOpacity(double opacity) => only(
    directives: [
      MixDirective(
        (color) => color.withValues(alpha: opacity),
        debugLabel: 'opacity($opacity)',
      ),
    ],
  );

  T withAlpha(int alpha) => only(
    directives: [
      MixDirective(
        (color) => color.withAlpha(alpha),
        debugLabel: 'alpha($alpha)',
      ),
    ],
  );

  T darken(int amount) => only(
    directives: [
      MixDirective(
        (color) => color.darken(amount),
        debugLabel: 'darken($amount)',
      ),
    ],
  );

  T lighten(int amount) => only(
    directives: [
      MixDirective(
        (color) => color.lighten(amount),
        debugLabel: 'lighten($amount)',
      ),
    ],
  );

  T saturate(int amount) => only(
    directives: [
      MixDirective(
        (color) => color.saturate(amount),
        debugLabel: 'saturate($amount)',
      ),
    ],
  );

  T desaturate(int amount) => only(
    directives: [
      MixDirective(
        (color) => color.desaturate(amount),
        debugLabel: 'desaturate($amount)',
      ),
    ],
  );

  T tint(int amount) => only(
    directives: [
      MixDirective((color) => color.tint(amount), debugLabel: 'tint($amount)'),
    ],
  );

  T shade(int amount) => only(
    directives: [
      MixDirective(
        (color) => color.shade(amount),
        debugLabel: 'shade($amount)',
      ),
    ],
  );

  T brighten(int amount) => only(
    directives: [
      MixDirective(
        (color) => color.brighten(amount),
        debugLabel: 'brighten($amount)',
      ),
    ],
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
  T only({
    Color? color,
    MixableToken<Color>? token,
    List<MixDirective<Color>>? directives,
  }) {
    // For now, just use the provided color or the foundation color
    return _buildColor(color ?? this.color);
  }
}

@immutable
final class ColorUtility<T extends StyleElement> extends BaseColorUtility<T>
    with ColorDirectiveMixin<T>, MaterialColorsMixin<T>, BasicColorsMixin<T> {
  ColorUtility(super.builder);

  /// @deprecated Use [token] instead
  @Deprecated('Use token() instead. Will be removed in a future version.')
  T ref(MixableToken<Color> ref) => token(ref);

  T token(MixableToken<Color> token) => only(token: token);

  T call(Color value) => _buildColor(value);

  @override
  T only({
    Color? color,
    MixableToken<Color>? token,
    List<MixDirective<Color>>? directives,
  }) {
    if (color == null && token == null && directives == null) {
      throw UnsupportedError(
        'ColorUtility requires a color value, token, or directives.',
      );
    }

    // For now, we only support direct color values
    // TODO: Add support for tokens and directives once the infrastructure is ready
    if (color != null) {
      return builder(color);
    }

    // Temporary: tokens and directives not yet supported
    throw UnsupportedError('Token and directives-only color not yet supported');
  }
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
