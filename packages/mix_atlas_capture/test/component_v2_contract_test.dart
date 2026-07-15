import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' show SemanticsValidationResult, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart'
    show AtlasCaptureIndex, AtlasTokenUse;
import 'package:mix_atlas_capture/producer.dart';
import 'package:mix_atlas_capture/src/artifacts/capture_bundle.dart';
import 'package:mix_atlas_capture/src/artifacts/capture_loader.dart';
import 'package:mix_atlas_capture/src/artifacts/component_document.dart';
import 'package:mix_atlas_capture/src/artifacts/component_parser.dart';
import 'package:mix_atlas_capture/src/portable_component_renderer.dart';

import 'artifact_fixture.dart';

void main() {
  group('component/v2 contract', () {
    test(
      'builder projects every primitive into an embedded strict document',
      () {
        final builder = portableV2FixtureBuilder();
        final json = builder.buildJson();
        final document = builder.buildDocument();

        expect(json['schema'], 'mix_atlas/component/v2');
        expect(document.schema, ComponentDocumentSchema.v2);
        expect(
          document.properties.values.map((item) => item.kind),
          containsAll({
            ComponentPropertyKind.enumeration,
            ComponentPropertyKind.string,
            ComponentPropertyKind.boolean,
            ComponentPropertyKind.number,
            ComponentPropertyKind.duration,
            ComponentPropertyKind.icon,
          }),
        );
        expect(document.styleLibrary, hasLength(6));
        expect(
          document.anatomy.nodes.values.map((node) => node.kind),
          containsAll({
            ComponentAnatomyNodeKind.box,
            ComponentAnatomyNodeKind.flexBox,
            ComponentAnatomyNodeKind.stackBox,
            ComponentAnatomyNodeKind.text,
            ComponentAnatomyNodeKind.icon,
            ComponentAnatomyNodeKind.image,
            ComponentAnatomyNodeKind.spinner,
            ComponentAnatomyNodeKind.fractionalPosition,
            ComponentAnatomyNodeKind.nestedComponent,
          }),
        );
        expect(document.states['selectedError']!.widgetStates, {
          'selected',
          'error',
        });
        expect(
          document.semantics.bindings.keys,
          containsAll({'label', 'enabled', 'selected', 'liveRegion'}),
        );
        expect(document.diagnostics.single.code, 'runtime.callback_omitted');
        expect(jsonEncode(json), isNot(contains('Unsupported')));
      },
    );

    test('projector fails atomically for an unrepresentable style', () {
      const projector = AtlasCompositeStyleProjector();

      expect(
        () => projector.projectComposite(
          Object(),
          slots: (_) => {'root': Object()},
        ),
        throwsA(isA<AtlasPortableProjectionException>()),
      );
    });

    test('projector preserves token and widget-state style sources', () {
      const projector = AtlasCompositeStyleProjector();
      final payload = projector.projectStyle(
        BoxStyler()
            .color(const ColorToken('surface')())
            .onHovered(BoxStyler().color(Colors.blue)),
      );

      expect(jsonEncode(payload), contains(r'$token'));
      expect(jsonEncode(payload), contains('hovered'));
    });

    test('strict parser rejects unsafe binding references', () {
      final json = _deepCopy(portableV2FixtureBuilder().buildJson());
      final anatomy = json['anatomy']! as Map<String, Object?>;
      final nodes = anatomy['nodes']! as List<Object?>;
      final spinner = nodes.cast<Map<String, Object?>>().singleWhere(
        (node) => node['id'] == 'spinner',
      );
      final bindings = spinner['bindings']! as Map<String, Object?>;
      bindings['color'] = {'token': '../../secret'};

      expect(
        () => _parse(json),
        throwsA(
          isA<ArtifactLoadException>().having(
            (error) => error.kind,
            'kind',
            ArtifactFailureKind.invalidComponent,
          ),
        ),
      );
    });

    test('strict parser rejects statically unrenderable binding values', () {
      final invalidProgress = _deepCopy(portableV2FixtureBuilder().buildJson());
      final properties = (invalidProgress['properties']! as List<Object?>)
          .cast<Map<String, Object?>>();
      properties.singleWhere(
        (property) => property['id'] == 'progress',
      )['default'] = 2.0;

      expect(
        () => _parse(invalidProgress),
        throwsA(isA<ArtifactLoadException>()),
      );

      final invalidIcon = _deepCopy(portableV2FixtureBuilder().buildJson());
      final iconProperties = (invalidIcon['properties']! as List<Object?>)
          .cast<Map<String, Object?>>();
      iconProperties.singleWhere(
        (property) => property['id'] == 'icon',
      )['default'] = 'unregistered_icon';

      expect(() => _parse(invalidIcon), throwsA(isA<ArtifactLoadException>()));
    });

    test('strict parser enforces component-scoped style limits', () {
      final json = _deepCopy(portableV2FixtureBuilder().buildJson());
      json['styles'] = {
        for (var index = 0; index < 2049; index++)
          'style/$index': {'v': 1, 'type': 'box'},
      };

      expect(
        () => _parse(json),
        throwsA(
          isA<ArtifactLoadException>().having(
            (error) => error.kind,
            'kind',
            ArtifactFailureKind.malformedJson,
          ),
        ),
      );
    });

    test('component/v1 documents still translate into the runtime model', () {
      final document = _parse(validButtonComponentDocument());

      expect(document.schema, ComponentDocumentSchema.v1);
      expect(document.semantics.role, 'button');
      expect(document.semantics.bindings['label']!.propertyId, 'label');
    });

    testWidgets('loader and renderer cover every v2 primitive', (tester) async {
      final fixture = ArtifactFixture.create()
        ..addRenderedComponent(id: 'fixture', label: 'Fixture')
        ..addRenderedComponent(id: 'fixtureChild', label: 'Fixture Child');
      for (final theme in const ['light', 'dark']) {
        fixture.replaceJson(
          '$theme/fixture.json',
          _atlasMetadata(
            component: 'fixture',
            theme: theme,
            recipe: 'primary',
            states: const [
              (
                id: 'default',
                widgetStates: <String>[],
                props: <String, Object?>{},
              ),
              (
                id: 'selectedError',
                widgetStates: <String>['error', 'selected'],
                props: <String, Object?>{'invalid': true},
              ),
            ],
          ),
          rehash: false,
        );
        fixture.replaceJson(
          '$theme/fixtureChild.json',
          _atlasMetadata(
            component: 'fixtureChild',
            theme: theme,
            recipe: 'primary',
          ),
          rehash: false,
        );
      }
      fixture.files['images/fixture.png'] = Uint8List.fromList(
        fixture.files['light/fixture.png']!,
      );
      fixture.addPortableV2Capture({
        'fixture': portableV2FixtureBuilder().buildJson(),
        'fixtureChild': _simpleV2Builder(
          id: 'fixtureChild',
          label: 'Fixture Child',
          recipeId: 'primary',
          propertyIds: const {'label'},
        ).buildJson(),
      });
      final capture = await CaptureLoader(
        source: fixture.source(),
      ).load(fixtureRequest);
      final component = capture.componentDocuments.singleWhere(
        (document) => document.id == 'fixture',
      );

      expect(
        capture.atlasMetadata['fixture/light']!.rowAxes.single.id,
        'variant',
      );
      expect(capture.atlasMetadata['fixture/light']!.rows.single.id, 'primary');
      expect(
        capture.atlasMetadata['fixture/light']!.scenarios.last.widgetStates,
        {'error', 'selected'},
      );
      expect(capture.validatedStyleDocumentCount, greaterThanOrEqualTo(8));
      final index = AtlasCaptureIndex.build(capture);
      expect(
        index.tokenUses,
        contains(
          isA<AtlasTokenUse>()
              .having((use) => use.componentId, 'component', 'fixture')
              .having((use) => use.slotId, 'slot', 'spinner')
              .having((use) => use.property, 'property', 'binding.color')
              .having((use) => use.tokenName, 'token', 'fortal.accent.9'),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: PortableComponentRenderer(
              capture: capture,
              component: component,
              selection: const PortableComponentSelection(
                recipeId: 'primary',
                stateId: 'selectedError',
                themeId: 'light',
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(Box), findsWidgets);
      expect(find.byType(FlexBox), findsOneWidget);
      expect(find.byType(StackBox), findsOneWidget);
      expect(find.byType(StyledText), findsOneWidget);
      expect(find.byType(StyledIcon), findsOneWidget);
      expect(find.byType(StyledImage), findsOneWidget);
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(2));
      expect(find.byType(FractionallySizedBox), findsOneWidget);
      expect(
        find.byKey(const ValueKey('portable-component-fixtureChild')),
        findsOneWidget,
      );
      final semantics = tester.getSemantics(
        find.byKey(const ValueKey('portable-component-fixture')),
      );
      expect(semantics.label, 'Fixture');
      expect(semantics.flagsCollection.isButton, isTrue);
      expect(semantics.flagsCollection.isSelected, Tristate.isTrue);
      expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
      expect(semantics.flagsCollection.isRequired, Tristate.isTrue);
      expect(semantics.validationResult, SemanticsValidationResult.invalid);
      expect(find.textContaining('Unsupported'), findsNothing);
    });

    test('loader rejects nested component cycles', () async {
      final fixture = ArtifactFixture.create()
        ..addRenderedComponent(id: 'avatar', label: 'Avatar');
      fixture.addPortableV2Capture({
        'button': _simpleV2Builder(
          id: 'button',
          label: 'Button',
          recipeId: 'solid',
          nestedComponent: 'avatar',
        ).buildJson(),
        'avatar': _simpleV2Builder(
          id: 'avatar',
          label: 'Avatar',
          recipeId: 'solid',
          nestedComponent: 'button',
        ).buildJson(),
      });

      expect(
        () => CaptureLoader(source: fixture.source()).load(fixtureRequest),
        throwsA(
          isA<ArtifactLoadException>().having(
            (error) => error.kind,
            'kind',
            ArtifactFailureKind.invalidComponent,
          ),
        ),
      );
    });
  });
}

AtlasPortableComponentBuilder portableV2FixtureBuilder() {
  return AtlasPortableComponentBuilder(id: 'fixture', label: 'Fixture')
    ..property(
      ComponentPropertyDefinition(
        id: 'variant',
        kind: .enumeration,
        values: const ['primary'],
        defaultValue: 'primary',
        isRequired: true,
      ),
    )
    ..property(
      ComponentPropertyDefinition(
        id: 'label',
        kind: .string,
        defaultValue: 'Fixture',
        isRequired: true,
      ),
    )
    ..property(
      ComponentPropertyDefinition(
        id: 'enabled',
        kind: .boolean,
        defaultValue: true,
        isRequired: true,
      ),
    )
    ..property(
      ComponentPropertyDefinition(
        id: 'invalid',
        kind: .boolean,
        defaultValue: false,
        isRequired: true,
      ),
    )
    ..property(
      ComponentPropertyDefinition(
        id: 'progress',
        kind: .number,
        defaultValue: 0.5,
        isRequired: true,
      ),
    )
    ..property(
      ComponentPropertyDefinition(
        id: 'duration',
        kind: .duration,
        defaultValue: 200,
        isRequired: true,
      ),
    )
    ..property(
      ComponentPropertyDefinition(
        id: 'icon',
        kind: .icon,
        defaultValue: 'check',
        isRequired: true,
      ),
    )
    ..property(
      ComponentPropertyDefinition(
        id: 'image',
        kind: .string,
        defaultValue: 'images/fixture.png',
        isRequired: true,
      ),
    )
    ..property(
      ComponentPropertyDefinition(
        id: 'nestedRecipe',
        kind: .enumeration,
        values: const ['primary'],
        defaultValue: 'primary',
        isRequired: true,
      ),
    )
    ..state(
      ComponentStateDefinition(
        id: 'default',
        widgetStates: const {},
        propertyOverrides: const {},
      ),
    )
    ..state(
      ComponentStateDefinition(
        id: 'selectedError',
        widgetStates: const {'selected', 'error'},
        propertyOverrides: const {'invalid': true},
      ),
    )
    ..slot(const ComponentSlotDefinition(id: 'root', kind: .stackBox))
    ..slot(const ComponentSlotDefinition(id: 'box', kind: .box))
    ..slot(const ComponentSlotDefinition(id: 'text', kind: .text))
    ..slot(const ComponentSlotDefinition(id: 'flex', kind: .flexBox))
    ..slot(const ComponentSlotDefinition(id: 'icon', kind: .icon))
    ..slot(const ComponentSlotDefinition(id: 'image', kind: .image))
    ..node(
      AtlasPortableNode(
        id: 'root',
        kind: .stackBox,
        slotId: 'root',
        children: const ['box', 'flex', 'spinner', 'fractional', 'nested'],
      ),
    )
    ..node(
      AtlasPortableNode(
        id: 'box',
        kind: .box,
        slotId: 'box',
        children: const ['text'],
      ),
    )
    ..node(
      AtlasPortableNode(
        id: 'text',
        kind: .text,
        slotId: 'text',
        children: const [],
        bindings: const {'text': AtlasPortableBinding.property('label')},
      ),
    )
    ..node(
      AtlasPortableNode(
        id: 'flex',
        kind: .flexBox,
        slotId: 'flex',
        children: const ['icon', 'image'],
      ),
    )
    ..node(
      AtlasPortableNode(
        id: 'icon',
        kind: .icon,
        slotId: 'icon',
        children: const [],
        bindings: const {'icon': AtlasPortableBinding.property('icon')},
      ),
    )
    ..node(
      AtlasPortableNode(
        id: 'image',
        kind: .image,
        slotId: 'image',
        children: const [],
        bindings: const {'source': AtlasPortableBinding.property('image')},
      ),
    )
    ..node(
      AtlasPortableNode(
        id: 'spinner',
        kind: .spinner,
        children: const [],
        bindings: const {
          'value': AtlasPortableBinding.property('progress'),
          'strokeWidth': AtlasPortableBinding.literal(2.0),
          'trackStrokeWidth': AtlasPortableBinding.literal(1.0),
          'color': AtlasPortableBinding.token(
            kind: 'color',
            name: 'fortal.accent.9',
          ),
          'trackColor': AtlasPortableBinding.literal('#223344'),
          'size': AtlasPortableBinding.literal(16.0),
          'duration': AtlasPortableBinding.property('duration'),
        },
        visibleWhen: const ComponentVisibilityCondition.widgetState(
          state: 'selected',
          operator: .active,
        ),
      ),
    )
    ..node(
      AtlasPortableNode(
        id: 'fractional',
        kind: .fractionalPosition,
        children: const ['fractionalSpinner'],
        bindings: const {
          'widthFactor': AtlasPortableBinding.property('progress'),
          'alignment': AtlasPortableBinding.literal('centerLeft'),
        },
      ),
    )
    ..node(
      AtlasPortableNode(
        id: 'fractionalSpinner',
        kind: .spinner,
        children: const [],
        bindings: const {'size': AtlasPortableBinding.literal(8.0)},
      ),
    )
    ..node(
      AtlasPortableNode(
        id: 'nested',
        kind: .nestedComponent,
        children: const [],
        componentId: 'fixtureChild',
        recipeBinding: const AtlasPortableBinding.property('nestedRecipe'),
        stateBinding: const AtlasPortableBinding.literal('default'),
        propertyBindings: const {
          'label': AtlasPortableBinding.property('label'),
        },
      ),
    )
    ..root('root')
    ..recipe(
      id: 'primary',
      properties: const {'variant': 'primary'},
      styles: {
        'root': StackBoxStyler(),
        'box': BoxStyler(),
        'text': TextStyler(),
        'flex': FlexBoxStyler(),
        'icon': IconStyler(),
        'image': ImageStyler(),
      },
    )
    ..semantics(
      AtlasPortableSemantics(
        role: 'button',
        bindings: const {
          'label': AtlasPortableBinding.property('label'),
          'enabled': AtlasPortableBinding.property('enabled'),
          'selected': AtlasPortableBinding.literal(true),
          'required': AtlasPortableBinding.literal(true),
          'invalid': AtlasPortableBinding.property('invalid'),
          'liveRegion': AtlasPortableBinding.literal(false),
        },
      ),
    )
    ..oracle(
      const ComponentVisualOracle(
        themeId: 'light',
        imagePath: 'light/fixture.png',
        metadataPath: 'light/fixture.json',
        evidence: .rendered,
      ),
    )
    ..oracle(
      const ComponentVisualOracle(
        themeId: 'dark',
        imagePath: 'dark/fixture.png',
        metadataPath: 'dark/fixture.json',
        evidence: .rendered,
      ),
    )
    ..diagnostic(
      const ComponentDiagnostic(
        code: 'runtime.callback_omitted',
        severity: 'info',
        path: 'nested',
        message: 'Callbacks are intentionally not captured.',
      ),
    );
}

PortableComponentDocument _parse(Map<String, Object?> json) =>
    parsePortableComponentDocument(
      Uint8List.fromList(utf8.encode(jsonEncode(json))),
      path: 'fixture.component.json',
    );

Map<String, Object?> _deepCopy(Map<String, Object?> value) =>
    jsonDecode(jsonEncode(value)) as Map<String, Object?>;

AtlasPortableComponentBuilder _simpleV2Builder({
  required String id,
  required String label,
  required String recipeId,
  String? nestedComponent,
  Set<String> propertyIds = const {},
}) {
  final builder = AtlasPortableComponentBuilder(id: id, label: label)
    ..property(
      ComponentPropertyDefinition(
        id: 'variant',
        kind: .enumeration,
        values: [recipeId],
        defaultValue: recipeId,
        isRequired: true,
      ),
    );
  if (propertyIds.contains('label')) {
    builder.property(
      ComponentPropertyDefinition(
        id: 'label',
        kind: .string,
        defaultValue: label,
        isRequired: true,
      ),
    );
  }
  builder
    ..state(
      ComponentStateDefinition(
        id: 'default',
        widgetStates: const {},
        propertyOverrides: const {},
      ),
    )
    ..slot(const ComponentSlotDefinition(id: 'root', kind: .box))
    ..node(
      AtlasPortableNode(
        id: 'root',
        kind: .box,
        slotId: 'root',
        children: nestedComponent == null ? const [] : const ['nested'],
      ),
    );
  if (nestedComponent != null) {
    builder.node(
      AtlasPortableNode(
        id: 'nested',
        kind: .nestedComponent,
        children: const [],
        componentId: nestedComponent,
        recipeBinding: AtlasPortableBinding.literal(recipeId),
        stateBinding: const AtlasPortableBinding.literal('default'),
      ),
    );
  }
  return builder
    ..root('root')
    ..recipe(
      id: recipeId,
      properties: {'variant': recipeId},
      styles: {'root': BoxStyler()},
    )
    ..semantics(AtlasPortableSemantics(role: 'none'))
    ..oracle(
      ComponentVisualOracle(
        themeId: 'light',
        imagePath: 'light/$id.png',
        metadataPath: 'light/$id.json',
        evidence: .rendered,
      ),
    )
    ..oracle(
      ComponentVisualOracle(
        themeId: 'dark',
        imagePath: 'dark/$id.png',
        metadataPath: 'dark/$id.json',
        evidence: .rendered,
      ),
    );
}

Map<String, Object?> _atlasMetadata({
  required String component,
  required String theme,
  required String recipe,
  List<({String id, List<String> widgetStates, Map<String, Object?> props})>
  states = const [
    (id: 'default', widgetStates: <String>[], props: <String, Object?>{}),
  ],
}) => {
  'schema': 'mix_atlas/atlas/v1',
  'component': component,
  'componentLabel': component,
  'theme': theme,
  'themeLabel': theme,
  'brightness': theme,
  'file': '$component.png',
  'rowAxes': [
    {'id': 'variant', 'label': 'Variant'},
  ],
  'rows': [
    {
      'id': recipe,
      'values': {
        'variant': {'id': recipe, 'label': recipe},
      },
    },
  ],
  'columns': [
    for (final state in states)
      {'id': state.id, 'states': state.widgetStates, 'props': state.props},
  ],
};
