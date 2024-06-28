import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'interactive playground',
  type: RXButton,
)
Widget buildButtonUseCase(BuildContext context) {
  Widget buildButton(ButtonVariant type) {
    return RXButton(
      label: context.knobs.string(
        label: 'Title',
        initialValue: 'Title',
      ),
      onPressed: () {},
      loading: context.knobs.boolean(
        label: 'Is loading',
        initialValue: false,
      ),
      disabled: context.knobs.boolean(
        label: 'Disabled',
        initialValue: false,
      ),
      size: context.knobs.list(
        label: 'Size',
        options: ButtonSize.values,
        initialOption: ButtonSize.medium,
        labelBuilder: (value) => value.name.split('.').last,
      ),
      type: type,
    );
  }

  return Container(
    color: Colors.white,
    child: Center(
      child: Wrap(
        spacing: 12,
        children: ButtonVariant.values.map(buildButton).toList(),
      ),
    ),
  );
}
