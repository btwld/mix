import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/experimental.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:naked/naked.dart';

part 'tooltip.g.dart';
part 'tooltip_style.dart';
part 'tooltip_widget.dart';

@MixableSpec()
base class TooltipSpec extends Spec<TooltipSpec>
    with _$TooltipSpec, Diagnosticable {
  final BoxSpec container;

  /// {@macro tooltip_spec_of}
  static const of = _$TooltipSpec.of;

  static const from = _$TooltipSpec.from;

  const TooltipSpec({BoxSpec? container, super.modifiers, super.animated})
      : container = container ?? const BoxSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
