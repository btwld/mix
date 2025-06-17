import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/theme/remix_theme.dart';
import '../../feedback/toast/toast.dart';

part 'scaffold.g.dart';
part 'scaffold_style.dart';
part 'scaffold_widget.dart';

@MixableSpec()
base class ScaffoldSpec extends Spec<ScaffoldSpec>
    with _$ScaffoldSpec, Diagnosticable {
  final BoxSpec container;

  /// {@macro scaffold_spec_of}
  static const of = _$ScaffoldSpec.of;

  static const from = _$ScaffoldSpec.from;

  const ScaffoldSpec({BoxSpec? container, super.animated, super.modifiers})
      : container = container ?? const BoxSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
