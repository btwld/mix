import 'package:mix_generator/src/core/curated/type_mappings.dart';
import 'package:test/test.dart';

void main() {
  group('Type Mappings', () {
    group('mixTypeMap', () {
      test('contains EdgeInsetsGeometry -> EdgeInsetsGeometryMix', () {
        expect(
          mixTypeMap['EdgeInsetsGeometry'],
          equals('EdgeInsetsGeometryMix'),
        );
      });

      test('contains BoxConstraints -> BoxConstraintsMix', () {
        expect(mixTypeMap['BoxConstraints'], equals('BoxConstraintsMix'));
      });

      test('contains Decoration -> DecorationMix', () {
        expect(mixTypeMap['Decoration'], equals('DecorationMix'));
      });

      test('contains TextStyle -> TextStyleMix', () {
        expect(mixTypeMap['TextStyle'], equals('TextStyleMix'));
      });

      test('contains Shadow -> ShadowMix', () {
        expect(mixTypeMap['Shadow'], equals('ShadowMix'));
      });

      test('does NOT contain direct types like Color', () {
        expect(mixTypeMap.containsKey('Color'), isFalse);
      });

      test('does NOT contain direct types like AlignmentGeometry', () {
        expect(mixTypeMap.containsKey('AlignmentGeometry'), isFalse);
      });
    });

    group('listMixTypeMap', () {
      test('contains ShadowMix -> ShadowListMix', () {
        expect(listMixTypeMap['ShadowMix'], equals('ShadowListMix'));
      });

      test('contains BoxShadowMix -> BoxShadowListMix', () {
        expect(listMixTypeMap['BoxShadowMix'], equals('BoxShadowListMix'));
      });
    });

    group('listElementMixTypeMap', () {
      test('contains Shadow -> ShadowMix', () {
        expect(listElementMixTypeMap['Shadow'], equals('ShadowMix'));
      });

      test('contains BoxShadow -> BoxShadowMix', () {
        expect(listElementMixTypeMap['BoxShadow'], equals('BoxShadowMix'));
      });
    });

    group('directTypes', () {
      test('contains double', () {
        expect(directTypes.contains('double'), isTrue);
      });

      test('contains int', () {
        expect(directTypes.contains('int'), isTrue);
      });

      test('contains bool', () {
        expect(directTypes.contains('bool'), isTrue);
      });

      test('contains String', () {
        expect(directTypes.contains('String'), isTrue);
      });

      test('contains AlignmentGeometry', () {
        expect(directTypes.contains('AlignmentGeometry'), isTrue);
      });

      test('contains Matrix4', () {
        expect(directTypes.contains('Matrix4'), isTrue);
      });

      test('contains Color', () {
        expect(directTypes.contains('Color'), isTrue);
      });
    });

    group('enumTypes', () {
      test('contains Clip', () {
        expect(enumTypes.contains('Clip'), isTrue);
      });

      test('contains Axis', () {
        expect(enumTypes.contains('Axis'), isTrue);
      });

      test('contains TextAlign', () {
        expect(enumTypes.contains('TextAlign'), isTrue);
      });

      test('contains BoxFit', () {
        expect(enumTypes.contains('BoxFit'), isTrue);
      });

      test('contains BlendMode', () {
        expect(enumTypes.contains('BlendMode'), isTrue);
      });
    });

    group('lerpableTypes', () {
      test('contains double', () {
        expect(lerpableTypes.contains('double'), isTrue);
      });

      test('contains Color', () {
        expect(lerpableTypes.contains('Color'), isTrue);
      });

      test('contains EdgeInsetsGeometry', () {
        expect(lerpableTypes.contains('EdgeInsetsGeometry'), isTrue);
      });

      test('contains AlignmentGeometry', () {
        expect(lerpableTypes.contains('AlignmentGeometry'), isTrue);
      });

      test('contains Matrix4', () {
        expect(lerpableTypes.contains('Matrix4'), isTrue);
      });

      test('contains Decoration', () {
        expect(lerpableTypes.contains('Decoration'), isTrue);
      });

      test('contains Shadow', () {
        expect(lerpableTypes.contains('Shadow'), isTrue);
      });
    });

    group('snappableTypes', () {
      test('contains bool', () {
        expect(snappableTypes.contains('bool'), isTrue);
      });

      test('contains String', () {
        expect(snappableTypes.contains('String'), isTrue);
      });

      test('contains IconData', () {
        expect(snappableTypes.contains('IconData'), isTrue);
      });

      test('contains TextScaler', () {
        expect(snappableTypes.contains('TextScaler'), isTrue);
      });
    });

    group('rawListTypes', () {
      test('textDirectives is a raw list field', () {
        expect(rawListTypes.containsKey('textDirectives'), isTrue);
        expect(rawListTypes['textDirectives'], equals('Directive<String>'));
      });
    });

    group('fieldAliasMap', () {
      test('TextStyler.textDirectives has diagnosticLabel = directives', () {
        final alias = fieldAliasMap['TextStyler.textDirectives'];
        expect(alias, isNotNull);
        expect(alias!.diagnosticLabel, equals('directives'));
      });

      test('TextStyler.textDirectives has setterName = null (no setter)', () {
        final alias = fieldAliasMap['TextStyler.textDirectives'];
        expect(alias, isNotNull);
        expect(alias!.setterName, isNull);
      });
    });
  });
}
