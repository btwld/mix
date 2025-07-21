import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/resolved_style_provider.dart';
import '../../core/spec.dart';

final class StackSpec extends Spec<StackSpec> with Diagnosticable {
  final AlignmentGeometry? alignment;
  final StackFit? fit;
  final TextDirection? textDirection;
  final Clip? clipBehavior;

  const StackSpec({
    this.alignment,
    this.fit,
    this.textDirection,
    this.clipBehavior,
  });

  static StackSpec from(BuildContext context) {
    return maybeOf(context) ?? const StackSpec();
  }

  /// Retrieves the [StackSpec] from the nearest [ResolvedStyleProvider] ancestor.
  ///
  /// Returns null if no ancestor [ResolvedStyleProvider] is found.
  static StackSpec? maybeOf(BuildContext context) {
    return ResolvedStyleProvider.of<StackSpec>(context)?.spec;
  }

  /// {@template stack_spec_of}
  /// Retrieves the [StackSpec] from the nearest [ResolvedStyleProvider] ancestor in the widget tree.
  ///
  /// This method uses [ResolvedStyleProvider.of] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [StackSpec] changes, not when other specs change.
  /// If no ancestor [ResolvedStyleProvider] is found, this method returns an empty [StackSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final stackSpec = StackSpec.of(context);
  /// ```
  /// {@endtemplate}
  static StackSpec of(BuildContext context) {
    return maybeOf(context) ?? const StackSpec();
  }

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
    properties.add(
      DiagnosticsProperty('textDirection', textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// Creates a copy of this [StackSpec] but with the given fields
  /// replaced with the new values.
  @override
  StackSpec copyWith({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
  }) {
    return StackSpec(
      alignment: alignment ?? this.alignment,
      fit: fit ?? this.fit,
      textDirection: textDirection ?? this.textDirection,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [StackSpec] and another [StackSpec] based on the given parameter [t].
  @override
  StackSpec lerp(StackSpec? other, double t) {
    if (other == null) return this;

    return StackSpec(
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      fit: t < 0.5 ? fit : other.fit,
      textDirection: t < 0.5 ? textDirection : other.textDirection,
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  /// The list of properties that constitute the state of this [StackSpec].
  @override
  List<Object?> get props => [alignment, fit, textDirection, clipBehavior];
}
