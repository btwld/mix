import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
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
          child: Padding(padding: .all(24), child: DodgeField()),
        ),
      ),
    ),
  ),
);

final dodgeStage = BoxStyler().width(240).height(120).alignment(.center);

/// Springs the button toward its bounded dodge offset.
BoxStyler dodgeButtonStyle({required Offset offset}) => BoxStyler()
    .padding(.horizontal(16))
    .padding(.vertical(10))
    .borderRadius(.circular(14))
    .color(accentColor)
    .translate(offset.dx, offset.dy)
    .animate(.spring(280.ms, bounce: 0.32));

final dodgeLabel = TextStyler().color(inkColor).fontSize(14).fontWeight(.w600);

/// Move toward the button to make it dodge three times, then click to reset.
class DodgeField extends StatefulWidget {
  const DodgeField({super.key});

  @override
  State<DodgeField> createState() => _DodgeFieldState();
}

class _DodgeFieldState extends State<DodgeField> {
  Offset _offset = Offset.zero;
  int _tries = 0;

  void _dodge(Offset local, Size size) {
    if (_tries >= 3) {
      setState(() => _offset = Offset.zero);
      return;
    }
    final center = size.center(Offset.zero) + _offset;
    if ((local - center).distance > 46) return;
    final dir = local == center
        ? const Offset(1, 0)
        : (center - local) / (center - local).distance;
    setState(() {
      _tries += 1;
      _offset = _tries >= 3
          ? Offset.zero
          : Offset(
              (_offset.dx + dir.dx * 36).clamp(-70.0, 70.0),
              (_offset.dy + dir.dy * 24).clamp(-28.0, 28.0),
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    final dodgeButton = dodgeButtonStyle(offset: _offset);

    return MouseRegion(
      key: const Key('dodge-field'),
      onHover: (event) => _dodge(event.localPosition, const Size(240, 120)),
      child: dodgeStage(
        child: PressableBox(
          onPress: () => setState(() {
            _tries = 0;
            _offset = Offset.zero;
          }),
          style: dodgeButton,
          child: dodgeLabel(_tries >= 3 ? 'Fine, you win' : 'Catch me'),
        ),
      ),
    );
  }
}
