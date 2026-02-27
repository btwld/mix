import 'package:flutter_test/flutter_test.dart';
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

  group('SchemaTrust', () {
    test('has three values', () {
      expect(SchemaTrust.values.length, 3);
      expect(SchemaTrust.values, contains(SchemaTrust.minimal));
      expect(SchemaTrust.values, contains(SchemaTrust.standard));
      expect(SchemaTrust.values, contains(SchemaTrust.elevated));
    });
  });

}
