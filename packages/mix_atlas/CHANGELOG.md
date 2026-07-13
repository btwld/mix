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
