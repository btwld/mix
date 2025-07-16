import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  // BorderSideDto tests - Test this first as it's a dependency
  group('BorderSideDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('main constructor creates BorderSideDto with all properties', () {
        final dto = BorderSideDto(
          color: Colors.red,
          style: BorderStyle.solid,
          width: 2.0,
          strokeAlign: BorderSide.strokeAlignCenter,
        );

        expect(dto.color, resolvesTo(Colors.red));
        expect(dto.style, resolvesTo(BorderStyle.solid));
        expect(dto.width, resolvesTo(2.0));
        expect(dto.strokeAlign, resolvesTo(BorderSide.strokeAlignCenter));
      });

      test('value constructor from BorderSide', () {
        const borderSide = BorderSide(
          color: Colors.blue,
          width: 3.0,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignInside,
        );

        final dto = BorderSideDto.value(borderSide);

        expect(dto.color, resolvesTo(borderSide.color));
        expect(dto.width, resolvesTo(borderSide.width));
        expect(dto.style, resolvesTo(borderSide.style));
        expect(dto.strokeAlign, resolvesTo(borderSide.strokeAlign));
      });

      test('props constructor with Prop values', () {
        const dto = BorderSideDto.props(
          color: Prop.fromValue(Colors.green),
          width: Prop.fromValue(4.0),
          style: Prop.fromValue(BorderStyle.none),
          strokeAlign: Prop.fromValue(BorderSide.strokeAlignOutside),
        );

        expect(dto.color, resolvesTo(Colors.green));
        expect(dto.width, resolvesTo(4.0));
        expect(dto.style, resolvesTo(BorderStyle.none));
        expect(dto.strokeAlign, resolvesTo(BorderSide.strokeAlignOutside));
      });

      test('none constant creates BorderSideDto with default values', () {
        final dto = BorderSideDto.none;
        final context = createEmptyMixData();

        final resolved = dto.resolve(context);
        expect(resolved, const BorderSide());
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns BorderSideDto for non-null BorderSide', () {
        const borderSide = BorderSide(color: Colors.red, width: 2.0);
        final dto = BorderSideDto.maybeValue(borderSide);

        expect(dto, isNotNull);
        expect(dto?.color, resolvesTo(Colors.red));
        expect(dto?.width, resolvesTo(2.0));
      });

      test('maybeValue returns null for null BorderSide', () {
        final dto = BorderSideDto.maybeValue(null);
        expect(dto, isNull);
      });

      test('maybeValue returns null for BorderSide.none', () {
        final dto = BorderSideDto.maybeValue(BorderSide.none);
        expect(dto, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves all properties correctly', () {
        final dto = BorderSideDto(
          color: Colors.purple,
          width: 5.0,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignCenter,
        );

        expect(
          dto,
          resolvesTo(
            const BorderSide(
              color: Colors.purple,
              width: 5.0,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        const dto = BorderSideDto.props();
        final context = createEmptyMixData();

        final resolved = dto.resolve(context);
        expect(resolved.color, const BorderSide().color);
        expect(resolved.width, const BorderSide().width);
        expect(resolved.style, const BorderSide().style);
        expect(resolved.strokeAlign, const BorderSide().strokeAlign);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another BorderSideDto - all properties', () {
        final dto1 = BorderSideDto(
          color: Colors.red,
          style: BorderStyle.solid,
          width: 1.0,
          strokeAlign: BorderSide.strokeAlignInside,
        );

        final dto2 = BorderSideDto(
          color: Colors.blue,
          style: BorderStyle.none,
          width: 2.0,
          strokeAlign: BorderSide.strokeAlignOutside,
        );

        final merged = dto1.merge(dto2);

        expect(merged.color, resolvesTo(Colors.blue));
        expect(merged.style, resolvesTo(BorderStyle.none));
        expect(merged.width, resolvesTo(2.0));
        expect(merged.strokeAlign, resolvesTo(BorderSide.strokeAlignOutside));
      });

      test('merge with partial properties', () {
        final dto1 = BorderSideDto(color: Colors.red, width: 1.0);

        final dto2 = BorderSideDto(width: 2.0, style: BorderStyle.solid);

        final merged = dto1.merge(dto2);

        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.width, resolvesTo(2.0));
        expect(merged.style, resolvesTo(BorderStyle.solid));
      });

      test('merge with null returns original', () {
        final dto = BorderSideDto(color: Colors.green, width: 3.0);

        final merged = dto.merge(null);
        expect(merged, same(dto));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal BorderSideDtos', () {
        final dto1 = BorderSideDto(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignCenter,
        );

        final dto2 = BorderSideDto(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignCenter,
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal BorderSideDtos', () {
        final dto1 = BorderSideDto(color: Colors.red);
        final dto2 = BorderSideDto(color: Colors.blue);

        expect(dto1, isNot(equals(dto2)));
      });
    });
  });

  // BorderDto tests
  group('BorderDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('main constructor creates BorderDto with all sides', () {
        final dto = BorderDto(
          top: BorderSideDto(width: 1.0),
          bottom: BorderSideDto(width: 2.0),
          left: BorderSideDto(width: 3.0),
          right: BorderSideDto(width: 4.0),
        );

        expect(dto.top?.mixValue?.width, resolvesTo(1.0));
        expect(dto.bottom?.mixValue?.width, resolvesTo(2.0));
        expect(dto.left?.mixValue?.width, resolvesTo(3.0));
        expect(dto.right?.mixValue?.width, resolvesTo(4.0));
      });

      test('all constructor creates uniform BorderDto', () {
        final side = BorderSideDto(color: Colors.red, width: 2.0);
        final dto = BorderDto.all(side);

        expect(dto.top?.mixValue, equals(side));
        expect(dto.bottom?.mixValue, equals(side));
        expect(dto.left?.mixValue, equals(side));
        expect(dto.right?.mixValue, equals(side));
        expect(dto.isUniform, isTrue);
      });

      test('symmetric constructor', () {
        final vertical = BorderSideDto(color: Colors.red);
        final horizontal = BorderSideDto(color: Colors.blue);

        final dto = BorderDto.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        );

        expect(dto.left?.mixValue, equals(vertical));
        expect(dto.right?.mixValue, equals(vertical));
        expect(dto.top?.mixValue, equals(horizontal));
        expect(dto.bottom?.mixValue, equals(horizontal));
      });

      test('vertical constructor', () {
        final side = BorderSideDto(width: 2.0);
        final dto = BorderDto.vertical(side);

        expect(dto.left?.mixValue, equals(side));
        expect(dto.right?.mixValue, equals(side));
        expect(dto.top, isNull);
        expect(dto.bottom, isNull);
      });

      test('horizontal constructor', () {
        final side = BorderSideDto(width: 3.0);
        final dto = BorderDto.horizontal(side);

        expect(dto.top?.mixValue, equals(side));
        expect(dto.bottom?.mixValue, equals(side));
        expect(dto.left, isNull);
        expect(dto.right, isNull);
      });

      test('value constructor from Border', () {
        const border = Border(
          top: BorderSide(color: Colors.red, width: 1.0),
          bottom: BorderSide(color: Colors.blue, width: 2.0),
          left: BorderSide(color: Colors.green, width: 3.0),
          right: BorderSide(color: Colors.yellow, width: 4.0),
        );

        final dto = BorderDto.value(border);

        expect(dto.top?.mixValue?.color, resolvesTo(Colors.red));
        expect(dto.top?.mixValue?.width, resolvesTo(1.0));
        expect(dto.bottom?.mixValue?.color, resolvesTo(Colors.blue));
        expect(dto.bottom?.mixValue?.width, resolvesTo(2.0));
        expect(dto.left?.mixValue?.color, resolvesTo(Colors.green));
        expect(dto.left?.mixValue?.width, resolvesTo(3.0));
        expect(dto.right?.mixValue?.color, resolvesTo(Colors.yellow));
        expect(dto.right?.mixValue?.width, resolvesTo(4.0));
      });

      test('none constant', () {
        final none = BorderDto.none;
        expect(none.top?.mixValue, equals(BorderSideDto.none));
        expect(none.bottom?.mixValue, equals(BorderSideDto.none));
        expect(none.left?.mixValue, equals(BorderSideDto.none));
        expect(none.right?.mixValue, equals(BorderSideDto.none));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns BorderDto for non-null Border', () {
        final border = Border.all(color: Colors.red, width: 2.0);
        final dto = BorderDto.maybeValue(border);

        expect(dto, isNotNull);
        expect(dto?.top?.mixValue?.color, resolvesTo(Colors.red));
      });

      test('maybeValue returns null for null Border', () {
        final dto = BorderDto.maybeValue(null);
        expect(dto, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to Border with all sides', () {
        final dto = BorderDto(
          top: BorderSideDto(width: 5.0),
          bottom: BorderSideDto(width: 10.0),
          left: BorderSideDto(width: 15.0),
          right: BorderSideDto(width: 20.0),
        );

        expect(
          dto,
          resolvesTo(
            const Border(
              top: BorderSide(width: 5.0),
              bottom: BorderSide(width: 10.0),
              left: BorderSide(width: 15.0),
              right: BorderSide(width: 20.0),
            ),
          ),
        );
      });

      test('resolves with default values for missing sides', () {
        final dto = BorderDto(
          top: BorderSideDto(width: 5.0),
          left: BorderSideDto(width: 15.0),
        );

        expect(
          dto,
          resolvesTo(
            const Border(
              top: BorderSide(width: 5.0),
              bottom: BorderSide.none,
              left: BorderSide(width: 15.0),
              right: BorderSide.none,
            ),
          ),
        );
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another BorderDto', () {
        final dto1 = BorderDto(
          top: BorderSideDto(color: Colors.red, width: 1.0),
          bottom: BorderSideDto(color: Colors.red, width: 1.0),
          left: BorderSideDto(color: Colors.red, width: 1.0),
          right: BorderSideDto(color: Colors.red, width: 1.0),
        );

        final dto2 = BorderDto(
          top: BorderSideDto(width: 2.0),
          bottom: BorderSideDto(width: 2.0),
          left: BorderSideDto(width: 2.0),
          right: BorderSideDto(width: 2.0),
        );

        final merged = dto1.merge(dto2);

        expect(merged.top?.mixValue?.width, resolvesTo(2.0));
        expect(merged.top?.mixValue?.color, resolvesTo(Colors.red));
        expect(merged.bottom?.mixValue?.width, resolvesTo(2.0));
        expect(merged.bottom?.mixValue?.color, resolvesTo(Colors.red));
        expect(merged.left?.mixValue?.width, resolvesTo(2.0));
        expect(merged.left?.mixValue?.color, resolvesTo(Colors.red));
        expect(merged.right?.mixValue?.width, resolvesTo(2.0));
        expect(merged.right?.mixValue?.color, resolvesTo(Colors.red));
      });

      test('merge with null returns original', () {
        final dto = BorderDto.all(BorderSideDto(width: 1.0));
        final merged = dto.merge(null);

        expect(merged, same(dto));
      });
    });

    // Property Tests
    group('Property Tests', () {
      test('isDirectional returns false', () {
        final dto = BorderDto();
        expect(dto.isDirectional, isFalse);
      });

      test('isUniform with all sides equal', () {
        final side = BorderSideDto(width: 2.0);
        final dto = BorderDto.all(side);
        expect(dto.isUniform, isTrue);
      });

      test('isUniform with different sides', () {
        final dto = BorderDto(
          top: BorderSideDto(width: 1.0),
          bottom: BorderSideDto(width: 2.0),
        );
        expect(dto.isUniform, isFalse);
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal BorderDtos', () {
        final dto1 = BorderDto(
          top: BorderSideDto(width: 1.0),
          bottom: BorderSideDto(width: 2.0),
          left: BorderSideDto(width: 3.0),
          right: BorderSideDto(width: 4.0),
        );

        final dto2 = BorderDto(
          top: BorderSideDto(width: 1.0),
          bottom: BorderSideDto(width: 2.0),
          left: BorderSideDto(width: 3.0),
          right: BorderSideDto(width: 4.0),
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal BorderDtos', () {
        final dto1 = BorderDto(top: BorderSideDto(width: 1.0));
        final dto2 = BorderDto(top: BorderSideDto(width: 2.0));

        expect(dto1, isNot(equals(dto2)));
      });
    });
  });

  // BorderDirectionalDto tests
  group('BorderDirectionalDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('main constructor creates BorderDirectionalDto with all sides', () {
        final dto = BorderDirectionalDto(
          top: BorderSideDto(width: 1.0),
          bottom: BorderSideDto(width: 2.0),
          start: BorderSideDto(width: 3.0),
          end: BorderSideDto(width: 4.0),
        );

        expect(dto.top?.mixValue?.width, resolvesTo(1.0));
        expect(dto.bottom?.mixValue?.width, resolvesTo(2.0));
        expect(dto.start?.mixValue?.width, resolvesTo(3.0));
        expect(dto.end?.mixValue?.width, resolvesTo(4.0));
      });

      test('all constructor creates uniform BorderDirectionalDto', () {
        final side = BorderSideDto(color: Colors.red, width: 2.0);
        final dto = BorderDirectionalDto.all(side);

        expect(dto.top?.mixValue, equals(side));
        expect(dto.bottom?.mixValue, equals(side));
        expect(dto.start?.mixValue, equals(side));
        expect(dto.end?.mixValue, equals(side));
        expect(dto.isUniform, isTrue);
      });

      test('symmetric constructor', () {
        final vertical = BorderSideDto(color: Colors.red);
        final horizontal = BorderSideDto(color: Colors.blue);

        final dto = BorderDirectionalDto.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        );

        expect(dto.start?.mixValue, equals(vertical));
        expect(dto.end?.mixValue, equals(vertical));
        expect(dto.top?.mixValue, equals(horizontal));
        expect(dto.bottom?.mixValue, equals(horizontal));
      });

      test('value constructor from BorderDirectional', () {
        const border = BorderDirectional(
          top: BorderSide(color: Colors.red, width: 1.0),
          bottom: BorderSide(color: Colors.blue, width: 2.0),
          start: BorderSide(color: Colors.green, width: 3.0),
          end: BorderSide(color: Colors.yellow, width: 4.0),
        );

        final dto = BorderDirectionalDto.value(border);

        expect(dto.top?.mixValue?.color, resolvesTo(Colors.red));
        expect(dto.bottom?.mixValue?.color, resolvesTo(Colors.blue));
        expect(dto.start?.mixValue?.color, resolvesTo(Colors.green));
        expect(dto.end?.mixValue?.color, resolvesTo(Colors.yellow));
      });

      test('none constant', () {
        final none = BorderDirectionalDto.none;
        expect(none.top?.mixValue, equals(BorderSideDto.none));
        expect(none.bottom?.mixValue, equals(BorderSideDto.none));
        expect(none.start?.mixValue, equals(BorderSideDto.none));
        expect(none.end?.mixValue, equals(BorderSideDto.none));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns BorderDirectionalDto for non-null', () {
        const border = BorderDirectional(
          top: BorderSide(color: Colors.red),
          bottom: BorderSide(color: Colors.red),
          start: BorderSide(color: Colors.red),
          end: BorderSide(color: Colors.red),
        );
        final dto = BorderDirectionalDto.maybeValue(border);

        expect(dto, isNotNull);
        expect(dto?.top?.mixValue?.color, resolvesTo(Colors.red));
      });

      test('maybeValue returns null for null', () {
        final dto = BorderDirectionalDto.maybeValue(null);
        expect(dto, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to BorderDirectional', () {
        final dto = BorderDirectionalDto(
          top: BorderSideDto(width: 5.0),
          bottom: BorderSideDto(width: 10.0),
          start: BorderSideDto(width: 15.0),
          end: BorderSideDto(width: 20.0),
        );

        expect(
          dto,
          resolvesTo(
            const BorderDirectional(
              top: BorderSide(width: 5.0),
              bottom: BorderSide(width: 10.0),
              start: BorderSide(width: 15.0),
              end: BorderSide(width: 20.0),
            ),
          ),
        );
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another BorderDirectionalDto', () {
        final dto1 = BorderDirectionalDto(
          top: BorderSideDto(color: Colors.red),
          start: BorderSideDto(width: 1.0),
        );

        final dto2 = BorderDirectionalDto(
          top: BorderSideDto(width: 2.0),
          end: BorderSideDto(color: Colors.blue),
        );

        final merged = dto1.merge(dto2);

        expect(merged.top?.mixValue?.color, resolvesTo(Colors.red));
        expect(merged.top?.mixValue?.width, resolvesTo(2.0));
        expect(merged.start?.mixValue?.width, resolvesTo(1.0));
        expect(merged.end?.mixValue?.color, resolvesTo(Colors.blue));
      });
    });

    // Property Tests
    group('Property Tests', () {
      test('isDirectional returns true', () {
        final dto = BorderDirectionalDto();
        expect(dto.isDirectional, isTrue);
      });

      test('isUniform with all sides equal', () {
        final side = BorderSideDto(width: 2.0);
        final dto = BorderDirectionalDto.all(side);
        expect(dto.isUniform, isTrue);
      });
    });
  });

  // BoxBorderDto cross-type tests
  group('BoxBorderDto cross-type tests', () {
    test('tryToMerge with BorderDto and BorderDirectionalDto', () {
      final borderDto = BorderDto.all(
        BorderSideDto(color: Colors.yellow, width: 3.0),
      );

      final borderDirectionalDto = BorderDirectionalDto(
        top: BorderSideDto(color: Colors.green),
        bottom: BorderSideDto(width: 4.0),
        start: BorderSideDto(color: Colors.red, width: 1.0),
        end: BorderSideDto(color: Colors.blue, width: 2.0),
      );

      final merged =
          BoxBorderDto.tryToMerge(borderDto, borderDirectionalDto)
              as BorderDirectionalDto?;

      expect(merged?.top?.mixValue?.color, resolvesTo(Colors.green));
      expect(merged?.top?.mixValue?.width, resolvesTo(3.0));
      expect(merged?.bottom?.mixValue?.color, resolvesTo(Colors.yellow));
      expect(merged?.bottom?.mixValue?.width, resolvesTo(4.0));
      expect(merged?.start?.mixValue?.color, resolvesTo(Colors.red));
      expect(merged?.start?.mixValue?.width, resolvesTo(1.0));
      expect(merged?.end?.mixValue?.color, resolvesTo(Colors.blue));
      expect(merged?.end?.mixValue?.width, resolvesTo(2.0));
    });

    test('tryToMerge with BorderDirectionalDto and BorderDto', () {
      final borderDirectionalDto = BorderDirectionalDto(
        top: BorderSideDto(color: Colors.green),
        start: BorderSideDto(width: 1.0),
      );

      final borderDto = BorderDto(
        top: BorderSideDto(width: 3.0),
        left: BorderSideDto(color: Colors.red),
      );

      final merged =
          BoxBorderDto.tryToMerge(borderDirectionalDto, borderDto)
              as BorderDto?;

      expect(merged?.top?.mixValue?.color, resolvesTo(Colors.green));
      expect(merged?.top?.mixValue?.width, resolvesTo(3.0));
      expect(merged?.left?.mixValue?.color, resolvesTo(Colors.red));
    });

    test('tryToMerge with null values', () {
      final dto = BorderDto.all(BorderSideDto(width: 1.0));

      expect(BoxBorderDto.tryToMerge(dto, null), same(dto));
      expect(BoxBorderDto.tryToMerge(null, dto), same(dto));
      expect(BoxBorderDto.tryToMerge(null, null), isNull);
    });

    test('value factory with Border', () {
      final border = Border.all(color: Colors.red);
      final dto = BoxBorderDto.value(border);

      expect(dto, isA<BorderDto>());
      expect((dto as BorderDto).top?.mixValue?.color, resolvesTo(Colors.red));
    });

    test('value factory with BorderDirectional', () {
      const border = BorderDirectional(
        top: BorderSide(color: Colors.blue),
        bottom: BorderSide(color: Colors.blue),
        start: BorderSide(color: Colors.blue),
        end: BorderSide(color: Colors.blue),
      );
      final dto = BoxBorderDto.value(border);

      expect(dto, isA<BorderDirectionalDto>());
      expect(
        (dto as BorderDirectionalDto).top?.mixValue?.color,
        resolvesTo(Colors.blue),
      );
    });

    test('maybeValue factory', () {
      final border = Border.all(color: Colors.red);
      final dto = BoxBorderDto.maybeValue(border);

      expect(dto, isNotNull);
      expect(dto, isA<BorderDto>());

      final nullDto = BoxBorderDto.maybeValue(null);
      expect(nullDto, isNull);
    });
  });
}
