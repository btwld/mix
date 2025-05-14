import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Toast Component',
  type: Toast,
)
Widget buildButtonUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Event has been created',
  );
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Sunday, December 03, 2023 at 9:00 AM',
  );

  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Builder(builder: (context) {
        return Center(
          child: RxButton(
            label: 'Show toast',
            onPressed: () {
              showToast(
                context: context,
                entry: ToastEntry(
                  showDuration: const Duration(seconds: 2),
                  alignment: Alignment.topCenter,
                  builder: (context, entry) => Toast(
                    title: title,
                    description: description,
                  ),
                ),
              );
            },
          ),
        );
      }),
    ),
  );
}
