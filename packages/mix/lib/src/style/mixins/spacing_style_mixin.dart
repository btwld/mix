import '../../core/mix_element.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';

/// Mixin that provides convenient spacing styling methods for styles
mixin SpacingStyleMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  T padding(EdgeInsetsGeometryMix value);

  /// Must be implemented by the class using this mixin
  T margin(EdgeInsetsGeometryMix value);

  // Padding convenience methods
  /// Sets the top padding.
  @Deprecated(
    'Use padding(.top(value)) instead. paddingTop will be removed in Mix 3.0.',
  )
  T paddingTop(double value) => padding(EdgeInsetsGeometryMix.top(value));

  /// Sets the bottom padding.
  @Deprecated(
    'Use padding(.bottom(value)) instead. paddingBottom will be removed in Mix 3.0.',
  )
  T paddingBottom(double value) => padding(EdgeInsetsGeometryMix.bottom(value));

  /// Sets the left padding.
  @Deprecated(
    'Use padding(.left(value)) instead. paddingLeft will be removed in Mix 3.0.',
  )
  T paddingLeft(double value) => padding(EdgeInsetsGeometryMix.left(value));

  /// Sets the right padding.
  @Deprecated(
    'Use padding(.right(value)) instead. paddingRight will be removed in Mix 3.0.',
  )
  T paddingRight(double value) => padding(EdgeInsetsGeometryMix.right(value));

  /// Sets horizontal (left and right) padding.
  @Deprecated(
    'Use padding(.horizontal(value)) instead. paddingX will be removed in Mix 3.0.',
  )
  T paddingX(double value) => padding(EdgeInsetsGeometryMix.horizontal(value));

  /// Sets vertical (top and bottom) padding.
  @Deprecated(
    'Use padding(.vertical(value)) instead. paddingY will be removed in Mix 3.0.',
  )
  T paddingY(double value) => padding(EdgeInsetsGeometryMix.vertical(value));

  /// Sets padding on all sides.
  @Deprecated(
    'Use padding(.all(value)) instead. paddingAll will be removed in Mix 3.0.',
  )
  T paddingAll(double value) => padding(EdgeInsetsGeometryMix.all(value));

  /// Sets the start (leading) padding.
  @Deprecated(
    'Use padding(.start(value)) instead. paddingStart will be removed in Mix 3.0.',
  )
  T paddingStart(double value) => padding(EdgeInsetsGeometryMix.start(value));

  /// Sets the end (trailing) padding.
  @Deprecated(
    'Use padding(.end(value)) instead. paddingEnd will be removed in Mix 3.0.',
  )
  T paddingEnd(double value) => padding(EdgeInsetsGeometryMix.end(value));

  /// Sets custom padding for each side with priority resolution.
  ///
  /// Each side falls back on its own: `left ?? horizontal`,
  /// `right ?? horizontal`, `top ?? vertical`, `bottom ?? vertical`.
  /// When [start] or [end] is set, start is `start ?? left ?? horizontal`
  /// and end is `end ?? right ?? horizontal`.
  ///
  /// Known values: `padding(.horizontal(h).left(l))` and
  /// `padding(.vertical(v).top(t))` put the broad setter first. Reversing
  /// either pair lets that setter overwrite the specific side.
  /// `padding(.start(s).end(e))` sets two peers; either order keeps both.
  ///
  /// `.only` and `.directional` take concrete sides. They do not apply
  /// horizontal or vertical fallback. Resolve each side, then pass it:
  ///
  /// ```dart
  /// padding(.only(
  ///   left: left ?? horizontal,
  ///   right: right ?? horizontal,
  ///   top: top ?? vertical,
  ///   bottom: bottom ?? vertical,
  /// ))
  /// ```
  ///
  /// When [start] or [end] is present:
  ///
  /// ```dart
  /// padding(.directional(
  ///   start: start ?? left ?? horizontal,
  ///   end: end ?? right ?? horizontal,
  ///   top: top ?? vertical,
  ///   bottom: bottom ?? vertical,
  /// ))
  /// ```
  @Deprecated(
    'Use padding(.horizontal(h).left(l)) with the broad setter first, or padding(.start(s).end(e)). For nullables, resolve each side (left ?? horizontal, right ?? horizontal, top ?? vertical, bottom ?? vertical) and pass those values to padding(.only(...)), or padding(.directional(...)) when start or end is set. paddingOnly will be removed in Mix 3.0.',
  )
  T paddingOnly({
    double? horizontal,
    double? vertical,
    double? start,
    double? end,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    // Priority resolution (most specific wins)
    final resolvedLeft = left ?? horizontal;
    final resolvedRight = right ?? horizontal;
    final resolvedTop = top ?? vertical;
    final resolvedBottom = bottom ?? vertical;

    // Use directional if start/end provided
    if (start != null || end != null) {
      return padding(
        EdgeInsetsGeometryMix.directional(
          start: start ?? resolvedLeft,
          end: end ?? resolvedRight,
          top: resolvedTop,
          bottom: resolvedBottom,
        ),
      );
    }

    // Otherwise use regular EdgeInsets
    return padding(
      EdgeInsetsGeometryMix.only(
        left: resolvedLeft,
        right: resolvedRight,
        top: resolvedTop,
        bottom: resolvedBottom,
      ),
    );
  }

  // Margin convenience methods

  /// Sets the top margin.
  @Deprecated(
    'Use margin(.top(value)) instead. marginTop will be removed in Mix 3.0.',
  )
  T marginTop(double value) => margin(EdgeInsetsGeometryMix.top(value));

  /// Sets the bottom margin.
  @Deprecated(
    'Use margin(.bottom(value)) instead. marginBottom will be removed in Mix 3.0.',
  )
  T marginBottom(double value) => margin(EdgeInsetsGeometryMix.bottom(value));

  /// Sets the left margin.
  @Deprecated(
    'Use margin(.left(value)) instead. marginLeft will be removed in Mix 3.0.',
  )
  T marginLeft(double value) => margin(EdgeInsetsGeometryMix.left(value));

  /// Sets the right margin.
  @Deprecated(
    'Use margin(.right(value)) instead. marginRight will be removed in Mix 3.0.',
  )
  T marginRight(double value) => margin(EdgeInsetsGeometryMix.right(value));

  /// Sets horizontal (left and right) margin.
  @Deprecated(
    'Use margin(.horizontal(value)) instead. marginX will be removed in Mix 3.0.',
  )
  T marginX(double value) => margin(EdgeInsetsGeometryMix.horizontal(value));

  /// Sets vertical (top and bottom) margin.
  @Deprecated(
    'Use margin(.vertical(value)) instead. marginY will be removed in Mix 3.0.',
  )
  T marginY(double value) => margin(EdgeInsetsGeometryMix.vertical(value));

  /// Sets margin on all sides.
  @Deprecated(
    'Use margin(.all(value)) instead. marginAll will be removed in Mix 3.0.',
  )
  T marginAll(double value) => margin(EdgeInsetsGeometryMix.all(value));

  /// Sets the start (leading) margin.
  @Deprecated(
    'Use margin(.start(value)) instead. marginStart will be removed in Mix 3.0.',
  )
  T marginStart(double value) => margin(EdgeInsetsGeometryMix.start(value));

  /// Sets the end (trailing) margin.
  @Deprecated(
    'Use margin(.end(value)) instead. marginEnd will be removed in Mix 3.0.',
  )
  T marginEnd(double value) => margin(EdgeInsetsGeometryMix.end(value));

  /// Sets custom margin for each side with priority resolution.
  ///
  /// Each side falls back on its own: `left ?? horizontal`,
  /// `right ?? horizontal`, `top ?? vertical`, `bottom ?? vertical`.
  /// When [start] or [end] is set, start is `start ?? left ?? horizontal`
  /// and end is `end ?? right ?? horizontal`.
  ///
  /// Known values: `margin(.horizontal(h).left(l))` and
  /// `margin(.vertical(v).top(t))` put the broad setter first. Reversing
  /// either pair lets that setter overwrite the specific side.
  /// `margin(.start(s).end(e))` sets two peers; either order keeps both.
  ///
  /// `.only` and `.directional` take concrete sides. They do not apply
  /// horizontal or vertical fallback. Resolve each side, then pass it:
  ///
  /// ```dart
  /// margin(.only(
  ///   left: left ?? horizontal,
  ///   right: right ?? horizontal,
  ///   top: top ?? vertical,
  ///   bottom: bottom ?? vertical,
  /// ))
  /// ```
  ///
  /// When [start] or [end] is present:
  ///
  /// ```dart
  /// margin(.directional(
  ///   start: start ?? left ?? horizontal,
  ///   end: end ?? right ?? horizontal,
  ///   top: top ?? vertical,
  ///   bottom: bottom ?? vertical,
  /// ))
  /// ```
  @Deprecated(
    'Use margin(.horizontal(h).left(l)) with the broad setter first, or margin(.start(s).end(e)). For nullables, resolve each side (left ?? horizontal, right ?? horizontal, top ?? vertical, bottom ?? vertical) and pass those values to margin(.only(...)), or margin(.directional(...)) when start or end is set. marginOnly will be removed in Mix 3.0.',
  )
  T marginOnly({
    double? horizontal,
    double? vertical,
    double? start,
    double? end,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    // Priority resolution (most specific wins)
    final resolvedLeft = left ?? horizontal;
    final resolvedRight = right ?? horizontal;
    final resolvedTop = top ?? vertical;
    final resolvedBottom = bottom ?? vertical;

    // Use directional if start/end provided
    if (start != null || end != null) {
      return margin(
        EdgeInsetsGeometryMix.directional(
          start: start ?? resolvedLeft,
          end: end ?? resolvedRight,
          top: resolvedTop,
          bottom: resolvedBottom,
        ),
      );
    }

    // Otherwise use regular EdgeInsets
    return margin(
      EdgeInsetsGeometryMix.only(
        left: resolvedLeft,
        right: resolvedRight,
        top: resolvedTop,
        bottom: resolvedBottom,
      ),
    );
  }
}
