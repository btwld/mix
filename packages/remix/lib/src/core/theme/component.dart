import '../../components/feedback/dialog/dialog.dart';
import '../../components/feedback/toast/toast.dart';
import '../../components/navigation/segmented_control/segmented_control.dart';
import '../../components/utility/dropdown_menu/dropdown_menu.dart';

class RemixComponentTheme {
  final DialogStyle dialog;
  final SegmentedControlStyle segmentedControl;
  final ToastStyle toast;
  final DropdownMenuStyle dropdownMenu;

  const RemixComponentTheme({
    required this.dialog,
    required this.segmentedControl,
    required this.toast,
    required this.dropdownMenu,
  });

  factory RemixComponentTheme.light() {
    return const RemixComponentTheme(
      dialog: DialogStyle(),
      segmentedControl: SegmentedControlStyle(),
      toast: ToastStyle(),
      dropdownMenu: DropdownMenuStyle(),
    );
  }

  factory RemixComponentTheme.dark() {
    return RemixComponentTheme.light().copyWith(
      dialog: const DialogDarkStyle(),
      segmentedControl: const SegmentedControlDarkStyle(),
      toast: const ToastDarkStyle(),
      dropdownMenu: const DropdownMenuDarkStyle(),
    );
  }

  RemixComponentTheme copyWith({
    DialogStyle? dialog,
    SegmentedControlStyle? segmentedControl,
    ToastStyle? toast,
    DropdownMenuStyle? dropdownMenu,
  }) {
    return RemixComponentTheme(
      dialog: dialog ?? this.dialog,
      segmentedControl: segmentedControl ?? this.segmentedControl,
      toast: toast ?? this.toast,
      dropdownMenu: dropdownMenu ?? this.dropdownMenu,
    );
  }
}
