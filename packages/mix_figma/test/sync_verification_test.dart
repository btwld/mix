import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/diagnostics/mix_figma_diagnostic.dart';
import 'package:mix_figma/src/core/sync/sync_plan.dart';
import 'package:mix_figma/src/core/sync/sync_verification.dart';

void main() {
  MixFigmaSyncPlan plan(
    Iterable<MixFigmaSyncOperation> operations, {
    Object desired = const {'value': 1},
  }) => MixFigmaSyncPlan.create(
    direction: MixFigmaSyncDirection.mixToFigma,
    resource: MixFigmaSyncResource.tokens,
    current: const {'before': true},
    desired: desired,
    operations: operations,
  );

  test(
    'verification accepts unchanged state and explicit retained deletes',
    () {
      final before = plan(const [
        MixFigmaSyncOperation(
          action: MixFigmaSyncAction.update,
          kind: 'variable',
          ref: 'colors/brand',
          name: 'color/brand',
        ),
      ]);
      final after = plan(const [
        MixFigmaSyncOperation(
          action: MixFigmaSyncAction.unchanged,
          kind: 'variable',
          ref: 'colors/brand',
          name: 'color/brand',
        ),
        MixFigmaSyncOperation(
          action: MixFigmaSyncAction.delete,
          kind: 'variable',
          ref: 'colors/legacy',
          name: 'color/legacy',
          destructive: true,
        ),
      ]);

      final report = verifyMixFigmaSync(
        approvedPlan: before,
        observedPlan: after,
        allowDeletes: false,
      );

      expect(
        report.status,
        MixFigmaSyncVerificationStatus.verifiedWithRetainedItems,
      );
      expect(report.pendingDeletes, 1);
      expect(report.toJson()['schema'], 'mix_figma/sync-report/v1');
    },
  );

  test('verification fails when an applied mutation remains', () {
    final before = plan(const []);
    final after = plan(const [
      MixFigmaSyncOperation(
        action: MixFigmaSyncAction.update,
        kind: 'textStyle',
        ref: 'textStyles/body',
        name: 'type/body',
      ),
    ]);

    final report = verifyMixFigmaSync(
      approvedPlan: before,
      observedPlan: after,
      allowDeletes: true,
    );

    expect(report.status, MixFigmaSyncVerificationStatus.failed);
    expect(report.remainingMutations, 1);
  });

  test('verification reports skipped unowned resources as retained', () {
    final before = plan(const []);
    final after = plan(const [
      MixFigmaSyncOperation(
        action: MixFigmaSyncAction.skip,
        kind: 'textStyle',
        ref: 'style:user',
        name: 'User/Safety Sentinel',
        diagnostics: [
          MixFigmaDiagnostic(
            code: 'unmanaged_resource_preserved',
            severity: MixFigmaDiagnosticSeverity.info,
            path: '/styles/style:user',
            message: 'Unowned Figma resource was preserved.',
          ),
        ],
      ),
    ]);

    final report = verifyMixFigmaSync(
      approvedPlan: before,
      observedPlan: after,
      allowDeletes: false,
    );

    expect(
      report.status,
      MixFigmaSyncVerificationStatus.verifiedWithRetainedItems,
    );
    expect(report.pendingDeletes, 0);
    expect(
      report.diagnostics.map((item) => item.code),
      contains('unmanaged_resource_preserved'),
    );
  });
}
