import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Shadow list merge (Prop<List<T>> with ListMix wrappers)', () {
    test(
      'BoxDecorationMix: merges boxShadow lists by index with in-place item merge',
      () {
        final first = BoxDecorationMix.boxShadow([
          BoxShadowMix(color: Colors.blue, blurRadius: 4.0),
          BoxShadowMix(offset: const Offset(1, 1), spreadRadius: 1.0),
        ]);

        final second = BoxDecorationMix.boxShadow([
          BoxShadowMix(color: Colors.red),
          BoxShadowMix(blurRadius: 10.0),
        ]);

        final merged = first.merge(second);

        final ctx = MockBuildContext();
        final resolved = merged.resolve(ctx);
        expect(resolved, isA<BoxDecoration>());
        final box = resolved;

        expect(box.boxShadow, isNotNull);
        expect(box.boxShadow, hasLength(2));

        // Index 0: color from second, blur from first (since second didn't set blur)
        expect(box.boxShadow![0].color, Colors.red);
        expect(box.boxShadow![0].blurRadius, 4.0);

        // Index 1: offset from first, blur from second, spread from first
        expect(box.boxShadow![1].offset, const Offset(1, 1));
        expect(box.boxShadow![1].blurRadius, 10.0);
        expect(box.boxShadow![1].spreadRadius, 1.0);
      },
    );

    test(
      'BoxDecorationMix: merges lists of different lengths (first shorter)',
      () {
        final first = BoxDecorationMix.boxShadow([
          BoxShadowMix(blurRadius: 2.0),
        ]);

        final second = BoxDecorationMix.boxShadow([
          BoxShadowMix(color: Colors.red),
          BoxShadowMix(blurRadius: 7.0),
        ]);

        final merged = first.merge(second);
        final box = merged.resolve(MockBuildContext());

        expect(box.boxShadow, hasLength(2));
        // index 0 merged: blur from first, color from second
        expect(box.boxShadow![0].blurRadius, 2.0);
        expect(box.boxShadow![0].color, Colors.red);
        // index 1 comes from second (since first is shorter)
        expect(box.boxShadow![1].blurRadius, 7.0);
      },
    );

    test(
      'BoxDecorationMix: merges lists of different lengths (first longer)',
      () {
        final first = BoxDecorationMix.boxShadow([
          BoxShadowMix(blurRadius: 2.0),
          BoxShadowMix(spreadRadius: 3.0),
        ]);

        final second = BoxDecorationMix.boxShadow([
          BoxShadowMix(color: Colors.red),
        ]);

        final merged = first.merge(second);
        final box = merged.resolve(MockBuildContext());

        expect(box.boxShadow, hasLength(2));
        // index 0 merged: blur from first, color from second
        expect(box.boxShadow![0].blurRadius, 2.0);
        expect(box.boxShadow![0].color, Colors.red);
        // index 1 retained from first (since second is shorter)
        expect(box.boxShadow![1].spreadRadius, 3.0);
      },
    );

    group('Integration via ShadowStyleMixin (BoxStyler)', () {
      test('shadowOnly merge: same index item merges in-place', () {
        final a = BoxStyler().shadowOnly(color: Colors.blue, blurRadius: 4.0);
        final b = BoxStyler().shadowOnly(color: Colors.red);

        final merged = a.merge(b);
        final spec = merged.resolve(MockBuildContext());
        final decoration = spec.spec.decoration as BoxDecoration?;
        expect(decoration, isNotNull);
        expect(decoration!.boxShadow, hasLength(1));
        expect(decoration.boxShadow![0].color, Colors.red);
        expect(decoration.boxShadow![0].blurRadius, 4.0);
      });

      test('shadows merge: multiple items merge by index', () {
        final a = BoxStyler().shadows([
          BoxShadowMix(offset: const Offset(1, 1)),
        ]);
        final b = BoxStyler().shadows([BoxShadowMix(blurRadius: 10.0)]);

        final merged = a.merge(b);
        final spec = merged.resolve(MockBuildContext());
        final decoration = spec.spec.decoration as BoxDecoration?;
        expect(decoration, isNotNull);
        expect(decoration!.boxShadow, hasLength(1));
        expect(decoration.boxShadow![0].offset, const Offset(1, 1));
        expect(decoration.boxShadow![0].blurRadius, 10.0);
      });
    });
  });
}
