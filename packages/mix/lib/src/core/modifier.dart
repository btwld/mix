import 'package:flutter/widgets.dart';

import 'spec.dart';

/// New unified base class for modifiers.
///
/// This will become the single base during the consolidation. For now, we keep
/// the legacy WidgetModifier alongside it to allow incremental refactor across
/// steps without breaking the build.
abstract class Modifier<Self extends Modifier<Self>> extends Spec<Self> {
  const Modifier();

  /// Builds the modified widget by wrapping or transforming [child].
  Widget build(Widget child);
}
