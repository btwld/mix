import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mix/mix.dart';

import '../parsing/markdown_alert_element.dart';
import '../parsing/markdown_tags.dart';
import '../specs/markdown_spec.dart';
import 'inline_spans.dart';
import 'markdown_alert.dart';
import 'markdown_blocks.dart';
import 'markdown_text.dart';
import 'mix_markdown.dart';

class MarkdownDocument extends StatelessWidget {
  const MarkdownDocument({
    super.key,
    required this.nodes,
    required this.unsupported,
    required this.spec,
    this.wrapBlock,
    this.unsupportedBuilder,
  });

  final List<md.Node> nodes;
  final Set<String> unsupported;
  final MarkdownSpec spec;
  final MarkdownBlockWrapper? wrapBlock;
  final MarkdownUnsupportedBuilder? unsupportedBuilder;

  StyleSpec<TextSpec> _textSpecFor(MarkdownBlockTag block) {
    final heading = switch (block) {
      MarkdownBlockTag.paragraph => null,
      MarkdownBlockTag.h1 => spec.h1,
      MarkdownBlockTag.h2 => spec.h2,
      MarkdownBlockTag.h3 => spec.h3,
      MarkdownBlockTag.h4 => spec.h4,
      MarkdownBlockTag.h5 => spec.h5,
      MarkdownBlockTag.h6 => spec.h6,
    };

    return heading ?? spec.paragraph ?? const StyleSpec(spec: TextSpec());
  }

  Widget? _block(BuildContext context, md.Element element) {
    final alertType = element.alertType;
    final Widget child;
    if (alertType != null) {
      child = MarkdownAlert(
        type: alertType,
        styleSpec: spec.alert,
        blockSpacing: spec.blockSpacing,
        children: _blocks(context, element.alertContent),
      );
    } else {
      final spans = buildInlineSpans(element.children ?? const [], spec: spec);
      if (spans.isEmpty) return null;
      final block =
          MarkdownBlockTag.from(element.tag) ?? MarkdownBlockTag.paragraph;
      child = MarkdownText(
        spans: spans,
        block: block,
        styleSpec: _textSpecFor(block),
      );
    }

    return wrapBlock?.call(context, element, child) ?? child;
  }

  List<Widget> _blocks(BuildContext context, List<md.Node> elements) => [
    for (final element in elements.whereType<md.Element>())
      if (_block(context, element) case final block?) block,
  ];

  @override
  Widget build(BuildContext context) {
    if (unsupported.isNotEmpty) {
      return unsupportedBuilder?.call(context, unsupported) ??
          Text(
            'Unsupported Markdown: ${(unsupported.toList()..sort()).join(', ')}',
          );
    }

    return Box(
      styleSpec: spec.container,
      child: MarkdownBlocks(
        spacing: spec.blockSpacing,
        children: _blocks(context, nodes),
      ),
    );
  }
}
