import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:naked/naked.dart';

import '../../../helpers/utility_extension.dart';

part 'avatar.g.dart';
part 'avatar_style.dart';
part 'avatar_widget.dart';

@MixableSpec()
base class AvatarSpec extends Spec<AvatarSpec> with _$AvatarSpec {
  final BoxSpec container;
  final StackSpec stack;
  final ImageSpec image;
  final TextStyle fallbackTextStyle;

  /// {@macro avatar_spec_of}
  static const of = _$AvatarSpec.of;

  static const from = _$AvatarSpec.from;

  const AvatarSpec({
    BoxSpec? container,
    ImageSpec? image,
    TextStyle? fallbackTextStyle,
    StackSpec? stack,
    super.animated,
  })  : stack = stack ?? const StackSpec(),
        container = container ?? const BoxSpec(),
        image = image ?? const ImageSpec(),
        fallbackTextStyle = fallbackTextStyle ?? const TextStyle();
}
