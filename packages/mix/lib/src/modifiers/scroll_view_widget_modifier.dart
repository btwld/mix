import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../attributes/enum/enum_util.dart';
import '../attributes/spacing/edge_insets_dto.dart';
import '../attributes/spacing/spacing_util.dart';
import '../core/element.dart';
import '../core/factory/mix_data.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

part 'scroll_view_widget_modifier.g.dart';

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class ScrollViewModifierSpec
    extends WidgetModifierSpec<ScrollViewModifierSpec>
    with _$ScrollViewModifierSpec, Diagnosticable {
  final Axis? scrollDirection;
  final bool? reverse;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Clip? clipBehavior;

  ScrollViewModifierSpec({
    this.scrollDirection,
    this.reverse,
    this.padding,
    this.physics,
    this.clipBehavior,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  Widget build(Widget child) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection ?? Axis.vertical,
      reverse: reverse ?? false,
      padding: padding,
      physics: physics,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      child: child,
    );
  }
}

final class ScrollViewModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, ScrollViewModifierSpecAttribute> {
  /// Make the scroll view reverse or not.
  late final reverse = BoolUtility((reverse) => call(reverse: reverse));

  /// Set the padding of the scroll view.
  late final padding =
      EdgeInsetsGeometryUtility((padding) => call(padding: padding));

  /// Set the clip behavior of the scroll view.
  late final clipBehavior = ClipUtility((clip) => call(clipBehavior: clip));

  ScrollViewModifierSpecUtility(super.builder);

  /// Set the scroll direction of the scroll view.
  T direction(Axis axis) => call(scrollDirection: axis);

  /// Set the scroll direction of the scroll view to horizontal.
  T horizontal() => call(scrollDirection: Axis.horizontal);

  /// Set the scroll direction of the scroll view to vertical.
  T vertical() => call(scrollDirection: Axis.vertical);

  /// Set the physics of the scroll view.
  T physics(ScrollPhysics physics) => call(physics: physics);

  /// Disable the scroll physics of the scroll view.
  T neverScrollableScrollPhysics() =>
      physics(const NeverScrollableScrollPhysics());

  /// Set the iOS-style scroll physics of the scroll view.
  T bouncingScrollPhysics() => physics(const BouncingScrollPhysics());

  /// Set the Android-style scroll physics of the scroll view.
  T clampingScrollPhysics() => physics(const ClampingScrollPhysics());

  T call({
    Axis? scrollDirection,
    bool? reverse,
    EdgeInsetsGeometryDto? padding,
    ScrollPhysics? physics,
    Clip? clipBehavior,
  }) =>
      builder(
        ScrollViewModifierSpecAttribute(
          scrollDirection: scrollDirection,
          reverse: reverse,
          padding: padding,
          physics: physics,
          clipBehavior: clipBehavior,
        ),
      );
}
