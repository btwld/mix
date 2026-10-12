import 'tw_types.dart';

/// Read-only view of the Flutter runtime behavior a compiled class list needs.
///
/// An empty plan means the returned Mix styler fully represents Mix Winds'
/// behavior. Whether a separate codec supports that styler is an independent
/// consumer-boundary concern. Concrete plan details remain package-internal so
/// the public contract does not expose parser internals.
abstract interface class TwLayoutPlan {
  /// Creates a plan with no Flutter widget-layer work.
  const factory TwLayoutPlan.empty() = _EmptyTwLayoutPlan;

  /// Whether the compiled style is fully represented by its Mix styler.
  bool get isEmpty;
}

final class _EmptyTwLayoutPlan implements TwLayoutPlan {
  const _EmptyTwLayoutPlan();

  @override
  bool get isEmpty => true;
}

/// The deterministic result of compiling Tailwind classes for one Mix target.
final class TwCompilation<S extends Object> {
  /// The Mix styler produced for the requested target.
  final S styler;

  /// Flutter runtime behavior that is not portable through the styler.
  final TwLayoutPlan layoutPlan;

  /// Diagnostics in deterministic compilation order.
  final List<TwDiagnostic> diagnostics;

  TwCompilation({
    required this.styler,
    required this.layoutPlan,
    required List<TwDiagnostic> diagnostics,
  }) : diagnostics = List.unmodifiable(diagnostics);

  /// Whether evaluating this compilation requires the Mix Winds widget layer.
  bool get requiresWidgetRuntime => !layoutPlan.isEmpty;
}
