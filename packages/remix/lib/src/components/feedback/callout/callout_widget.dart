part of 'callout.dart';

class Callout extends StatelessWidget {
  const Callout({
    super.key,
    this.icon,
    required this.text,
    this.variants = const [],
    this.style,
  });

  /// The text content displayed in the callout.
  final String text;

  /// The icon displayed in the callout.
  final IconData? icon;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro remix.component.style}
  final CalloutStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? context.remix.components.callout;

    final configuration = SpecConfiguration(context, CalloutSpecUtility.self);

    return SpecBuilder(
      style: style.makeStyle(configuration).applyVariants(variants),
      builder: (context) {
        final spec = CalloutSpec.of(context);

        return spec.container(
          direction: Axis.horizontal,
          children: [if (icon != null) spec.icon(icon!), spec.text(text)],
        );
      },
    );
  }
}
