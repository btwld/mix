part of 'progress.dart';

class Progress extends StatelessWidget {
  const Progress({
    super.key,
    this.style,
    this.variants = const [],
    required this.value,
  }) : assert(
          value >= 0 && value <= 1,
          'Progress value must be between 0 and 1',
        );

  /// {@macro remix.component.style}
  final ProgressStyle? style;

  /// The progress value between 0 and 1.
  ///
  /// This value determines how much of the progress bar is filled.
  /// A value of 0 means empty, while 1 means completely filled.
  final double value;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? context.remix.components.progress;

    final configuration = SpecConfiguration(context, ProgressSpecUtility.self);

    return SpecBuilder(
      style: style.makeStyle(configuration).applyVariants(variants),
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
