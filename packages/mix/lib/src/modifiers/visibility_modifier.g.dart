// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visibility_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

class VisibilityModifierMix extends ModifierMix<VisibilityModifier>
    with Diagnosticable {
  final Prop<bool>? visible;

  const VisibilityModifierMix.create({this.visible});

  VisibilityModifierMix({bool? visible})
    : this.create(visible: Prop.maybe(visible));

  @override
  VisibilityModifier resolve(BuildContext context) {
    return VisibilityModifier(MixOps.resolve(context, visible));
  }

  @override
  VisibilityModifierMix merge(VisibilityModifierMix? other) {
    if (other == null) return this;

    return VisibilityModifierMix.create(
      visible: MixOps.merge(visible, other.visible),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('visible', visible));
  }

  @override
  List<Object?> get props => [visible];
}
