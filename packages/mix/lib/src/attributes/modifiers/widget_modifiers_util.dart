import '../../core/element.dart';
import '../../core/modifier.dart';
import '../../modifiers/internal/reset_modifier.dart';
import '../../modifiers/widget_modifiers_util.dart';
import 'widget_modifiers_data_dto.dart';

final class SpecModifierUtility<T extends StyleElement>
    extends ModifierUtility<T, WidgetModifiersDataDto> {
  late final resetModifiers = ResetModifierSpecUtility(only);

  SpecModifierUtility(super.builder);

  @override
  T only(WidgetModifierSpecAttribute attribute) {
    return builder(WidgetModifiersDataDto([attribute]));
  }
}
