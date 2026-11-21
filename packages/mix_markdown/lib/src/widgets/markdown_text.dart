import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mix/mix.dart';

import '../parsing/markdown_tags.dart';
import '../specs/markdown_spec.dart';
import 'inline_spans.dart';

class MarkdownText extends StatelessWidget {
  const MarkdownText({
    super.key,
    required this.element,
    required this.block,
    required this.styleSpec,
    required this.spec,
  });

  final md.Element element;
  final MarkdownBlockTag block;
  final StyleSpec<TextSpec> styleSpec;
  final MarkdownSpec spec;

  Widget _buildText(BuildContext context, TextSpec textSpec) {
    final spans = buildInlineSpans(
      element.children ?? const [],
      spec: spec,
      transform: textSpec.textDirectives?.apply,
    );
    if (spans.isEmpty) return const SizedBox.shrink();
    final text = Text.rich(
      TextSpan(children: spans),
      style: textSpec.style,
      strutStyle: textSpec.strutStyle,
      textAlign: textSpec.textAlign,
      textDirection: textSpec.textDirection,
      locale: textSpec.locale,
      softWrap: textSpec.softWrap,
      overflow: textSpec.overflow,
      textScaler: textSpec.textScaler,
      maxLines: textSpec.maxLines,
      semanticsLabel: textSpec.semanticsLabel,
      textWidthBasis: textSpec.textWidthBasis,
      textHeightBehavior: textSpec.textHeightBehavior,
      selectionColor: textSpec.selectionColor,
    );

    return block.isHeading ? Semantics(header: true, child: text) : text;
  }

  @override
  Widget build(BuildContext context) =>
      StyleSpecBuilder<TextSpec>(builder: _buildText, styleSpec: styleSpec);
}
