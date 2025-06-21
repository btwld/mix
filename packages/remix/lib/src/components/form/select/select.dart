library remix_select;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/experimental.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:naked/naked.dart';

import '../../../core/attributes/icon_theme_data.dart';
import '../../../core/style_scope.dart';
import '../../../helpers/mix_controller_mixin.dart';
import '../../../helpers/remix_builder.dart';
import '../../../helpers/spec/composited_transform_follower_spec.dart';

part 'select.g.dart';
part 'select_style.dart';
part 'select_widget.dart';

@MixableSpec()
class SelectSpec extends Spec<SelectSpec> with _$SelectSpec, Diagnosticable {
  @MixableField(dto: MixableFieldType(type: 'SelectTriggerSpecAttribute'))
  final SelectTriggerSpec trigger;

  final BoxSpec menuContainer;

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
    SelectTriggerSpec? trigger,
    BoxSpec? menuContainer,
    SelectMenuItemSpec? item,
    CompositedTransformFollowerSpec? position,
    super.modifiers,
    super.animated,
  })  : trigger = trigger ?? const SelectTriggerSpec(),
        item = item ?? const SelectMenuItemSpec(),
        menuContainer = menuContainer ?? const BoxSpec(),
        position = position ?? const CompositedTransformFollowerSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

@MixableSpec()
base class SelectMenuItemSpec extends Spec<SelectMenuItemSpec>
    with _$SelectMenuItemSpec, Diagnosticable {
  final IconSpec icon;
  final TextSpec text;
  final FlexBoxSpec container;

  static const of = _$SelectMenuItemSpec.of;

  static const from = _$SelectMenuItemSpec.from;

  const SelectMenuItemSpec({
    IconSpec? icon,
    TextSpec? text,
    FlexBoxSpec? container,
    super.modifiers,
    super.animated,
  })  : icon = icon ?? const IconSpec(),
        text = text ?? const TextSpec(),
        container = container ?? const FlexBoxSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

@MixableSpec(methods: GeneratedSpecMethods.skipLerp)
class SelectTriggerSpec extends Spec<SelectTriggerSpec>
    with _$SelectTriggerSpec, Diagnosticable {
  final FlexBoxSpec container;
  final TextSpec label;

  @MixableField(
    dto: MixableFieldType(type: 'IconThemeDataDto'),
    utilities: [MixableFieldUtility(type: 'IconThemeDataUtility')],
  )
  final IconThemeData icon;

  /// {@macro select_button_spec_of}
  static const of = _$SelectTriggerSpec.of;

  static const from = _$SelectTriggerSpec.from;

  const SelectTriggerSpec({
    FlexBoxSpec? container,
    IconThemeData? icon,
    TextSpec? label,
    super.modifiers,
    super.animated,
  })  : container = container ?? const FlexBoxSpec(),
        icon = icon ?? const IconThemeData(),
        label = label ?? const TextSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  SelectTriggerSpec lerp(SelectTriggerSpec? other, double t) {
    if (other == null) return _$this;

    return SelectTriggerSpec(
      container: _$this.container.lerp(other.container, t),
      icon: IconThemeData.lerp(_$this.icon, other.icon, t),
      label: _$this.label.lerp(other.label, t),
      modifiers: other.modifiers,
      animated: _$this.animated ?? other.animated,
    );
  }
}
