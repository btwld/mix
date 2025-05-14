import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/theme/remix_theme.dart';

part 'slider.g.dart';
part 'slider_style.dart';
part 'slider_widget.dart';

@MixableSpec()
class SliderSpec extends Spec<SliderSpec> with _$SliderSpec, Diagnosticable {
  final BoxSpec thumb;
  final BoxSpec track;
  final BoxSpec activeTrack;
  final BoxSpec division;

  /// {@macro button_spec_of}
  static const of = _$SliderSpec.of;

  static const from = _$SliderSpec.from;

  SliderSpec({
    BoxSpec? thumb,
    BoxSpec? track,
    BoxSpec? activeTrack,
    BoxSpec? division,
    super.modifiers,
    super.animated,
  })  : thumb = thumb ?? const BoxSpec(),
        track = track ?? const BoxSpec(),
        activeTrack = activeTrack ?? const BoxSpec(),
        division = division ?? const BoxSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
