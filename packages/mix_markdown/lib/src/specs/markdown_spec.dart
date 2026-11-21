import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../parsing/markdown_syntax.dart';
import '../widgets/mix_markdown.dart';
import 'markdown_alert_spec.dart';

part 'markdown_spec.g.dart';

/// Resolved presentation for a [MixMarkdown] document.
///
/// Block slots resolve to complete [TextSpec]s, including modifiers and
/// animation. Inline slots contribute only their resolved [TextSpec.style],
/// because inline runs are text spans rather than widgets.
@MixableSpec(target: MixMarkdown.new)
@immutable
final class MarkdownSpec with _$MarkdownSpec {
  /// Box around the whole document.
  @override
  final StyleSpec<BoxSpec>? container;

  /// Vertical space between blocks, including blocks inside alerts.
  @override
  final double? blockSpacing;

  /// Paragraphs, and any heading level without a slot of its own.
  @override
  final StyleSpec<TextSpec>? paragraph;

  /// `#` headings.
  @override
  final StyleSpec<TextSpec>? h1;

  /// `##` headings.
  @override
  final StyleSpec<TextSpec>? h2;

  /// `###` headings.
  @override
  final StyleSpec<TextSpec>? h3;

  /// `####` headings.
  @override
  final StyleSpec<TextSpec>? h4;

  /// `#####` headings.
  @override
  final StyleSpec<TextSpec>? h5;

  /// `######` headings.
  @override
  final StyleSpec<TextSpec>? h6;

  /// `**strong**` runs, layered over bold.
  @override
  final StyleSpec<TextSpec>? strong;

  /// `*emphasis*` runs, layered over italic.
  @override
  final StyleSpec<TextSpec>? emphasis;

  /// `~~strikethrough~~` runs, layered over a line-through decoration.
  @override
  final StyleSpec<TextSpec>? strikethrough;

  /// Inline `code` runs, layered over a monospace font.
  @override
  final StyleSpec<TextSpec>? code;

  /// Link text. Links are styled but not activated.
  @override
  final StyleSpec<TextSpec>? link;

  /// GitHub alerts.
  @override
  final StyleSpec<MarkdownAlertSpec>? alert;

  const MarkdownSpec({
    this.container,
    this.blockSpacing,
    this.paragraph,
    this.h1,
    this.h2,
    this.h3,
    this.h4,
    this.h5,
    this.h6,
    this.strong,
    this.emphasis,
    this.strikethrough,
    this.code,
    this.link,
    this.alert,
  });
}
