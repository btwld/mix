# Mix Atlas Capture

Shared capture contracts for producers and the standalone Mix Atlas app.
The package validates committed capture bundles, verifies file hashes, decodes
Mix protocol documents, and reconstructs only the bounded component-v1
vocabulary. It never imports or executes producer widgets.

```dart
final capture = await AtlasCaptureReader(source: source).load(
  const AtlasRepositoryRequest(
    repository: 'btwld/remix',
    ref: 'main',
    manifestPath: 'atlas/fortal/capture.json',
  ),
);
```

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
