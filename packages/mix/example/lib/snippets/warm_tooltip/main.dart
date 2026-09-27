import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const trackColor = Color(0xFF27272F);
const hoverColor = Color(0xFF32323C);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: WarmTooltip()),
        ),
      ),
    ),
  ),
);

final tooltipRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(8)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

final tooltipColumn = FlexBoxStyler()
    .direction(.vertical)
    .spacing(6)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

/// Lifts and fades the bubble after the hover delay.
BoxStyler tooltipBubbleStyle({required bool isOpen}) => BoxStyler()
    .paddingX(8)
    .paddingY(4)
    .borderRounded(8)
    .color(inkColor)
    .wrap(.opacity(isOpen ? 1 : 0))
    .translate(0, isOpen ? 0 : 6)
    .animate(.easeOut(220.ms));

final tooltipLabel = TextStyler()
    .fontSize(11)
    .fontWeight(.w600)
    .color(pageColor);

final tooltipButton = BoxStyler()
    .size(40, 40)
    .borderRounded(12)
    .color(trackColor)
    .alignment(.center)
    .onHovered(.color(hoverColor))
    .animate(.easeOut(160.ms));

final tooltipIcon = IconStyler().size(18).color(inkColor);

/// Hover an action to reveal its tooltip; nearby actions reuse the warm delay.
class WarmTooltip extends StatefulWidget {
  const WarmTooltip({super.key});

  @override
  State<WarmTooltip> createState() => _WarmTooltipState();
}

class _WarmTooltipState extends State<WarmTooltip> {
  int? _open;
  bool _warm = false;
  Timer? _cooldown;
  Timer? _delay;

  @override
  void dispose() {
    _delay?.cancel();
    _cooldown?.cancel();
    super.dispose();
  }

  void _enter(int index) {
    _delay?.cancel();
    _cooldown?.cancel();
    if (_warm) {
      setState(() => _open = index);
      return;
    }
    _delay = Timer(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      setState(() {
        _open = index;
        _warm = true;
      });
    });
  }

  void _exit() {
    _delay?.cancel();
    _cooldown?.cancel();
    _cooldown = Timer(700.ms, () => _warm = false);
    setState(() => _open = null);
  }

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.cut_rounded, 'Cut'),
      (Icons.content_copy_rounded, 'Copy'),
      (Icons.content_paste_rounded, 'Paste'),
    ];
    return tooltipRow(
      key: const Key('warm-tooltip'),
      children: [
        for (var i = 0; i < items.length; i++)
          MouseRegion(
            onEnter: (_) => _enter(i),
            onExit: (_) => _exit(),
            child: tooltipColumn(
              children: [
                tooltipBubbleStyle(isOpen: _open == i)(
                  child: tooltipLabel(items[i].$2),
                ),
                PressableBox(
                  onPress: () {},
                  style: tooltipButton,
                  child: tooltipIcon(icon: items[i].$1),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
