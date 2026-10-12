import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../specs/wrap/wrap_spec.dart';

/// Provides fluent Wrap layout methods to Wrap-backed stylers.
///
/// [wrapAlignment] and [wrapClipBehavior] are intentionally prefixed so a
/// compound styler can reserve `alignment` and `clipBehavior` for its Box.
mixin WrapStyleMixin<T extends Mix<Object?>> {
  /// Merges a complete Wrap style into this styler.
  T flow(WrapStyler value);

  /// Sets the Wrap main-axis direction.
  T direction(Axis value) => flow(WrapStyler(direction: value));

  /// Sets alignment within each Wrap run.
  T wrapAlignment(WrapAlignment value) {
    return flow(WrapStyler(alignment: value));
  }

  /// Sets spacing between children in a run.
  T spacing(double value) => flow(WrapStyler(spacing: value));

  /// Sets alignment between Wrap runs.
  T runAlignment(WrapAlignment value) {
    return flow(WrapStyler(runAlignment: value));
  }

  /// Sets spacing between Wrap runs.
  T runSpacing(double value) => flow(WrapStyler(runSpacing: value));

  /// Sets child alignment along a run's cross axis.
  T crossAxisAlignment(WrapCrossAlignment value) {
    return flow(WrapStyler(crossAxisAlignment: value));
  }

  /// Sets the horizontal ordering direction used by Wrap.
  T textDirection(TextDirection value) {
    return flow(WrapStyler(textDirection: value));
  }

  /// Sets the vertical ordering direction used by Wrap.
  T verticalDirection(VerticalDirection value) {
    return flow(WrapStyler(verticalDirection: value));
  }

  /// Sets clipping for overflowing Wrap content.
  T wrapClipBehavior(Clip value) {
    return flow(WrapStyler(clipBehavior: value));
  }
}
