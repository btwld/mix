import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../parsing/markdown_tags.dart';
import 'inline_spans.dart';

class MarkdownText extends StatelessWidget {
  const MarkdownText({
    super.key,
    required this.spans,
    required this.block,
    required this.styleSpec,
  });

  final List<TextSpan> spans;
  final MarkdownBlockTag block;
  final StyleSpec<TextSpec> styleSpec;

  Widget _buildText(BuildContext context, TextSpec textSpec) {
    final transform = textSpec.textDirectives?.apply;
    final text = Text.rich(
      TextSpan(
        children: transform == null
            ? spans
            : transformInlineSpans(spans, transform),
      ),
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
