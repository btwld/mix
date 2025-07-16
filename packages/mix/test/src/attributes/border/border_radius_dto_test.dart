import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('BorderRadiusDto', () {
    group('constructor', () {
      test('main factory assigns properties correctly', () {
        final dto = BorderRadiusDto(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(20.0),
          bottomLeft: const Radius.circular(30.0),
          bottomRight: const Radius.circular(40.0),
        );

        expect(dto, resolvesTo(const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(40.0),
        )));
      });

      test('props factory assigns properties correctly', () {
        final dto = BorderRadiusDto.props(
          topLeft: Prop.value(const Radius.circular(10.0)),
          topRight: Prop.value(const Radius.circular(20.0)),
          bottomLeft: Prop.value(const Radius.circular(30.0)),
          bottomRight: Prop.value(const Radius.circular(40.0)),
        );

        expect(dto, resolvesTo(const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(40.0),
        )));
      });

      test('.value factory creates from Flutter type', () {
        const borderRadius = BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(40.0),
        );
        final dto = BorderRadiusDto.value(borderRadius);

        expect(dto, resolvesTo(borderRadius));
      });

      test('.maybeValue handles null correctly', () {
        expect(BorderRadiusDto.maybeValue(null), isNull);
        expect(
          BorderRadiusDto.maybeValue(const BorderRadius.all(Radius.circular(10.0))),
          isNotNull,
        );
      });
    });

    group('resolve', () {
      test('returns correct BorderRadius', () {
        final dto = BorderRadiusDto(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(20.0),
          bottomLeft: const Radius.circular(30.0),
          bottomRight: const Radius.circular(40.0),
        );

        expect(dto, resolvesTo(const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(40.0),
        )));
      });

      test('uses default values for null properties', () {
        final dto = BorderRadiusDto(topLeft: const Radius.circular(10.0)); // other properties are null

        expect(dto, resolvesTo(const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.zero,
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        )));
      });

      test('handles all-null DTO', () {
        final dto = BorderRadiusDto();

        expect(dto, resolvesTo(BorderRadius.zero));
      });
    });

    group('merge', () {
      test('correctly combines properties', () {
        final base = BorderRadiusDto(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(20.0),
          bottomLeft: const Radius.circular(30.0),
          bottomRight: const Radius.circular(40.0),
        );
        final override = BorderRadiusDto(
          topLeft: const Radius.circular(5.0),
          bottomLeft: const Radius.circular(15.0),
        ); // topRight and bottomRight not specified

        final merged = base.merge(override);

        expect(merged, resolvesTo(const BorderRadius.only(
          topLeft: Radius.circular(5.0),    // From override
          topRight: Radius.circular(20.0),  // Preserved from base
          bottomLeft: Radius.circular(15.0), // From override
          bottomRight: Radius.circular(40.0), // Preserved from base
        )));
      });

      test('returns self when merging with null', () {
        final dto = BorderRadiusDto(topLeft: const Radius.circular(10.0));
        expect(dto.merge(null), same(dto));
      });

      test('preserves unspecified properties', () {
        final base = BorderRadiusDto(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(20.0),
          bottomLeft: const Radius.circular(30.0),
          bottomRight: const Radius.circular(40.0),
        );
        final override = BorderRadiusDto(topLeft: const Radius.circular(5.0));

        final merged = base.merge(override);

        expect(merged, resolvesTo(const BorderRadius.only(
          topLeft: Radius.circular(5.0),    // Overridden
          topRight: Radius.circular(20.0),  // Preserved
          bottomLeft: Radius.circular(30.0), // Preserved
          bottomRight: Radius.circular(40.0), // Preserved
        )));
      });
    });

    group('equality', () {
      test('equals with same values', () {
        final dto1 = BorderRadiusDto(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(20.0),
        );
        final dto2 = BorderRadiusDto(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(20.0),
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equals with different values', () {
        final dto1 = BorderRadiusDto(topLeft: const Radius.circular(10.0));
        final dto2 = BorderRadiusDto(topLeft: const Radius.circular(20.0));

        expect(dto1, isNot(equals(dto2)));
      });
    });

    group('token resolution', () {
      testWidgets('resolves tokens from context', (tester) async {
        const radiusToken = MixableToken<Radius>('test-radius');
        final dto = BorderRadiusDto.props(
          topLeft: Prop.token(radiusToken),
          topRight: Prop.value(const Radius.circular(20.0)),
        );

        await tester.pumpWithMixScope(
          Container(),
          theme: MixScopeData.static(tokens: {radiusToken: const Radius.circular(10.0)}),
        );

        final context = tester.element(find.byType(Container));
        final mixContext = MixContext.create(context, const Style.empty());

        expect(
          dto.resolve(mixContext),
          const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(20.0),
          ),
        );
      });

      test('handles missing tokens gracefully', () {
        const token = MixableToken<Radius>('undefined');
        final dto = BorderRadiusDto.props(
          topLeft: Prop.token(token),
        );

        expect(
          () => dto.resolve(EmptyMixData),
          throwsStateError,
        );
      });
    });
  });

  group('BorderRadiusDirectionalDto', () {
    group('constructor', () {
      test('main factory assigns properties correctly', () {
        final dto = BorderRadiusDirectionalDto(
          topStart: const Radius.circular(10.0),
          topEnd: const Radius.circular(20.0),
          bottomStart: const Radius.circular(30.0),
          bottomEnd: const Radius.circular(40.0),
        );

        expect(dto, resolvesTo(const BorderRadiusDirectional.only(
          topStart: Radius.circular(10.0),
          topEnd: Radius.circular(20.0),
          bottomStart: Radius.circular(30.0),
          bottomEnd: Radius.circular(40.0),
        )));
      });

      test('props factory assigns properties correctly', () {
        final dto = BorderRadiusDirectionalDto.props(
          topStart: Prop.value(const Radius.circular(10.0)),
          topEnd: Prop.value(const Radius.circular(20.0)),
          bottomStart: Prop.value(const Radius.circular(30.0)),
          bottomEnd: Prop.value(const Radius.circular(40.0)),
        );

        expect(dto, resolvesTo(const BorderRadiusDirectional.only(
          topStart: Radius.circular(10.0),
          topEnd: Radius.circular(20.0),
          bottomStart: Radius.circular(30.0),
          bottomEnd: Radius.circular(40.0),
        )));
      });

      test('.value factory creates from Flutter type', () {
        const borderRadius = BorderRadiusDirectional.only(
          topStart: Radius.circular(10.0),
          topEnd: Radius.circular(20.0),
          bottomStart: Radius.circular(30.0),
          bottomEnd: Radius.circular(40.0),
        );
        final dto = BorderRadiusDirectionalDto.value(borderRadius);

        expect(dto, resolvesTo(borderRadius));
      });

      test('.maybeValue handles null correctly', () {
        expect(BorderRadiusDirectionalDto.maybeValue(null), isNull);
        expect(
          BorderRadiusDirectionalDto.maybeValue(const BorderRadiusDirectional.all(Radius.circular(10.0))),
          isNotNull,
        );
      });
    });

    group('resolve', () {
      test('returns correct BorderRadiusDirectional', () {
        final dto = BorderRadiusDirectionalDto(
          topStart: const Radius.circular(10.0),
          topEnd: const Radius.circular(20.0),
          bottomStart: const Radius.circular(30.0),
          bottomEnd: const Radius.circular(40.0),
        );

        expect(dto, resolvesTo(const BorderRadiusDirectional.only(
          topStart: Radius.circular(10.0),
          topEnd: Radius.circular(20.0),
          bottomStart: Radius.circular(30.0),
          bottomEnd: Radius.circular(40.0),
        )));
      });

      test('uses default values for null properties', () {
        final dto = BorderRadiusDirectionalDto(topStart: const Radius.circular(10.0)); // other properties are null

        expect(dto, resolvesTo(const BorderRadiusDirectional.only(
          topStart: Radius.circular(10.0),
          topEnd: Radius.zero,
          bottomStart: Radius.zero,
          bottomEnd: Radius.zero,
        )));
      });

      test('handles all-null DTO', () {
        final dto = BorderRadiusDirectionalDto();

        expect(dto, resolvesTo(BorderRadiusDirectional.zero));
      });
    });

    group('merge', () {
      test('correctly combines properties', () {
        final base = BorderRadiusDirectionalDto(
          topStart: const Radius.circular(10.0),
          topEnd: const Radius.circular(20.0),
          bottomStart: const Radius.circular(30.0),
          bottomEnd: const Radius.circular(40.0),
        );
        final override = BorderRadiusDirectionalDto(
          topStart: const Radius.circular(5.0),
          bottomStart: const Radius.circular(15.0),
        ); // topEnd and bottomEnd not specified

        final merged = base.merge(override);

        expect(merged, resolvesTo(const BorderRadiusDirectional.only(
          topStart: Radius.circular(5.0),    // From override
          topEnd: Radius.circular(20.0),     // Preserved from base
          bottomStart: Radius.circular(15.0), // From override
          bottomEnd: Radius.circular(40.0),   // Preserved from base
        )));
      });

      test('returns self when merging with null', () {
        final dto = BorderRadiusDirectionalDto(topStart: const Radius.circular(10.0));
        expect(dto.merge(null), same(dto));
      });

      test('preserves unspecified properties', () {
        final base = BorderRadiusDirectionalDto(
          topStart: const Radius.circular(10.0),
          topEnd: const Radius.circular(20.0),
          bottomStart: const Radius.circular(30.0),
          bottomEnd: const Radius.circular(40.0),
        );
        final override = BorderRadiusDirectionalDto(topStart: const Radius.circular(5.0));

        final merged = base.merge(override);

        expect(merged, resolvesTo(const BorderRadiusDirectional.only(
          topStart: Radius.circular(5.0),    // Overridden
          topEnd: Radius.circular(20.0),     // Preserved
          bottomStart: Radius.circular(30.0), // Preserved
          bottomEnd: Radius.circular(40.0),   // Preserved
        )));
      });
    });

    group('equality', () {
      test('equals with same values', () {
        final dto1 = BorderRadiusDirectionalDto(
          topStart: const Radius.circular(10.0),
          topEnd: const Radius.circular(20.0),
        );
        final dto2 = BorderRadiusDirectionalDto(
          topStart: const Radius.circular(10.0),
          topEnd: const Radius.circular(20.0),
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equals with different values', () {
        final dto1 = BorderRadiusDirectionalDto(topStart: const Radius.circular(10.0));
        final dto2 = BorderRadiusDirectionalDto(topStart: const Radius.circular(20.0));

        expect(dto1, isNot(equals(dto2)));
      });
    });

    group('token resolution', () {
      testWidgets('resolves tokens from context', (tester) async {
        const radiusToken = MixableToken<Radius>('test-radius');
        final dto = BorderRadiusDirectionalDto.props(
          topStart: Prop.token(radiusToken),
          topEnd: Prop.value(const Radius.circular(20.0)),
        );

        await tester.pumpWithMixScope(
          Container(),
          theme: MixScopeData.static(tokens: {radiusToken: const Radius.circular(10.0)}),
        );

        final context = tester.element(find.byType(Container));
        final mixContext = MixContext.create(context, const Style.empty());

        expect(
          dto.resolve(mixContext),
          const BorderRadiusDirectional.only(
            topStart: Radius.circular(10.0),
            topEnd: Radius.circular(20.0),
          ),
        );
      });

      test('handles missing tokens gracefully', () {
        const token = MixableToken<Radius>('undefined');
        final dto = BorderRadiusDirectionalDto.props(
          topStart: Prop.token(token),
        );

        expect(
          () => dto.resolve(EmptyMixData),
          throwsStateError,
        );
      });
    });

    group('directional property behavior', () {
      test('topLeft, topRight, bottomLeft, and bottomRight are always null', () {
        final dto = BorderRadiusDirectionalDto(
          topStart: const Radius.circular(1),
          topEnd: const Radius.circular(2),
          bottomStart: const Radius.circular(3),
          bottomEnd: const Radius.circular(4),
        );
        expect(dto.topLeft, isNull);
        expect(dto.topRight, isNull);
        expect(dto.bottomLeft, isNull);
        expect(dto.bottomRight, isNull);
      });
    });
  });

  group('BorderRadiusGeometryDto', () {
    group('static factories', () {
      test('.value creates appropriate DTO type', () {
        const borderRadius = BorderRadius.all(Radius.circular(10.0));
        const directional = BorderRadiusDirectional.all(Radius.circular(20.0));

        final dto1 = BorderRadiusGeometryDto.value(borderRadius);
        final dto2 = BorderRadiusGeometryDto.value(directional);

        expect(dto1, isA<BorderRadiusDto>());
        expect(dto2, isA<BorderRadiusDirectionalDto>());
        expect(dto1, resolvesTo(borderRadius));
        expect(dto2, resolvesTo(directional));
      });

      test('.maybeValue handles null correctly', () {
        expect(BorderRadiusGeometryDto.maybeValue(null), isNull);
        expect(
          BorderRadiusGeometryDto.maybeValue(const BorderRadius.all(Radius.circular(10.0))),
          isNotNull,
        );
      });
    });

    group('cross-type merging', () {
      test('BorderRadiusDto merges with BorderRadiusDirectionalDto', () {
        final borderRadius = BorderRadiusDto(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(20.0),
          bottomLeft: const Radius.circular(30.0),
          bottomRight: const Radius.circular(40.0),
        );
        final directional = BorderRadiusDirectionalDto(
          topStart: const Radius.circular(5.0),
          bottomStart: const Radius.circular(15.0),
        );

        final merged = BorderRadiusGeometryDto.tryToMerge(borderRadius, directional);

        expect(merged, isA<BorderRadiusDirectionalDto>());
        expect(merged, resolvesTo(const BorderRadiusDirectional.only(
          topStart: Radius.circular(5.0),   // From directional (overrides)
          topEnd: Radius.circular(20.0),    // From borderRadius.topRight
          bottomStart: Radius.circular(15.0), // From directional
          bottomEnd: Radius.circular(40.0),  // From borderRadius.bottomRight
        )));
      });

      test('BorderRadiusDirectionalDto merges with BorderRadiusDto', () {
        final directional = BorderRadiusDirectionalDto(
          topStart: const Radius.circular(10.0),
          topEnd: const Radius.circular(20.0),
          bottomStart: const Radius.circular(30.0),
          bottomEnd: const Radius.circular(40.0),
        );
        final borderRadius = BorderRadiusDto(
          topLeft: const Radius.circular(5.0),
          bottomLeft: const Radius.circular(15.0),
        );

        final merged = BorderRadiusGeometryDto.tryToMerge(directional, borderRadius);

        expect(merged, isA<BorderRadiusDto>());
        expect(merged, resolvesTo(const BorderRadius.only(
          topLeft: Radius.circular(5.0),     // From borderRadius (overrides)
          topRight: Radius.circular(20.0),   // From directional.topEnd
          bottomLeft: Radius.circular(15.0), // From borderRadius
          bottomRight: Radius.circular(40.0), // From directional.bottomEnd
        )));
      });

      test('same type merging works normally', () {
        final dto1 = BorderRadiusDto(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(20.0),
        );
        final dto2 = BorderRadiusDto(
          topLeft: const Radius.circular(5.0),
          bottomLeft: const Radius.circular(30.0),
        );

        final merged = BorderRadiusGeometryDto.tryToMerge(dto1, dto2);

        expect(merged, isA<BorderRadiusDto>());
        expect(merged, resolvesTo(const BorderRadius.only(
          topLeft: Radius.circular(5.0),     // From dto2
          topRight: Radius.circular(20.0),   // From dto1 (preserved)
          bottomLeft: Radius.circular(30.0), // From dto2
          bottomRight: Radius.zero,          // Default
        )));
      });

      test('returns second when first is null', () {
        final dto = BorderRadiusDto(topLeft: const Radius.circular(10.0));
        final merged = BorderRadiusGeometryDto.tryToMerge(null, dto);

        expect(merged, same(dto));
      });

      test('returns first when second is null', () {
        final dto = BorderRadiusDto(topLeft: const Radius.circular(10.0));
        final merged = BorderRadiusGeometryDto.tryToMerge(dto, null);

        expect(merged, same(dto));
      });

      test('returns null when both are null', () {
        final merged = BorderRadiusGeometryDto.tryToMerge(null, null);

        expect(merged, isNull);
      });
    });
  });

  // Legacy test for backward compatibility
  group('BorderSideDto', () {
    test('from constructor sets all values correctly', () {
      final attr = BorderSideDto(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 1.0,
      );
      expect(attr.color, resolvesTo(Colors.red));
      expect(attr.width, resolvesTo(1.0));
      expect(attr.style, resolvesTo(BorderStyle.solid));
    });
    test('resolve returns correct BorderSide', () {
      final attr = BorderSideDto(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 1.0,
      );
      
      expect(
        attr,
        resolvesTo(
          const BorderSide(
            color: Colors.red,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
      );
    });
    test('Equality holds when all attributes are the same', () {
      final attr1 = BorderSideDto(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 1.0,
      );
      final attr2 = BorderSideDto(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 1.0,
      );
      expect(attr1, attr2);
      expect(attr1.hashCode, attr2.hashCode);
    });
    test('Equality fails when attributes are different', () {
      final attr1 = BorderSideDto(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 1.0,
      );
      final attr2 = BorderSideDto(
        color: Colors.blue,
        style: BorderStyle.solid,
        width: 1.0,
      );
      expect(attr1, isNot(attr2));
      expect(attr1.hashCode, isNot(attr2.hashCode));
    });
  });
}