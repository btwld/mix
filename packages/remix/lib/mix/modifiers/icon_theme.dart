import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../attributes/icon_theme_data.dart';

part 'icon_theme.g.dart';

@MixableSpec()
final class IconThemeModifierSpec
    extends WidgetModifierSpec<IconThemeModifierSpec>
    with _$IconThemeModifierSpec, Diagnosticable {
  @MixableField(
    dto: MixableFieldType(type: 'IconThemeDataDto'),
    utilities: [
      MixableFieldUtility(type: 'IconThemeDataUtility'),
    ],
  )
  final IconThemeData data;

  const IconThemeModifierSpec({IconThemeData? data})
      : data = data ?? const IconThemeData();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  Widget build(Widget child) {
    return IconTheme(
      data: data,
      child: child,
    );
  }
}
