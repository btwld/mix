import 'package:flutter/widgets.dart';

/// Represents an inclusive size range used for responsive styling.
///
/// Use [matchesContext] to evaluate the viewport size from `MediaQuery`, or
/// [matches] to evaluate any [Size], including one derived from local layout
/// constraints.
///
/// Example usage:
/// ```dart
/// const Breakpoint mobile = .maxWidth(767);
/// const Breakpoint tablet = .widthRange(768, 1023);
/// const Breakpoint desktop = .minWidth(1024);
/// ```
@immutable
class Breakpoint {
  /// The minimum width for this breakpoint (inclusive).
  /// If null, there is no minimum width constraint.
  final double? minWidth;

  /// The maximum width for this breakpoint (inclusive).
  /// If null, there is no maximum width constraint.
  final double? maxWidth;

  /// The minimum height for this breakpoint (inclusive).
  /// If null, there is no minimum height constraint.
  final double? minHeight;

  /// The maximum height for this breakpoint (inclusive).
  /// If null, there is no maximum height constraint.
  final double? maxHeight;

  static const mobile = Breakpoint(maxWidth: 767);

  static const tablet = Breakpoint(minWidth: 768, maxWidth: 1023);

  static const desktop = Breakpoint(minWidth: 1024);

  /// Creates a new breakpoint with the specified constraints.
  ///
  /// At least one constraint must be provided.
  const Breakpoint({
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
  }) : assert(
         minWidth != null ||
             maxWidth != null ||
             minHeight != null ||
             maxHeight != null,
         'At least one constraint must be provided',
       );

  /// Creates a breakpoint that matches widths less than or equal to [maxWidth].
  const Breakpoint.maxWidth(double maxWidth) : this(maxWidth: maxWidth);

  /// Creates a breakpoint that matches widths greater than or equal to [minWidth].
  const Breakpoint.minWidth(double minWidth) : this(minWidth: minWidth);

  /// Creates a breakpoint that matches widths from [minWidth] to [maxWidth].
  const Breakpoint.widthRange(double minWidth, double maxWidth)
    : this(minWidth: minWidth, maxWidth: maxWidth);

  /// Creates a breakpoint that matches heights less than or equal to [maxHeight].
  const Breakpoint.maxHeight(double maxHeight) : this(maxHeight: maxHeight);

  /// Creates a breakpoint that matches heights greater than or equal to [minHeight].
  const Breakpoint.minHeight(double minHeight) : this(minHeight: minHeight);

  /// Creates a breakpoint that matches heights from [minHeight] to [maxHeight].
  const Breakpoint.heightRange(double minHeight, double maxHeight)
    : this(minHeight: minHeight, maxHeight: maxHeight);

  /// Checks if the given [size] matches this breakpoint's constraints.
  bool matches(Size size) {
    // Check width constraints
    if (minWidth != null && size.width < minWidth!) return false;
    if (maxWidth != null && size.width > maxWidth!) return false;

    // Check height constraints
    if (minHeight != null && size.height < minHeight!) return false;
    if (maxHeight != null && size.height > maxHeight!) return false;

    return true;
  }

  /// Checks whether this breakpoint matches the viewport size from [context].
  bool matchesContext(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return matches(size);
  }

  /// Returns a string representation of this breakpoint for debugging.
  @override
  String toString() {
    final constraints = <String>[];

    if (minWidth != null) constraints.add('minWidth: $minWidth');
    if (maxWidth != null) constraints.add('maxWidth: $maxWidth');
    if (minHeight != null) constraints.add('minHeight: $minHeight');
    if (maxHeight != null) constraints.add('maxHeight: $maxHeight');

    return 'Breakpoint(${constraints.join(', ')})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Breakpoint &&
          runtimeType == other.runtimeType &&
          minWidth == other.minWidth &&
          maxWidth == other.maxWidth &&
          minHeight == other.minHeight &&
          maxHeight == other.maxHeight;

  @override
  int get hashCode => Object.hash(minWidth, maxWidth, minHeight, maxHeight);
}
