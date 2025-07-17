import 'package:flutter/widgets.dart';

import '../../core/variant.dart';

/// A variant based on a [TextDirection] value.
///
/// This class determines whether the current [TextDirection] within the given
/// [BuildContext] matches the specified [direction].
final class OnDirectionalityVariant extends ContextVariant {
  /// The [TextDirection] associated with this variant.
  final TextDirection direction;

  /// Creates a new [OnDirectionalityVariant] with the given [direction].
  const OnDirectionalityVariant(this.direction);

  /// Determines whether the current [TextDirection] matches the specified [direction].
  @override
  bool when(BuildContext context) {
    return Directionality.of(context) == direction;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnDirectionalityVariant && other.direction == direction;

  @override
  int get hashCode => direction.hashCode;

  @override
  List<Object?> get props => [direction];
}
