import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/sync/sync_plan.dart';

void main() {
  test('sync plan is deterministic and keeps destructive work opt-in', () {
    final plan = MixFigmaSyncPlan.create(
      direction: MixFigmaSyncDirection.mixToFigma,
      resource: MixFigmaSyncResource.tokens,
      current: {
        'variables': {'b': 2, 'a': 1},
      },
      desired: {
        'themes': {'light': true},
      },
      operations: const [
        MixFigmaSyncOperation(
          action: MixFigmaSyncAction.delete,
          kind: 'variable',
          ref: 'colors/legacy',
          name: 'color/legacy',
          destructive: true,
        ),
        MixFigmaSyncOperation(
          action: MixFigmaSyncAction.update,
          kind: 'textStyle',
          ref: 'textStyles/body',
          name: 'type/body',
          changes: ['fontSize'],
        ),
        MixFigmaSyncOperation(
          action: MixFigmaSyncAction.unchanged,
          kind: 'collection',
          ref: 'Mix Tokens',
          name: 'Mix Tokens',
        ),
      ],
    );
    final samePlan = MixFigmaSyncPlan.create(
      direction: MixFigmaSyncDirection.mixToFigma,
      resource: MixFigmaSyncResource.tokens,
      current: {
        'variables': {'a': 1, 'b': 2},
      },
      desired: {
        'themes': {'light': true},
      },
      operations: plan.operations.reversed,
    );

    expect(plan.id, samePlan.id);
    expect(plan.sourceFingerprint, samePlan.sourceFingerprint);
    expect(plan.summary.toJson(), {
      'create': 0,
      'update': 1,
      'rename': 0,
      'delete': 1,
      'unchanged': 1,
      'skip': 0,
      'errors': 0,
      'warnings': 0,
    });
    expect(
      plan.operationsForApply(allowDeletes: false).map((item) => item.action),
      isNot(contains(MixFigmaSyncAction.delete)),
    );
    expect(
      plan.operationsForApply(allowDeletes: true).map((item) => item.action),
      contains(MixFigmaSyncAction.delete),
    );
    expect(plan.toJson()['schema'], 'mix_figma/sync-plan/v1');
  });

  test('current state changes invalidate the plan id', () {
    MixFigmaSyncPlan build(int value) => MixFigmaSyncPlan.create(
      direction: MixFigmaSyncDirection.figmaToMix,
      resource: MixFigmaSyncResource.tokens,
      current: {'value': value},
      desired: const {'value': 1},
      operations: const [],
    );

    expect(build(1).id, isNot(build(2).id));
  });
}
