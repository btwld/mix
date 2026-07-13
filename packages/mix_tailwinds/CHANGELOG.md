## Unreleased

- **Breaking (experimental alpha):** Removed the legacy `TwResolver`, the
  `wrapDefaultTextStyle` styler extensions, and unused `TwConfig` lookup
  helpers. Use `TwParser`, standard Mix composition, and the public config
  maps instead.
- Restored the hosted `mix: ^2.1.0` dependency so the package remains
  publishable by the repository release workflow.
- Report unsupported `basis-*` flex item utilities through `onUnsupported`
  instead of silently ignoring fraction, full, arbitrary, or unknown values.
- Keep supported `basis-auto` and spacing-scale basis utilities quiet while
  preserving the existing pixel-basis runtime behavior.
- Made the parser registry reproducible from a committed compact Tailwind
  registry snapshot and added a named Melos generation script.

## 0.0.1-alpha.1

- Initial alpha release of `mix_tailwinds`.
- Experimental Tailwind-like class utilities mapped to Mix 2.0 stylers.
