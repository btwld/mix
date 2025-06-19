import 'package:demo/helpers/use_case_state.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Switch Component',
  type: RxSwitch,
)
Widget buildSwitchUseCase(BuildContext context) {
  final knobState = WidgetbookState.of(context);

  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: RxSwitch(
          selected: context.knobs.boolean(label: 'Toggle', initialValue: true),
          enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
          onChanged: (value) => knobState.updateKnob('Toggle', value),
        ),
      ),
    ),
  );
}
