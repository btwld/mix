import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../core/factory/mix_data.dart';
import '../../theme/tokens/mix_token.dart';
import 'color_directives.dart';
import 'color_directives_impl.dart';

/// A Data transfer object that represents a [Color] value.
///
/// This DTO is used to resolve a [Color] value from a [MixData] instance.
/// It can hold either a direct color value or a token reference.
///
/// See also:
/// * [Token], which is used to reference theme values.
/// * [Color], which is the Flutter equivalent class.
/// {@category DTO}
@immutable
class ColorDto extends Mixable<Color> with Diagnosticable {
  final Color? value;
  final MixToken<Color>? token;
  final List<ColorDirective> directives;

  const ColorDto.raw({this.value, this.token, this.directives = const []});
  const ColorDto(Color value) : this.raw(value: value);

  factory ColorDto.token(MixToken<Color> token) => ColorDto.raw(token: token);

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
    Color color;

    // Type-safe, direct token resolution using MixToken object
    if (token != null) {
      color = mix.tokens.resolveToken<Color>(token!);
    } else {
      color = value ?? defaultColor;
    }

    // Apply directives
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

    final color = value ?? defaultColor;
    properties.add(ColorProperty('color', color));
  }

  @override
  List<Object?> get props => [value, token, directives];
}

extension ColorExt on Color {
  ColorDto toDto() => ColorDto(this);
}
