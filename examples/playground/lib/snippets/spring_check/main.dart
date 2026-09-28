import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);

/// Paste this file into DartPad, then click the checkbox to toggle the spring.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    // Keep platform typography without introducing theme tokens for the demo.
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: SpringCheck()),
        ),
      ),
    ),
  ),
);

// Fixed styles stay outside build; state-dependent styles take explicit inputs.
final checkRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(12)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min)
    .paddingY(8);

final checkBox = StackBoxStyler()
    .size(28, 28)
    .borderRounded(6)
    .clipBehavior(.antiAlias)
    .stackAlignment(.center)
    .onPressed(.scale(0.95))
    .animate(.easeOut(160.ms));

final checkOutline = BoxStyler()
    .size(28, 28)
    .borderRounded(6)
    .border(.color(inkColor).width(2))
    .wrap(.opacity(0.28))
    .onHovered(.new().wrap(.opacity(0.5)))
    .animate(.easeOut(120.ms));

final checkLabelStack = StackBoxStyler().stackAlignment(.centerLeft);

/// Springs the fill independently of the tick's fade.
BoxStyler checkFillStyle({required bool isChecked}) => BoxStyler()
    .size(28, 28)
    .color(inkColor)
    .borderRounded(6)
    .scale(isChecked ? 1 : 0.01)
    .animate(.spring(280.ms, bounce: 0.22));

/// Delays the tick slightly so the expanding fill leads the transition.
IconStyler checkTickStyle({required bool isChecked}) => IconStyler()
    .size(18)
    .color(pageColor)
    .wrap(.opacity(isChecked ? 1 : 0))
    .animate(.easeOut(140.ms, delay: 40.ms));

/// Dims the completed label without changing its layout.
TextStyler checkLabelStyle({required bool isChecked}) => TextStyler()
    .color(inkColor)
    .fontSize(18)
    .fontWeight(.w600)
    .wrap(.opacity(isChecked ? 0.42 : 1))
    .animate(.easeOut(220.ms));

/// Grows the strike from the label's left edge using its measured width.
BoxStyler checkStrikeStyle({required bool isChecked}) => BoxStyler()
    .height(1.5)
    .color(inkColor)
    .borderRounded(2)
    .wrap(
      .align(
        alignment: .centerLeft,
      ).scale(isChecked ? 1 : 0.01, 1, alignment: .centerLeft),
    )
    .animate(.spring(240.ms, bounce: 0.06));

/// A checkbox with a spring fill and a matching animated strikethrough.
///
/// Hold to shrink the box; release to toggle it. Each style owns its animation,
/// so the fill can bounce while the tick and label fade independently.
class SpringCheck extends StatefulWidget {
  const SpringCheck({super.key});

  @override
  State<SpringCheck> createState() => _SpringCheckState();
}

class _SpringCheckState extends State<SpringCheck> {
  bool _checked = false;

  void _toggle() => setState(() => _checked = !_checked);

  @override
  Widget build(BuildContext context) {
    final fill = checkFillStyle(isChecked: _checked);
    final tick = checkTickStyle(isChecked: _checked);
    final label = checkLabelStyle(isChecked: _checked);
    final strike = checkStrikeStyle(isChecked: _checked);

    return Semantics(
      // The visible text supplies the label; this node owns the checkbox action.
      checked: _checked,
      onTap: _toggle,
      child: Pressable(
        key: const Key('spring-check'),
        excludeFromSemantics: true,
        onPress: _toggle,
        child: checkRow(
          children: [
            checkBox(
              children: [
                checkOutline(),
                fill(key: const Key('spring-check-fill')),
                tick(icon: Icons.check_rounded),
              ],
            ),
            checkLabelStack(
              children: [
                label('Ship the build'),
                Positioned.fill(child: strike()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
