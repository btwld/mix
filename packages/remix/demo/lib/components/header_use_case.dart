import 'package:flutter/cupertino.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';
import 'package:remix/themes/fortaleza.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Header Component',
  type: Header,
)
Widget buildCard(BuildContext context) {
  final leading = Box(
    style: Style(
      $box.chain
        ..padding(10)
        ..color.white10()
        ..borderRadius(8)
        ..wrap.padding.right(16),
      $on.light(
        $box.color.black12(),
        $icon.color.black(),
      ),
    ),
    child: const StyledIcon(
      CupertinoIcons.person,
    ),
  );

  final actions = Row(
    children: [
      IconButton(
        CupertinoIcons.trash,
        variants: const [FortalezaIconButtonStyle.ghost],
        onPressed: () {},
      ),
      const SizedBox(
        height: 16,
      ),
      RxButton(
        label: 'Button',
        onPressed: () {},
      ),
    ],
  );

  return Scaffold(
    header: Header(
      title: context.knobs.string(label: 'Title', initialValue: 'Title'),
      subtitle: context.knobs.stringOrNull(label: 'description'),
      leading: context.knobs.boolean(
        label: 'leading Icons',
        initialValue: false,
      )
          ? leading
          : null,
      trailing: context.knobs.boolean(
        label: 'Trailing Icons',
        initialValue: false,
      )
          ? actions
          : null,
    ),
    body: Box(
      style: Style(
        $box.color.white.withOpacity($on.dark.when(context) ? 0.03 : 1),
        // $box.color.$neutral(1),
      ),
    ),
  );
}
