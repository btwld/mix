/// Immutable selection preserved across every Atlas review surface.
final class AtlasReviewContext {
  final String repository;

  final String baselineRef;
  final String currentRef;
  final String? componentId;
  final String? recipeId;
  final String? stateId;
  final String? themeId;
  final String? slotId;
  final String? property;
  final String? tokenKind;
  final String? tokenName;
  const AtlasReviewContext({
    required this.repository,
    required this.baselineRef,
    required this.currentRef,
    this.componentId,
    this.recipeId,
    this.stateId,
    this.themeId,
    this.slotId,
    this.property,
    this.tokenKind,
    this.tokenName,
  });

  AtlasReviewContext copyWith({
    String? repository,
    String? baselineRef,
    String? currentRef,
    String? componentId,
    String? recipeId,
    String? stateId,
    String? themeId,
    String? slotId,
    String? property,
    String? tokenKind,
    String? tokenName,
    bool clearEvidence = false,
  }) => .new(
    repository: repository ?? this.repository,
    baselineRef: baselineRef ?? this.baselineRef,
    currentRef: currentRef ?? this.currentRef,
    componentId: componentId ?? this.componentId,
    recipeId: recipeId ?? this.recipeId,
    stateId: stateId ?? this.stateId,
    themeId: themeId ?? this.themeId,
    slotId: slotId ?? this.slotId,
    property: clearEvidence ? null : (property ?? this.property),
    tokenKind: clearEvidence ? null : (tokenKind ?? this.tokenKind),
    tokenName: clearEvidence ? null : (tokenName ?? this.tokenName),
  );
}
