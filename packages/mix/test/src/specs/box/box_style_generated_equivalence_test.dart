import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../fixtures/box_spec_for_spike.styler.g.dart';

void main() {
  group('BoxStyler vs BoxSpecForSpikeStyler equivalence', () {
    test('both expose representative public mixin-derived methods', () {
      final hand = BoxStyler();
      final generated = BoxSpecForSpikeStyler();

      expect(() => hand.color(const Color(0xFF000000)), returnsNormally);
      expect(() => generated.color(const Color(0xFF000000)), returnsNormally);

      expect(() => hand.width(100), returnsNormally);
      expect(() => generated.width(100), returnsNormally);

      expect(() => hand.paddingAll(8), returnsNormally);
      expect(() => generated.paddingAll(8), returnsNormally);
    });

    test('factories exist on both', () {
      expect(() => BoxStyler.color(const Color(0xFF000000)), returnsNormally);
      expect(
        () => BoxSpecForSpikeStyler.color(const Color(0xFF000000)),
        returnsNormally,
      );

      expect(() => BoxStyler.width(100), returnsNormally);
      expect(() => BoxSpecForSpikeStyler.width(100), returnsNormally);
    });

    test('merge composes the generated styler field shape', () {
      final a = BoxSpecForSpikeStyler().color(const Color(0xFF000000));
      final b = BoxSpecForSpikeStyler().padding(.all(8));
      final merged = a.merge(b);

      expect(merged.$padding, isNotNull);
      expect(merged.$decoration, isNotNull);
    });
  });
}
