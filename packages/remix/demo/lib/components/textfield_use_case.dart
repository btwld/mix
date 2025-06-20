import 'package:demo/addons/icon_data_knob.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'TextField Component',
  type: RxTextField,
)
Widget buildButtonUseCase(BuildContext context) {
  final iconKnob = context.knobs.iconData(label: 'icons', initialValue: null);
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: RxTextField(
            suffix: context.knobs
                    .boolean(label: 'SuffixWidget', initialValue: false)
                ? RxButton.icon(
                    Icons.close_rounded,
                    onPressed: () {},
                  )
                : null,
            prefix: iconKnob != null ? Icon(iconKnob) : null,
            maxLines: context.knobs.int.input(
              label: 'Max Lines',
              initialValue: 1,
            ),
            hintText: context.knobs.string(
              label: 'Hint Text',
              initialValue: 'Hint Text',
            ),
            helperText: context.knobs.string(
              label: 'Helper Text',
              initialValue: 'Helper Text',
            ),
          ),
        ),
      ),
    ),
  );
}
