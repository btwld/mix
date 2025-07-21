import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  group('RoundedRectangleBorderDto', () {
    test('only constructor with DTO objects', () {
      final dto = RoundedRectangleBorderDto.only(
        borderRadius: BorderRadiusDto.only(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(20),
          bottomLeft: const Radius.circular(5),
          bottomRight: const Radius.circular(10),
        ),
        side: BorderSideDto.only(color: Colors.red, width: 1.0),
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
      final dto = RoundedRectangleBorderDto(
        borderRadius: MixProp(
          BorderRadiusDto.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(20),
            bottomLeft: const Radius.circular(5),
            bottomRight: const Radius.circular(10),
          ),
        ),
        side: MixProp(BorderSideDto.only(color: Colors.red, width: 1.0)),
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
      final dto = RoundedRectangleBorderDto.value(border);

      expect(dto, resolvesTo(border));
    });

    test('merge should combine two RoundedRectangleBorderDtos correctly', () {
      final original = RoundedRectangleBorderDto.only(
        borderRadius: BorderRadiusDto.only(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(20),
          bottomLeft: const Radius.circular(5),
          bottomRight: const Radius.circular(10),
        ),
        side: BorderSideDto.only(color: Colors.red, width: 1.0),
      );
      final merged = original.merge(
        RoundedRectangleBorderDto.only(
          borderRadius: BorderRadiusDto.only(
            topLeft: const Radius.circular(25),
          ),
          side: BorderSideDto.only(color: Colors.blue, width: 2.0),
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

  group('CircleBorderDto', () {
    test('only constructor with DTO objects', () {
      final dto = CircleBorderDto.only(
        side: BorderSideDto.only(color: Colors.red, width: 1.0),
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
      final dto = CircleBorderDto(
        side: MixProp(BorderSideDto.only(color: Colors.red, width: 1.0)),
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
      final dto = CircleBorderDto.value(border);

      expect(dto, resolvesTo(border));
    });

    test('merge should combine two CircleBorderDtos correctly', () {
      final original = CircleBorderDto.only(
        side: BorderSideDto.only(color: Colors.red, width: 1.0),
        eccentricity: 0.5,
      );
      final merged = original.merge(
        CircleBorderDto.only(
          side: BorderSideDto.only(color: Colors.blue, width: 2.0),
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

  group('BeveledRectangleBorderDto', () {
    test('only constructor with DTO objects', () {
      final dto = BeveledRectangleBorderDto.only(
        borderRadius: BorderRadiusDto.only(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(20),
          bottomLeft: const Radius.circular(5),
          bottomRight: const Radius.circular(10),
        ),
        side: BorderSideDto.only(color: Colors.red, width: 1.0),
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
      final dto = BeveledRectangleBorderDto.value(border);

      expect(dto, resolvesTo(border));
    });
  });

  group('ContinuousRectangleBorderDto', () {
    test('only constructor with DTO objects', () {
      final dto = ContinuousRectangleBorderDto.only(
        borderRadius: BorderRadiusDto.only(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(20),
          bottomLeft: const Radius.circular(5),
          bottomRight: const Radius.circular(10),
        ),
        side: BorderSideDto.only(color: Colors.red, width: 1.0),
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
      final dto = ContinuousRectangleBorderDto.value(border);

      expect(dto, resolvesTo(border));
    });
  });

  group('StadiumBorderDto', () {
    test('only constructor with DTO objects', () {
      final dto = StadiumBorderDto.only(
        side: BorderSideDto.only(color: Colors.red, width: 1.0),
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
      final dto = StadiumBorderDto.value(border);

      expect(dto, resolvesTo(border));
    });
  });

  group('ShapeBorderDto factory methods', () {
    test(
      'value factory creates correct DTO type for RoundedRectangleBorder',
      () {
        final border = RoundedRectangleBorderDto.only(
          borderRadius: BorderRadiusDto.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
            bottomLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10),
          ),
          side: BorderSideDto.only(color: Colors.red, width: 2.0),
        ).resolve(MockBuildContext());
        final dto = ShapeBorderDto.value(border);

        expect(dto, isA<RoundedRectangleBorderDto>());
        expect(dto, resolvesTo(border));
      },
    );

    test('value factory creates correct DTO type for CircleBorder', () {
      const border = CircleBorder(
        side: BorderSide(color: Colors.blue, width: 1.5),
      );
      final dto = ShapeBorderDto.value(border);

      expect(dto, isA<CircleBorderDto>());
      expect(dto, resolvesTo(border));
    });

    test('maybeValue returns null for null input', () {
      final dto = ShapeBorderDto.maybeValue(null);
      expect(dto, isNull);
    });

    test('maybeValue returns DTO for non-null input', () {
      const border = StadiumBorder();
      final dto = ShapeBorderDto.maybeValue(border);

      expect(dto, isA<StadiumBorderDto>());
      expect(dto, resolvesTo(border));
    });
  });
}
