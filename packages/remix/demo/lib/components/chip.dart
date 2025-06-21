import 'package:demo/addons/icon_data_knob.dart';
import 'package:demo/helpers/use_case_state.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Chip Component',
  type: RxChip,
)
Widget buildChipUseCase(BuildContext context) {
  final knobState = WidgetbookState.of(context);

  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: RxChip(
          selected: context.knobs.boolean(label: 'Checked', initialValue: true),
          onChanged: (value) => knobState.updateKnob('Checked', value),
          label: context.knobs.string(
            label: 'Label',
            initialValue: 'Chip',
          ),
          enabled: context.knobs.boolean(
            label: 'Enabled',
            initialValue: true,
          ),
          iconLeft: context.knobs.iconData(
            label: 'Icon left',
            initialValue: null,
          ),
          iconRight: context.knobs.iconData(
            label: 'Icon right',
            initialValue: null,
          ),
        ),
      ),
    ),
  );
}
