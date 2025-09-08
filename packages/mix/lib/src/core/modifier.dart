import 'package:flutter/widgets.dart';

import 'spec.dart';

/// Unified base class for modifiers.
///
/// Provides a common interface for widget modifications that can be applied
/// to styled elements in the Mix framework.
abstract class Modifier<Self extends Modifier<Self>> extends Spec<Self> {
  const Modifier();

  /// Builds the modified widget by wrapping or transforming [child].
  Widget build(Widget child);
}
