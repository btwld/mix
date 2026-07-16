import '../diagnostics.dart';

final _aliasPattern = RegExp(r'^\{([^{}]+)\}$');
final _tokenNamePattern = RegExp(r'^[A-Za-z0-9_.-]{1,128}$');

/// A single design token parsed from a DTCG document.
final class DtcgToken {
  const DtcgToken({
    required this.path,
    required this.value,
    this.type,
    this.description,
  });

  /// Dot-separated token path (group names joined with `.`).
  final String path;

  /// The raw `$value` payload, unmodified.
  final Object? value;

  /// Effective `$type`: the token's own or the nearest ancestor group's.
  /// Null when neither declares one (aliases commonly rely on their target).
  final String? type;

  final String? description;

  /// The referenced token path when `$value` is a whole-value alias like
  /// `"{color.primary}"`, otherwise null.
  String? get aliasTarget {
    final value = this.value;
    if (value is! String) return null;

    return _aliasPattern.firstMatch(value)?.group(1);
  }

  bool get isAlias => aliasTarget != null;
}

/// Tokens extracted from a DTCG document plus any structural diagnostics.
final class DtcgParseResult {
  const DtcgParseResult({required this.tokens, required this.diagnostics});

  /// Parsed tokens keyed by dot-separated path, in document order.
  final Map<String, DtcgToken> tokens;

  final List<MixFigmaDiagnostic> diagnostics;
}

/// Parses a decoded DTCG (Design Tokens Format Module 2025.10) document into
/// a flat token map.
///
/// Groups are maps without `$value`; tokens are maps with `$value`. A group's
/// `$type` is inherited by descendant tokens that do not declare their own.
/// Keys are normalized to the `mix_protocol` token-name grammar (`/` becomes
/// `.`, spaces become `-`); keys that still do not fit are skipped with a
/// diagnostic.
DtcgParseResult parseDtcgDocument(Map<String, Object?> document) {
  final tokens = <String, DtcgToken>{};
  final diagnostics = <MixFigmaDiagnostic>[];

  void visit(Map<String, Object?> node, String prefix, String? inheritedType) {
    final ownType = node[r'$type'];
    final groupType = ownType is String ? ownType : inheritedType;

    for (final entry in node.entries) {
      final key = entry.key;
      if (key.startsWith(r'$')) continue;

      final normalized = key.replaceAll('/', '.').replaceAll(' ', '-');
      final path = prefix.isEmpty ? normalized : '$prefix.$normalized';
      if (!_tokenNamePattern.hasMatch(path)) {
        diagnostics.add(
          MixFigmaDiagnostic(
            path: path,
            message:
                'name does not fit the mix_protocol token-name grammar '
                '([A-Za-z0-9_.-]{1,128}); token or group skipped',
          ),
        );
        continue;
      }

      final value = entry.value;
      if (value is! Map<String, Object?>) {
        diagnostics.add(
          MixFigmaDiagnostic(
            path: path,
            message:
                'expected a group or token object, found '
                '${value.runtimeType}; skipped',
          ),
        );
        continue;
      }

      if (value.containsKey(r'$value')) {
        final tokenType = value[r'$type'];
        final description = value[r'$description'];
        tokens[path] = DtcgToken(
          path: path,
          value: value[r'$value'],
          type: tokenType is String ? tokenType : groupType,
          description: description is String ? description : null,
        );
      } else {
        visit(value, path, groupType);
      }
    }
  }

  visit(document, '', null);

  return DtcgParseResult(tokens: tokens, diagnostics: diagnostics);
}
