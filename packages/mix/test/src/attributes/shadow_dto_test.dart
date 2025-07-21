import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  // ShadowDto tests
  group('ShadowDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('only constructor with raw values', () {
        final dto = ShadowDto.only(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(10, 10),
        );

        expect(dto.blurRadius, resolvesTo(10.0));
        expect(dto.color, resolvesTo(Colors.blue));
        expect(dto.offset, resolvesTo(const Offset(10, 10)));
      });

      test('main constructor with Prop values', () {
        final dto = ShadowDto(
          blurRadius: Prop(5.0),
          color: Prop(Colors.red),
          offset: Prop(const Offset(5, 5)),
        );

        expect(dto.blurRadius, resolvesTo(5.0));
        expect(dto.color, resolvesTo(Colors.red));
        expect(dto.offset, resolvesTo(const Offset(5, 5)));
      });

      test('value constructor from Shadow', () {
        const shadow = Shadow(
          blurRadius: 15.0,
          color: Colors.green,
          offset: Offset(15, 15),
        );
        final dto = ShadowDto.value(shadow);

        expect(dto.blurRadius, resolvesTo(shadow.blurRadius));
        expect(dto.color, resolvesTo(shadow.color));
        expect(dto.offset, resolvesTo(shadow.offset));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns ShadowDto for non-null Shadow', () {
        const shadow = Shadow(blurRadius: 8.0, color: Colors.purple);
        final dto = ShadowDto.maybeValue(shadow);

        expect(dto, isNotNull);
        expect(dto?.blurRadius, resolvesTo(shadow.blurRadius));
        expect(dto?.color, resolvesTo(shadow.color));
      });

      test('maybeValue returns null for null Shadow', () {
        final dto = ShadowDto.maybeValue(null);
        expect(dto, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to Shadow with all properties', () {
        final dto = ShadowDto.only(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(10, 10),
        );

        expect(
          dto,
          resolvesTo(
            const Shadow(
              blurRadius: 10.0,
              color: Colors.blue,
              offset: Offset(10, 10),
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        const dto = ShadowDto();

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        expect(resolved.blurRadius, 0.0);
        expect(resolved.color, const Color(0xFF000000));
        expect(resolved.offset, Offset.zero);
      });

      test('resolves with partial properties', () {
        final dto = ShadowDto.only(color: Colors.red);

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        expect(resolved.color, Colors.red);
        expect(resolved.blurRadius, 0.0);
        expect(resolved.offset, Offset.zero);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another ShadowDto - all properties', () {
        final dto1 = ShadowDto.only(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(10, 10),
        );
        final dto2 = ShadowDto.only(
          blurRadius: 20.0,
          color: Colors.red,
          offset: const Offset(20, 20),
        );

        final merged = dto1.merge(dto2);

        expect(merged.blurRadius, resolvesTo(20.0));
        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.offset, resolvesTo(const Offset(20, 20)));
      });

      test('merge with another ShadowDto - partial properties', () {
        final dto1 = ShadowDto.only(blurRadius: 10.0, color: Colors.blue);
        final dto2 = ShadowDto.only(color: Colors.red);

        final merged = dto1.merge(dto2);

        expect(merged.blurRadius, resolvesTo(10.0));
        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.offset, isNull);
      });

      test('merge with null returns original', () {
        final dto = ShadowDto.only(blurRadius: 5.0, color: Colors.purple);

        final merged = dto.merge(null);

        expect(merged, equals(dto));
      });
    });

    // Equality Tests
    group('Equality Tests', () {
      test('equality works correctly', () {
        final dto1 = ShadowDto.only(blurRadius: 10.0, color: Colors.blue);
        final dto2 = ShadowDto.only(blurRadius: 10.0, color: Colors.blue);

        expect(dto1, equals(dto2));
      });

      test('inequality works correctly', () {
        final dto1 = ShadowDto.only(blurRadius: 10.0, color: Colors.blue);
        final dto2 = ShadowDto.only(blurRadius: 10.0, color: Colors.red);

        expect(dto1, isNot(equals(dto2)));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles zero blur radius', () {
        final dto = ShadowDto.only(blurRadius: 0.0, color: Colors.black);

        expect(dto.blurRadius, resolvesTo(0.0));
      });

      test('handles negative blur radius', () {
        final dto = ShadowDto.only(blurRadius: -5.0, color: Colors.black);

        expect(dto.blurRadius, resolvesTo(-5.0));
      });

      test('handles transparent color', () {
        final dto = ShadowDto.only(color: Colors.transparent, blurRadius: 10.0);

        expect(dto.color, resolvesTo(Colors.transparent));
      });
    });
  });

  // BoxShadowDto tests
  group('BoxShadowDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('only constructor with raw values', () {
        final dto = BoxShadowDto.only(
          color: Colors.red,
          offset: const Offset(5, 5),
          blurRadius: 8.0,
          spreadRadius: 2.0,
        );

        expect(dto.color, resolvesTo(Colors.red));
        expect(dto.offset, resolvesTo(const Offset(5, 5)));
        expect(dto.blurRadius, resolvesTo(8.0));
        expect(dto.spreadRadius, resolvesTo(2.0));
      });

      test('main constructor with Prop values', () {
        final dto = BoxShadowDto(
          color: Prop(Colors.red),
          offset: Prop(const Offset(5, 5)),
          blurRadius: Prop(8.0),
          spreadRadius: Prop(3.0),
        );

        expect(dto.color, resolvesTo(Colors.red));
        expect(dto.offset, resolvesTo(const Offset(5, 5)));
        expect(dto.blurRadius, resolvesTo(8.0));
        expect(dto.spreadRadius, resolvesTo(5.0));
      });

      test('value constructor from BoxShadow', () {
        const boxShadow = BoxShadow(
          color: Colors.grey,
          offset: Offset(3, 3),
          blurRadius: 6.0,
          spreadRadius: 1.0,
        );
        final dto = BoxShadowDto.value(boxShadow);

        expect(dto.color, resolvesTo(boxShadow.color));
        expect(dto.offset, resolvesTo(boxShadow.offset));
        expect(dto.blurRadius, resolvesTo(boxShadow.blurRadius));
        expect(dto.spreadRadius, resolvesTo(boxShadow.spreadRadius));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns BoxShadowDto for non-null BoxShadow', () {
        const boxShadow = BoxShadow(
          color: Colors.grey,
          blurRadius: 10.0,
          spreadRadius: 2.0,
        );
        final dto = BoxShadowDto.maybeValue(boxShadow);

        expect(dto, isNotNull);
        expect(dto?.color, resolvesTo(boxShadow.color));
        expect(dto?.blurRadius, resolvesTo(boxShadow.blurRadius));
        expect(dto?.spreadRadius, resolvesTo(boxShadow.spreadRadius));
      });

      test('maybeValue returns null for null BoxShadow', () {
        final dto = BoxShadowDto.maybeValue(null);
        expect(dto, isNull);
      });

      test('fromElevation creates correct shadows', () {
        final shadows = BoxShadowDto.fromElevation(ElevationShadow.four);

        expect(shadows.length, 2);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to BoxShadow with all properties', () {
        final dto = BoxShadowDto.only(
          color: Colors.grey,
          offset: const Offset(2, 2),
          blurRadius: 4.0,
          spreadRadius: 1.0,
        );

        expect(
          dto,
          resolvesTo(
            const BoxShadow(
              color: Colors.grey,
              offset: Offset(2, 2),
              blurRadius: 4.0,
              spreadRadius: 1.0,
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        const dto = BoxShadowDto();

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        expect(resolved.color, const Color(0xFF000000));
        expect(resolved.offset, Offset.zero);
        expect(resolved.blurRadius, 0.0);
        expect(resolved.spreadRadius, 0.0);
      });

      test('resolves with partial properties', () {
        final dto = BoxShadowDto.only(color: Colors.red, spreadRadius: 3.0);

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        expect(resolved.color, Colors.red);
        expect(resolved.spreadRadius, 3.0);
        expect(resolved.blurRadius, 0.0);
        expect(resolved.offset, Offset.zero);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another BoxShadowDto - all properties', () {
        final dto1 = BoxShadowDto.only(
          color: Colors.blue,
          blurRadius: 5.0,
          spreadRadius: 2.0,
        );
        final dto2 = BoxShadowDto.only(color: Colors.green, blurRadius: 15.0);

        final merged = dto1.merge(dto2);

        expect(merged.color, resolvesTo(Colors.green));
        expect(merged.blurRadius, resolvesTo(15.0));
        expect(merged.spreadRadius, resolvesTo(2.0));
      });

      test('merge with another BoxShadowDto - partial properties', () {
        final dto1 = BoxShadowDto.only(color: Colors.blue, spreadRadius: 5.0);
        final dto2 = BoxShadowDto.only(color: Colors.blue, spreadRadius: 10.0);

        final merged = dto1.merge(dto2);

        expect(merged.color, resolvesTo(Colors.blue));
        expect(merged.spreadRadius, resolvesTo(10.0));
        expect(merged.blurRadius, isNull);
        expect(merged.offset, isNull);
      });

      test('merge with null returns original', () {
        final dto = BoxShadowDto.only(color: Colors.black, blurRadius: 10.0);

        final merged = dto.merge(null);

        expect(merged, equals(dto));
      });
    });

    // Equality Tests
    group('Equality Tests', () {
      test('equality works correctly', () {
        final dto1 = BoxShadowDto.only(
          color: Colors.grey,
          blurRadius: 5.0,
          spreadRadius: 2.0,
        );
        final dto2 = BoxShadowDto.only(
          color: Colors.grey,
          blurRadius: 5.0,
          spreadRadius: 2.0,
        );

        expect(dto1, equals(dto2));
      });

      test('inequality works correctly', () {
        final dto1 = BoxShadowDto.only(
          color: Colors.grey,
          blurRadius: 5.0,
          spreadRadius: 2.0,
        );
        final dto2 = BoxShadowDto.only(
          color: Colors.black,
          blurRadius: 5.0,
          spreadRadius: 2.0,
        );

        expect(dto1, isNot(equals(dto2)));
      });
    });

    // Utility Tests
    group('Utility Tests', () {
      test('merge behavior preserves later values', () {
        final baseShadow = BoxShadowDto.only(
          color: Colors.black,
          blurRadius: 5.0,
        );
        final overrideShadow = BoxShadowDto.only(
          color: Colors.red,
          spreadRadius: 3.0,
        );
        final finalShadow = BoxShadowDto.only(offset: const Offset(2, 4));

        final result = baseShadow.merge(overrideShadow).merge(finalShadow);

        expect(result.color, resolvesTo(Colors.red));
        expect(result.blurRadius, resolvesTo(5.0));
        expect(result.spreadRadius, resolvesTo(3.0));
        expect(result.offset, resolvesTo(const Offset(2, 4)));
      });
    });
  });
}
