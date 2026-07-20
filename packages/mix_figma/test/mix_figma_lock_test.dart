import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/identity/mix_figma_lock.dart';

void main() {
  test('merges plugin write results without losing existing identities', () {
    final inputCollectionIds = {'legacy.collection': 'collection-legacy'};
    final lock = MixFigmaLock(
      collectionIds: inputCollectionIds,
      modeIds: const {
        'core': {'legacy': 'mode-legacy'},
      },
      variableIds: {'legacy.variable': 'variable-legacy'},
      styleIds: {'legacy.style': 'style-legacy'},
      componentIds: {'legacy.component': 'component-legacy'},
    );
    inputCollectionIds['caller.mutation'] = 'collection-mutated';
    final tokenResult = <String, Object?>{
      'variables': {
        'collections': {'core': 'collection-core'},
        'modes': {
          'core': {'light': 'mode-light', 'dark': 'mode-dark'},
        },
        'variables': {'colors.brand': 'variable-brand'},
      },
      'styles': {
        'textStyles': {'type.body': 'style-text-body'},
        'effectStyles': {'shadow.card': 'style-effect-card'},
        'paintStyles': {'color.brand': 'style-paint-brand'},
      },
    };

    final tokenLock = lock.mergeTokenWriteResult(tokenResult);
    final merged = tokenLock.mergeComponentWriteResult('button', {
      'componentSetId': 'component-button',
    });

    expect(tokenLock.collectionIds, {
      'legacy.collection': 'collection-legacy',
      'core': 'collection-core',
    });
    expect(tokenLock.modeIds, {
      'core': {
        'legacy': 'mode-legacy',
        'light': 'mode-light',
        'dark': 'mode-dark',
      },
    });
    expect(tokenLock.variableIds, {
      'legacy.variable': 'variable-legacy',
      'colors.brand': 'variable-brand',
    });
    expect(tokenLock.styleIds, {
      'legacy.style': 'style-legacy',
      'type.body': 'style-text-body',
      'shadow.card': 'style-effect-card',
      'color.brand': 'style-paint-brand',
    });
    expect(merged.componentIds, {
      'legacy.component': 'component-legacy',
      'button': 'component-button',
    });
    expect(lock.collectionIds, {'legacy.collection': 'collection-legacy'});
    expect(MixFigmaLock.empty.toJson(), {
      'schema': 'mix_figma/lock/v2',
      'collections': <String, String>{},
      'modes': <String, Object?>{},
      'variables': <String, String>{},
      'styles': <String, String>{},
      'components': <String, String>{},
    });

    expect(
      () => tokenLock.collectionIds['mutated'] = 'collection-mutated',
      throwsUnsupportedError,
    );
    expect(
      () => tokenLock.styleIds['mutated'] = 'style-mutated',
      throwsUnsupportedError,
    );

    final encoded = merged.toJson();
    expect(MixFigmaLock.fromJson(encoded).toJson(), encoded);
  });

  test('reads a v1 lock without treating untracked modes as managed', () {
    final lock = MixFigmaLock.fromJson({
      'schema': 'mix_figma/lock/v1',
      'collections': {'core': 'collection-core'},
      'variables': <String, Object?>{},
      'styles': <String, Object?>{},
      'components': <String, Object?>{},
    });

    expect(lock.collectionIds, {'core': 'collection-core'});
    expect(lock.modeIds, isEmpty);
    expect(lock.toJson()['schema'], 'mix_figma/lock/v2');
  });
}
