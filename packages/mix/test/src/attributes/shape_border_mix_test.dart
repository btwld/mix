import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  group('RoundedRectangleBorderMix', () {
    test('only constructor with DTO objects', () {
      final mix = RoundedRectangleBorderMix.only(
        borderRadius: BorderRadiusMix.only(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(20),
          bottomLeft: const Radius.circular(5),
          bottomRight: const Radius.circular(10),
        ),
        side: BorderSideMix.only(color: Colors.red, width: 1.0),
      );

      expect(
        dto,
        resolvesTo(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(10),
            ),
            side: BorderSide(color: Colors.red, width: 1.0),
          ),
        ),
      );
    });

    test('main constructor with MixProp values', () {
      final mix = RoundedRectangleBorderMix(
        borderRadius: MixProp(
          BorderRadiusMix.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(20),
            bottomLeft: const Radius.circular(5),
            bottomRight: const Radius.circular(10),
          ),
        ),
        side: MixProp(BorderSideMix.only(color: Colors.red, width: 1.0)),
      );

      expect(
        dto,
        resolvesTo(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(10),
            ),
            side: BorderSide(color: Colors.red, width: 1.0),
          ),
        ),
      );
    });

    test('value constructor from Flutter object', () {
      const border = RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(10),
        ),
        side: BorderSide(color: Colors.red, width: 1.0),
      );
      final mix = RoundedRectangleBorderMix.value(border);

      expect(mix, resolvesTo(border));
    });

    test('merge should combine two RoundedRectangleBorderMixs correctly', () {
      final original = RoundedRectangleBorderMix.only(
        borderRadius: BorderRadiusMix.only(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(20),
          bottomLeft: const Radius.circular(5),
          bottomRight: const Radius.circular(10),
        ),
        side: BorderSideMix.only(color: Colors.red, width: 1.0),
      );
      final merged = original.merge(
        RoundedRectangleBorderMix.only(
          borderRadius: BorderRadiusMix.only(
            topLeft: const Radius.circular(25),
          ),
          side: BorderSideMix.only(color: Colors.blue, width: 2.0),
        ),
      );

      expect(
        merged,
        resolvesTo(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(10),
            ),
            side: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
      );
    });
  });

  group('CircleBorderMix', () {
    test('only constructor with DTO objects', () {
      final mix = CircleBorderMix.only(
        side: BorderSideMix.only(color: Colors.red, width: 1.0),
        eccentricity: 0.5,
      );

      expect(
        dto,
        resolvesTo(
          const CircleBorder(
            side: BorderSide(color: Colors.red, width: 1.0),
            eccentricity: 0.5,
          ),
        ),
      );
    });

    test('main constructor with MixProp values', () {
      final mix = CircleBorderMix(
        side: MixProp(BorderSideMix.only(color: Colors.red, width: 1.0)),
        eccentricity: Prop(0.5),
      );

      expect(
        dto,
        resolvesTo(
          const CircleBorder(
            side: BorderSide(color: Colors.red, width: 1.0),
            eccentricity: 0.5,
          ),
        ),
      );
    });

    test('value constructor from Flutter object', () {
      const border = CircleBorder(
        side: BorderSide(color: Colors.red, width: 1.0),
        eccentricity: 0.5,
      );
      final mix = CircleBorderMix.value(border);

      expect(mix, resolvesTo(border));
    });

    test('merge should combine two CircleBorderMixs correctly', () {
      final original = CircleBorderMix.only(
        side: BorderSideMix.only(color: Colors.red, width: 1.0),
        eccentricity: 0.5,
      );
      final merged = original.merge(
        CircleBorderMix.only(
          side: BorderSideMix.only(color: Colors.blue, width: 2.0),
          eccentricity: 0.75,
        ),
      );

      expect(
        merged,
        resolvesTo(
          const CircleBorder(
            side: BorderSide(color: Colors.blue, width: 2.0),
            eccentricity: 0.75,
          ),
        ),
      );
    });
  });

  group('BeveledRectangleBorderMix', () {
    test('only constructor with DTO objects', () {
      final mix = BeveledRectangleBorderMix.only(
        borderRadius: BorderRadiusMix.only(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(20),
          bottomLeft: const Radius.circular(5),
          bottomRight: const Radius.circular(10),
        ),
        side: BorderSideMix.only(color: Colors.red, width: 1.0),
      );

      expect(
        dto,
        resolvesTo(
          const BeveledRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(10),
            ),
            side: BorderSide(color: Colors.red, width: 1.0),
          ),
        ),
      );
    });

    test('value constructor from Flutter object', () {
      const border = BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(10),
        ),
        side: BorderSide(color: Colors.red, width: 1.0),
      );
      final mix = BeveledRectangleBorderMix.value(border);

      expect(mix, resolvesTo(border));
    });
  });

  group('ContinuousRectangleBorderMix', () {
    test('only constructor with DTO objects', () {
      final mix = ContinuousRectangleBorderMix.only(
        borderRadius: BorderRadiusMix.only(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(20),
          bottomLeft: const Radius.circular(5),
          bottomRight: const Radius.circular(10),
        ),
        side: BorderSideMix.only(color: Colors.red, width: 1.0),
      );

      expect(
        dto,
        resolvesTo(
          const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(10),
            ),
            side: BorderSide(color: Colors.red, width: 1.0),
          ),
        ),
      );
    });

    test('value constructor from Flutter object', () {
      const border = ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(10),
        ),
        side: BorderSide(color: Colors.red, width: 1.0),
      );
      final mix = ContinuousRectangleBorderMix.value(border);

      expect(mix, resolvesTo(border));
    });
  });

  group('StadiumBorderMix', () {
    test('only constructor with DTO objects', () {
      final mix = StadiumBorderMix.only(
        side: BorderSideMix.only(color: Colors.red, width: 1.0),
      );

      expect(
        dto,
        resolvesTo(
          const StadiumBorder(side: BorderSide(color: Colors.red, width: 1.0)),
        ),
      );
    });

    test('value constructor from Flutter object', () {
      const border = StadiumBorder(
        side: BorderSide(color: Colors.red, width: 1.0),
      );
      final mix = StadiumBorderMix.value(border);

      expect(mix, resolvesTo(border));
    });
  });

  group('ShapeBorderMix factory methods', () {
    test(
      'value factory creates correct DTO type for RoundedRectangleBorder',
      () {
        final border = RoundedRectangleBorderMix.only(
          borderRadius: BorderRadiusMix.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
            bottomLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10),
          ),
          side: BorderSideMix.only(color: Colors.red, width: 2.0),
        ).resolve(MockBuildContext());
        final mix = ShapeBorderMix.value(border);

        expect(mix, isA<RoundedRectangleBorderMix>());
        expect(mix, resolvesTo(border));
      },
    );

    test('value factory creates correct DTO type for CircleBorder', () {
      const border = CircleBorder(
        side: BorderSide(color: Colors.blue, width: 1.5),
      );
      final mix = ShapeBorderMix.value(border);

      expect(mix, isA<CircleBorderMix>());
      expect(mix, resolvesTo(border));
    });

    test('maybeValue returns null for null input', () {
      final mix = ShapeBorderMix.maybeValue(null);
      expect(mix, isNull);
    });

    test('maybeValue returns DTO for non-null input', () {
      const border = StadiumBorder();
      final mix = ShapeBorderMix.maybeValue(border);

      expect(mix, isA<StadiumBorderMix>());
      expect(mix, resolvesTo(border));
    });
  });
}
