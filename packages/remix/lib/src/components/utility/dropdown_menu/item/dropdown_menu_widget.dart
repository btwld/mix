part of '../dropdown_menu.dart';

/// A widget that represents an individual item in a [Select] dropdown menu.
///
/// This widget is used internally by the [Select] widget to render each [SelectMenuItem]
/// in its dropdown. It applies styling and layout defined in the [SelectStyle].
///
/// Example usage within [Select]:
/// ```dart
/// Select<String>(
///   value: selectedValue,
///   onChanged: (value) => setState(() => selectedValue = value),
///   items: [
///     SelectMenuItem(
///       value: 'profile',
///       child: SelectMenuItemWidget(
///         icon: Icons.person,
///         text: 'Profile',
///       ),
///     ),
///   ],
/// )
/// ```

class DropdownMenuItem extends StatelessWidget {
  const DropdownMenuItem({
    super.key,
    this.icon,
    required this.text,
    this.onPress,
    this.variants = const [],
  });

  /// The optional icon data to display before the text.
  final IconData? icon;

  /// The text label to display for this menu item.
  final String text;

  /// The callback that is called when the item is pressed.
  final VoidCallback? onPress;

  final List<Variant> variants;

  Style _inheritStyleFromDropdownMenu(BuildContext context) {
    final dropdownMenu = context.findAncestorWidgetOfExactType<DropdownMenu>();

    if (dropdownMenu == null) {
      throw Exception('DropdownMenuItem must be a child of a DropdownMenu');
    }

    final style = dropdownMenu.style ?? context.remix.components.dropdownMenu;
    final configuration =
        SpecConfiguration(context, DropdownMenuSpecUtility.self);

    return style.makeStyle(configuration).applyVariants(dropdownMenu.variants);
  }

  @override
  Widget build(BuildContext context) {
    final style = _inheritStyleFromDropdownMenu(context);

    return Pressable(
      onPress: onPress,
      child: SpecBuilder(
        style: style.applyVariants(variants),
        builder: (context) {
          final item = DropdownMenuSpec.of(context).item;
          final container = item.container;
          final iconWidget = item.icon;
          final textWidget = item.text;

          return container(
            direction: Axis.horizontal,
            children: [if (icon != null) iconWidget(icon), textWidget(text)],
          );
        },
      ),
    );
  }
}
