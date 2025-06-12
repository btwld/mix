import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../core/factory/mix_data.dart';
import '../../theme/tokens/color_token.dart';
import '../../theme/tokens/token.dart';
import 'color_directives.dart';
import 'color_directives_impl.dart';

/// A Data transfer object that represents a [Color] value.
///
/// This DTO is used to resolve a [Color] value from a [MixData] instance.
///
/// See also:
/// * [ColorToken], which is used to resolve a [Color] value from a [MixData] instance.
/// * [ColorRef], which is used to reference a [Color] value from a [MixData] instance.
/// * [Color], which is the Flutter equivalent class.
/// {@category DTO}
@immutable
class ColorDto extends Mixable<Color> with Diagnosticable {
  final Color? value;
  final Token<Color>? token;
  final List<ColorDirective> directives;

  const ColorDto.raw({this.value, this.token, this.directives = const []});
  const ColorDto(Color value) : this.raw(value: value);

  factory ColorDto.token(Token<Color> token) => ColorDto.raw(token: token);

  ColorDto.directive(ColorDirective directive)
      : this.raw(directives: [directive]);

  List<ColorDirective> _applyResetIfNeeded(List<ColorDirective> directives) {
    final lastResetIndex =
        directives.lastIndexWhere((e) => e is ResetColorDirective);

    return lastResetIndex == -1
        ? directives
        : directives.sublist(lastResetIndex);
  }

  Color get defaultColor => const Color(0x00000000);

  @override
  Color resolve(MixData mix) {
    // Handle token resolution first
    if (token != null) {
      // Resolve through the token resolver using the old token type for compatibility
      final colorToken = ColorToken(token!.name);

      return mix.tokens.colorToken(colorToken);
    }

    Color color = value ?? defaultColor;

    if (color is ColorRef) {
      color = mix.tokens.colorRef(color);
    }

    for (final directive in directives) {
      color = directive.modify(color);
    }

    return color;
  }

  @override
  ColorDto merge(ColorDto? other) {
    if (other == null) return this;

    return ColorDto.raw(
      value: other.value ?? value,
      token: other.token ?? token,
      directives: _applyResetIfNeeded([...directives, ...other.directives]),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    if (token != null) {
      properties.add(DiagnosticsProperty('token', token?.toString()));

      return;
    }

    Color color = value ?? defaultColor;

    if (color is ColorRef) {
      properties.add(DiagnosticsProperty('token', color.token.name));
    }

    properties.add(ColorProperty('color', color));
  }

  @override
  List<Object?> get props => [value, token, directives];
}

extension ColorExt on Color {
  ColorDto toDto() => ColorDto(this);
}
