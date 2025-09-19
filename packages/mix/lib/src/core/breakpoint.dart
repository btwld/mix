import 'package:flutter/widgets.dart';

/// Represents a responsive breakpoint for screen size-based styling.
///
/// A breakpoint defines a range of screen sizes where certain styles should apply.
/// It can have a minimum width, maximum width, or both.
///
/// Example usage:
/// ```dart
/// const mobile = Breakpoint(maxWidth: 767);
/// const tablet = Breakpoint(minWidth: 768, maxWidth: 1023);
/// const desktop = Breakpoint(minWidth: 1024);
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

  /// Extra small devices (portrait phones, up to 575px)
  static const xs = Breakpoint.maxWidth(575);

  /// Small devices (landscape phones, 576px and up)
  static const sm = Breakpoint.widthRange(576, 767);

  /// Medium devices (tablets, 768px and up)
  static const md = Breakpoint.widthRange(768, 991);

  /// Large devices (desktops, 992px and up)
  static const lg = Breakpoint.widthRange(992, 1199);

  /// Extra large devices (large desktops, 1200px and up)
  static const xl = Breakpoint.minWidth(1200);

  /// Mobile devices (up to 767px)
  static const mobile = Breakpoint.maxWidth(767);

  /// Tablet devices (768px to 1023px)
  static const tablet = Breakpoint.widthRange(768, 1023);

  /// Desktop devices (1024px and up)
  static const desktop = Breakpoint.minWidth(1024);

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

  /// Creates a breakpoint that matches screens with width less than or equal to [maxWidth].
  const Breakpoint.maxWidth(double maxWidth) : this(maxWidth: maxWidth);

  /// Creates a breakpoint that matches screens with width greater than or equal to [minWidth].
  const Breakpoint.minWidth(double minWidth) : this(minWidth: minWidth);

  /// Creates a breakpoint that matches screens with width between [minWidth] and [maxWidth] (inclusive).
  const Breakpoint.widthRange(double minWidth, double maxWidth)
    : this(minWidth: minWidth, maxWidth: maxWidth);

  /// Creates a breakpoint that matches screens with height less than or equal to [maxHeight].
  const Breakpoint.maxHeight(double maxHeight) : this(maxHeight: maxHeight);

  /// Creates a breakpoint that matches screens with height greater than or equal to [minHeight].
  const Breakpoint.minHeight(double minHeight) : this(minHeight: minHeight);

  /// Creates a breakpoint that matches screens with height between [minHeight] and [maxHeight] (inclusive).
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

  /// Checks if this breakpoint matches the current screen size from the given [context].
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
