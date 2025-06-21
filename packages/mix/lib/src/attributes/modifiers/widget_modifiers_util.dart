import '../../core/modifier.dart';
import '../../core/spec.dart';
import '../../modifiers/internal/reset_modifier.dart';
import '../../modifiers/widget_modifiers_util.dart';
import 'widget_modifiers_config_dto.dart';

final class SpecModifierUtility<T extends SpecAttribute>
    extends ModifierUtility<T, WidgetModifiersConfigDto> {
  late final resetModifiers = ResetModifierSpecUtility(only);

  SpecModifierUtility(super.builder);

  @override
  T only(WidgetModifierSpecAttribute attribute) {
    return builder(WidgetModifiersConfigDto([attribute]));
  }
}
