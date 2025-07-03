import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('RoundedRectangleBorderDto', () {
    test('merge should combine two RoundedRectangleBorderDtos correctly', () {
      const original = RoundedRectangleBorderDto(
        borderRadius: BorderRadiusDto(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(10),
        ),
        side: BorderSideDto(color: ColorDto(Colors.red), width: 1.0),
      );
      final merged = original.merge(
        const RoundedRectangleBorderDto(
          borderRadius: BorderRadiusDto(
            topLeft: Radius.circular(25),
          ),
          side: BorderSideDto(color: ColorDto(Colors.blue), width: 2.0),
        ),
      );

      expect(merged.borderRadius!.topLeft, const Radius.circular(25));
      expect(merged.borderRadius!.topRight, const Radius.circular(20));
      expect(merged.borderRadius!.bottomLeft, const Radius.circular(5));
      expect(merged.borderRadius!.bottomRight, const Radius.circular(10));

      expect(merged.side!.color, const ColorDto(Colors.blue));
      expect(merged.side!.width, 2.0);
    });

    test(
      'resolve should create a RoundedRectangleBorder with the correct values',
      () {
        const dto = RoundedRectangleBorderDto(
          borderRadius: BorderRadiusDto(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(10),
          ),
          side: BorderSideDto(color: ColorDto(Colors.red), width: 1.0),
        );

        final roundedRectangleBorder = dto.resolve(EmptyMixData);

        final borderRadius =
            roundedRectangleBorder.borderRadius as BorderRadius;

        expect(borderRadius.topLeft, const Radius.circular(15));
        expect(borderRadius.topRight, const Radius.circular(20));
        expect(borderRadius.bottomLeft, const Radius.circular(5));
        expect(borderRadius.bottomRight, const Radius.circular(10));

        expect(roundedRectangleBorder.side.color, Colors.red);
        expect(roundedRectangleBorder.side.width, 1.0);
      },
    );
  });

  // CircleBorderDto
  group('CircleBorderDto', () {
    test('merge should combine two CircleBorderDtos correctly', () {
      const original = CircleBorderDto(
        side: BorderSideDto(color: ColorDto(Colors.red), width: 1.0),
        eccentricity: 0.5,
      );
      final merged = original.merge(
        const CircleBorderDto(
          side: BorderSideDto(color: ColorDto(Colors.blue), width: 2.0),
          eccentricity: 0.75,
        ),
      );

      expect(merged.eccentricity, 0.75);
      expect(merged.side!.color, const ColorDto(Colors.blue));
      expect(merged.side!.width, 2.0);
    });

    test('resolve should create a CircleBorder with the correct values', () {
      const dto = CircleBorderDto(
        side: BorderSideDto(color: ColorDto(Colors.red), width: 1.0),
        eccentricity: 0.5,
      );

      final circleBorder = dto.resolve(EmptyMixData);

      expect(circleBorder.eccentricity, 0.5);
      expect(circleBorder.side.color, Colors.red);
      expect(circleBorder.side.width, 1.0);
    });
  });

  // BeveledRectangleBorderDto
  group('BeveledRectangleBorderDto', () {
    test('merge should combine two BeveledRectangleBorderDtos correctly', () {
      const original = BeveledRectangleBorderDto(
        borderRadius: BorderRadiusDto(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(10),
        ),
        side: BorderSideDto(color: ColorDto(Colors.red), width: 1.0),
      );
      final merged = original.merge(
        const BeveledRectangleBorderDto(
          borderRadius: BorderRadiusDto(
            topLeft: Radius.circular(25),
          ),
          side: BorderSideDto(color: ColorDto(Colors.blue), width: 2.0),
        ),
      );

      expect(merged.borderRadius!.topLeft, const Radius.circular(25));
      expect(merged.borderRadius!.topRight, const Radius.circular(20));
      expect(merged.borderRadius!.bottomLeft, const Radius.circular(5));
      expect(merged.borderRadius!.bottomRight, const Radius.circular(10));

      expect(merged.side!.color, const ColorDto(Colors.blue));
      expect(merged.side!.width, 2.0);
    });

    test(
      'resolve should create a BeveledRectangleBorder with the correct values',
      () {
        const dto = BeveledRectangleBorderDto(
          borderRadius: BorderRadiusDto(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(10),
          ),
          side: BorderSideDto(color: ColorDto(Colors.red), width: 1.0),
        );

        final beveledRectangleBorder = dto.resolve(EmptyMixData);

        final borderRadius =
            beveledRectangleBorder.borderRadius as BorderRadius;

        expect(borderRadius.topLeft, const Radius.circular(15));
        expect(borderRadius.topRight, const Radius.circular(20));
        expect(borderRadius.bottomLeft, const Radius.circular(5));
        expect(borderRadius.bottomRight, const Radius.circular(10));

        expect(beveledRectangleBorder.side.color, Colors.red);
        expect(beveledRectangleBorder.side.width, 1.0);
      },
    );
  });

  // StadiumBorderDto
  group('StadiumBorderDto', () {
    test('merge should combine two StadiumBorderDtos correctly', () {
      const original = StadiumBorderDto(
        side: BorderSideDto(color: ColorDto(Colors.red), width: 1.0),
      );
      final merged = original.merge(
        const StadiumBorderDto(
          side: BorderSideDto(color: ColorDto(Colors.blue), width: 2.0),
        ),
      );

      expect(merged.side!.color, const ColorDto(Colors.blue));
      expect(merged.side!.width, 2.0);
    });

    test('resolve should create a StadiumBorder with the correct values', () {
      const dto = StadiumBorderDto(
        side: BorderSideDto(color: ColorDto(Colors.red), width: 1.0),
      );

      final stadiumBorder = dto.resolve(EmptyMixData);

      expect(stadiumBorder.side.color, Colors.red);
      expect(stadiumBorder.side.width, 1.0);
    });
  });

  // ContinuousRectangleBorderDto
  group('ContinuousRectangleBorderDto', () {
    test(
      'merge should combine two ContinuousRectangleBorderDtos correctly',
      () {
        const original = ContinuousRectangleBorderDto(
          borderRadius: BorderRadiusDto(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(10),
          ),
          side: BorderSideDto(color: ColorDto(Colors.red), width: 1.0),
        );
        final merged = original.merge(
          const ContinuousRectangleBorderDto(
            borderRadius: BorderRadiusDto(
              topLeft: Radius.circular(25),
            ),
            side: BorderSideDto(color: ColorDto(Colors.blue), width: 2.0),
          ),
        );

        final borderRadius = merged.borderRadius as BorderRadiusDto;

        expect(borderRadius.topLeft, const Radius.circular(25));
        expect(borderRadius.topRight, const Radius.circular(20));
        expect(borderRadius.bottomLeft, const Radius.circular(5));
        expect(borderRadius.bottomRight, const Radius.circular(10));

        expect(merged.side!.color, const ColorDto(Colors.blue));
        expect(merged.side!.width, 2.0);
      },
    );

    test(
      'resolve should create a ContinuousRectangleBorder with the correct values',
      () {
        const dto = ContinuousRectangleBorderDto(
          borderRadius: BorderRadiusDto(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(10),
          ),
          side: BorderSideDto(color: ColorDto(Colors.red), width: 1.0),
        );

        final continuousRectangleBorder = dto.resolve(EmptyMixData);

        final borderRadius =
            continuousRectangleBorder.borderRadius as BorderRadius;

        expect(borderRadius.topLeft, const Radius.circular(15));
        expect(borderRadius.topRight, const Radius.circular(20));
        expect(borderRadius.bottomLeft, const Radius.circular(5));
        expect(borderRadius.bottomRight, const Radius.circular(10));

        expect(continuousRectangleBorder.side.color, Colors.red);
        expect(continuousRectangleBorder.side.width, 1.0);
      },
    );
  });

  // Tests for ShapeBorderDto
  group('ShapeBorderDto', () {
    test(
        'maybeFrom factory method should create the correct ShapeBorderDto subclass or return null',
        () {
      const roundedRectangleBorder = RoundedRectangleBorder();
      const circleBorder = CircleBorder();
      const beveledRectangleBorder = BeveledRectangleBorder();
      const continuousRectangleBorder = ContinuousRectangleBorder();
      const stadiumBorder = StadiumBorder();

      expect(roundedRectangleBorder.toDto(), isA<RoundedRectangleBorderDto>());
      expect(circleBorder.toDto(), isA<CircleBorderDto>());
      expect(beveledRectangleBorder.toDto(), isA<BeveledRectangleBorderDto>());
      expect(continuousRectangleBorder.toDto(),
          isA<ContinuousRectangleBorderDto>());
      expect(stadiumBorder.toDto(), isA<StadiumBorderDto>());
    });
  });

  // Tests for OutlinedBorderDto
  group('OutlinedBorderDto', () {
    test(
        'from factory method should create the correct OutlinedBorderDto subclass',
        () {
      const roundedRectangleBorder = RoundedRectangleBorder();
      const circleBorder = CircleBorder();
      const beveledRectangleBorder = BeveledRectangleBorder();
      const continuousRectangleBorder = ContinuousRectangleBorder();
      const stadiumBorder = StadiumBorder();

      expect(roundedRectangleBorder.toDto(), isA<RoundedRectangleBorderDto>());
      expect(circleBorder.toDto(), isA<CircleBorderDto>());
      expect(beveledRectangleBorder.toDto(), isA<BeveledRectangleBorderDto>());
      expect(continuousRectangleBorder.toDto(),
          isA<ContinuousRectangleBorderDto>());
      expect(stadiumBorder.toDto(), isA<StadiumBorderDto>());
    });

    test('resolve method should create the correct OutlinedBorder instance',
        () {
      const roundedRectangleBorderDto = RoundedRectangleBorderDto();
      const circleBorderDto = CircleBorderDto();
      const beveledRectangleBorderDto = BeveledRectangleBorderDto();
      const continuousRectangleBorderDto = ContinuousRectangleBorderDto();
      const stadiumBorderDto = StadiumBorderDto();

      expect(roundedRectangleBorderDto.resolve(EmptyMixData),
          isA<RoundedRectangleBorder>());
      expect(circleBorderDto.resolve(EmptyMixData), isA<CircleBorder>());
      expect(beveledRectangleBorderDto.resolve(EmptyMixData),
          isA<BeveledRectangleBorder>());
      expect(continuousRectangleBorderDto.resolve(EmptyMixData),
          isA<ContinuousRectangleBorder>());
      expect(stadiumBorderDto.resolve(EmptyMixData), isA<StadiumBorder>());
    });
  });

  // Additional tests for RoundedRectangleBorderDto
  group('RoundedRectangleBorderDto', () {
    test(
        'from factory method should create RoundedRectangleBorderDto from RoundedRectangleBorder',
        () {
      final roundedRectangleBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.red),
      );

      final roundedRectangleBorderDto = roundedRectangleBorder.toDto();

      expect(roundedRectangleBorderDto.borderRadius,
          equals(BorderRadius.circular(10).toDto()));
      expect(roundedRectangleBorderDto.side,
          equals(const BorderSide(color: Colors.red).toDto()));
    });

    test('merge method should handle null values correctly', () {
      final roundedRectangleBorderDto = RoundedRectangleBorderDto(
        borderRadius: BorderRadius.circular(10).toDto(),
        side: const BorderSide(color: Colors.red).toDto(),
      );

      final mergedDto = roundedRectangleBorderDto.merge(null);

      expect(mergedDto, equals(roundedRectangleBorderDto));
    });
  });

  // Additional tests for CircleBorderDto
  group('CircleBorderDto', () {
    test('from factory method should create CircleBorderDto from CircleBorder',
        () {
      const circleBorder = CircleBorder(
        side: BorderSide(color: Colors.blue),
        eccentricity: 0.8,
      );

      final circleBorderDto = circleBorder.toDto();

      expect(circleBorderDto.side,
          equals(const BorderSide(color: Colors.blue).toDto()));
      expect(circleBorderDto.eccentricity, equals(0.8));
    });

    test('merge method should handle null values correctly', () {
      final circleBorderDto = CircleBorderDto(
        side: const BorderSide(color: Colors.blue).toDto(),
        eccentricity: 0.8,
      );

      final mergedDto = circleBorderDto.merge(null);

      expect(mergedDto, equals(circleBorderDto));
    });
  });

  // Additional tests for BeveledRectangleBorderDto
  group('BeveledRectangleBorderDto', () {
    test(
        'from factory method should create BeveledRectangleBorderDto from BeveledRectangleBorder',
        () {
      final beveledRectangleBorder = BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.green),
      );

      final beveledRectangleBorderDto = beveledRectangleBorder.toDto();

      expect(beveledRectangleBorderDto.borderRadius,
          equals(BorderRadius.circular(10).toDto()));
      expect(beveledRectangleBorderDto.side,
          equals(const BorderSide(color: Colors.green).toDto()));
    });

    test('merge method should handle null values correctly', () {
      final beveledRectangleBorderDto = BeveledRectangleBorderDto(
        borderRadius: BorderRadius.circular(10).toDto(),
        side: const BorderSide(color: Colors.green).toDto(),
      );

      final mergedDto = beveledRectangleBorderDto.merge(null);

      expect(mergedDto, equals(beveledRectangleBorderDto));
    });
  });

  // Additional tests for ContinuousRectangleBorderDto
  group('ContinuousRectangleBorderDto', () {
    test(
        'from factory method should create ContinuousRectangleBorderDto from ContinuousRectangleBorder',
        () {
      final continuousRectangleBorder = ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.orange),
      );

      final continuousRectangleBorderDto = continuousRectangleBorder.toDto();

      expect(continuousRectangleBorderDto.borderRadius,
          equals(BorderRadius.circular(10).toDto()));
      expect(continuousRectangleBorderDto.side,
          equals(const BorderSide(color: Colors.orange).toDto()));
    });

    test('merge method should handle null values correctly', () {
      final continuousRectangleBorderDto = ContinuousRectangleBorderDto(
        borderRadius: BorderRadius.circular(10).toDto(),
        side: const BorderSide(color: Colors.orange).toDto(),
      );

      final mergedDto = continuousRectangleBorderDto.merge(null);

      expect(mergedDto, equals(continuousRectangleBorderDto));
    });
  });

  // Additional tests for StadiumBorderDto
  group('StadiumBorderDto', () {
    test(
        'from factory method should create StadiumBorderDto from StadiumBorder',
        () {
      const stadiumBorder = StadiumBorder(
        side: BorderSide(color: Colors.purple),
      );

      final stadiumBorderDto = stadiumBorder.toDto();

      expect(stadiumBorderDto.side,
          equals(const BorderSide(color: Colors.purple).toDto()));
    });

    test('merge method should handle null values correctly', () {
      final stadiumBorderDto = StadiumBorderDto(
        side: const BorderSide(color: Colors.purple).toDto(),
      );

      final mergedDto = stadiumBorderDto.merge(null);

      expect(mergedDto, equals(stadiumBorderDto));
    });
  });

  // Additional tests for StarBorderDto
  group('StarBorderDto', () {
    test('from factory method should create StarBorderDto from StarBorder', () {
      const starBorder = StarBorder(
        side: BorderSide(color: Colors.teal),
        points: 5,
        innerRadiusRatio: 0.5,
        pointRounding: 0.2,
        valleyRounding: 0.1,
        rotation: 0.3,
        squash: 0.4,
      );

      final starBorderDto = starBorder.toDto();

      expect(starBorderDto.side,
          equals(const BorderSide(color: Colors.teal).toDto()));
      expect(starBorderDto.points, equals(5));
      expect(starBorderDto.innerRadiusRatio, equals(0.5));
      expect(starBorderDto.pointRounding, equals(0.2));
      expect(starBorderDto.valleyRounding, equals(0.1));
      expect(starBorderDto.rotation, equals(0.3));
      expect(starBorderDto.squash, equals(0.4));
    });

    test('merge method should handle null values correctly', () {
      final starBorderDto = StarBorderDto(
        side: const BorderSide(color: Colors.teal).toDto(),
        points: 5,
        innerRadiusRatio: 0.5,
        pointRounding: 0.2,
        valleyRounding: 0.1,
        rotation: 0.3,
        squash: 0.4,
      );

      final mergedDto = starBorderDto.merge(null);

      expect(mergedDto, equals(starBorderDto));
    });
  });

  // Additional tests for LinearBorderDto
  group('LinearBorderDto', () {
    test('from factory method should create LinearBorderDto from LinearBorder',
        () {
      const linearBorder = LinearBorder(
        side: BorderSide(color: Colors.brown),
        start: LinearBorderEdge(size: 0.1, alignment: 0.1),
        end: LinearBorderEdge(size: 0.2, alignment: 0.2),
        top: LinearBorderEdge(size: 0.3, alignment: 0.3),
        bottom: LinearBorderEdge(size: 0.4, alignment: 0.4),
      );

      final linearBorderDto = linearBorder.toDto();

      expect(linearBorderDto.side,
          equals(const BorderSide(color: Colors.brown).toDto()));
      expect(linearBorderDto.start,
          equals(const LinearBorderEdge(size: 0.1, alignment: 0.1).toDto()));
      expect(linearBorderDto.end,
          equals(const LinearBorderEdge(size: 0.2, alignment: 0.2).toDto()));
      expect(linearBorderDto.top,
          equals(const LinearBorderEdge(size: 0.3, alignment: 0.3).toDto()));
      expect(linearBorderDto.bottom,
          equals(const LinearBorderEdge(size: 0.4, alignment: 0.4).toDto()));
    });

    test('merge method should handle null values correctly', () {
      final linearBorderDto = LinearBorderDto(
        side: const BorderSide(color: Colors.brown).toDto(),
        start: const LinearBorderEdge(size: 0.1, alignment: 0.1).toDto(),
        end: const LinearBorderEdge(size: 0.2, alignment: 0.2).toDto(),
        top: const LinearBorderEdge(size: 0.3, alignment: 0.3).toDto(),
        bottom: const LinearBorderEdge(size: 0.4, alignment: 0.4).toDto(),
      );

      final mergedDto = linearBorderDto.merge(null);

      expect(mergedDto, equals(linearBorderDto));
    });

    // Additional tests for LinearBorderEdgeDto
    group('LinearBorderEdgeDto', () {
      test(
          'from factory method should create LinearBorderEdgeDto from LinearBorderEdge',
          () {
        const linearBorderEdge = LinearBorderEdge(size: 1.0, alignment: 0.1);

        final linearBorderEdgeDto = linearBorderEdge.toDto();

        expect(linearBorderEdgeDto.size, equals(1.0));
        expect(linearBorderEdgeDto.alignment, equals(0.1));
      });

      test('merge method should handle null values correctly', () {
        const linearBorderEdgeDto =
            LinearBorderEdgeDto(size: 1.0, alignment: 0.1);

        final mergedDto = linearBorderEdgeDto.merge(null);

        expect(mergedDto, equals(linearBorderEdgeDto));
      });

      // test equality
      test('== should return true if two LinearBorderEdgeDto are equal', () {
        const linearBorderEdgeDto1 =
            LinearBorderEdgeDto(size: 1.0, alignment: 0.1);
        const linearBorderEdgeDto2 =
            LinearBorderEdgeDto(size: 1.0, alignment: 0.1);

        expect(linearBorderEdgeDto1, equals(linearBorderEdgeDto2));
      });
    });

    // Additional tests for ShapeBorderUtility
    group('ShapeBorderUtility', () {
      test('should create utility instances for each shape border type', () {
        final shapeBorderUtility = ShapeBorderUtility(UtilityTestAttribute.new);

        expect(shapeBorderUtility.roundedRectangle,
            isA<RoundedRectangleBorderUtility>());
        expect(shapeBorderUtility.circle, isA<CircleBorderUtility>());
        expect(shapeBorderUtility.beveledRectangle,
            isA<BeveledRectangleBorderUtility>());
        expect(shapeBorderUtility.stadium, isA<StadiumBorderUtility>());
        expect(shapeBorderUtility.continuousRectangle,
            isA<ContinuousRectangleBorderUtility>());
      });
    });
  });

  group('ShapeBorderDto.tryToMerge', () {
    test('should return null when both inputs are null', () {
      final result = ShapeBorderDto.tryToMerge(null, null);
      expect(result, isNull);
    });

    test('should return the non-null input when one input is null', () {
      const dto = RoundedRectangleBorderDto();
      expect(ShapeBorderDto.tryToMerge(dto, null), equals(dto));
      expect(ShapeBorderDto.tryToMerge(null, dto), equals(dto));
    });

    test(
        'should return the second input when both inputs are not OutlinedBorderDto',
        () {
      const dto1 = CircleBorderDto();
      const dto2 = StarBorderDto();
      expect(ShapeBorderDto.tryToMerge(dto1, dto2), equals(dto2));
    });

    test(
        'should call OutlinedBorderDto.tryToMerge when both inputs are OutlinedBorderDto',
        () {
      const dto1 = RoundedRectangleBorderDto(
          borderRadius: BorderRadiusDto(topLeft: Radius.circular(10)));
      final dto2 = RoundedRectangleBorderDto(
          side: BorderSideDto(color: Colors.red.toDto()));
      final expectedResult = RoundedRectangleBorderDto(
        borderRadius: const BorderRadiusDto(topLeft: Radius.circular(10)),
        side: BorderSideDto(color: Colors.red.toDto()),
      );
      expect(ShapeBorderDto.tryToMerge(dto1, dto2), equals(expectedResult));
    });
  });

  group('OutlinedBorderDto.tryToMerge', () {
    test('should return null when both inputs are null', () {
      final result = OutlinedBorderDto.tryToMerge(null, null);
      expect(result, isNull);
    });

    test('should return the non-null input when one input is null', () {
      const dto = RoundedRectangleBorderDto();
      expect(OutlinedBorderDto.tryToMerge(dto, null), equals(dto));
      expect(OutlinedBorderDto.tryToMerge(null, dto), equals(dto));
    });

    test('should call _exhaustiveMerge when both inputs are not null', () {
      const dto1 = RoundedRectangleBorderDto(
          borderRadius: BorderRadiusDto(topLeft: Radius.circular(10)));
      final dto2 = RoundedRectangleBorderDto(
          side: BorderSideDto(color: Colors.red.toDto()));
      final expectedResult = RoundedRectangleBorderDto(
        borderRadius: const BorderRadiusDto(topLeft: Radius.circular(10)),
        side: BorderSideDto(color: Colors.red.toDto()),
      );
      expect(OutlinedBorderDto.tryToMerge(dto1, dto2), equals(expectedResult));
    });
  });
  group('RoundedRectangleBorderDto', () {
    test(
        'adapt method should return the same instance if input is RoundedRectangleBorderDto',
        () {
      const dtoA = RoundedRectangleBorderDto(
        borderRadius: BorderRadiusDto(topLeft: Radius.circular(10)),
        side: BorderSideDto(width: 2.0),
      );
      const dtoB = RoundedRectangleBorderDto(
        borderRadius: BorderRadiusDto(topLeft: Radius.circular(20)),
        side: BorderSideDto(width: 4.0),
      );
      expect(dtoA.adapt(dtoB), equals(dtoB));
    });

    test(
        'adapt method should create a new instance from other OutlinedBorderDto',
        () {
      const dtoA = RoundedRectangleBorderDto();
      const dtoB = CircleBorderDto(side: BorderSideDto(width: 3.0));
      final result = dtoA.adapt(dtoB);
      expect(result, isA<RoundedRectangleBorderDto>());
      expect(result.side, equals(dtoB.side));
      expect(result.borderRadius, isNull);
    });
  });

  group('BeveledRectangleBorderDto', () {
    test(
        'adapt method should return the same instance if input is BeveledRectangleBorderDto',
        () {
      const dtoA = BeveledRectangleBorderDto(
        borderRadius: BorderRadiusDto(topLeft: Radius.circular(5)),
        side: BorderSideDto(width: 1.5),
      );
      const dtoB = BeveledRectangleBorderDto(
        borderRadius: BorderRadiusDto(topLeft: Radius.circular(5)),
        side: BorderSideDto(width: 3),
      );
      expect(dtoA.adapt(dtoB), equals(dtoB));
    });

    test(
        'adapt method should create a new instance from other OutlinedBorderDto',
        () {
      const dtoA = BeveledRectangleBorderDto();
      const dtoB = StadiumBorderDto(side: BorderSideDto(width: 2.5));
      final result = dtoA.adapt(dtoB);
      expect(result, isA<BeveledRectangleBorderDto>());
      expect(result.side, equals(dtoB.side));
      expect(result.borderRadius, isNull);
    });
  });

  group('ContinuousRectangleBorderDto', () {
    test(
        'adapt method should return the same instance if input is ContinuousRectangleBorderDto',
        () {
      const dtoA = ContinuousRectangleBorderDto(
        borderRadius: BorderRadiusDto(topLeft: Radius.circular(8)),
        side: BorderSideDto(width: 1.2),
      );
      const dtoB = ContinuousRectangleBorderDto(
        borderRadius: BorderRadiusDto(topLeft: Radius.circular(16)),
        side: BorderSideDto(width: 3),
      );
      expect(dtoA.adapt(dtoB), equals(dtoB));
    });

    test(
        'adapt method should create a new instance from other OutlinedBorderDto',
        () {
      const dtoA = ContinuousRectangleBorderDto();
      const dtoB = RoundedRectangleBorderDto(
        side: BorderSideDto(width: 1.8),
        borderRadius: BorderRadiusDto(
          topLeft: Radius.circular(10),
        ),
      );
      final result = dtoA.adapt(dtoB);
      expect(result, isA<ContinuousRectangleBorderDto>());
      expect(result.side, equals(dtoB.side));
      expect(result.borderRadius, equals(dtoB.borderRadius));
    });
  });

  group('CircleBorderDto', () {
    test(
        'adapt method should return the same instance if input is CircleBorderDto',
        () {
      const dtoA =
          CircleBorderDto(side: BorderSideDto(width: 2.2), eccentricity: 0.5);
      const dtoB =
          CircleBorderDto(side: BorderSideDto(width: 22), eccentricity: 0.7);
      expect(dtoA.adapt(dtoB), equals(dtoB));
    });

    test(
        'adapt method should create a new instance from other OutlinedBorderDto',
        () {
      const dtoA = CircleBorderDto();
      const dtoB = BeveledRectangleBorderDto(side: BorderSideDto(width: 1.7));
      final result = dtoA.adapt(dtoB);
      expect(result, isA<CircleBorderDto>());
      expect(result.side, equals(dtoB.side));
      expect(result.eccentricity, isNull);
    });
  });

  group('StarBorderDto', () {
    test(
        'adapt method should create a new instance from other OutlinedBorderDto',
        () {
      const dtoA = StarBorderDto();
      const dtoB = ContinuousRectangleBorderDto(
        side: BorderSideDto(width: 1.3),
      );

      final result = dtoA.adapt(dtoB);
      expect(result, isA<StarBorderDto>());
      expect(result.side, equals(dtoB.side));
      expect(result.points, isNull);
      expect(result.innerRadiusRatio, isNull);
      expect(result.pointRounding, isNull);
      expect(result.valleyRounding, isNull);
      expect(result.rotation, isNull);
      expect(result.squash, isNull);
    });
  });

  group('LinearBorderDto', () {
    test(
        'adapt method should return the same instance if input is LinearBorderDto',
        () {
      const dtoA = LinearBorderDto(
        side: BorderSideDto(width: 1.9),
        start: LinearBorderEdgeDto(size: 2.0, alignment: 0.5),
      );
      const dtoB = LinearBorderDto(
        side: BorderSideDto(width: 19),
        start: LinearBorderEdgeDto(size: 20, alignment: 0.9),
      );
      expect(dtoA.adapt(dtoB), equals(dtoB));
    });

    test(
        'adapt method should create a new instance from other OutlinedBorderDto',
        () {
      const dtoA = LinearBorderDto();
      const dtoB = StadiumBorderDto(side: BorderSideDto(width: 2.1));
      final result = dtoA.adapt(dtoB);
      expect(result, isA<LinearBorderDto>());
      expect(result.side, equals(dtoB.side));
      expect(result.start, isNull);
      expect(result.end, isNull);
      expect(result.top, isNull);
      expect(result.bottom, isNull);
    });
  });

  group('StadiumBorderDto', () {
    test(
        'adapt method should return the same instance if input is StadiumBorderDto',
        () {
      const dtoA = StadiumBorderDto(side: BorderSideDto(width: 1.6));
      const dtoB = StadiumBorderDto(side: BorderSideDto(width: 16));
      expect(dtoA.adapt(dtoB), equals(dtoB));
    });

    test(
        'adapt method should create a new instance from other OutlinedBorderDto',
        () {
      const dtoA = StadiumBorderDto();
      const dtoB = CircleBorderDto(side: BorderSideDto(width: 2.3));
      final result = dtoA.adapt(dtoB);
      expect(result, isA<StadiumBorderDto>());
      expect(result.side, equals(dtoB.side));
    });
  });
}
