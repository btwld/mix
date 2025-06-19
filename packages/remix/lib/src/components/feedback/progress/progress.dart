import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'progress.g.dart';
part 'progress_style.dart';
part 'progress_widget.dart';

@MixableSpec()
base class ProgressSpec extends Spec<ProgressSpec>
    with _$ProgressSpec, Diagnosticable {
  final BoxSpec container;
  final BoxSpec track;
  final BoxSpec fill;
  final BoxSpec outerContainer;

  /// {@macro progress_spec_of}
  static const of = _$ProgressSpec.of;

  static const from = _$ProgressSpec.from;

  const ProgressSpec({
    BoxSpec? container,
    BoxSpec? track,
    BoxSpec? fill,
    BoxSpec? outerContainer,
    super.animated,
    super.modifiers,
  })  : container = container ?? const BoxSpec(),
        track = track ?? const BoxSpec(),
        fill = fill ?? const BoxSpec(),
        outerContainer = outerContainer ?? const BoxSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
