# Mix Atlas Capture

Shared capture contracts for producers and the standalone Mix Atlas app.
The package validates committed capture bundles, verifies file hashes, decodes
Mix protocol documents, and reconstructs the bounded component-v1 and
component-v2 vocabularies. It never imports or executes producer widgets.

In capture v2, `catalog.json` is the complete component inventory. Complete
component-v2 captures provide one portable document for every catalog entry;
the loader validates that each ordered recipe/state matrix aligns exactly with
its contact-sheet metadata in every theme. Legacy partial and component-v1
captures remain readable through their indexed rendered artifacts. Every
artifact is path-, byte-, and SHA-256-validated before the capture is exposed
to the app.

```dart
final capture = await AtlasCaptureReader(source: source).load(
  const AtlasRepositoryRequest(
    repository: 'btwld/remix',
    ref: 'main',
    manifestPath: 'atlas/fortal/capture.json',
  ),
);
```

## Portable component documents

`mix_atlas/component/v2` is a producer-agnostic widget layer over canonical Mix
Protocol style JSON. It supports typed scalar properties, all Flutter widget
states, safe literal/property/token bindings, generic semantics, nested
components, and a bounded tree of box, flex-box, stack-box, text, icon, image,
spinner, and fractional-position nodes. Component-scoped styles are embedded
in the document, so a recipe's stable slot IDs do not require separate files.

Producer adapters import `package:mix_atlas_capture/producer.dart` and build
documents with `AtlasPortableComponentBuilder`. Mix leaf styles are projected
strictly by `AtlasCompositeStyleProjector`; unrepresentable visual data throws
`AtlasPortableProjectionException` instead of producing a placeholder. Runtime
callbacks may be recorded as nonvisual diagnostics, but component-v2 visual
nodes must always be representable.

Producers can build or check a canonical capture from a staged directory:

Producer commands should import `package:mix_atlas_capture/producer.dart` so
they do not load viewer-only Flutter reconstruction and source adapter APIs.

```sh
dart run mix_atlas_capture \
  --source .atlas/staged \
  --output atlas/fortal \
  --config atlas/fortal.package.json

dart run mix_atlas_capture \
  --source .atlas/staged \
  --output atlas/fortal \
  --config atlas/fortal.package.json \
  --check
```

The JSON config contains `metadata`, optional source/destination `assets`, and
optional `preserve` paths such as `README.md`. Build removes stale generated
files; check is non-mutating and reports every drifted path.
