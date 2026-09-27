import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const cardColor = Color(0xFF121218);
const inkColor = Color(0xFFF5F5F7);
const trackColor = Color(0xFF27272F);
const accentColor = Color(0xFF7C6AF7);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: SwipeToast()),
        ),
      ),
    ),
  ),
);

final toastColumn = FlexBoxStyler()
    .direction(.vertical)
    .spacing(12)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

final toastButton = BoxStyler()
    .paddingX(14)
    .paddingY(8)
    .borderRounded(12)
    .color(trackColor)
    .onPressed(.scale(0.96))
    .animate(.spring(240.ms, bounce: 0.12));

final toastLabel = TextStyler().color(inkColor).fontSize(13).fontWeight(.w600);

/// Animates the toast's layout space for entrance and exit.
BoxStyler toastRevealStyle({required bool isVisible}) => BoxStyler()
    .wrap(
      .align(
        alignment: .topCenter,
        widthFactor: 1,
        heightFactor: isVisible ? 1 : 0,
      ),
    )
    .animate(.easeOut(isVisible ? 400.ms : 280.ms));

/// Springs back after release, but follows a drag directly.
BoxStyler toastTravelStyle({
  required bool isDragging,
  required bool isVisible,
  required double drag,
}) => BoxStyler()
    .translate(0, isVisible ? drag : 60)
    .animate(
      isDragging
          ? .linear(1.ms)
          : isVisible
          ? .spring(320.ms, bounce: 0.12)
          : .easeOut(280.ms),
    );

/// Keeps the fade bounded independently of the position spring.
BoxStyler toastSurfaceStyle({required bool isVisible}) => BoxStyler()
    .width(220)
    .paddingAll(12)
    .borderRounded(14)
    .color(cardColor)
    .border(.color(const Color(0x22FFFFFF)).width(1))
    .wrap(.opacity(isVisible ? 1 : 0))
    .animate(.easeOut(isVisible ? 400.ms : 280.ms));

final toastContent = FlexBoxStyler()
    .direction(.vertical)
    .spacing(8)
    .crossAxisAlignment(.start);

/// Shrinks the countdown bar and dismisses the toast on completion.
BoxStyler toastFuseStyle({
  required bool isBurning,
  required VoidCallback onEnd,
}) => BoxStyler()
    .height(3)
    .shapeStadium()
    .color(accentColor)
    .constraintsOnly(minWidth: 0, maxWidth: isBurning ? 0 : 196)
    .animate(isBurning ? .linear(2600.ms, onEnd: onEnd) : .linear(1.ms));

/// Tap Notify to start a countdown; swipe down to dismiss the toast early.
class SwipeToast extends StatefulWidget {
  const SwipeToast({super.key});

  @override
  State<SwipeToast> createState() => _SwipeToastState();
}

class _SwipeToastState extends State<SwipeToast> {
  bool _visible = false;
  bool _burning = false;
  bool _dragging = false;
  bool _canceled = false;
  double _drag = 0;

  void _show() {
    setState(() {
      _visible = true;
      _burning = false;
      _drag = 0;
      _dragging = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_visible) return;
      setState(() => _burning = true);
    });
  }

  void _dismiss() {
    if (!mounted || !_visible) return;
    setState(() {
      _visible = false;
      _burning = false;
      _drag = 0;
      _dragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final toastReveal = toastRevealStyle(isVisible: _visible);
    final toastSurface = toastSurfaceStyle(isVisible: _visible);
    final toastTravel = toastTravelStyle(
      isDragging: _dragging,
      isVisible: _visible,
      drag: _drag,
    );
    final toastFuse = toastFuseStyle(isBurning: _burning, onEnd: _dismiss);

    return toastColumn(
      key: const Key('swipe-toast'),
      children: [
        PressableBox(
          onPress: _show,
          style: toastButton,
          child: toastLabel('Notify'),
        ),
        IgnorePointer(
          ignoring: !_visible,
          child: ExcludeSemantics(
            excluding: !_visible,
            child: ClipRect(
              key: const Key('toast-reveal'),
              child: toastReveal(
                child: Listener(
                  onPointerCancel: (_) => setState(() {
                    _canceled = true;
                    _dragging = false;
                    _drag = 0;
                  }),
                  child: GestureDetector(
                    onVerticalDragStart: (_) => setState(() {
                      _dragging = true;
                      _canceled = false;
                    }),
                    onVerticalDragUpdate: (details) {
                      setState(
                        () => _drag = (_drag + details.delta.dy).clamp(
                          0.0,
                          120.0,
                        ),
                      );
                    },
                    onVerticalDragEnd: (_) {
                      if (_canceled) return;
                      setState(() => _dragging = false);
                      if (_drag > 28) {
                        _dismiss();
                      } else {
                        setState(() => _drag = 0);
                      }
                    },
                    onVerticalDragCancel: () => setState(() {
                      _dragging = false;
                      _drag = 0;
                    }),
                    child: toastTravel(
                      child: toastSurface(
                        child: toastContent(
                          children: [
                            toastLabel('Mix saved the draft'),
                            toastFuse(key: const Key('toast-fuse')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
