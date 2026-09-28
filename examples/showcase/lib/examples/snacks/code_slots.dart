import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const trackColor = Color(0xFF27272F);
const successColor = Color(0xFF3DD68C);
const dangerColor = Color(0xFFFF5C7A);

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
          child: Padding(padding: .all(24), child: CodeSlots()),
        ),
      ),
    ),
  ),
);

final codeStack = StackBoxStyler().stackAlignment(.center);

final codeRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(8)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

/// Highlights the next slot and tilts alternating slots for an invalid code.
BoxStyler codeSlotStyle({
  required bool isActive,
  required String? status,
  required int index,
}) => BoxStyler()
    .size(42, 52)
    .borderRadius(.circular(12))
    .alignment(.center)
    .color(status == 'ok' ? successColor : trackColor)
    .border(
      .color(
        status == 'bad' ? dangerColor : const Color(0x22FFFFFF),
      ).width(1.5),
    )
    .scale(isActive ? 1.06 : 1)
    .rotate(status == 'bad' ? (index.isEven ? -0.04 : 0.04) : 0)
    .animate(.spring(280.ms, bounce: 0.2));

/// Slides and fades a digit into its slot.
BoxStyler codeDigitStyle({required bool hasDigit}) => BoxStyler()
    .translate(0, hasDigit ? 0 : 6)
    .wrap(.opacity(hasDigit ? 1 : 0))
    .animate(.easeOut(160.ms));

final codeLabel = TextStyler().color(inkColor).fontSize(20).fontWeight(.w600);

/// Click the slots and enter four digits; 1234 succeeds and other codes shake.
class CodeSlots extends StatefulWidget {
  const CodeSlots({super.key});

  @override
  State<CodeSlots> createState() => _CodeSlotsState();
}

class _CodeSlotsState extends State<CodeSlots> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final code = _controller.text;
    final status = code.length == 4 ? (code == '1234' ? 'ok' : 'bad') : null;
    return codeStack(
      key: const Key('code-slots'),
      children: [
        ExcludeSemantics(
          child: codeRow(
            children: [
              for (var i = 0; i < 4; i++)
                codeSlotStyle(
                  isActive: code.length == i,
                  status: status,
                  index: i,
                )(
                  child: codeDigitStyle(hasDigit: i < code.length)(
                    child: codeLabel(i < code.length ? code[i] : ''),
                  ),
                ),
            ],
          ),
        ),
        // The real input covers every slot and gap; Mix paints the digits.
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            alwaysIncludeSemantics: true,
            child: TextField(
              controller: _controller,
              selectAllOnFocus: true,
              // A full code is ready to replace; partial codes append naturally.
              onTap: () => _controller.selection = TextSelection(
                baseOffset: code.length == 4 ? 0 : code.length,
                extentOffset: code.length,
              ),
              decoration: const InputDecoration(
                labelText: 'Four-digit code',
                border: InputBorder.none,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
      ],
    );
  }
}
