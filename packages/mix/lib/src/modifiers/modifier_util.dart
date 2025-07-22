import '../core/style.dart';
import 'align_widget_modifier.dart';
import 'aspect_ratio_widget_modifier.dart';
import 'clip_widget_modifier.dart';
import 'flexible_widget_modifier.dart';
import 'fractionally_sized_box_widget_modifier.dart';
import 'intrinsic_widget_modifier.dart';
import 'opacity_widget_modifier.dart';
import 'padding_widget_modifier.dart';
import 'rotated_box_widget_modifier.dart';
import 'sized_box_widget_modifier.dart';
import 'transform_widget_modifier.dart';
import 'visibility_widget_modifier.dart';

/// Utility class that provides access to all widget modifier utilities.
///
/// This class combines all the individual modifier utilities into a single
/// convenient interface. It's used to create the global `$with` utility.
///
/// Example usage:
/// ```dart
/// Style(
///   $with.opacity(0.5),
///   $with.scale(1.2),
///   $with.rotate(45),
///   $with.visibility(true),
///   $with.aspectRatio(16/9),
/// )
/// ```
final class ModifierUtility<T extends SpecStyle<Object?>> {
  final T Function(ModifierAttribute) builder;

  /// Utility for opacity modifiers
  late final opacity = OpacityModifierUtility<T>((attr) => builder(attr));

  /// Utility for transform modifiers (scale, rotate, translate, etc.)
  late final transform = TransformModifierUtility<T>((attr) => builder(attr));

  /// Utility for visibility modifiers
  late final visibility = VisibilityModifierUtility<T>((attr) => builder(attr));

  /// Utility for aspect ratio modifiers
  late final aspectRatio = AspectRatioModifierUtility<T>(
    (attr) => builder(attr),
  );

  /// Utility for align modifiers
  late final align = AlignModifierUtility<T>((attr) => builder(attr));

  /// Utility for padding modifiers
  late final padding = PaddingModifierUtility<T>((attr) => builder(attr));

  /// Utility for sized box modifiers
  late final sizedBox = SizedBoxModifierUtility<T>((attr) => builder(attr));

  /// Utility for flexible modifiers
  late final flexible = FlexibleModifierUtility<T>((attr) => builder(attr));

  /// Utility for fractionally sized box modifiers
  late final fractionallySizedBox = FractionallySizedBoxModifierUtility<T>(
    (attr) => builder(attr),
  );

  /// Utility for rotated box modifiers
  late final rotatedBox = RotatedBoxModifierUtility<T>((attr) => builder(attr));

  /// Utility for intrinsic width modifiers
  late final intrinsicWidth = IntrinsicWidthModifierUtility<T>(
    (attr) => builder(attr),
  );

  /// Utility for intrinsic height modifiers
  late final intrinsicHeight = IntrinsicHeightModifierUtility<T>(
    (attr) => builder(attr),
  );

  /// Utility for clip oval modifiers
  late final clipOval = ClipOvalModifierUtility<T>((attr) => builder(attr));

  /// Utility for clip rounded rectangle modifiers
  late final clipRRect = ClipRRectModifierUtility<T>((attr) => builder(attr));

  /// Utility for clip rectangle modifiers
  late final clipRect = ClipRectModifierUtility<T>((attr) => builder(attr));

  /// Utility for clip triangle modifiers
  late final clipTriangle = ClipTriangleModifierUtility<T>(
    (attr) => builder(attr),
  );

  /// Utility for clip path modifiers
  late final clipPath = ClipPathModifierUtility<T>((attr) => builder(attr));

  ModifierUtility(this.builder);

  // Convenience methods for common modifiers

  /// Sets the opacity of the widget.
  ///
  /// The [value] should be between 0.0 (fully transparent) and 1.0 (fully opaque).
  T opacityValue(double value) => opacity(value);

  /// Scales the widget by the given [value].
  ///
  /// A value of 1.0 means no scaling, values greater than 1.0 make the widget larger,
  /// and values less than 1.0 make it smaller.
  T scale(double value) => transform.scale(value);

  /// Rotates the widget by the given [value] in radians.
  ///
  /// Positive values rotate clockwise, negative values rotate counter-clockwise.
  T rotate(double value) => transform.rotate(value);

  /// Controls the visibility of the widget.
  ///
  /// When [visible] is false, the widget is hidden but still takes up space.
  T visibilityValue(bool visible) => visibility(visible);

  /// Sets the aspect ratio of the widget.
  ///
  /// The [ratio] is width divided by height. For example, 16/9 for widescreen.
  T aspectRatioValue(double ratio) => aspectRatio(ratio);
}
