import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:highlight/highlight.dart' as syntax;
import 'package:remix/remix.dart';

import '../ui/ui.dart';

const _ink = Color(0xFF0C1733);
const _muted = Color(0xFF62708E);
const _edge = Color(0xFFDCE4F0);
const _stage = Color(0xFFF7F9FC);

class SourcePanel extends StatefulWidget {
  const SourcePanel({super.key, required this.path});
  final String path;

  @override
  State<SourcePanel> createState() => _SourcePanelState();
}

class _SourcePanelState extends State<SourcePanel> {
  late Future<_SourceData> _data;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _data = _load(widget.path);
  }

  @override
  void didUpdateWidget(covariant SourcePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _data = _load(widget.path);
      _copied = false;
    }
  }

  Future<_SourceData> _load(String path) async {
    final source = await rootBundle.loadString(path);
    final excerpt = widgetExcerpt(source);
    final parsed = syntax.highlight.parse(excerpt, language: 'dart');
    return _SourceData(source, excerpt, [
      for (final node in parsed.nodes ?? []) _span(node),
    ]);
  }

  Future<void> _copy() async {
    try {
      final data = await _data;
      await Clipboard.setData(ClipboardData(text: data.source));
      if (mounted) setState(() => _copied = true);
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not copy source.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => UiCard(
    style: CardStyler().padding(.all(16)).borderRadius(.circular(10)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Example code',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
            ),
            UiButton.outline(
              label: _copied ? 'Copied' : 'Copy code',
              size: .small,
              onPressed: () => unawaited(_copy()),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Widget and supporting styles · Copy the full runnable file',
          style: TextStyle(color: _muted, fontSize: 13),
        ),
        const SizedBox(height: 14),
        Container(
          height: 370,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: _stage,
            border: Border.all(color: _edge),
            borderRadius: BorderRadius.circular(7),
          ),
          child: FutureBuilder<_SourceData>(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Source unavailable'));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data!;
              return SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          List.generate(
                            data.lineCount,
                            (i) => '${i + 1}',
                          ).join('\n'),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            height: 1.55,
                            color: Color(0xFF8894AA),
                          ),
                        ),
                        const SizedBox(width: 24),
                        SelectableText.rich(
                          TextSpan(children: data.spans),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            height: 1.55,
                            color: _ink,
                          ),
                          textWidthBasis: TextWidthBasis.longestLine,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _SourceData {
  const _SourceData(this.source, this.excerpt, this.spans);
  final String source;
  final String excerpt;
  final List<InlineSpan> spans;
  int get lineCount => '\n'.allMatches(excerpt).length + 1;
}

/// Drops only the standalone app shell. The visible code is still taken from
/// the same source that the copy action puts on the clipboard.
String widgetExcerpt(String source) {
  final main = source.indexOf('void main() => runApp(');
  if (main < 0) return source.trim();
  final end = source.indexOf(RegExp(r'^\);\s*$', multiLine: true), main);
  if (end < 0) return source.trim();
  final shellEnd = source.indexOf('\n', end);
  var prelude = source
      .substring(0, main)
      .replaceAll(RegExp(r'^import [^\n]*\n', multiLine: true), '');
  // DartPad instructions immediately preceding main belong to the shell.
  prelude = prelude.replaceFirst(RegExp(r'(?:\s*///[^\n]*\n)+\s*$'), '');
  final widget = source.substring(shellEnd < 0 ? source.length : shellEnd + 1);
  return '${prelude.trim()}\n\n${widget.trim()}'.trim();
}

TextSpan _span(syntax.Node node) => TextSpan(
  text: node.value,
  style: TextStyle(
    color: switch (node.className) {
      'keyword' || 'selector-tag' => const Color(0xFF155EEF),
      'string' || 'regexp' => const Color(0xFFB43E50),
      'comment' || 'quote' => const Color(0xFF71809A),
      'number' || 'literal' => const Color(0xFF7B4DB2),
      'title' || 'class' || 'type' => const Color(0xFF174D9C),
      'meta' || 'built_in' => const Color(0xFFAF6114),
      _ => null,
    },
  ),
  children: node.children?.map(_span).toList(),
);
