/// Generated-data backed Tailwind parser registry.
library;

typedef JsonMap = Map<String, Object?>;

final class TailwindParserRegistry {
  TailwindParserRegistry({
    Set<String> staticUtilityRoots = const {},
    Set<String> functionalUtilityRoots = const {},
    Set<String> staticVariantRoots = const {},
    Set<String> functionalVariantRoots = const {},
    Set<String> compoundVariantRoots = const {},
    Set<String> customUtilityRoots = const {},
    Set<String> customVariantRoots = const {},
    Map<String, Object?> meta = const {},
  }) : staticUtilityRoots = Set.unmodifiable(staticUtilityRoots),
       functionalUtilityRoots = Set.unmodifiable(functionalUtilityRoots),
       staticVariantRoots = Set.unmodifiable(staticVariantRoots),
       functionalVariantRoots = Set.unmodifiable(functionalVariantRoots),
       compoundVariantRoots = Set.unmodifiable(compoundVariantRoots),
       customUtilityRoots = Set.unmodifiable(customUtilityRoots),
       customVariantRoots = Set.unmodifiable(customVariantRoots),
       meta = Map.unmodifiable(meta);

  const TailwindParserRegistry._empty()
    : staticUtilityRoots = const {},
      functionalUtilityRoots = const {},
      staticVariantRoots = const {},
      functionalVariantRoots = const {},
      compoundVariantRoots = const {},
      customUtilityRoots = const {},
      customVariantRoots = const {},
      meta = const {};

  static const empty = TailwindParserRegistry._empty();

  factory TailwindParserRegistry.fromJson(JsonMap json) {
    return TailwindParserRegistry(
      staticUtilityRoots: _stringSet(json['staticUtilityRoots']),
      functionalUtilityRoots: _stringSet(json['functionalUtilityRoots']),
      staticVariantRoots: _stringSet(json['staticVariantRoots']),
      functionalVariantRoots: _stringSet(json['functionalVariantRoots']),
      compoundVariantRoots: _stringSet(json['compoundVariantRoots']),
      customUtilityRoots: _stringSet(json['customUtilityRoots']),
      customVariantRoots: _stringSet(json['customVariantRoots']),
      meta: (json['meta'] as Map?)?.cast<String, Object?>() ?? const {},
    );
  }

  final Set<String> staticUtilityRoots;
  final Set<String> functionalUtilityRoots;
  final Set<String> staticVariantRoots;
  final Set<String> functionalVariantRoots;
  final Set<String> compoundVariantRoots;
  final Set<String> customUtilityRoots;
  final Set<String> customVariantRoots;
  final Map<String, Object?> meta;

  bool isStaticUtility(String root) =>
      staticUtilityRoots.contains(root) || customUtilityRoots.contains(root);

  bool isFunctionalUtility(String root) =>
      functionalUtilityRoots.contains(root) ||
      customUtilityRoots.contains(root);

  bool isStaticVariant(String root) =>
      staticVariantRoots.contains(root) || customVariantRoots.contains(root);

  bool isFunctionalVariant(String root) =>
      functionalVariantRoots.contains(root) ||
      customVariantRoots.contains(root);

  bool isCompoundVariant(String root) => compoundVariantRoots.contains(root);
}

Set<String> _stringSet(Object? value) {
  if (value is! Iterable) return const {};
  return value.whereType<String>().toSet();
}
