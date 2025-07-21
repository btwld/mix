import '../core/prop.dart';
import '../core/utility.dart';
import 'align_widget_modifier.dart';
import 'aspect_ratio_widget_modifier.dart';
import 'clip_widget_modifier.dart';
import 'default_text_style_widget_modifier.dart';
import 'flexible_widget_modifier.dart';
import 'fractionally_sized_box_widget_modifier.dart';
import 'intrinsic_widget_modifier.dart';
import 'mouse_cursor_modifier.dart';
import 'opacity_widget_modifier.dart';
import 'padding_widget_modifier.dart';
import 'rotated_box_widget_modifier.dart';
import 'scroll_view_widget_modifier.dart';
import 'sized_box_widget_modifier.dart';
import 'transform_widget_modifier.dart';
import 'visibility_widget_modifier.dart';

abstract class ModifierUtility<T extends SpecUtility<Object?>, Value>
    extends MixUtility<T, Value> {
  late final intrinsicWidth = IntrinsicWidthModifierSpecUtility(only);
  late final intrinsicHeight = IntrinsicHeightModifierSpecUtility(only);
  late final rotate = RotatedBoxModifierSpecUtility(only);
  late final opacity = OpacityModifierSpecUtility(only);
  late final clipPath = ClipPathModifierSpecUtility(only);
  late final clipRRect = ClipRRectModifierSpecUtility(only);
  late final clipOval = ClipOvalModifierSpecUtility(only);
  late final clipRect = ClipRectModifierSpecUtility(only);
  late final clipTriangle = ClipTriangleModifierSpecUtility(only);
  late final visibility = VisibilityModifierSpecUtility(only);
  late final show = visibility.on;
  late final hide = visibility.off;
  late final aspectRatio = AspectRatioModifierSpecUtility(only);
  late final flexible = FlexibleModifierSpecUtility(only);
  late final expanded = flexible.expanded;
  late final transform = TransformModifierSpecUtility(only);
  late final defaultTextStyle = DefaultTextStyleModifierSpecUtility(only);

  late final scale = transform.scale;
  late final align = AlignModifierSpecUtility(only);
  late final fractionallySizedBox = FractionallySizedBoxModifierSpecUtility(
    only,
  );

  late final padding = PaddingModifierSpecUtility(only);
  late final sizedBox = SizedBoxModifierSpecUtility(only);
  late final mouseCursor = MouseCursorModifierSpecUtility(only);

  const ModifierUtility(super.builder);

  T only();
}

/// Utility class for building [WithModifierUtility] instances.
final class WithModifierUtility<T extends SpecUtility<Object?>>
    extends SpecUtility<T, ModifierSpecAttribute>
    with ModifierUtility<T, T> {
  /// Creates a [WithModifierUtility] with the provided builder.
  WithModifierUtility(super.builder);

  /// Creates a static instance of [WithModifierUtility].
  static WithModifierUtility<ModifierSpecAttribute> get self =>
      WithModifierUtility((v) => v);

  @override
  T only() => builder(const ModifierSpecAttribute());
}
