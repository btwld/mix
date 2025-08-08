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
  Widget build(BuildContext context, Widget child);
}

/// Legacy base used throughout the codebase prior to consolidation.
///
/// NOTE: This remains temporarily to keep existing modifiers compiling while we
/// migrate to [Modifier]. It will be removed once all concrete modifiers are
/// converted.
abstract class WidgetModifier<Self extends WidgetModifier<Self>>
    extends Spec<Self> {
  const WidgetModifier();

  /// Builds the modified widget by wrapping or transforming [child].
  Widget build(Widget child);
}

/// Temporary adapter to allow legacy WidgetModifier instances to be treated as
/// new-style Modifier during the consolidation refactor.
class LegacyModifierAdapter extends Modifier<LegacyModifierAdapter> {
  final WidgetModifier _inner;
  const LegacyModifierAdapter(this._inner);

  @override
  LegacyModifierAdapter copyWith() => this;

  @override
  LegacyModifierAdapter lerp(LegacyModifierAdapter? other, double t) {
    return other ?? this;
  }

  @override
  List<Object?> get props => [_inner];

  @override
  Widget build(BuildContext context, Widget child) => _inner.build(child);
}
