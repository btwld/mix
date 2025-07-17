import 'package:flutter/widgets.dart';

import '../../core/variant.dart';

/// A variant of [ContextVariant] that negates the result of another [ContextVariant].
///
/// This class determines whether the specified [variant] evaluates to `false`
/// within the given [BuildContext].
base class OnNotVariant extends ContextVariant {
  /// The [ContextVariant] to negate.
  final ContextVariant variant;

  /// Creates a new [OnNotVariant] with the given [variant].
  ///
  /// The [key] is set to a [ValueKey] based on the [variant].
  const OnNotVariant(this.variant);

  /// Determines whether the specified [variant] evaluates to `false`.
  ///
  /// Returns `true` if the [variant] evaluates to `false` within the given
  /// [context], and `false` otherwise.
  @override
  bool when(BuildContext context) => !variant.when(context);

  /// The properties used for equality comparison.
  ///
  /// Returns a list containing the [variant].
  @override
  List<Object?> get props => [variant];
}
