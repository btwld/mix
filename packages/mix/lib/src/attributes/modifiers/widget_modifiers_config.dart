import '../../core/modifier.dart';

@Deprecated(
  'Use WidgetModifiersConfig instead. This will be removed in version 2.0',
)
typedef WidgetModifiersData = WidgetModifiersConfig;

class WidgetModifiersConfig {
  // ignore: avoid-dynamic
  final List<WidgetModifierSpec<dynamic>> value;
  const WidgetModifiersConfig(this.value);
}
