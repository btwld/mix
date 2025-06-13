import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('SpaceDto', () {
    test('from value constructor works correctly', () {
      const dto = SpaceDto(10.0);
      final result = dto.resolve(EmptyMixData);
      expect(result, 10.0);
    });

    testWidgets('SpaceDto.token resolves using unified resolver system',
        (tester) async {
      const testToken = MixToken<double>('test-space');

      await tester.pumpWithMixTheme(
        Container(),
        theme: MixThemeData.unified(
          tokens: {
            testToken: 16.0,
          },
        ),
      );

      final buildContext = tester.element(find.byType(Container));
      final mockMixData = MixData.create(buildContext, Style());

      final spaceDto = SpaceDto.token(testToken);
      final resolvedValue = spaceDto.resolve(mockMixData);

      expect(resolvedValue, isA<double>());
      expect(resolvedValue, 16.0);
    });
  });
}