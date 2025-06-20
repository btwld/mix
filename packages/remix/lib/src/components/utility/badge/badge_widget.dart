part of 'badge.dart';

class RxBadge extends StatelessWidget {
  RxBadge({
    super.key,
    String? label,
    IconData? icon,
    IconPosition iconPosition = IconPosition.start,
    this.style,
    this.variants = const [],
  }) : child = RxLabel(label ?? '', icon: icon, iconPosition: iconPosition);

  const RxBadge.raw({
    super.key,
    this.style,
    this.variants = const [],
    required this.child,
  });

  /// The label to display in the badge.
  final Widget child;

  /// {@macro remix.component.style}
  final RxBadgeStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  RxBadgeStyle get _style =>
      RxBadgeStyle._default().merge(style ?? RxBadgeStyle._default());

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      style: Style(_style).applyVariants(variants),
      builder: (context) {
        final spec = BadgeSpec.of(context);

        return DefaultTextStyle(
          style: spec.textStyle,
          child: IconTheme(
            data: spec.icon,
            child: spec.container(child: child),
          ),
        );
      },
    );
  }
}
