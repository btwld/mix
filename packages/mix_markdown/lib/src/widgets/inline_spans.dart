import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart' as md;

import '../parsing/markdown_tags.dart';
import '../specs/markdown_spec.dart';

/// Builds the text spans of one block from its inline [nodes].
///
/// Code spans are marked so [transformInlineSpans] can preserve their text.
/// Decorations are combined when both the inner and inherited styles specify
/// one. An inner [TextDecoration.none] does not clear an inherited decoration.
List<TextSpan> buildInlineSpans(
  List<md.Node> nodes, {
  required MarkdownSpec spec,
}) {
  final spans = <TextSpan>[];

  void collect(md.Node node, TextStyle style, {required bool inCode}) {
    if (node is md.Text) {
      final text = inCode ? node.text : node.text.replaceAll('\n', ' ');
      if (text.isNotEmpty) {
        spans.add(
          inCode
              ? _CodeSpan(text: text, style: style)
              : TextSpan(text: text, style: style),
        );
      }

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

/// Applies [transform] to the joined block, using placeholders for inline
/// code so it contributes context without having its text transformed.
///
/// Keeps inline styles when case or separator changes preserve span boundaries,
/// or when per-span transforms match the block result ignoring whitespace. The
/// block result supplies the actual text and spacing in either case. If neither
/// mapping is safe, returns a single unstyled span with the code restored.
/// If placeholders are lost or duplicated, transforms each non-code span
/// separately and leaves code intact.
List<TextSpan> transformInlineSpans(
  List<TextSpan> spans,
  String Function(String) transform,
) {
  final codeSpans = spans.whereType<_CodeSpan>().toList();
  final original = spans.map((span) => span.text).join();
  var placeholder = '\uFFFC';
  while (codeSpans.isNotEmpty && original.contains(placeholder)) {
    placeholder = '\uE000$placeholder\uE001';
  }
  final spanTexts = [
    for (final span in spans) span is _CodeSpan ? placeholder : span.text!,
  ];
  final source = spanTexts.join();
  final transformed = transform(source);
  if (transformed == source) return spans;

  final parts = codeSpans.isEmpty ? null : transformed.split(placeholder);
  String transformRun(String text) =>
      parts != null && text == placeholder ? text : transform(text);

  List<String>? keepCodeBoundaries(List<String>? mapped) {
    if (mapped == null || parts == null) return mapped;

    for (final (index, span) in spans.indexed) {
      final text = mapped[index];
      if (span is _CodeSpan
          ? text.trim() != placeholder
          : text.contains(placeholder)) {
        return null;
      }
    }

    return mapped;
  }

  final mapped = parts != null && parts.length != codeSpans.length + 1
      ? spanTexts.map(transformRun).toList()
      : (keepCodeBoundaries(_mapCaseChanges(spanTexts, source, transformed)) ??
            keepCodeBoundaries(_mapRuns(spanTexts, transformed, transformRun)));
  if (mapped != null) {
    return [
      for (final (index, span) in spans.indexed)
        if (mapped[index].isNotEmpty)
          TextSpan(
            text: span is _CodeSpan
                ? mapped[index].replaceFirst(placeholder, span.text!)
                : mapped[index],
            style: span.style,
          ),
    ];
  }

  if (parts == null) return [TextSpan(text: transformed)];

  final restored = StringBuffer(parts.first);
  for (final (index, span) in codeSpans.indexed) {
    restored.write(span.text);
    restored.write(parts[index + 1]);
  }

  return [TextSpan(text: restored.toString())];
}

final _caseSeparators = RegExp(r'^[\s_-]+$');
final _nonWhitespace = RegExp(r'\S', unicode: true);

bool _matchesCaseOrSeparator(String source, String target) =>
    source == target ||
    source.toLowerCase() == target.toLowerCase() ||
    source.toUpperCase() == target.toUpperCase() ||
    (_caseSeparators.hasMatch(source) && _caseSeparators.hasMatch(target));

List<String>? _mapCaseChanges(
  List<String> spanTexts,
  String original,
  String transformed,
) {
  final source = original.characters;
  final target = transformed.characters;
  if (source.length != target.length) return null;

  final sourceClusters = source.iterator;
  final targetClusters = target.iterator;
  final mapped = <String>[];
  var sourceEnd = 0;
  var targetStart = 0;
  var sourceClusterEnd = 0;
  var targetClusterEnd = 0;
  for (final text in spanTexts) {
    sourceEnd += text.length;
    while (sourceClusterEnd < sourceEnd) {
      sourceClusters.moveNext();
      targetClusters.moveNext();
      if (!_matchesCaseOrSeparator(
        sourceClusters.current,
        targetClusters.current,
      )) {
        return null;
      }
      sourceClusterEnd += sourceClusters.current.length;
      targetClusterEnd += targetClusters.current.length;
    }

    var targetEnd = targetClusterEnd;
    if (sourceEnd < sourceClusterEnd) {
      final sourceCluster = sourceClusters.current;
      final targetCluster = targetClusters.current;
      if (sourceCluster.runes.length != targetCluster.runes.length) {
        return null;
      }
      final offset = sourceEnd - (sourceClusterEnd - sourceCluster.length);
      final leadingRunes = sourceCluster.substring(0, offset).runes.length;
      targetEnd -= String.fromCharCodes(
        targetCluster.runes.skip(leadingRunes),
      ).length;
    }
    mapped.add(transformed.substring(targetStart, targetEnd));
    targetStart = targetEnd;
  }

  return mapped;
}

List<String>? _mapRuns(
  List<String> spanTexts,
  String transformed,
  String Function(String) transform,
) {
  final target = _nonWhitespace.allMatches(transformed).iterator;
  var hasTarget = target.moveNext();
  final mapped = <String>[];
  var start = 0;
  for (final text in spanTexts) {
    final candidate = transform(text);
    var end = start;
    for (final match in _nonWhitespace.allMatches(candidate)) {
      if (!hasTarget || match.group(0) != target.current.group(0)) return null;

      end = target.current.end;
      hasTarget = target.moveNext();
    }
    final ownsGap = end == start
        ? _caseSeparators.hasMatch(text)
        : text != text.trimRight() || candidate != candidate.trimRight();
    if (hasTarget && ownsGap) {
      end = target.current.start;
    } else if (!hasTarget && end != start) {
      end = transformed.length;
    }
    mapped.add(transformed.substring(start, end));
    start = end;
  }

  return start == transformed.length ? mapped : null;
}

class _CodeSpan extends TextSpan {
  const _CodeSpan({required String super.text, required super.style});
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
