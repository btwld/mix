/// Deterministic producer-side APIs for building and checking Atlas captures.
///
/// Import this library from command-line tooling to avoid loading viewer-only
/// Flutter reconstruction and source-adapter APIs.
library;

export 'src/packaging/capture_packager.dart';
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
