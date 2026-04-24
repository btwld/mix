import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';

part 'flexible_modifier.g.dart';

/// Modifier that makes its child flexible within a flex layout.
///
/// Wraps the child in a [Flexible] widget with the specified flex and fit properties.
@MixableModifier()
final class FlexibleModifier extends WidgetModifier<FlexibleModifier>
    with Diagnosticable, _$FlexibleModifierMethods {
  @override
  final int? flex;
  @override
  final FlexFit? fit;
  const FlexibleModifier({this.flex, this.fit});

  @override
  Widget build(Widget child) {
    return Flexible(flex: flex ?? 1, fit: fit ?? .loose, child: child);
  }
}
