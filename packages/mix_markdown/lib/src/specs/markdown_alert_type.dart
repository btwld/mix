import 'package:flutter/widgets.dart';

/// The GitHub alert kinds, with the header used when a style sets none.
enum MarkdownAlertType {
  note('Note', IconData(0xe33d, fontFamily: 'MaterialIcons')),
  tip('Tip', IconData(0xe37c, fontFamily: 'MaterialIcons')),
  important('Important', IconData(0xe362, fontFamily: 'MaterialIcons')),
  warning('Warning', IconData(0xf4ae, fontFamily: 'MaterialIcons')),
  caution('Caution', IconData(0xef9e, fontFamily: 'MaterialIcons'));

  /// Header text shown when [MarkdownAlertTypeSpec.label] is null.
  final String defaultLabel;

  /// Header icon shown when [MarkdownAlertTypeSpec.icon] sets no icon.
  final IconData defaultIcon;

  const MarkdownAlertType(this.defaultLabel, this.defaultIcon);
}
