import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('RoundedRectangleBorderDto', () {
    test('merge should combine two RoundedRectangleBorderDtos correctly', () {
      final original = RoundedRectangleBorderDto(
        borderRadius: BorderRadiusDto(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(20),
          bottomLeft: const Radius.circular(5),
          bottomRight: const Radius.circular(10),
        ),
        side: BorderSideDto(color: Colors.red, width: 1.0),
      );
      final merged = original.merge(
        RoundedRectangleBorderDto(
          borderRadius: BorderRadiusDto(topLeft: const Radius.circular(25)),
          side: BorderSideDto(color: Colors.blue, width: 2.0),
        ),
      );

      expect(
        merged.borderRadius!.mixValue?.topLeft,
        resolvesTo(const Radius.circular(25)),
      );
      expect(
        merged.borderRadius!.mixValue?.topRight,
        resolvesTo(const Radius.circular(20)),
      );
      expect(
        merged.borderRadius!.mixValue?.bottomLeft,
        resolvesTo(const Radius.circular(5)),
      );
      expect(
        merged.borderRadius!.mixValue?.bottomRight,
        resolvesTo(const Radius.circular(10)),
      );

      expect(merged.side!.mixValue?.color, resolvesTo(Colors.blue));
      expect(merged.side!.mixValue?.width, resolvesTo(2.0));
    });

    test(
      'resolve should create a RoundedRectangleBorder with the correct values',
      () {
        final dto = RoundedRectangleBorderDto(
          borderRadius: BorderRadiusDto(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(20),
            bottomLeft: const Radius.circular(5),
            bottomRight: const Radius.circular(10),
          ),
          side: BorderSideDto(color: Colors.red, width: 1.0),
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
      },
    );
  });

  // CircleBorderDto
  group('CircleBorderDto', () {
    test('merge should combine two CircleBorderDtos correctly', () {
      final original = CircleBorderDto(
        side: BorderSideDto(color: Colors.red, width: 1.0),
        eccentricity: 0.5,
      );
      final merged = original.merge(
        CircleBorderDto(
          side: BorderSideDto(color: Colors.blue, width: 2.0),
          eccentricity: 0.75,
        ),
      );

      expect(merged.eccentricity, resolvesTo(0.75));
      expect(merged.side!.mixValue?.color, resolvesTo(Colors.blue));
      expect(merged.side!.mixValue?.width, resolvesTo(2.0));
    });

    test('resolve should create a CircleBorder with the correct values', () {
      final dto = CircleBorderDto(
        side: BorderSideDto(color: Colors.red, width: 1.0),
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
  });

  // BeveledRectangleBorderDto
  group('BeveledRectangleBorderDto', () {
    test('merge should combine two BeveledRectangleBorderDtos correctly', () {
      final original = BeveledRectangleBorderDto(
        borderRadius: BorderRadiusDto(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(20),
          bottomLeft: const Radius.circular(5),
          bottomRight: const Radius.circular(10),
        ),
        side: BorderSideDto(color: Colors.red, width: 1.0),
      );
      final merged = original.merge(
        BeveledRectangleBorderDto(
          borderRadius: BorderRadiusDto(topLeft: const Radius.circular(25)),
          side: BorderSideDto(color: Colors.blue, width: 2.0),
        ),
      );

      expect(
        merged.borderRadius!.mixValue?.topLeft,
        resolvesTo(const Radius.circular(25)),
      );
      expect(
        merged.borderRadius!.mixValue?.topRight,
        resolvesTo(const Radius.circular(20)),
      );
      expect(
        merged.borderRadius!.mixValue?.bottomLeft,
        resolvesTo(const Radius.circular(5)),
      );
      expect(
        merged.borderRadius!.mixValue?.bottomRight,
        resolvesTo(const Radius.circular(10)),
      );

      expect(merged.side!.mixValue?.color, resolvesTo(Colors.blue));
      expect(merged.side!.mixValue?.width, resolvesTo(2.0));
    });

    test(
      'resolve should create a BeveledRectangleBorder with the correct values',
      () {
        final dto = BeveledRectangleBorderDto(
          borderRadius: BorderRadiusDto(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(20),
            bottomLeft: const Radius.circular(5),
            bottomRight: const Radius.circular(10),
          ),
          side: BorderSideDto(color: Colors.red, width: 1.0),
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
      },
    );
  });

  // StadiumBorderDto
  group('StadiumBorderDto', () {
    test('merge should combine two StadiumBorderDtos correctly', () {
      final original = StadiumBorderDto(
        side: BorderSideDto(color: Colors.red, width: 1.0),
      );
      final merged = original.merge(
        StadiumBorderDto(side: BorderSideDto(color: Colors.blue, width: 2.0)),
      );

      expect(merged.side!.mixValue?.color, resolvesTo(Colors.blue));
      expect(merged.side!.mixValue?.width, resolvesTo(2.0));
    });

    test('resolve should create a StadiumBorder with the correct values', () {
      final dto = StadiumBorderDto(
        side: BorderSideDto(color: Colors.red, width: 1.0),
      );

      expect(
        dto,
        resolvesTo(
          const StadiumBorder(side: BorderSide(color: Colors.red, width: 1.0)),
        ),
      );
    });
  });

  // ContinuousRectangleBorderDto
  group('ContinuousRectangleBorderDto', () {
    test(
      'merge should combine two ContinuousRectangleBorderDtos correctly',
      () {
        final original = ContinuousRectangleBorderDto(
          borderRadius: BorderRadiusDto(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(20),
            bottomLeft: const Radius.circular(5),
            bottomRight: const Radius.circular(10),
          ),
          side: BorderSideDto(color: Colors.red, width: 1.0),
        );
        final merged = original.merge(
          ContinuousRectangleBorderDto(
            borderRadius: BorderRadiusDto(topLeft: const Radius.circular(25)),
            side: BorderSideDto(color: Colors.blue, width: 2.0),
          ),
        );

        expect(
          merged.borderRadius!.mixValue?.topLeft,
          resolvesTo(const Radius.circular(25)),
        );
        expect(
          merged.borderRadius!.mixValue?.topRight,
          resolvesTo(const Radius.circular(20)),
        );
        expect(
          merged.borderRadius!.mixValue?.bottomLeft,
          resolvesTo(const Radius.circular(5)),
        );
        expect(
          merged.borderRadius!.mixValue?.bottomRight,
          resolvesTo(const Radius.circular(10)),
        );

        expect(merged.side!.mixValue?.color, resolvesTo(Colors.blue));
        expect(merged.side!.mixValue?.width, resolvesTo(2.0));
      },
    );

    test(
      'resolve should create a ContinuousRectangleBorder with the correct values',
      () {
        final dto = ContinuousRectangleBorderDto(
          borderRadius: BorderRadiusDto(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(20),
            bottomLeft: const Radius.circular(5),
            bottomRight: const Radius.circular(10),
          ),
          side: BorderSideDto(color: Colors.red, width: 1.0),
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

        expect(
          RoundedRectangleBorderDto.value(roundedRectangleBorder),
          isA<RoundedRectangleBorderDto>(),
        );
        expect(CircleBorderDto.value(circleBorder), isA<CircleBorderDto>());
        expect(
          BeveledRectangleBorderDto.value(beveledRectangleBorder),
          isA<BeveledRectangleBorderDto>(),
        );
        expect(
          ContinuousRectangleBorderDto.value(continuousRectangleBorder),
          isA<ContinuousRectangleBorderDto>(),
        );
        expect(StadiumBorderDto.value(stadiumBorder), isA<StadiumBorderDto>());
      },
    );
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

        expect(
          RoundedRectangleBorderDto.value(roundedRectangleBorder),
          isA<RoundedRectangleBorderDto>(),
        );
        expect(CircleBorderDto.value(circleBorder), isA<CircleBorderDto>());
        expect(
          BeveledRectangleBorderDto.value(beveledRectangleBorder),
          isA<BeveledRectangleBorderDto>(),
        );
        expect(
          ContinuousRectangleBorderDto.value(continuousRectangleBorder),
          isA<ContinuousRectangleBorderDto>(),
        );
        expect(StadiumBorderDto.value(stadiumBorder), isA<StadiumBorderDto>());
      },
    );

    test(
      'resolve method should create the correct OutlinedBorder instance',
      () {
        final roundedRectangleBorderDto = RoundedRectangleBorderDto();
        final circleBorderDto = CircleBorderDto();
        final beveledRectangleBorderDto = BeveledRectangleBorderDto();
        final continuousRectangleBorderDto = ContinuousRectangleBorderDto();
        final stadiumBorderDto = StadiumBorderDto();

        expect(
          roundedRectangleBorderDto,
          resolvesTo(isA<RoundedRectangleBorder>()),
        );
        expect(circleBorderDto, resolvesTo(isA<CircleBorder>()));
        expect(
          beveledRectangleBorderDto,
          resolvesTo(isA<BeveledRectangleBorder>()),
        );
        expect(
          continuousRectangleBorderDto,
          resolvesTo(isA<ContinuousRectangleBorder>()),
        );
        expect(stadiumBorderDto, resolvesTo(isA<StadiumBorder>()));
      },
    );
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

        final roundedRectangleBorderDto = RoundedRectangleBorderDto.value(
          roundedRectangleBorder,
        );

        expect(
          roundedRectangleBorderDto.borderRadius!.mixValue,
          equals(BorderRadiusDto.value(BorderRadius.circular(10))),
        );
        expect(
          roundedRectangleBorderDto.side!.mixValue,
          equals(BorderSideDto.value(const BorderSide(color: Colors.red))),
        );
      },
    );

    test('merge method should handle null values correctly', () {
      final roundedRectangleBorderDto = RoundedRectangleBorderDto(
        borderRadius: BorderRadiusDto.value(BorderRadius.circular(10)),
        side: BorderSideDto.value(const BorderSide(color: Colors.red)),
      );

      final mergedDto = roundedRectangleBorderDto.merge(null);

      expect(mergedDto, equals(roundedRectangleBorderDto));
    });
  });

  // Additional tests for CircleBorderDto
  group('CircleBorderDto', () {
    test(
      'from factory method should create CircleBorderDto from CircleBorder',
      () {
        const circleBorder = CircleBorder(
          side: BorderSide(color: Colors.blue),
          eccentricity: 0.8,
        );

        final circleBorderDto = CircleBorderDto.value(circleBorder);

        expect(
          circleBorderDto.side!.mixValue,
          equals(BorderSideDto.value(const BorderSide(color: Colors.blue))),
        );
        expect(circleBorderDto.eccentricity, resolvesTo(0.8));
      },
    );

    test('merge method should handle null values correctly', () {
      final circleBorderDto = CircleBorderDto(
        side: BorderSideDto.value(const BorderSide(color: Colors.blue)),
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

        final beveledRectangleBorderDto = BeveledRectangleBorderDto.value(
          beveledRectangleBorder,
        );

        expect(
          beveledRectangleBorderDto.borderRadius!.mixValue,
          equals(BorderRadiusDto.value(BorderRadius.circular(10))),
        );
        expect(
          beveledRectangleBorderDto.side!.mixValue,
          equals(BorderSideDto.value(const BorderSide(color: Colors.green))),
        );
      },
    );

    test('merge method should handle null values correctly', () {
      final beveledRectangleBorderDto = BeveledRectangleBorderDto(
        borderRadius: BorderRadiusDto.value(BorderRadius.circular(10)),
        side: BorderSideDto.value(const BorderSide(color: Colors.green)),
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

        final continuousRectangleBorderDto = ContinuousRectangleBorderDto.value(
          continuousRectangleBorder,
        );

        expect(
          continuousRectangleBorderDto.borderRadius!.mixValue,
          equals(BorderRadiusDto.value(BorderRadius.circular(10))),
        );
        expect(
          continuousRectangleBorderDto.side!.mixValue,
          equals(BorderSideDto.value(const BorderSide(color: Colors.orange))),
        );
      },
    );

    test('merge method should handle null values correctly', () {
      final continuousRectangleBorderDto = ContinuousRectangleBorderDto(
        borderRadius: BorderRadiusDto.value(BorderRadius.circular(10)),
        side: BorderSideDto.value(const BorderSide(color: Colors.orange)),
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

        final stadiumBorderDto = StadiumBorderDto.value(stadiumBorder);

        expect(
          stadiumBorderDto.side!.mixValue,
          equals(BorderSideDto.value(const BorderSide(color: Colors.purple))),
        );
      },
    );

    test('merge method should handle null values correctly', () {
      final stadiumBorderDto = StadiumBorderDto(
        side: BorderSideDto.value(const BorderSide(color: Colors.purple)),
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

      final starBorderDto = StarBorderDto.value(starBorder);

      expect(
        starBorderDto.side!.mixValue,
        equals(BorderSideDto.value(const BorderSide(color: Colors.teal))),
      );
      expect(starBorderDto.points, resolvesTo(5.0));
      expect(starBorderDto.innerRadiusRatio, resolvesTo(0.5));
      expect(starBorderDto.pointRounding, resolvesTo(0.2));
      expect(starBorderDto.valleyRounding, resolvesTo(0.1));
      expect(starBorderDto.rotation, resolvesTo(0.3));
      expect(starBorderDto.squash, resolvesTo(0.4));
    });

    test('merge method should handle null values correctly', () {
      final starBorderDto = StarBorderDto(
        side: BorderSideDto(color: Colors.teal),
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
    test(
      'from factory method should create LinearBorderDto from LinearBorder',
      () {
        const linearBorder = LinearBorder(
          side: BorderSide(color: Colors.brown),
          start: LinearBorderEdge(size: 0.1, alignment: 0.1),
          end: LinearBorderEdge(size: 0.2, alignment: 0.2),
          top: LinearBorderEdge(size: 0.3, alignment: 0.3),
          bottom: LinearBorderEdge(size: 0.4, alignment: 0.4),
        );

        final linearBorderDto = LinearBorderDto.value(linearBorder);

        expect(
          linearBorderDto.side!.mixValue,
          equals(BorderSideDto.value(const BorderSide(color: Colors.brown))),
        );
        expect(
          linearBorderDto.start!.mixValue,
          equals(
            LinearBorderEdgeDto.value(
              const LinearBorderEdge(size: 0.1, alignment: 0.1),
            ),
          ),
        );
        expect(
          linearBorderDto.end!.mixValue,
          equals(
            LinearBorderEdgeDto.value(
              const LinearBorderEdge(size: 0.2, alignment: 0.2),
            ),
          ),
        );
        expect(
          linearBorderDto.top!.mixValue,
          equals(
            LinearBorderEdgeDto.value(
              const LinearBorderEdge(size: 0.3, alignment: 0.3),
            ),
          ),
        );
        expect(
          linearBorderDto.bottom!.mixValue,
          equals(
            LinearBorderEdgeDto.value(
              const LinearBorderEdge(size: 0.4, alignment: 0.4),
            ),
          ),
        );
      },
    );

    test('merge method should handle null values correctly', () {
      final linearBorderDto = LinearBorderDto(
        side: BorderSideDto.value(const BorderSide(color: Colors.brown)),
        start: LinearBorderEdgeDto.value(
          const LinearBorderEdge(size: 0.1, alignment: 0.1),
        ),
        end: LinearBorderEdgeDto.value(
          const LinearBorderEdge(size: 0.2, alignment: 0.2),
        ),
        top: LinearBorderEdgeDto.value(
          const LinearBorderEdge(size: 0.3, alignment: 0.3),
        ),
        bottom: LinearBorderEdgeDto.value(
          const LinearBorderEdge(size: 0.4, alignment: 0.4),
        ),
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

          final linearBorderEdgeDto = LinearBorderEdgeDto.value(
            linearBorderEdge,
          );

          expect(linearBorderEdgeDto.size, resolvesTo(1.0));
          expect(linearBorderEdgeDto.alignment, resolvesTo(0.1));
        },
      );

      test('merge method should handle null values correctly', () {
        final linearBorderEdgeDto = LinearBorderEdgeDto(
          size: 1.0,
          alignment: 0.1,
        );

        final mergedDto = linearBorderEdgeDto.merge(null);

        expect(mergedDto, equals(linearBorderEdgeDto));
      });

      // test equality
      test('== should return true if two LinearBorderEdgeDto are equal', () {
        final linearBorderEdgeDto1 = LinearBorderEdgeDto(
          size: 1.0,
          alignment: 0.1,
        );
        final linearBorderEdgeDto2 = LinearBorderEdgeDto(
          size: 1.0,
          alignment: 0.1,
        );

        expect(linearBorderEdgeDto1, equals(linearBorderEdgeDto2));
      });
    });

    // Additional tests for ShapeBorderUtility
    group('ShapeBorderUtility', () {
      test('should create utility instances for each shape border type', () {
        final shapeBorderUtility = ShapeBorderUtility(UtilityTestAttribute.new);

        expect(
          shapeBorderUtility.roundedRectangle,
          isA<RoundedRectangleBorderUtility>(),
        );
        expect(shapeBorderUtility.circle, isA<CircleBorderUtility>());
        expect(
          shapeBorderUtility.beveled,
          isA<BeveledRectangleBorderUtility>(),
        );
        expect(shapeBorderUtility.stadium, isA<StadiumBorderUtility>());
        expect(
          shapeBorderUtility.continuous,
          isA<ContinuousRectangleBorderUtility>(),
        );
      });
    });
  });

  group('ShapeBorderDto.tryToMerge', () {
    test('should return null when both inputs are null', () {
      final result = ShapeBorderDto.tryToMerge(null, null);
      expect(result, isNull);
    });

    test('should return the non-null input when one input is null', () {
      final dto = RoundedRectangleBorderDto();
      expect(ShapeBorderDto.tryToMerge(dto, null), equals(dto));
      expect(ShapeBorderDto.tryToMerge(null, dto), equals(dto));
    });

    test(
      'should return the second input when both inputs are not OutlinedBorderDto',
      () {
        final dto1 = CircleBorderDto();
        final dto2 = StarBorderDto();
        expect(ShapeBorderDto.tryToMerge(dto1, dto2), equals(dto2));
      },
    );

    test(
      'should call OutlinedBorderDto.tryToMerge when both inputs are OutlinedBorderDto',
      () {
        final dto1 = RoundedRectangleBorderDto(
          borderRadius: BorderRadiusDto(topLeft: const Radius.circular(10)),
        );
        final dto2 = RoundedRectangleBorderDto(
          side: BorderSideDto(color: Colors.red),
        );
        final expectedResult = RoundedRectangleBorderDto(
          borderRadius: BorderRadiusDto(topLeft: const Radius.circular(10)),
          side: BorderSideDto(color: Colors.red),
        );
        expect(ShapeBorderDto.tryToMerge(dto1, dto2), equals(expectedResult));
      },
    );
  });

  group('OutlinedBorderDto.tryToMerge', () {
    test('should return null when both inputs are null', () {
      final result = OutlinedBorderDto.tryToMerge(null, null);
      expect(result, isNull);
    });

    test('should return the non-null input when one input is null', () {
      final dto = RoundedRectangleBorderDto();
      expect(OutlinedBorderDto.tryToMerge(dto, null), equals(dto));
      expect(OutlinedBorderDto.tryToMerge(null, dto), equals(dto));
    });

    test('should call _exhaustiveMerge when both inputs are not null', () {
      final dto1 = RoundedRectangleBorderDto(
        borderRadius: BorderRadiusDto(topLeft: const Radius.circular(10)),
      );
      final dto2 = RoundedRectangleBorderDto(
        side: BorderSideDto(color: Colors.red),
      );
      final expectedResult = RoundedRectangleBorderDto(
        borderRadius: BorderRadiusDto(topLeft: const Radius.circular(10)),
        side: BorderSideDto(color: Colors.red),
      );
      expect(OutlinedBorderDto.tryToMerge(dto1, dto2), equals(expectedResult));
    });
  });
  group('RoundedRectangleBorderDto', () {
    test(
      'adapt method should return the same instance if input is RoundedRectangleBorderDto',
      () {
        final dtoA = RoundedRectangleBorderDto(
          borderRadius: BorderRadiusDto(topLeft: const Radius.circular(10)),
          side: BorderSideDto(width: 2.0),
        );
        final dtoB = RoundedRectangleBorderDto(
          borderRadius: BorderRadiusDto(topLeft: const Radius.circular(20)),
          side: BorderSideDto(width: 4.0),
        );
        expect(dtoA.adapt(dtoB), equals(dtoB));
      },
    );

    test(
      'adapt method should create a new instance from other OutlinedBorderDto',
      () {
        final dtoA = RoundedRectangleBorderDto();
        final dtoB = CircleBorderDto(side: BorderSideDto(width: 3.0));
        final result = dtoA.adapt(dtoB);
        expect(result, isA<RoundedRectangleBorderDto>());
        expect(result.side, equals(dtoB.side));
        expect(result.borderRadius, isNull);
      },
    );
  });

  group('BeveledRectangleBorderDto', () {
    test(
      'adapt method should return the same instance if input is BeveledRectangleBorderDto',
      () {
        final dtoA = BeveledRectangleBorderDto(
          borderRadius: BorderRadiusDto(topLeft: const Radius.circular(5)),
          side: BorderSideDto(width: 1.5),
        );
        final dtoB = BeveledRectangleBorderDto(
          borderRadius: BorderRadiusDto(topLeft: const Radius.circular(5)),
          side: BorderSideDto(width: 3),
        );
        expect(dtoA.adapt(dtoB), equals(dtoB));
      },
    );

    test(
      'adapt method should create a new instance from other OutlinedBorderDto',
      () {
        final dtoA = BeveledRectangleBorderDto();
        final dtoB = StadiumBorderDto(side: BorderSideDto(width: 2.5));
        final result = dtoA.adapt(dtoB);
        expect(result, isA<BeveledRectangleBorderDto>());
        expect(result.side, equals(dtoB.side));
        expect(result.borderRadius, isNull);
      },
    );
  });

  group('ContinuousRectangleBorderDto', () {
    test(
      'adapt method should return the same instance if input is ContinuousRectangleBorderDto',
      () {
        final dtoA = ContinuousRectangleBorderDto(
          borderRadius: BorderRadiusDto(topLeft: const Radius.circular(8)),
          side: BorderSideDto(width: 1.2),
        );
        final dtoB = ContinuousRectangleBorderDto(
          borderRadius: BorderRadiusDto(topLeft: const Radius.circular(16)),
          side: BorderSideDto(width: 3),
        );
        expect(dtoA.adapt(dtoB), equals(dtoB));
      },
    );

    test(
      'adapt method should create a new instance from other OutlinedBorderDto',
      () {
        final dtoA = ContinuousRectangleBorderDto();
        final dtoB = RoundedRectangleBorderDto(
          side: BorderSideDto(width: 1.8),
          borderRadius: BorderRadiusDto(topLeft: const Radius.circular(10)),
        );
        final result = dtoA.adapt(dtoB);
        expect(result, isA<ContinuousRectangleBorderDto>());
        expect(result.side, equals(dtoB.side));
        expect(result.borderRadius, equals(dtoB.borderRadius));
      },
    );
  });

  group('CircleBorderDto', () {
    test(
      'adapt method should return the same instance if input is CircleBorderDto',
      () {
        final dtoA = CircleBorderDto(
          side: BorderSideDto(width: 2.2),
          eccentricity: 0.5,
        );
        final dtoB = CircleBorderDto(
          side: BorderSideDto(width: 22),
          eccentricity: 0.7,
        );
        expect(dtoA.adapt(dtoB), equals(dtoB));
      },
    );

    test(
      'adapt method should create a new instance from other OutlinedBorderDto',
      () {
        final dtoA = CircleBorderDto();
        final dtoB = BeveledRectangleBorderDto(side: BorderSideDto(width: 1.7));
        final result = dtoA.adapt(dtoB);
        expect(result, isA<CircleBorderDto>());
        expect(result.side, equals(dtoB.side));
        expect(result.eccentricity, isNull);
      },
    );
  });

  group('StarBorderDto', () {
    test(
      'adapt method should create a new instance from other OutlinedBorderDto',
      () {
        final dtoA = StarBorderDto();
        final dtoB = ContinuousRectangleBorderDto(
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
      },
    );
  });

  group('LinearBorderDto', () {
    test(
      'adapt method should return the same instance if input is LinearBorderDto',
      () {
        final dtoA = LinearBorderDto(
          side: BorderSideDto(width: 1.9),
          start: LinearBorderEdgeDto(size: 2.0, alignment: 0.5),
        );
        final dtoB = LinearBorderDto(
          side: BorderSideDto(width: 19),
          start: LinearBorderEdgeDto(size: 20, alignment: 0.9),
        );
        expect(dtoA.adapt(dtoB), equals(dtoB));
      },
    );

    test(
      'adapt method should create a new instance from other OutlinedBorderDto',
      () {
        final dtoA = LinearBorderDto();
        final dtoB = StadiumBorderDto(side: BorderSideDto(width: 2.1));
        final result = dtoA.adapt(dtoB);
        expect(result, isA<LinearBorderDto>());
        expect(result.side, equals(dtoB.side));
        expect(result.start, isNull);
        expect(result.end, isNull);
        expect(result.top, isNull);
        expect(result.bottom, isNull);
      },
    );
  });

  group('StadiumBorderDto', () {
    test(
      'adapt method should return the same instance if input is StadiumBorderDto',
      () {
        final dtoA = StadiumBorderDto(side: BorderSideDto(width: 1.6));
        final dtoB = StadiumBorderDto(side: BorderSideDto(width: 16));
        expect(dtoA.adapt(dtoB), equals(dtoB));
      },
    );

    test(
      'adapt method should create a new instance from other OutlinedBorderDto',
      () {
        final dtoA = StadiumBorderDto();
        final dtoB = CircleBorderDto(side: BorderSideDto(width: 2.3));
        final result = dtoA.adapt(dtoB);
        expect(result, isA<StadiumBorderDto>());
        expect(result.side, equals(dtoB.side));
      },
    );
  });
}
