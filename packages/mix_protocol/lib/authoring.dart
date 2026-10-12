/// Public authoring surface for package-contributed protocol vocabularies.
///
/// The underlying schema engine remains private to `mix_protocol`.
library;

export 'src/contract/json_map.dart' show JsonMap;
export 'src/schema/vocabulary.dart'
    show
        MixProtocolBranchContext,
        MixProtocolCodecs,
        MixProtocolField,
        MixProtocolFieldCodec,
        MixProtocolStylerBranch,
        MixProtocolStylerBranchBase,
        MixProtocolStylerCodec,
        MixProtocolStylerMetadata,
        MixProtocolStylerMetadataBase,
        MixProtocolValueCodec,
        MixProtocolVocabulary;
