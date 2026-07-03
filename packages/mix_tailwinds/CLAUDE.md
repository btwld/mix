# mix_tailwinds — Agent Guide

## Goal

Build a **1:1 mapping** from **Tailwind CSS utilities → Mix stylers/widgets** (“Mix partners”) with:

- **Same behavior** as Tailwind where Flutter semantics allow
- **Same mental model** as Tailwind (variants/prefixes, composability, scales)
- A **matching structure + file tree** (organized like Tailwind’s docs/sections) so parity work is obvious and traceable

## Project Map

- `lib/src/parser/` — pure Tailwind candidate parser and generated utility registry
- `lib/src/translate/` — candidate → Mix styler translation, accumulators, routing, and presets
- `lib/src/theme/data/` — generated default Tailwind theme data
- `lib/src/tw_parser.dart` — public parser facade over the translator
- `lib/src/tw_config.dart` — scales/colors/breakpoints + `TwConfigProvider`
- `lib/src/tw_widget.dart` — widget-layer behaviors (e.g. flex-item tokens that can’t live purely in the parser)
- `test/` — correctness tests for tokens + widget behavior
- `example/` — demo app + visual parity harness (Flutter + real Tailwind HTML)

Key docs:
- `COMPARISON_TESTING.md` — screenshot + pixel-diff workflow for Flutter vs Tailwind
- `FLUTTER_ADAPTATIONS.md` — intentional/necessary semantic differences vs CSS
- `FUTURE_WORK.md` — backlog + planned parity work

## Workflow (Preferred)

1. Define expected Tailwind output in `example/real_tailwind/` (HTML + classes).
2. Implement the mapping in the parser/translator module that owns the utility family.
3. Add tests (unit + golden/parity when it matters).
4. Validate with the visual comparison workflow in `COMPARISON_TESTING.md`.

## Current Internal Structure

The current implementation keeps parsing and translation separate:

- `lib/src/parser/candidate_parser.dart` — parse candidates, variants, modifiers, arbitrary values
- `lib/src/parser/data/parser_registry.g.dart` — generated known utility registry
- `lib/src/translate/tw_translator.dart` — maps parsed candidates into Mix stylers
- `lib/src/translate/tw_accumulators.dart` — cross-token accumulation for borders and transforms
- `lib/src/translate/tw_gradient.dart` — gradient accumulation and Mix conversion
- `lib/src/translate/tw_routing.dart` — early classification for ignored, unsupported, gradient, and typed styler tokens
- `lib/src/translate/tw_target.dart` — target filtering for Box, FlexBox, and Text
- `lib/src/tw_widget.dart` — widget-only behavior such as flex-item tokens

Prefer extending these modules over reintroducing disconnected section files. If utility-family modules are added later, wire them into `TwTranslator` behavior in the same change.
