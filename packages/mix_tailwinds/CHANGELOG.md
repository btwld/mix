## Unreleased

- Report unsupported `basis-*` flex item utilities through `onUnsupported`
  instead of silently ignoring fraction, full, arbitrary, or unknown values.
- Keep supported `basis-auto` and spacing-scale basis utilities quiet while
  preserving the existing pixel-basis runtime behavior.
- Made the parser registry reproducible from a committed compact Tailwind
  registry snapshot and added a named Melos generation script.

## 0.0.1-alpha.1

- Initial alpha release of `mix_tailwinds`.
- Experimental Tailwind-like class utilities mapped to Mix 2.0 stylers.
