import 'package:mix_generator/src/core/resolvers/lerp_resolver.dart';
import 'package:test/test.dart';

import '../test_helpers.dart';

void main() {
  group('lerp_resolver', () {
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

    group('resolveLerpStrategy', () {
      test('returns interpolate for lerpable fields', () {
        final field = createTestFieldModel(
          name: 'padding',
          typeName: 'EdgeInsetsGeometry',
          isLerpable: true,
        );

        expect(resolveLerpStrategy(field), LerpStrategy.interpolate);
      });

      test('returns snap for non-lerpable fields', () {
        final field = createTestFieldModel(
          name: 'clipBehavior',
          typeName: 'Clip',
          isLerpable: false,
        );

        expect(resolveLerpStrategy(field), LerpStrategy.snap);
      });

      test('returns delegateToSpec for StyleSpec fields', () {
        final field = createTestFieldModel(
          name: 'box',
          typeName: 'StyleSpec<BoxSpec>',
          effectiveSpecType: 'StyleSpec<BoxSpec>?',
          isNullable: true,
          styleSpecArgument: 'BoxSpec',
        );

        expect(resolveLerpStrategy(field), LerpStrategy.delegateToSpec);
      });

      test('prefers delegateToSpec over interpolate for StyleSpec fields', () {
        final field = createTestFieldModel(
          name: 'box',
          typeName: 'StyleSpec<BoxSpec>',
          effectiveSpecType: 'StyleSpec<BoxSpec>?',
          isNullable: true,
          styleSpecArgument: 'BoxSpec',
          isLerpable: true,
        );

        expect(resolveLerpStrategy(field), LerpStrategy.delegateToSpec);
      });
    });

    group('generateLerpCode', () {
      test('generates MixOps.lerp for interpolate strategy', () {
        final field = createTestFieldModel(
          name: 'padding',
          typeName: 'EdgeInsetsGeometry',
          isLerpable: true,
        );

        expect(
          generateLerpCode(field),
          equals('MixOps.lerp(padding, other?.padding, t)'),
        );
      });

      test('generates MixOps.lerpSnap for snap strategy', () {
        final field = createTestFieldModel(
          name: 'clipBehavior',
          typeName: 'Clip',
          isLerpable: false,
        );

        expect(
          generateLerpCode(field),
          equals('MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t)'),
        );
      });

      test('uses ?. for nullable StyleSpec fields', () {
        final field = createTestFieldModel(
          name: 'box',
          typeName: 'StyleSpec<BoxSpec>',
          effectiveSpecType: 'StyleSpec<BoxSpec>?',
          isNullable: true,
          styleSpecArgument: 'BoxSpec',
        );

        expect(generateLerpCode(field), equals('box?.lerp(other?.box, t)'));
      });

      test('uses . for non-nullable StyleSpec fields', () {
        final field = createTestFieldModel(
          name: 'box',
          typeName: 'StyleSpec<BoxSpec>',
          effectiveSpecType: 'StyleSpec<BoxSpec>',
          isNullable: false,
          styleSpecArgument: 'BoxSpec',
        );

        expect(generateLerpCode(field), equals('box.lerp(other?.box, t)'));
      });
    });
  });
}
