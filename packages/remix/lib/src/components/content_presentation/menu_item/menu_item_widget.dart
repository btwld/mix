part of 'menu_item.dart';

/// A menu item component that displays a title, and optionally a subtitle, leading, and trailing widgets.
///
/// The [RxMenuItem] is a customizable widget that can be used to create a list of items with a consistent style.
/// It supports various configurations such as enabling/disabling the item, applying style variants, and handling
/// press actions.
///
/// {@macro remix.component}
///
/// ## Example
///
/// ```dart
/// RxMenuItem(
///   title: 'Settings',
///   subtitle: 'Manage your preferences',
///   leading: Icon(Icons.settings),
///   trailing: Icon(Icons.arrow_forward),
///   onPress: () {
///     // Handle press action
///   },
///   enabled: true,
///   variants: [Variant.primary],
///   style: RxMenuItemStyle(),
/// )
/// ```
///
class RxMenuItem extends StatelessWidget {
  const RxMenuItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onPress,
    this.variants = const [],
    this.style,
    this.enabled = true,
  });

  /// The primary text displayed in the menu item.
  final String title;

  /// Optional secondary text displayed below the title.
  final String? subtitle;

  /// {@macro remix.component.onPressed}
  final VoidCallback? onPress;

  /// A widget that represents the leading widget in the menu item.
  ///
  /// This widget is displayed at the start of the menu item.
  ///
  /// {@macro remix.widget_spec_builder.icon_spec}
  ///
  /// ```dart
  /// MenuItem(
  ///   title: 'Settings',
  ///   leading: Icon(Icons.settings),
  /// );
  /// ```
  final Widget? leading;

  /// A widget that represents the trailing widget in the menu item.
  ///
  /// This widget is displayed at the end of the menu item.
  ///
  /// {@macro remix.widget_spec_builder.icon_spec}
  ///
  /// ```dart
  /// MenuItem(
  ///   title: 'Settings',
  ///   leading: Icon(Icons.settings),
  /// );
  /// ```
  final Widget? trailing;

  /// {@macro remix.component.enabled}
  final bool enabled;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro remix.component.style}
  final RxMenuItemStyle? style;

  RxMenuItemStyle get _style =>
      RxMenuItemStyle._default().merge(style ?? RxMenuItemStyle());

  @override
  Widget build(BuildContext context) {
    return Pressable(
      enabled: enabled,
      onPress: onPress,
      child: SpecBuilder(
        style: Style(_style).applyVariants(variants),
        builder: (context) {
          final spec = MenuItemSpec.of(context);

          return spec.container(
            direction: Axis.horizontal,
            children: [
              if (leading != null) leading!,
              spec.titleSubtitleContainer(
                direction: Axis.vertical,
                children: [
                  spec.title(title),
                  if (subtitle != null) spec.subtitle(subtitle!),
                ],
              ),
              if (trailing != null) trailing!,
            ],
          );
        },
      ),
    );
  }
}
