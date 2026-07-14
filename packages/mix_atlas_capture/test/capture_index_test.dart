import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

void main() {
  test(
    'indexes exact declared evidence and token uses deterministically',
    () async {
      final capture = await _load('button_baseline');

      final first = AtlasCaptureIndex.build(capture);
      final second = AtlasCaptureIndex.build(capture);

      expect(first.toCanonicalJson(), second.toCanonicalJson());
      expect(first.propertyEvidence, hasLength(2));
      expect(
        first.propertyEvidence.map((evidence) => evidence.themeId),
        unorderedEquals(['dark', 'light']),
      );
      expect(
        first.propertyEvidence.singleWhere((e) => e.themeId == 'light'),
        isA<AtlasPropertyEvidence>()
            .having((e) => e.componentId, 'component', 'button')
            .having((e) => e.recipeId, 'recipe', 'solid-size1')
            .having((e) => e.slotId, 'slot', 'label')
            .having((e) => e.property, 'property', 'style.color')
            .having((e) => e.jsonPointer, 'pointer', r'/style/color')
            .having((e) => e.tokenName, 'token', 'fortal.accent.9'),
      );
      expect(first.tokenUses, hasLength(2));
      expect(first.tokenDefinitions, hasLength(4));
      expect(first.tokenUses.map((use) => use.tokenKind).toSet(), {'colors'});
      expect(first.tokenUses.map((use) => use.referenceType).toSet(), {
        AtlasTokenReferenceType.direct,
      });
    },
  );

  test(
    'diffs canonical declared JSON and treats additions as compatible',
    () async {
      final baseline = await _load('button_baseline');
      final current = await _load('button_changed');
      final baselineJson = jsonDecode(
        utf8.decode(
          baseline.files['styles/button/solid-size1/label.mix.json']!,
        ),
      );
      final currentJson = jsonDecode(
        utf8.decode(current.files['styles/button/solid-size1/label.mix.json']!),
      );

      final changes = AtlasJsonDiffer.compare(baselineJson, currentJson);

      expect(
        changes,
        contains(
          isA<AtlasJsonChange>()
              .having(
                (change) => change.kind,
                'kind',
                AtlasJsonChangeKind.added,
              )
              .having((change) => change.jsonPointer, 'pointer', '/maxLines')
              .having((change) => change.currentValue, 'value', 1),
        ),
      );
      expect(
        AtlasCaptureCompatibility.evaluate(baseline, current).isCompatible,
        true,
      );
    },
  );

  test('reports removals, changes, and unchanged declared JSON', () {
    const baseline = {
      'type': 'text',
      'maxLines': 2,
      'style': {'fontSize': 14},
    };
    const current = {'type': 'text', 'maxLines': 1};

    expect(AtlasJsonDiffer.compare(baseline, baseline), isEmpty);
    expect(
      AtlasJsonDiffer.compare(baseline, current),
      containsAll([
        isA<AtlasJsonChange>()
            .having(
              (change) => change.kind,
              'kind',
              AtlasJsonChangeKind.changed,
            )
            .having((change) => change.jsonPointer, 'pointer', '/maxLines'),
        isA<AtlasJsonChange>()
            .having(
              (change) => change.kind,
              'kind',
              AtlasJsonChangeKind.removed,
            )
            .having((change) => change.jsonPointer, 'pointer', '/style'),
      ]),
    );
  });
}

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
