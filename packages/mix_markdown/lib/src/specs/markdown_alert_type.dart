import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

/// The GitHub alert kinds, with the header used when a style sets none.
enum MarkdownAlertType {
  note('Note', Icons.info_outline),
  tip('Tip', Icons.lightbulb_outline),
  important('Important', Icons.label_important_outline),
  warning('Warning', Icons.warning_amber_outlined),
  caution('Caution', Icons.dangerous_outlined);

  /// Header text shown when [MarkdownAlertTypeSpec.label] is null.
  final String defaultLabel;

  /// Header icon shown when [MarkdownAlertTypeSpec.icon] sets no icon.
  final IconData defaultIcon;

  const MarkdownAlertType(this.defaultLabel, this.defaultIcon);
}
