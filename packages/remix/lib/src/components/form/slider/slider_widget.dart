part of 'slider.dart';

class RxSlider extends StatefulWidget implements Disableable {
  const RxSlider({
    super.key,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    required this.onChanged,
    required this.value,
    this.onChangeEnd,
    this.onChangeStart,
    this.style,
    this.variants = const [],
    this.enabled = true,
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
  final int? divisions;

  /// The current value of the slider.
  /// Must be between [min] and [max].
  final double value;

  /// {@macro remix.component.style}
  final RxSliderStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro remix.component.enabled}
  @override
  final bool enabled;

  /// Called when the user starts dragging the slider.
  final ValueChanged<double>? onChangeStart;

  /// Called during drag with the new value.
  final ValueChanged<double>? onChanged;

  /// Called when the user is done selecting a new value.
  final ValueChanged<double>? onChangeEnd;

  @override
  State<RxSlider> createState() => _RxSliderState();
}

class _RxSliderState extends State<RxSlider>
    with TickerProviderStateMixin, MixControllerMixin, DisableableMixin {
  int? get _divisions {
    if (widget.divisions == 0) {
      return null;
    }

    return widget.divisions;
  }

  RxSliderStyle get _style =>
      RxSliderStyle._default().merge(widget.style ?? RxSliderStyle());

  @override
  Widget build(BuildContext context) {
    return NakedSlider(
      value: widget.value,
      min: widget.min,
      max: widget.max,
      onChanged: widget.onChanged,
      onHoverState: (state) {
        mixController.hovered = state;
      },
      onDraggingState: (state) {
        mixController.dragged = state;
      },
      onFocusState: (state) {
        mixController.focused = state;
      },
      enabled: widget.enabled,
      direction: Axis.horizontal,
      divisions: _divisions,
      child: RemixBuilder(
        builder: (context) {
          final spec = SliderSpec.of(context);
          final height = spec.thumb.height;
          final horizontalPadding = height ?? 0;

          return SizedBox(
            height: height,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final thumbPosition =
                    (constraints.maxWidth - horizontalPadding) * widget.value;

                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding / 2,
                      ),
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: _AnimatedTrack(
                          value: widget.value,
                          active: spec.activeTrack,
                          baseTrack: spec.baseTrack,
                          divisions: _divisions,
                          division: spec.division,
                          duration: spec.animated?.duration ??
                              const Duration(milliseconds: 200),
                          curve: spec.animated?.curve ?? Curves.linear,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(thumbPosition, 0),
                      child: spec.thumb(),
                    ),
                  ],
                );
              },
            ),
          );
        },
        style: Style(_style).applyVariants(widget.variants),
        controller: mixController,
      ),
    );
  }
}

class _TrackPainter extends CustomPainter {
  final double value;
  final PaintData active;
  final PaintData baseTrack;
  final int? divisions;
  final PaintData division;
  final Color color;

  const _TrackPainter({
    required this.value,
    required this.active,
    required this.baseTrack,
    required this.divisions,
    required this.division,
    required this.color,
  });

  List<Offset> calculateDivisionsPositions(int divisions, Size size) {
    final list = <Offset>[];
    for (var i = 0; i < divisions; i++) {
      list.add(Offset((i + 1) * size.width / divisions, size.midY));
    }

    return list;
  }

  void drawDivisions(Canvas canvas, Size size) {
    final divisionsPaint = Paint()
      ..color = division.color
      ..strokeWidth = division.strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawPoints(
      PointMode.points,
      calculateDivisionsPositions(divisions!, size),
      divisionsPaint,
    );
  }

  void drawTrack(
    Canvas canvas,
    Offset initialOffset,
    Offset endOffset,
    PaintData data,
    Color color,
  ) {
    final trackPaint = Paint()
      ..color = color
      ..strokeWidth = data.strokeWidth
      ..strokeCap = data.strokeCap;

    canvas.drawLine(initialOffset, endOffset, trackPaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final initialOffset = Offset(0, size.midY);
    final endOffset = Offset(size.width, size.midY);

    final realWidth = size.width;

    drawTrack(canvas, initialOffset, endOffset, baseTrack, baseTrack.color);

    if (divisions != null) {
      drawDivisions(canvas, size);
    }

    drawTrack(
      canvas,
      initialOffset,
      Offset((realWidth) * value, size.midY),
      active,
      color,
    );
  }

  @override
  bool shouldRepaint(_TrackPainter oldDelegate) {
    return value != oldDelegate.value ||
        active != oldDelegate.active ||
        baseTrack != oldDelegate.baseTrack ||
        divisions != oldDelegate.divisions;
  }
}

extension on Size {
  double get midY => height / 2;
}

class _AnimatedTrack extends StatefulWidget {
  const _AnimatedTrack({
    required this.value,
    required this.active,
    required this.baseTrack,
    required this.divisions,
    required this.division,
    required this.duration,
    required this.curve,
  });

  final double value;
  final PaintData active;
  final PaintData baseTrack;
  final int? divisions;
  final PaintData division;

  final Duration duration;
  final Curve curve;

  @override
  _AnimatedTrackState createState() => _AnimatedTrackState();
}

class _AnimatedTrackState extends State<_AnimatedTrack> {
  _Tracks? _oldTracks;

  @override
  void initState() {
    super.initState();
    _oldTracks = _Tracks(
      active: widget.active,
      baseTrack: widget.baseTrack,
      division: widget.division,
    );
  }

  @override
  void didUpdateWidget(covariant _AnimatedTrack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _oldTracks = _Tracks(
      active: oldWidget.active,
      baseTrack: oldWidget.baseTrack,
      division: oldWidget.division,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: _TracksTween(
        begin: _oldTracks,
        end: _Tracks(
          active: widget.active,
          baseTrack: widget.baseTrack,
          division: widget.division,
        ),
      ),
      duration: widget.duration,
      curve: widget.curve,
      builder: (context, value, child) {
        return CustomPaint(
          painter: _TrackPainter(
            value: widget.value,
            active: value.active,
            baseTrack: value.baseTrack,
            divisions: widget.divisions,
            division: value.division,
            color: value.active.color,
          ),
        );
      },
    );
  }
}

class _Tracks {
  final PaintData active;
  final PaintData baseTrack;
  final PaintData division;

  const _Tracks({
    required this.active,
    required this.baseTrack,
    required this.division,
  });

  @override
  bool operator ==(Object other) {
    return other is _Tracks &&
        active == other.active &&
        baseTrack == other.baseTrack &&
        division == other.division;
  }

  @override
  int get hashCode => active.hashCode ^ baseTrack.hashCode ^ division.hashCode;
}

class _TracksTween extends Tween<_Tracks> {
  _TracksTween({required super.begin, required super.end});

  @override
  _Tracks lerp(double t) {
    return _Tracks(
      active: begin!.active.lerp(end!.active, t),
      baseTrack: begin!.baseTrack.lerp(end!.baseTrack, t),
      division: begin!.division.lerp(end!.division, t),
    );
  }
}
