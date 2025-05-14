import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/theme/remix_theme.dart';
import '../../../helpers/object_ext.dart';
import '../../../helpers/overlay.dart';

part 'dropdown_menu.g.dart';
part 'dropdown_menu_style.dart';
part 'dropdown_menu_widget.dart';
part 'item/dropdown_menu.dart';
part 'item/dropdown_menu_widget.dart';

@MixableSpec()
class DropdownMenuSpec extends Spec<DropdownMenuSpec>
    with _$DropdownMenuSpec, Diagnosticable {
  @MixableField(
    dto: MixableFieldType(type: 'DropdownMenuContainerSpecAttribute'),
  )
  final DropdownMenuContainerSpec menu;

  @MixableField(
    dto: MixableFieldType(type: 'DropdownMenuItemSpecAttribute'),
  )
  final DropdownMenuItemSpec item;

  /// {@macro select_spec_of}
  static const of = _$DropdownMenuSpec.of;

  static const from = _$DropdownMenuSpec.from;

  const DropdownMenuSpec({
    DropdownMenuContainerSpec? menu,
    DropdownMenuItemSpec? item,
    super.modifiers,
    super.animated,
  })  : item = item ?? const DropdownMenuItemSpec(),
        menu = menu ?? const DropdownMenuContainerSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

@MixableSpec()
base class DropdownMenuContainerSpec extends Spec<DropdownMenuContainerSpec>
    with _$DropdownMenuContainerSpec, Diagnosticable {
  final FlexBoxSpec container;
  final bool autoWidth;

  /// {@macro select_menu_spec_of}
  static const of = _$DropdownMenuContainerSpec.of;

  static const from = _$DropdownMenuContainerSpec.from;

  const DropdownMenuContainerSpec({
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
