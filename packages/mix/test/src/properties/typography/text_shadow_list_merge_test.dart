import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextStyleMix shadows list merge (Prop<List<Shadow>>)', () {
    test('merges by index with in-place item merge', () {
      final first = TextStyleMix.shadows([
        ShadowMix(color: Colors.blue, blurRadius: 2.0),
        ShadowMix(offset: const Offset(1, 1)),
      ]);

      final second = TextStyleMix.shadows([
        ShadowMix(color: Colors.red),
        ShadowMix(blurRadius: 10.0),
      ]);

      final merged = first.merge(second);
      final textStyle = merged.resolve(MockBuildContext());

      expect(textStyle.shadows, isNotNull);
      expect(textStyle.shadows, hasLength(2));

      // Index 0: color from second, blur from first
      expect(textStyle.shadows![0].color, Colors.red);
      expect(textStyle.shadows![0].blurRadius, 2.0);

      // Index 1: offset from first, blur from second
      expect(textStyle.shadows![1].offset, const Offset(1, 1));
      expect(textStyle.shadows![1].blurRadius, 10.0);
    });

    test('different lengths are handled (left shorter)', () {
      final first = TextStyleMix.shadows([ShadowMix(blurRadius: 2.0)]);
      final second = TextStyleMix.shadows([
        ShadowMix(color: Colors.red),
        ShadowMix(blurRadius: 7.0),
      ]);

      final merged = first.merge(second);
      final ts = merged.resolve(MockBuildContext());

      expect(ts.shadows, hasLength(2));
      expect(ts.shadows![0].blurRadius, 2.0);
      expect(ts.shadows![0].color, Colors.red);
      expect(ts.shadows![1].blurRadius, 7.0);
    });
  });
}
