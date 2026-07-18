import 'package:flutter_test/flutter_test.dart';
import 'package:rendering_pipeline/src/resolution_stage_protocol.dart';

void main() {
  test('builds deterministic forward and reverse case orders', () {
    final forward = resolutionStageCases('forward');
    final reverse = resolutionStageCases('reverse');

    expect(
      forward,
      hasLength(
        ResolutionProfile.values.length * ResolutionStage.values.length,
      ),
    );
    expect(
      forward
          .take(ResolutionStage.values.length)
          .map((entry) => '${entry.profile.label}:${entry.stage.label}'),
      <String>[
        'inactive_only:control_store',
        'inactive_only:active_variant_collection',
        'inactive_only:active_variant_priority_sort',
        'inactive_only:active_style_extraction',
        'inactive_only:context_builder_extraction',
        'inactive_only:ordinary_style_extraction',
        'inactive_only:ordinary_style_extraction_with_raw_variation_prefilter',
        'inactive_only:ordinary_style_extraction_with_cached_variation_classification',
        'inactive_only:ordinary_style_extraction_without_variation_check',
        'inactive_only:active_style_merge',
        'inactive_only:active_style_merge_without_variant_metadata',
        'inactive_only:variant_merge',
        'inactive_only:property_resolve',
        'inactive_only:null_property_resolve_control',
        'inactive_only:padding_property_resolve',
        'inactive_only:constraints_property_resolve',
        'inactive_only:decoration_property_resolve',
        'inactive_only:decoration_mix_merge',
        'inactive_only:decoration_merged_mix_resolve',
        'inactive_only:decoration_border_resolve',
        'inactive_only:decoration_border_mix_merge',
        'inactive_only:decoration_border_merged_mix_resolve',
        'inactive_only:decoration_border_uniform_resolve',
        'inactive_only:decoration_border_side_resolve',
        'inactive_only:decoration_border_construction',
        'inactive_only:decoration_border_radius_resolve',
        'inactive_only:decoration_box_shadow_resolve',
        'inactive_only:decoration_color_resolve',
        'inactive_only:decoration_construction',
        'inactive_only:transform_property_resolve',
        'inactive_only:modifier_resolve',
        'inactive_only:spec_construction',
        'inactive_only:premerged_spec_resolve',
        'inactive_only:full_style_build',
      ],
    );
    expect(reverse, forward.reversed);
  });

  test('rejects unsupported order labels', () {
    expect(() => resolutionStageCases('random'), throwsArgumentError);
  });

  test('filters profiles and stages without changing their relative order', () {
    final profiles = parseResolutionProfileFilter('static,all_active');
    final stages = parseResolutionStageFilter('variant_merge,full_style_build');

    final forward = resolutionStageCases(
      'forward',
      profiles: profiles,
      stages: stages,
    );
    final reverse = resolutionStageCases(
      'reverse',
      profiles: profiles,
      stages: stages,
    );

    expect(
      forward.map((entry) => '${entry.profile.label}:${entry.stage.label}'),
      <String>[
        'static:variant_merge',
        'static:full_style_build',
        'all_active:variant_merge',
        'all_active:full_style_build',
      ],
    );
    expect(reverse, forward.reversed);
  });

  test('empty filters select every profile and stage', () {
    expect(parseResolutionProfileFilter(''), ResolutionProfile.values.toSet());
    expect(parseResolutionStageFilter(''), ResolutionStage.values.toSet());
  });

  test('rejects unsupported profile and stage filter labels', () {
    expect(
      () => parseResolutionProfileFilter('static,unknown'),
      throwsArgumentError,
    );
    expect(
      () => parseResolutionStageFilter('variant_merge,unknown'),
      throwsArgumentError,
    );
  });
}
