import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _accordionKey = GlobalKey();

@widgetbook.UseCase(
  name: 'Accordion Component',
  type: RxAccordion,
)
Widget buildAccordionUseCase(BuildContext context) {
  final knobState = WidgetbookState.of(context);

  return Scaffold(
    body: Center(
      child: SizedBox(
        width: 300,
        child: RxAccordion(
          key: _accordionKey,
          children: [
            RxAccordionItem(
              value: 'Item 1',
              title: 'How do I update my account information?',
              child: const Text(
                'Insert the accordion description here. It would look better as two lines of text.',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
