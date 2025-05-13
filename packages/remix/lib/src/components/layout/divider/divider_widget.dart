part of 'divider.dart';

class Divider extends StatelessWidget {
  const Divider({
    super.key,
    this.style,
    this.variants = const [],
    this.axis = Axis.horizontal,
  });

  /// {@macro remix.component.style}
  final DividerStyle? style;

  /// The axis along which the divider will be displayed.
  final Axis axis;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? context.remix.components.divider;
    final axisVariant = axis == Axis.horizontal
        ? DividerStyle.horizontal
        : DividerStyle.vertical;

    final configuration = SpecConfiguration(context, DividerSpecUtility.self);

    return SpecBuilder(
      style: style
          .makeStyle(configuration)
          .applyVariants([...variants, axisVariant]),
      builder: (context) {
        final spec = DividerSpec.of(context);

        return spec.container();
      },
    );
  }
}
