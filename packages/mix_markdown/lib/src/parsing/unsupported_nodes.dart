import 'package:markdown/markdown.dart' as md;

import 'markdown_alert_element.dart';
import 'markdown_tags.dart';

final _htmlComment = RegExp(r'<!--.*?-->', dotAll: true);

/// The tags in [nodes] that the renderer cannot draw; empty when it can
/// draw the whole document.
///
/// Block-level text, which the parser emits for raw HTML, reports `text`.
/// Whitespace and HTML comments in block-level text are ignored.
/// A paragraph holding only an image reports `standalone-image`, because
/// rendering it as alt text would silently drop the image.
Set<String> unsupportedNodes(List<md.Node> nodes) {
  final unsupported = <String>{};

  void visitInline(md.Node node, {bool inCode = false}) {
    if (node is! md.Element) return;
    final tag = MarkdownInlineTag.from(node.tag);
    if (tag == null && !(inCode && node.tag == 'span')) {
      unsupported.add(node.tag);

      return;
    }
    for (final child in node.children ?? const <md.Node>[]) {
      visitInline(child, inCode: tag == MarkdownInlineTag.code);
    }
  }

  void visitBlock(md.Node node) {
    if (node is md.Text) {
      if (node.text.replaceAll(_htmlComment, '').trim().isNotEmpty) {
        unsupported.add('text');
      }

      return;
    }
    if (node is! md.Element) return;
    if (node.alertType != null) {
      node.alertContent.forEach(visitBlock);

      return;
    }
    final block = MarkdownBlockTag.from(node.tag);
    if (block == null) {
      unsupported.add(node.tag);

      return;
    }
    if (block == MarkdownBlockTag.paragraph && _isStandaloneImage(node)) {
      unsupported.add('standalone-image');
    }
    node.children?.forEach(visitInline);
  }

  nodes.forEach(visitBlock);

  return Set.unmodifiable(unsupported);
}

bool _isStandaloneImage(md.Element paragraph) {
  final content = _inlineContent(paragraph).singleOrNull;

  return content is md.Element && content.tag == MarkdownInlineTag.image.tag;
}

Iterable<md.Node> _inlineContent(md.Node node) sync* {
  if (node is md.Element && node.tag != MarkdownInlineTag.image.tag) {
    for (final child in node.children ?? const <md.Node>[]) {
      yield* _inlineContent(child);
    }
  } else if (node is! md.Text || node.text.trim().isNotEmpty) {
    yield node;
  }
}
