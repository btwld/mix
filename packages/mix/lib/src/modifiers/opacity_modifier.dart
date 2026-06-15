import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';

part 'opacity_modifier.g.dart';

/// Modifier that applies opacity to its child.
///
/// Wraps the child in an [Opacity] widget with the specified opacity value.
@MixableModifier()
final class OpacityModifier with _$OpacityModifier {
  /// Opacity value between 0.0 and 1.0 (inclusive).
  @override
  final double opacity;
  const OpacityModifier([double? opacity]) : opacity = opacity ?? 1.0;

  @override
  Widget build(Widget child) {
    return Opacity(opacity: opacity, child: child);
  }
}
