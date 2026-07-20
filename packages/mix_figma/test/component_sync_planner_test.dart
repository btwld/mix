import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/sync/component_sync_planner.dart';
import 'package:mix_figma/src/core/sync/sync_plan.dart';

void main() {
  final rawPayload = <String, Object?>{
    'version': 1,
    'schema': 'mix_figma/component-set-write/v1',
    'ref': 'button',
    'name': 'Button',
    'identity': {'id': 'button', 'kind': 'componentSet', 'protocolVersion': 1},
    'variants': [
      {
        'ref': 'primary-default',
        'properties': {'variant': 'primary', 'state': 'default'},
        'root': {'id': 'root', 'name': 'root', 'kind': 'FRAME'},
      },
    ],
  };

  test('component payload fingerprints produce a read-back fixed point', () {
    final desired = addComponentSyncMetadata(rawPayload);
    final initial = buildComponentPushSyncPlan(
      current: const {'componentSet': null},
      desired: desired,
    );

    expect(initial.resource, MixFigmaSyncResource.component);
    expect(
      initial.operations
          .where((item) => item.action == .create)
          .map((item) => item.kind),
      {'componentSet', 'componentVariant'},
    );

    final setPluginData = (desired['pluginData']! as Map).cast();
    final variant = ((desired['variants']! as List).single! as Map).cast();
    final root = (variant['root']! as Map).cast();
    final observed = {
      'componentSet': {
        'id': 'ComponentSet:1',
        'name': 'Button',
        'pluginData': setPluginData,
        'variants': [
          {
            'id': 'Component:1',
            'name': 'state=default, variant=primary',
            'pluginData': root['pluginData'],
          },
        ],
      },
    };
    final readBack = buildComponentPushSyncPlan(
      current: observed,
      desired: desired,
    );

    expect(
      readBack.operations.where(
        (item) => item.action != .unchanged && item.action != .skip,
      ),
      isEmpty,
    );
  });

  test('component content fingerprints ignore transport source ids', () {
    final withoutSourceId = addComponentSyncMetadata(rawPayload);
    final withSourceId = addComponentSyncMetadata({
      ...rawPayload,
      'sourceId': 'ComponentSet:stale',
    });

    expect(
      (withSourceId['pluginData']! as Map)['mix_figma.payloadFingerprint'],
      (withoutSourceId['pluginData']! as Map)['mix_figma.payloadFingerprint'],
    );
  });

  test('only stamped stale variants are eligible for deletion', () {
    final desired = addComponentSyncMetadata(rawPayload);
    final setPluginData = (desired['pluginData']! as Map).cast();
    final desiredVariant = ((desired['variants']! as List).single! as Map)
        .cast();
    final root = (desiredVariant['root']! as Map).cast();
    final plan = buildComponentPushSyncPlan(
      current: {
        'componentSet': {
          'id': 'ComponentSet:1',
          'name': 'Button',
          'pluginData': setPluginData,
          'variants': [
            {
              'id': 'Component:1',
              'name': 'state=default, variant=primary',
              'pluginData': root['pluginData'],
            },
            {
              'id': 'Component:legacy',
              'name': 'Legacy',
              'pluginData': {'mix_figma.id': 'button.legacy'},
            },
            {
              'id': 'Component:user',
              'name': 'User variant',
              'pluginData': <String, Object?>{},
            },
          ],
        },
      },
      desired: desired,
    );

    final deletes = plan.operations.where((item) => item.action == .delete);
    expect(deletes.map((item) => item.sourceId), {'Component:legacy'});
    expect(deletes.single.destructive, isTrue);
    expect(
      plan.operations.singleWhere((item) => item.sourceId == 'Component:user'),
      isA<MixFigmaSyncOperation>().having(
        (item) => item.action,
        'action',
        MixFigmaSyncAction.skip,
      ),
    );
  });
}
