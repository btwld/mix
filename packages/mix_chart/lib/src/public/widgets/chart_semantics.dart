import 'package:flutter/widgets.dart';

/// Applies the summary-level semantics contract shared by chart widgets.
Widget buildChartSemantics({
  required Widget child,
  required String? label,
  required String value,
  required bool exclude,
}) {
  if (exclude) {
    return ExcludeSemantics(child: child);
  }

  return Semantics(
    container: true,
    excludeSemantics: true,
    readOnly: true,
    label: label,
    value: value,
    child: child,
  );
}
