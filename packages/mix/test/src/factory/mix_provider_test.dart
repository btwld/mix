import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Mix', () {
    testWidgets('toInheritable()', (tester) async {
      final style = Style(
        $icon.color.black(),
        $with.scale(2),
      );

      final mixData = MixData.create(
        MockBuildContext(),
        style,
      );

      final expectedMixData = MixData.create(
        MockBuildContext(),
        Style(
          $icon.color.black(),
        ),
      );

      tester.pumpWidget(
        Mix(
          data: mixData,
          child: Builder(
            builder: (context) {
              final inheritedMixData = Mix.of(context).toInheritable();
              expect(inheritedMixData, expectedMixData);
              return Container();
            },
          ),
        ),
      );
    });
  });
}
