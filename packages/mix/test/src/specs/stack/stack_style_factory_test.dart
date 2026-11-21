import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('StackStyler factory constructors', () {
    group('dot-shorthand resolution', () {
      test('factory resolves via dot-shorthand typed assignment', () {
        StackStyler styler = StackStyler.alignment(Alignment.center);
        expect(styler.$alignment, isNotNull);
      });

      test('chaining after factory constructor works', () {
        final styler = StackStyler.alignment(
          Alignment.center,
        ).fit(.expand).clipBehavior(.hardEdge);
        expect(styler.$alignment, isNotNull);
        expect(styler.$fit, isNotNull);
        expect(styler.$clipBehavior, isNotNull);
      });
    });

    group('factory matches instance method', () {
      test('alignment', () {
        expect(
          StackStyler.alignment(Alignment.center),
          equals(StackStyler(alignment: Alignment.center)),
        );
      });

      test('fit', () {
        expect(StackStyler.fit(.expand), equals(StackStyler(fit: .expand)));
      });

      test('clipBehavior', () {
        expect(
          StackStyler.clipBehavior(.hardEdge),
          equals(StackStyler(clipBehavior: .hardEdge)),
        );
      });

      test('textDirection', () {
        expect(
          StackStyler.textDirection(.rtl),
          equals(StackStyler(textDirection: .rtl)),
        );
      });
    });

    group('resolved values', () {
      test('alignment resolves correctly', () {
        final alignment = StackStyler.alignment(
          Alignment.center,
        ).$alignment!.resolveProp(MockBuildContext());
        expect(alignment, Alignment.center);
      });

      test('fit resolves correctly', () {
        final fit = StackStyler.fit(
          .expand,
        ).$fit!.resolveProp(MockBuildContext());
        expect(fit, StackFit.expand);
      });
    });
  });
}
