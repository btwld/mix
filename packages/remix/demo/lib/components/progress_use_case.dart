import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Progress Component',
  type: RxProgress,
)
Widget buildProgressUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SizedBox(
        width: 200,
        child: RxProgress(
          value: context.knobs.double.slider(
            label: 'value',
            min: 0,
            max: 1,
            initialValue: 0.5,
          ),
        ),
      ),
    ),
  );
}
