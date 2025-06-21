import '../../components/feedback/dialog/dialog.dart';
import '../../components/feedback/toast/toast.dart';
import '../../components/layout/divider/divider.dart';
import '../../components/layout/header/header.dart';
import '../../components/layout/scaffold/scaffold.dart';
import '../../components/navigation/segmented_control/segmented_control.dart';
import '../../components/utility/badge/badge.dart';
import '../../components/utility/dropdown_menu/dropdown_menu.dart';

class RemixComponentTheme {
  final BadgeStyle badge;
  // final ButtonStyle button;
  final DialogStyle dialog;
  final DividerStyle divider;
  final HeaderStyle header;

  final ScaffoldStyle scaffold;
  final SegmentedControlStyle segmentedControl;
  final ToastStyle toast;
  final DropdownMenuStyle dropdownMenu;

  const RemixComponentTheme({
    required this.badge,
    // required this.button,

    required this.dialog,
    required this.divider,
    required this.header,
    required this.scaffold,
    required this.segmentedControl,
    required this.toast,
    required this.dropdownMenu,
  });

  factory RemixComponentTheme.light() {
    return const RemixComponentTheme(
      badge: BadgeStyle(),
      // button: ButtonStyle(),

      dialog: DialogStyle(),
      divider: DividerStyle(),
      header: HeaderStyle(),

      scaffold: ScaffoldStyle(),
      segmentedControl: SegmentedControlStyle(),
      toast: ToastStyle(),
      dropdownMenu: DropdownMenuStyle(),
    );
  }

  factory RemixComponentTheme.dark() {
    return RemixComponentTheme.light().copyWith(
      badge: const BadgeDarkStyle(),
      // button: const ButtonDarkStyle(),

      dialog: const DialogDarkStyle(),
      divider: const DividerDarkStyle(),
      header: const HeaderDarkStyle(),

      scaffold: const ScaffoldDarkStyle(),
      segmentedControl: const SegmentedControlDarkStyle(),
      toast: const ToastDarkStyle(),
      dropdownMenu: const DropdownMenuDarkStyle(),
    );
  }

  RemixComponentTheme copyWith({
    BadgeStyle? badge,
    // ButtonStyle? button,

    DialogStyle? dialog,
    DividerStyle? divider,
    HeaderStyle? header,
    ScaffoldStyle? scaffold,
    SegmentedControlStyle? segmentedControl,
    ToastStyle? toast,
    DropdownMenuStyle? dropdownMenu,
  }) {
    return RemixComponentTheme(
      badge: badge ?? this.badge,
      dialog: dialog ?? this.dialog,
      divider: divider ?? this.divider,
      header: header ?? this.header,
      scaffold: scaffold ?? this.scaffold,
      segmentedControl: segmentedControl ?? this.segmentedControl,
      toast: toast ?? this.toast,
      dropdownMenu: dropdownMenu ?? this.dropdownMenu,
    );
  }
}
