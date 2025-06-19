part of 'progress.dart';

/// The [RxProgress] widget is used to display a progress bar that indicates a
/// completion percentage between 0 and 1. It can be customized using the
/// [variants] and [style] parameters to fit different design needs.
///
/// ## Example
///
/// ```dart
/// RxProgress(
///   value: 0.5,
///   variants: [Variant.primary],
///   style: RxProgressStyle(),
/// )
/// ```
class RxProgress extends StatelessWidget {
  const RxProgress({
    super.key,
    this.style,
    this.variants = const [],
    required this.value,
  }) : assert(
          value >= 0 && value <= 1,
          'Progress value must be between 0 and 1',
        );

  /// {@macro remix.component.style}
  final RxProgressStyle? style;

  /// The progress value between 0 and 1.
  ///
  /// This value determines how much of the progress bar is filled.
  /// A value of 0 means empty, while 1 means completely filled.
  final double value;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  RxProgressStyle get _style =>
      RxProgressStyle._default().merge(style ?? RxProgressStyle());

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      style: Style(_style).applyVariants(variants),
      builder: (context) {
        final spec = ProgressSpec.of(context);

        return spec.container(
          child: Stack(
            children: [
              spec.track(),
              LayoutBuilder(builder: (context, constraints) {
                final biggestSize = constraints.biggest;

                return SizedBox(
                  width: biggestSize.width * value,
                  child: spec.fill(),
                );
              }),
              spec.outerContainer(),
            ],
          ),
        );
      },
    );
  }
}
