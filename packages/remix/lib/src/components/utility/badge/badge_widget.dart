part of 'badge.dart';

class Badge extends StatelessWidget {
  const Badge({
    super.key,
    required this.label,
    this.style,
    this.variants = const [],
  });

  /// The label to display in the badge.
  final String label;

  /// {@macro remix.component.style}
  final BadgeStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? context.remix.components.badge;

    final configuration = SpecConfiguration(context, BadgeSpecUtility.self);

    return SpecBuilder(
      style: style.makeStyle(configuration).applyVariants(variants),
      builder: (context) {
        final spec = BadgeSpec.of(context);

        final ContainerWidget = spec.container;
        final LabelWidget = spec.label;

        return ContainerWidget(child: LabelWidget(label));
      },
    );
  }
}
