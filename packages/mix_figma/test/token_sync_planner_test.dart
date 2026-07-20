import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/figma/figma_styles_document.dart';
import 'package:mix_figma/src/core/figma/figma_variables_document.dart';
import 'package:mix_figma/src/core/figma/figma_variables_parser.dart';
import 'package:mix_figma/src/core/identity/mix_figma_lock.dart';
import 'package:mix_figma/src/core/protocol_json/figma_style_payloads.dart';
import 'package:mix_figma/src/core/protocol_json/figma_variable_payload.dart';
import 'package:mix_figma/src/core/sync/sync_plan.dart';
import 'package:mix_figma/src/core/sync/token_sync_planner.dart';

void main() {
  final theme = <String, Object?>{
    'v': 1,
    'type': 'theme',
    'colors': {
      'color.base': '#112233',
      'color.alias': {r'$token': 'color.base'},
    },
    'spaces': {'space.sm': 8},
    'textStyles': {
      'type.body': {
        'fontFamily': 'Inter',
        'fontSize': 14,
        'fontWeight': 'w400',
        'height': 1.4,
      },
    },
  };

  test('matching token state produces an idempotent preview', () {
    final desiredVariables = buildFigmaVariableWritePayload({
      'light': theme,
    }).value;
    final desiredStyles = buildFigmaStylePayloads(theme).value;
    final plan = buildTokenPushSyncPlan(
      currentVariables: figmaVariablesDocumentFromWritePayload(
        desiredVariables,
      ),
      currentStyles: figmaStylesDocumentFromWritePayload(desiredStyles),
      desiredVariables: desiredVariables,
      desiredStyles: desiredStyles,
    );

    expect(plan.direction, MixFigmaSyncDirection.mixToFigma);
    expect(plan.resource, MixFigmaSyncResource.tokens);
    expect(
      plan.operations.where(
        (item) =>
            item.action != MixFigmaSyncAction.unchanged &&
            item.action != MixFigmaSyncAction.skip,
      ),
      isEmpty,
    );
  });

  test('native text style defaults do not create false drift', () {
    final desiredVariables = buildFigmaVariableWritePayload({
      'light': theme,
    }).value;
    final desiredStyles = buildFigmaStylePayloads(theme).value;
    final generated = figmaStylesDocumentFromWritePayload(desiredStyles);
    final textStyle = generated.styles.single;
    final currentStyles = FigmaStylesDocument(
      styles: [
        FigmaStyle(
          id: textStyle.id,
          key: textStyle.key,
          name: textStyle.name,
          type: textStyle.type,
          value: {
            ...textStyle.value,
            'leadingTrim': 'NONE',
            'paragraphIndent': 0,
            'paragraphSpacing': 0,
            'listSpacing': 0,
            'hangingPunctuation': false,
            'hangingList': false,
            'textCase': 'ORIGINAL',
            'textDecoration': 'NONE',
          },
          pluginData: textStyle.pluginData,
          description: textStyle.description,
        ),
      ],
    );
    final plan = buildTokenPushSyncPlan(
      currentVariables: figmaVariablesDocumentFromWritePayload(
        desiredVariables,
      ),
      currentStyles: currentStyles,
      desiredVariables: desiredVariables,
      desiredStyles: desiredStyles,
    );

    expect(
      plan.operations.singleWhere((item) => item.kind == 'textStyle').action,
      MixFigmaSyncAction.unchanged,
    );
  });

  test('Figma numeric normalization does not create false drift', () {
    final desiredVariables = buildFigmaVariableWritePayload({
      'light': theme,
    }).value;
    final currentVariableJson = figmaVariablesDocumentFromWritePayload(
      desiredVariables,
    ).toJson();
    final baseVariable = (currentVariableJson['variables']! as List)
        .cast<Map>()
        .singleWhere((item) => item['name'] == 'color/base');
    final baseColor =
        ((baseVariable['valuesByMode']! as Map).values.single as Map)
            .cast<String, Object?>();
    baseColor['r'] = (baseColor['r']! as num).toDouble() + 1e-8;
    baseColor['a'] = 1;

    final desiredStyles = buildFigmaStylePayloads(theme).value;
    final generatedStyles = figmaStylesDocumentFromWritePayload(desiredStyles);
    final generatedTextStyle = generatedStyles.styles.single;
    final currentStyles = FigmaStylesDocument(
      styles: [
        FigmaStyle(
          id: generatedTextStyle.id,
          key: generatedTextStyle.key,
          name: generatedTextStyle.name,
          type: generatedTextStyle.type,
          value: {
            ...generatedTextStyle.value,
            'lineHeight': {'unit': 'PERCENT', 'value': 140},
          },
          pluginData: generatedTextStyle.pluginData,
          description: generatedTextStyle.description,
        ),
      ],
    );

    final plan = buildTokenPushSyncPlan(
      currentVariables: parseFigmaVariablesDocument(currentVariableJson),
      currentStyles: currentStyles,
      desiredVariables: desiredVariables,
      desiredStyles: desiredStyles,
    );

    expect(
      plan.operations.where(
        (item) => item.action != MixFigmaSyncAction.unchanged,
      ),
      isEmpty,
    );
  });

  test('native effect defaults inside lists do not create false drift', () {
    final shadowTheme = <String, Object?>{
      ...theme,
      'boxShadows': {
        'elevation.overlay': [
          {
            'color': '#99000000',
            'offset': {'x': 0, 'y': 16},
            'blurRadius': 40,
            'spreadRadius': 0,
          },
        ],
      },
    };
    final desiredVariables = buildFigmaVariableWritePayload({
      'light': shadowTheme,
    }).value;
    final desiredStyles = buildFigmaStylePayloads(shadowTheme).value;
    final generatedStyles = figmaStylesDocumentFromWritePayload(desiredStyles);
    final currentStyles = FigmaStylesDocument(
      styles: [
        for (final style in generatedStyles.styles)
          FigmaStyle(
            id: style.id,
            key: style.key,
            name: style.name,
            type: style.type,
            value: style.type == FigmaStyleType.effect
                ? {
                    'effects': [
                      for (final effect in style.value['effects']! as List)
                        {
                          ...(effect! as Map),
                          'boundVariables': <String, Object?>{},
                          'showShadowBehindNode': true,
                        },
                    ],
                  }
                : style.value,
            pluginData: style.pluginData,
            description: style.description,
          ),
      ],
    );

    final plan = buildTokenPushSyncPlan(
      currentVariables: figmaVariablesDocumentFromWritePayload(
        desiredVariables,
      ),
      currentStyles: currentStyles,
      desiredVariables: desiredVariables,
      desiredStyles: desiredStyles,
    );

    expect(
      plan.operations.singleWhere((item) => item.kind == 'effectStyle').action,
      MixFigmaSyncAction.unchanged,
    );
  });

  test('stale source ids never adopt unowned resources', () {
    final lock = MixFigmaLock(
      collectionIds: const {'Mix Tokens': 'collection:user'},
      variableIds: const {
        'colors/color.base': 'variable:user-base',
        'colors/color.alias': 'variable:user-alias',
        'spaces/space.sm': 'variable:user-space',
      },
      styleIds: const {'textStyles/type.body': 'style:user'},
    );
    final desiredVariables = buildFigmaVariableWritePayload({
      'light': theme,
    }, lock: lock).value;
    final generatedVariables = figmaVariablesDocumentFromWritePayload(
      desiredVariables,
    );
    final currentVariables = FigmaVariablesDocument(
      collections: [
        for (final collection in generatedVariables.collections)
          FigmaVariableCollection(
            id: collection.id,
            key: collection.key,
            name: collection.name,
            defaultModeId: collection.defaultModeId,
            modes: collection.modes,
          ),
      ],
      variables: [
        for (final variable in generatedVariables.variables)
          FigmaVariable(
            id: variable.id,
            name: variable.name,
            collectionId: variable.collectionId,
            resolvedType: variable.resolvedType,
            valuesByMode: variable.valuesByMode,
            scopes: variable.scopes,
            codeSyntax: variable.codeSyntax,
            description: variable.description,
          ),
      ],
    );
    final desiredStyles = buildFigmaStylePayloads(theme, lock: lock).value;
    final generatedStyles = figmaStylesDocumentFromWritePayload(desiredStyles);
    final currentStyles = FigmaStylesDocument(
      styles: [
        for (final style in generatedStyles.styles)
          FigmaStyle(
            id: style.id,
            key: style.key,
            name: style.name,
            type: style.type,
            value: style.value,
            description: style.description,
          ),
      ],
    );
    final plan = buildTokenPushSyncPlan(
      currentVariables: currentVariables,
      currentStyles: currentStyles,
      desiredVariables: desiredVariables,
      desiredStyles: desiredStyles,
      lock: lock,
    );

    expect(
      plan.operations
          .where((item) => item.action == MixFigmaSyncAction.create)
          .map((item) => item.kind),
      containsAll(<String>['collection', 'variable', 'textStyle']),
    );
    expect(
      plan.operations.where(
        (item) =>
            item.action == MixFigmaSyncAction.update ||
            item.action == MixFigmaSyncAction.rename ||
            item.action == MixFigmaSyncAction.delete,
      ),
      isEmpty,
    );
  });

  test('only proven Mix-managed extras are offered for deletion', () {
    final desiredVariables = buildFigmaVariableWritePayload({
      'light': theme,
    }).value;
    final desiredStyles = buildFigmaStylePayloads(theme).value;
    final currentJson = figmaVariablesDocumentFromWritePayload(
      desiredVariables,
    ).toJson();
    final collection = (currentJson['collections']! as List).single as Map;
    (collection['modes']! as List).addAll(<Map<String, Object?>>[
      {'id': 'mode:legacy-id', 'name': 'Legacy'},
      {'id': 'mode:user-id', 'name': 'User mode'},
    ]);
    final variables = currentJson['variables']! as List;
    variables.addAll(<Map<String, Object?>>[
      {
        'id': 'variable:legacy',
        'name': 'color/legacy',
        'collectionId': collection['id'],
        'resolvedType': 'COLOR',
        'valuesByMode': {
          'mode:light': {'r': 1, 'g': 0, 'b': 0, 'a': 1},
        },
        'pluginData': {'mix_figma.id': 'colors/color.legacy'},
      },
      {
        'id': 'variable:user',
        'name': 'user/local',
        'collectionId': collection['id'],
        'resolvedType': 'FLOAT',
        'valuesByMode': {'mode:light': 2},
      },
    ]);
    final currentStyles = figmaStylesDocumentFromWritePayload(desiredStyles);
    final stylesWithExtras = FigmaStylesDocument(
      styles: [
        ...currentStyles.styles,
        FigmaStyle(
          id: 'style:legacy',
          key: 'style:legacy',
          name: 'legacy/shadow',
          type: FigmaStyleType.effect,
          value: const {'effects': <Object?>[]},
          pluginData: const {'mix_figma.id': 'boxShadows/legacy.shadow'},
        ),
        FigmaStyle(
          id: 'style:user',
          key: 'style:user',
          name: 'user/style',
          type: FigmaStyleType.effect,
          value: const {'effects': <Object?>[]},
        ),
      ],
    );
    final plan = buildTokenPushSyncPlan(
      currentVariables: parseFigmaVariablesDocument(currentJson),
      currentStyles: stylesWithExtras,
      desiredVariables: desiredVariables,
      desiredStyles: desiredStyles,
      lock: MixFigmaLock(
        modeIds: const {
          'Mix Tokens': {'mode:legacy': 'mode:legacy-id'},
        },
      ),
    );
    final deletes = plan.operations
        .where((item) => item.action == MixFigmaSyncAction.delete)
        .toList();
    final skipped = plan.operations
        .where((item) => item.action == MixFigmaSyncAction.skip)
        .toList();

    expect(deletes.map((item) => item.kind), {
      'mode',
      'variable',
      'effectStyle',
    });
    expect(deletes.map((item) => item.sourceId), {
      'mode:legacy-id',
      'variable:legacy',
      'style:legacy',
    });
    expect(deletes.every((item) => item.destructive), isTrue);
    expect(skipped.map((item) => item.name), {
      'User mode',
      'user/local',
      'user/style',
    });
    expect(
      plan.operationsForApply(allowDeletes: false),
      isNot(containsAll(deletes)),
    );
  });

  test('same-named unowned resources are preserved instead of adopted', () {
    final desiredVariables = buildFigmaVariableWritePayload({
      'light': theme,
    }).value;
    final desiredStyles = buildFigmaStylePayloads(theme).value;
    final managedVariables = figmaVariablesDocumentFromWritePayload(
      desiredVariables,
    );
    final currentVariables = FigmaVariablesDocument(
      collections: [
        for (final collection in managedVariables.collections)
          FigmaVariableCollection(
            id: 'user:${collection.id}',
            key: collection.key,
            name: collection.name,
            defaultModeId: collection.defaultModeId,
            modes: collection.modes,
          ),
      ],
      variables: [
        for (final variable in managedVariables.variables)
          FigmaVariable(
            id: 'user:${variable.id}',
            name: variable.name,
            collectionId: 'user:${variable.collectionId}',
            resolvedType: variable.resolvedType,
            valuesByMode: variable.valuesByMode,
            scopes: variable.scopes,
            codeSyntax: variable.codeSyntax,
            description: variable.description,
          ),
      ],
    );
    final managedStyles = figmaStylesDocumentFromWritePayload(desiredStyles);
    final currentStyles = FigmaStylesDocument(
      styles: [
        for (final style in managedStyles.styles)
          FigmaStyle(
            id: 'user:${style.id}',
            key: 'user:${style.key}',
            name: style.name,
            type: style.type,
            value: style.value,
            description: style.description,
          ),
      ],
    );

    final plan = buildTokenPushSyncPlan(
      currentVariables: currentVariables,
      currentStyles: currentStyles,
      desiredVariables: desiredVariables,
      desiredStyles: desiredStyles,
    );

    expect(
      plan.operations
          .where((item) => item.action == MixFigmaSyncAction.create)
          .map((item) => item.kind),
      containsAll(<String>['collection', 'variable', 'textStyle']),
    );
    expect(
      plan.operations.where((item) => item.action == MixFigmaSyncAction.delete),
      isEmpty,
    );
    expect(
      plan.operations
          .where((item) => item.action == MixFigmaSyncAction.skip)
          .map((item) => item.name),
      containsAll(currentStyles.styles.map((item) => item.name)),
    );
  });

  test(
    'remote styles are rejected during Analyze instead of failing in Apply',
    () {
      final desiredVariables = buildFigmaVariableWritePayload({
        'light': theme,
      }).value;
      final desiredStyles = buildFigmaStylePayloads(theme).value;
      final generated = figmaStylesDocumentFromWritePayload(desiredStyles);
      final currentStyles = FigmaStylesDocument(
        styles: [
          for (final style in generated.styles)
            FigmaStyle(
              id: style.id,
              key: style.key,
              name: style.name,
              type: style.type,
              value: style.value,
              pluginData: style.pluginData,
              description: style.description,
              remote: true,
            ),
        ],
      );

      final plan = buildTokenPushSyncPlan(
        currentVariables: figmaVariablesDocumentFromWritePayload(
          desiredVariables,
        ),
        currentStyles: currentStyles,
        desiredVariables: desiredVariables,
        desiredStyles: desiredStyles,
      );

      expect(plan.hasErrors, isTrue);
      expect(
        plan.operations
            .where((item) => item.kind.endsWith('Style'))
            .every((item) => item.action == MixFigmaSyncAction.skip),
        isTrue,
      );
      expect(
        plan.operations
            .expand((item) => item.diagnostics)
            .map((item) => item.code),
        contains('remote_resource_not_writable'),
      );
    },
  );
}
