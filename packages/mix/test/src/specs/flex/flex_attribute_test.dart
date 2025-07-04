import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  const token = MixTokensTest();
  group('FlexMixAttribute', () {
    test('of returns correct FlexMixAttribute', () {
      const attribute = FlexSpecAttribute();

      expect(attribute.direction, null);
      expect(attribute.mainAxisAlignment, null);
      expect(attribute.crossAxisAlignment, null);
      expect(attribute.mainAxisSize, null);
      expect(attribute.verticalDirection, null);
      expect(attribute.textDirection, null);
      expect(attribute.textBaseline, null);
      expect(attribute.clipBehavior, null);
      expect(attribute.gap, null);
    });

    test('resolve returns correct FlexSpec', () {
      const attribute = FlexSpecAttribute(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.up,
        textDirection: TextDirection.rtl,
        textBaseline: TextBaseline.alphabetic,
        clipBehavior: Clip.antiAlias,
        gap: SpaceDto(10.0),
      );
      final mixData = MixContext.create(MockBuildContext(), Style(attribute));
      final resolvedSpec = attribute.resolve(mixData);

      expect(resolvedSpec.crossAxisAlignment, CrossAxisAlignment.start);
      expect(resolvedSpec.mainAxisAlignment, MainAxisAlignment.center);
      expect(resolvedSpec.mainAxisSize, MainAxisSize.max);
      expect(resolvedSpec.verticalDirection, VerticalDirection.up);
      expect(resolvedSpec.direction, Axis.horizontal);
      expect(resolvedSpec.textDirection, TextDirection.rtl);
      expect(resolvedSpec.textBaseline, TextBaseline.alphabetic);
      expect(resolvedSpec.clipBehavior, Clip.antiAlias);
      expect(resolvedSpec.gap, 10.0);
    });

    testWidgets('tokens resolve returns correct FlexSpec', (tester) async {
      const tokenValue = 8.0;

      final theme = MixScopeData.static(
        tokens: {
          token.space.small: tokenValue,
        },
      );

      late MixContext mixData;

      await tester.pumpWidget(
        MixScope(
          data: theme,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  mixData = MixContext.create(
                    context,
                    Style(
                      $flex.gap.ref(token.space.small),
                    ),
                  );

                  return Container();
                },
              ),
            ),
          ),
        ),
      );

      final attribute = mixData.whereType<FlexSpecAttribute>().first;
      final resolvedSpec = attribute.resolve(mixData);

      expect(resolvedSpec.gap, tokenValue);
    });

    test('merge returns correct FlexMixAttribute', () {
      const attribute1 = FlexSpecAttribute(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.up,
        textDirection: TextDirection.rtl,
        textBaseline: TextBaseline.alphabetic,
        clipBehavior: Clip.antiAlias,
        gap: SpaceDto(10.0),
      );
      const attribute2 = FlexSpecAttribute(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.ideographic,
        clipBehavior: Clip.hardEdge,
        gap: SpaceDto(20.0),
      );
      final mergedAttribute = attribute1.merge(attribute2);

      expect(mergedAttribute.direction, Axis.vertical);
      expect(mergedAttribute.mainAxisAlignment, MainAxisAlignment.end);
      expect(mergedAttribute.crossAxisAlignment, CrossAxisAlignment.end);
      expect(mergedAttribute.mainAxisSize, MainAxisSize.min);
      expect(mergedAttribute.verticalDirection, VerticalDirection.down);
      expect(mergedAttribute.textDirection, TextDirection.ltr);
      expect(mergedAttribute.textBaseline, TextBaseline.ideographic);
      expect(mergedAttribute.clipBehavior, Clip.hardEdge);
      expect(mergedAttribute.gap, const SpaceDto(20.0));
    });
  });
}
