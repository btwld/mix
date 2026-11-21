import 'package:markdown/markdown.dart' as md;

import '../specs/markdown_alert_type.dart';

const _alertClass = 'markdown-alert';
const _titleClass = 'markdown-alert-title';

/// Reads the GitHub alert elements produced by [md.AlertBlockSyntax].
///
/// That syntax emits a `div` whose class names carry the alert type, with a
/// generated title paragraph as its first child. The renderer draws its own
/// header, so [alertContent] leaves that paragraph out.
extension MarkdownAlertElement on md.Element {
  /// The alert type of this element, or null when it is not an alert.
  MarkdownAlertType? get alertType {
    if (tag != 'div') return null;
    final classes = attributes['class']?.split(' ') ?? const <String>[];
    if (!classes.contains(_alertClass)) return null;
    for (final type in MarkdownAlertType.values) {
      if (classes.contains('$_alertClass-${type.name}')) return type;
    }

    return null;
  }

  /// The alert body without the generated title paragraph.
  List<md.Node> get alertContent => [
    for (final child in children ?? const <md.Node>[])
      if (!_isTitle(child)) child,
  ];
}

bool _isTitle(md.Node node) =>
    node is md.Element && node.attributes['class'] == _titleClass;
