# mix_tailwinds — Agent Guide

## Goal

Build a **1:1 mapping** from **Tailwind CSS utilities → Mix stylers/widgets** (“Mix partners”) with:

- **Same behavior** as Tailwind where Flutter semantics allow
- **Same mental model** as Tailwind (variants/prefixes, composability, scales)
- A **matching structure + file tree** (organized like Tailwind’s docs/sections) so parity work is obvious and traceable

## Project Map

- `lib/src/tw_parser.dart` — token parsing → Mix styles/specs
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
2. Implement the mapping in the Tailwind-section module (or, today, in `tw_parser.dart`).
3. Add tests (unit + golden/parity when it matters).
4. Validate with the visual comparison workflow in `COMPARISON_TESTING.md`.

## Structure Target (Desired Tree)

Evolve toward a module-per-section layout that mirrors Tailwind’s docs:

- `lib/src/tw/variants.dart`
- `lib/src/tw/layout.dart`
- `lib/src/tw/flexbox.dart`
- `lib/src/tw/spacing.dart`
- `lib/src/tw/sizing.dart`
- `lib/src/tw/typography.dart`
- `lib/src/tw/backgrounds.dart`
- `lib/src/tw/borders.dart`
- `lib/src/tw/effects.dart`
- `lib/src/tw/transforms.dart`
- `lib/src/tw/animation.dart`

Names should track Tailwind section names as closely as practical.
