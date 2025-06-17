part of 'header.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.style,
    this.variants = const [],
  });

  final Widget? leading;

  final String title;
  final String? subtitle;

  final Widget? trailing;

  /// {@macro remix.component.style}
  final HeaderStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? context.remix.components.header;

    final configuration = SpecConfiguration(context, HeaderSpecUtility.self);

    return SpecBuilder(
      style: style.makeStyle(configuration).applyVariants(variants),
      builder: (context) {
        final spec = HeaderSpec.of(context);

        return spec.container(
          direction: Axis.horizontal,
          children: [
            if (leading != null) leading!,
            spec.titleGroup(
              direction: Axis.vertical,
              children: [
                spec.title(title),
                if (subtitle != null) spec.subtitle(subtitle!),
              ],
            ),
            const Spacer(),
            if (trailing != null) trailing!,
          ],
        );
      },
    );
  }
}
