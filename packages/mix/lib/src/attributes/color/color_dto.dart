import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../core/factory/mix_data.dart';
import '../../theme/tokens/color_token.dart';
import 'color_directives.dart';
import 'color_directives_impl.dart';

/// A Data transfer object that represents a [Color] value.
///
/// This DTO is used to resolve a [Color] value from a [MixContext] instance.
///
/// See also:
/// * [ColorToken], which is used to resolve a [Color] value from a [MixContext] instance.
/// * [ColorRef], which is used to reference a [Color] value from a [MixContext] instance.
/// * [Color], which is the Flutter equivalent class.
/// {@category DTO}
@immutable
class ColorDto extends Mixable<Color> {
  final Color? value;
  final List<ColorDirective> directives;

  const ColorDto.raw({this.value, this.directives = const []});
  const ColorDto(Color value) : this.raw(value: value);

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
  Color resolve(MixContext mix) {
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
      directives: _applyResetIfNeeded([...directives, ...other.directives]),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    Color color = value ?? defaultColor;

    if (color is ColorRef) {
      properties.add(DiagnosticsProperty('token', color.token.name));
    }

    properties.add(ColorProperty('color', color));
  }

  @override
  List<Object?> get props => [value, directives];
}

extension ColorExt on Color {
  ColorDto toDto() => ColorDto(this);
}
