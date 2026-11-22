import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart' as md;

import '../parsing/markdown_tags.dart';
import '../specs/markdown_spec.dart';

/// Builds the spans of one block from its inline [nodes].
///
/// A [transform] leaves inline code unchanged. It applies to contiguous prose
/// when only letter case changes, and to individual runs otherwise.
List<TextSpan> buildInlineSpans(
  List<md.Node> nodes, {
  required MarkdownSpec spec,
  String Function(String)? transform,
}) {
  final runs = <_Run>[];

  void collect(md.Node node, TextStyle style, {required bool inCode}) {
    if (node is md.Text) {
      final text = inCode ? node.text : node.text.replaceAll('\n', ' ');
      if (text.isNotEmpty) runs.add(_Run(text, style, inCode: inCode));

      return;
    }
    if (node is! md.Element) return;

    final tag = MarkdownInlineTag.from(node.tag);
    final inline = _inlineStyle(spec, tag);
    var merged = style.merge(inline);
    final inheritedDecoration = style.decoration;
    final inlineDecoration = inline.decoration;
    if (inheritedDecoration != null && inlineDecoration != null) {
      merged = merged.copyWith(
        decoration: TextDecoration.combine([
          inheritedDecoration,
          inlineDecoration,
        ]),
      );
    }
    switch (tag) {
      case MarkdownInlineTag.lineBreak:
        runs.add(_Run('\n', merged));
      case MarkdownInlineTag.image:
        final alt = node.attributes['alt'] ?? '';
        if (alt.isNotEmpty) runs.add(_Run(alt, merged));
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
  if (transform != null) return _transformRuns(runs, transform);

  return [for (final run in runs) TextSpan(text: run.text, style: run.style)];
}

List<TextSpan> _transformRuns(
  List<_Run> runs,
  String Function(String) transform,
) {
  final spans = <TextSpan>[];
  final prose = <_Run>[];
  for (final run in runs) {
    if (!run.inCode) {
      prose.add(run);
      continue;
    }

    if (prose.isNotEmpty) {
      spans.addAll(_transformProse(prose, transform));
      prose.clear();
    }
    spans.add(TextSpan(text: run.text, style: run.style));
  }
  if (prose.isNotEmpty) spans.addAll(_transformProse(prose, transform));

  return spans;
}

List<TextSpan> _transformProse(
  List<_Run> runs,
  String Function(String) transform,
) {
  List<TextSpan> transformIndividually() => [
    for (final run in runs)
      TextSpan(text: _transformRun(run.text, transform), style: run.style),
  ];

  final source = runs.map((run) => run.text).join().characters;
  final transformed = transform(source.string);
  final target = transformed.characters;
  if (source.length != target.length) {
    return transformIndividually();
  }

  final sourceClusters = source.iterator;
  final targetClusters = target.iterator;
  final spans = <TextSpan>[];
  var sourceEnd = 0;
  var targetStart = 0;
  var sourceClusterEnd = 0;
  var targetClusterEnd = 0;
  for (final run in runs) {
    sourceEnd += run.text.length;
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
        return transformIndividually();
      }
      final offset = sourceEnd - (sourceClusterEnd - sourceCluster.length);
      final leadingRunes = sourceCluster.substring(0, offset).runes.length;
      targetEnd -= String.fromCharCodes(
        targetCluster.runes.skip(leadingRunes),
      ).length;
    }
    final text = transformed.substring(targetStart, targetEnd);
    if (text != run.text &&
        text.toLowerCase() != run.text.toLowerCase() &&
        text.toUpperCase() != run.text.toUpperCase()) {
      return transformIndividually();
    }
    spans.add(TextSpan(text: text, style: run.style));
    targetStart = targetEnd;
  }

  return spans;
}

String _transformRun(String text, String Function(String) transform) {
  final transformed = transform(text);
  final trimmedLeft = text.trimLeft();
  if (trimmedLeft.isEmpty) return transformed.isEmpty ? text : transformed;

  final leading = transformed == transformed.trimLeft()
      ? text.substring(0, text.length - trimmedLeft.length)
      : '';
  final trailing = transformed == transformed.trimRight()
      ? text.substring(text.trimRight().length)
      : '';

  return '$leading$transformed$trailing';
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

class _Run {
  final String text;
  final TextStyle style;
  final bool inCode;

  const _Run(this.text, this.style, {this.inCode = false});
}
