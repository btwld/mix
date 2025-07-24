import 'package:flutter/widgets.dart';

import 'spec.dart';

/// Base class for widget modifiers that can be applied to styled widgets.
///
/// Widget modifiers transform or wrap widgets with additional functionality
/// while maintaining style inheritance and animation support.
abstract class Modifier<Self extends Modifier<Self>> extends Spec<Self> {
  const Modifier();

  /// Builds the modified widget by wrapping or transforming [child].
  Widget build(Widget child);
}
