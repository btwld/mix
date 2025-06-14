import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('RadiusToken', () {
    test('Constructor assigns name correctly', () {
      const radiusRef = RadiusToken('testName');
      expect(radiusRef.name, 'testName');
    });

    test('Equality operator works correctly', () {
      const radiusRef1 = RadiusToken('testName');
      const radiusRef2 = RadiusToken('testName');
      const radiusRef3 = RadiusToken('differentName');

      expect(radiusRef1 == radiusRef2, isTrue);
      expect(radiusRef1 == radiusRef3, isFalse);
      expect(radiusRef1 == Object(), isFalse);
    });

    test('hashCode is consistent with name', () {
      const radiusRef1 = RadiusToken('testName');
      const radiusRef2 = RadiusToken('testName');
      const radiusRef3 = RadiusToken('differentName');

      expect(radiusRef1.hashCode, radiusRef2.hashCode);
      expect(radiusRef1.hashCode, isNot(radiusRef3.hashCode));
    });

    testWidgets('Test it resolves correctly', (tester) async {
      const redRadiusRef = RadiusToken('red');
      const greenRadiusRef = RadiusToken('green');
      const blueRadiusRef = RadiusToken('blue');
      final theme = MixThemeData(
        radii: {
          redRadiusRef: const Radius.circular(1),
          greenRadiusRef: const Radius.circular(2),
          blueRadiusRef: const Radius.circular(3),
        },
      );

      await tester.pumpWidget(createWithMixTheme(theme));

      final context = tester.element(find.byType(Container));

      final mixData = MixContext.create(context, const Style.empty());

      expect(mixData.tokens.radiiToken(redRadiusRef), const Radius.circular(1));
      expect(
        mixData.tokens.radiiToken(greenRadiusRef),
        const Radius.circular(2),
      );
      expect(
        mixData.tokens.radiiToken(blueRadiusRef),
        const Radius.circular(3),
      );
    });
  });

  test('RadiusResolver resolves correctly', () {
    final radiusResolver =
        RadiusResolver((context) => const Radius.circular(5));
    final context = MockBuildContext();

    final resolvedValue = radiusResolver.resolve(context);

    expect(resolvedValue, const Radius.circular(5));
  });

  test('RadiusRef equality operator works correctly', () {
    const radiusToken1 = RadiusToken('testToken');
    const radiusToken2 = RadiusToken('testToken');
    const radiusToken3 = RadiusToken('differentToken');

    const radiusRef1 = RadiusRef(radiusToken1);
    const radiusRef2 = RadiusRef(radiusToken2);
    const radiusRef3 = RadiusRef(radiusToken3);

    expect(radiusRef1 == radiusRef2, isTrue);
    expect(radiusRef1 == radiusRef3, isFalse);
    expect(radiusRef1 == Object(), isFalse);
  });

  test('RadiusRef hashCode is consistent with token', () {
    const radiusToken1 = RadiusToken('testToken');
    const radiusToken2 = RadiusToken('testToken');
    const radiusToken3 = RadiusToken('differentToken');

    const radiusRef1 = RadiusRef(radiusToken1);
    const radiusRef2 = RadiusRef(radiusToken2);
    const radiusRef3 = RadiusRef(radiusToken3);

    expect(radiusRef1.hashCode, radiusRef2.hashCode);
    expect(radiusRef1.hashCode, isNot(radiusRef3.hashCode));
  });

  test('UtilityWithRadiusTokens calls the provided function correctly', () {
    final utility =
        UtilityWithRadiusTokens<String>((value) => 'Radius: $value');

    final result = utility(const Radius.circular(10));

    expect(result, 'Radius: Radius.circular(10.0)');
  });

  test(
      'UtilityWithRadiusTokens.shorthand calls the provided function correctly',
      () {
    final utility =
        UtilityWithRadiusTokens.shorthand((p1, [p2, p3, p4]) => 'Radius: $p1');

    final result = utility(const Radius.circular(10));

    expect(result, 'Radius: Radius.circular(10.0)');
  });
}
