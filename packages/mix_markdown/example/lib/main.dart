import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_markdown/mix_markdown.dart';

void main() => runApp(const MarkdownDemoApp());

const _document = '''
# mix_markdown

Markdown rendered with **Mix** styles. Inline formatting composes, so
***bold italic***, ~~strikethrough~~, `code`, and [links](https://fluttermix.com)
all keep their nested styles.

## Alerts

> [!NOTE]
> Alerts use the GitHub syntax and render nested **formatting**.
>
> > [!TIP]
> > Alerts can nest, and share link references such as [the docs][docs].

> [!IMPORTANT]
> Every alert type has its own style slot.

> [!WARNING]
> Toggle the theme in the app bar to see the `onDark` variants.

> [!CAUTION]
> Links are styled but not activated yet.

[docs]: https://fluttermix.com
''';

/// Demo app for the `MixMarkdown` widget.
class MarkdownDemoApp extends StatefulWidget {
  const MarkdownDemoApp({super.key});

  @override
  State<MarkdownDemoApp> createState() => _MarkdownDemoAppState();
}

class _MarkdownDemoAppState extends State<MarkdownDemoApp> {
  var _brightness = Brightness.light;

  void _toggleBrightness() => setState(() {
    _brightness = _brightness == Brightness.light
        ? Brightness.dark
        : Brightness.light;
  });

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'mix_markdown',
    theme: ThemeData(brightness: _brightness),
    home: Builder(
      builder: (context) => MediaQuery(
        // Mix's onDark variant reads the platform brightness.
        data: MediaQuery.of(context).copyWith(platformBrightness: _brightness),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('mix_markdown'),
            actions: [
              IconButton(
                icon: Icon(
                  _brightness == Brightness.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                tooltip: 'Toggle theme',
                onPressed: _toggleBrightness,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: SelectionArea(
              child: MixMarkdown(data: _document, style: _documentStyle),
            ),
          ),
        ),
      ),
    ),
  );
}

final _documentStyle = MarkdownStyler(
  container: BoxStyler().padding(.all(24)),
  blockSpacing: 16,
  paragraph: _text,
  h1: _text.fontSize(32).fontWeight(FontWeight.bold),
  h2: _text.fontSize(24).fontWeight(FontWeight.w600),
  code: TextStyler()
      .backgroundColor(Colors.black12)
      .onDark(TextStyler().backgroundColor(Colors.white12)),
  link: TextStyler()
      .color(Colors.blue.shade700)
      .decoration(TextDecoration.underline)
      .onDark(TextStyler().color(Colors.lightBlue.shade200)),
  alert: MarkdownAlertStyler(
    note: _alert(Colors.blue),
    tip: _alert(Colors.green),
    important: _alert(Colors.purple),
    warning: _alert(Colors.orange),
    caution: _alert(Colors.red),
  ),
);

final _text = TextStyler()
    .fontSize(16)
    .color(Colors.black87)
    .onDark(TextStyler().color(Colors.white70));

MarkdownAlertTypeStyler _alert(MaterialColor color) => MarkdownAlertTypeStyler(
  container: BoxStyler()
      .padding(.all(12))
      .borderRadius(.circular(8))
      .color(color.shade50)
      .border(.color(color.shade200))
      .onDark(
        BoxStyler()
            .color(color.shade900.withValues(alpha: 0.3))
            .border(.color(color.shade700)),
      ),
  header: FlexBoxStyler().spacing(8),
  icon: IconStyler()
      .size(20)
      .color(color.shade700)
      .onDark(IconStyler().color(color.shade200)),
  title: TextStyler()
      .fontWeight(FontWeight.bold)
      .color(color.shade700)
      .onDark(TextStyler().color(color.shade200)),
);
