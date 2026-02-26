import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/trust/capability_matrix.dart';

void main() {
  group('TrustCapabilities', () {
    test('minimal trust limits', () {
      expect(TrustCapabilities.minimal.maxDepth, 5);
      expect(TrustCapabilities.minimal.maxNodeCount, 50);
      expect(TrustCapabilities.minimal.maxAnimatedNodes, 5);
    });

    test('standard trust limits', () {
      expect(TrustCapabilities.standard.maxDepth, 10);
      expect(TrustCapabilities.standard.maxNodeCount, 200);
      expect(TrustCapabilities.standard.maxAnimatedNodes, 20);
    });

    test('elevated trust limits', () {
      expect(TrustCapabilities.elevated.maxDepth, 20);
      expect(TrustCapabilities.elevated.maxNodeCount, 1000);
      expect(TrustCapabilities.elevated.maxAnimatedNodes, 50);
    });

    test('forTrust returns correct capabilities', () {
      expect(TrustCapabilities.forTrust(SchemaTrust.minimal),
          TrustCapabilities.minimal);
      expect(TrustCapabilities.forTrust(SchemaTrust.standard),
          TrustCapabilities.standard);
      expect(TrustCapabilities.forTrust(SchemaTrust.elevated),
          TrustCapabilities.elevated);
    });
  });

  group('ActionPolicy', () {
    group('policyFor matches §9.3 trust-action gating table', () {
      // Minimal trust
      test('minimal + low = execute', () {
        expect(
          TrustCapabilities.policyFor(SchemaTrust.minimal, ActionRisk.low),
          ActionPolicy.execute,
        );
      });

      test('minimal + medium = block', () {
        expect(
          TrustCapabilities.policyFor(SchemaTrust.minimal, ActionRisk.medium),
          ActionPolicy.block,
        );
      });

      test('minimal + high = block', () {
        expect(
          TrustCapabilities.policyFor(SchemaTrust.minimal, ActionRisk.high),
          ActionPolicy.block,
        );
      });

      // Standard trust
      test('standard + low = execute', () {
        expect(
          TrustCapabilities.policyFor(SchemaTrust.standard, ActionRisk.low),
          ActionPolicy.execute,
        );
      });

      test('standard + medium = proposeBeforeExecute', () {
        expect(
          TrustCapabilities.policyFor(SchemaTrust.standard, ActionRisk.medium),
          ActionPolicy.proposeBeforeExecute,
        );
      });

      test('standard + high = block', () {
        expect(
          TrustCapabilities.policyFor(SchemaTrust.standard, ActionRisk.high),
          ActionPolicy.block,
        );
      });

      // Elevated trust
      test('elevated + low = execute', () {
        expect(
          TrustCapabilities.policyFor(SchemaTrust.elevated, ActionRisk.low),
          ActionPolicy.execute,
        );
      });

      test('elevated + medium = execute', () {
        expect(
          TrustCapabilities.policyFor(SchemaTrust.elevated, ActionRisk.medium),
          ActionPolicy.execute,
        );
      });

      test('elevated + high = proposeBeforeExecute', () {
        expect(
          TrustCapabilities.policyFor(SchemaTrust.elevated, ActionRisk.high),
          ActionPolicy.proposeBeforeExecute,
        );
      });
    });
  });

  group('SchemaTrust', () {
    test('has three values', () {
      expect(SchemaTrust.values.length, 3);
      expect(SchemaTrust.values, contains(SchemaTrust.minimal));
      expect(SchemaTrust.values, contains(SchemaTrust.standard));
      expect(SchemaTrust.values, contains(SchemaTrust.elevated));
    });
  });

  group('ActionRisk', () {
    test('has three levels', () {
      expect(ActionRisk.values.length, 3);
      expect(ActionRisk.values, contains(ActionRisk.low));
      expect(ActionRisk.values, contains(ActionRisk.medium));
      expect(ActionRisk.values, contains(ActionRisk.high));
    });
  });
}
