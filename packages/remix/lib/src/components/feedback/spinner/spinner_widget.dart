part of 'spinner.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key, this.style, this.variants = const []});

  /// {@macro remix.component.style}
  final SpinnerStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? context.remix.components.spinner;

    final configuration = SpecConfiguration(context, SpinnerSpecUtility.self);

    return SpecBuilder(
      style: style.makeStyle(configuration).applyVariants(variants),
      builder: (context) {
        final spinnerWidget = SpinnerSpec.of(context);

        return spinnerWidget();
      },
    );
  }
}

class SpinnerSpecWidget extends StatefulWidget {
  const SpinnerSpecWidget({this.spec = const SpinnerSpec(), super.key});

  final SpinnerSpec spec;

  @override
  State createState() => _SpinnerSpecWidgetState();
}

class _SpinnerSpecWidgetState extends State<SpinnerSpecWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.spec.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant SpinnerSpecWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spec.duration != widget.spec.duration) {
      controller.duration = widget.spec.duration;
      controller.repeat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    final color = spec.color;
    final strokeWidth = spec.strokeWidth ?? 1;
    final size = spec.size;
    final painter = spec.style == SpinnerTypeStyle.dotted
        ? DottedSpinnerPainter(
            animation: controller,
            strokeWidth: strokeWidth,
            color: color,
          )
        : SolidSpinnerPainter(
            animation: controller,
            strokeWidth: strokeWidth,
            color: color,
          );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(painter: painter, size: Size(size, size));
      },
    );
  }
}
