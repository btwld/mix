import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/theme/remix_theme.dart';

part 'toast.g.dart';
part 'toast_layer.dart';
part 'toast_style.dart';
part 'toast_widget.dart';

@MixableSpec()
base class ToastSpec extends Spec<ToastSpec> with _$ToastSpec, Diagnosticable {
  final FlexBoxSpec container;
  final FlexBoxSpec titleSubtitleContainer;
  final TextSpec title;
  final TextSpec subtitle;

  /// {@macro toast_spec_of}
  static const of = _$ToastSpec.of;

  static const from = _$ToastSpec.from;

  const ToastSpec({
    FlexBoxSpec? container,
    FlexBoxSpec? titleSubtitleContainer,
    TextSpec? title,
    TextSpec? subtitle,
    super.modifiers,
    super.animated,
  })  : container = container ?? const FlexBoxSpec(),
        titleSubtitleContainer = titleSubtitleContainer ?? const FlexBoxSpec(),
        title = title ?? const TextSpec(),
        subtitle = subtitle ?? const TextSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
