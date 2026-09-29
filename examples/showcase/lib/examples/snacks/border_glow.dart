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
const whiteColor = Color(0xFFFFFFFF);
const roseColor = Color(0xFFFF3264);
const amberColor = Color(0xFFFFA01E);
const greenColor = Color(0xFF32C850);
const cyanColor = Color(0xFF28B4DC);
const violetColor = Color(0xFF6446FF);

const glowRadius = 16.0;
const glowWidth = 1.5;

/// A comet: hairline tail, colored body with a white-hot core, hairline head.
const glowStops = [0.30, 0.40, 0.52, 0.62, 0.70, 0.78, 0.86, 0.95];
final glowColors = [
  hairlineColor,
  roseColor.withAlpha(0x59),
  amberColor,
  greenColor,
  whiteColor,
  cyanColor,
  violetColor.withAlpha(0x59),
  hairlineColor,
];

/// The comet's hues, which the button halo cycles through.
const haloColors = [roseColor, amberColor, greenColor, cyanColor, violetColor];

final glowGradient = SweepGradientMix.colors(glowColors).stops(glowStops);

/// One 1.96s loop shared by the ring, card glow and button halo, so all three
/// stay in step: the comet's angle, a color cycle and a slow breath.
final glowTimeline = [
  KeyframeTrack<double>('angle', [.linear(math.pi * 2, 1960.ms)], initial: 0),
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
    .easeInOut(1, 980.ms),
    .easeInOut(0.5, 980.ms),
  ], initial: 0.5),
];

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
    timeline: glowTimeline,
    styleBuilder: (values, style) => style.gradient(
      glowGradient.transform(GradientRotation(values.get<double>('angle'))),
    ),
  );
}

/// The same comet at half its strength, blended onto the card.
final glowInnerGradient = SweepGradientMix.colors([
  for (final color in glowColors)
    Color.alphaBlend(color.withValues(alpha: color.a * 0.5), surfaceColor),
]).stops(glowStops);

/// The card: its backdrop spins the dimmed comet in step with the ring, and
/// the veil above lets only its outer edge show, as a soft inner glow. Both
/// layers fill the card, so only the card sets a size.
StackBoxStyler glowCardStyle({required bool isActive}) {
  final card = StackBoxStyler()
      .size(240, 120)
      .borderRadius(.circular(glowRadius - glowWidth))
      // Keeps the veil's blurred shadow from spilling past the card.
      .clipBehavior(.antiAlias)
      .fit(.expand);
  if (!isActive) return card.color(surfaceColor).animate(.easeOut(400.ms));

  return card.keyframeAnimation(
    timeline: glowTimeline,
    styleBuilder: (values, style) => style.gradient(
      glowInnerGradient.transform(
        GradientRotation(values.get<double>('angle')),
      ),
    ),
  );
}

/// A surface-colored shadow inset from the edge; its blur feathers the glow
/// from the border inward.
final glowVeil = BoxStyler()
    .margin(.all(4))
    .borderRadius(.circular(10))
    .shadow(.color(surfaceColor).blurRadius(14));

final glowRow = FlexBoxStyler()
    .padding(.all(20))
    .direction(.horizontal)
    .spacing(14);

/// Reacts to the card's hover and press, then springs back with a bounce.
BoxStyler glowButtonStyle({required bool isActive}) => BoxStyler()
    .size(44, 44)
    .shape(.circle())
    .color(isActive ? inkColor : trackColor)
    .onHovered(.scale(1.08))
    .onPressed(.scale(0.86))
    .animate(.spring(360.ms, bounce: 0.45));

/// A soft halo that orbits the button with the comet and breathes. It lives on
/// a wrapper so its loop never fights the button's hover and press spring.
BoxStyler glowHaloStyle({required bool isActive}) {
  final halo = BoxStyler().shape(.circle());
  if (!isActive) return halo.animate(.easeOut(400.ms));

  return halo.keyframeAnimation(
    timeline: glowTimeline,
    styleBuilder: (values, style) {
      // 0.7 of a turn ahead points the halo at the comet's white core.
      final heading = values.get<double>('angle') + math.pi * 1.4;
      final alpha = values.get<double>('alpha') * 0.4;

      return style.shadow(
        .offset(.fromDirection(heading, 5))
            .color(values.get<Color>('color').withValues(alpha: alpha))
            .blurRadius(18),
      );
    },
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
    final glowCard = glowCardStyle(isActive: _active);
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
        children: [
          glowVeil(),
          glowRow(
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
        ],
      ),
    );
  }
}

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
