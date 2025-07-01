part of 'tooltip.dart';

/// A customizable tooltip component that wraps NakedTooltip.
/// The tooltip integrates with the Mix styling system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RxTooltip(
///   tooltipChild: Text(
///     'This is a tooltip',
///     style: TextStyle(color: Colors.white),
///   ),
///   child: Text('Hello'),
/// )
/// ```
///
class RxTooltip extends StatefulWidget {
  /// Creates a Remix tooltip.
  ///
  /// The [tooltipChild] and [child] parameters are required.
  /// The [tooltipChild] parameter should be the widget to display in the tooltip.
  const RxTooltip({
    super.key,
    required this.tooltipChild,
    required this.child,
    this.showDuration = const Duration(seconds: 1),
    this.waitDuration = Duration.zero,
    this.tooltipSemantics,
    this.style,
    this.variants = const [],
  });

  /// The widget to display in the tooltip.
  ///
  /// This widget will be shown as the tooltip content when the child is hovered
  final Widget tooltipChild;

  /// The child widget that will trigger the tooltip when hovered or long-pressed.
  final Widget child;

  /// The duration for which the tooltip is shown.
  final Duration showDuration;

  /// The duration to wait before showing the tooltip.
  final Duration waitDuration;

  /// The semantic label for the tooltip.
  final String? tooltipSemantics;

  /// The style for the tooltip.
  final RxTooltipStyle? style;

  /// The variants for the tooltip.
  final List<Variant> variants;

  @override
  State<RxTooltip> createState() => _RxTooltipState();
}

class _RxTooltipState extends State<RxTooltip> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  RxTooltipStyle get _style =>
      RxTooltipStyle._default().merge(widget.style ?? RxTooltipStyle());

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Style(_style).applyVariants(widget.variants);

    return MixBuilder(
      style: style,
      builder: (context) {
        final spec = TooltipSpec.of(context);

        final animationDuration = spec.animated?.duration ?? Duration.zero;

        return NakedTooltip(
          tooltipBuilder: (context) => SpecBuilder(
            style: style,
            builder: (context) {
              final spec = TooltipSpec.of(context);

              return FadeTransition(
                opacity: _animationController.view,
                child: spec.container(child: widget.tooltipChild),
              );
            },
          ),
          showDuration: widget.showDuration,
          waitDuration: widget.waitDuration,
          tooltipSemantics: widget.tooltipSemantics,
          removalDelay: animationDuration,
          onStateChange: (state) {
            _animationController.duration = animationDuration;

            if (state == OverlayChildLifecycleState.present) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
          },
          child: widget.child,
        );
      },
    );
  }
}
