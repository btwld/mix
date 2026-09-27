## 0.1.0-alpha.1

- First functional `mix_winds` release on pub.dev, replacing the name-reservation
  placeholder. Uses the released Mix 2.2.0 and hosted `mix_protocol` alpha for
  development-time wire-contract checks; `mix_protocol` remains optional at
  runtime for applications that need portable JSON.

## 0.1.0-alpha.0 (tagged but not published)

- Requires `mix` 2.2.0-beta.5 or later. The package uses focus-visible
  variants, semantics roles, and gradient transforms that were added after
  2.1.0, so the previous `^2.1.0` constraint could not resolve a working
  build.
- Export `TwCompilation` and `TwLayoutPlan` for typed compilation results and
  read-only runtime layout inspection.
- Match zero-viewport padding and border activation to Mix, and share responsive
  widths through nested Tw flex scopes so reserved and applied margins agree.
- Derive layout inset merge order from the actual emitted style groups, and
  project the plan's padding and border widths from those groups so the plan
  cannot disagree with the rendered style.
- Widget compilation keeps external margin out of box and flex Stylers; the
  layout plan owns it, so semantic widgets no longer strip margin from every
  resolved spec. Direct `TwParser` compilation still retains margin.
- Preserve intrinsic measurement for text, headings, spans, and icons with static
  margins or padding, and for responsive margins when a viewport or enclosing
  Tw flex scope supplies the width.
- Match zero-basis padding and border accounting to the emitted style's variant
  merge order so responsive flex children retain equal content space.
- Validate each supported utility ledger family through Mix Protocol.
- Check resolved styles, target diagnostics, and runtime plans in Dart, and
  pin one encoded document per ledger family under `schema/fixtures` for the
  repository's Ajv schema check.
- Encode `focus-visible` through the additive Protocol v1 selector.
- Normalize static viewport sizing before routing to prevent incorrect
  unsupported diagnostics.
- **Breaking:** Renamed the package from `mix_tailwinds` to `mix_winds`. Update
  the dependency name and change `package:mix_tailwinds/mix_tailwinds.dart`
  imports to `package:mix_winds/mix_winds.dart`. No public API symbol changed;
  the `Tw*` types and `tw*` functions keep their names because they still map
  Tailwind CSS utilities. `mix_tailwinds` is discontinued on pub.dev at
  `0.0.1-alpha.1`.
- Fixed zero-basis flex growth with unequal child margin, padding, or border.
  When positive content space remains, Tailwind-owned flex containers now
  reserve those non-content extents before distributing it, while delegating
  both layout passes to Flutter's `RenderFlex` and retaining native
  `Row`/`Column` compatibility.
- Corrected `min-w-auto` compatibility reporting. Flutter has no equivalent
  flex-item automatic-minimum phase, so the utility is now reported as
  unsupported instead of invoking a no-op escape hatch.
- Fixed `self-start`, `self-end`, and `self-center`, which silently did nothing
  whenever the container carried an `items-*` utility. A flex holding a
  self-aligned child now renders through a `RenderFlex` that offsets those
  children after it has measured its cross axis, so the override also works in
  the common case of a row nested inside a column.
- **Breaking:** `TwConfig.standard()` now contains only Tailwind CSS 4.3.1
  defaults. The fixture-only `brand-500`, `card` spacing/radius, `3xl`
  breakpoint, and `shadow-card` values were removed; add project values with
  `TwConfig.copyWith` or explicit Mix composition.
- **Breaking (experimental alpha):** Removed `TwPressable` in favor of `Button`;
  rename `onPress` to `onPressed`. A null `onPressed` disables the control
  unless `onLongPress` supplies an action, and semantics are always button
  semantics. Its margin stays outside the pressed, tappable, and semantic
  border box.
- Added class-first lowercase convenience functions for `Div`, text, headings,
  `Button`, `TwIcon`, and `TruncatedP`. They return the concrete uppercase
  widgets; use those const-capable constructors for advanced options.
- `H1` through `H6` now expose matching Flutter semantics heading levels 1
  through 6.
