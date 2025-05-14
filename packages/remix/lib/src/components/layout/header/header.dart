import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/theme/remix_theme.dart';

part 'header.g.dart';
part 'header_style.dart';
part 'header_widget.dart';

@MixableSpec()
base class HeaderSpec extends Spec<HeaderSpec>
    with _$HeaderSpec, Diagnosticable {
  final FlexBoxSpec container;
  final FlexSpec titleGroup;
  final TextSpec title;
  final TextSpec subtitle;

  /// {@macro header_spec_of}
  static const of = _$HeaderSpec.of;

  static const from = _$HeaderSpec.from;

  const HeaderSpec({
    FlexBoxSpec? container,
    super.modifiers,
    FlexSpec? titleGroup,
    TextSpec? title,
    TextSpec? subtitle,
    super.animated,
  })  : container = container ?? const FlexBoxSpec(),
        titleGroup = titleGroup ?? const FlexSpec(),
        title = title ?? const TextSpec(),
        subtitle = subtitle ?? const TextSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
