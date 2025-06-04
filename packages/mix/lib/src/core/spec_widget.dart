import 'package:flutter/widgets.dart';

import 'spec.dart';

/// Base class for all spec widgets using Pattern A approach.
/// 
/// Pattern A provides explicit, debuggable widget building with separate 
/// classes for regular and animated widgets.
/// 
/// Example:
/// ```dart
/// class MySpecWidget extends SpecWidget<MySpec> {
///   @override
///   Widget build(BuildContext context) {
///     return Container(width: spec?.width);
///   }
/// }
/// ```
@immutable
abstract class SpecWidget<S extends Spec<S>> extends StatelessWidget {
  /// Creates a spec widget.
  /// 
  /// The [spec] parameter may be null and should be handled gracefully.
  const SpecWidget({
    this.spec,
    super.key,
  });

  /// The spec that defines this widget's properties.
  /// 
  /// When null, implementations should provide sensible defaults.
  /// Use null-aware operators (spec?.property) for safe access.
  final S? spec;

  /// Builds the widget using the provided [spec].
  /// 
  /// Implementations should handle null [spec] values gracefully
  /// and use standard Flutter patterns without abstraction layers.
  @override
  Widget build(BuildContext context);
}
