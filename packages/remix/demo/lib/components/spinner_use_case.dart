import 'package:demo/helpers/knob_builder.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix/themes/fortaleza.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Spinner Component',
  type: RxSpinner,
)
Widget buildSpinnerUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: RxSpinner(
        variants: [context.knobs.variant(FortalezaSpinnerStyle.variants)],
      ),
    ),
  );
}
