import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/figma/figma_variables_document.dart';
import 'package:mix_figma/src/core/mapping/float_disambiguation.dart';
import 'package:mix_figma/src/core/mapping/mix_figma_config.dart';
import 'package:mix_figma/src/core/mapping/name_mapper.dart';

void main() {
  group('MixFigmaNameMapper', () {
    test('maps slash-delimited Figma names to protocol names and back', () {
      expect(
        MixFigmaNameMapper.figmaToMix('color/brand/primary'),
        'color.brand.primary',
      );
      expect(
        MixFigmaNameMapper.mixToFigma('color.brand.primary'),
        'color/brand/primary',
      );
    });

    test('rejects names outside the protocol grammar', () {
      expect(
        () => MixFigmaNameMapper.figmaToMix('color/brand primary'),
        throwsFormatException,
      );
      expect(() => MixFigmaNameMapper.mixToFigma(''), throwsFormatException);
    });
  });

  group('FLOAT disambiguation', () {
    test('uses the five evidence tiers in priority order', () {
      final stamped = disambiguateFloatVariable(
        _variable(
          id: 'stamped',
          codeSyntax: const {'WEB': 'mix://spaces/layout.gap'},
          scopes: const ['CORNER_RADIUS'],
        ),
        collection: _collection('Generic'),
      );
      expect(stamped.group, MixFigmaFloatGroup.spaces);
      expect(stamped.confidence, MixFigmaMappingConfidence.stamped);

      final scoped = disambiguateFloatVariable(
        _variable(id: 'scoped', scopes: const ['CORNER_RADIUS']),
        collection: _collection('Generic'),
      );
      expect(scoped.group, MixFigmaFloatGroup.radii);
      expect(scoped.confidence, MixFigmaMappingConfidence.scope);

      final conventional = disambiguateFloatVariable(
        _variable(id: 'collection'),
        collection: _collection('Font Weights'),
      );
      expect(conventional.group, MixFigmaFloatGroup.fontWeights);
      expect(conventional.confidence, MixFigmaMappingConfidence.collection);

      final configured = disambiguateFloatVariable(
        _variable(id: 'configured'),
        collection: _collection('Generic'),
        config: const MixFigmaConfig(
          floatGroupsByVariable: {'configured': MixFigmaFloatGroup.radii},
        ),
      );
      expect(configured.group, MixFigmaFloatGroup.radii);
      expect(configured.confidence, MixFigmaMappingConfidence.config);

      final fallback = disambiguateFloatVariable(
        _variable(id: 'fallback'),
        collection: _collection('Generic'),
      );
      expect(fallback.group, MixFigmaFloatGroup.doubles);
      expect(fallback.confidence, MixFigmaMappingConfidence.fallback);
      expect(fallback.diagnostics.single.code, 'ambiguous_float_variable');
      expect(fallback.diagnostics.single.severity.name, 'warning');
    });

    test('parses YAML overrides', () {
      final config = MixFigmaConfig.fromYaml('''
floatGroups:
  variables:
    variable-1: spaces
  collections:
    collection-1: radii
''');

      expect(
        config.floatGroupsByVariable['variable-1'],
        MixFigmaFloatGroup.spaces,
      );
      expect(
        config.floatGroupsByCollection['collection-1'],
        MixFigmaFloatGroup.radii,
      );
    });
  });
}

FigmaVariable _variable({
  required String id,
  List<String> scopes = const [],
  Map<String, String> codeSyntax = const {},
}) => FigmaVariable(
  id: id,
  name: 'value/$id',
  collectionId: 'collection',
  resolvedType: FigmaVariableType.float,
  valuesByMode: const {'light': 8.0},
  scopes: scopes,
  codeSyntax: codeSyntax,
);

FigmaVariableCollection _collection(String name) => FigmaVariableCollection(
  id: 'collection',
  name: name,
  defaultModeId: 'light',
  modes: const [FigmaVariableMode(id: 'light', name: 'Light')],
);
