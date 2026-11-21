import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mix/mix.dart';
import 'package:mix_markdown/mix_markdown.dart';
import 'package:mix_markdown/src/widgets/inline_spans.dart';

void main() {
  const spec = MarkdownSpec(
    strong: StyleSpec(
      spec: TextSpec(style: TextStyle(color: Color(0xff112233))),
    ),
    link: StyleSpec(
      spec: TextSpec(style: TextStyle(decoration: TextDecoration.underline)),
    ),
  );

  List<TextSpan> spans(String source, {String Function(String)? transform}) {
    final nodes = const MarkdownSyntax().createDocument().parseInline(source);

    return buildInlineSpans(
      nodes,
      spec: spec,
      transform: transform,
    ).cast<TextSpan>().toList();
  }

  String plain(List<TextSpan> result) =>
      TextSpan(children: result).toPlainText();

  test('nested bold and italic compose over the slot style', () {
    final run = spans('***both***').singleWhere((span) => span.text == 'both');

    expect(run.style?.fontWeight, FontWeight.bold);
    expect(run.style?.fontStyle, FontStyle.italic);
    expect(run.style?.color, const Color(0xff112233));
  });

  test('strikethrough, code, and links keep their inline styles', () {
    final result = spans('~~gone~~ `code` [docs](https://example.com)');
    TextSpan run(String text) => result.singleWhere((s) => s.text == text);

    expect(run('gone').style?.decoration, TextDecoration.lineThrough);
    expect(run('code').style?.fontFamily, 'monospace');
    expect(run('docs').style?.decoration, TextDecoration.underline);
    expect(run('docs').recognizer, isNull);
  });

  test('inline image contributes alt text only', () {
    final result = spans('before ![alt](asset.png) after');

    expect(plain(result), 'before alt after');
  });

  test('length-preserving transform keeps nested styles', () {
    final result = spans(
      'Hello ***world***',
      transform: (s) => s.toUpperCase(),
    );
    final world = result.singleWhere((s) => s.text == 'WORLD');

    expect(plain(result), 'HELLO WORLD');
    expect(world.style?.fontStyle, FontStyle.italic);
    expect(world.style?.fontWeight, FontWeight.bold);
  });

  test('length-changing transform falls back to one unstyled span', () {
    final result = spans(
      '**straße**',
      transform: (s) => s.replaceAll('ß', 'SS'),
    );

    expect(result, hasLength(1));
    expect(result.single.text, 'straSSe');
    expect(result.single.style, isNull);
  });

  test('a combining mark across runs stays outside the bold span', () {
    final result = spans('**a**\u0301b', transform: (s) => s.toUpperCase());

    expect(result.map((run) => run.text), ['A', '\u0301B']);
    expect(result.first.style?.fontWeight, FontWeight.bold);
    expect(result.last.style?.fontWeight, isNull);
  });

  test('only raw br tags outside inline code break lines', () {
    expect(
      plain(spans(r'a<br />b &lt;br&gt; \<br> `<br />`')),
      'a\nb <br> <br> <br />',
    );
  });

  test('soft line breaks become spaces', () {
    final nodes = const MarkdownSyntax().createDocument().parse(
      'one\ntwo **three\nfour**',
    );
    final paragraph = nodes.single as md.Element;

    expect(
      plain(
        buildInlineSpans(
          paragraph.children!,
          spec: spec,
        ).cast<TextSpan>().toList(),
      ),
      'one two three four',
    );
  });

  test('parsed hard breaks become line breaks', () {
    final nodes = const MarkdownSyntax().createDocument().parse('a  \nb');
    final paragraph = nodes.single as md.Element;

    expect(
      plain(
        buildInlineSpans(
          paragraph.children!,
          spec: spec,
        ).cast<TextSpan>().toList(),
      ),
      'a\nb',
    );
  });
}
