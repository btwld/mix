import 'package:mix_generator/src/core/curated/type_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('TypeMetadata', () {
    test('registry is immutable', () {
      expect(
        () => typeMetadata['Anything'] = const TypeMetadata(
          category: TypeCategory.snappable,
        ),
        throwsUnsupportedError,
      );
    });

    group('mix types', () {
      test('contains Flutter type to Mix type mappings', () {
        expect(mixTypeFor('EdgeInsetsGeometry'), 'EdgeInsetsGeometryMix');
        expect(mixTypeFor('BoxConstraints'), 'BoxConstraintsMix');
        expect(mixTypeFor('Decoration'), 'DecorationMix');
        expect(mixTypeFor('TextStyle'), 'TextStyleMix');
        expect(mixTypeFor('Shadow'), 'ShadowMix');
      });

      test('returns null for direct types without Mix variants', () {
        expect(mixTypeFor('Color'), isNull);
        expect(mixTypeFor('AlignmentGeometry'), isNull);
      });
    });

    group('list mappings', () {
      test('contains Mix element to ListMix mappings', () {
        expect(listMixTypeFor('ShadowMix'), 'ShadowListMix');
        expect(listMixTypeFor('BoxShadowMix'), 'BoxShadowListMix');
      });

      test('contains Flutter element to Mix element mappings', () {
        expect(listElementMixTypeFor('Shadow'), 'ShadowMix');
        expect(listElementMixTypeFor('BoxShadow'), 'BoxShadowMix');
      });
    });

    group('classification', () {
      test('identifies enum types', () {
        expect(isEnumType('Clip'), isTrue);
        expect(isEnumType('TextAlign'), isTrue);
        expect(isEnumType('BoxFit'), isTrue);
        expect(isEnumType('Color'), isFalse);
      });

      test('identifies lerpable types', () {
        expect(isLerpableType('double'), isTrue);
        expect(isLerpableType('Color'), isTrue);
        expect(isLerpableType('EdgeInsetsGeometry'), isTrue);
        expect(isLerpableType('Matrix4'), isTrue);
        expect(isLerpableType('String'), isFalse);
      });

      test('identifies snappable types', () {
        expect(isSnappableType('bool'), isTrue);
        expect(isSnappableType('String'), isTrue);
        expect(isSnappableType('IconData'), isTrue);
        expect(isSnappableType('Clip'), isTrue);
        expect(isSnappableType('Color'), isFalse);
      });
    });

    group('diagnostics', () {
      test('returns diagnostic kinds from metadata', () {
        expect(diagnosticKindFor('Color', isList: false), DiagnosticKind.color);
        expect(
          diagnosticKindFor('double', isList: false),
          DiagnosticKind.doubleProperty,
        );
        expect(
          diagnosticKindFor('Clip', isList: false),
          DiagnosticKind.enumProperty,
        );
        expect(
          diagnosticKindFor('Shadow', isList: true),
          DiagnosticKind.iterableProperty,
        );
      });

      test('contains curated flag descriptions', () {
        expect(flagDescriptionFor('softWrap'), 'wrapping at word boundaries');
        expect(
          flagDescriptionFor('excludeFromSemantics'),
          'excluded from semantics',
        );
        expect(flagDescriptionFor('gaplessPlayback'), 'gapless playback');
        expect(flagDescriptionFor('isAntiAlias'), 'anti-aliased');
        expect(
          flagDescriptionFor('matchTextDirection'),
          'matches text direction',
        );
        expect(flagDescriptionFor('applyTextScaling'), 'scales with text');
        expect(flagDescriptionFor('unknownField'), isNull);
      });
    });

    group('raw lists and aliases', () {
      test('recognizes raw list fields', () {
        expect(isRawListField('textDirectives'), isTrue);
        expect(rawListElementTypeFor('textDirectives'), 'Directive<String>');
        expect(isRawListField('shadows'), isFalse);
        expect(rawListElementTypeFor('shadows'), isNull);
      });

      test('contains TextStyler textDirectives alias', () {
        final alias = fieldAliasMap['TextStyler.textDirectives'];
        expect(alias, isNotNull);
        expect(alias!.diagnosticLabel, 'directives');
        expect(alias.setterName, isNull);
      });
    });

    group('ownerMixinsFor', () {
      test('returns SpacingStyleMixin for EdgeInsetsGeometry', () {
        expect(ownerMixinsFor('EdgeInsetsGeometry'), ['SpacingStyleMixin']);
      });

      test('returns ConstraintStyleMixin for BoxConstraints', () {
        expect(ownerMixinsFor('BoxConstraints'), ['ConstraintStyleMixin']);
      });

      test('returns Decoration mixin fan-out for Decoration', () {
        expect(
          ownerMixinsFor('Decoration'),
          containsAll([
            'DecorationStyleMixin',
            'BorderStyleMixin',
            'BorderRadiusStyleMixin',
            'ShadowStyleMixin',
          ]),
        );
      });

      test('returns TransformStyleMixin for Matrix4', () {
        expect(ownerMixinsFor('Matrix4'), ['TransformStyleMixin']);
      });

      test('returns empty for Clip', () {
        expect(ownerMixinsFor('Clip'), isEmpty);
      });

      test('returns empty for unknown type', () {
        expect(ownerMixinsFor('NoSuchType'), isEmpty);
      });
    });
  });
}
