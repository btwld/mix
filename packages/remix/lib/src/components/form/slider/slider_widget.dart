part of 'slider.dart';

class Slider extends StatefulWidget {
  const Slider({
    super.key,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions = 0,
    required this.onChanged,
    required this.value,
    this.onChangeEnd,
    this.onChangeStart,
    this.style,
    this.variants = const [],
    this.disabled = false,
  }) : assert(
          value >= min && value <= max,
          'Slider value must be between min and max values',
        );

  /// The minimum value the slider can have.
  final double min;

  /// The maximum value the slider can have.
  final double max;

  /// The number of discrete divisions the slider can move through.
  /// If it's 0, the slider moves continuously.
  final int divisions;

  /// The current value of the slider.
  /// Must be between [min] and [max].
  final double value;

  /// {@macro remix.component.style}
  final SliderStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro remix.component.disabled}
  final bool disabled;

  /// Called when the user starts dragging the slider.
  final ValueChanged<double>? onChangeStart;

  /// Called during drag with the new value.
  final ValueChanged<double>? onChanged;

  /// Called when the user is done selecting a new value.
  final ValueChanged<double>? onChangeEnd;

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> with TickerProviderStateMixin {
  double _sliderWidth = 0.0;
  double _thumbWidth = 0.0;

  late WidgetStatesController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WidgetStatesController()..disabled = widget.disabled;
  }

  double _calculateValue(Offset localPosition) {
    double dx = (localPosition.dx - _thumbWidth / 2).clamp(0, _sliderWidth);
    double percent = dx / _sliderWidth;
    int divisions = widget.divisions;

    if (divisions > 0) {
      final range = widget.max - widget.min;
      final step = range / divisions;
      final rounded = ((percent * range) / step).round();

      return step * rounded;
    }

    return widget.min + percent * (widget.max - widget.min);
  }

  void _handleInteraction(void Function(WidgetStatesController) callback) {
    if (_controller.disabled) return;
    callback(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? context.remix.components.slider;
    final configuration = SpecConfiguration(context, SliderSpecUtility.self);

    return Interactable(
      enabled: !widget.disabled,
      mouseCursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      controller: _controller,
      child: GestureDetector(
        onPanStart: (details) {
          _handleInteraction((c) {
            c.pressed = true;
            final value = _calculateValue(details.localPosition);
            widget.onChangeStart?.call(value);
          });
        },
        onPanUpdate: (details) {
          _handleInteraction((c) {
            c.pressed = true;
            final value = _calculateValue(details.localPosition);
            widget.onChanged?.call(value);
          });
        },
        onPanEnd: (details) {
          _handleInteraction((c) {
            c.pressed = false;
          });
        },
        child: SpecBuilder(
          style: style.makeStyle(configuration).applyVariants(widget.variants),
          builder: (context) {
            final spec = SliderSpec.of(context);
            _thumbWidth = spec.thumb.width ?? 0;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (spec.thumb.width ?? 0) / 2,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _sliderWidth = constraints.maxWidth;
                  double percent =
                      ((widget.value - widget.min) / (widget.max - widget.min))
                          .clamp(0, 1);

                  final a = (constraints.maxWidth - _thumbWidth / 4) /
                      widget.divisions;
                  final divisions = [
                    for (int i = 0; i < widget.divisions; i++)
                      Transform.translate(
                        offset: Offset(a * (i + 1), 0),
                        child: spec.division(),
                      ),
                  ];

                  return Container(
                    color: Colors.transparent,
                    height: (spec.thumb.height ?? 0) * 2,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        spec.track(),
                        ...divisions,
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: percent,
                          child: spec.activeTrack(),
                        ),
                        Transform.translate(
                          offset: Offset(
                            percent * constraints.maxWidth - _thumbWidth / 2,
                            0,
                          ),
                          child: spec.thumb(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
