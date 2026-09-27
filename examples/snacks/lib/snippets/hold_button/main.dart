import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const dangerColor = Color(0xFFFF5C7A);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: HoldButton()),
        ),
      ),
    ),
  ),
);

final holdButton = BoxStyler()
    .width(168)
    .height(48)
    .borderRounded(14)
    .color(dangerColor)
    .clipBehavior(.antiAlias)
    .alignment(.center)
    .onPressed(.scale(0.98))
    .animate(.spring(220.ms, bounce: 0.08));

final holdStack = StackBoxStyler().size(168, 48).stackAlignment(.center);

/// Follows controller progress directly so early release can roll back.
BoxStyler holdFillStyle({required double progress}) =>
    BoxStyler().width(168).height(48 * progress).color(const Color(0xFF8A1028));

final holdLabel = TextStyler().fontSize(14).fontWeight(.w600).color(inkColor);

/// Hold to fill the button; early release rolls back and a later tap resets it.
class HoldButton extends StatefulWidget {
  const HoldButton({super.key});

  @override
  State<HoldButton> createState() => _HoldButtonState();
}

class _HoldButtonState extends State<HoldButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fill = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  bool _done = false;
  bool _resetOnRelease = false;

  @override
  void initState() {
    super.initState();
    _fill.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _done = true);
      }
    });
  }

  @override
  void dispose() {
    _fill.dispose();
    super.dispose();
  }

  void _reset() {
    _fill
      ..stop()
      ..value = 0;
    setState(() => _done = false);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        _resetOnRelease = _done;
        if (!_done) _fill.forward();
      },
      onPointerUp: _done
          ? null
          : (_) {
              if (!_done) _fill.reverse();
            },
      onPointerCancel: _done ? null : (_) => _fill.reverse(),
      child: PressableBox(
        key: const Key('hold-button'),
        onPress: () {
          if (_resetOnRelease) _reset();
        },
        style: holdButton,
        child: AnimatedBuilder(
          animation: _fill,
          builder: (context, _) {
            return holdStack(
              children: [
                Positioned(
                  bottom: 0,
                  child: holdFillStyle(progress: _fill.value)(),
                ),
                holdLabel(_done ? 'Deleted' : 'Hold to delete'),
              ],
            );
          },
        ),
      ),
    );
  }
}
