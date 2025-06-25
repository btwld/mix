import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/attributes/icon_theme_data.dart';
import '../../../helpers/utility_extension.dart';

part 'avatar.g.dart';
part 'avatar_style.dart';
part 'avatar_widget.dart';

@MixableSpec(methods: GeneratedSpecMethods.skipLerp)
base class AvatarSpec extends Spec<AvatarSpec> with _$AvatarSpec {
  final BoxSpec container;
  final TextStyle textStyle;

  @MixableField(
    dto: MixableFieldType(type: 'IconThemeDataDto'),
    utilities: [MixableFieldUtility(type: 'IconThemeDataUtility')],
  )
  final IconThemeData icon;

  /// {@macro avatar_spec_of}
  static const of = _$AvatarSpec.of;

  static const from = _$AvatarSpec.from;

  const AvatarSpec({
    BoxSpec? container,
    TextStyle? textStyle,
    IconThemeData? icon,
    super.animated,
  })  : container = container ?? const BoxSpec(),
        textStyle = textStyle ?? const TextStyle(),
        icon = icon ?? const IconThemeData();

  /// Linearly interpolates between this [AvatarSpec] and another [AvatarSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [AvatarSpec] is returned. When [t] is 1.0, the [other] [AvatarSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [AvatarSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [AvatarSpec] instance.
  ///
  /// The interpolation is performed on each property of the [AvatarSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [container].
  /// - [MixHelpers.lerpTextStyle] for [textStyle].
  /// - [IconThemeData.lerp] for [icon].
  /// For [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [AvatarSpec] is used. Otherwise, the value
  /// from the [other] [AvatarSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [AvatarSpec] configurations.
  @override
  AvatarSpec lerp(AvatarSpec? other, double t) {
    if (other == null) return _$this;

    return AvatarSpec(
      container: _$this.container.lerp(other.container, t),
      textStyle:
          MixHelpers.lerpTextStyle(_$this.textStyle, other.textStyle, t)!,
      icon: IconThemeData.lerp(_$this.icon, other.icon, t),
      animated: _$this.animated ?? other.animated,
    );
  }
}
