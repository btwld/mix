const allocationInfoExtension = 'ext.mix.allocation.info';
const allocationWarmupExtension = 'ext.mix.allocation.warmup';
const allocationRunExtension = 'ext.mix.allocation.run';
const allocationFinishExtension = 'ext.mix.allocation.finish';

enum AllocationStage { control, variantMerge, specResolve, fullBuild }

enum AllocationProfile { static, allActive }

extension AllocationStageLabel on AllocationStage {
  String get label => switch (this) {
    AllocationStage.control => 'control_store',
    AllocationStage.variantMerge => 'variant_merge',
    AllocationStage.specResolve => 'premerged_spec_resolve',
    AllocationStage.fullBuild => 'full_style_build',
  };
}

extension AllocationProfileLabel on AllocationProfile {
  String get label => switch (this) {
    AllocationProfile.static => 'static',
    AllocationProfile.allActive => 'all_active',
  };
}

typedef AllocationBenchmarkCase = ({
  AllocationProfile profile,
  AllocationStage stage,
});

List<AllocationBenchmarkCase> allocationBenchmarkCases(String orderLabel) {
  final cases = <AllocationBenchmarkCase>[
    for (final profile in AllocationProfile.values)
      for (final stage in AllocationStage.values)
        (profile: profile, stage: stage),
  ];

  return switch (orderLabel) {
    'forward' => List<AllocationBenchmarkCase>.unmodifiable(cases),
    'reverse' => List<AllocationBenchmarkCase>.unmodifiable(cases.reversed),
    _ => throw ArgumentError.value(
      orderLabel,
      'orderLabel',
      'Expected forward or reverse',
    ),
  };
}
