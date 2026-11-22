import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart' as md;

import '../parsing/markdown_tags.dart';
import '../specs/markdown_spec.dart';

/// Builds the text spans of one block from its inline [nodes].
List<TextSpan> buildInlineSpans(
  List<md.Node> nodes, {
  required MarkdownSpec spec,
}) {
  final spans = <TextSpan>[];

  void collect(md.Node node, TextStyle style, {required bool inCode}) {
    if (node is md.Text) {
      final text = inCode ? node.text : node.text.replaceAll('\n', ' ');
      if (text.isNotEmpty) spans.add(TextSpan(text: text, style: style));

      return;
    }
    if (node is! md.Element) return;

    final tag = MarkdownInlineTag.from(node.tag);
    final merged = style.merge(_inlineStyle(spec, tag));
    switch (tag) {
      case MarkdownInlineTag.lineBreak:
        spans.add(TextSpan(text: '\n', style: merged));
      case MarkdownInlineTag.image:
        final alt = node.attributes['alt'] ?? '';
        if (alt.isNotEmpty) spans.add(TextSpan(text: alt, style: merged));
      case MarkdownInlineTag.strong:
      case MarkdownInlineTag.boldAlias:
      case MarkdownInlineTag.emphasis:
      case MarkdownInlineTag.italicAlias:
      case MarkdownInlineTag.strikethrough:
      case MarkdownInlineTag.strikethroughAlias:
      case MarkdownInlineTag.link:
      case MarkdownInlineTag.code:
      case null:
        final nested = inCode || tag == MarkdownInlineTag.code;
        for (final child in node.children ?? const <md.Node>[]) {
          collect(child, merged, inCode: nested);
        }
    }
  }

  for (final node in nodes) {
    collect(node, const TextStyle(), inCode: false);
  }

  return spans;
}

/// Transforms one block's spans as a whole. Inline styles are retained only
/// when the original span boundaries can be mapped onto the result.
List<TextSpan> transformInlineSpans(
  List<TextSpan> spans,
  String Function(String) transform,
) {
  final source = spans.map((span) => span.text).join().characters;
  final transformed = transform(source.string);
  final target = transformed.characters;
  if (source.length != target.length) {
    return [TextSpan(text: transformed)];
  }

  final sourceClusters = source.iterator;
  final targetClusters = target.iterator;
  final transformedSpans = <TextSpan>[];
  var sourceEnd = 0;
  var targetStart = 0;
  var sourceClusterEnd = 0;
  var targetClusterEnd = 0;
  for (final span in spans) {
    sourceEnd += span.text!.length;
    while (sourceClusterEnd < sourceEnd) {
      sourceClusters.moveNext();
      targetClusters.moveNext();
      sourceClusterEnd += sourceClusters.current.length;
      targetClusterEnd += targetClusters.current.length;
    }

    var targetEnd = targetClusterEnd;
    if (sourceEnd < sourceClusterEnd) {
      final sourceCluster = sourceClusters.current;
      final targetCluster = targetClusters.current;
      if (sourceCluster.runes.length != targetCluster.runes.length) {
        return [TextSpan(text: transformed)];
      }
      final offset = sourceEnd - (sourceClusterEnd - sourceCluster.length);
      final leadingRunes = sourceCluster.substring(0, offset).runes.length;
      targetEnd -= String.fromCharCodes(
        targetCluster.runes.skip(leadingRunes),
      ).length;
    }
    transformedSpans.add(
      TextSpan(
        text: transformed.substring(targetStart, targetEnd),
        style: span.style,
      ),
    );
    targetStart = targetEnd;
  }

  return transformedSpans;
}

TextStyle _inlineStyle(MarkdownSpec spec, MarkdownInlineTag? tag) =>
    switch (tag) {
      MarkdownInlineTag.strong ||
      MarkdownInlineTag.boldAlias => const TextStyle(
        fontWeight: FontWeight.bold,
      ).merge(spec.strong?.spec.style),
      MarkdownInlineTag.emphasis ||
      MarkdownInlineTag.italicAlias => const TextStyle(
        fontStyle: FontStyle.italic,
      ).merge(spec.emphasis?.spec.style),
      MarkdownInlineTag.strikethrough ||
      MarkdownInlineTag.strikethroughAlias => const TextStyle(
        decoration: TextDecoration.lineThrough,
      ).merge(spec.strikethrough?.spec.style),
      MarkdownInlineTag.code => const TextStyle(
        fontFamily: 'monospace',
      ).merge(spec.code?.spec.style),
      MarkdownInlineTag.link => spec.link?.spec.style ?? const TextStyle(),
      MarkdownInlineTag.lineBreak ||
      MarkdownInlineTag.image ||
      null => const TextStyle(),
    };
