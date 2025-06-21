import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('SpaceToken Tests', () {
    // Constructor Test
    test('Constructor assigns name correctly', () {
      const spaceToken = SpaceToken('testName');
      expect(spaceToken.name, 'testName');
    });

    // Equality Operator Test
    test('Equality operator works correctly', () {
      const spaceToken1 = SpaceToken('testName');
      const spaceToken2 = SpaceToken('testName');

      const spaceToken3 = SpaceToken('differentName');

      expect(spaceToken1 == spaceToken2, isTrue);

      expect(spaceToken1 == spaceToken3, isFalse);
      expect(spaceToken1 == Object(), isFalse);
    });

    // HashCode Test
    test('hashCode is consistent with name', () {
      const spaceToken1 = SpaceToken('testName');
      const spaceToken2 = SpaceToken('testName');
      const spaceToken3 = SpaceToken('differentName');

      expect(spaceToken1.hashCode, spaceToken2.hashCode);
      expect(spaceToken1.hashCode, isNot(spaceToken3.hashCode));
    });

    testWidgets('Test it resolves correctly', (tester) async {
      const smallSpaceToken = SpaceToken('small');
      const mediumSpaceToken = SpaceToken('medium');
      const largeSpaceToken = SpaceToken('large');

      final theme = MixThemeData(
        spaces: {
          smallSpaceToken: 4,
          mediumSpaceToken: 8,
          largeSpaceToken: 16,
        },
      );

      await tester.pumpWidget(createWithMixTheme(theme));

      final context = tester.element(find.byType(Container));

      final mixData = MixContext.create(context, const Style.empty());

      expect(mixData.tokens.spaceToken(smallSpaceToken), 4);
      expect(mixData.tokens.spaceToken(mediumSpaceToken), 8);
      expect(mixData.tokens.spaceToken(largeSpaceToken), 16);
    });
  });
}
