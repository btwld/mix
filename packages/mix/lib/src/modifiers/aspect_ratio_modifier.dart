import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';

part 'aspect_ratio_modifier.g.dart';

/// Modifier that constrains its child to a specific aspect ratio.
///
/// Wraps the child in an [AspectRatio] widget with the specified ratio.
@MixableModifier()
final class AspectRatioModifier with _$AspectRatioModifier {
  @override
  final double aspectRatio;

  const AspectRatioModifier([double? aspectRatio])
    : aspectRatio = aspectRatio ?? 1.0;

  @override
  Widget build(Widget child) {
    return AspectRatio(aspectRatio: aspectRatio, child: child);
  }
}
