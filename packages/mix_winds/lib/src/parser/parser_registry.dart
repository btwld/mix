/// Generated-data backed Tailwind parser registry.
library;

final class TailwindParserRegistry {
  static const empty = TailwindParserRegistry();

  final Set<String> staticUtilityRoots;

  final Set<String> functionalUtilityRoots;
  final Set<String> staticVariantRoots;
  final Set<String> functionalVariantRoots;
  final Set<String> compoundVariantRoots;
  const TailwindParserRegistry({
    this.staticUtilityRoots = const {},
    this.functionalUtilityRoots = const {},
    this.staticVariantRoots = const {},
    this.functionalVariantRoots = const {},
    this.compoundVariantRoots = const {},
  });
}
