import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

void main() {
  late AtlasCapture baseline;
  late AtlasCapture changed;

  setUpAll(() async {
    baseline = await _load('button_baseline');
    changed = await _load('button_changed');
  });

  test('reports style-only changes deterministically', () {
    final first = AtlasCaptureComparison.compare(baseline, changed);
    final second = AtlasCaptureComparison.compare(baseline, changed);

    expect(first.compatibility.isCompatible, true);
    expect(first.toCanonicalJson(), second.toCanonicalJson());
    expect(
      first.changes,
      contains(
        isA<AtlasDeclaredChange>()
            .having(
              (change) => change.category,
              'category',
              AtlasDeclaredChangeCategory.styleTerm,
            )
            .having(
              (change) => change.kind,
              'kind',
              AtlasDeclaredChangeKind.added,
            )
            .having((change) => change.property, 'property', 'maxLines'),
      ),
    );
    expect(
      first.count(category: AtlasDeclaredChangeCategory.tokenDefinition),
      0,
    );
  });

  test('separates token-definition changes from style terms', () {
    final tokenChanged = _clone(
      baseline,
      files: {
        ...baseline.files,
        'themes/light.mix.json': Uint8List.fromList(
          utf8.encode(
            '{"v":1,"type":"theme","colors":'
            '{"fortal.accent.9":"#123456"},'
            '"spaces":{"fortal.space.2":8.0}}',
          ),
        ),
      },
    );

    final comparison = AtlasCaptureComparison.compare(baseline, tokenChanged);

    expect(
      comparison.count(category: AtlasDeclaredChangeCategory.tokenDefinition),
      1,
    );
    expect(
      comparison.count(category: AtlasDeclaredChangeCategory.styleTerm),
      0,
    );
    expect(
      comparison.changes.singleWhere(
        (change) =>
            change.category == AtlasDeclaredChangeCategory.tokenDefinition,
      ),
      isA<AtlasDeclaredChange>()
          .having((change) => change.themeId, 'theme', 'light')
          .having(
            (change) => change.kind,
            'kind',
            AtlasDeclaredChangeKind.modified,
          ),
    );
  });

  test('treats added and removed components as compatible changes', () {
    final empty = _clone(
      baseline,
      catalog: AtlasCatalog(
        id: baseline.catalog.id,
        label: baseline.catalog.label,
        themes: baseline.catalog.themes,
        components: const [],
      ),
      componentDocuments: const [],
    );

    final removed = AtlasCaptureComparison.compare(baseline, empty);
    final added = AtlasCaptureComparison.compare(empty, baseline);

    expect(removed.compatibility.isCompatible, true);
    expect(
      removed.changes,
      contains(
        isA<AtlasDeclaredChange>()
            .having(
              (change) => change.category,
              'category',
              AtlasDeclaredChangeCategory.component,
            )
            .having(
              (change) => change.kind,
              'kind',
              AtlasDeclaredChangeKind.removed,
            ),
      ),
    );
    expect(
      added.changes,
      contains(
        isA<AtlasDeclaredChange>()
            .having(
              (change) => change.category,
              'category',
              AtlasDeclaredChangeCategory.component,
            )
            .having(
              (change) => change.kind,
              'kind',
              AtlasDeclaredChangeKind.added,
            ),
      ),
    );
  });

  test('indexes visual-oracle changes for the full catalog', () {
    final renderedOnly = _clone(
      baseline,
      catalog: AtlasCatalog(
        id: baseline.catalog.id,
        label: baseline.catalog.label,
        themes: baseline.catalog.themes,
        components: [
          ...baseline.catalog.components,
          AtlasCatalogComponent(
            id: 'avatar',
            label: 'Avatar',
            assets: {
              'light': const AtlasComponentAsset(
                themeId: 'light',
                imagePath: 'light/avatar.png',
                metadataPath: 'light/avatar.json',
              ),
              'dark': const AtlasComponentAsset(
                themeId: 'dark',
                imagePath: 'dark/avatar.png',
                metadataPath: 'dark/avatar.json',
              ),
            },
          ),
        ],
      ),
    );

    final comparison = AtlasCaptureComparison.compare(baseline, renderedOnly);

    expect(
      comparison.count(category: AtlasDeclaredChangeCategory.visualOracle),
      2,
    );
    expect(
      comparison.changes
          .where(
            (change) =>
                change.category == AtlasDeclaredChangeCategory.visualOracle,
          )
          .map((change) => change.componentId)
          .toSet(),
      {'avatar'},
    );
  });

  test('reports unchanged and incompatible captures truthfully', () {
    expect(AtlasCaptureComparison.compare(baseline, baseline).changes, isEmpty);
    final incompatible = _clone(
      baseline,
      catalog: AtlasCatalog(
        id: 'another-catalog',
        label: baseline.catalog.label,
        themes: baseline.catalog.themes,
        components: baseline.catalog.components,
      ),
    );

    final comparison = AtlasCaptureComparison.compare(baseline, incompatible);

    expect(comparison.compatibility.isCompatible, false);
    expect(comparison.compatibility.reason, 'Catalog identities do not match.');
    expect(comparison.changes, isEmpty);
  });
}

AtlasCapture _clone(
  AtlasCapture source, {
  AtlasCatalog? catalog,
  List<AtlasComponentDocument>? componentDocuments,
  Map<String, Uint8List>? files,
}) => AtlasCapture(
  receipt: source.receipt,
  manifest: source.manifest,
  catalog: catalog ?? source.catalog,
  protocolCoverage: source.protocolCoverage,
  files: files ?? source.files,
  themeTokenCounts: source.themeTokenCounts,
  protocolThemes: source.protocolThemes,
  componentDocuments: componentDocuments ?? source.componentDocuments,
  styleDocuments: source.styleDocuments,
  atlasMetadata: source.atlasMetadata,
  validatedStyleDocumentCount: source.validatedStyleDocumentCount,
);

Future<AtlasCapture> _load(String fixture) =>
    AtlasCaptureReader(
      source: AtlasDirectorySource(
        Directory('test/fixtures/$fixture').absolute,
      ),
    ).load(
      const AtlasRepositoryRequest(
        repository: 'local',
        ref: 'local',
        manifestPath: 'capture.json',
      ),
    );
