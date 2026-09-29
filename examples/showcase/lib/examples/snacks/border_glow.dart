import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const surfaceColor = Color(0xFF15151C);
const inkColor = Color(0xFFF5F5F7);
const mutedColor = Color(0xFF8B8B93);
const hairlineColor = Color(0x14FFFFFF);
const hoverColor = Color(0x33FFFFFF);
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
          child: Padding(padding: .all(24), child: BorderGlow()),
        ),
      ),
    ),
  ),
);

const glowRadius = 16.0;
const glowWidth = 1.5;

/// A comet: hairline tail, colored body with a white-hot core, hairline head.
const glowStops = [0.30, 0.40, 0.52, 0.62, 0.70, 0.78, 0.86, 0.95];
const glowColors = [
  hairlineColor,
  Color(0x59FF3264),
  Color(0xFFFFA01E),
  Color(0xFF32C850),
  Color(0xFFFFFFFF),
  Color(0xFF28B4DC),
  Color(0x596446FF),
  hairlineColor,
];

/// The comet's saturated colors, which the button halo cycles through.
const haloColors = [
  Color(0xFFFF3264),
  Color(0xFFFFA01E),
  Color(0xFF32C850),
  Color(0xFF28B4DC),
  Color(0xFF6446FF),
];

final glowGradient = SweepGradientMix.colors(glowColors).stops(glowStops);

/// Paints the border ring: the child covers everything inside the padding.
/// While active, a keyframe loop spins the comet around once per 1.96s; the
/// idle ease-out replaces that loop and fades the comet back to a hairline,
/// which brightens on hover to invite a press.
BoxStyler glowRingStyle({required bool isActive}) {
  final ring = BoxStyler()
      .padding(.all(glowWidth))
      .borderRadius(.circular(glowRadius));
  if (!isActive) {
    return ring
        .color(hairlineColor)
        .onHovered(.color(hoverColor))
        .animate(.easeOut(400.ms));
  }

  return ring.keyframeAnimation(
    timeline: [
      KeyframeTrack<double>('turn', [.linear(1, 1960.ms)], initial: 0),
    ],
    styleBuilder: (values, style) {
      final angle = values.get<double>('turn') * math.pi * 2;

      return style.gradient(glowGradient.transform(GradientRotation(angle)));
    },
  );
}

final glowCard = BoxStyler()
    .size(240, 120)
    .padding(.all(20))
    .alignment(.centerLeft)
    .color(surfaceColor)
    .borderRadius(.circular(glowRadius - glowWidth));

final glowRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(14)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

/// Reacts to the card's hover and press, then springs back with a bounce.
BoxStyler glowButtonStyle({required bool isActive}) => BoxStyler()
    .size(44, 44)
    .shape(.circle())
    .alignment(.center)
    .color(isActive ? inkColor : trackColor)
    .onHovered(.scale(1.08))
    .onPressed(.scale(0.86))
    .animate(.spring(360.ms, bounce: 0.45));

BoxShadowMix glowHaloShadow({
  required double alpha,
  Color color = inkColor,
  Offset offset = .zero,
}) => BoxShadowMix.color(
  color.withValues(alpha: alpha),
).blurRadius(18).offset(x: offset.dx, y: offset.dy);

/// A soft halo that orbits the button in step with the border comet (same
/// 1.96s loop), cycles through the comet's colors, and breathes as it goes. It lives on a wrapper so its loop never
/// fights the button's hover and press spring.
BoxStyler glowHaloStyle({required bool isActive}) {
  final halo = BoxStyler().size(44, 44).shape(.circle());
  if (!isActive) {
    return halo.shadow(glowHaloShadow(alpha: 0)).animate(.easeOut(400.ms));
  }

  return halo.keyframeAnimation(
    timeline: [
      KeyframeTrack<double>('turn', [.linear(1, 1960.ms)], initial: 0),
      KeyframeTrack<Color>(
        'color',
        [
          for (final color in [...haloColors.skip(1), haloColors.first])
            .linear(color, 392.ms),
        ],
        initial: haloColors.first,
        tweenBuilder: ColorTween.new,
      ),
      KeyframeTrack<double>('alpha', [
        .easeInOut(0.6, 980.ms),
        .easeInOut(0.3, 980.ms),
      ], initial: 0.3),
    ],
    styleBuilder: (values, style) => style.shadow(
      glowHaloShadow(
        alpha: values.get<double>('alpha'),
        color: values.get<Color>('color'),
        // 0.7 of a turn lines the halo up with the comet's white core.
        offset: .fromDirection(
          (values.get<double>('turn') + 0.7) * math.pi * 2,
          5,
        ),
      ),
    ),
  );
}

/// Squashes the icon, swaps it at the dip, then pops it back on each toggle.
BoxStyler glowIconPopStyle({required Listenable trigger}) =>
    BoxStyler().keyframeAnimation(
      trigger: trigger,
      timeline: [
        KeyframeTrack<double>('scale', [
          .easeIn(0.55, 90.ms),
          .easeOut(1.2, 150.ms),
          .easeInOut(1, 140.ms),
        ], initial: 1),
      ],
      styleBuilder: (values, style) => style.scale(values.get<double>('scale')),
    );

IconStyler glowIconStyle({required bool isActive}) =>
    IconStyler().size(20).color(isActive ? pageColor : inkColor);

final glowLabels = FlexBoxStyler()
    .direction(.vertical)
    .spacing(2)
    .crossAxisAlignment(.start)
    .mainAxisSize(.min);

final glowTitle = TextStyler()
    .color(inkColor)
    .fontSize(14)
    .fontWeight(.w600)
    .maxLines(1)
    .overflow(.ellipsis);

/// Brightens the status line while the glow is running.
TextStyler glowStatusStyle({required bool isActive}) => TextStyler()
    .color(isActive ? inkColor : mutedColor)
    .fontSize(12)
    .fontWeight(.w500)
    .maxLines(1)
    .overflow(.ellipsis);

/// Press play to spin a glowing comet around the card; press again to stop.
class BorderGlow extends StatefulWidget {
  const BorderGlow({super.key});

  @override
  State<BorderGlow> createState() => _BorderGlowState();
}

class _BorderGlowState extends State<BorderGlow> {
  final _pop = ValueNotifier(0);
  bool _active = false;

  @override
  void dispose() {
    _pop.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _active = !_active);
    _pop.value++;
  }

  @override
  Widget build(BuildContext context) {
    final glowHalo = glowHaloStyle(isActive: _active);
    final glowButton = glowButtonStyle(isActive: _active);
    final glowIconPop = glowIconPopStyle(trigger: _pop);
    final glowIcon = glowIconStyle(isActive: _active);
    final glowStatus = glowStatusStyle(isActive: _active);

    // One pressable owns hover and press; the ring and button below react to
    // its states through their own variants.
    return PressableBox(
      key: const Key('border-glow'),
      semanticsLabel: _active ? 'Pause glow' : 'Play glow',
      onPress: _toggle,
      style: glowRingStyle(isActive: _active),
      child: glowCard(
        child: glowRow(
          children: [
            glowHalo(
              child: glowButton(
                child: glowIconPop(
                  child: glowIcon(
                    icon: _active
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                ),
              ),
            ),
            Flexible(
              child: glowLabels(
                children: [
                  glowTitle('Border Glow'),
                  glowStatus(_active ? 'Glowing…' : 'Tap to glow'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
