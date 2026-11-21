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
          child: Padding(padding: .all(24), child: JellyRadio()),
        ),
      ),
    ),
  ),
);

final radioRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(8)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

/// Springs the selected pill's padding and scale.
BoxStyler radioOptionStyle({required bool isSelected}) => BoxStyler()
    .padding(.horizontal(isSelected ? 18 : 12))
    .padding(.vertical(isSelected ? 12 : 8))
    .shape(.stadium())
    .color(isSelected ? inkColor : trackColor)
    .scale(isSelected ? 1.04 : 1)
    .animate(.spring(360.ms, bounce: 0.38));

/// Transitions label contrast independently of the pill's spring.
TextStyler radioLabelStyle({required bool isSelected}) => TextStyler()
    .fontSize(13)
    .fontWeight(.w700)
    .color(isSelected ? pageColor : inkColor)
    .animate(.easeOut(180.ms));

/// Choose an option to spring its size and transition its label color.
class JellyRadio extends StatefulWidget {
  const JellyRadio({super.key});

  @override
  State<JellyRadio> createState() => _JellyRadioState();
}

class _JellyRadioState extends State<JellyRadio> {
  static const _labels = ['Quiet', 'Focus', 'Loud'];
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return radioRow(
      key: const Key('jelly-radio'),
      children: [
        for (var i = 0; i < _labels.length; i++)
          PressableBox(
            onPress: () => setState(() => _index = i),
            style: radioOptionStyle(isSelected: _index == i),
            child: radioLabelStyle(isSelected: _index == i)(_labels[i]),
          ),
      ],
    );
  }
}
