import 'package:flutter/material.dart' hide Scaffold;
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Menu Item Component',
  type: MenuItem,
)
Widget buildButtonUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
          child: MenuItem(
            title: context.knobs.string(
              label: 'Title',
              initialValue: 'Menu Item',
            ),
            subtitle: context.knobs.stringOrNull(
              label: 'Subtitle',
              initialValue: 'Subtitle',
            ),
            onPress: () {},
            disabled: context.knobs.boolean(
              label: 'Disabled',
              initialValue: false,
            ),
            leadingWidgetBuilder: (icon) => context.knobs.boolean(
              label: 'Show leading widget',
              initialValue: false,
            )
                ? Avatar(fallbackLabel: 'LF')
                : const SizedBox.shrink(),
            trailingWidgetBuilder: (icon) => context.knobs.boolean(
              label: 'Show trailing widget',
              initialValue: false,
            )
                ? icon(Icons.chevron_right)
                : const SizedBox.shrink(),
          ),
        ),
      ),
    ),
  );
}
