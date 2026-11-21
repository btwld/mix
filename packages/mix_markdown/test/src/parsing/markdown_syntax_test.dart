import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mix_markdown/mix_markdown.dart';
import 'package:mix_markdown/src/parsing/markdown_alert_element.dart';

void main() {
  test('configurations are equal when they hold the same instances', () {
    final marker = _MarkerSyntax();
    final a = MarkdownSyntax(inlineSyntaxes: [marker]);
    final b = MarkdownSyntax(inlineSyntaxes: [marker]);

    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(MarkdownSyntax(inlineSyntaxes: [_MarkerSyntax()])));
    expect(
      const MarkdownSyntax(),
      isNot(MarkdownSyntax(extensionSet: md.ExtensionSet.commonMark)),
    );
  });

  test('parses GitHub alerts by default and decodes entities', () {
    final nodes = const MarkdownSyntax().createDocument().parse(
      '> [!NOTE]\n> &amp; \\*x\\*',
    );
    final alert = nodes.single as md.Element;

    expect(alert.alertType, MarkdownAlertType.note);
    expect(alert.alertContent.single.textContent, '& *x*');
  });

  test('custom syntaxes take part in parsing', () {
    final nodes = MarkdownSyntax(
      inlineSyntaxes: [_MarkerSyntax()],
    ).createDocument().parse('a @@ b');
    final paragraph = nodes.single as md.Element;

    expect(paragraph.children!.whereType<md.Element>().single.tag, 'strong');
  });

  test('nested alerts share document-level references', () {
    const source =
        '> [!NOTE]\n'
        '> [outer][docs]\n>\n'
        '> > [!TIP]\n> > **[inner][docs]**\n\n'
        '[docs]: https://example.com/docs "Title"\n';
    final elements = _elements(
      const MarkdownSyntax().createDocument().parse(source),
    ).toList();
    final links = elements.where((e) => e.tag == 'a');

    expect(elements.where((e) => e.alertType != null), hasLength(2));
    expect(links, hasLength(2));
    expect(
      links.every((e) => e.attributes['href'] == 'https://example.com/docs'),
      isTrue,
    );
  });

  test('empty and Unicode input keep document boundaries', () {
    final document = const MarkdownSyntax().createDocument();

    expect(document.parse(''), isEmpty);
    expect(
      document.parse('日本語 العربية 😀').single.textContent,
      '日本語 العربية 😀',
    );
  });

  test('alert type is null for other elements', () {
    final nodes = const MarkdownSyntax().createDocument().parse(
      '<div class="markdown-alert">x</div>\n\n# Title',
    );

    expect(nodes.whereType<md.Element>().single.alertType, isNull);
  });
}

Iterable<md.Element> _elements(Iterable<md.Node> nodes) sync* {
  for (final node in nodes) {
    if (node is md.Element) {
      yield node;
      yield* _elements(node.children ?? const []);
    }
  }
}

class _MarkerSyntax extends md.InlineSyntax {
  _MarkerSyntax() : super('@@');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(md.Element.text('strong', 'marker'));

    return true;
  }
}
