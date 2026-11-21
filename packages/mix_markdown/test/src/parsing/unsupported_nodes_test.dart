import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mix_markdown/mix_markdown.dart';
import 'package:mix_markdown/src/parsing/unsupported_nodes.dart';

void main() {
  List<md.Node> parse(String source) =>
      const MarkdownSyntax().createDocument().parse(source);

  test('supported subset reports nothing', () {
    const source =
        '# Title\n\nText with **bold**, `code`, [a](x) and ![i](y).\n\n'
        '> [!TIP]\n> Nested *alert*\n>\n> > [!NOTE]\n> > Inner';

    expect(unsupportedNodes(parse(source)), isEmpty);
  });

  test('reports unsupported blocks, including inside alerts', () {
    expect(unsupportedNodes(parse('- item')), {'ul'});
    expect(unsupportedNodes(parse('| h |\n|---|\n| b |')), {'table'});
    expect(unsupportedNodes(parse('> [!NOTE]\n> - item')), {'ul'});
    expect(unsupportedNodes(parse('```dart\nx\n```')), {'pre'});
  });

  test('reports block-level raw text', () {
    expect(unsupportedNodes(parse('<div>\nraw\n</div>')), {'text'});
  });

  test('reports a paragraph that holds only an image', () {
    const linkedImage =
        '[![CI](https://example.com/badge.svg)]'
        '(https://example.com/build)';
    for (final source in [
      '![alt][img]\n\n[img]: image.png',
      linkedImage,
      '$linkedImage<br>',
    ]) {
      expect(unsupportedNodes(parse(source)), {
        'standalone-image',
      }, reason: source);
    }
    expect(unsupportedNodes(parse('text ![alt](image.png)')), isEmpty);
  });
}
