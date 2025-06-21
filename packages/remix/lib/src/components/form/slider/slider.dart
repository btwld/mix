import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:naked/naked.dart';

import '../../../helpers/mix_controller_mixin.dart';
import '../../../helpers/remix_builder.dart';
import '../../../helpers/utility_extension.dart';

part 'slider.g.dart';
part 'slider_style.dart';
part 'slider_widget.dart';

@MixableSpec()
class SliderSpec extends Spec<SliderSpec> with _$SliderSpec, Diagnosticable {
  final BoxSpec thumb;
  final PaintData baseTrack;
  final PaintData activeTrack;
  final PaintData division;

  /// {@macro slider_spec_of}
  static const of = _$SliderSpec.of;

  static const from = _$SliderSpec.from;

  SliderSpec({
    BoxSpec? thumb,
    PaintData? baseTrack,
    PaintData? activeTrack,
    PaintData? division,
    super.modifiers,
    super.animated,
  })  : thumb = thumb ?? const BoxSpec(),
        baseTrack = baseTrack ?? const PaintData(),
        activeTrack = activeTrack ?? const PaintData(),
        division = division ?? const PaintData();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

@MixableSpec()
class PaintData extends Spec<PaintData> with _$PaintData, Diagnosticable {
  final double strokeWidth;
  final Color color;
  final StrokeCap strokeCap;

  /// {@macro paint_data_of}
  static const of = _$PaintData.of;

  static const from = _$PaintData.from;

  const PaintData({double? strokeWidth, Color? color, StrokeCap? strokeCap})
      : strokeWidth = strokeWidth ?? 8,
        color = color ?? Colors.grey,
        strokeCap = strokeCap ?? StrokeCap.round;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
