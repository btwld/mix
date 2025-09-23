import 'package:flutter/widgets.dart';

import 'spec.dart';

/// Unified base class for widget modifiers.
///
/// Provides a common interface for widget modifications that can be applied
/// to styled elements in the Mix framework.
abstract class WidgetModifier<Self extends WidgetModifier<Self>>
    extends Spec<Self> {
  const WidgetModifier();

  /// Builds the modified widget by wrapping or transforming [child].
  Widget build(Widget child);
}
