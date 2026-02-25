import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexStyler factory constructors', () {
    group('dot-shorthand resolution', () {
      test('factory resolves via dot-shorthand typed assignment', () {
        FlexStyler styler = FlexStyler.direction(Axis.horizontal);
        expect(styler.$direction, isNotNull);
      });

      test('chaining after factory constructor works', () {
        final styler = FlexStyler.direction(
          Axis.horizontal,
        ).spacing(8).mainAxisAlignment(MainAxisAlignment.center);
        expect(styler.$direction, isNotNull);
        expect(styler.$spacing, isNotNull);
        expect(styler.$mainAxisAlignment, isNotNull);
      });
    });

    group('factory matches instance method', () {
      test('direction', () {
        expect(
          FlexStyler.direction(Axis.horizontal),
          equals(FlexStyler(direction: Axis.horizontal)),
        );
      });

      test('mainAxisAlignment', () {
        expect(
          FlexStyler.mainAxisAlignment(MainAxisAlignment.center),
          equals(FlexStyler(mainAxisAlignment: MainAxisAlignment.center)),
        );
      });

      test('crossAxisAlignment', () {
        expect(
          FlexStyler.crossAxisAlignment(CrossAxisAlignment.stretch),
          equals(FlexStyler(crossAxisAlignment: CrossAxisAlignment.stretch)),
        );
      });

      test('mainAxisSize', () {
        expect(
          FlexStyler.mainAxisSize(MainAxisSize.min),
          equals(FlexStyler(mainAxisSize: MainAxisSize.min)),
        );
      });

      test('spacing', () {
        expect(FlexStyler.spacing(16), equals(FlexStyler(spacing: 16)));
      });

      test('clipBehavior', () {
        expect(
          FlexStyler.clipBehavior(Clip.hardEdge),
          equals(FlexStyler(clipBehavior: Clip.hardEdge)),
        );
      });

      test('row', () {
        expect(
          FlexStyler.row(),
          equals(FlexStyler(direction: Axis.horizontal)),
        );
      });

      test('column', () {
        expect(
          FlexStyler.column(),
          equals(FlexStyler(direction: Axis.vertical)),
        );
      });
    });

    group('resolved values', () {
      test('direction resolves correctly', () {
        final direction = FlexStyler.direction(
          Axis.horizontal,
        ).$direction!.resolveProp(MockBuildContext());
        expect(direction, Axis.horizontal);
      });

      test('spacing resolves correctly', () {
        final spacing = FlexStyler.spacing(
          16,
        ).$spacing!.resolveProp(MockBuildContext());
        expect(spacing, 16);
      });
    });
  });
}
