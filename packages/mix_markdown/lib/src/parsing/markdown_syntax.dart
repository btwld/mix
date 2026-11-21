import 'package:flutter/foundation.dart';
import 'package:markdown/markdown.dart' as md;

final _htmlBreak = _HtmlBreakSyntax();

class _HtmlBreakSyntax extends md.InlineSyntax {
  _HtmlBreakSyntax()
    : super(
        r'<br\s*/?>',
        caseSensitive: false,
        startCharacter: '<'.codeUnitAt(0),
      );

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(md.Element.empty('br'));

    return true;
  }
}

/// Parser configuration for a Markdown document.
///
/// Two configurations are equal when they hold the same syntax instances and
/// the same extension set, so a mounted renderer parses again only when the
/// configuration changes. Supply a new syntax instance when its behavior
/// changes, and treat the lists as immutable once passed in.
@immutable
class MarkdownSyntax {
  /// Block syntaxes tried before those of [extensionSet].
  final List<md.BlockSyntax> blockSyntaxes;

  /// Inline syntaxes tried before those of [extensionSet].
  final List<md.InlineSyntax> inlineSyntaxes;

  /// Extension set, [md.ExtensionSet.gitHubWeb] when null.
  final md.ExtensionSet? extensionSet;

  const MarkdownSyntax({
    this.blockSyntaxes = const [],
    this.inlineSyntaxes = const [],
    this.extensionSet,
  });

  /// Creates a parser for one document.
  ///
  /// HTML entities are decoded rather than encoded because the output is
  /// rendered as text, not markup.
  md.Document createDocument() => md.Document(
    blockSyntaxes: blockSyntaxes,
    inlineSyntaxes: [...inlineSyntaxes, _htmlBreak],
    extensionSet: extensionSet ?? md.ExtensionSet.gitHubWeb,
    encodeHtml: false,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkdownSyntax &&
          listEquals(blockSyntaxes, other.blockSyntaxes) &&
          listEquals(inlineSyntaxes, other.inlineSyntaxes) &&
          identical(extensionSet, other.extensionSet);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(blockSyntaxes),
    Object.hashAll(inlineSyntaxes),
    extensionSet,
  );
}
