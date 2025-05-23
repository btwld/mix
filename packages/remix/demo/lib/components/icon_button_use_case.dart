import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Button Component',
  type: RxButton,
)
Widget buildButtonUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: Builder(builder: (context) {
          return RxButton.icon(
            m.Icons.add,
            onPressed: () {
              showToast(
                context: context,
                entry: ToastEntry(
                  showDuration: const Duration(milliseconds: 800),
                  builder: (context, actions) =>
                      const Toast(title: 'Button pressed'),
                ),
              );
            },
            enabled: context.knobs.boolean(
              label: 'Enabled',
              initialValue: true,
            ),
            loading: context.knobs.boolean(
              label: 'loading',
              initialValue: false,
            ),
          );
        }),
      ),
    ),
  );
}
