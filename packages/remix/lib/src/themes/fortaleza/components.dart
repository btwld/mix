import '../../core/theme/component.dart';
import 'components/dialog_theme.dart';
import 'components/dropdown_theme.dart';
import 'components/segmented_control_theme.dart';
import 'components/toast_theme.dart';

class FortalezaComponentTheme extends RemixComponentTheme {
  const FortalezaComponentTheme({
    required super.dialog,
    required super.segmentedControl,
    required super.toast,
    required super.dropdownMenu,
  });

  static RemixComponentTheme light() {
    return const FortalezaComponentTheme(
      
      dialog: FortalezaDialogStyle(),
      segmentedControl: FortalezaSegmentedControlStyle(),
      toast: FortalezaToastStyle(),
      dropdownMenu: FortalezaDropdownMenuStyle(),
    );
  }

  static RemixComponentTheme dark() {
    return FortalezaComponentTheme.light().copyWith(
      segmentedControl: const FortalezaDarkSegmentedControlStyle(),
    );
  }
}
