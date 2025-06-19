import '../../core/theme/component.dart';
import 'components/badge_theme.dart';

import 'components/dialog_theme.dart';
import 'components/divider_theme.dart';
import 'components/dropdown_theme.dart';
import 'components/header_theme.dart';
import 'components/scaffold_theme.dart';
import 'components/segmented_control_theme.dart';
import 'components/textfield_theme.dart';
import 'components/toast_theme.dart';

class FortalezaComponentTheme extends RemixComponentTheme {
  const FortalezaComponentTheme({
    required super.badge,
    // required super.button,
    required super.dialog,
    required super.divider,
    required super.header,
    required super.scaffold,
    required super.segmentedControl,
    required super.textField,
    required super.toast,
    required super.dropdownMenu,
  });

  static RemixComponentTheme light() {
    return const FortalezaComponentTheme(
      badge: FortalezaBadgeStyle(),
      dialog: FortalezaDialogStyle(),
      divider: FortalezaDividerStyle(),
      header: FortalezaHeaderStyle(),
      scaffold: FortalezaScaffoldStyle(),
      segmentedControl: FortalezaSegmentedControlStyle(),
      textField: FortalezaTextFieldStyle(),
      toast: FortalezaToastStyle(),
      dropdownMenu: FortalezaDropdownMenuStyle(),
    );
  }

  static RemixComponentTheme dark() {
    return FortalezaComponentTheme.light().copyWith(
      badge: const FortalezaDarkBadgeStyle(),
      segmentedControl: const FortalezaDarkSegmentedControlStyle(),
    );
  }
}
