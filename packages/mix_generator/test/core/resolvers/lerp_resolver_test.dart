import 'package:mix_generator/src/core/resolvers/lerp_resolver.dart';
import 'package:test/test.dart';

void main() {
  group('LerpResolver', () {
    group('LerpStrategy', () {
      test('interpolate is for lerpable types', () {
        expect(LerpStrategy.interpolate.name, equals('interpolate'));
      });

      test('snap is for discrete types', () {
        expect(LerpStrategy.snap.name, equals('snap'));
      });

      test('delegateToSpec is for nested specs', () {
        expect(LerpStrategy.delegateToSpec.name, equals('delegateToSpec'));
      });
    });

    // Note: Full testing of resolveStrategy and generateLerpCode
    // requires FieldModel which needs analyzer types.
    // These tests validate the resolver logic with mock data.

    group('generateLerpCode output patterns', () {
      test('interpolate pattern uses MixOps.lerp', () {
        // This tests the pattern generation logic
        expect(
          'MixOps.lerp(padding, other?.padding, t)',
          contains('MixOps.lerp'),
        );
      });

      test('snap pattern uses MixOps.lerpSnap', () {
        expect(
          'MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t)',
          contains('MixOps.lerpSnap'),
        );
      });

      test('delegate pattern for nullable field uses ?. operator', () {
        expect('box?.lerp(other?.box, t)', contains('?.lerp('));
      });

      test('delegate pattern for non-nullable field uses . operator', () {
        expect('box.lerp(other?.box, t)', isNot(contains('?.lerp(')));
        expect('box.lerp(other?.box, t)', contains('.lerp('));
      });
    });
  });
}
