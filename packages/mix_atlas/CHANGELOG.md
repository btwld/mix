## Unreleased

- Rebuilt `AtlasCatalogViewer` with responsive desktop and compact layouts,
  keyboard search, theme controls, atlas details, and polished light/dark
  navigation chrome.
- Added `AtlasStoryCanvas`, a scenario-first live-viewer presentation that
  places values from the final row axis side by side while preserving
  `AtlasView` as the canonical golden-sheet grid.
- Applied the selected atlas theme's brightness to both Material and
  `MediaQuery`, so Mix context variants such as `onDark` resolve correctly in
  the live viewer.
- Added deterministic desktop-light, compact-dark, and search/details viewer
  golden coverage.
- Added a runnable desktop example that configures the Atlas viewer's initial
  and minimum native window sizes through `window_manager`.

## 0.1.0

- Initial release of `mix_atlas`.
- Static component atlases that render every variant × state combination of a
  Mix component into a single contact atlas for visual review, golden
  snapshots, and AI-agent validation.
- `ComponentAtlas`, `AtlasScenario`, `AtlasTheme`, and `AtlasCatalog` for
  declaring reusable, design-system-agnostic atlases.
- `AtlasView` and `AtlasCatalogViewer` for rendering atlases live.
- Golden-snapshot harness (`package:mix_atlas/golden.dart`):
  `expectAtlasGolden`, `registerAtlasCatalogGoldens`, and machine-readable
  sidecar/catalog metadata.
- Scenario widget states flow through components' normal `style` APIs, even
  across nested interaction providers; `AtlasCellContext.resolve` remains an
  optional advanced escape hatch.
- Golden comparison supports an explicit precision tolerance for local
  cross-macOS text rasterization while canonical CI remains byte-exact.
