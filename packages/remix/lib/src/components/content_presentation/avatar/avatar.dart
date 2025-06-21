import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../helpers/utility_extension.dart';

part 'avatar.g.dart';
part 'avatar_style.dart';
part 'avatar_widget.dart';

@MixableSpec()
base class AvatarSpec extends Spec<AvatarSpec> with _$AvatarSpec {
  final BoxSpec container;
  final ImageSpec image;
  final TextStyle textStyle;

  /// {@macro avatar_spec_of}
  static const of = _$AvatarSpec.of;

  static const from = _$AvatarSpec.from;

  const AvatarSpec({
    BoxSpec? container,
    TextStyle? textStyle,
    ImageSpec? image,
    super.animated,
  })  : container = container ?? const BoxSpec(),
        textStyle = textStyle ?? const TextStyle(),
        image = image ?? const ImageSpec();
}
