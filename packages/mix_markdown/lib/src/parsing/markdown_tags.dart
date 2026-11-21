/// A block element the renderer draws directly.
enum MarkdownBlockTag {
  paragraph('p'),
  h1('h1'),
  h2('h2'),
  h3('h3'),
  h4('h4'),
  h5('h5'),
  h6('h6');

  /// The tag the Markdown parser emits.
  final String tag;

  const MarkdownBlockTag(this.tag);

  /// The block tag named [tag], or null when the renderer cannot draw it.
  static MarkdownBlockTag? from(String tag) {
    for (final value in values) {
      if (value.tag == tag) return value;
    }

    return null;
  }

  /// Whether this block is a heading rather than body text.
  bool get isHeading => this != paragraph;
}

/// An inline element the renderer turns into a text span.
enum MarkdownInlineTag {
  strong('strong'),
  boldAlias('b'),
  emphasis('em'),
  italicAlias('i'),
  strikethrough('del'),
  strikethroughAlias('s'),
  link('a'),
  code('code'),
  lineBreak('br'),
  image('img');

  /// The tag the Markdown parser emits.
  final String tag;

  const MarkdownInlineTag(this.tag);

  /// The inline tag named [tag], or null when the renderer cannot draw it.
  static MarkdownInlineTag? from(String tag) {
    for (final value in values) {
      if (value.tag == tag) return value;
    }

    return null;
  }
}
