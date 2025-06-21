import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:naked/naked.dart';

import '../../../core/attributes/icon_theme_data.dart';
import '../../../helpers/mix_controller_mixin.dart';
import '../../../helpers/remix_builder.dart';
import '../../content_presentation/label/label.dart';
import '../../feedback/spinner/spinner.dart';

part 'button.g.dart';
part 'button_style.dart';
part 'button_widget.dart';

@MixableSpec(methods: GeneratedSpecMethods.skipLerp)
base class ButtonSpec extends Spec<ButtonSpec>
    with _$ButtonSpec, Diagnosticable {
  final BoxSpec container;

  @MixableField(
    dto: MixableFieldType(type: 'IconThemeDataDto'),
    utilities: [MixableFieldUtility(type: 'IconThemeDataUtility')],
  )
  final IconThemeData icon;
  final TextStyle textStyle;

  @MixableField(dto: MixableFieldType(type: 'SpinnerSpecAttribute'))
  final SpinnerSpec spinner;

  /// {@macro button_spec_of}
  static const of = _$ButtonSpec.of;

  static const from = _$ButtonSpec.from;

  const ButtonSpec({
    BoxSpec? container,
    IconThemeData? icon,
    TextStyle? textStyle,
    super.modifiers,
    SpinnerSpec? spinner,
    super.animated,
  })  : container = container ?? const BoxSpec(),
        icon = icon ?? const IconThemeData(),
        textStyle = textStyle ?? const TextStyle(),
        spinner = spinner ?? const SpinnerSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  /// Linearly interpolates between this [ButtonSpec] and another [ButtonSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ButtonSpec] is returned. When [t] is 1.0, the [other] [ButtonSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ButtonSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ButtonSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ButtonSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [container].
  /// - [IconThemeData.lerp] for [icon].
  /// - [MixHelpers.lerpTextStyle] for [textStyle].
  /// - [SpinnerSpec.lerp] for [spinner].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ButtonSpec] is used. Otherwise, the value
  /// from the [other] [ButtonSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ButtonSpec] configurations.
  @override
  ButtonSpec lerp(ButtonSpec? other, double t) {
    if (other == null) return _$this;

    return ButtonSpec(
      container: _$this.container.lerp(other.container, t),
      icon: IconThemeData.lerp(_$this.icon, other.icon, t),
      textStyle:
          MixHelpers.lerpTextStyle(_$this.textStyle, other.textStyle, t)!,
      modifiers: other.modifiers,
      spinner: _$this.spinner.lerp(other.spinner, t),
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }
}
