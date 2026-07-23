import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Publishes the incoming [BoxConstraints] to descendant style resolution.
///
/// Used by constraint variants ([ConstraintVariant]) so they can match against
/// offered max width/height instead of [MediaQuery] viewport size.
///
/// Inserted by [StyleBuilder] only when the style tree contains a constraint
/// variant — styles without constraint variants pay zero cost.
///
/// Spike / not productized — not exported from `mix.dart`.
@internal
@immutable
class ConstraintScope extends InheritedWidget {
  /// Creates a scope that publishes [constraints] to descendants.
  const ConstraintScope({
    super.key,
    required this.constraints,
    required super.child,
  });

  /// The nearest [ConstraintScope] above [context], or null if none.
  static ConstraintScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  /// The nearest [ConstraintScope] above [context].
  ///
  /// Throws if no scope is found — constraint variants require StyleBuilder
  /// (or an explicit parent [ConstraintScope]) to publish constraints.
  static ConstraintScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(() {
      if (scope == null) {
        throw FlutterError.fromParts([
          ErrorSummary(
            'ConstraintScope.of() called with a context that does not contain '
            'a ConstraintScope.',
          ),
          ErrorDescription(
            'Constraint variants match against offered BoxConstraints. '
            'StyleBuilder inserts ConstraintScope automatically when a style '
            'contains constraint variants. Ensure you resolve styles through '
            'StyleBuilder (the style path), not styleSpec alone.\n'
            'Note: constraint variants returned from an onBuilder closure '
            'cannot be detected statically, so no ConstraintScope is inserted '
            'for them. Attach onConstraints directly to the style instead of '
            'nesting it inside onBuilder.',
          ),
          context.describeElement('The context used was'),
        ]);
      }

      return true;
    }());

    if (scope == null) {
      throw FlutterError(
        'ConstraintScope.of() called with a context that does not contain a '
        'ConstraintScope.',
      );
    }

    return scope;
  }

  /// Offered size from the nearest [ConstraintScope], or null if none.
  static Size? maybeSizeOf(BuildContext context) => maybeOf(context)?.size;

  /// Offered size from the nearest [ConstraintScope].
  static Size sizeOf(BuildContext context) => of(context).size;

  /// The incoming box constraints for this style host.
  final BoxConstraints constraints;

  /// Size formed from [constraints.biggest] (maxWidth × maxHeight).
  ///
  /// Unbounded axes remain [double.infinity], so a finite `maxWidth` breakpoint
  /// does not match an unbounded width.
  Size get size => constraints.biggest;

  @override
  bool updateShouldNotify(ConstraintScope oldWidget) {
    return constraints != oldWidget.constraints;
  }
}
