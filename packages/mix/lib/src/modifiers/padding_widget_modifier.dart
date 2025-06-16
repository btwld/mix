// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../attributes/spacing/edge_insets_dto.dart';
import '../attributes/spacing/spacing_util.dart';
import '../core/element.dart';
import '../core/factory/mix_data.dart';
import '../core/modifier.dart';
import '../core/spec.dart';

part 'padding_widget_modifier.g.dart';

@MixableSpec()
final class PaddingModifierSpec extends WidgetModifierSpec<PaddingModifierSpec>
    with _$PaddingModifierSpec, Diagnosticable {
  final EdgeInsetsGeometry padding;

  const PaddingModifierSpec([EdgeInsetsGeometry? padding])
      : padding = padding ?? EdgeInsets.zero;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  Widget build(Widget child) {
    return Padding(padding: padding, child: child);
  }
}
