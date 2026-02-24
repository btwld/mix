import '../../core/spec.dart';
import '../../core/style.dart';
import '../../modifiers/widget_modifier_config.dart';

/// Provides convenient widget modifier styling methods for spec attributes.
mixin WidgetModifierStyleMixin<T extends Style<S>, S extends Spec<S>>
    on Style<S> {
  /// Applies the given [value] widget modifier configuration.
  T wrap(WidgetModifierConfig value);
}
