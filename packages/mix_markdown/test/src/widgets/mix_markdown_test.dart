import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mix/mix.dart';
import 'package:mix_markdown/mix_markdown.dart';
import 'package:mix_markdown/src/widgets/markdown_alert.dart';
import 'package:mix_markdown/src/widgets/markdown_blocks.dart';

void main() {
  Widget app(
    Widget child, {
    double scale = 1,
    double width = 320,
    TextDirection direction = TextDirection.ltr,
    Brightness brightness = Brightness.light,
  }) => MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: MediaQuery(
      data: MediaQueryData(
        textScaler: TextScaler.linear(scale),
        platformBrightness: brightness,
      ),
      child: Directionality(
        textDirection: direction,
        child: Material(
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              child: SingleChildScrollView(child: child),
            ),
          ),
        ),
      ),
    ),
  );

  group('parsing lifecycle', () {
    testWidgets('document modifier changes do not reparse', (tester) async {
      final marker = _MarkerSyntax();
      final syntax = MarkdownSyntax(inlineSyntaxes: [marker]);
      Future<void> pump(MarkdownStyler style) => tester.pumpWidget(
        app(MixMarkdown(data: '@@', syntax: syntax, style: style)),
      );

      final style = MarkdownStyler();
      await pump(style);
      await pump(style.wrap(.opacity(0.5)));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Opacity && widget.opacity == 0.5,
        ),
        findsOneWidget,
      );
      await pump(style);

      expect(marker.matches, 1);
    });

    testWidgets('new data or syntax parses again', (tester) async {
      final marker = _MarkerSyntax();
      Future<void> pump(String data, [_MarkerSyntax? custom]) =>
          tester.pumpWidget(
            app(
              MixMarkdown(
                data: data,
                syntax: MarkdownSyntax(inlineSyntaxes: [custom ?? marker]),
              ),
            ),
          );

      await pump('@@');
      await pump('@@ again');
      expect(marker.matches, 2);
      expect(find.text('marker again', findRichText: true), findsOneWidget);

      final replacement = _MarkerSyntax();
      await pump('@@ again', replacement);
      expect(replacement.matches, 1);
    });

    testWidgets('brightness and text scale update without a parse', (
      tester,
    ) async {
      final style = MarkdownStyler(
        paragraph: TextStyler()
            .color(Colors.black)
            .onDark(TextStyler().color(Colors.white)),
      );
      final marker = _MarkerSyntax();
      final document = MixMarkdown(
        data: '@@',
        style: style,
        syntax: MarkdownSyntax(inlineSyntaxes: [marker]),
      );
      Text body() => tester.widget<Text>(find.text('marker'));

      await tester.pumpWidget(app(document));
      expect(body().style?.color, Colors.black);

      await tester.pumpWidget(
        app(document, brightness: Brightness.dark, scale: 1.5),
      );
      await tester.pumpAndSettle();
      expect(body().style?.color, Colors.white);
      expect(marker.matches, 1);

      final rich = tester.widget<RichText>(
        find.descendant(
          of: find.text('marker'),
          matching: find.byType(RichText),
        ),
      );
      expect(rich.textScaler.scale(20), 30);
    });
  });

  group('blocks', () {
    testWidgets('headings and paragraphs render with heading semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          const MixMarkdown(
            data:
                '# One\n\n## Two\n\n### Three\n\n#### Four\n\n##### Five\n\n###### Six\n\nBody',
          ),
        ),
      );

      for (final label in [
        'One',
        'Two',
        'Three',
        'Four',
        'Five',
        'Six',
        'Body',
      ]) {
        expect(find.text(label, findRichText: true), findsOneWidget);
      }
      final headers = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .where((s) => s.properties.header == true);
      expect(headers, hasLength(6));
    });

    testWidgets('heading slots fall back to the paragraph slot', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          MixMarkdown(
            data: '# Title\n\n## Sub',
            style: MarkdownStyler(
              paragraph: TextStyler().fontSize(10),
              h1: TextStyler().fontSize(30),
            ),
          ),
        ),
      );

      expect(tester.widget<Text>(find.text('Title')).style?.fontSize, 30);
      expect(tester.widget<Text>(find.text('Sub')).style?.fontSize, 10);
    });

    testWidgets('block spacing applies between blocks and inside alerts', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          MixMarkdown(
            data: 'first\n\n> [!NOTE]\n> second\n>\n> third',
            style: MarkdownStyler(blockSpacing: 12),
          ),
        ),
      );

      final columns = tester.widgetList<Column>(
        find.descendant(
          of: find.byType(MarkdownBlocks),
          matching: find.byType(Column),
        ),
      );
      expect(columns, hasLength(2));
      expect(columns.every((column) => column.spacing == 12), isTrue);
    });

    testWidgets('empty blocks add no spacing and are not wrapped', (
      tester,
    ) async {
      final wrapped = <String>[];
      await tester.pumpWidget(
        app(
          MixMarkdown(
            data: 'first\n\n#\n\n> [!NOTE]\n> ##\n>\n> inside\n\nlast',
            style: MarkdownStyler(blockSpacing: 12),
            wrapBlock: (context, element, child) {
              wrapped.add(element.tag);

              return child;
            },
          ),
        ),
      );

      final first = find.text('first');
      final alert = find.byType(MarkdownAlert);
      final last = find.text('last');
      expect(tester.getTopLeft(alert).dy - tester.getBottomLeft(first).dy, 12);
      expect(tester.getTopLeft(last).dy - tester.getBottomLeft(alert).dy, 12);
      final alertBlocks = tester.widget<MarkdownBlocks>(
        find.descendant(of: alert, matching: find.byType(MarkdownBlocks)),
      );
      expect(alertBlocks.children, hasLength(2));
      expect(wrapped, ['p', 'p', 'div', 'p']);
    });

    testWidgets('empty body renders nothing and does not throw', (
      tester,
    ) async {
      await tester.pumpWidget(app(const MixMarkdown(data: '')));

      expect(find.byType(Text), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('wraps under a narrow constraint and inherits direction', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          const MixMarkdown(
            data: 'العربية 日本語 long long long long long long long long',
          ),
          direction: TextDirection.rtl,
          scale: 1.5,
        ),
      );

      final paragraph = tester.renderObject<RenderParagraph>(
        find.byType(RichText).last,
      );
      expect(paragraph.textDirection, TextDirection.rtl);
      expect(
        tester.getSize(find.byType(MixMarkdown)).width,
        lessThanOrEqualTo(320),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('text directives keep equal-length inline styles', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          MixMarkdown(
            data: 'hello **world**',
            style: MarkdownStyler(paragraph: TextStyler().uppercase()),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('HELLO WORLD'));
      final world = text.textSpan!.getSpanForPosition(
        const TextPosition(offset: 7),
      );
      expect(world?.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('a host SelectionArea registers the text', (tester) async {
      await tester.pumpWidget(
        app(
          const SelectionArea(child: MixMarkdown(data: '**Selectable** body')),
        ),
      );

      final richTexts = tester.widgetList<RichText>(find.byType(RichText));
      expect(richTexts.any((t) => t.selectionRegistrar != null), isTrue);

      await tester.pumpWidget(app(const SizedBox.shrink()));
      expect(tester.takeException(), isNull);
    });
  });

  group('alerts', () {
    testWidgets('long alert title wraps at narrow widths with scaled text', (
      tester,
    ) async {
      const label = 'A long localized alert title';
      await tester.pumpWidget(
        app(
          MixMarkdown(
            data: '> [!NOTE]\n> Body',
            style: MarkdownStyler(
              alert: MarkdownAlertStyler(
                note: MarkdownAlertTypeStyler(label: label),
              ),
            ),
          ),
          width: 150,
          scale: 2,
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.text(label)).width, lessThan(150));
    });

    testWidgets('alert headers support intrinsic sizing in a dialog', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AlertDialog(content: MixMarkdown(data: '> [!NOTE]\n> Body')),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Note'), findsOneWidget);
      expect(find.text('Body', findRichText: true), findsOneWidget);
    });

    testWidgets(
      'default alert headers shrink-wrap with or without a width bound',
      (tester) async {
        const alert = MixMarkdown(data: '> [!NOTE]\n> Body');
        final header = find.byType(RowBox);
        await tester.pumpWidget(app(alert));

        final boundedWidth = tester.getSize(header).width;
        expect(boundedWidth, lessThan(320));

        await tester.pumpWidget(
          app(
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: alert,
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(tester.getSize(header).width, boundedWidth);
      },
    );

    testWidgets(
      'alert title wraps at the header width in a horizontal scroll view',
      (tester) async {
        const label = 'A long localized alert title';
        await tester.pumpWidget(
          app(
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: MixMarkdown(
                data: '> [!NOTE]\n> Body',
                style: MarkdownStyler(
                  alert: MarkdownAlertStyler(
                    note: MarkdownAlertTypeStyler(
                      label: label,
                      header: FlexBoxStyler().width(100),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(tester.getSize(find.byType(RowBox)).width, 100);
        expect(tester.getSize(find.text(label)).width, lessThan(100));
      },
    );

    const alerts =
        '> [!NOTE]\n> **Outer**\n>\n> > [!TIP]\n> > Inner\n\n'
        '> [!IMPORTANT]\n> Important body\n\n'
        '> [!WARNING]\n> Warning body\n\n'
        '> [!CAUTION]\n> Caution body';

    testWidgets('every type renders its header and parsed children', (
      tester,
    ) async {
      await tester.pumpWidget(app(const MixMarkdown(data: alerts)));

      expect(find.byType(MarkdownAlert), findsNWidgets(5));
      for (final label in ['Note', 'Tip', 'Important', 'Warning', 'Caution']) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.text('Outer', findRichText: true), findsOneWidget);
      expect(find.text('Inner', findRichText: true), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('type slots style the label, icon, and container', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          MixMarkdown(
            data: '> [!TIP]\n> body',
            style: MarkdownStyler(
              alert: MarkdownAlertStyler(
                tip: MarkdownAlertTypeStyler(
                  label: 'Hint',
                  icon: IconStyler().icon(Icons.star).color(Colors.amber),
                  container: BoxStyler().padding(.all(12)),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Hint'), findsOneWidget);
      expect(find.text('Tip'), findsNothing);
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.star);
      expect(icon.color, Colors.amber);
      expect(
        tester
            .widget<Padding>(
              find
                  .descendant(
                    of: find.byType(MarkdownAlert),
                    matching: find.byType(Padding),
                  )
                  .first,
            )
            .padding,
        const EdgeInsets.all(12),
      );
    });

    testWidgets('unsupported blocks inside an alert fall back as a whole', (
      tester,
    ) async {
      Set<String>? seen;
      await tester.pumpWidget(
        app(
          MixMarkdown(
            data: '> [!NOTE]\n> - unsupported list\n',
            unsupportedBuilder: (context, tags) {
              seen = tags;

              return const Text('fallback');
            },
          ),
        ),
      );

      expect(seen, {'ul'});
      expect(find.text('fallback'), findsOneWidget);
      expect(find.byType(MarkdownAlert), findsNothing);
    });
  });

  group('unsupported documents', () {
    testWidgets('inline colors render as code text without a swatch', (
      tester,
    ) async {
      await tester.pumpWidget(app(const MixMarkdown(data: 'Use `#ff0000`.')));

      final text = tester.widget<Text>(find.text('Use #ff0000.'));
      final spans = (text.textSpan! as TextSpan).children!.cast<TextSpan>();
      expect(spans.map((span) => span.text), ['Use ', '#ff0000', '.']);
      expect(spans[1].style?.fontFamily, 'monospace');
    });

    testWidgets('block comments are invisible in prose and alerts', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          const MixMarkdown(
            data:
                'before\n\n<!-- hidden -->\n\n'
                '> [!NOTE]\n> <!-- also hidden -->\n>\n> inside',
          ),
        ),
      );

      expect(find.text('before'), findsOneWidget);
      expect(find.text('inside'), findsOneWidget);
      expect(find.textContaining('hidden'), findsNothing);
    });

    testWidgets('show a diagnostic without a builder', (tester) async {
      await tester.pumpWidget(
        app(const MixMarkdown(data: '| h |\n|---|\n| b |')),
      );

      expect(find.text('Unsupported Markdown: table'), findsOneWidget);
    });

    testWidgets('report standalone images instead of flattening them', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(const MixMarkdown(data: '![alt][img]\n\n[img]: image.png')),
      );

      expect(find.textContaining('standalone-image'), findsOneWidget);
    });

    testWidgets('linked images in prose render their alt text', (tester) async {
      await tester.pumpWidget(
        app(
          const MixMarkdown(
            data:
                'Status: [![CI](https://example.com/badge.svg)]'
                '(https://example.com/build).',
          ),
        ),
      );

      expect(find.text('Status: CI.', findRichText: true), findsOneWidget);
    });

    testWidgets('unsupported raw inline HTML renders literally', (
      tester,
    ) async {
      const source = 'Press <kbd>Ctrl</kbd>.';
      await tester.pumpWidget(app(const MixMarkdown(data: source)));

      expect(find.text(source, findRichText: true), findsOneWidget);
    });
  });

  group('hooks', () {
    testWidgets('wrapBlock receives the same element across rebuilds', (
      tester,
    ) async {
      md.Element? original;
      var calls = 0;
      Widget body() => app(
        MixMarkdown(
          data: '# Wrapped',
          wrapBlock: (context, element, child) {
            if (original != null) expect(element, same(original));
            original = element;
            calls++;

            return Padding(padding: const EdgeInsets.all(3), child: child);
          },
        ),
      );

      await tester.pumpWidget(body());
      await tester.pumpWidget(body());

      expect(calls, greaterThanOrEqualTo(2));
    });
  });

  group('style contract', () {
    test('generated spec supports copy, equality, and lerp', () {
      const start = MarkdownSpec(blockSpacing: 8);
      const end = MarkdownSpec(blockSpacing: 24);

      expect(start.copyWith(blockSpacing: 24), end);
      expect(start.lerp(end, 0.5).blockSpacing, 16);
      expect(start.hashCode, const MarkdownSpec(blockSpacing: 8).hashCode);
    });

    testWidgets('styler merge keeps earlier nested fields', (tester) async {
      final style =
          MarkdownStyler(
            paragraph: TextStyler().fontSize(24).color(Colors.red),
            container: BoxStyler().padding(.all(12)),
            blockSpacing: 8,
          ).merge(
            MarkdownStyler(
              paragraph: TextStyler().fontWeight(FontWeight.bold),
              blockSpacing: 16,
            ),
          );
      late MarkdownSpec resolved;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              resolved = style.resolve(context).spec;

              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolved.paragraph?.spec.style?.fontSize, 24);
      expect(resolved.paragraph?.spec.style?.color, Colors.red);
      expect(resolved.paragraph?.spec.style?.fontWeight, FontWeight.bold);
      expect(resolved.container?.spec.padding, const EdgeInsets.all(12));
      expect(resolved.blockSpacing, 16);
    });

    testWidgets('animated block spacing interpolates', (tester) async {
      Future<void> pump(double spacing) => tester.pumpWidget(
        app(
          MixMarkdown(
            data: 'first\n\nsecond',
            style: MarkdownStyler(blockSpacing: spacing).animate(
              AnimationConfig.linear(const Duration(milliseconds: 250)),
            ),
          ),
        ),
      );
      Column column() => tester.widget<Column>(
        find.descendant(
          of: find.byType(MarkdownBlocks),
          matching: find.byType(Column),
        ),
      );

      await pump(8);
      await tester.pumpAndSettle();
      await pump(32);
      await tester.pump(const Duration(milliseconds: 125));
      expect(column().spacing, greaterThan(8));
      expect(column().spacing, lessThan(32));

      await tester.pumpAndSettle();
      expect(column().spacing, 32);
      expect(tester.takeException(), isNull);
    });
  });
}

class _MarkerSyntax extends md.InlineSyntax {
  _MarkerSyntax() : super('@@');

  int matches = 0;

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    matches++;
    parser.addNode(md.Element.text('strong', 'marker'));

    return true;
  }
}
