import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/theme/remix_theme.dart';
import '../../../helpers/object_ext.dart';
import '../../../helpers/overlay.dart';
import '../../../helpers/spec/composited_transform_follower_spec.dart';

part 'item/select_menu.dart';
part 'item/select_menu_widget.dart';
part 'select.g.dart';
part 'select_style.dart';
part 'select_widget.dart';
part 'trigger/select_trigger.dart';
part 'trigger/select_trigger_widget.dart';

@MixableSpec()
class SelectSpec extends Spec<SelectSpec> with _$SelectSpec, Diagnosticable {
  @MixableField(dto: MixableFieldType(type: 'SelectTriggerSpecAttribute'))
  final SelectTriggerSpec button;

  @MixableField(dto: MixableFieldType(type: 'SelectMenuSpecAttribute'))
  final SelectMenuSpec menu;

  @MixableField(dto: MixableFieldType(type: 'SelectMenuItemSpecAttribute'))
  final SelectMenuItemSpec item;

  @MixableField(
    dto: MixableFieldType(type: 'CompositedTransformFollowerSpecAttribute'),
  )
  final CompositedTransformFollowerSpec position;

  /// {@macro select_spec_of}
  static const of = _$SelectSpec.of;

  static const from = _$SelectSpec.from;

  const SelectSpec({
    SelectTriggerSpec? button,
    SelectMenuSpec? menu,
    SelectMenuItemSpec? item,
    CompositedTransformFollowerSpec? position,
    super.modifiers,
    super.animated,
  })  : button = button ?? const SelectTriggerSpec(),
        item = item ?? const SelectMenuItemSpec(),
        menu = menu ?? const SelectMenuSpec(),
        position = position ?? const CompositedTransformFollowerSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

@MixableSpec()
base class SelectMenuSpec extends Spec<SelectMenuSpec>
    with _$SelectMenuSpec, Diagnosticable {
  final FlexBoxSpec container;
  final bool autoWidth;

  /// {@macro select_menu_spec_of}
  static const of = _$SelectMenuSpec.of;

  static const from = _$SelectMenuSpec.from;

  const SelectMenuSpec({
    FlexBoxSpec? container,
    bool? autoWidth,
    super.modifiers,
    super.animated,
  })  : container = container ?? const FlexBoxSpec(),
        autoWidth = autoWidth ?? true;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
