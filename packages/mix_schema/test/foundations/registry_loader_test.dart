import 'package:mix_schema/mix_schema.dart';
import 'package:test/test.dart';

import '_helpers.dart';

void main() {
  late MixSchemaAssets assets;

  setUpAll(() {
    assets = MixSchemaAssets.fromFiles(testAssetsDir);
  });

  group('Registry.tokenNamespaces', () {
    test('contains all 8 built-in namespaces', () {
      expect(
        assets.registry.tokenNamespaces.keys,
        unorderedEquals(<String>[
          'color',
          'radius',
          'space',
          'double',
          'breakpoint',
          'text',
          'borderSide',
          'shadow',
        ]),
      );
    });

    test('binds each namespace to a non-empty target type', () {
      for (final entry in assets.registry.tokenNamespaces.entries) {
        expect(
          entry.value.type,
          isNotEmpty,
          reason: 'token namespace ${entry.key} has empty type',
        );
      }
    });
  });

  group('Registry.enums', () {
    test('every enum has a non-empty value list', () {
      expect(assets.registry.enums, isNotEmpty);
      for (final entry in assets.registry.enums.entries) {
        expect(
          entry.value,
          isNotEmpty,
          reason: 'enum ${entry.key} has no values',
        );
      }
    });

    test('FontWeight enum carries the canonical w100..w900', () {
      expect(
        assets.registry.enums['FontWeight'],
        equals(<String>[
          'w100',
          'w200',
          'w300',
          'w400',
          'w500',
          'w600',
          'w700',
          'w800',
          'w900',
        ]),
      );
    });
  });

  group('Registry.enumAliases', () {
    test('has FontWeight aliases (Decision #36)', () {
      final fw = assets.registry.enumAliases['FontWeight'];
      expect(fw, isNotNull);
      expect(fw!['normal'], 'w400');
      expect(fw['bold'], 'w700');
    });
  });

  group('Registry.specs', () {
    test('contains all 8 specs', () {
      expect(
        assets.registry.specs.keys,
        unorderedEquals(<String>[
          'box',
          'flex',
          'text',
          'icon',
          'image',
          'stack',
          'flexbox',
          'stackbox',
        ]),
      );
    });

    test('flexbox and stackbox are composite', () {
      expect(assets.registry.specs['flexbox']!.isComposite, isTrue);
      expect(assets.registry.specs['flexbox']!.composite, equals(['box', 'flex']));
      expect(assets.registry.specs['stackbox']!.isComposite, isTrue);
      expect(
        assets.registry.specs['stackbox']!.composite,
        equals(['box', 'stack']),
      );
    });

    test('leaf specs have non-empty props', () {
      for (final spec in const ['box', 'flex', 'text', 'icon', 'image', 'stack']) {
        expect(
          assets.registry.specs[spec]!.props,
          isNotEmpty,
          reason: 'spec $spec has no props',
        );
      }
    });

    test('text spec carries spec-level textDirectives', () {
      expect(assets.registry.specs['text']!.specLevel, contains('textDirectives'));
    });
  });

  group('Registry.modifiers', () {
    test('contains 30 modifiers', () {
      expect(assets.registry.modifiers, hasLength(30));
    });

    test('reset modifier exists with empty props', () {
      final reset = assets.registry.modifiers['reset'];
      expect(reset, isNotNull);
      expect(reset!.props, isEmpty);
    });

    test('box and defaultTextStyler modifiers carry styleNode props', () {
      expect(
        assets.registry.modifiers['box']!.props['style']!.kind,
        'styleNode',
      );
      expect(
        assets.registry.modifiers['defaultTextStyler']!.props['style']!.kind,
        'styleNode',
      );
    });
  });

  group('Registry.directives', () {
    test('groups by target type — color, string, number', () {
      expect(
        assets.registry.directives.keys,
        unorderedEquals(<String>['color', 'string', 'number']),
      );
    });

    test('color has 13 ops, string has 5, number has 9 — total 27', () {
      expect(assets.registry.directives['color'], hasLength(13));
      expect(assets.registry.directives['string'], hasLength(5));
      expect(assets.registry.directives['number'], hasLength(9));
    });
  });

  group('Registry.literals', () {
    test('contains all 19 v1.0 literals', () {
      expect(
        assets.registry.literals.keys,
        unorderedEquals(<String>[
          'EdgeInsets',
          'BorderRadius',
          'BoxConstraints',
          'Size',
          'Offset',
          'Rect',
          'Alignment',
          'Matrix4',
          'Shadow',
          'BorderSide',
          'Border',
          'Decoration',
          'Gradient',
          'TextStyle',
          'StrutStyle',
          'TextScaler',
          'TextHeightBehavior',
          'Icon',
          'Image',
        ]),
      );
    });

    test('discriminated literals expose their kinds', () {
      final discriminated = const ['Gradient', 'Matrix4', 'TextScaler', 'Icon', 'Image'];
      for (final name in discriminated) {
        final lit = assets.registry.literals[name]!;
        expect(
          lit.isDiscriminated,
          isTrue,
          reason: '$name should be discriminated',
        );
        expect(
          lit.kinds,
          isNotNull,
          reason: '$name should expose kinds',
        );
      }
    });

    test('Alignment exposes 9 presets', () {
      expect(assets.registry.literals['Alignment']!.presets, hasLength(9));
    });
  });
}
