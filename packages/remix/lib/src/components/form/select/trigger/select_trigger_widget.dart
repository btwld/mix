part of '../select.dart';

class SelectTrigger extends StatelessWidget {
  const SelectTrigger({
    super.key,
    required this.text,
    this.trailingIcon = Icons.keyboard_arrow_down_rounded,
    this.disabled = false,
  });

  final String text;
  final IconData trailingIcon;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final select = context.findAncestorStateOfType<SelectState>();

    if (select == null) {
      throw Exception('SelectButton must be a child of a Select');
    }

    final style = select.widget.style ?? context.remix.components.select;
    final configuration = SpecConfiguration(context, SelectSpecUtility.self);
    final appliedStyle =
        style.makeStyle(configuration).applyVariants(select.widget.variants);

    return Pressable(
      enabled: !disabled,
      onPress: () {
        select.openMenu();
      },
      child: SpecBuilder(
        style: appliedStyle,
        builder: (context) {
          final button = SelectSpec.of(context).button;

          final container = button.container;
          final label = button.label;
          final icon = button.icon;

          return container(
            direction: Axis.horizontal,
            children: [label(text), icon(trailingIcon)],
          );
        },
      ),
    );
  }
}
