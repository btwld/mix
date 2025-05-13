part of '../dropdown_menu.dart';

@MixableSpec()
class DropdownMenuItemSpec extends Spec<DropdownMenuItemSpec>
    with _$DropdownMenuItemSpec, Diagnosticable {
  final IconSpec icon;
  final TextSpec text;
  final FlexBoxSpec container;

  static const of = _$DropdownMenuItemSpec.of;

  static const from = _$DropdownMenuItemSpec.from;

  const DropdownMenuItemSpec({
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
