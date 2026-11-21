import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:flutter/widgets.dart' show IconData, Widget;

import 'tw_widget.dart';

/// Creates a non-const [Div] with [classNames] and optional [children].
///
/// Use [Div.new] when you need a key, configuration, diagnostics, a single
/// child, or a const widget.
Div div(String classNames, [List<Widget> children = const []]) {
  return Div(classNames: classNames, children: children);
}

/// Creates a non-const [P] with [classNames] and [text].
P p(String classNames, String text) {
  return P(text: text, classNames: classNames);
}

/// Creates a non-const [Span] with [classNames] and [text].
Span span(String classNames, String text) {
  return Span(text: text, classNames: classNames);
}

/// Creates a non-const [H1] with [classNames] and [text].
H1 h1(String classNames, String text) {
  return H1(text: text, classNames: classNames);
}

/// Creates a non-const [H2] with [classNames] and [text].
H2 h2(String classNames, String text) {
  return H2(text: text, classNames: classNames);
}

/// Creates a non-const [H3] with [classNames] and [text].
H3 h3(String classNames, String text) {
  return H3(text: text, classNames: classNames);
}

/// Creates a non-const [H4] with [classNames] and [text].
H4 h4(String classNames, String text) {
  return H4(text: text, classNames: classNames);
}

/// Creates a non-const [H5] with [classNames] and [text].
H5 h5(String classNames, String text) {
  return H5(text: text, classNames: classNames);
}

/// Creates a non-const [H6] with [classNames] and [text].
H6 h6(String classNames, String text) {
  return H6(text: text, classNames: classNames);
}

/// Creates a non-const [Button] with [classNames] and [children].
///
/// A null [onPressed] disables the button. Use [semanticsLabel] to name
/// icon-only or otherwise nonverbal content. Use [Button.new] for advanced
/// interaction, focus, configuration, diagnostic, or const options.
Button button(
  String classNames,
  List<Widget> children, {
  required VoidCallback? onPressed,
  String? semanticsLabel,
}) {
  return Button(
    classNames: classNames,
    onPressed: onPressed,
    semanticsLabel: semanticsLabel,
    children: children,
  );
}

/// Creates a non-const [TwIcon] with [classNames] and [icon].
TwIcon twIcon(String classNames, IconData icon, {String? semanticLabel}) {
  return TwIcon(icon, classNames: classNames, semanticLabel: semanticLabel);
}

/// Creates a non-const [TruncatedP] with [classNames] and [text].
TruncatedP truncatedP(String classNames, String text) {
  return TruncatedP(text: text, classNames: classNames);
}
