import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../attributes/enum/enum_util.dart';
import '../attributes/spacing/edge_insets_dto.dart';
import '../attributes/spacing/spacing_util.dart';
import '../core/attribute.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

final class ScrollViewModifierSpec extends ModifierSpec<ScrollViewModifierSpec>
    with Diagnosticable {
  final Axis? scrollDirection;
  final bool? reverse;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Clip? clipBehavior;

  const ScrollViewModifierSpec({
    this.scrollDirection,
    this.reverse,
    this.padding,
    this.physics,
    this.clipBehavior,
  });

  @override
  ScrollViewModifierSpec copyWith({
    Axis? scrollDirection,
    bool? reverse,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    Clip? clipBehavior,
  }) {
    return ScrollViewModifierSpec(
      scrollDirection: scrollDirection ?? this.scrollDirection,
      reverse: reverse ?? this.reverse,
      padding: padding ?? this.padding,
      physics: physics ?? this.physics,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  ScrollViewModifierSpec lerp(ScrollViewModifierSpec? other, double t) {
    if (other == null) return this;

    return ScrollViewModifierSpec(
      scrollDirection: t < 0.5 ? scrollDirection : other.scrollDirection,
      reverse: t < 0.5 ? reverse : other.reverse,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      physics: t < 0.5 ? physics : other.physics,
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty(
        'scrollDirection',
        scrollDirection,
        defaultValue: null,
      ),
    );
    properties.add(DiagnosticsProperty('reverse', reverse, defaultValue: null));
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty('physics', physics, defaultValue: null));
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  @override
  List<Object?> get props => [
    scrollDirection,
    reverse,
    padding,
    physics,
    clipBehavior,
  ];

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

final class ScrollViewModifierSpecUtility<T extends SpecUtility<Object?>>
    extends MixUtility<T, ScrollViewModifierSpecAttribute> {
  /// Make the scroll view reverse or not.
  late final reverse = BoolUtility((prop) => call(reverse: prop.getValue()));

  /// Set the padding of the scroll view.
  late final padding = EdgeInsetsGeometryUtility(
    (padding) => call(padding: padding),
  );

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
  }) => builder(
    ScrollViewModifierSpecAttribute(
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      physics: physics,
      clipBehavior: clipBehavior,
    ),
  );
}

class ScrollViewModifierSpecAttribute
    extends ModifierSpecAttribute<ScrollViewModifierSpec>
    with Diagnosticable {
  final Axis? scrollDirection;
  final bool? reverse;
  final EdgeInsetsGeometryDto? padding;
  final ScrollPhysics? physics;
  final Clip? clipBehavior;

  const ScrollViewModifierSpecAttribute({
    this.scrollDirection,
    this.reverse,
    this.padding,
    this.physics,
    this.clipBehavior,
  });

  @override
  ScrollViewModifierSpec resolve(BuildContext context) {
    return ScrollViewModifierSpec(
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding?.resolve(context),
      physics: physics,
      clipBehavior: clipBehavior,
    );
  }

  @override
  ScrollViewModifierSpecAttribute merge(
    ScrollViewModifierSpecAttribute? other,
  ) {
    if (other == null) return this;

    return ScrollViewModifierSpecAttribute(
      scrollDirection: other.scrollDirection ?? scrollDirection,
      reverse: other.reverse ?? reverse,
      padding: EdgeInsetsGeometryDto.tryToMerge(padding, other.padding),
      physics: other.physics ?? physics,
      clipBehavior: other.clipBehavior ?? clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty(
        'scrollDirection',
        scrollDirection,
        defaultValue: null,
      ),
    );
    properties.add(DiagnosticsProperty('reverse', reverse, defaultValue: null));
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty('physics', physics, defaultValue: null));
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  @override
  List<Object?> get props => [
    scrollDirection,
    reverse,
    padding,
    physics,
    clipBehavior,
  ];
}

