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
  late final intrinsicWidth = IntrinsicWidthModifierSpecUtility(builder);
  late final intrinsicHeight = IntrinsicHeightModifierSpecUtility(builder);
  late final rotate = RotatedBoxModifierSpecUtility(builder);
  late final opacity = OpacityModifierSpecUtility(builder);
  late final clipPath = ClipPathModifierSpecUtility(builder);
  late final clipRRect = ClipRRectModifierSpecUtility(builder);
  late final clipOval = ClipOvalModifierSpecUtility(builder);
  late final clipRect = ClipRectModifierSpecUtility(builder);
  late final clipTriangle = ClipTriangleModifierSpecUtility(builder);
  late final visibility = VisibilityModifierSpecUtility(builder);
  late final show = visibility.on;
  late final hide = visibility.off;
  late final aspectRatio = AspectRatioModifierSpecUtility(builder);
  late final flexible = FlexibleModifierSpecUtility(builder);
  late final expanded = flexible.expanded;
  late final transform = TransformModifierSpecUtility(builder);
  late final defaultTextStyle = DefaultTextStyleModifierSpecUtility(builder);

  late final scale = transform.scale;
  late final align = AlignModifierSpecUtility(builder);
  late final fractionallySizedBox = FractionallySizedBoxModifierSpecUtility(
    builder,
  );

  late final padding = PaddingModifierSpecUtility(builder);
  late final sizedBox = SizedBoxModifierSpecUtility(builder);
  late final mouseCursor = MouseCursorModifierSpecUtility(builder);

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
