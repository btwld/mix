import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexStyler factory constructors', () {
    group('dot-shorthand resolution', () {
      test('factory resolves via dot-shorthand typed assignment', () {
        FlexStyler styler = FlexStyler.direction(.horizontal);
        expect(styler.$direction, isNotNull);
      });

      test('chaining after factory constructor works', () {
        final styler = FlexStyler.direction(
          .horizontal,
        ).spacing(8).mainAxisAlignment(.center);
        expect(styler.$direction, isNotNull);
        expect(styler.$spacing, isNotNull);
        expect(styler.$mainAxisAlignment, isNotNull);
      });
    });

    group('factory matches instance method', () {
      test('direction', () {
        expect(
          FlexStyler.direction(.horizontal),
          equals(FlexStyler(direction: .horizontal)),
        );
      });

      test('mainAxisAlignment', () {
        expect(
          FlexStyler.mainAxisAlignment(.center),
          equals(FlexStyler(mainAxisAlignment: .center)),
        );
      });

      test('crossAxisAlignment', () {
        expect(
          FlexStyler.crossAxisAlignment(.stretch),
          equals(FlexStyler(crossAxisAlignment: .stretch)),
        );
      });

      test('mainAxisSize', () {
        expect(
          FlexStyler.mainAxisSize(.min),
          equals(FlexStyler(mainAxisSize: .min)),
        );
      });

      test('spacing', () {
        expect(FlexStyler.spacing(16), equals(FlexStyler(spacing: 16)));
      });

      test('clipBehavior', () {
        expect(
          FlexStyler.clipBehavior(.hardEdge),
          equals(FlexStyler(clipBehavior: .hardEdge)),
        );
      });

      test('row', () {
        expect(FlexStyler.row(), equals(FlexStyler(direction: .horizontal)));
      });

      test('column', () {
        expect(FlexStyler.column(), equals(FlexStyler(direction: .vertical)));
      });

      test('verticalDirection', () {
        expect(
          FlexStyler.verticalDirection(.up),
          equals(FlexStyler(verticalDirection: .up)),
        );
      });

      test('textDirection', () {
        expect(
          FlexStyler.textDirection(.rtl),
          equals(FlexStyler(textDirection: .rtl)),
        );
      });

      test('textBaseline', () {
        expect(
          FlexStyler.textBaseline(.alphabetic),
          equals(FlexStyler(textBaseline: .alphabetic)),
        );
      });
    });

    group('resolved values', () {
      test('direction resolves correctly', () {
        final direction = FlexStyler.direction(
          .horizontal,
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
