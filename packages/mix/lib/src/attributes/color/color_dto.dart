import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../core/factory/mix_data.dart';
import '../../theme/tokens/color_token.dart';
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
class ColorMix extends Mixable<Color> with Diagnosticable {
  final Color? value;
  final List<ColorDirective> directives;

  const ColorMix.raw({this.value, this.directives = const []});
  const ColorMix(Color value) : this.raw(value: value);

  ColorMix.directive(ColorDirective directive)
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
  ColorMix merge(ColorMix? other) {
    if (other == null) return this;

    return ColorMix.raw(
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
  ColorMix toDto() => ColorMix(this);
}
