import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const trackColor = Color(0xFF27272F);
const hoverColor = Color(0xFF32323C);
const warningColor = Color(0xFFF5C542);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: FuseButton()),
        ),
      ),
    ),
  ),
);

final fuseButton = BoxStyler()
    .size(148, 44)
    .shapeStadium()
    .color(trackColor)
    .clipBehavior(.antiAlias)
    .onHovered(.color(hoverColor))
    .onPressed(.scale(0.97))
    .animate(.spring(240.ms, bounce: 0.12));

final fuseStack = StackBoxStyler().stackAlignment(.center);

/// Crossfades one face without changing the countdown's geometry.
BoxStyler fuseFaceStyle({required bool isVisible}) => BoxStyler()
    .size(148, 44)
    .alignment(.center)
    .wrap(.opacity(isVisible ? 1 : 0))
    .animate(.easeOut(200.ms));

final fuseRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(8)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

final fuseIcon = IconStyler().size(15).color(inkColor);

final fuseLabel = TextStyler().color(inkColor).fontSize(14).fontWeight(.w600);

/// Tap Archive to start the fuse, then Undo to cancel; hover reentry pauses it.
class FuseButton extends StatefulWidget {
  const FuseButton({super.key});

  @override
  State<FuseButton> createState() => _FuseButtonState();
}

class _FuseButtonState extends State<FuseButton>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool _armed = false;
  bool _canPauseOnHover = false;
  bool _hoverPaused = false;
  bool _hidden = false;
  late final AnimationController _fuse;

  @override
  void initState() {
    super.initState();
    _fuse = AnimationController(vsync: this, duration: 4000.ms)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) setState(() => _armed = false);
      });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fuse.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _hidden = state != AppLifecycleState.resumed;
    _syncCountdown();
  }

  void _syncCountdown() {
    if (!_armed) return;
    if (_hoverPaused || _hidden) {
      _fuse.stop();
    } else {
      _fuse.forward();
    }
  }

  void _press() {
    if (_armed) {
      _fuse.stop();
      setState(() => _armed = false);
    } else {
      setState(() {
        _armed = true;
        _canPauseOnHover = false;
        _hoverPaused = false;
      });
      _fuse.forward(from: 0);
      _syncCountdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _hoverPaused = _canPauseOnHover;
        _syncCountdown();
      },
      onExit: (_) {
        _canPauseOnHover = true;
        _hoverPaused = false;
        _syncCountdown();
      },
      child: PressableBox(
        key: const Key('fuse-button'),
        onPress: _press,
        style: fuseButton,
        child: CustomPaint(
          key: const Key('fuse-outline'),
          // Path drawing and pausable elapsed time are the custom part;
          // the two faces and all ordinary chrome remain Mix styles.
          foregroundPainter: _armed ? _FuseOutline(_fuse, warningColor) : null,
          child: fuseStack(
            children: [
              for (final undo in [false, true])
                IgnorePointer(
                  ignoring: _armed != undo,
                  child: ExcludeSemantics(
                    excluding: _armed != undo,
                    child: fuseFaceStyle(isVisible: _armed == undo)(
                      child: fuseRow(
                        children: [
                          fuseIcon(
                            icon: undo
                                ? Icons.undo_rounded
                                : Icons.archive_outlined,
                          ),
                          fuseLabel(undo ? 'Undo' : 'Archive'),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FuseOutline extends CustomPainter {
  _FuseOutline(this.progress, this.color) : super(repaint: progress);

  final Animation<double> progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 1.5;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)),
      );
    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(metric.length * progress.value, metric.length),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_FuseOutline oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
