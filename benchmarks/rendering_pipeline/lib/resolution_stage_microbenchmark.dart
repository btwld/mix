// The result-file marker is the CLI interface for this benchmark.
// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'scenarios/card_grid.dart';
import 'scenarios/mix_card.dart';
import 'src/benchmark_metadata.dart';
import 'src/resolution_stage_protocol.dart';
import 'src/statistics.dart';

const int _defaultOperationsPerBatch = 100;
const int _controlOperationsPerBatch = 100000;
const int _warmupBatches = 100;
const int _benchmarkSeconds = int.fromEnvironment(
  'BENCHMARK_SECONDS',
  defaultValue: 3,
);

typedef _ResolvedBoxFields = ({
  AlignmentGeometry? alignment,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  BoxConstraints? constraints,
  Decoration? decoration,
  Decoration? foregroundDecoration,
  Matrix4? transform,
  AlignmentGeometry? transformAlignment,
  Clip? clipBehavior,
  AnimationConfig? animation,
  List<WidgetModifier>? widgetModifiers,
});
typedef _ResolvedDecorationFields = ({
  BlendMode? backgroundBlendMode,
  BoxBorder? border,
  BorderRadiusGeometry? borderRadius,
  List<BoxShadow>? boxShadow,
  Color? color,
  Gradient? gradient,
  DecorationImage? image,
  BoxShape shape,
});
typedef _ExtractedActiveStyle = (Style<BoxSpec>, bool);

final Expando<bool> _styleVariationClassification = Expando<bool>(
  'style variation classification',
);

Future<void> main() => executeResolutionStageMicrobenchmark();

