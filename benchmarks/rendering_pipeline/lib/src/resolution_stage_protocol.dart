enum ResolutionStage {
  control,
  activeCollection,
  prioritySort,
  activeExtraction,
  contextBuilderExtraction,
  ordinaryStyleExtraction,
  ordinaryStyleExtractionWithRawVariationPrefilter,
  ordinaryStyleExtractionWithCachedVariationClassification,
  ordinaryStyleExtractionWithoutVariationCheck,
  activeStyleMerge,
  activeStyleMergeWithoutVariantMetadata,
  variantMerge,
  propertyResolve,
  nullPropertyResolveControl,
  paddingPropertyResolve,
  constraintsPropertyResolve,
  decorationPropertyResolve,
  decorationMixMerge,
  decorationMergedMixResolve,
  decorationBorderResolve,
  decorationBorderMixMerge,
  decorationBorderMergedMixResolve,
  decorationBorderUniformResolve,
  decorationBorderSideResolve,
  decorationBorderConstruction,
  decorationBorderRadiusResolve,
  decorationBoxShadowResolve,
  decorationColorResolve,
  decorationConstruction,
  transformPropertyResolve,
  modifierResolve,
  specConstruction,
  specResolve,
  fullBuild,
}

enum ResolutionProfile { inactiveOnly, static, allActive }

extension ResolutionStageLabel on ResolutionStage {
  String get label => switch (this) {
    ResolutionStage.control => 'control_store',
    ResolutionStage.activeCollection => 'active_variant_collection',
    ResolutionStage.prioritySort => 'active_variant_priority_sort',
    ResolutionStage.activeExtraction => 'active_style_extraction',
    ResolutionStage.contextBuilderExtraction => 'context_builder_extraction',
    ResolutionStage.ordinaryStyleExtraction => 'ordinary_style_extraction',
    ResolutionStage.ordinaryStyleExtractionWithRawVariationPrefilter =>
      'ordinary_style_extraction_with_raw_variation_prefilter',
    ResolutionStage.ordinaryStyleExtractionWithCachedVariationClassification =>
      'ordinary_style_extraction_with_cached_variation_classification',
    ResolutionStage.ordinaryStyleExtractionWithoutVariationCheck =>
      'ordinary_style_extraction_without_variation_check',
    ResolutionStage.activeStyleMerge => 'active_style_merge',
    ResolutionStage.activeStyleMergeWithoutVariantMetadata =>
      'active_style_merge_without_variant_metadata',
    ResolutionStage.variantMerge => 'variant_merge',
    ResolutionStage.propertyResolve => 'property_resolve',
    ResolutionStage.nullPropertyResolveControl =>
      'null_property_resolve_control',
    ResolutionStage.paddingPropertyResolve => 'padding_property_resolve',
    ResolutionStage.constraintsPropertyResolve =>
      'constraints_property_resolve',
    ResolutionStage.decorationPropertyResolve => 'decoration_property_resolve',
    ResolutionStage.decorationMixMerge => 'decoration_mix_merge',
    ResolutionStage.decorationMergedMixResolve =>
      'decoration_merged_mix_resolve',
    ResolutionStage.decorationBorderResolve => 'decoration_border_resolve',
    ResolutionStage.decorationBorderMixMerge => 'decoration_border_mix_merge',
    ResolutionStage.decorationBorderMergedMixResolve =>
      'decoration_border_merged_mix_resolve',
    ResolutionStage.decorationBorderUniformResolve =>
      'decoration_border_uniform_resolve',
    ResolutionStage.decorationBorderSideResolve =>
      'decoration_border_side_resolve',
    ResolutionStage.decorationBorderConstruction =>
      'decoration_border_construction',
    ResolutionStage.decorationBorderRadiusResolve =>
      'decoration_border_radius_resolve',
    ResolutionStage.decorationBoxShadowResolve =>
      'decoration_box_shadow_resolve',
    ResolutionStage.decorationColorResolve => 'decoration_color_resolve',
    ResolutionStage.decorationConstruction => 'decoration_construction',
    ResolutionStage.transformPropertyResolve => 'transform_property_resolve',
    ResolutionStage.modifierResolve => 'modifier_resolve',
    ResolutionStage.specConstruction => 'spec_construction',
    ResolutionStage.specResolve => 'premerged_spec_resolve',
    ResolutionStage.fullBuild => 'full_style_build',
  };
}

extension ResolutionProfileLabel on ResolutionProfile {
  String get label => switch (this) {
    ResolutionProfile.inactiveOnly => 'inactive_only',
    ResolutionProfile.static => 'static',
    ResolutionProfile.allActive => 'all_active',
  };
}

typedef ResolutionStageCase = ({
  ResolutionProfile profile,
  ResolutionStage stage,
});

List<ResolutionStageCase> resolutionStageCases(String orderLabel) {
  final cases = <ResolutionStageCase>[
    for (final profile in ResolutionProfile.values)
      for (final stage in ResolutionStage.values)
        (profile: profile, stage: stage),
  ];

  return switch (orderLabel) {
    'forward' => List<ResolutionStageCase>.unmodifiable(cases),
    'reverse' => List<ResolutionStageCase>.unmodifiable(cases.reversed),
    _ => throw ArgumentError.value(
      orderLabel,
      'orderLabel',
      'Expected forward or reverse',
    ),
  };
}
