# mix_winds agent guide

Follow the root [AGENTS.md](../../AGENTS.md). Aim for Tailwind behavior where
Flutter permits it; document intentional differences instead of promising full
CSS equivalence.

## Ownership

- `lib/src/parser/`: pure candidate parsing and generated utility registry.
- `lib/src/translate/`: routing, target filtering, accumulation and Mix translation.
- `lib/src/tw_compilation.dart` / `tw_layout_plan.dart`: compiler output and typed
  layout declarations. The compiler owns both style and layout-plan decisions.
- `lib/src/tw_widget.dart`: evaluate the plan using live constraints and parent
  data. Do not add an independent class-string interpreter here.
- `lib/src/tw_config.dart` and `theme/data/`: scales and generated theme defaults.

Extend the owning module rather than creating disconnected Tailwind-section
files. Wire any new utility module into translation in the same change.

## Parity workflow

1. Match the reference HTML and Flutter class strings, including order and
   expanded reusable/dynamic fragments.
2. Implement at the owning parser, translator or runtime stage and add focused
   semantic/geometry tests.
3. Use [COMPARISON_TESTING.md](COMPARISON_TESTING.md) for browser captures,
   selected metrics and golden-harness diagnosis when visual parity is affected.
4. Update [FLUTTER_ADAPTATIONS.md](FLUTTER_ADAPTATIONS.md) for necessary semantic
   differences and report unsupported utilities through `onDiagnostic`.

Keep generated registry and theme output reproducible; use the generation
commands in `melos.yaml` and the package README. Protocol is a development-only
representability check here, not an internal compiler representation.
