## 0.1.0-beta.2

### Bug fixes

- **Inline color codes:** GitHub color codes in backticks render as code text
  without a color swatch, rather than triggering the unsupported-document
  fallback ([#1145](https://github.com/btwld/mix/pull/1145)).
- **HTML comments:** Blocks containing only HTML comments are ignored, including
  inside alerts ([#1145](https://github.com/btwld/mix/pull/1145)).
- **Text directives:** Directives run on the whole block and leave inline code
  text unchanged. Inline styles are preserved when they can be mapped safely;
  otherwise the block uses a single unstyled span
  ([#1143](https://github.com/btwld/mix/pull/1143)).
- **Nested decorations:** Strikethrough inside an underlined link keeps both
  decorations. An inner `TextDecoration.none` no longer clears an inherited
  decoration ([#1143](https://github.com/btwld/mix/pull/1143)).

### Behavior changes

- **Empty blocks:** Empty text blocks add no spacing and no longer call
  `wrapBlock`, including inside alerts. Alerts with empty bodies still render
  and call `wrapBlock` ([#1145](https://github.com/btwld/mix/pull/1145)).
- **Default alert icons:** The package no longer imports Flutter's Material
  library for these icons. They still use the Material Icons font, so apps
  using the defaults need `uses-material-design: true`. Regenerating the
  package now requires `mix_generator: ^2.3.0`
  ([#1144](https://github.com/btwld/mix/pull/1144)).
- **Release checks:** Publishing is gated on analysis and tests against the
  oldest and newest compatible published versions of Mix and Mix Annotations
  ([#1142](https://github.com/btwld/mix/pull/1142)).

## 0.1.0-beta.1

- First experimental release. `MixMarkdown` styles paragraphs, headings,
  inline formatting, and GitHub alerts with Mix.
- Customize parsing with `MarkdownSyntax` and hand off unsupported documents
  with `unsupportedBuilder`.
