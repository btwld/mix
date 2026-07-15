import 'artifacts/capture_bundle.dart';
import 'artifacts/capture_loader.dart';
import 'artifacts/component_document.dart';
import 'portable_component_renderer.dart';
import 'sources/artifact_source.dart';
import 'sources/github_repository_source.dart';

export 'artifacts/component_document.dart'
    show
        AtlasPortableBinding,
        AtlasPortableNode,
        AtlasPortableSemantics,
        atlasPortableIconIdentities;
export 'producer/portable_component_builder.dart'
    show
        AtlasCompositeStyleProjector,
        AtlasPortableComponentBuilder,
        AtlasPortableProjectionException;

export 'sources/directory_source.dart' show AtlasDirectorySource;
export 'sources/github_repository_source.dart'
    show
        AtlasGitHubPullRequest,
        AtlasGitHubPullRequestList,
        AtlasGitHubRateLimit;

typedef AtlasCaptureFailureKind = ArtifactFailureKind;
typedef AtlasSourceKind = ArtifactSourceKind;
typedef AtlasCaptureException = ArtifactLoadException;
typedef AtlasRepositoryRequest = ArtifactRepositoryRequest;
typedef AtlasSourceReceipt = ArtifactSourceReceipt;
typedef AtlasCaptureProducer = CaptureProducer;
typedef AtlasCaptureFileEntry = CaptureFileEntry;
typedef AtlasCaptureThemeEntry = CaptureThemeEntry;
typedef AtlasCaptureComponentEntry = CaptureComponentDocumentEntry;
typedef AtlasCaptureManifest = CaptureManifest;
typedef AtlasCatalogTheme = CapturedCatalogTheme;
typedef AtlasComponentAsset = CapturedComponentAsset;
typedef AtlasCatalogComponent = CapturedComponent;
typedef AtlasCatalog = CapturedCatalog;
typedef AtlasVisualOracleMetadata = CapturedAtlasMetadata;
typedef AtlasVisualOracleAxis = CapturedAtlasAxis;
typedef AtlasVisualOracleAxisValue = CapturedAtlasAxisValue;
typedef AtlasVisualOracleRow = CapturedAtlasRow;
typedef AtlasVisualOracleScenario = CapturedAtlasScenario;
typedef AtlasDiagnostic = ProtocolDiagnostic;
typedef AtlasCoverageItem = ProtocolCoverageItem;
typedef AtlasCoverageSummary = ProtocolCoverageSummary;
typedef AtlasCapture = LoadedCapture;

typedef AtlasComponentPropertyKind = ComponentPropertyKind;
typedef AtlasComponentDocumentSchema = ComponentDocumentSchema;
typedef AtlasComponentSlotKind = ComponentSlotKind;
typedef AtlasEvidence = ComponentEvidence;
typedef AtlasSupportStatus = ComponentSupportStatus;
typedef AtlasAnatomyNodeKind = ComponentAnatomyNodeKind;
typedef AtlasConditionOperator = ComponentConditionOperator;
typedef AtlasComponentProperty = ComponentPropertyDefinition;
typedef AtlasComponentState = ComponentStateDefinition;
typedef AtlasComponentSlot = ComponentSlotDefinition;
typedef AtlasVisibilityCondition = ComponentVisibilityCondition;
typedef AtlasAnatomyNode = ComponentAnatomyNode;
typedef AtlasComponentAnatomy = ComponentAnatomy;
typedef AtlasComponentDiagnostic = ComponentDiagnostic;
typedef AtlasSlotStyle = ComponentSlotStyleReference;
typedef AtlasStyleLibraryEntry = ComponentStyleLibraryEntry;
typedef AtlasComponentRecipe = PortableComponentRecipe;
typedef AtlasSemanticsContract = ComponentSemanticsContract;
typedef AtlasVisualOracle = ComponentVisualOracle;
typedef AtlasComponentDocument = PortableComponentDocument;
typedef AtlasComponentSelection = PortableComponentSelection;

typedef AtlasArtifactSource = ArtifactSource;
typedef AtlasResolvedArtifactSource = ResolvedArtifactSource;
typedef AtlasHttpResponse = ArtifactHttpResponse;
typedef AtlasHttpClient = ArtifactHttpClient;
typedef AtlasIoHttpClient = IoArtifactHttpClient;
typedef AtlasGitHubRepositorySource = GitHubRepositorySource;

/// Strictly loads and validates a complete Atlas capture.
final class AtlasCaptureReader {
  final CaptureLoader _loader;

  AtlasCaptureReader({required AtlasArtifactSource source})
    : _loader = CaptureLoader(source: source);

  Future<AtlasCapture> load(AtlasRepositoryRequest request) =>
      _loader.load(request);
}

/// Reconstructs the whitelisted component-v1 and component-v2 vocabularies.
class AtlasPortableComponent extends PortableComponentRenderer {
  const AtlasPortableComponent({
    required super.capture,
    required super.component,
    required super.selection,
    super.onActivate,
    super.key,
  });
}
