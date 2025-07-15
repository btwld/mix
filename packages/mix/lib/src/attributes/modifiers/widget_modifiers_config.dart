import '../../core/modifier.dart';
import '../../internal/compare_mixin.dart';

class WidgetModifiersConfig with EqualityMixin {
  // ignore: avoid-dynamic
  final List<WidgetModifierSpec<dynamic>> value;
  const WidgetModifiersConfig(this.value);

  @override
  List<Object?> get props => [value];
}
