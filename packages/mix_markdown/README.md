# mix_markdown

Render headings, paragraphs, and GitHub alerts with [Mix](https://pub.dev/packages/mix).

**Experimental beta.** The API may change before a stable release. See
[Supported content](#supported-content) for what the renderer handles today.

## Quick start

```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_markdown/mix_markdown.dart';

final body = TextStyler().fontSize(16).onDark(TextStyler().color(Colors.white70));

final style = MarkdownStyler(
  container: BoxStyler().padding(.all(24)),
  blockSpacing: 16,
  paragraph: body,
  h1: body.fontSize(32).fontWeight(FontWeight.bold),
  link: TextStyler().color(Colors.blue).decoration(TextDecoration.underline),
);

MixMarkdown(data: source, style: style);
```

`MixMarkdown` does not scroll. Place it in a scroll view, and in a
`SelectionArea` when the text should be selectable.

## Style slots

| Slot | Type | Applies to |
| --- | --- | --- |
| `container` | `BoxStyler` | The whole document |
| `blockSpacing` | `double` | Space between blocks, inside alerts too |
| `paragraph` | `TextStyler` | Paragraphs, and headings without a slot |
| `h1` … `h6` | `TextStyler` | Headings |
| `strong`, `emphasis`, `strikethrough`, `code`, `link` | `TextStyler` | Inline runs |
| `alert` | `MarkdownAlertStyler` | GitHub alerts |

Block text slots support Mix modifiers, animation, and text directives. Inline
slots layer their resolved `TextStyle` over defaults such as bold or italic.
Tokens and variants can affect that style, but inline slots do not apply
their own modifiers, animation, or text directives.

### Alerts

GitHub alerts (`> [!NOTE]`, `> [!TIP]`, `> [!IMPORTANT]`, `> [!WARNING]`,
`> [!CAUTION]`) render as a box with an icon and title row above the body.
Each type has a `MarkdownAlertTypeStyler` slot:

```dart
MarkdownAlertStyler(
  note: MarkdownAlertTypeStyler(
    container: BoxStyler()
        .padding(.all(12))
        .borderRadius(.circular(8))
        .color(Colors.blue.shade50),
    header: FlexBoxStyler().spacing(8),
    icon: IconStyler().size(20).color(Colors.blue),
    title: TextStyler().fontWeight(FontWeight.bold).color(Colors.blue),
  ),
)
```

Set `label` to change the title text and `IconStyler().icon(...)` to change
the icon. The default icons come from Material, so the app needs
`uses-material-design: true`.

Headers shrink-wrap by default. To fill a bounded width, set
`FlexBoxStyler().mainAxisSize(.max)` on the header.

## Supported content

- Paragraphs and `h1` to `h6` headings, with heading semantics.
- Nested inline formatting: strong, emphasis, strikethrough, inline code,
  and links. Inline color codes render as code text without a color swatch.
  Links are styled but not activated.
- Markdown hard breaks and inline `<br>` tags. Soft line breaks become spaces.
- Images in prose contribute their alt text.
- GitHub alerts, including nested alerts and shared link references.
- Blocks containing only HTML comments are ignored.

A document with unsupported blocks (such as lists, tables, or fenced code)
goes to `unsupportedBuilder` with the offending tags. A paragraph containing
only an image, even a linked one, reports `standalone-image`. Without a
builder, the widget shows a diagnostic. Unsupported raw inline HTML such as
`<kbd>` renders as literal text and does not invoke `unsupportedBuilder`.

```dart
MixMarkdown(
  data: source,
  unsupportedBuilder: (context, tags) => OtherRenderer(source),
);
```

## Parsing

While mounted, `MixMarkdown` reparses only when `data` or `syntax` changes.

`MarkdownSyntax` configures the parser. It defaults to
`ExtensionSet.gitHubWeb`, which includes the alert syntax. Two configurations
are equal when they hold the same syntax instances and extension set. Use a
new syntax instance when changing its behavior.

`wrapBlock` receives each rendered block with its parsed element, for example
to wrap a heading in a `Hero`. Empty text blocks are skipped, so they add no
spacing and are not passed to `wrapBlock`, including inside alerts. Alerts
with an empty body still render their header and are passed to `wrapBlock`.
