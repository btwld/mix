import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'markdown_alert_type_spec.g.dart';

/// Resolved presentation for one GitHub alert type.
///
/// An alert renders as a [container] holding a [header] row followed by the
/// alert body. Body blocks use the document's paragraph and heading slots.
@MixableSpec()
@immutable
final class MarkdownAlertTypeSpec with _$MarkdownAlertTypeSpec {
  /// Box around the header and the body.
  @override
  final StyleSpec<BoxSpec>? container;

  /// Row holding the icon and the title. Defaults to [MainAxisSize.min].
  /// Use [MainAxisSize.max] only when the header has a bounded width.
  @override
  final StyleSpec<FlexBoxSpec>? header;

  /// Header icon. Its `icon` value replaces the default icon of the type.
  @override
  final StyleSpec<IconSpec>? icon;

  /// Header title text.
  @override
  final StyleSpec<TextSpec>? title;

  /// Header title, the capitalized type name when null.
  @override
  final String? label;

  const MarkdownAlertTypeSpec({
    this.container,
    this.header,
    this.icon,
    this.title,
    this.label,
  });
}
