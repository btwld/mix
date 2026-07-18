import 'package:mix_protocol/mix_protocol.dart';

/// Thin Flutter-boundary facade over the fixed Mix protocol instance.
final class MixFigmaBridge {
  const MixFigmaBridge();

  MixProtocolResult<MixProtocolTheme> materializeTheme(Object? document) =>
      mixProtocol.decodeTheme(document);

  MixProtocolResult<JsonMap> dematerializeTheme(MixProtocolTheme theme) =>
      mixProtocol.encodeTheme(theme);

  MixProtocolResult<T> materializeStyle<T extends Object>(
    Object? document, {
    MixProtocolDecodeOptions options = const MixProtocolDecodeOptions(),
  }) => mixProtocol.decodeStyle(document, options: options);

  MixProtocolResult<JsonMap> dematerializeStyle(
    Object style, {
    MixProtocolEncodeOptions options = const MixProtocolEncodeOptions(),
  }) => mixProtocol.encodeStyle(style, options: options);

  MixProtocolResult<MixProtocolThemeInspection> diffableTheme(
    Object? authoredDocument,
  ) => inspectThemeDocument(authoredDocument);

  MixProtocolResult<MixProtocolStyleInspection> diffableStyle(
    Object? authoredDocument, {
    MixProtocolIconResolver? resolveIcon,
    MixProtocolImageResolver? resolveImage,
  }) => inspectStyleDocument(
    authoredDocument,
    resolveIcon: resolveIcon,
    resolveImage: resolveImage,
  );

  /// Returns references from a materialized runtime style, not raw wire JSON.
  Set<MixProtocolTokenReference> tokenRefs(Object? materializedStyle) =>
      tokenReferencesOf(materializedStyle);
}