- Generated every supported default theme namespace from a checked-in,
  versioned Tailwind 4.3.1 snapshot, including the complete stock palette and
  corrected radii, blurs, font line heights, leading, and tracking values.
- Resolve `tracking-*` em values against the final font size and preserve an
  explicit `leading-*` over font-size defaults in either class order, including
  inherited default text styles.
- Fixed nested interaction variants, routed `focus-visible` through input
  modality, and removed the non-Tailwind `theme-midnight` dark-mode alias.
- Fixed fixed/fraction/full/auto responsive width behavior under stretched
  Flutter constraints. Responsive `w-auto` and `h-auto` now clear earlier
  fixed constraints explicitly.
- Visual comparisons now enforce per-example, per-width acceptance contracts
  and generate a filterable, browser-smoked HTML light-table report after
  successful and failed runs.
- Added a source-backed web showcase for five product-scale examples with
  Tailwind/Flutter code comparison, published parity evidence, linkable
  viewports, and one-engine single/multi-view Flutter embedding modes. Showcase
  builds reject incomplete, malformed, or stale parity evidence by validating
  the canonical viewport set and a content fingerprint of their source inputs.
- **Breaking (experimental alpha):** Removed the legacy `TwResolver`, the
  `wrapDefaultTextStyle` styler extensions, and unused `TwConfig` lookup
  helpers. Use `TwParser`, standard Mix composition, and the public config
  maps instead.
- **Breaking (experimental alpha):** Removed the unused semantic AST and plugin
  registry that were previously exported from `tw_semantic.dart`.
- Restored the hosted `mix: ^2.1.0` dependency so the package remains
  publishable by the repository release workflow.
- Added structured `TwDiagnostic` reporting through `onDiagnostic`; ignored
  adaptations and unsupported candidates no longer disappear silently. The
  token-only `onUnsupported` callback remains as a deprecated shim.
- Added `TwParser.compileBox`, `compileFlex`, `compileText`, and `compileIcon`
  to return the Styler, deterministic diagnostics, and a read-only runtime
  layout plan from one candidate pass. Compiled Stylers now retain transition
  animation for portable Mix Protocol encoding.
- Build the runtime plan from the compiler's typed utility semantics instead of
  interpreting class strings a second time, keeping runtime classification in
  lockstep with routing and configured values.
- Fixed runtime classification and plan evaluation for external box/flex
  margins and implicit vertical-flex alignment under bounded versus unbounded
  constraints.
- Flex parents now hand prepared compilations to built-in direct children, so
  parent measurement and child rendering share one parse while diagnostics are
  still delivered exactly once by the child.
- Preserve keyed flex child state through prepared compilation and cross-axis
  gap wrappers when children are reordered.
- Report unsupported interactive external margins during semantic widget
  compilation. Direct Box and Flex styler compilation retains supported variants.
- Skip negative arbitrary external margins so semantic widgets do not receive
  invalid padding or overwrite an earlier positive margin.
- Require every nested viewport breakpoint before applying a semantic layout
  utility, independent of the breakpoint order.
- **Breaking (experimental alpha):** Removed the token-level `TwParser`
  helpers `listTokens`, `setTokens`, `wantsFlex`, and
  `parseAnimationFromTokens`. Use the target-specific `compile*` methods; the
  parsed candidate program is now package-internal.
- Resolve conflicting utilities in canonical registry order across translated
  styles and constraint-aware widget behavior, so class-string order no longer
  changes base, variant, flex-axis, gap, or self-alignment output.
- Report unsupported `basis-*` flex item utilities through `onDiagnostic`
  instead of silently ignoring fraction, full, arbitrary, or unknown values.
- Keep supported `basis-auto` and spacing-scale basis utilities quiet while
  preserving the existing pixel-basis runtime behavior.
- Made the parser registry reproducible from a committed compact Tailwind
  registry snapshot and added a named Melos generation script.

## 0.0.1-alpha.1

- Initial alpha release of `mix_tailwinds`.
- Experimental Tailwind-like class utilities mapped to Mix 2.0 stylers.
