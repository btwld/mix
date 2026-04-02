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
        ).fit(StackFit.expand).clipBehavior(Clip.hardEdge);
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
        expect(
          StackStyler.fit(StackFit.expand),
          equals(StackStyler(fit: StackFit.expand)),
        );
      });

      test('clipBehavior', () {
        expect(
          StackStyler.clipBehavior(Clip.hardEdge),
          equals(StackStyler(clipBehavior: Clip.hardEdge)),
        );
      });

      test('textDirection', () {
        expect(
          StackStyler.textDirection(TextDirection.rtl),
          equals(StackStyler(textDirection: TextDirection.rtl)),
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
          StackFit.expand,
        ).$fit!.resolveProp(MockBuildContext());
        expect(fit, StackFit.expand);
      });
    });
  });
}
