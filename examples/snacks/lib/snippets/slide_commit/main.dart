import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const mutedColor = Color(0xFF8B8B93);
const trackColor = Color(0xFF27272F);
const successColor = Color(0xFF3DD68C);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: .dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF7C6AF7),
        brightness: .dark,
      ),
      useMaterial3: true,
    ),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: SlideCommit()),
        ),
      ),
    ),
  ),
);

const _width = 280.0;
const _height = 56.0;
const _grip = _height - 8;
const _travel = _width - _height;

/// Shows a horizontal drag cursor only while the track accepts input.
StackBoxStyler slideTrackStyle({required bool busy, required bool done}) =>
    StackBoxStyler()
        .size(_width, _height)
        .color(trackColor)
        .shapeStadium()
        .clipBehavior(.antiAlias)
        .stackAlignment(.centerLeft)
        .wrap(
          .modifier(
            MouseCursorModifierMix(
              mouseCursor: busy
                  ? SystemMouseCursors.progress
                  : done
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.resizeLeftRight,
            ),
          ),
        );

/// Fades the instruction as the grip travels across it.
BoxStyler slideLabelFadeStyle({
  required String phase,
  required bool isDragging,
  required double labelOpacity,
}) => BoxStyler()
    .size(_width, _height)
    .alignment(.center)
    .wrap(.opacity(phase == 'idle' ? labelOpacity : 0))
    .animate(isDragging ? .linear(1.ms) : .easeOut(200.ms));

final slideLabel = TextStyler()
    .color(mutedColor)
    .fontSize(14)
    .fontWeight(.w500);

/// Follows the drag, then settles without overshooting the track.
BoxStyler slideCapsuleStyle({
  required bool isDragging,
  required double offset,
  required bool isDone,
}) => BoxStyler()
    .width(isDone ? _width - 8 : _grip)
    .height(_grip)
    .shapeStadium()
    .color(isDone ? successColor : inkColor)
    .clipBehavior(.antiAlias)
    .alignment(.center)
    .translate(4 + offset, 0)
    // A non-overshooting spring keeps capsule edges in the track.
    .animate(isDragging ? .linear(1.ms) : .spring(380.ms, bounce: 0));

final slideSuccessRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(8)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

final slideSuccessIcon = IconStyler().size(18).color(pageColor);

final slideSuccessLabel = TextStyler()
    .fontSize(14)
    .fontWeight(.w600)
    .color(pageColor);

final slideArrow = IconStyler().size(20).color(pageColor);

/// Drag the grip to the end to commit; cancellation returns it to the start.
class SlideCommit extends StatefulWidget {
  const SlideCommit({super.key});

  @override
  State<SlideCommit> createState() => _SlideCommitState();
}

class _SlideCommitState extends State<SlideCommit> {
  double _x = 0;
  bool _dragging = false;
  bool _canceled = false;
  String _phase = 'idle';
  Timer? _completion;

  @override
  void dispose() {
    _completion?.cancel();
    super.dispose();
  }

  void _release({bool canceled = false}) {
    if (_phase != 'idle') return;
    final commit = !canceled && !_canceled && _x >= _travel;
    setState(() {
      _dragging = false;
      _x = commit ? _travel : 0;
      if (commit) _phase = 'busy';
    });
    if (!commit) return;
    _completion = Timer(700.ms, () {
      setState(() {
        _phase = 'done';
        _x = 0;
      });
      _completion = Timer(1500.ms, () => setState(() => _phase = 'idle'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final done = _phase == 'done';
    final busy = _phase == 'busy';
    final labelOpacity = (1 - _x / (_travel * 0.55)).clamp(0.0, 1.0);
    final slideLabelFade = slideLabelFadeStyle(
      phase: _phase,
      isDragging: _dragging,
      labelOpacity: labelOpacity,
    );
    final slideCapsule = slideCapsuleStyle(
      isDragging: _dragging,
      offset: _x,
      isDone: done,
    );
    final track = slideTrackStyle(busy: busy, done: done);

    return Semantics(
      label: 'Slide to pay',
      value: busy
          ? 'Working'
          : done
          ? 'Paid'
          : '${(_x / _travel * 100).round()}%',
      child: Listener(
        onPointerCancel: (_) {
          _canceled = true;
          _release(canceled: true);
        },
        child: GestureDetector(
          key: const Key('slide-commit'),
          onHorizontalDragStart: _phase == 'idle'
              ? (_) => setState(() {
                  _dragging = true;
                  _canceled = false;
                })
              : null,
          onHorizontalDragUpdate: _phase == 'idle'
              ? (details) => setState(
                  () => _x = (_x + details.delta.dx).clamp(0.0, _travel),
                )
              : null,
          onHorizontalDragEnd: _phase == 'idle' ? (_) => _release() : null,
          onHorizontalDragCancel: () => _release(canceled: true),
          child: track(
            children: [
              slideLabelFade(
                key: const Key('slide-label'),
                child: slideLabel('Slide to pay'),
              ),
              slideCapsule(
                key: const Key('slide-capsule'),
                // The success face is revealed as the capsule expands; it must
                // not reflow or overflow while the capsule is still grip-sized.
                child: OverflowBox(
                  minWidth: 0,
                  maxWidth: _width - 8,
                  child: done
                      ? slideSuccessRow(
                          children: [
                            slideSuccessIcon(icon: Icons.check_rounded),
                            slideSuccessLabel('Paid'),
                          ],
                        )
                      : busy
                      ? SizedBox(
                          key: const Key('slide-pending'),
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: pageColor,
                            semanticsLabel: 'Working',
                          ),
                        )
                      : slideArrow(icon: Icons.arrow_forward_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
