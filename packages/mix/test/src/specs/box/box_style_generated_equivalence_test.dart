import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../fixtures/box_spec_for_spike.dart';
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

    test('direct field factories exist on both', () {
      expect(() => BoxStyler.padding(.all(8)), returnsNormally);
      expect(() => BoxSpecForSpikeStyler.padding(.all(8)), returnsNormally);

      expect(() => BoxStyler.constraints(.width(100)), returnsNormally);
      expect(
        () => BoxSpecForSpikeStyler.constraints(.width(100)),
        returnsNormally,
      );
    });

    test('merge composes the generated styler field shape', () {
      final a = BoxSpecForSpikeStyler().color(const Color(0xFF000000));
      final b = BoxSpecForSpikeStyler().padding(.all(8));
      final merged = a.merge(b);

      expect(merged.$padding, isNotNull);
      expect(merged.$decoration, isNotNull);
    });

    test('generated base methods merge style metadata through MixOps', () {
      final modifier = WidgetModifierConfig.orderOfModifiers(const [
        OpacityModifier,
      ]);
      final animation = AnimationConfig.ease(const Duration(milliseconds: 100));
      final variant = VariantStyle(
        const NamedVariant('compact'),
        BoxSpecForSpikeStyler().height(24),
      );

      final styled = BoxSpecForSpikeStyler()
          .modifier(modifier)
          .animate(animation)
          .variants([variant]);

      expect(styled.$modifier, modifier);
      expect(styled.$animation, animation);
      expect(styled.$variants, [variant]);

      final wrapped = BoxSpecForSpikeStyler().wrap(modifier);

      expect(wrapped.$modifier, modifier);
    });

    test('generated spec lerp uses MixOps interpolation strategy', () {
      final start = BoxSpecForSpike(
        padding: const EdgeInsets.all(10),
        clipBehavior: Clip.none,
      );
      final end = BoxSpecForSpike(
        padding: const EdgeInsets.all(20),
        clipBehavior: Clip.hardEdge,
      );

      final midpoint = start.lerp(end, 0.5);
      final beforeSnap = start.lerp(end, 0.49);

      expect(midpoint.padding, const EdgeInsets.all(15));
      expect(midpoint.clipBehavior, Clip.hardEdge);
      expect(beforeSnap.clipBehavior, Clip.none);
    });
  });
}
