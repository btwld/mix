import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const trackColor = Color(0xFF27272F);

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
          child: Padding(padding: .all(24), child: ScrubField()),
        ),
      ),
    ),
  ),
);

/// Keeps the surface steady and distinguishes scrubbing from text editing.
BoxStyler scrubButtonStyle({required bool isEditing}) => BoxStyler()
    .width(104)
    .height(46)
    .alignment(.center)
    .paddingX(16)
    .paddingY(10)
    .borderRounded(14)
    .color(trackColor)
    .wrap(
      .modifier(
        MouseCursorModifierMix(
          mouseCursor: isEditing
              ? SystemMouseCursors.text
              : SystemMouseCursors.resizeLeftRight,
        ),
      ),
    )
    .onPressed(.scale(0.98))
    .animate(.spring(200.ms, bounce: 0.08));

final scrubLabel = TextStyler().color(inkColor).fontSize(14).fontWeight(.w600);

const scrubTextStyle = TextStyle(
  color: inkColor,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

/// Drag horizontally to scrub the value, or click to edit and press Enter.
class ScrubField extends StatefulWidget {
  const ScrubField({super.key});

  @override
  State<ScrubField> createState() => _ScrubFieldState();
}

class _ScrubFieldState extends State<ScrubField> {
  double _value = 24;
  bool _editing = false;
  final _controller = TextEditingController(text: '24');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _set(double next) {
    final clamped = next.clamp(0.0, 100.0);
    setState(() {
      _value = clamped;
      _controller.text = clamped.round().toString();
    });
  }

  void _edit() {
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
    setState(() => _editing = true);
  }

  void _commit() {
    _set(double.tryParse(_controller.text) ?? _value);
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final scrubButton = scrubButtonStyle(isEditing: _editing);
    return GestureDetector(
      onHorizontalDragUpdate: _editing
          ? null
          : (details) => _set(_value + details.delta.dx * 0.25),
      child: PressableBox(
        key: const Key('scrub-field'),
        onPress: _editing ? null : _edit,
        style: scrubButton,
        child: _editing
            ? SizedBox(
                width: 72,
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  selectAllOnFocus: true,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: scrubTextStyle,
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                    suffixText: ' px',
                    suffixStyle: scrubTextStyle,
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _commit(),
                  onTapOutside: (_) => _commit(),
                ),
              )
            : scrubLabel('${_value.round()} px'),
      ),
    );
  }
}
