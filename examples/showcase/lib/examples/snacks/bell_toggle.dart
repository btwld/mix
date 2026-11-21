import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const trackColor = Color(0xFF27272F);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: BellToggle()),
        ),
      ),
    ),
  ),
);

/// Keeps the pill steady while acknowledging a press with a small spring.
BoxStyler bellSurfaceStyle({required bool isOn}) => BoxStyler()
    .width(188)
    .padding(.horizontal(14))
    .padding(.vertical(10))
    .shape(.stadium())
    .color(isOn ? inkColor : trackColor)
    .onPressed(.scale(0.96))
    .animate(.spring(240.ms, bounce: 0.12));

final bellRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(8)
    .crossAxisAlignment(.center)
    .mainAxisAlignment(.center)
    .mainAxisSize(.min);

/// Plays one ringing sequence per activation, independent of the pill spring.
BoxStyler bellSwingStyle({required Listenable trigger}) =>
    BoxStyler().keyframeAnimation(
      trigger: trigger,
      timeline: [
        KeyframeTrack<double>('tilt', [
          .easeOut(-0.35, 80.ms),
          .easeInOut(0.3, 90.ms),
          .easeInOut(-0.18, 90.ms),
          .easeOut(0, 80.ms),
        ], initial: 0),
      ],
      styleBuilder: (values, style) => style.rotate(values.get<double>('tilt')),
    );

/// Keeps the bell legible against either pill color.
IconStyler bellIconStyle({required bool isOn}) =>
    IconStyler().size(18).color(isOn ? pageColor : inkColor);

/// Matches the label to the pill's current contrast.
TextStyler bellLabelStyle({required bool isOn}) => TextStyler()
    .fontSize(14)
    .fontWeight(.w600)
    .color(isOn ? pageColor : inkColor);

/// Tap to toggle notifications and ring the bell without resizing the pill.
class BellToggle extends StatefulWidget {
  const BellToggle({super.key});

  @override
  State<BellToggle> createState() => _BellToggleState();
}

class _BellToggleState extends State<BellToggle> {
  final _trigger = ValueNotifier(0);
  bool _on = false;

  @override
  void dispose() {
    _trigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bellSurface = bellSurfaceStyle(isOn: _on);
    final bellSwing = bellSwingStyle(trigger: _trigger);
    final bellIcon = bellIconStyle(isOn: _on);
    final bellLabel = bellLabelStyle(isOn: _on);

    return PressableBox(
      key: const Key('bell-toggle'),
      onPress: () {
        setState(() => _on = !_on);
        _trigger.value++;
      },
      style: bellSurface,
      child: bellRow(
        children: [
          bellSwing(
            child: bellIcon(
              icon: _on
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_outlined,
            ),
          ),
          bellLabel(_on ? 'Notify me' : 'Muted'),
        ],
      ),
    );
  }
}
