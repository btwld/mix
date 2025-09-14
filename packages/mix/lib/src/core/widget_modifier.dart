import 'package:flutter/widgets.dart';

import 'spec.dart';

/// Base class for widget modifiers.
abstract class WidgetModifier<Self extends WidgetModifier<Self>> extends Spec<Self> {
  const WidgetModifier();

  /// Builds the modified widget by wrapping or transforming [child].
  Widget build(Widget child);
}
