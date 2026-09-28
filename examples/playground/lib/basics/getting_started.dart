import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFFF5F5FA);
const whiteColor = Color(0xFFFFFFFF);
const inkColor = Color(0xFF242438);
const accentColor = Color(0xFF5B5BD6);
const savedColor = Color(0xFF247A58);

final page = BoxStyler().color(pageColor).paddingAll(24).alignment(.center);
final card = FlexBoxStyler()
    .direction(.vertical)
    .mainAxisSize(.min)
    .crossAxisAlignment(.stretch)
    .spacing(16)
    .maxWidth(320)
    .paddingAll(24)
    .color(whiteColor)
    .borderRounded(20);
final heading = TextStyler().fontSize(24).fontWeight(.w700).color(inkColor);
final body = TextStyler().fontSize(16).color(inkColor);
final buttonLabel = TextStyler()
    .fontSize(16)
    .fontWeight(.w600)
    .color(whiteColor);

// State changes the color; Pressable supplies hover, focus, and press variants.
BoxStyler saveButton(bool saved) => BoxStyler()
    .color(saved ? savedColor : accentColor)
    .paddingAll(16)
    .alignment(.center)
    .borderRounded(12)
    .border(.color(whiteColor).width(2))
    .onHovered(.scale(1.02))
    .onFocused(.border(.color(inkColor).width(2)))
    .onPressed(.scale(0.96))
    .animate(.easeInOut(180.ms));

/// Runs a small lesson in named styles, callable widgets, and state variants.
///
/// Click the button or focus it with Tab and press Enter to change its color.
void main() => runApp(const GettingStartedApp());

/// Keeps visual styles separate from widget composition and interaction state.
class GettingStartedApp extends StatelessWidget {
  const GettingStartedApp({super.key});

  @override
  Widget build(BuildContext context) => WidgetsApp(
    debugShowCheckedModeBanner: false,
    color: pageColor,
    textStyle: const TextStyle(fontFamily: 'sans-serif'),
    builder: (context, child) => const GettingStartedDemo(),
  );
}

/// The lesson content can also live inside the combined examples app.
class GettingStartedDemo extends StatefulWidget {
  const GettingStartedDemo({super.key});

  @override
  State<GettingStartedDemo> createState() => _GettingStartedDemoState();
}

class _GettingStartedDemoState extends State<GettingStartedDemo> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final button = saveButton(_saved);

    return FocusScope(
      autofocus: true,
      child: page(
        child: card(
          children: [
            heading('Make it yours.'),
            body('Named styles. A little state. One animated button.'),
            Pressable(
              onPress: () => setState(() => _saved = !_saved),
              child: button(
                child: buttonLabel(_saved ? 'Saved — undo' : 'Save example'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
