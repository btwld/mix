import '../../core/theme/component.dart';
import 'components/avatar_theme.dart';
import 'components/badge_theme.dart';
import 'components/callout_theme.dart';
import 'components/checkbox_theme.dart';
import 'components/chip_theme.dart';
import 'components/dialog_theme.dart';
import 'components/divider_theme.dart';
import 'components/dropdown_theme.dart';
import 'components/header_theme.dart';
import 'components/menu_item_theme.dart';
import 'components/progress_theme.dart';
import 'components/radio_theme.dart';
import 'components/scaffold_theme.dart';
import 'components/segmented_control_theme.dart';
import 'components/select_theme.dart';
import 'components/slider_theme.dart';
import 'components/spinner_theme.dart';
import 'components/switch_theme.dart';
import 'components/textfield_theme.dart';
import 'components/toast_theme.dart';

class FortalezaComponentTheme extends RemixComponentTheme {
  const FortalezaComponentTheme({
    required super.avatar,
    required super.badge,
    // required super.button,
    required super.callout,
    required super.checkbox,
    required super.dialog,
    required super.chip,
    required super.divider,
    required super.header,
    required super.menuItem,
    required super.progress,
    required super.radio,
    required super.scaffold,
    required super.segmentedControl,
    required super.select,
    required super.spinner,
    required super.switchComponent,
    required super.textField,
    required super.toast,
    required super.slider,
    required super.dropdownMenu,
  });

  static RemixComponentTheme light() {
    return const FortalezaComponentTheme(
      avatar: FortalezaAvatarStyle(),
      badge: FortalezaBadgeStyle(),
      callout: FortalezaCalloutStyle(),
      checkbox: FortalezaCheckboxStyle(),
      dialog: FortalezaDialogStyle(),
      chip: FortalezaChipStyle(),
      divider: FortalezaDividerStyle(),
      header: FortalezaHeaderStyle(),
      menuItem: FortalezaMenuItemStyle(),
      progress: FortalezaProgressStyle(),
      radio: FortalezaRadioStyle(),
      scaffold: FortalezaScaffoldStyle(),
      segmentedControl: FortalezaSegmentedControlStyle(),
      select: FortalezaSelectStyle(),
      spinner: FortalezaSpinnerStyle(),
      switchComponent: FortalezaSwitchStyle(),
      textField: FortalezaTextFieldStyle(),
      toast: FortalezaToastStyle(),
      slider: FortalezaSliderStyle(),
      dropdownMenu: FortalezaDropdownMenuStyle(),
    );
  }

  static RemixComponentTheme dark() {
    return FortalezaComponentTheme.light().copyWith(
      avatar: const FortalezaDarkAvatarStyle(),
      badge: const FortalezaDarkBadgeStyle(),
      segmentedControl: const FortalezaDarkSegmentedControlStyle(),
      select: const FortalezaDarkSelectStyle(),
      switchComponent: const FortalezaDarkSwitchStyle(),
    );
  }
}
