import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mix/mix.dart';

import '../parsing/markdown_syntax.dart';
import '../parsing/unsupported_nodes.dart';
import '../specs/markdown_spec.dart';
import 'markdown_document.dart';

/// Wraps a rendered block, for example to add a [Hero] around a heading.
///
/// [element] is the parsed node of the block. Do not mutate or retain it.
typedef MarkdownBlockWrapper =
    Widget Function(BuildContext context, md.Element element, Widget child);

/// Replaces a document that contains unsupported nodes.
///
/// [tags] names the offending Markdown element tags.
typedef MarkdownUnsupportedBuilder =
    Widget Function(BuildContext context, Set<String> tags);

/// Renders a Markdown document with Mix styles.
///
/// Supports paragraphs, headings, nested inline formatting, and GitHub
/// alerts. Links are styled but not activated. Images in prose contribute
/// their alt text. Standalone images (including linked images) and
/// other unsupported blocks go to [unsupportedBuilder], or display a
/// diagnostic when that is null. Unsupported raw inline HTML such as `<kbd>`
/// renders as literal text and does not invoke [unsupportedBuilder].
///
/// While mounted, the document is reparsed only when [data] or [syntax]
/// changes. Style, theme, and text scale updates reuse the parsed nodes. The
/// widget does not scroll. Place it in a scroll view, and in a
/// [SelectionArea] when the text should be selectable.
class MixMarkdown extends StatefulWidget {
  const MixMarkdown({
    required this.data,
    this.syntax = const MarkdownSyntax(),
    this.wrapBlock,
    this.unsupportedBuilder,
    this.style = const MarkdownStyler.create(),
    this.styleSpec,
    super.key,
  });

  /// Markdown source.
  final String data;

  /// Parser configuration.
  final MarkdownSyntax syntax;

  /// Wraps each rendered block.
  final MarkdownBlockWrapper? wrapBlock;

  /// Renders the whole document when it contains unsupported nodes.
  final MarkdownUnsupportedBuilder? unsupportedBuilder;

  /// Style applied to the document when [styleSpec] is not provided.
  final MarkdownStyler style;

  /// Resolved style that takes precedence over [style].
  final StyleSpec<MarkdownSpec>? styleSpec;

  @override
  State<MixMarkdown> createState() => _MixMarkdownState();
}

class _MixMarkdownState extends State<MixMarkdown> {
  late List<md.Node> _nodes;
  late Set<String> _unsupported;

  @override
  void initState() {
    super.initState();
    _parse();
  }

  void _parse() {
    _nodes = widget.syntax.createDocument().parse(widget.data);
    _unsupported = unsupportedNodes(_nodes);
  }

  @override
  void didUpdateWidget(MixMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data || widget.syntax != oldWidget.syntax) {
      _parse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildDocument(BuildContext context, MarkdownSpec spec) =>
        MarkdownDocument(
          spec: spec,
          nodes: _nodes,
          unsupported: _unsupported,
          wrapBlock: widget.wrapBlock,
          unsupportedBuilder: widget.unsupportedBuilder,
        );

    final styleSpec = widget.styleSpec;
    if (styleSpec != null) {
      return StyleSpecBuilder(builder: buildDocument, styleSpec: styleSpec);
    }

    return StyleBuilder(style: widget.style, builder: buildDocument);
  }
}
