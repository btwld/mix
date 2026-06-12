import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';

part 'mouse_cursor_modifier.g.dart';

/// Modifier that applies a mouse cursor to its child.
///
/// Wraps the child in a [MouseRegion] widget with the specified cursor.
@MixableModifier()
class MouseCursorModifier with _$MouseCursorModifier {
  @override
  final MouseCursor? mouseCursor;

  const MouseCursorModifier({this.mouseCursor});

  @override
  Widget build(Widget child) {
    return MouseRegion(cursor: mouseCursor ?? .defer, child: child);
  }
}
