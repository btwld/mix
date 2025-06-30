// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/element.dart';
import '../../core/factory/mix_context.dart';
import '../../core/modifier.dart';
import '../../core/utility.dart';

part 'reset_modifier.g.dart';

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class ResetModifierSpec extends WidgetModifierSpec<ResetModifierSpec>
    with _$ResetModifierSpec, Diagnosticable {
  const ResetModifierSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  Widget build(Widget child) {
    return child;
  }
}

final class ResetModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, ResetModifierSpecAttribute> {
  const ResetModifierSpecUtility(super.builder);
  T call() {
    return builder(const ResetModifierSpecAttribute());
  }
}
