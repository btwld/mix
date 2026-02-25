import 'package:mix_generator/src/core/registry/mix_type_registry.dart';
import 'package:test/test.dart';

void main() {
  group('MixTypeRegistry', () {
    const registry = MixTypeRegistry();

    group('hasMixType', () {
      test('returns true for EdgeInsetsGeometry', () {
        expect(registry.hasMixType('EdgeInsetsGeometry'), isTrue);
      });

      test('returns true for Decoration', () {
        expect(registry.hasMixType('Decoration'), isTrue);
      });

      test('returns false for Color', () {
        expect(registry.hasMixType('Color'), isFalse);
      });

      test('returns false for AlignmentGeometry', () {
        expect(registry.hasMixType('AlignmentGeometry'), isFalse);
      });
    });

    group('getMixType', () {
      test('returns EdgeInsetsGeometryMix for EdgeInsetsGeometry', () {
        expect(
          registry.getMixType('EdgeInsetsGeometry'),
          equals('EdgeInsetsGeometryMix'),
        );
      });

      test('returns DecorationMix for Decoration', () {
        expect(registry.getMixType('Decoration'), equals('DecorationMix'));
      });

      test('returns null for Color', () {
        expect(registry.getMixType('Color'), isNull);
      });
    });

    group('hasListMixType', () {
      test('returns true for ShadowMix', () {
        expect(registry.hasListMixType('ShadowMix'), isTrue);
      });

      test('returns false for Shadow', () {
        expect(registry.hasListMixType('Shadow'), isFalse);
      });
    });

    group('getListMixType', () {
      test('returns ShadowListMix for ShadowMix', () {
        expect(registry.getListMixType('ShadowMix'), equals('ShadowListMix'));
      });

      test('returns BoxShadowListMix for BoxShadowMix', () {
        expect(
          registry.getListMixType('BoxShadowMix'),
          equals('BoxShadowListMix'),
        );
      });

      test('returns null for Shadow', () {
        expect(registry.getListMixType('Shadow'), isNull);
      });
    });

    group('getListElementMixType', () {
      test('returns ShadowMix for Shadow', () {
        expect(registry.getListElementMixType('Shadow'), equals('ShadowMix'));
      });

      test('returns BoxShadowMix for BoxShadow', () {
        expect(
          registry.getListElementMixType('BoxShadow'),
          equals('BoxShadowMix'),
        );
      });

      test('returns null for String', () {
        expect(registry.getListElementMixType('String'), isNull);
      });
    });

    group('isDirectType', () {
      test('returns true for double', () {
        expect(registry.isDirectType('double'), isTrue);
      });

      test('returns true for Color', () {
        expect(registry.isDirectType('Color'), isTrue);
      });

      test('returns true for AlignmentGeometry', () {
        expect(registry.isDirectType('AlignmentGeometry'), isTrue);
      });

      test('returns false for EdgeInsetsGeometry', () {
        expect(registry.isDirectType('EdgeInsetsGeometry'), isFalse);
      });
    });

    group('isEnumType', () {
      test('returns true for Clip', () {
        expect(registry.isEnumType('Clip'), isTrue);
      });

      test('returns true for TextAlign', () {
        expect(registry.isEnumType('TextAlign'), isTrue);
      });

      test('returns false for Color', () {
        expect(registry.isEnumType('Color'), isFalse);
      });
    });

    group('isLerpableType', () {
      test('returns true for double', () {
        expect(registry.isLerpableType('double'), isTrue);
      });

      test('returns true for Color', () {
        expect(registry.isLerpableType('Color'), isTrue);
      });

      test('returns true for EdgeInsetsGeometry', () {
        expect(registry.isLerpableType('EdgeInsetsGeometry'), isTrue);
      });

      test('returns true for Matrix4', () {
        expect(registry.isLerpableType('Matrix4'), isTrue);
      });

      test('returns false for String', () {
        expect(registry.isLerpableType('String'), isFalse);
      });
    });

    group('isSnappableType', () {
      test('returns true for bool', () {
        expect(registry.isSnappableType('bool'), isTrue);
      });

      test('returns true for String', () {
        expect(registry.isSnappableType('String'), isTrue);
      });

      test('returns true for Clip (enum)', () {
        expect(registry.isSnappableType('Clip'), isTrue);
      });

      test('returns false for Color', () {
        expect(registry.isSnappableType('Color'), isFalse);
      });
    });

    group('isRawListField', () {
      test('returns true for textDirectives', () {
        expect(registry.isRawListField('textDirectives'), isTrue);
      });

      test('returns false for shadows', () {
        expect(registry.isRawListField('shadows'), isFalse);
      });
    });

    group('getRawListElementType', () {
      test('returns Directive<String> for textDirectives', () {
        expect(
          registry.getRawListElementType('textDirectives'),
          equals('Directive<String>'),
        );
      });

      test('returns null for shadows', () {
        expect(registry.getRawListElementType('shadows'), isNull);
      });
    });

    group('getPropWrapperKind', () {
      test('returns none for raw list field', () {
        final kind = registry.getPropWrapperKind(
          'List<Directive<String>>',
          isList: true,
          listElementType: 'Directive<String>',
          fieldName: 'textDirectives',
        );
        expect(kind, equals(PropWrapperKind.none));
      });

      test('returns listMix for List<Shadow>', () {
        final kind = registry.getPropWrapperKind(
          'List<Shadow>',
          isList: true,
          listElementType: 'Shadow',
          fieldName: 'shadows',
        );
        expect(kind, equals(PropWrapperKind.listMix));
      });

      test('returns maybeMix for EdgeInsetsGeometry', () {
        final kind = registry.getPropWrapperKind(
          'EdgeInsetsGeometry',
          isList: false,
          listElementType: null,
          fieldName: 'padding',
        );
        expect(kind, equals(PropWrapperKind.maybeMix));
      });

      test('returns maybe for Color', () {
        final kind = registry.getPropWrapperKind(
          'Color',
          isList: false,
          listElementType: null,
          fieldName: 'color',
        );
        expect(kind, equals(PropWrapperKind.maybe));
      });

      test('returns maybe for Clip (enum)', () {
        final kind = registry.getPropWrapperKind(
          'Clip',
          isList: false,
          listElementType: null,
          fieldName: 'clipBehavior',
        );
        expect(kind, equals(PropWrapperKind.maybe));
      });
    });
  });
}
