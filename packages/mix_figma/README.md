# mix_figma

Bridge between design-tool token sources and Mix, built on
[`mix_protocol`](../mix_protocol/).

Converts [DTCG 2025.10](https://www.designtokens.org/tr/2025.10/format/)
design-token files — the format exported by Figma's native variable export,
Tokens Studio, and Style Dictionary — into `mix_protocol` theme documents
that decode to token maps ready for `MixScope(tokens:)`.

See [`guides/figma-mix-protocol-plan.md`](../../guides/figma-mix-protocol-plan.md)
for the research, architecture, and roadmap (Figma REST reader, composite
tokens from Figma styles, exporter plugin).

## Status

Phase 1 (in progress): DTCG → theme document conversion, with a `pull` CLI.

## CLI

Convert a directory of per-mode DTCG files (one Figma variable mode each) into
`<name>.theme.json` documents:

```bash
dart run mix_figma pull --out design/tokens \
    --group radius=radii --group breakpoint=breakpoints \
    design/figma-export/
```

Each input file becomes one theme document; `--group <prefix>=<theme-group>`
routes ambiguous dimension/number tokens, and `--rem-pixel-ratio <n>` resolves
`rem` units. Every token that cannot be represented is reported as a warning —
nothing is dropped silently — and the command exits non-zero only on file-level
failures (unreadable file, non-object JSON).

The CLI and conversion core are pure Dart (no Flutter dependency) so they run
fast under `dart run`; the produced documents are validated against the real
`mixProtocol.decodeTheme` codec in this package's test suite.

## Library

```dart
import 'package:mix_figma/mix_figma.dart';
import 'package:mix_protocol/mix_protocol.dart';

final result = dtcgToThemeDocument(jsonDecode(dtcgFileContents));
// result.themeDocument is a mix_protocol theme document:
//   { "v": 1, "type": "theme", "colors": {...}, ... }
// result.diagnostics reports every token that could not be represented.

final theme = switch (mixProtocol.decodeTheme(result.themeDocument)) {
  MixProtocolSuccess<MixProtocolTheme>(:final value) => value,
  MixProtocolFailure<MixProtocolTheme>(:final errors) =>
    throw StateError('$errors'),
};
// MixScope(tokens: theme.tokens, child: ...)
```

Figma exports one DTCG file per variable mode — convert each file to its own
theme document (e.g. `light.theme.json`, `dark.theme.json`) and swap or layer
them at runtime with `MixScope` / `MixScope.inherit`.

## Mapping

| DTCG `$type` | Theme group | Notes |
|---|---|---|
| `color` | `colors` | hex and sRGB component forms |
| `dimension` | `spaces` (default) | px only; route to `radii`/`doubles`/`breakpoints` via `DtcgConversionOptions.groupOverrides` |
| `number` | `doubles` | route to `breakpoints` via overrides |
| `fontWeight` | `fontWeights` | numeric and named weights, snapped to `w100`–`w900` |
| `duration` | `durations` | `ms` and `s` units |
| `shadow` | `boxShadows` | single or layered; `inset` unsupported |
| `border` | `borders` | `solid` style only |
| `typography` | `textStyles` | fontFamily/size/weight/letterSpacing/lineHeight |
| alias `{a.b}` | same group as target | whole-value, same-kind (protocol rule) |

Unsupported token types (`fontFamily`, `cubicBezier`, `gradient`,
`strokeStyle`, `transition`, string/boolean values) are skipped with a
diagnostic — never silently dropped.
