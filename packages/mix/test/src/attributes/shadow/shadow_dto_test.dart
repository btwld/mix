import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('ShadowDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('main constructor creates ShadowDto with all properties', () {
        final dto = ShadowDto(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(10, 10),
        );

        expect(dto.blurRadius, resolvesTo(10.0));
        expect(dto.color, resolvesTo(Colors.blue));
        expect(dto.offset, resolvesTo(const Offset(10, 10)));
      });

      test('main constructor with Prop values', () {
        const dto = ShadowDto(
          blurRadius: Prop(5.0),
          color: Prop(Colors.red),
          offset: Prop(Offset(5, 5)),
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
        final dto = ShadowDto(
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
        final dto = ShadowDto(color: Colors.red);

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
        final dto1 = ShadowDto(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(10, 10),
        );
        final dto2 = ShadowDto(
          blurRadius: 20.0,
          color: Colors.red,
          offset: const Offset(20, 20),
        );

        final merged = dto1.merge(dto2);

        expect(merged.blurRadius, resolvesTo(20.0));
        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.offset, resolvesTo(const Offset(20, 20)));
      });

      test('merge with partial properties', () {
        final dto1 = ShadowDto(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(10, 10),
        );
        final dto2 = ShadowDto(color: Colors.green);

        final merged = dto1.merge(dto2);

        expect(merged.blurRadius, resolvesTo(10.0));
        expect(merged.color, resolvesTo(Colors.green));
        expect(merged.offset, resolvesTo(const Offset(10, 10)));
      });

      test('merge with null returns original', () {
        final dto = ShadowDto(blurRadius: 5.0, color: Colors.purple);

        final merged = dto.merge(null);
        expect(merged, same(dto));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal ShadowDtos', () {
        final dto1 = ShadowDto(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(10, 10),
        );
        final dto2 = ShadowDto(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(10, 10),
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal ShadowDtos', () {
        final dto1 = ShadowDto(blurRadius: 10.0, color: Colors.blue);
        final dto2 = ShadowDto(blurRadius: 10.0, color: Colors.red);

        expect(dto1, isNot(equals(dto2)));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles zero blur radius', () {
        final dto = ShadowDto(blurRadius: 0.0, color: Colors.black);

        expect(dto.blurRadius, resolvesTo(0.0));
      });

      test('handles negative blur radius', () {
        final dto = ShadowDto(blurRadius: -5.0, color: Colors.black);

        expect(dto.blurRadius, resolvesTo(-5.0));
      });

      test('handles large offsets', () {
        final dto = ShadowDto(
          offset: const Offset(1000, 1000),
          color: Colors.black,
        );

        expect(dto.offset, resolvesTo(const Offset(1000, 1000)));
      });

      test('handles negative offsets', () {
        final dto = ShadowDto(
          offset: const Offset(-50, -50),
          color: Colors.black,
        );

        expect(dto.offset, resolvesTo(const Offset(-50, -50)));
      });

      test('handles transparent color', () {
        final dto = ShadowDto(color: Colors.transparent, blurRadius: 10.0);

        expect(dto.color, resolvesTo(Colors.transparent));
      });
    });
  });

  group('BoxShadowDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('main constructor creates BoxShadowDto with all properties', () {
        final dto = BoxShadowDto(
          color: Colors.blue,
          offset: const Offset(10, 10),
          blurRadius: 10.0,
          spreadRadius: 5.0,
        );

        expect(dto.color, resolvesTo(Colors.blue));
        expect(dto.offset, resolvesTo(const Offset(10, 10)));
        expect(dto.blurRadius, resolvesTo(10.0));
        expect(dto.spreadRadius, resolvesTo(5.0));
      });

      test('main constructor with Prop values', () {
        const dto = BoxShadowDto(
          color: Prop(Colors.red),
          offset: Prop(Offset(5, 5)),
          blurRadius: Prop(8.0),
          spreadRadius: Prop(3.0),
        );

        expect(dto.color, resolvesTo(Colors.red));
        expect(dto.offset, resolvesTo(const Offset(5, 5)));
        expect(dto.blurRadius, resolvesTo(8.0));
        expect(dto.spreadRadius, resolvesTo(3.0));
      });

      test('value constructor from BoxShadow', () {
        const boxShadow = BoxShadow(
          color: Colors.green,
          offset: Offset(15, 15),
          blurRadius: 12.0,
          spreadRadius: 6.0,
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
          color: Colors.purple,
          blurRadius: 8.0,
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
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to BoxShadow with all properties', () {
        final dto = BoxShadowDto(
          color: Colors.blue,
          offset: const Offset(10, 10),
          blurRadius: 10.0,
          spreadRadius: 5.0,
        );

        expect(
          dto,
          resolvesTo(
            const BoxShadow(
              color: Colors.blue,
              offset: Offset(10, 10),
              blurRadius: 10.0,
              spreadRadius: 5.0,
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
        final dto = BoxShadowDto(color: Colors.red, spreadRadius: 3.0);

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        expect(resolved.color, Colors.red);
        expect(resolved.offset, Offset.zero);
        expect(resolved.blurRadius, 0.0);
        expect(resolved.spreadRadius, 3.0);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another BoxShadowDto - all properties', () {
        final dto1 = BoxShadowDto(
          color: Colors.blue,
          offset: const Offset(10, 10),
          blurRadius: 10.0,
          spreadRadius: 5.0,
        );
        final dto2 = BoxShadowDto(
          color: Colors.red,
          offset: const Offset(20, 20),
          blurRadius: 20.0,
          spreadRadius: 10.0,
        );

        final merged = dto1.merge(dto2);

        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.offset, resolvesTo(const Offset(20, 20)));
        expect(merged.blurRadius, resolvesTo(20.0));
        expect(merged.spreadRadius, resolvesTo(10.0));
      });

      test('merge with partial properties', () {
        final dto1 = BoxShadowDto(
          color: Colors.blue,
          offset: const Offset(10, 10),
          blurRadius: 10.0,
          spreadRadius: 5.0,
        );
        final dto2 = BoxShadowDto(color: Colors.green, blurRadius: 15.0);

        final merged = dto1.merge(dto2);

        expect(merged.color, resolvesTo(Colors.green));
        expect(merged.offset, resolvesTo(const Offset(10, 10)));
        expect(merged.blurRadius, resolvesTo(15.0));
        expect(merged.spreadRadius, resolvesTo(5.0));
      });

      test('merge with null returns original', () {
        final dto = BoxShadowDto(
          color: Colors.purple,
          blurRadius: 5.0,
          spreadRadius: 2.0,
        );

        final merged = dto.merge(null);
        expect(merged, same(dto));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal BoxShadowDtos', () {
        final dto1 = BoxShadowDto(
          color: Colors.blue,
          offset: const Offset(10, 10),
          blurRadius: 10.0,
          spreadRadius: 5.0,
        );
        final dto2 = BoxShadowDto(
          color: Colors.blue,
          offset: const Offset(10, 10),
          blurRadius: 10.0,
          spreadRadius: 5.0,
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal BoxShadowDtos', () {
        final dto1 = BoxShadowDto(color: Colors.blue, spreadRadius: 5.0);
        final dto2 = BoxShadowDto(color: Colors.blue, spreadRadius: 10.0);

        expect(dto1, isNot(equals(dto2)));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles zero blur and spread radius', () {
        final dto = BoxShadowDto(
          blurRadius: 0.0,
          spreadRadius: 0.0,
          color: Colors.black,
        );

        expect(dto.blurRadius, resolvesTo(0.0));
        expect(dto.spreadRadius, resolvesTo(0.0));
      });

      test('handles negative blur and spread radius', () {
        final dto = BoxShadowDto(
          blurRadius: -5.0,
          spreadRadius: -3.0,
          color: Colors.black,
        );

        expect(dto.blurRadius, resolvesTo(-5.0));
        expect(dto.spreadRadius, resolvesTo(-3.0));
      });

      test('handles inset property preservation', () {
        // Note: BoxShadowDto doesn't have an inset property in the current implementation
        // This is just to document expected behavior
        final dto = BoxShadowDto(color: Colors.black, blurRadius: 10.0);

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        // BoxShadow defaults to non-inset (normal shadow)
        expect(resolved.blurRadius, 10.0);
      });

      test('handles large spread radius', () {
        final dto = BoxShadowDto(spreadRadius: 100.0, color: Colors.black);

        expect(dto.spreadRadius, resolvesTo(100.0));
      });

      test('handles semi-transparent colors', () {
        final dto = BoxShadowDto(
          color: const Color(0x80000000), // Black with 50% alpha
          blurRadius: 10.0,
          spreadRadius: 5.0,
        );

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        expect(
          (resolved.color.a * 255.0).round() & 0xff,
          0x80,
        ); // 128 = 50% of 255
      });
    });
  });

  // Integration Tests
  group('Integration Tests', () {
    test('ShadowDto vs BoxShadowDto in lists', () {
      final shadows = [
        ShadowDto(
          color: Colors.black,
          blurRadius: 5.0,
          offset: const Offset(2, 2),
        ),
      ];

      final boxShadows = [
        BoxShadowDto(
          color: Colors.black,
          blurRadius: 5.0,
          offset: const Offset(2, 2),
          spreadRadius: 2.0,
        ),
      ];

      expect(shadows.length, 1);
      expect(boxShadows.length, 1);

      // They resolve to different types
      final context = MockBuildContext();
      expect(shadows[0].resolve(context), isA<Shadow>());
      expect(boxShadows[0].resolve(context), isA<BoxShadow>());
    });

    test('BoxShadowDto in decoration context', () {
      final shadow = BoxShadowDto(
        color: Colors.grey,
        blurRadius: 10.0,
        spreadRadius: 2.0,
        offset: const Offset(0, 4),
      );

      final decoration = BoxDecorationDto(
        color: Colors.white,
        boxShadow: [shadow],
      );

      final context = MockBuildContext();
      final resolved = decoration.resolve(context);

      expect(resolved.boxShadow?.length, 1);
      expect(resolved.boxShadow?[0].color, Colors.grey);
      expect(resolved.boxShadow?[0].blurRadius, 10.0);
      expect(resolved.boxShadow?[0].spreadRadius, 2.0);
    });

    test('multiple BoxShadowDto merging', () {
      final baseShadow = BoxShadowDto(color: Colors.black, blurRadius: 5.0);

      final overrideShadow = BoxShadowDto(spreadRadius: 3.0);

      final finalShadow = BoxShadowDto(offset: const Offset(2, 4));

      final merged = baseShadow.merge(overrideShadow).merge(finalShadow);

      expect(merged.color, resolvesTo(Colors.black));
      expect(merged.blurRadius, resolvesTo(5.0));
      expect(merged.spreadRadius, resolvesTo(3.0));
      expect(merged.offset, resolvesTo(const Offset(2, 4)));
    });
  });
}
