import '../../components/feedback/dialog/dialog.dart';
import '../../components/feedback/spinner/spinner.dart';
import '../../components/feedback/toast/toast.dart';
import '../../components/form/checkbox/checkbox.dart';
import '../../components/form/radio/radio.dart';
import '../../components/form/select/select.dart';
import '../../components/form/slider/slider.dart';
import '../../components/form/switch/switch.dart';
import '../../components/form/textfield/textfield.dart';
import '../../components/layout/divider/divider.dart';
import '../../components/layout/header/header.dart';
import '../../components/layout/scaffold/scaffold.dart';
import '../../components/navigation/segmented_control/segmented_control.dart';
import '../../components/utility/badge/badge.dart';
import '../../components/utility/dropdown_menu/dropdown_menu.dart';

class RemixComponentTheme {
  final BadgeStyle badge;
  // final ButtonStyle button;
  final CheckboxStyle checkbox;
  final DialogStyle dialog;
  final DividerStyle divider;
  final HeaderStyle header;

  final RadioStyle radio;
  final ScaffoldStyle scaffold;
  final SegmentedControlStyle segmentedControl;
  final SelectStyle select;
  final SpinnerStyle spinner;
  final SwitchStyle switchComponent;
  final TextFieldStyle textField;
  final ToastStyle toast;
  final SliderStyle slider;
  final DropdownMenuStyle dropdownMenu;

  const RemixComponentTheme({
    required this.badge,
    // required this.button,

    required this.checkbox,
    required this.dialog,
    required this.divider,
    required this.header,
    required this.radio,
    required this.scaffold,
    required this.segmentedControl,
    required this.select,
    required this.spinner,
    required this.switchComponent,
    required this.textField,
    required this.toast,
    required this.slider,
    required this.dropdownMenu,
  });

  factory RemixComponentTheme.light() {
    return const RemixComponentTheme(
      badge: BadgeStyle(),
      // button: ButtonStyle(),

      checkbox: CheckboxStyle(),
      dialog: DialogStyle(),
      divider: DividerStyle(),
      header: HeaderStyle(),

      radio: RadioStyle(),
      scaffold: ScaffoldStyle(),
      segmentedControl: SegmentedControlStyle(),
      select: SelectStyle(),
      spinner: SpinnerStyle(),
      switchComponent: SwitchStyle(),
      textField: TextFieldStyle(),
      toast: ToastStyle(),
      slider: SliderStyle(),
      dropdownMenu: DropdownMenuStyle(),
    );
  }

  factory RemixComponentTheme.dark() {
    return RemixComponentTheme.light().copyWith(
      badge: const BadgeDarkStyle(),
      // button: const ButtonDarkStyle(),

      checkbox: const CheckboxDarkStyle(),
      dialog: const DialogDarkStyle(),
      divider: const DividerDarkStyle(),
      header: const HeaderDarkStyle(),

      radio: const RadioDarkStyle(),
      scaffold: const ScaffoldDarkStyle(),
      segmentedControl: const SegmentedControlDarkStyle(),
      select: const SelectDarkStyle(),
      spinner: const SpinnerDarkStyle(),
      switchComponent: const SwitchDarkStyle(),
      textField: const TextFieldDarkStyle(),
      toast: const ToastDarkStyle(),
      slider: const SliderDarkStyle(),
      dropdownMenu: const DropdownMenuDarkStyle(),
    );
  }

  RemixComponentTheme copyWith({
    BadgeStyle? badge,
    // ButtonStyle? button,

    CheckboxStyle? checkbox,
    DialogStyle? dialog,
    DividerStyle? divider,
    HeaderStyle? header,
    RadioStyle? radio,
    ScaffoldStyle? scaffold,
    SegmentedControlStyle? segmentedControl,
    SelectStyle? select,
    SpinnerStyle? spinner,
    SwitchStyle? switchComponent,
    TextFieldStyle? textField,
    ToastStyle? toast,
    SliderStyle? slider,
    DropdownMenuStyle? dropdownMenu,
  }) {
    return RemixComponentTheme(
      badge: badge ?? this.badge,
      checkbox: checkbox ?? this.checkbox,
      dialog: dialog ?? this.dialog,
      divider: divider ?? this.divider,
      header: header ?? this.header,
      radio: radio ?? this.radio,
      scaffold: scaffold ?? this.scaffold,
      segmentedControl: segmentedControl ?? this.segmentedControl,
      select: select ?? this.select,
      spinner: spinner ?? this.spinner,
      switchComponent: switchComponent ?? this.switchComponent,
      textField: textField ?? this.textField,
      toast: toast ?? this.toast,
      slider: slider ?? this.slider,
      dropdownMenu: dropdownMenu ?? this.dropdownMenu,
    );
  }
}
