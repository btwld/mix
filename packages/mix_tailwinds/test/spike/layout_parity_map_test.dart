// Spike tests exercise unexported mix layout surfaces and internal APIs.
// ignore_for_file: implementation_imports, invalid_use_of_internal_member

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/layout/grid_track.dart';
import 'package:mix/src/specs/wrap/wrap_spec.dart';
import 'package:mix/src/specs/wrapbox/wrapbox_spec.dart';
import 'package:mix/src/variants/variant.dart' show ConstraintVariant;
import 'package:mix_tailwinds/src/spike/layout_parity_map.dart';

void main() {
  group('Spike 4 Tailwind layout parity map', () {
    test('acceptance mapping table covers the three required rows', () {
      expect(spike4AcceptanceMappings, hasLength(3));
      expect(
        spike4AcceptanceMappings.map((m) => m.tailwind).toList(),
        containsAll([
          '@container + @max-md:flex-col',
          'grid-cols-3 gap-4',
          'flex-wrap gap-2',
        ]),
      );
    });

    testWidgets('@max-md:flex-col → onConstraints vertical branch', (
      tester,
    ) async {
      final style = translateContainerMaxMdFlexCol();

      expect(style.$variants, isNotNull);
      expect(style.$variants!.first.variant, isA<ConstraintVariant>());

      Axis? direction;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 400,
              height: 100,
              child: StyleBuilder<FlexBoxSpec>(
                style: style,
                builder: (context, spec) {
                  direction = spec.flex?.spec.direction;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      expect(direction, Axis.vertical);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 900,
              height: 100,
              child: StyleBuilder<FlexBoxSpec>(
                style: style,
                builder: (context, spec) {
                  direction = spec.flex?.spec.direction;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      expect(direction, Axis.horizontal);
    });

    test('grid-cols-3 gap-4 → three fr tracks and 16px gap', () {
      final style = translateGridColsGap(columnCount: 3, gapStep: 4);
      expect(style.columns, hasLength(3));
      expect(style.columns.every((t) => t is FrGridTrack), isTrue);
      expect(style.columnGap, 16);
      expect(style.rowGap, 16);
    });

    test('flex-wrap gap-2 → WrapBoxStyler flow spacing/runSpacing 8', () {
      final style = translateFlexWrapGap(gapStep: 2);
      expect(style, isA<WrapBoxStyler>());
      expect(style.$flow, isNotNull);

      // Compare against the expected nested WrapStyler construction.
      final expected = WrapBoxStyler(
        flow: WrapStyler(spacing: 8, runSpacing: 8),
      );
      expect(style.$flow, expected.$flow);
    });
  });
}
