import 'package:flutter/material.dart' hide Scaffold;
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Menu Item Component',
  type: RxMenuItem,
)
Widget buildButtonUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
          child: RxMenuItem(
            title: context.knobs.string(
              label: 'Title',
              initialValue: 'Menu Item',
            ),
            subtitle: context.knobs.stringOrNull(
              label: 'Subtitle',
              initialValue: 'Subtitle',
            ),
            onPress: () {},
            enabled: context.knobs.boolean(
              label: 'Disabled',
              initialValue: false,
            ),
            leading: context.knobs.boolean(
              label: 'Show leading widget',
              initialValue: false,
            )
                ? const RxAvatar.raw(child: Text('LF'))
                : const SizedBox.shrink(),
            trailing: context.knobs.boolean(
              label: 'Show trailing widget',
              initialValue: false,
            )
                ? const Icon(Icons.chevron_right)
                : const SizedBox.shrink(),
          ),
        ),
      ),
    ),
  );
}
