/// Flutter producer-side APIs for projecting and building Atlas captures.
///
/// Pure Dart command-line packagers should import `packaging.dart` instead.
library;

export 'packaging.dart';
export 'src/artifacts/component_document.dart'
    show
        AtlasPortableBinding,
        AtlasPortableNode,
        AtlasPortableSemantics,
        atlasPortableIconIdentities,
        ComponentAnatomyNodeKind,
        ComponentConditionOperator,
        ComponentDiagnostic,
        ComponentEvidence,
        ComponentPropertyDefinition,
        ComponentPropertyKind,
        ComponentSlotDefinition,
        ComponentSlotKind,
        ComponentStateDefinition,
        ComponentVisibilityCondition,
        ComponentVisualOracle;
export 'src/producer/portable_component_builder.dart';