Future<void> executeResolutionStageMicrobenchmark() async {
  if (!kReleaseMode) {
    throw StateError(
      'CPU timings are valid only in release mode. '
      'Run: fvm flutter run --release -d <device> '
      '-t lib/resolution_stage_microbenchmark.dart',
    );
  }

  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  if (binding is! LiveTestWidgetsFlutterBinding) {
    throw StateError('The microbenchmark requires a live Flutter device.');
  }

  final orderLabel = const String.fromEnvironment(
    'STAGE_ORDER',
    defaultValue: 'forward',
  );
  final inactiveContextKey = GlobalKey();
  final staticContextKey = GlobalKey();
  final allActiveContextKey = GlobalKey();
  final results = <Map<String, Object?>>[];

  await benchmarkWidgets((WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: <Widget>[
            WidgetStateProvider(
              states: const <WidgetState>{},
              child: SizedBox(key: inactiveContextKey),
            ),
            WidgetStateProvider(
              states: const <WidgetState>{},
              child: SizedBox(key: staticContextKey),
            ),
            WidgetStateProvider(
              states: const <WidgetState>{
                WidgetState.disabled,
                WidgetState.hovered,
                WidgetState.pressed,
                WidgetState.selected,
              },
              child: SizedBox(key: allActiveContextKey),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    final contexts = <ResolutionProfile, BuildContext?>{
      ResolutionProfile.inactiveOnly: inactiveContextKey.currentContext,
      ResolutionProfile.static: staticContextKey.currentContext,
      ResolutionProfile.allActive: allActiveContextKey.currentContext,
    };
    if (contexts.values.any((context) => context == null || !context.mounted)) {
      throw StateError('A diagnostic BuildContext was not mounted.');
    }

    final style = styleForCard(CardStateProfile.all, animated: false);
    final styles = <ResolutionProfile, BoxStyler>{
      ResolutionProfile.inactiveOnly: _createInactiveOnlyStyle(),
      ResolutionProfile.static: style,
      ResolutionProfile.allActive: style,
    };
    final premergedStyles = <ResolutionProfile, BoxStyler>{
      for (final profile in ResolutionProfile.values)
        profile:
            styles[profile]!.mergeActiveVariants(
                  contexts[profile]!,
                  namedVariants: const <NamedVariant>{},
                )
                as BoxStyler,
    };
    final decorationMixSources = <ResolutionProfile, List<BoxDecorationMix>>{
      for (final profile in ResolutionProfile.values)
        profile: _extractDecorationMixSources(premergedStyles[profile]!),
    };
    final mergedDecorationMixes = <ResolutionProfile, BoxDecorationMix>{
      for (final profile in ResolutionProfile.values)
        profile: _mergeDecorationMixSources(
          contexts[profile]!,
          decorationMixSources[profile]!,
        ),
    };
    final decorationBorderMixSources = <ResolutionProfile, List<BorderMix>>{
      for (final profile in ResolutionProfile.values)
        profile: _extractBorderMixSources(mergedDecorationMixes[profile]!),
    };
    final mergedDecorationBorderMixes = <ResolutionProfile, BorderMix?>{
      for (final profile in ResolutionProfile.values)
        profile: _mergeBorderMixSources(decorationBorderMixSources[profile]!),
    };
    final resolvedUniformBorderSides = <ResolutionProfile, BorderSide?>{
      for (final profile in ResolutionProfile.values)
        profile: MixOps.resolve(
          contexts[profile]!,
          mergedDecorationBorderMixes[profile]?.uniformBorderSide,
        ),
    };
    final resolvedDecorationFields =
        <ResolutionProfile, _ResolvedDecorationFields>{
          for (final profile in ResolutionProfile.values)
            profile: _resolveDecorationFields(
              contexts[profile]!,
              mergedDecorationMixes[profile]!,
            ),
        };
    final resolvedFields = <ResolutionProfile, _ResolvedBoxFields>{
      for (final profile in ResolutionProfile.values)
        profile: _resolveBoxFields(
          contexts[profile]!,
          premergedStyles[profile]!,
        ),
    };
    final activeVariants = <ResolutionProfile, List<VariantStyle<BoxSpec>>>{
      for (final profile in ResolutionProfile.values)
        profile: _collectActiveVariants(styles[profile]!, contexts[profile]!),
    };
    final sortedActiveVariants =
        <ResolutionProfile, List<VariantStyle<BoxSpec>>>{
          for (final profile in ResolutionProfile.values)
            profile: _sortActiveVariants(activeVariants[profile]!),
        };
    final extractedActiveStyles =
        <ResolutionProfile, List<_ExtractedActiveStyle>>{
          for (final profile in ResolutionProfile.values)
            profile: _extractActiveStyles(
              contexts[profile]!,
              styles[profile]!,
              sortedActiveVariants[profile]!,
            ),
        };
    final activeContextBuilderVariants =
        <ResolutionProfile, List<VariantStyle<BoxSpec>>>{
          for (final profile in ResolutionProfile.values)
            profile: sortedActiveVariants[profile]!
                .where(
                  (variantStyle) =>
                      variantStyle.variant is ContextVariantBuilder,
                )
                .toList(),
        };
    final activeOrdinaryVariants =
        <ResolutionProfile, List<VariantStyle<BoxSpec>>>{
          for (final profile in ResolutionProfile.values)
            profile: sortedActiveVariants[profile]!
                .where(
                  (variantStyle) =>
                      variantStyle.variant is! ContextVariantBuilder,
                )
                .toList(),
        };

    for (final stageCase in resolutionStageCases(orderLabel)) {
      final profile = stageCase.profile;
      final stage = stageCase.stage;
      print('RESOLUTION_STAGE_PROGRESS:${profile.label}:${stage.label}:start');
      results.add(
        _measureCase(
          context: contexts[profile]!,
          profile: profile,
          stage: stage,
          style: styles[profile]!,
          premergedStyle: premergedStyles[profile]!,
          decorationMixSources: decorationMixSources[profile]!,
          mergedDecorationMix: mergedDecorationMixes[profile]!,
          decorationBorderMixSources: decorationBorderMixSources[profile]!,
          mergedDecorationBorderMix: mergedDecorationBorderMixes[profile],
          resolvedUniformBorderSide: resolvedUniformBorderSides[profile],
          resolvedDecorationFields: resolvedDecorationFields[profile]!,
          resolvedFields: resolvedFields[profile]!,
          activeVariants: activeVariants[profile]!,
          sortedActiveVariants: sortedActiveVariants[profile]!,
          extractedActiveStyles: extractedActiveStyles[profile]!,
          activeContextBuilderVariants: activeContextBuilderVariants[profile]!,
          activeOrdinaryVariants: activeOrdinaryVariants[profile]!,
        ),
      );
      print('RESOLUTION_STAGE_PROGRESS:${profile.label}:${stage.label}:done');
    }
  });

  final expectedResultCount =
      ResolutionProfile.values.length * ResolutionStage.values.length;
  if (results.length != expectedResultCount) {
    throw StateError(
      'Expected $expectedResultCount benchmark results, got ${results.length}.',
    );
  }

  final view = binding.platformDispatcher.views.firstOrNull;
  final output = <String, Object?>{
    'schema_version': benchmarkSchemaVersion,
    'metadata': createBenchmarkMetadata(
      kind: 'release_resolution_stage_microbenchmark',
      runOrder: orderLabel,
      view: view,
    ),
    'results': results,
  };

  final configuredOutputPath = const String.fromEnvironment(
    'BENCHMARK_OUTPUT_PATH',
  );
  final outputFile = configuredOutputPath.isEmpty
      ? File(
          '${Directory.systemTemp.path}/mix_resolution_stage_microbenchmark.json',
        )
      : File(configuredOutputPath).absolute;
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString(jsonEncode(output));
  print('BENCHMARK_RESULT_FILE:${outputFile.path}');
  exit(0);
}

Map<String, Object?> _measureCase({
  required BuildContext context,
  required ResolutionProfile profile,
  required ResolutionStage stage,
  required BoxStyler style,
  required BoxStyler premergedStyle,
  required List<BoxDecorationMix> decorationMixSources,
  required BoxDecorationMix mergedDecorationMix,
  required List<BorderMix> decorationBorderMixSources,
  required BorderMix? mergedDecorationBorderMix,
  required BorderSide? resolvedUniformBorderSide,
  required _ResolvedDecorationFields resolvedDecorationFields,
  required _ResolvedBoxFields resolvedFields,
  required List<VariantStyle<BoxSpec>> activeVariants,
  required List<VariantStyle<BoxSpec>> sortedActiveVariants,
  required List<_ExtractedActiveStyle> extractedActiveStyles,
  required List<VariantStyle<BoxSpec>> activeContextBuilderVariants,
  required List<VariantStyle<BoxSpec>> activeOrdinaryVariants,
}) {
  final notRun = Object();
  Object? blackHole = notRun;
  final operationsPerBatch = stage == ResolutionStage.control
      ? _controlOperationsPerBatch
      : _defaultOperationsPerBatch;
  final operation = switch (stage) {
    ResolutionStage.control => () => blackHole = style,
    ResolutionStage.activeCollection =>
      () => blackHole = _collectActiveVariants(style, context),
    ResolutionStage.prioritySort => () => blackHole = _sortActiveVariants(
      activeVariants,
    ),
    ResolutionStage.activeExtraction => () => blackHole = _extractActiveStyles(
      context,
      style,
      sortedActiveVariants,
    ),
    ResolutionStage.contextBuilderExtraction =>
      () => blackHole = _extractContextBuilderStyles(
        context,
        activeContextBuilderVariants,
      ),
    ResolutionStage.ordinaryStyleExtraction =>
      () => blackHole = _extractOrdinaryStyles(
        context,
        style,
        activeOrdinaryVariants,
      ),
    ResolutionStage.ordinaryStyleExtractionWithRawVariationPrefilter =>
      () => blackHole = _extractOrdinaryStylesWithRawVariationPrefilter(
        context,
        style,
        activeOrdinaryVariants,
      ),
    ResolutionStage.ordinaryStyleExtractionWithCachedVariationClassification =>
      () => blackHole = _extractOrdinaryStylesWithCachedVariationClassification(
        context,
        style,
        activeOrdinaryVariants,
      ),
    ResolutionStage.ordinaryStyleExtractionWithoutVariationCheck =>
      () => blackHole = _extractOrdinaryStylesWithoutVariationCheck(
        activeOrdinaryVariants,
      ),
    ResolutionStage.activeStyleMerge => () => blackHole = _mergeExtractedStyles(
      style,
      extractedActiveStyles,
      context: context,
      stripVariantMetadata: false,
    ),
    ResolutionStage.activeStyleMergeWithoutVariantMetadata =>
      () => blackHole = _mergeExtractedStyles(
        style,
        extractedActiveStyles,
        context: context,
        stripVariantMetadata: true,
      ),
    ResolutionStage.variantMerge => () => blackHole = style.mergeActiveVariants(
      context,
      namedVariants: const <NamedVariant>{},
    ),
    ResolutionStage.propertyResolve => () => blackHole = _resolveBoxFields(
      context,
      premergedStyle,
    ),
    ResolutionStage.nullPropertyResolveControl =>
      () => blackHole = MixOps.resolve(context, premergedStyle.$alignment),
    ResolutionStage.paddingPropertyResolve => () => blackHole = MixOps.resolve(
      context,
      premergedStyle.$padding,
    ),
    ResolutionStage.constraintsPropertyResolve =>
      () => blackHole = MixOps.resolve(context, premergedStyle.$constraints),
    ResolutionStage.decorationPropertyResolve =>
      () => blackHole = MixOps.resolve(context, premergedStyle.$decoration),
    ResolutionStage.decorationMixMerge =>
      () =>
          blackHole = _mergeDecorationMixSources(context, decorationMixSources),
    ResolutionStage.decorationMergedMixResolve =>
      () => blackHole = mergedDecorationMix.resolve(context),
    ResolutionStage.decorationBorderResolve => () => blackHole = MixOps.resolve(
      context,
      mergedDecorationMix.$border,
    ),
    ResolutionStage.decorationBorderMixMerge =>
      () => blackHole = _mergeBorderMixSources(decorationBorderMixSources),
    ResolutionStage.decorationBorderMergedMixResolve =>
      () => blackHole = mergedDecorationBorderMix?.resolve(context),
    ResolutionStage.decorationBorderUniformResolve =>
      () =>
          blackHole = _resolveUniformBorder(context, mergedDecorationBorderMix),
    ResolutionStage.decorationBorderSideResolve =>
      () => blackHole = MixOps.resolve(
        context,
        mergedDecorationBorderMix?.uniformBorderSide,
      ),
    ResolutionStage.decorationBorderConstruction =>
      () => blackHole = _constructUniformBorder(resolvedUniformBorderSide),
    ResolutionStage.decorationBorderRadiusResolve =>
      () => blackHole = MixOps.resolve(
        context,
        mergedDecorationMix.$borderRadius,
      ),
    ResolutionStage.decorationBoxShadowResolve =>
      () => blackHole = MixOps.resolve(context, mergedDecorationMix.$boxShadow),
    ResolutionStage.decorationColorResolve => () => blackHole = MixOps.resolve(
      context,
      mergedDecorationMix.$color,
    ),
    ResolutionStage.decorationConstruction =>
      () => blackHole = _constructBoxDecoration(resolvedDecorationFields),
    ResolutionStage.transformPropertyResolve =>
      () => blackHole = MixOps.resolve(context, premergedStyle.$transform),
    ResolutionStage.modifierResolve =>
      () => blackHole = premergedStyle.$modifier?.resolve(context),
    ResolutionStage.specConstruction => () => blackHole = _constructStyleSpec(
      resolvedFields,
    ),
    ResolutionStage.specResolve => () => blackHole = premergedStyle.resolve(
      context,
    ),
    ResolutionStage.fullBuild => () => blackHole = style.build(context),
  };

  void runBatch() {
    for (
      var operationIndex = 0;
      operationIndex < operationsPerBatch;
      operationIndex++
    ) {
      operation();
    }
  }

  for (var batch = 0; batch < _warmupBatches; batch++) {
    runBatch();
  }

  final samples = <int>[];
  final measuredTime = Stopwatch()..start();
  final batchTime = Stopwatch();
  while (measuredTime.elapsed < const Duration(seconds: _benchmarkSeconds)) {
    batchTime
      ..reset()
      ..start();
    runBatch();
    batchTime.stop();

    final elapsedNanoseconds =
        batchTime.elapsedTicks *
        Duration.microsecondsPerSecond *
        1000 /
        batchTime.frequency;
    samples.add((elapsedNanoseconds / operationsPerBatch).round());
  }
  measuredTime.stop();

  if (identical(blackHole, notRun)) {
    throw StateError('The benchmark operation did not produce a value.');
  }

  return <String, Object?>{
    'profile': profile.label,
    'stage': stage.label,
    'declared_variant_count': style.$variants?.length ?? 0,
    'selected_variant_count': activeVariants.length,
    'operations_per_batch': operationsPerBatch,
    'warmup_batches': _warmupBatches,
    'measurement_duration_ms': measuredTime.elapsedMilliseconds,
    'metrics': DistributionStatistics.fromSamples(
      samples,
    ).toJson(unitSuffix: 'ns'),
    'samples_ns_per_operation': samples,
  };
}

List<VariantStyle<BoxSpec>> _collectActiveVariants(
  BoxStyler style,
  BuildContext context,
) {
  return (style.$variants ?? const <VariantStyle<BoxSpec>>[])
      .where(
        (variantStyle) => switch (variantStyle.variant) {
          ContextVariant variant => variant.when(context),
          NamedVariant _ => false,
          ContextVariantBuilder _ => true,
        },
      )
      .toList();
}

List<VariantStyle<BoxSpec>> _sortActiveVariants(
  List<VariantStyle<BoxSpec>> activeVariants,
) {
  return List<VariantStyle<BoxSpec>>.of(activeVariants)..sort(
    (a, b) => Comparable.compare(
      a.variant is WidgetStateVariant ? 1 : 0,
      b.variant is WidgetStateVariant ? 1 : 0,
    ),
  );
}

List<_ExtractedActiveStyle> _extractActiveStyles(
  BuildContext context,
  BoxStyler baseStyle,
  List<VariantStyle<BoxSpec>> activeVariants,
) {
  final extractedStyles = <_ExtractedActiveStyle>[];
  for (final variantStyle in activeVariants) {
    final result = switch (variantStyle.variant) {
      ContextVariantBuilder variant => (
        variant.build(context) as Style<BoxSpec>,
        false,
      ),
      ContextVariant() || NamedVariant() => () {
        // Keep this check aligned with Style.mergeActiveVariants even though
        // the benchmark card does not currently declare a StyleVariation.
        // ignore: avoid-unrelated-type-assertions
        if (variantStyle.value is StyleVariation<BoxSpec>) {
          // ignore: avoid-unrelated-type-casts
          final variation = variantStyle.value as StyleVariation<BoxSpec>;
          if (const <NamedVariant>{}.contains(variation.variantType)) {
            return (
              variation.styleBuilder(
                baseStyle,
                const <NamedVariant>{},
                context,
              ),
              true,
            );
          }
        }

        return (variantStyle.value, false);
      }(),
    };
    extractedStyles.add(result);
  }

  return extractedStyles;
}

List<_ExtractedActiveStyle> _extractContextBuilderStyles(
  BuildContext context,
  List<VariantStyle<BoxSpec>> variants,
) {
  final extractedStyles = <_ExtractedActiveStyle>[];
  for (final variantStyle in variants) {
    final variant = variantStyle.variant as ContextVariantBuilder;
    extractedStyles.add((variant.build(context) as Style<BoxSpec>, false));
  }

  return extractedStyles;
}

List<_ExtractedActiveStyle> _extractOrdinaryStyles(
  BuildContext context,
  BoxStyler baseStyle,
  List<VariantStyle<BoxSpec>> variants,
) {
  final extractedStyles = <_ExtractedActiveStyle>[];
  for (final variantStyle in variants) {
    // Keep this check aligned with Style.mergeActiveVariants even though the
    // benchmark card does not currently declare a StyleVariation.
    // ignore: avoid-unrelated-type-assertions
    if (variantStyle.value is StyleVariation<BoxSpec>) {
      // ignore: avoid-unrelated-type-casts
      final variation = variantStyle.value as StyleVariation<BoxSpec>;
      if (const <NamedVariant>{}.contains(variation.variantType)) {
        extractedStyles.add((
          variation.styleBuilder(baseStyle, const <NamedVariant>{}, context),
          true,
        ));
        continue;
      }
    }

    extractedStyles.add((variantStyle.value, false));
  }

  return extractedStyles;
}

List<_ExtractedActiveStyle> _extractOrdinaryStylesWithoutVariationCheck(
  List<VariantStyle<BoxSpec>> variants,
) {
  return <_ExtractedActiveStyle>[
    for (final variantStyle in variants) (variantStyle.value, false),
  ];
}

List<_ExtractedActiveStyle> _extractOrdinaryStylesWithRawVariationPrefilter(
  BuildContext context,
  BoxStyler baseStyle,
  List<VariantStyle<BoxSpec>> variants,
) {
  final extractedStyles = <_ExtractedActiveStyle>[];
  for (final variantStyle in variants) {
    final value = variantStyle.value;
    // Preserve the exact generic check for actual variations while rejecting
    // ordinary styles through the raw interface first.
    // ignore: avoid-unrelated-type-assertions
    if (value is StyleVariation &&
        // ignore: avoid-unrelated-type-assertions
        value is StyleVariation<BoxSpec>) {
      // ignore: avoid-unrelated-type-casts
      final variation = value as StyleVariation<BoxSpec>;
      if (const <NamedVariant>{}.contains(variation.variantType)) {
        extractedStyles.add((
          variation.styleBuilder(baseStyle, const <NamedVariant>{}, context),
          true,
        ));
        continue;
      }
    }

    extractedStyles.add((value, false));
  }

  return extractedStyles;
}

List<_ExtractedActiveStyle>
_extractOrdinaryStylesWithCachedVariationClassification(
  BuildContext context,
  BoxStyler baseStyle,
  List<VariantStyle<BoxSpec>> variants,
) {
  final extractedStyles = <_ExtractedActiveStyle>[];
  for (final variantStyle in variants) {
    final value = variantStyle.value;
    final isStyleVariation = _styleVariationClassification[value] ??=
        // ignore: avoid-unrelated-type-assertions
        value is StyleVariation<BoxSpec>;
    if (isStyleVariation) {
      // ignore: avoid-unrelated-type-casts
      final variation = value as StyleVariation<BoxSpec>;
      if (const <NamedVariant>{}.contains(variation.variantType)) {
        extractedStyles.add((
          variation.styleBuilder(baseStyle, const <NamedVariant>{}, context),
          true,
        ));
        continue;
      }
    }

    extractedStyles.add((value, false));
  }

  return extractedStyles;
}

BoxStyler _mergeExtractedStyles(
  BoxStyler style,
  List<_ExtractedActiveStyle> extractedStyles, {
  required BuildContext context,
  required bool stripVariantMetadata,
}) {
  Style<BoxSpec> mergedStyle = stripVariantMetadata
      ? _withoutVariants(style)
      : style;
  for (final (extractedStyle, isFromStyleVariation) in extractedStyles) {
    final fullyResolvedStyle = isFromStyleVariation
        ? extractedStyle
        : extractedStyle.mergeActiveVariants(
            context,
            namedVariants: const <NamedVariant>{},
          );
    final styleToMerge = stripVariantMetadata
        ? _withoutVariants(fullyResolvedStyle as BoxStyler)
        : fullyResolvedStyle;
    mergedStyle = mergedStyle.merge(styleToMerge);
  }

  return mergedStyle as BoxStyler;
}

BoxStyler _withoutVariants(BoxStyler style) {
  return BoxStyler.create(
    alignment: style.$alignment,
    padding: style.$padding,
    margin: style.$margin,
    constraints: style.$constraints,
    decoration: style.$decoration,
    foregroundDecoration: style.$foregroundDecoration,
    transform: style.$transform,
    transformAlignment: style.$transformAlignment,
    clipBehavior: style.$clipBehavior,
    modifier: style.$modifier,
    animation: style.$animation,
  );
}

List<BoxDecorationMix> _extractDecorationMixSources(BoxStyler style) {
  final prop = style.$decoration;
  if (prop == null || prop.sources.isEmpty) {
    throw StateError('The decoration diagnostic requires decoration sources.');
  }

  final mixes = <BoxDecorationMix>[];
  for (final source in prop.sources) {
    switch (source) {
      case MixSource<Decoration>(:final mix) when mix is BoxDecorationMix:
        mixes.add(mix);
      case _:
        throw StateError(
          'The decoration diagnostic requires only BoxDecorationMix sources; '
          'found ${source.runtimeType}.',
        );
    }
  }

  return mixes;
}

BoxDecorationMix _mergeDecorationMixSources(
  BuildContext context,
  List<BoxDecorationMix> mixes,
) {
  var merged = mixes.first;
  for (var index = 1; index < mixes.length; index++) {
    final next = DecorationMix.tryMerge(context, merged, mixes[index]);
    if (next is! BoxDecorationMix) {
      throw StateError('Expected BoxDecorationMix, got ${next.runtimeType}.');
    }
    merged = next;
  }

  return merged;
}

List<BorderMix> _extractBorderMixSources(BoxDecorationMix decoration) {
  final prop = decoration.$border;
  if (prop == null) return const <BorderMix>[];

  final mixes = <BorderMix>[];
  for (final source in prop.sources) {
    switch (source) {
      case MixSource<BoxBorder>(:final mix) when mix is BorderMix:
        mixes.add(mix);
      case _:
        throw StateError(
          'The border diagnostic requires only BorderMix sources; '
          'found ${source.runtimeType}.',
        );
    }
  }

  return mixes;
}

BorderMix? _mergeBorderMixSources(List<BorderMix> mixes) {
  if (mixes.isEmpty) return null;

  var merged = mixes.first;
  for (var index = 1; index < mixes.length; index++) {
    merged = merged.merge(mixes[index]);
  }

  return merged;
}

Border? _resolveUniformBorder(BuildContext context, BorderMix? mix) {
  if (mix == null) return null;

  final side = mix.uniformBorderSide;
  if (side == null) return mix.resolve(context);

  return Border.fromBorderSide(
    MixOps.resolve(context, side) ?? BorderSide.none,
  );
}

Border? _constructUniformBorder(BorderSide? side) {
  return side == null ? null : Border.fromBorderSide(side);
}

_ResolvedDecorationFields _resolveDecorationFields(
  BuildContext context,
  BoxDecorationMix mix,
) {
  const defaults = BoxDecoration();

  return (
    backgroundBlendMode:
        MixOps.resolve(context, mix.$backgroundBlendMode) ??
        defaults.backgroundBlendMode,
    border: MixOps.resolve(context, mix.$border) ?? defaults.border,
    borderRadius:
        MixOps.resolve(context, mix.$borderRadius) ?? defaults.borderRadius,
    boxShadow: MixOps.resolve(context, mix.$boxShadow) ?? defaults.boxShadow,
    color: MixOps.resolve(context, mix.$color) ?? defaults.color,
    gradient: MixOps.resolve(context, mix.$gradient) ?? defaults.gradient,
    image: MixOps.resolve(context, mix.$image) ?? defaults.image,
    shape: MixOps.resolve(context, mix.$shape) ?? defaults.shape,
  );
}

BoxDecoration _constructBoxDecoration(_ResolvedDecorationFields fields) {
  return BoxDecoration(
    backgroundBlendMode: fields.backgroundBlendMode,
    border: fields.border,
    borderRadius: fields.borderRadius,
    boxShadow: fields.boxShadow,
    color: fields.color,
    gradient: fields.gradient,
    image: fields.image,
    shape: fields.shape,
  );
}

_ResolvedBoxFields _resolveBoxFields(BuildContext context, BoxStyler style) {
  return (
    alignment: MixOps.resolve(context, style.$alignment),
    padding: MixOps.resolve(context, style.$padding),
    margin: MixOps.resolve(context, style.$margin),
    constraints: MixOps.resolve(context, style.$constraints),
    decoration: MixOps.resolve(context, style.$decoration),
    foregroundDecoration: MixOps.resolve(context, style.$foregroundDecoration),
    transform: MixOps.resolve(context, style.$transform),
    transformAlignment: MixOps.resolve(context, style.$transformAlignment),
    clipBehavior: MixOps.resolve(context, style.$clipBehavior),
    animation: style.$animation,
    widgetModifiers: style.$modifier?.resolve(context),
  );
}

StyleSpec<BoxSpec> _constructStyleSpec(_ResolvedBoxFields fields) {
  return StyleSpec(
    spec: BoxSpec(
      alignment: fields.alignment,
      padding: fields.padding,
      margin: fields.margin,
      constraints: fields.constraints,
      decoration: fields.decoration,
      foregroundDecoration: fields.foregroundDecoration,
      transform: fields.transform,
      transformAlignment: fields.transformAlignment,
      clipBehavior: fields.clipBehavior,
    ),
    animation: fields.animation,
    widgetModifiers: fields.widgetModifiers,
  );
}

BoxStyler _createInactiveOnlyStyle() {
  return BoxStyler()
      .size(100, 100)
      .color(Colors.black)
      .onHovered(BoxStyler().color(Colors.blue))
      .onPressed(BoxStyler().scale(0.98))
      .variant(
        ContextVariant.widgetState(WidgetState.selected),
        BoxStyler().borderAll(color: Colors.indigo, width: 2),
      )
      .onDisabled(BoxStyler().wrap(WidgetModifierConfig.opacity(0.45)));
}
